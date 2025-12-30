{ colours, ... }:
{
  recent-windows = {
    highlight = {
      active-color = colours.base.miku;
      urgent-color = colours.base.teto;
      padding = 4;
      corner-radius = 0;
    };
    binds = {
      "Mod+Shift+grave" = {
        previous-window._props = {
          filter = "app-id";
        };
      };
      "Mod+grave" = {
        next-window._props = {
          filter = "app-id";
        };
      };
    };
  };
}
