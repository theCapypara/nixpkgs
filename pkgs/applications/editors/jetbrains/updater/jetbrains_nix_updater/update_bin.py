from jetbrains_nix_updater.config import UpdaterConfig
from jetbrains_nix_updater.fetcher import VersionInfo
from jetbrains_nix_updater.ides import Ide
from jetbrains_nix_updater.util import replace_blocks


def run_bin_update(ide: Ide, info: VersionInfo, _config: UpdaterConfig):
    urls_nix = ""
    for system, url in info.urls.items():
        urls_nix += f"""
        {system} = {{
          url = "{url}";
          sha256 = "{info.download_sha256(system)}";
        }};"""

    try:
        replace_blocks(
            ide.drv_path,
            [
                (
                    "version",
                    f"""
                        version = "{info.version}";
                        buildNumber = "{info.build_number}";
                    """,
                ),
                (
                    "urls",
                    f"""
                        urls = {{{urls_nix}}};
                    """,
                ),
            ],
        )
    except Exception as e:
        print(f"[!] Writing update info to file failed: {e}")
