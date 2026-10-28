{
  description = "Tim's system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    import-tree.url = "github:vic/import-tree";

    microvm.url = "github:microvm-nix/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    # Skill sources for modules/shared/agent-skills.nix.
    anthropic-skills.url = "github:anthropics/skills";
    anthropic-skills.flake = false;

    mattpocock-skills.url = "github:mattpocock/skills";
    mattpocock-skills.flake = false;

    pstack-claude.url = "github:michael-denyer/pstack-claude";
    pstack-claude.flake = false;

    tstack.url = "github:t3dotgg/tstack";
    tstack.flake = false;
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
