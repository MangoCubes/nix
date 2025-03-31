{ stdenvNoCC, lib }:
stdenvNoCC.mkDerivation {
  pname = "bank-gothic";
  version = "1.0";
  src = ./files/BankGothic;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp -r $src/*.{ttf,otf} $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "BankGothic fonts";
    # homepage = "https://www.yourfontwebsite.com/";
    platforms = platforms.all;
  };
}
