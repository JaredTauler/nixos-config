final: prev: {
  freerdp = prev.freerdp.overrideAttrs (_: {
    version = "3.16.0";
    src = prev.fetchFromGitHub {
      owner  = "FreeRDP";
      repo   = "FreeRDP";
      rev    = "fcdf4c65f79b2ab3b9d2af7d9a9fa25b7d5f824d";
      hash   = "sha256:385af54245560493698730b688b5e6e5d56d5c7ecf2fa7c1d7cedfde8a4ba456";
    };
    cmakeFlags = [ "-DWITH_SDL3=ON" ];
  });
}
