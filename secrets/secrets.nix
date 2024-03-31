let
  workstation = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzu6WsnLgOJ4Oos1vf/+Fmwp714q/T4N+Qok93br0sK";
  pi3b = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4mEb5kqY8LMAoWN1OY844BRvNDW4grv84ko5ILRs9v";
  y520 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJPn6Z3UquawKbfaHqHd2iEnJoPhg38XIBJZa/2HRUv";
  allKeys = [workstation pi3b y520];
in {
  "hashedUserPassword.age".publicKeys = allKeys;
  "wifi.age".publicKeys = allKeys;
  "keepalived.age".publicKeys = allKeys;
}
