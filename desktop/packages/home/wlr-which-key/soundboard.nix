{ config, pkgs, ... }:
let
  stopAll = "pkill -x play";
  combined = "Combined";
  microphone = "alsa_input.usb-Samsung_Samsung_USB_C_Earphones_20160406.1-00.analog-stereo";
  playSpeaker = file: "${pkgs.sox}/bin/play ${file}";
  play = file: "AUDIODEV=${combined} ${pkgs.sox}/bin/play ${file}";
  setup = ''
    pactl load-module module-null-sink sink_name=${combined} sink_properties=device.description="Combined-output";
    pactl load-module module-loopback source=${microphone} sink=${combined};
  '';
  playSound = file: ''
    ${stopAll}
    ${playSpeaker file} &
    ${play file} &
  '';
in
[
  {
    key = "S";
    desc = "Setup microphone";
    cmd = setup;
  }
  {
    key = "q";
    desc = "Stop all sounds";
    cmd = stopAll;
  }
  {
    key = "d";
    desc = "Discord notification";
    cmd = playSound ./effects/discord-notification.mp3;
  }
  {
    key = "D";
    desc = "Discord join";
    cmd = playSound ./effects/discord-join.mp3;
  }
  {
    key = "b";
    desc = "Battle start";
    cmd = playSound ./effects/battle.mp3;
  }
  {
    key = "c";
    desc = "Caught";
    cmd = playSound ./effects/caught.mp3;
  }
  {
    key = "o";
    desc = "Owned";
    cmd = playSound ./effects/victory.mp3;
  }
  {
    key = "a";
    desc = "Alert";
    cmd = playSound ./effects/alert.mp3;
  }
  {
    key = "e";
    desc = "Extraction announcement";
    cmd = playSound ./effects/extract.wav;
  }
  {
    key = "B";
    desc = "BTP";
    cmd = playSound ./effects/sss.wav;
  }
]
