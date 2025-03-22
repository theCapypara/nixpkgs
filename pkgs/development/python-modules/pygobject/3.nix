{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  buildPythonPackage,
  pkg-config,
  glib,
  gobject-introspection,
  pycairo,
  cairo,
  ncurses,
  meson,
  ninja,
  pythonOlder,
  gnome,
  python,
}:

buildPythonPackage rec {
  pname = "pygobject";
  version = "3.52.2";

  outputs = [
    "out"
    "dev"
  ];

  disabled = pythonOlder "3.9";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/${lib.versions.majorMinor version}/pygobject-${version}.tar.gz";
    hash = "sha256-hp9C7nDc9t5QvOJnBy4sNc7n/NLjLqGvOjqZqIkBhQo=";
  };

  patches = [ 
    # Fix get_value error breaking gst-python
    # https://gitlab.freedesktop.org/gstreamer/gstreamer/-/issues/4301
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/pygobject/-/commit/cf88f6ecdd8d3510658cd38f8e8c7a8385f0a478.patch";
      hash = "sha256-tjqgONiOBW+DtLecmZu3+p3XsXKOGnMeuNgdx/9aHBo=";
    })
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gobject-introspection
  ];

  buildInputs = [
    cairo
    glib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ ncurses ];

  propagatedBuildInputs = [
    pycairo
    gobject-introspection # e.g. try building: python3Packages.urwid python3Packages.pydbus
  ];

  mesonFlags = [
    # This is only used for figuring out what version of Python is in
    # use, and related stuff like figuring out what the install prefix
    # should be, but it does need to be able to execute Python code.
    "-Dpython=${python.pythonOnBuildForHost.interpreter}"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "python3.pkgs.pygobject3";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://pygobject.readthedocs.io/";
    description = "Python bindings for Glib";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
