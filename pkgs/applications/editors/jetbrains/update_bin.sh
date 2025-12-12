#!/usr/bin/env bash
if [ -z "$1" ]; then
  echo >&2 'Update script requires pname to update'
  exit 1
fi
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"
set -ex

./bin/update_bin.py --no-commit --no-plugin-updates --throw $1
