#!/usr/bin/python3

# This is free software, licensed under the CC0 1.0 Universal.
# See /LICENSE for more information.

import re
import json
import requests as req
import sys
import os


def parse_ieee_file():
    vendors = {}

    with open(f"./oui.txt", "r") as f:
        ouitext = f.read()
        for line in ouitext.splitlines():
            match = re.match(r'^([0-9A-Fa-f]{6})\s+\(base 16\)\s+(.+)$', line)

            if match:
                oui = match.group(1).lower()
                mac_oui = "mac-oui-{}|1".format(oui)
                vendor = match.group(2).strip()

                if vendor not in vendors:
                    vendors[vendor] = []

                vendors[vendor].append(mac_oui)

    entry = {
        "vendor=%": vendors
    }

    with open(f"./modules/oui.json", "w") as f:
        json.dump(entry, f, indent=4)


def download_ieee_file():
    url = "https://standards-oui.ieee.org"

    headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/',
    }

    r = req.get(url, headers=headers)

    with open(f"./oui.txt", "w") as f:
        f.write(r.text)


if sys.argv[1] == "download":
    download_ieee_file()

if sys.argv[1] == "parse":
    parse_ieee_file()
