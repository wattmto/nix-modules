{
  description = "nix-modules";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      devenv,
      ...
    }@inputs:
    let
      mkModules =
        path:
        with builtins;
        listToAttrs (
          map (name: {
            inherit name;
            value = import (path + "/${name}");
          }) (attrNames (readDir path))
        );
    in
    {
      devenvModules = mkModules ./devenv;
    };
}
