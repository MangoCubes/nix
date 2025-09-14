{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  lib,
  glib,
  pango,
  libxkbcommon,
}:

rustPlatform.buildRustPackage {
  pname = "podman-watcher";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "MangoCubes";
    repo = "podman-watcher";
    rev = "master";
    hash = "sha256-plH2JaZE6Lo4x6QllEd6BeNsaqXwzyNmqwKk5PP4LXQ=";
  };

  cargoHash = "sha256-xA3Q65TwBqLhLLEhiIe/+W0fwM8TCxzIE9WJvK4vNXY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    pango
    libxkbcommon
  ];

  meta = with lib; {
    description = "Shows service info in a table";
    homepage = "https://github.com/MangoCubes/podman-watcher";
    platforms = platforms.linux;
    mainProgram = "podman-watcher";
  };
}
