{
  lib,
  makeSetupHook,
  writeScript,
  stdenv,
}:
makeSetupHook
  {
    name = "jetbrains-patch-shared-libs";
    meta.platforms = lib.platforms.linux;
  }
  (
    writeScript "jetbrains-patch-shared-libs.sh" ''
      #!@shell@

      _hook() {
        ls -d \
          $out/*/bin/*/linux/*/lib/liblldb.so \
          $out/*/bin/*/linux/*/lib/python*/lib-dynload/* \
          $out/*/plugins/*/bin/*/linux/*/lib/liblldb.so \
          $out/*/plugins/*/bin/*/linux/*/lib/python*/lib-dynload/* |
        xargs patchelf \
          --replace-needed libssl.so.10 libssl.so \
          --replace-needed libssl.so.1.1 libssl.so \
          --replace-needed libcrypto.so.10 libcrypto.so \
          --replace-needed libcrypto.so.1.1 libcrypto.so \
          --replace-needed libcrypt.so.1 libcrypt.so \
          ${lib.optionalString stdenv.hostPlatform.isAarch "--replace-needed libxml2.so.2 libxml2.so"}
      }

      preFixupHooks+=(_hook)
    ''
  )
