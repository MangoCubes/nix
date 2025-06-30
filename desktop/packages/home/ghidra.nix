{ pkgs, ... }:
{
  home.packages = [
    pkgs.ghidra
  ];
  programs.bash.shellAliases.ghidra = "env _JAVA_AWT_WM_NONREPARENTING=1 ghidra %U";
  xdg.desktopEntries.ghidra = {
    genericName = "Ghidra Software Reverse Engineering Suite";
    exec = ''env _JAVA_AWT_WM_NONREPARENTING=1 ghidra %U'';
    terminal = false;
    categories = [ "Development" ];
    icon = "ghidra";
    name = "Ghidra";
  };
}
