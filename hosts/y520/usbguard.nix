{
  services.usbguard = {
    enable = true;
    rules = ''
      allow id 0bda:0821 serial "00e04c000001" name "Bluetooth Radio " hash "Y4cSpbnKd4P20Q1jjrqRuZnQmtPOufG0JMRSWM4xh2s=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" with-interface { e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 } with-connect-type "hardwired"
    '';
  };
}
