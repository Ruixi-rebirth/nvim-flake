{ ... }:
{
  plugins.gitblame = {
    enable = true;
    settings = {
      message_template = "<summary> • <date> • <author> • <<sha>>";
      date_format = "%m-%d-%Y %H:%M:%S";
    };
  };
}
