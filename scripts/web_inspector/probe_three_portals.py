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

load_dotenv(".env")

PORTALS = [
    {
        "key": "ADM_EDUCA",
        "login_url": f"{os.getenv('EDUCA_BASE_URL', 'https://cmds.pad.cl:2443').rstrip('/')}/login/",
        "user": os.getenv("EDUCA_USER", "10633447"),
        "pass": os.getenv("EDUCA_PASS", "2114")
    },
    {
        "key": "ADM_RHU",
        "login_url": f"{os.getenv('RHU_BASE_URL', 'https://cmds.pad.cl:3443/cmds_rhu_prod').rstrip('/')}/login/",
        "user": os.getenv("RHU_USER", "10633447"),
        "pass": os.getenv("RHU_PASS", "7888")
    },
    {
        "key": "ADM_PORTALDIR",
        "login_url": f"{os.getenv('PORTALDIR_BASE_URL', 'https://cmds-portal-director.pad.cl:2443').rstrip('/')}/login/",
        "user": os.getenv("PORTALDIR_USER", "10633447"),
        "pass": os.getenv("PORTALDIR_PASS", "7888")
    }
]

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

def probe_portal(p):
    key = p["key"]
    login_url = p["login_url"]
    print(f"\n==========================================")
    print(f"PROBING {key} -> {login_url}")
    print(f"==========================================")
    opener = create_opener()
    try:
        resp = opener.open(login_url, timeout=20)
        html = resp.read().decode("utf-8", errors="replace")
        final_login_url = resp.geturl()
        soup = BeautifulSoup(html, "html.parser")
        print("Login Title:", soup.title.string.strip() if (soup.title and soup.title.string) else "None")

        # Inspect F1 inputs and Sajax signature
        f1 = soup.find("form", {"name": "F1"})
        if not f1:
            print("No form F1 found! Forms:", [f.get("name") for f in soup.find_all("form")])
            return

        inputs = {inp.get("name"): inp.get("value", "") for inp in f1.find_all("input") if inp.get("name")}
        print("F1 inputs:", list(inputs.keys()))

        # Find x_ajax_*_submit_form in HTML
        m_fn = re.search(r'function\s+do_ajax_([a-zA-Z0-9_]+)_submit_form\(\)\s*\{(.*?)\}', html, re.S)
        ajax_fn_name = f"ajax_{m_fn.group(1)}_submit_form" if m_fn else "ajax_login_submit_form"
        print("AJAX function:", ajax_fn_name)
        if m_fn:
            body = m_fn.group(2)
            m_call = re.search(r'x_ajax_[a-zA-Z0-9_]+_submit_form\((.*?)\);', body, re.S)
            if m_call:
                print("AJAX call args:", m_call.group(1).strip())

        rsargs = [
            p["user"], p["pass"],
            inputs.get("nm_form_submit", "1"),
            inputs.get("nmgp_url_saida", ""),
            "alterar",
            inputs.get("nmgp_ancora", ""),
            inputs.get("nmgp_num_form", ""),
            inputs.get("nmgp_parms", ""),
            inputs.get("script_case_init", ""),
            inputs.get("csrf_token", ""),
            inputs.get("bok", "OK")
        ]
        post_params = [("rs", ajax_fn_name), ("rst", ""), ("rsrnd", str(int(time.time() * 1000)))]
        for arg in rsargs:
            post_params.append(("rsargs[]", arg))

        req2 = urllib.request.Request(final_login_url, data=urllib.parse.urlencode(post_params).encode("utf-8"), headers={"Referer": final_login_url})
        resp2 = opener.open(req2, timeout=20)
        raw = resp2.read().decode("utf-8", errors="replace")
        print("Sajax response snippet:", raw[:600])

        # Extract redirInfo from Sajax response
        m_json = re.search(r"var res = '(.*)'; res;", raw, re.S)
        if m_json:
            json_str = m_json.group(1).replace('\\"', '"').replace("\\/", "/").replace("\\'", "'")
            try:
                data_obj = json.loads(json_str)
            except Exception:
                # Fallback regex for action and script_case_init
                data_obj = {}
            redir = data_obj.get("redirInfo", {})
            action = redir.get("action")
            if not action:
                m_act = re.search(r'"action":"([^"]+)"', json_str)
                if m_act:
                    action = m_act.group(1)
            print("Redirect action:", action, "redirInfo:", redir)
            if action:
                menu_url = urllib.parse.urljoin(final_login_url, action)
                menu_post = urllib.parse.urlencode({
                    "nmgp_parms": redir.get("nmgp_parms", ""),
                    "nmgp_url_saida": redir.get("nmgp_url_saida", ""),
                    "script_case_init": redir.get("script_case_init", "1")
                }).encode("utf-8")
                req_menu = urllib.request.Request(menu_url, data=menu_post, headers={"Referer": final_login_url})
                resp_menu = opener.open(req_menu, timeout=20)
                menu_html = resp_menu.read().decode("utf-8", errors="replace")
                soup_menu = BeautifulSoup(menu_html, "html.parser")
                print("Menu URL:", resp_menu.geturl(), "Title:", soup_menu.title.string.strip() if (soup_menu.title and soup_menu.title.string) else "None", "Len:", len(menu_html))
                with open(f"data/menu_{key.lower()}.html", "w", encoding="utf-8") as mf:
                    mf.write(menu_html)

                # Print menu items
                for a in soup_menu.find_all("a"):
                    txt = a.get_text(strip=True)
                    href = a.get("item-href") or a.get("href") or a.get("onclick") or ""
                    if txt or "sc_apl_menu=" in href:
                        print(f"  Menu [{a.get('id')}]: {txt} -> {href[:120]}")
    except Exception as e:
        print(f"Error probing {key}: {e}")

if __name__ == "__main__":
    os.makedirs("data", exist_ok=True)
    for p in PORTALS:
        probe_portal(p)
