{
  config = {
    autoCmd = [
      {
        # Jump to the last edit position
        event = [ "BufReadPost" ];
        pattern = [ "*" ];
        command = ''
          if line("'\"") > 1 && line("'\"") <= line("$") |
          	exe "normal! g`\""
          endif
        '';
      }
      {
        # Automatically remove trailing whitespace before saving the file
        event = [ "BufWritePre" ];
        pattern = [ "*" ];
        command = "%s/\\s\\+$//e";
      }
    ];
  };
}
