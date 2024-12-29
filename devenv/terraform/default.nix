{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.terraform;
in
{
  options.my.terraform = {
    enable = lib.mkEnableOption "tools for Terraform development";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.terraform;
      defaultText = lib.literalExpression "pkgs.terraform";
      description = "The Terraform package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    languages.terraform = {
      enable = true;
      package = cfg.package;
    };

    packages = [
      pkgs.awscli2
      pkgs.hcloud
      pkgs.oci-cli
      pkgs.terraformer
      pkgs.terragrunt
      pkgs.tflint
      pkgs.tfsec
    ];
  };
}
