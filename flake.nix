{
  description = "NixOS WSL Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };
  outputs = inputs: {
    nixosConfigurations = {
      nixos = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.nixos-wsl.nixosModules.default
          (
            { pkgs, ... }:
            {
              environment.systemPackages = with pkgs; [
                awscli
                btop
                clang
                clang-tools
                cmake
                docker
                fish
                gimme-aws-creds
                git
                glibc
                lunarvim
                meld
                neovim
                nodejs
                nodePackages.aws-cdk
                python312
                python312Packages.pip
                python312Packages.virtualenv
                unzip
                wget
                gnumake
                gcc
                starship
                zip
                zsh
              ];
              nix = {
                package = pkgs.nixVersions.stable;
                extraOptions = ''experimental-features = nix-command flakes'';
              };
              nixpkgs.config.allowUnfree = true;
              programs.fish = {
                enable = true;
                shellAliases = {
                  update = "sudo nixos-rebuild boot --flake /mnt/c/justin/code/wsl_nixos/";
                  gocode = "cd /mnt/c/justin/code";
                  goconfig = "cd /mnt/c/justin/code/wsl_nixos/";
                  ne = "python -m venv .venv";
                  newvenv = "python -m venv .venv";
                  activate = "source .venv/bin/activate.fish";
                  vim = "nvim";
                  flake = "nvim /mnt/c/justin/code/wsl_nixos/flake.nix";
                };
                interactiveShellInit = ''
                  cp -r /mnt/c/Users/Justin/.gitconfig ~/
                  set SSH_AUTH_SOCK eval $(ssh-agent -s)
                  git config --global core.editor "nvim"
                '';
              };
              programs.neovim = {
                enable = true;
                withPython3 = true;
                withNodeJs = true;
              };
              programs.nix-ld.enable = true;
              programs.nix-ld.libraries = with pkgs; [
                stdenv.cc.cc
              ];
              programs.nix-ld.package = pkgs.nix-ld-rs;
              programs.starship.enable = true;
              programs.starship.settings = {
                format = "$shlvl$directory$git_branch$python
$character";
                shlvl = {
                  disabled = false;
                  symbol = "";
                  style = "bright-red bold";
                };
                shell = {
                  disabled = true;
                  format = "$indicator";
                  fish_indicator = "";
                };
              };
              programs.zsh = {
                enable = false;
                #enableCompletion = true;
                #autosuggestion.enable = true;
                syntaxHighlighting.enable = true;
                shellAliases = {
                  ll = "ls -lah";
                  update = "sudo nixos-rebuild boot --flake /mnt/c/justin/code/wsl_nixos/";
                  gocode = "cd /mnt/c/justin/code";
                  goconfig = "cd /mnt/c/justin/code/wsl_nixos/";
                  ne = "python -m venv .venv";
                  newvenv = "python -m venv .venv";
                  activate = "source .venv/bin/activate";
                  vim = "nvim";
                  flake = "nvim /mnt/c/justin/code/wsl_nixos/flake.nix";
                };
                shellInit = ''
                  cp -r /mnt/c/Users/Justin/.gitconfig ~/
                  eval $(ssh-agent -s) > /dev/null
                  git config --global core.editor "nvim"
                '';
              };
              system.stateVersion = "24.05";
              time.timeZone = "America/Denver";
              users.users.nixos = {
                extraGroups = [ "wheel" ];
                home = "/home/nixos";
                isNormalUser = true;
                shell = pkgs.fish;
              };
              virtualisation.docker.enable = true;
              virtualisation.docker.rootless = {
                enable = true;
                setSocketVariable = true;
              };
              wsl.enable = true;
            }
          )
        ];
      };
    };
  };
}
