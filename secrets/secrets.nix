let
  workstation = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2R0FVgPAXo1wA6o9fUJJ2W7QGSbLqr6OgWn6k2TMW4";
  pi3b = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4mEb5kqY8LMAoWN1OY844BRvNDW4grv84ko5ILRs9v";
  y520 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDYj83QvVmoze1PzMCWoGkX2beHTjx0d62jY4jWcZ3qg";
  allKeys = [workstation pi3b y520];
in {
  "hashedUserPassword.age".publicKeys = allKeys;
  "wifi.age".publicKeys = allKeys;
  "keepalived.age".publicKeys = allKeys;
}
