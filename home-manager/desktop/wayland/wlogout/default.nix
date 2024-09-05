{config, ...}: {
  imports = [
    ./icons.nix
  ];
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Cerrar sesión";
        height = 0.95;
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Apagar";
        height = 0.95;
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspender";
        height = 0.95;
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reiniciar";
        height = 0.95;
      }
      {
        label = "lock";
        action = "hyprlock";
        text = "Bloquear";
        height = 0.95;
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernar";
        height = 0.95;
      }
    ];
    style = ''
      * {
      	background-image: none;
      }
      window {
      	background-color: rgba(46, 52, 64, 0.9);
      }
      button {
      	color: #ECEFF4;
        font-size: 18px;

      	background-repeat: no-repeat;
      	background-position: center;
      	background-size: 25%;

      	border-style: solid;
      	background-color: rgba(46, 52, 64, 0.5);
        border: 3px solid #ECEFF4;

        box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.3) 0 6px 20px 0 rgba(0, 0, 0, 0.2);
      }

      button:focus,
      button:active,
      button:hover {
      	background-color: rgba(46, 52, 64, 0.7);
      	color: #ECEFF4;
        border: 3px solid #81A1C1;
      }
      #logout {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("${config.home.homeDirectory}/.config/wlogout/icons/logout.png"));
      }
      #shutdown {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("${config.home.homeDirectory}/.config/wlogout/icons/shutdown.png"));
      }
      #suspend {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("${config.home.homeDirectory}/.config/wlogout/icons/suspend.png"));
      }
      #reboot {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("${config.home.homeDirectory}/.config/wlogout/icons/reboot.png"));
      }
      #lock {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("${config.home.homeDirectory}/.config/wlogout/icons/lock.png"));
      }
      #hibernate {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("${config.home.homeDirectory}/.config/wlogout/icons/hibernate.png"));
      }
    '';
  };
}
