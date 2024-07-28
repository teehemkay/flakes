{

  description = "tmk's standard development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default-darwin";
    flake-utils.url = "github:numtide/flake-utils";

    # Override flake-utils systems to mine
    flake-utils.inputs.systems.follows = "systems";
  };

  outputs = { self, nixpkgs, systems, flake-utils, ... }:
    let
      eachSystem = f:
        flake-utils.lib.eachSystem (import systems)
        (system: f nixpkgs.legacyPackages.${system});

    in eachSystem (pkgs:
      let
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
