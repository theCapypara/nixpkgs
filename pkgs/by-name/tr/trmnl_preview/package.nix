{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "trmnl_preview";

  gemdir = ./.;

  exes = [ "trmnlp" ];

  passthru.updateScript = bundlerUpdateScript "trmnl_preview";

  meta = {
    description = "A local dev server for building TRMNL plugins (trmnlp)";
    license = lib.licenses.mit;
    homepage = "https://github.com/usetrmnl/trmnlp";
    maintainers = with lib.maintainers; [ theCapypara ];
    mainProgram = "trmnlp";
  };
}
