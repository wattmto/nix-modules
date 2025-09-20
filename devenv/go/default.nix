{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.go;
  # Override the buildGoModule function to use the specified Go package.
  buildGoModule = pkgs.buildGoModule.override { go = cfg.package; };
  # A helper function to rebuild a package with the specific Go version.
  # It expects the package to have a `buildGo*Module` argument in its override function.
  # This will override multiple buildGo*Module arguments if they exist.
  buildWithSpecificGo = pkg:
    let
      overrideArgs = lib.functionArgs pkg.override;
      goModuleArgs = lib.filterAttrs (name: _: lib.match "buildGo.*Module" name != null) overrideArgs;
      goModuleOverrides = lib.mapAttrs (_: _: buildGoModule) goModuleArgs;
    in
    if goModuleOverrides != {} then
      pkg.override goModuleOverrides
    else
      throw ''
        `languages.go` failed to override the Go version for ${pkg.pname or "unknown"}.
        Expected to find a `buildGo*Module` argument in its override function.

        Found: ${toString (lib.attrNames overrideArgs)}
      '';
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
