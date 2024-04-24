{
  config = {
    autoCmd = [
      {
        #  jumps to the line of the last edit
        event = [ "BufReadPost" ];
        pattern = [ "*" ];
        command = ''
          if line("'\"") > 1 && line("'\"") <= line("$") |
          	exe "normal! g`\""
          endif
        '';
      }
    ];
  };
}
