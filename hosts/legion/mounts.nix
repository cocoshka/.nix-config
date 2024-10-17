{config, ...}: let
  bekFileC = config.age.secrets."C.BEK".path;
  bekFileD = config.age.secrets."D.BEK".path;
in {
  fileSystems."/mnt/dislocker/c" = {
    device = "/dev/disk/by-partuuid/0b315db3-3e7b-4803-b0d7-40e00a13b22d";
    fsType = "fuse./run/current-system/sw/bin/dislocker";
    options = ["nofail" "bekfile=${bekFileC}"];
  };

  fileSystems."/media/c" = {
    depends = [
      "/mnt/dislocker/c"
    ];
    device = "/mnt/dislocker/c/dislocker-file";
    fsType = "auto";
    options = ["nofail" "loop" "rw"];
  };

  fileSystems."/mnt/dislocker/d" = {
    device = "/dev/disk/by-partuuid/b20fbd65-03f4-4325-b841-d781c99af419";
    fsType = "fuse./run/current-system/sw/bin/dislocker";
    options = ["nofail" "bekfile=${bekFileD}"];
  };

  fileSystems."/media/d" = {
    depends = [
      "/mnt/dislocker/d"
    ];
    device = "/mnt/dislocker/d/dislocker-file";
    fsType = "auto";
    options = ["nofail" "loop" "rw"];
  };
}
