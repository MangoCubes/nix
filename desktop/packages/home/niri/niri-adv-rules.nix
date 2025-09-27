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
  pname = "niri-adv-rules";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "MangoCubes";
    repo = "niri-adv-rules";
    rev = "master";
    hash = "sha256-O7JFswMjFD1exImzCxZfQqta94QCbgbK7NLpDn1Ar4s=";
  };

  cargoHash = "sha256-DamExzRMEFn9C5OfF1k6PCZZMorIQAAYr/b4wy0MOOI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    pango
    libxkbcommon
  ];

  meta = with lib; {
    description = "niri-adv-rules";
    homepage = "https://github.com/MangoCubes/niri-adv-rules";
    platforms = platforms.linux;
    mainProgram = "niri-adv-rules";
  };
}
