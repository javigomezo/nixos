{
  lib,
  config,
  ...
}: {
  programs.wofi = {
    enable = true;
    settings = {
      location = "center";
      show = "drun";
      matching = "fuzzy";
      prompt = "Buscar...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 28;
      gtk_dark = true;
      term = lib.getExe config.programs.kitty.package;
    };
    # style = ''

    #   * {
    #     transition: 0.1s;
    #   }

    #   window {
    #   	font-family: "Comic Code Ligatures";
    #   	font-size: 16px;
    #   }

    #   window {
    #       margin: 0px;
    #       border: 2px solid #81a1c1;
    #       background-color: rgba(59, 66, 82, 0.82);
    #       border-radius: 16px;
    #   }

    #   #input {
    #       padding: 4px;
    #       margin: 20px;
    #       padding-left: 20px;
    #       border: none;
    #       color: rgba(76, 86, 106, 0.82);
    #       font-weight: bold;
    #       background: rgba(236, 239, 244, 0.82);
    #      	outline: none;
    #       border-radius: 16px;
    #   }

    #   #input image {
    #       color: #4c566a;
    #   }

    #   #input:focus {
    #       border: none;
    #      	outline: none;
    #   }

    #   #inner-box {
    #       margin: 20px;
    #       margin-top: 0px;
    #       border: none;
    #       color: rgba(180, 142, 173, 0.82);
    #       border-radius: 16px;
    #   }

    #   #inner-box * {
    #       transition: none;
    #   }

    #   #outer-box {
    #       margin: 0px;
    #       border: none;
    #       padding: 0px;
    #       border-radius: 16px;
    #   }

    #   #scroll {
    #       margin-top: 5px;
    #       border: none;
    #       border-radius: 16px;
    #       margin-bottom: 5px;
    #   }

    #   #text:selected {
    #       color: #eceff4;
    #       font-weight: bold;
    #   }

    #   #img {
    #       margin-right: 20px;
    #       background: transparent;
    #   }

    #   #text {
    #       margin: 0px;
    #       border: none;
    #       padding: 0px;
    #       background: transparent;
    #   }

    #   #entry {
    #       margin: 0px;
    #       border: none;
    #       border-radius: 16px;
    #       background-color: transparent;
    #       min-height:32px;
    #       font-weight: bold;
    #   }

    #   #entry:selected {
    #       outline: none;
    #       margin: 0px;
    #       border: none;
    #       border-radius: 16px;
    #       background: rgba(94, 129, 172, 0.82);
    #   }
    # '';
  };
}
