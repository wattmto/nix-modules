{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.go;

  goVersion = (lib.versions.major cfg.package.version) + (lib.versions.minor cfg.package.version);

  buildGoModule = pkgs.buildGoModule.override { go = cfg.package; };
  buildWithSpecificGo = pkg: pkg.override { inherit buildGoModule; };
in
{
  options.my.go = {
    enable = lib.mkEnableOption "tools for Go development";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.go;
      defaultText = lib.literalExpression "pkgs.go";
      description = "The Go package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    languages.go = {
      enable = true;
      enableHardeningWorkaround = true;
      package = cfg.package;
    };

    packages = [
      pkgs.gcc
      # TODO: Build with specific go version after https://github.com/NixOS/nixpkgs/pull/339057 fixes
      # (buildWithSpecificGo pkgs.golangci-lint)
      pkgs.golangci-lint
      (buildWithSpecificGo pkgs.ko)
    ];
  };
}
