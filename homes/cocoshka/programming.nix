{pkgs, ...}: {
  home.packages = with pkgs; [
    python3
    python3Packages.pip

    upstream.deno
    nodejs
    pnpm

    go
    rustup
  ];
}