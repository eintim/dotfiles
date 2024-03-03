{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      rmark = pkgs.rPackages.buildRPackage {
        name = "gifski";
        src = pkgs.fetchFromGitHub{
          owner = "r-rust";
          repo = "gifski";
          rev = "2b7f3bb558e5bfaeb52f9c989ecbff30d8310a05";
          sha256 = "12mhmmibizbxgmsns80c8h97rr7rclv9hz98zpgsl26hw3s4l0vm";
        };
   propagatedBuildInputs = with pkgs.rPackages; [bslib evaluate jsonlite knitr stringr tinytex yaml xfun];
      };
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.bashInteractive ];
        buildInputs = with pkgs; [ R rmark pandoc ];
      };
    });
}