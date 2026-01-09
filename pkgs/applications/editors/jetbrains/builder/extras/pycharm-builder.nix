{
  stdenv,
  python3,
  lib,
  mkJetBrainsProduct,
}:
# Base builder for all PyCharm IDEs
lib.extendMkDerivation {
  constructDrv = mkJetBrainsProduct;

  extendDrvArgs =
    finalAttrs:
    {
      buildInputs ? [ ],
      preInstall ? "",
      ...
    }:
    lib.optionalAttrs stdenv.hostPlatform.isLinux {

      buildInputs = buildInputs ++ [
        python3
        python3.pkgs.setuptools
      ];

      # See https://www.jetbrains.com/help/pycharm/2025.3/cython-speedups.html
      preInstall = ''
        echo "compiling cython debug speedups"
        if [[ -d plugins/python-ce ]]; then
            ${python3.interpreter} plugins/python-ce/helpers/pydev/setup_cython.py build_ext --inplace
        else
            ${python3.interpreter} plugins/python/helpers/pydev/setup_cython.py build_ext --inplace
        fi
      ''
      + preInstall;
    };
}
