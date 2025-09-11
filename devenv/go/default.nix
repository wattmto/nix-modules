{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.go;
  goVersion = (lib.versions.major cfg.package.version) + (lib.versions.minor cfg.package.version);
  buildWithSpecificGo =
    pkg:
    pkg.override { buildGoModule = pkgs."buildGo${goVersion}Module".override { go = cfg.package; }; };
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
      (buildWithSpecificGo pkgs.golangci-lint)
      (buildWithSpecificGo pkgs.ko)
    ];
  };
}
