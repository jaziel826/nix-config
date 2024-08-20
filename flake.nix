{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/24.05";
    sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    auto-cpufreq = {
    url = "github:AdnanHodzic/auto-cpufreq";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
#      impermanence.url = "github:nix-community/impermanence";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, auto-cpufreq, sops-nix,... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlay-unstable = final: prev: {
      #unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        # use this variant if unfree packages are needed:
         unstable = import nixpkgs-unstable {
           inherit system;
           config.allowUnfree = true;
         };

      };
    in {
    
      nixosConfigurations = {
        ThinkPad = lib.nixosSystem {
          inherit system;
          # specialArgs = {inherit inputs;};
          modules = [ 
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./nixos/configuration.nix
            ./modules
            #./sops.nix
            auto-cpufreq.nixosModules.default
            sops-nix.nixosModules.sops
            # inputs.home-manager.nixosModules.default
          ];
        };
    };
    homeConfigurations = {
      jaziel = home-manager.lib.homeManagerConfiguration { 
        inherit pkgs;
        extraSpecialArgs = { inherit overlay-unstable; };
	modules = [
	({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	./home/home.nix ];
		};  	
	};
};

}
