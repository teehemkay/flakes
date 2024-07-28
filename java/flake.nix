{
  description = "Java development standard devShell ";

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

        inherit (pkgs) stdenv lib mkShell;
        inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation CoreServices;

      in {
        devShells = {
          default = mkShell {
            packages = [
              pkgs.cljfmt
              pkgs.clj-kondo
              pkgs.clojure
              pkgs.clojure-lsp
              pkgs.gradle
              pkgs.jet
              pkgs.jdk
              pkgs.leiningen
              pkgs.maven
              pkgs.neil
            ] ++ lib.optionals stdenv.isDarwin [ CoreFoundation CoreServices ];
          };
        };
      });
}
