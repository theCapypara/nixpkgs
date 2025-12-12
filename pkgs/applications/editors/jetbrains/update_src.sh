#!/usr/bin/env bash
if [ -z "$1" ]; then
  echo >&2 'Update script requires pname to update'
  exit 1
fi
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"
set -ex

./source/update.py --ides="$1" ./source/ides.json ./bin/versions.json
if [ "$1" = "idea-community" ]; then
  nix --extra-experimental-features nix-command build .#jetbrains.idea-community-src.src.src
  ./source/build_maven.py source/idea_maven_artefacts.json result/
elif [ "$1" = "pycharm-community" ]; then
  nix --extra-experimental-features nix-command build .#jetbrains.pycharm-community-src.src.src
  ./source/build_maven.py source/pycharm_maven_artefacts.json result/
fi
rm result
./source/update_broken_plugins.py source/broken_plugins.json
