{ inputs, pkgs, ... }:
{
  imports = [ inputs.my-modules.devenvModules.go ];
  my.go.enable = true;
  
  enterTest = ''
    go version
  '';
}
