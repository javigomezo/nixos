{lib, ...}: {
  age.secrets.hashedUserPassword = lib.mkDefault {
    file = ./hashedUserPassword.age;
  };
  age.secrets.wifi = lib.mkDefault {
    file = ./wifi.age;
  };
  age.secrets.keepalived = lib.mkDefault {
    file = ./keepalived.age;
  };
}
