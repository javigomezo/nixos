{
  programs.starship = {
    enable = true;
    settings = {
      palette = "nord";
      add_newline = true;
      format = ''
        $directory$git_branch$fill$kubernetes$python$hostname
        $character
      '';
      directory = {
        style = "bold blue";
        truncation_symbol = "…/";
      };
      hostname = {
        style = "bold green";
        format = "[$ssh_symbol$hostname]($style)";
      };
      character = {
        success_symbol = "[->](bold green)";
        error_symbol = "[->](bold red)";
      };
      username = {
        style_user = "bold yellow";
        style_root = "bold red";
        format = "[$user]($style) ";
      };
      git_branch = {
        truncation_length = 14;
        style = "yellow";
        symbol = " ";
        # symbol = " ";
      };
      kubernetes = {
        symbol = "☸  ";
        style = "bold purple";
        disabled = false;
        detect_files = ["k8s" "Dockerfile"];
        detect_extensions = ["yaml"];
        format = "[$symbol$context( \($namespace\))]($style) ";
      };
      python = {detect_extensions = ["py"];};
      localip = {disabled = true;};
      gcloud = {disabled = true;};
      nodejs = {disabled = true;};
      lua = {disabled = true;};

      palettes.nord = {
        red = "#bf616a";
        green = "#a3be8c";
        blue = "#81A1C1";
        orange = "#d08770";
        yellow = "#ebcb8b";
        purple = "#b48ead";
      };
    };
  };
}
