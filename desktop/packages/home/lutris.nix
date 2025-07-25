{
  unfreeUnstable,
  ...
}:
{
  home.packages = (
    with unfreeUnstable;
    [
      (lutris.override {
        extraPkgs = pkgs: [
          wine
          dxvk
          vulkan-tools
        ];
      })
    ]
  );
}
