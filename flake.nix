{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    sops-nix = {
    url = "github:Mic92/sops-nix";
    #inputs.nixpkgs.follows = "nixpkgs";
    };
    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz"; # For latest stable version
      #url = "https://flakehub.com/f/Svenum/Solaar-Flake/0.1.1.tar.gz"; # uncomment line for solaar version 1.1.13
      #url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    #auto-cpufreq = {
    #url = "github:AdnanHodzic/auto-cpufreq";
    #inputs.nixpkgs.follows = "nixpkgs-stable";
    #};
#      impermanence.url = "github:nix-community/impermanence";
     home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, solaar,... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      #overlay-unstable = final: prev: {
      #unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        # use this variant if unfree packages are needed:
       #  unstable = import nixpkgs-unstable {
        #   inherit system;
       #    config.allowUnfree = true;
       #  };

      #};
    in {
    
      nixosConfigurations = {
        ThinkPad = lib.nixosSystem {
          inherit system;
          # specialArgs = {inherit inputs;};
          modules = [ 
         # ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./nixos/configuration.nix
            ./modules
            #./sops.nix
            #auto-cpufreq.nixosModules.default
            sops-nix.nixosModules.sops
            # inputs.home-manager.nixosModules.default
            solaar.nixosModules.default
            home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.jaziel = import ./home/home.nix;
            #sops-nix.nixosModules.sops;
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          ];
        };
    };
   # homeConfigurations = {
     # jaziel = home-manager.lib.homeManagerConfiguration {
       # inherit pkgs;
        #extraSpecialArgs = { inherit overlay-unstable; };
	#modules = [
	#({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	#./home/home.nix ];
	#	};
	#};
};

}
