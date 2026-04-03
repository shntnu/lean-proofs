{
  description = "Formal Lean 4 proofs of mathematical claims";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in {
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            elan  # Lean version manager — reads lean-toolchain
            git   # needed by lake for fetching dependencies
            curl  # needed by lake exe cache get
          ];
        };
      });
    };
}
