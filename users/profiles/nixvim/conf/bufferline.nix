{
  programs.nixvim = {
    plugins.bufferline = {
      enable = true;

      persistBufferSort = true;
      moveWrapsAtEnds = true;

      # indicator.style = "underline";
      # hover.enabled = true;

      # button = "󰅙";
      # button = "󰅚";
      # modified.button = "󰀨";
      # inactive.modified.button = "󰗖";

      separatorStyle = "slant";
      closeIcon = "󰅚";
      bufferCloseIcon = "󰅙";
      modifiedIcon = "󰀨";
      stylePreset = ["no_bold" "no_italic"];

      highlights = rec {
        # Tab bar fill
        fill.bg = "#21222a";
        fill.fg = "#5a5b64";

        # Tab fill
        background.fg = "#5a5b64";
        background.bg = "#000000";
        background.sp = fill.bg;
        background.underline = true;

        # Tab separator
        separator = background // { fg = fill.bg; };
        separatorVisible = background // { fg = fill.bg; };

        # Path name
        duplicate = background // { fg = "#5a5b64"; };

        # buffer = { fg = "#5a5b64"; } // background;
        modified = background // { fg = "#5e3828"; };
        closeButton = background;

        # duplicate.bg = "#21222a";
        pick.bg = "#212fff";
        hint.bg = "#212fff";
        # error.bg = "#21222a";
        # warning.bg = "#21222a";
        # info.bg = "#21222a";
        # hint.bg = "#21222a";
        # hintDiagnostic.bg = "#21222a";
        # infoDiagnostic.bg = "#21222a";
        # errorDiagnostic.bg = "#21222a";
        # warningDiagnostic.bg = "#21222a";
        # numbers.bg = "#21222a";

        # icon = background;
        bufferSelected.fg = "#ecedfa";
        separatorSelected.fg = separator.fg;
        # separatorSelected.fg = "#000000";
        closeButtonSelected.fg = "#ecedfa";

        # nameVisible.fg = "#ecedfa";
        modifiedSelected.fg = "#ef4030";

        bufferVisible.fg = "#5a5b64";
        infoVisible.fg = "#5a5b64";
      };
    };

    maps.normal = {
      # Reordering tabs
      "<m-s-j>" = "<cmd>BufferLineMoveNext<cr>";
      "<m-s-k>" = "<cmd>BufferLineMovePrev<cr>";
      "<m-p>" = "<cmd>BufferLineTogglePin<cr>";

      # Navigating tabs
      "<m-j>" = "<cmd>BufferLineCycleNext<cr>";
      "<m-k>" = "<cmd>BufferLineCyclePrev<cr>";
      "<m-1>" = "<cmd>BufferLineGoToBuffer 1<cr>";
      "<m-2>" = "<cmd>BufferLineGoToBuffer 2<cr>";
      "<m-3>" = "<cmd>BufferLineGoToBuffer 3<cr>";
      "<m-4>" = "<cmd>BufferLineGoToBuffer 4<cr>";
      "<m-5>" = "<cmd>BufferLineGoToBuffer 5<cr>";
      "<m-6>" = "<cmd>BufferLineGoToBuffer 6<cr>";
      "<m-7>" = "<cmd>BufferLineGoToBuffer 7<cr>";
      "<m-8>" = "<cmd>BufferLineGoToBuffer 8<cr>";
      "<m-9>" = "<cmd>BufferLineGoToBuffer 9<cr>";
      "<m-0>" = "<cmd>BufferLineGoToBuffer -1<cr>";

      # Close tab
      "<m-x>" = "<cmd>lua require('bufferline.commands').unpin_and_close()<cr>";
    };
  };
}
