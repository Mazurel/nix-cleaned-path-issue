{ stdenv, version, lib, clean ? false
, hello-folder-src ? if clean then lib.cleanSource ./. else ./., ... }:
let testFile = hello-folder-src + /test.txt;
in stdenv.mkDerivation rec {
  src = hello-folder-src;
  inherit version;

  name = "hello-${version}";

  buildPhase = ''
    cat > ${name} <<EOF
    #! $SHELL
    echo '${builtins.readFile testFile}'
    EOF
    chmod +x ${name}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin/
  '';
}
