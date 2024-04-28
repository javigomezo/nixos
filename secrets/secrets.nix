let
  workstation = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2R0FVgPAXo1wA6o9fUJJ2W7QGSbLqr6OgWn6k2TMW4";
  pi3b = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4mEb5kqY8LMAoWN1OY844BRvNDW4grv84ko5ILRs9v";
  y520 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKmH6bpHBh0uRYnIWcL8YK5aTS2OxukWbI2lj0w/nuS";
  allKeys = [workstation pi3b y520];
in {
  "hashedUserPassword.age".publicKeys = allKeys;
  "wifi.age".publicKeys = allKeys;
  "keepalived.age".publicKeys = allKeys;
}
