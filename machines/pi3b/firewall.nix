{ config, pkgs, lib, ... }:

{
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 22 3000 ];
      allowedUDPPorts = [ 53 ];
    };
  };

  services.keepalived.openFirewall = true;
}
