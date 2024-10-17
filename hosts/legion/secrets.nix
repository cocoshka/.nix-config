{flake-root, ...}: {
  age.secrets = {
    "C.BEK".file = flake-root + /secrets/C.BEK.age;
    "D.BEK".file = flake-root + /secrets/D.BEK.age;
  };
}
