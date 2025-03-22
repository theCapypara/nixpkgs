{
  stdenv,
  lib,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  rustPlatform,
  rustc,
  pkg-config,
  glib,
  libshumate,
  gst_all_1,
  gtk4,
  libadwaita,
  pipewire,
  wayland,
  wrapGAppsHook4,
  desktop-file-utils,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ashpd-demo";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "bilelmoussaoui";
    repo = "ashpd";
    tag = finalAttrs.version;
    hash = "sha256-zWxkI5Cq+taIkJ27qsVMslcFr6EqfxstQm9YvvSj3so=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = "${finalAttrs.src}/ashpd-demo";
    hash = "sha256-eGFz3wWXXLhDesVU9yqj/fAX46RN6FxHFqhKwvr4C24=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    rustPlatform.bindgenHook
    desktop-file-utils
    glib # for glib-compile-schemas
  ];

  buildInputs = [
    glib
    gtk4
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libadwaita
    pipewire
    wayland
    libshumate
  ];

  postPatch = ''
    cd ashpd-demo
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Tool for playing with XDG desktop portals";
    mainProgram = "ashpd-demo";
    homepage = "https://github.com/bilelmoussaoui/ashpd/tree/master/ashpd-demo";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
})
