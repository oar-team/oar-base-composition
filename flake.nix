{
  description = "OAR - basic setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.05";
    nxc.url = "/home/adfaure/code/nixos-compose"; # "git+https://gitlab.inria.fr/nixos-compose/nixos-compose.git?ref=nixpkgs-2305";
    nxc.inputs.nixpkgs.follows = "nixpkgs";
    NUR.url = "github:nix-community/NUR";
    kapack.url = "github:oar-team/nur-kapack?ref=regale";
    kapack.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nxc, NUR, kapack }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = nxc.lib.compose {
      inherit nixpkgs system NUR;
      repoOverrides = { inherit kapack; };
      composition = ./composition.nix;
      setup = ./setup.toml;
    };

    devShell.${system} = nxc.devShells.${system}.nxcShellFull;
  };
}
