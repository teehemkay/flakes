{
  description = "Clojure(Scrit) / Babashka standard devShell ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default-darwin";
    flake-utils.url = "github:numtide/flake-utils";
    clojure-lsp.url = "github:clojure-lsp/clojure-lsp";

    # Override flake-utils systems to mine
    flake-utils.inputs.systems.follows = "systems";
  };

  outputs = { nixpkgs, systems, flake-utils, clojure-lsp, ... }:
    flake-utils.lib.eachSystem (import systems) (system:
      let
        overlays = [ clojure-lsp.overlays.default ];
        pkgs = import nixpkgs { inherit system overlays; };

        inherit (pkgs) stdenv lib mkShell nodePackages;
        inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation CoreServices;

      in {
        devShells = {
          default = mkShell {
            packages = [
              nodePackages.pnpm
              nodePackages.typescript-language-server
              pkgs.cljfmt
              pkgs.clj-kondo
              pkgs.clojure
              pkgs.clojure-lsp
              pkgs.html-tidy
              pkgs.jet
              pkgs.jdk
              pkgs.leiningen
              pkgs.marksman
              pkgs.neil
              pkgs.nodejs
              pkgs.typescript
              pkgs.vscode-langservers-extracted
            ] ++ lib.optionals stdenv.isDarwin [ CoreFoundation CoreServices ];
          };
        };
      });
}
