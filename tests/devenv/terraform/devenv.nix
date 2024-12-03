{ inputs, pkgs, ... }:
{
  imports = [ inputs.my-modules.devenvModules.terraform ];
  my.terraform.enable = true;
  
  enterTest = ''
    terraform version
  '';
}
