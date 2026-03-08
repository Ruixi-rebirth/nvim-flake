{ ... }:
{
  plugins.undotree = {
    enable = true;

    settings = {
      CursorLine = true;
      DiffAutoOpen = true;
      DiffCommand = "diff";
      DiffpanelHeight = 10;
      HelpLine = true;
      HighlightChangedText = true;
      HighlightChangedWithSign = true;
      HighlightSyntaxAdd = "DiffAdd";
      HighlightSyntaxChange = "DiffChange";
      HighlightSyntaxDel = "DiffDelete";
      RelativeTimestamp = true;
      SetFocusWhenToggle = true;
      ShortIndicators = false;
      SplitWidth = 40;
      TreeNodeShape = "*";
      TreeReturnShape = "\\";
      TreeSplitShape = "/";
      TreeVertShape = "|";
      WindowLayout = 4;
    };

    lazyLoad.settings = {
      keys = [
        {
          __unkeyed-1 = "<leader>u";
          __unkeyed-2 = "<cmd>UndotreeToggle<cr>";
          desc = "Toggle UndoTree";
        }
      ];
    };
  };
}
