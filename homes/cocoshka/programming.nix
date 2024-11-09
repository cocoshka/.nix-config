{pkgs, ...}: {
  home.packages = with pkgs; [
    upstream.vscode
    jetbrains.idea-ultimate

    python3
    python3Packages.pip

    upstream.deno
    nodejs
    pnpm

    go
    rustup

    kotlin
    kotlin-language-server

    gradle
    maven
  ];

  programs.java = with pkgs; {
    enable = true;
    package = temurin-bin-21;
  };
}
