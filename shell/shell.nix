# https://nix.dev/anti-patterns/

{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) stdenv lib darwin mkShell nodePackages;
  inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices;

in mkShell {
  packages = [
    nodePackages.pnpm
    nodePackages.typescript-language-server
    pkgs.cljfmt
    pkgs.clj-kondo
    pkgs.clojure
    pkgs.clojure-lsp
    pkgs.html-tidy
    pkgs.hy
    pkgs.jdk
    pkgs.leiningen
    pkgs.marksman
    pkgs.neil
    pkgs.nodejs
    pkgs.python3
    pkgs.python3Packages.pip
    pkgs.typescript
    pkgs.vscode-langservers-extracted
  ] ++ lib.optionals stdenv.isDarwin [ CoreFoundation CoreServices ];
}
