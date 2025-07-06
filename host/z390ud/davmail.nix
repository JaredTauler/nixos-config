{ config, lib, pkgs, ... }:

{
  #   environment.systemPackages = with pkgs; [
  #   davmail
  # ];


  # environment.etc."davmail.properties".text = ''
  #   davmail.url=https://outlook.office365.com/EWS/Exchange.asmx
  #   davmail.popPort=-1
  #   davmail.smtpPort=1025
  #   davmail.imapPort=1143
  #   davmail.caldavPort=-1
  #   davmail.ldapPort=-1
  #   davmail.enableEws=true
  # '';
  services.davmail = {
    enable = true;
    url = "https://outlook.office365.com/EWS/Exchange.asm";
  };

}
