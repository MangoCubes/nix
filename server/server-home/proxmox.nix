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
    ipAddress = "192.168.0.1";
  };

}
