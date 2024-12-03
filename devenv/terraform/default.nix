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
  };

  config = lib.mkIf cfg.enable {
    languages.terraform.enable = true;

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
