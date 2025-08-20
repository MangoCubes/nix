{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "cloud" ];
      image = "collabora/code:latest";
      name = "collabora";
    })
  ];
}
