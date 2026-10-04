{
  flake.nixosModules.usbGuard = {
    services.usbguard = {
      enable = true;
      rules = ''
        allow id 0bda:0821 serial "00e04c000001" name "Bluetooth Radio " hash "Y4cSpbnKd4P20Q1jjrqRuZnQmtPOufG0JMRSWM4xh2s=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" with-interface { e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 } with-connect-type "hardwired"
        allow id 1050:0407 serial "" name "YubiKey OTP+FIDO+CCID" hash "Q+A8QQReKclmBSaDIYja0w4Bx6ld2IU6wF7HFKdtJ3Q=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-1" with-interface { 03:01:01 03:00:00 0b:00:00 } with-connect-type "hotplug"
      '';
    };
  };
}
