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
  gsettings-desktop-schemas,
  gtk4,
  libadwaita,
  libvirt,
  gst_all_1,
  desktop-file-utils,
  appstream,
  appstream-glib,
  wrapGAppsHook4,
  xdg-desktop-portal,
  blueprint-compiler,
  libxml2,
  spice-protocol,
  spice-gtk,
  vte-gtk4,
  gtk-vnc,
  usbredir,
  libepoxy,
  libGL,
  openssl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "field-monitor";
  version = "49.0";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "theCapypara";
    repo = "field-monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hKxYwYcUClBfHhi4sfNCZBVADXPRKQxHUHZS6l7BV+A=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-sd+yQLEqMnNNEYofPCd8wXJeNh0TYBS/E9FzrzfGEsk=";
  };

  mesonBuildType = "release";

  postInstall = ''
    wrapProgram $out/bin/de.capypara.FieldMonitor --prefix PATH ':' "$out/libexec"
  '';

  nativeBuildInputs = [
    appstream
    appstream-glib
    blueprint-compiler
    cargo
    desktop-file-utils
    libxml2
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk-vnc
    gtk4
    libadwaita
    libepoxy
    libGL
    libvirt
    openssl
    spice-gtk
    spice-protocol
    usbredir
    vte-gtk4
    xdg-desktop-portal
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ]);

  meta = {
    description = "Viewer for virtual machines and other external screens";
    homepage = "https://github.com/theCapypara/field-monitor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theCapypara ];
    platforms = lib.platforms.linux;
    mainProgram = "de.capypara.FieldMonitor";
  };
})
