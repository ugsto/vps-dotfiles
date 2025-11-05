{
  pkgs,
  username,
  name,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./locale.nix
    ./networking.nix
    ./security.nix
  ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    devices = [ "/dev/vda" ];
  };
  fileSystems."/" = {
    device = "/dev/vda2";
    fsType = "ext4";
  };
  services.openssh.enable = true;
  environment.systemPackages = with pkgs; [
    curl
    gitMinimal
    neovim
  ];
  users.users = {
    root = {
      initialPassword = "root";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOjVo4gFIozAyhko3MarStELFgQHIBX1qthAk7Yjuq4F kurisu@fedora"
      ];
    };
    ${username} = {
      isNormalUser = true;
      description = name;
      extraGroups = [
        "wheel"
        "input"
      ];
    };
  };
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        username
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d --max-kept-generations 5";
    };
  };
  system.stateVersion = "25.05";
}
