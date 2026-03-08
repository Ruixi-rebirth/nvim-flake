{ ... }:
{
  plugins.todo-comments = {
    enable = true;
    lazyLoad.settings = {
      event = [ "InsertEnter" ];
    };
  };
}
