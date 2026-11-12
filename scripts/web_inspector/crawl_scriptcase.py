import os
import re
import ssl
import json
import time
import urllib.request
import urllib.parse
import http.cookiejar
from bs4 import BeautifulSoup
from dotenv import load_dotenv

load_dotenv()

SC_BASE_URL = os.getenv("SC_BASE_URL", "https://cmds.pad.cl:3443/cmds_adm_prod").rstrip("/")
SC_USER = os.getenv("SC_USER", "10633447")
SC_PASS = os.getenv("SC_PASS", "7888")

TARGET_MODULES = {
    "2": "Boleta Honorarios",
    "3": "Oficina Partes",
    "1210": "Orden de Servicio",
    "4": "Servicios (Relacionado)",
    "5": "Mantenedor",
    "10": "Mantenimiento de Obras",
    "81": "Hoja de Ruta",
    "441": "Agenda de Atención",
    "804": "RRHH APS",
    "890": "Evidencia",
    "1371": "Mercado Público"
}

def create_opener():
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    cj = http.cookiejar.CookieJar()
    opener = urllib.request.build_opener(
        urllib.request.HTTPCookieProcessor(cj),
        urllib.request.HTTPSHandler(context=ctx)
    )
    opener.addheaders = [('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0')]
    return opener

def login_and_get_menu(opener):
    login_url = f"{SC_BASE_URL}/login/"
    resp = opener.open(login_url, timeout=20)
    html = resp.read().decode('utf-8', errors='replace')
    soup = BeautifulSoup(html, 'html.parser')

    f1 = soup.find('form', {'name': 'F1'})
    inputs = {inp.get('name'): inp.get('value', '') for inp in f1.find_all('input') if inp.get('name')}

    rsargs = [
        SC_USER, SC_PASS,
        inputs.get('nm_form_submit', '1'), inputs.get('nmgp_url_saida', ''),
        'alterar', inputs.get('nmgp_ancora', ''), inputs.get('nmgp_num_form', ''),
        inputs.get('nmgp_parms', ''), inputs.get('script_case_init', ''),
        inputs.get('csrf_token', ''), inputs.get('bok', 'OK')
    ]
    post_params = [('rs', 'ajax_login_submit_form'), ('rst', ''), ('rsrnd', str(int(time.time() * 1000)))]
    for arg in rsargs:
        post_params.append(('rsargs[]', arg))

    req = urllib.request.Request(login_url, data=urllib.parse.urlencode(post_params).encode('utf-8'), headers={'Referer': login_url})
    opener.open(req, timeout=20)

    menu_url = f"{SC_BASE_URL}/menu/"
    menu_post = urllib.parse.urlencode({
        'nmgp_parms': '',
        'nmgp_url_saida': '/cmds_adm_prod/login/',
        'script_case_init': '45'
    }).encode('utf-8')
    resp_menu = opener.open(urllib.request.Request(menu_url, data=menu_post, headers={'Referer': login_url}), timeout=20)
    return resp_menu.read().decode('utf-8', errors='replace'), menu_url

def parse_menu_tree(menu_html):
    soup = BeautifulSoup(menu_html, 'html.parser')
    main_ul = soup.find('ul', {'id': 'css3menu1'})
    if not main_ul:
        return []

    def walk(ul):
        nodes = []
        for li in ul.find_all('li', recursive=False):
            a = li.find('a', recursive=False)
            if not a:
                continue
            raw_id = a.get('id', '').replace('item_', '')
            label = a.get_text(strip=True)
            href = a.get('item-href') or a.get('href') or ''
            app = ''
            if 'sc_apl_menu=' in href:
                app = href.split('sc_apl_menu=')[1].split('&')[0]
            sub = li.find('ul', recursive=False)
            children = walk(sub) if sub else []
            nodes.append({
                'id': raw_id,
                'label': label,
                'app': app,
                'href': href,
                'children': children
            })
        return nodes

    return walk(main_ul)

