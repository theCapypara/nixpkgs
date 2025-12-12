#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.requests
from argparse import ArgumentParser
from requests import get
from subprocess import run
import json

URL_UPDATE = "https://archive.org/wayback/available?url=https://downloads.marketplace.jetbrains.com/files/brokenPlugins.json"


def get_args() -> (str, list[str]):
    parser = ArgumentParser()
    parser.add_argument("json_path", help="File to output json to")
    args = parser.parse_args()
    return args.json_path


def get_hash(url):
    print(f"Downloading {url}")
    args = ["nix-prefetch-url", url, "--print-path"]
    if url.endswith(".zip"):
        args.append("--unpack")
    else:
        args.append("--executable")
    path_process = run(args, capture_output=True)
    path = path_process.stdout.decode().split("\n")[1]
    result = run(["nix", "--extra-experimental-features", "nix-command", "hash", "path", path], capture_output=True)
    result_contents = result.stdout.decode()[:-1]
    if not result_contents:
        raise RuntimeError(result.stderr.decode())
    return result_contents


def main():
    json_path = get_args()
    print("Fetching latest available brokenPlugins.json from archive.org")
    available = get(URL_UPDATE)
    available.raise_for_status()
    latest_url = available.json()["archived_snapshots"]["closest"]["url"]
    url_hash = get_hash(latest_url)
    with open(json_path, 'w') as f:
        json.dump({"url": latest_url, "hash": url_hash}, f)
    print("Done!")


if __name__ == '__main__':
    main()
