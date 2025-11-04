{ games }:
{
  unfreeUnstable,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.wine
  ]
  ++ (with unfreeUnstable; [
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
