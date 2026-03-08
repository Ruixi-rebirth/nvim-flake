{ ... }:
{
  plugins.diffview = {
    enable = true;

    settings = {
      enhanced_diff_hl = true;
      diff_binaries = true;
      use_icons = true;
    };

    lazyLoad.settings = {
      cmd = [
        "DiffviewOpen"
        "DiffviewClose"
        "DiffviewToggleFiles"
        "DiffviewFocusFiles"
        "DiffviewRefresh"
        "DiffviewFileHistory"
      ];
    };
  };
}
