{ ... }:
{
  plugins.gitblame = {
    enable = true;
    settings = {
      message_template = " <summary> • <date> • <author> • <<sha>>";
    };
  };
}
