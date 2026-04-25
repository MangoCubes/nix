{ inputs, ... }:
{
  imports = [ inputs.dragevac.homeManager.default ];
  programs.dragevac = {
    enable = true;
    settings = {
      css = "window {\n\tbackground-color: rgba(0, 0, 0, 0.625);\n\tborder: 4px solid rgba(71, 200, 192, 1);\n\tpadding: 4px;\n\tmargin-top: 4px;\n\tmargin-left: 4px;\n\tmargin-right: 4px;\n}\n\nlabel {\n\tcolor: white;\n\ttext-shadow: 0px 0px 2px rgb(71, 200, 192), 0px 0px 2px rgb(71, 200, 192);\n}\n";
      empty_text = "Drop items here";
      keep_text = true;
      anchor = "top";
      expand = true;
      exclusive = true;
    };
  };
}
