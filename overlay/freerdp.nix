final: prev: {
  freerdp = prev.freerdp.overrideAttrs (_: {
    version = "unstable-2025-06-28";
    src = prev.fetchFromGitHub {
      owner  = "FreeRDP";
      repo   = "FreeRDP";
      rev    = "b1f0b2b00f4e90ce1d2bc8fb33ae15bfd1ac4e23";
      hash   = "sha256:1q2zgcw22hx2yri62nlg6hapg2w14i1kb1g7ih1cigfr9bw796xd";
    };
    cmakeFlags = [
      "-DWITH_WAYLAND=ON"
      "-DWITH_SDL3=ON"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_FULL_LIBDIR=${placeholder "out"}/lib"
    ];

    
  });
}
