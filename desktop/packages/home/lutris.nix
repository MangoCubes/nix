{ games }:
{
  unfree,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.wine
  ]
  ++ (with unfree; [
    (lutris.override {
      extraPkgs =
        pkgs:
        (
          if games then
            [
              dxvk
              vulkan-tools
            ]
          else
            [ ]
        );
    })
  ]);
}
