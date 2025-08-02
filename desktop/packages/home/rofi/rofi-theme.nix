{ config, colours }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  miku = mkLiteral "#${colours.miku}";
  teto = mkLiteral "#${colours.teto}";
  light = mkLiteral "#${colours.primaryBg}";
  dark = mkLiteral "#${colours.secondaryBg}";
in
{
  "*" = {
    selected-normal-foreground = dark;
    foreground = miku;
    normal-foreground = mkLiteral "@foreground";
    alternate-normal-background = mkLiteral "rgba ( 255, 255, 255, 7 % )";
    red = teto;
    selected-urgent-foreground = mkLiteral "@selected-normal-foreground";
    blue = mkLiteral "rgba ( 38, 139, 210, 100 % )";
    urgent-foreground = mkLiteral "rgba ( 255, 153, 153, 100 % )";
    alternate-urgent-background = mkLiteral "rgba ( 255, 255, 255, 7 % )";
    active-foreground = mkLiteral "rgba ( 170, 170, 17, 100 % )";
    lightbg = mkLiteral "rgba ( 238, 232, 213, 100 % )";
    selected-active-foreground = mkLiteral "@selected-normal-foreground";
    alternate-active-background = mkLiteral "rgba ( 255, 255, 255, 7 % )";
    background = mkLiteral "rgba ( 51, 51, 51, 93 % )";
    # bordercolor = mkLiteral "@foreground";
    alternate-normal-foreground = mkLiteral "@foreground";
    normal-background = mkLiteral "rgba ( 0, 0, 0, 0 % )";
    lightfg = light;
    selected-normal-background = mkLiteral "@foreground";
    border-color = mkLiteral "@foreground";
    spacing = mkLiteral "2";
    separatorcolor = mkLiteral "@foreground";
    urgent-background = mkLiteral "rgba ( 0, 0, 0, 0 % )";
    selected-urgent-background = mkLiteral "rgba ( 255, 153, 153, 100 % )";
    alternate-urgent-foreground = mkLiteral "@urgent-foreground";
    background-color = mkLiteral "rgba ( 0, 0, 0, 0 % )";
    alternate-active-foreground = mkLiteral "@active-foreground";
    active-background = mkLiteral "rgba ( 0, 0, 0, 0 % )";
    selected-active-background = mkLiteral "rgba ( 170, 170, 17, 100 % )";
  };
  window = {
    background-color = mkLiteral "@background";
    border = mkLiteral "4";
    padding = mkLiteral "5";
  };
  mainbox = {
    border = mkLiteral "0";
    padding = mkLiteral "0";
  };
  message = {
    border = mkLiteral "1px dash 0px 0px ";
    border-color = mkLiteral "@separatorcolor";
    padding = mkLiteral "1px ";
  };
  textbox = {
    text-color = mkLiteral "@foreground";
  };
  listview = {
    fixed-height = mkLiteral "0";
    border = mkLiteral "2px dash 0px 0px ";
    border-color = mkLiteral "@separatorcolor";
    spacing = mkLiteral "2px ";
    scrollbar = mkLiteral "false";
    padding = mkLiteral "2px 0px 0px ";
  };
  element = {
    border = mkLiteral "0";
    padding = mkLiteral "1px ";
  };
  element-text = {
    background-color = mkLiteral "inherit";
    text-color = mkLiteral "inherit";
  };
  "element.normal.normal" = {
    background-color = mkLiteral "@normal-background";
    text-color = mkLiteral "@normal-foreground";
  };
  "element.normal.urgent" = {
    background-color = mkLiteral "@urgent-background";
    text-color = mkLiteral "@urgent-foreground";
  };
  "element.normal.active" = {
    background-color = mkLiteral "@active-background";
    text-color = mkLiteral "@active-foreground";
  };
  "element.selected.normal" = {
    background-color = mkLiteral "@selected-normal-background";
    text-color = mkLiteral "@selected-normal-foreground";
  };
  "element.selected.urgent" = {
    background-color = mkLiteral "@selected-urgent-background";
    text-color = mkLiteral "@selected-urgent-foreground";
  };
  "element.selected.active" = {
    background-color = mkLiteral "@selected-active-background";
    text-color = mkLiteral "@selected-active-foreground";
  };
  "element.alternate.normal" = {
    background-color = mkLiteral "@alternate-normal-background";
    text-color = mkLiteral "@alternate-normal-foreground";
  };
  "element.alternate.urgent" = {
    background-color = mkLiteral "@alternate-urgent-background";
    text-color = mkLiteral "@alternate-urgent-foreground";
  };
  "element.alternate.active" = {
    background-color = mkLiteral "@alternate-active-background";
    text-color = mkLiteral "@alternate-active-foreground";
  };
  scrollbar = {
    width = mkLiteral "4px";
    border = mkLiteral "0";
    handle-width = mkLiteral "8px";
    padding = mkLiteral "0";
  };
  mode-switcher = {
    border = mkLiteral "2px dash 0px 0px";
    border-color = mkLiteral "@separatorcolor";
  };
  "button.selected" = {
    background-color = mkLiteral "@selected-normal-background";
    text-color = mkLiteral "@selected-normal-foreground";
  };
  inputbar = {
    spacing = mkLiteral "0";
    text-color = mkLiteral "@normal-foreground";
    padding = mkLiteral "1px ";
  };
  case-indicator = {
    spacing = mkLiteral "0";
    text-color = mkLiteral "@normal-foreground";
  };
  entry = {
    spacing = mkLiteral "0";
    text-color = mkLiteral "@normal-foreground";
  };
  prompt = {
    spacing = mkLiteral "0";
    text-color = mkLiteral "@normal-foreground";
  };
  inputbar = {
    children = mkLiteral "[ prompt,textbox-prompt-colon,entry,case-indicator ]";
  };
  textbox-prompt-colon = {
    expand = mkLiteral "false";
    str = "->";
    margin = mkLiteral "0px 0.3em 0em 0em ";
    text-color = mkLiteral "@normal-foreground";
  };
}