def parse_app_html(html, url, app_name):
    soup = BeautifulSoup(html, 'html.parser')
    title = soup.title.string.strip() if (soup.title and soup.title.string) else ""

    # Detect Oracle table reference in title or HTML (e.g. ADM_OBS.TABLE_NAME)
    oracle_refs = sorted(set(re.findall(r'\b(?:ADM_OBS|CMDS|PAD|[A-Z0-9_]+)\.[A-Z0-9_]{3,}\b', html)))
    # Filter out common JS object properties
    oracle_tables = [
        ref for ref in oracle_refs
        if ref.startswith(('ADM_OBS.', 'CMDS', 'BHO_', 'OFI_', 'ODS_', 'MNT_', 'HDR_', 'APS_', 'MP_'))
        or 'ADM_OBS.' in ref
    ]
    if title and '.' in title:
        for tok in re.findall(r'[A-Z_][A-Z0-9_]*\.[A-Z_][A-Z0-9_]*', title.upper()):
            if tok not in oracle_tables:
                oracle_tables.append(tok)

    # Extract labels & fields
    fields = []
    seen_fields = set()

    # 1. Scriptcase Form / Control / Search inputs (id_sc_field_*)
    for inp in soup.find_all(['input', 'select', 'textarea']):
        inp_id = inp.get('id', '')
        inp_name = inp.get('name', '')
        inp_type = inp.get('type', inp.name)
        if inp_type == 'hidden' and not inp_id.startswith('id_sc_field_'):
            continue
        if inp_name in ('nm_form_submit', 'nmgp_idioma_novo', 'nmgp_schema_f', 'nmgp_url_saida', 'bok',
                        'nmgp_opcao', 'nmgp_ancora', 'nmgp_num_form', 'nmgp_parms', 'script_case_init',
                        'NM_cancel_return_new', 'csrf_token', 'nmgp_ordem', 'nmgp_clone', 'sc_ifr_height',
                        'master_nav', 'nmgp_arg_dyn_search', 'SC_lig_apl_orig', 'nmgp_outra_jan'):
            continue

        field_key = inp_id or inp_name
        if not field_key or field_key in seen_fields:
            continue
        seen_fields.add(field_key)

        clean_col = inp_id.replace('id_sc_field_', '') if inp_id.startswith('id_sc_field_') else inp_name
        # Find label
        label_text = ""
        lbl_span = soup.find(id=f"id_label_{clean_col}")
        if lbl_span:
            label_text = lbl_span.get_text(" ", strip=True)
        else:
            parent_td = inp.find_parent('td')
            if parent_td:
                prev_td = parent_td.find_previous_sibling('td')
                if prev_td:
                    label_text = prev_td.get_text(" ", strip=True)

        options = []
        if inp.name == 'select':
            for opt in inp.find_all('option')[:15]:
                val = opt.get('value', '')
                txt = opt.get_text(" ", strip=True)
                if txt or val:
                    options.append(f"{val}: {txt}")

        fields.append({
            "column": clean_col,
            "name": inp_name,
            "id": inp_id,
            "type": inp_type,
            "label": label_text[:120],
            "options_sample": options
        })

    # 2. Grid column headers
    grid_columns = []
    for th in soup.find_all(['th', 'td'], class_=lambda c: c and ('scGridLabel' in c or 'scFormLabel' in c)):
        txt = th.get_text(" ", strip=True)
        if txt and txt not in grid_columns and len(txt) < 100:
            grid_columns.append(txt)

    # 3. Action buttons and toolbar links
    buttons = []
    for btn in soup.find_all(['a', 'input', 'button', 'span'], class_=lambda c: c and ('scButton' in c or 'btn' in c)):
        btxt = btn.get_text(" ", strip=True) or btn.get('value', '') or btn.get('title', '')
        btxt = btxt.strip()
        if btxt and btxt not in buttons and len(btxt) < 60:
            buttons.append(btxt)

    # 4. Iframes (dashboards, master-detail, search sub-frames)
    iframes = []
    for ifr in soup.find_all('iframe'):
        src = ifr.get('src', '')
        ifr_name = ifr.get('name', '') or ifr.get('id', '')
        if src or ifr_name:
            iframes.append({"name": ifr_name, "src": src})

    # 5. Linked Scriptcase applications referenced in HTML/JS (/cmds_adm_prod/<app>/)
    linked_apps = sorted(set(
        m for m in re.findall(r'/cmds_adm_prod/([a-zA-Z0-9_]+)/', html)
        if m not in ('login', 'menu', '_lib', 'devel', 'third', app_name)
    ))

    # Classify application type
    app_type = "unknown"
    if "dashboard" in app_name or any("under_dashboard=1" in i["src"] for i in iframes):
        app_type = "dashboard"
    elif app_name.endswith(("_grid", "_gird")) or app_name.startswith("grid_") or "scGridTabela" in html:
        app_type = "grid"
    elif app_name.endswith("_form") or app_name.startswith("form_"):
        app_type = "form"
    elif app_name.endswith(("_ctrl", "_control")) or app_name.startswith("control_"):
        app_type = "control"
    elif app_name.endswith("_blank") or app_name.startswith("blank_"):
        app_type = "blank"

    return {
        "app_name": app_name,
        "app_type": app_type,
        "url": url,
        "title": title,
        "oracle_tables_exposed": oracle_tables,
        "grid_or_section_labels": grid_columns,
        "fields": fields,
        "buttons": buttons,
        "iframes": iframes,
        "linked_apps": linked_apps
    }

