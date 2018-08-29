{ lib, stdenv, makeWrapper, glibcLocales, coreutils, perl, gnugrep, nodejs, seth, jays, token }:

stdenv.mkDerivation rec {
  name = "dai-${version}";
  version = "0.6.1";
  src = ./.;

  nativeBuildInputs = [makeWrapper];
  buildPhase = "true";
  makeFlags = ["prefix=$(out)"];
  postInstall = let path = lib.makeBinPath [
    coreutils perl gnugrep nodejs seth jays token
  ]; in ''
    wrapProgram "$out/bin/dai" --prefix PATH : "${path}" \
      ${if glibcLocales != null then
        "--set LOCALE_ARCHIVE \"${glibcLocales}\"/lib/locale/locale-archive"
        else ""}
  '';

  meta = {
    description = "Command-line tool for the Dai stablecoin system";
    homepage = https://github.com/makerdao/sai;
    license = lib.licenses.gpl3;
    inherit version;
  };
}
