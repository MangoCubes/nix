{ colours }:
let
  miku = "#${colours.base.miku}";
  teto = "#${colours.base.teto}";
  rin = "#${colours.base.rin}";
  blackBg = "#${colours.base.blackBg}";
  darkBg = "#${colours.base.darkBg}";
  lightBg = "#${colours.base.lightBg}";
  white = "#ffffff";
  fgbg = fg: bg: { inherit fg bg; };
  fgbgBold = fg: bg: {
    inherit fg bg;
    bold = true;
  };
in
{
  mgr = {
    cwd.fg = miku;
    find_keyword = {
      fg = rin;
      bold = true;
      italic = true;
      underline = true;
    };
    marker_copied = fgbg miku miku;
    marker_cut = fgbg teto teto;
    marker_selected = fgbg rin rin;
    marker_marked = fgbg white white;
    count_copied = fgbg blackBg miku;
    count_cut = fgbg blackBg teto;
    count_selected = fgbg blackBg rin;
    border_symbol = "┃";
    border_style.fg = lightBg;
  };

  tabs = {
    active = fgbgBold blackBg miku;
    inactive = fgbg miku darkBg;
  };

  mode = {
    normal_main = fgbgBold blackBg miku;
    normal_alt = fgbg miku darkBg;
    select_main = fgbgBold blackBg teto;
    select_alt = fgbg teto darkBg;
    unset_main = fgbgBold blackBg rin;
    unset_alt = fgbg rin darkBg;
  };

  status = {
    perm_sep.fg = lightBg;
    perm_type.fg = miku;
    perm_read.fg = rin;
    perm_write.fg = miku;
    perm_exec.fg = teto;

    progress_label = {
      fg = white;
      bold = true;
    };
    progress_normal = fgbg miku darkBg;
    progress_error = fgbg darkBg teto;
  };

  pick = {
    border.fg = miku;
    active = {
      fg = teto;
      bold = true;
    };
  };

  input.border.fg = miku;

  tasks = {
    border.fg = miku;
    hovered = {
      fg = teto;
      bold = true;
    };
  };

  notify = {
    title_info.fg = miku;
    title_warn.fg = rin;
    title_error.fg = teto;
  };

  filetype = {
    rules = [
      {
        mime = "**/image/*";
        fg = miku;
      }
      {
        mime = "**/{audio,video}/*";
        fg = rin;
      }
      {
        mime = "**/application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
        fg = teto;
      }
      {
        mime = "**/application/{pdf,doc,rtf}";
        fg = miku;
      }
      {
        mime = "vfs/{absent,stale}";
        fg = lightBg;
      }
      {
        url = "*";
        fg = "#ffffff";
      }
      {
        url = "*/";
        fg = miku;
      }
    ];
  };
}
