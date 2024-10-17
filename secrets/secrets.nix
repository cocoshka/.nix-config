let
  cocoshka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKF+fhfpEYCZNuA5dY8Aryjw+ZWp9Q35tpVu/QWu+pPG";
  users = [cocoshka];

  legion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERZnl5mhSxgZSXTGSywTlt+5X5r2xjaSnYINdXtp6X9";
  hosts = [legion];

  keys = users ++ hosts;
in {
  "C.BEK.age".publicKeys = keys;
  "D.BEK.age".publicKeys = keys;
}
