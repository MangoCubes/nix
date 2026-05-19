{
  inputs,
  ...
}:
{
  imports = [
    inputs.proxmox-nixos.nixosModules.proxmox-ve
  ];
  services.proxmox-ve = {
    enable = true;
    ipAddress = "127.0.0.1";
  };
}
