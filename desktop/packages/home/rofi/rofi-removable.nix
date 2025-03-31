{ pkgs }: pkgs.writeShellScriptBin "rofi-removable" ''
PARTS=$(mount | grep -w $USER | cut -d" " -f1)
DEVS=$(for PART in $PARTS; do echo $PART | sed 's/[0-9]*$//'; done | uniq)
if [ $# -eq 0 ]; then
  echo $DEVS
elif [ -e $@ ]; then
  sync && for PART in $(echo $PARTS | grep $@); do udisksctl unmount -b $PART > /dev/null; done && udisksctl power-off -b $(echo $DEVS | grep $@)
fi
''
