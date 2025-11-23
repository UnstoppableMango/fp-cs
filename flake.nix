{
  description = "Fun and profit";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      imports = [ inputs.treefmt-nix.flakeModule ];
      perSystem =
        { pkgs, lib, ... }:
        let
          fp-cs = pkgs.buildDotnetModule {
            pname = "UnMango.Fp";
            version = "0.0.1";
            dotnet-sdk = pkgs.dotnetCorePackages.sdk_10_0;
            src = lib.cleanSource ./.;
            nugetDeps = ./src/UnMango.Fp/nix-deps.json;
            projectFile = "Fp.slnx";
            packNupkg = true;
            meta = with lib; {
              homepage = "https://github.com/UnstoppableMango/fp-cs";
              description = "A functional programming library for C#";
              license = licenses.mit;
              maintainers = with maintainers; [ UnstoppableMango ];
            };
          };
        in
        {
          packages.fp-cs = fp-cs;
          packages.default = fp-cs;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              gnumake
              nixd
              nixfmt-rfc-style
              dotnetCorePackages.sdk_10_0
            ];
          };

          treefmt = {
            programs.nixfmt.enable = true;
          };
        };
    };
}