def inspect_app_url(opener, app_name, entry_url, referer, inspected_apps, depth=0):
    if app_name in inspected_apps or depth > 2:
        return inspected_apps.get(app_name)

    print(f"{'  ' * depth}Inspeccionando [{app_name}] -> {entry_url}")
    try:
        req = urllib.request.Request(entry_url, headers={'Referer': referer})
        resp = opener.open(req, timeout=20)
        html = resp.read().decode('utf-8', errors='replace')
        final_url = resp.geturl()

        # Check if this is menu_form_php.php bridge page with auto-submit form
        soup = BeautifulSoup(html, 'html.parser')
        form = soup.find('form')
        if len(html) < 3500 and form and form.get('action') and ('menu_form_php' in entry_url or 'nmgp_url_saida' in html):
            target_url = urllib.parse.urljoin(entry_url, form.get('action'))
            f_inputs = {inp.get('name'): inp.get('value', '') for inp in form.find_all('input') if inp.get('name')}
            req2 = urllib.request.Request(
                target_url,
                data=urllib.parse.urlencode(f_inputs).encode('utf-8'),
                headers={'Referer': entry_url}
            )
            resp2 = opener.open(req2, timeout=20)
            html = resp2.read().decode('utf-8', errors='replace')
            final_url = resp2.geturl()

        info = parse_app_html(html, final_url, app_name)

        # If this is a grid that opened a search iframe (index.php?nmgp_opcao=pesq), also inspect the search iframe AND grid body
        for ifr in list(info["iframes"]):
            src = ifr.get("src", "")
            if not src:
                continue
            ifr_url = urllib.parse.urljoin(final_url, src)
            if "nmgp_opcao=pesq" in src:
                try:
                    r_pesq = opener.open(urllib.request.Request(ifr_url, headers={'Referer': final_url}), timeout=15)
                    h_pesq = r_pesq.read().decode('utf-8', errors='replace')
                    pesq_info = parse_app_html(h_pesq, ifr_url, f"{app_name}__pesq")
                    # Merge search fields and labels
                    existing_cols = {f["column"] for f in info["fields"]}
                    for f in pesq_info["fields"]:
                        if f["column"] not in existing_cols:
                            info["fields"].append(f)
                    for lbl in pesq_info["grid_or_section_labels"]:
                        if lbl not in info["grid_or_section_labels"]:
                            info["grid_or_section_labels"].append(lbl)
                    for tbl in pesq_info["oracle_tables_exposed"]:
                        if tbl not in info["oracle_tables_exposed"]:
                            info["oracle_tables_exposed"].append(tbl)
                    for lnk in pesq_info["linked_apps"]:
                        if lnk not in info["linked_apps"]:
                            info["linked_apps"].append(lnk)
                except Exception as e:
                    print(f"    Aviso leyendo iframe pesq de {app_name}: {e}")

        inspected_apps[app_name] = info

        # If it's a dashboard or has child applications in iframes, inspect those child apps too!
        for ifr in info["iframes"]:
            src = ifr.get("src", "")
            m = re.search(r'/cmds_adm_prod/([a-zA-Z0-9_]+)/', src)
            if m:
                child_app = m.group(1)
                if child_app not in ('login', 'menu', '_lib', app_name) and child_app not in inspected_apps:
                    child_url = urllib.parse.urljoin(final_url, src)
                    inspect_app_url(opener, child_app, child_url, final_url, inspected_apps, depth + 1)

        # Also inspect directly linked apps (depth <= 1) via GET/POST read-only
        if depth < 2:
            for linked_app in info["linked_apps"]:
                if linked_app not in inspected_apps:
                    linked_url = f"{SC_BASE_URL}/{linked_app}/"
                    inspect_app_url(opener, linked_app, linked_url, final_url, inspected_apps, depth + 1)

        return info
    except Exception as e:
        print(f"Error inspeccionando {app_name}: {e}")
        err_info = {"app_name": app_name, "url": entry_url, "error": str(e)}
        inspected_apps[app_name] = err_info
        return err_info

def main():
    os.makedirs("data", exist_ok=True)
    opener = create_opener()
    menu_html, menu_url = login_and_get_menu(opener)
    tree = parse_menu_tree(menu_html)

    inspected_apps = {}
    modules_report = []

    def process_node(node, module_name):
        app = node.get("app")
        href = node.get("href")
        if app and href and not href.startswith("?script_case_init"):
            full_href = urllib.parse.urljoin(menu_url, href)
            inspect_app_url(opener, app, full_href, menu_url, inspected_apps, depth=1)
        for child in node.get("children", []):
            process_node(child, module_name)

    for top_node in tree:
        nid = top_node.get("id")
        if nid in TARGET_MODULES:
            mod_name = TARGET_MODULES[nid]
            print(f"\n=== MODULO [{nid}]: {mod_name} ===")
            process_node(top_node, mod_name)
            modules_report.append({
                "id": nid,
                "name": mod_name,
                "menu_tree": top_node
            })

    output = {
        "portal_url": SC_BASE_URL,
        "total_modules_selected": len(modules_report),
        "total_unique_apps_inspected": len(inspected_apps),
        "modules": modules_report,
        "applications": inspected_apps
    }

    with open("data/web_inventory.json", "w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False, indent=2)

    print(f"\nLevantamiento web finalizado: {len(modules_report)} modulos, {len(inspected_apps)} aplicaciones unicas inspeccionadas.")

if __name__ == "__main__":
    main()
