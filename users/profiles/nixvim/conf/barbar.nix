{
  programs.nixvim = {
    highlight = {
      BufferCurrent.bg = "#5a5b64";
      BufferCurrent.fg = "#ecedfa";
      BufferCurrent.sp = "#5a5b64";
      BufferCurrent.undercurl = true;
      BufferCurrentIcon = {};
      BufferCurrentSign.fg = "#5a5b64";
      BufferCurrentSign.bg = "none";
      BufferCurrentMod.bg = "#5a5b64";
      BufferCurrentMod.sp = "#fa6366";
      BufferCurrentMod.undercurl = true;
      # BufferCurrentMod.nocombine = true;
      BufferCurrentTarget.sp = "#fa6366";
      BufferCurrentTarget.undercurl = true;

      # BufferInactive.bg = "none";
      # BufferInactive.fg = "#5a5b64";
      # BufferInactiveSign.fg = "#21222a";
      # BufferInactiveIcon.fg = "#5a5b64";
      # BufferInactiveMod.bg = "#21222a";
      # BufferInactiveMod.fg = "#ff0000";
      # BufferInactiveModIcon.fg = "#ff0000";

      # BufferVisible.bg = "#21222a";
      # BufferVisible.fg = "#5a5b64";
      # BufferVisibleSign.fg = "#21222a";
      # BufferVisibleSign.bg = "none";
      # BufferVisibleMod.bg = "#21222a";
      # BufferVisibleMod.fg = "#ff0000";
      # BufferVisibleModIcon.fg = "#ff0000";

      # BufferAlternate.bg = "#21222a";
      # BufferAlternate.fg = "#5a5b64";
      # BufferAlternateSign.fg = "#21222a";
      # BufferAlternateSign.bg = "none";
      # BufferAlternateMod.bg = "#21222a";
      # BufferAlternateMod.fg = "#ff0000";
      # BufferAlternateModIcon.fg = "#ff0000";
    };

    plugins.barbar = {
      enable = true;
      # autoHide = true;
      # closeable = false; # Disable close button
      # TODO: set pin icon
      # highlightAlternate = true;
      icons = rec {
        separator = { left = ""; right = ""; };
        button = "󰅙";
        filetype = {
          customColors = true;
          enable = true;
        };
        current.filetype = filetype;

        modified.button = "󰀨";
        modified.filetype = filetype;
        alternate.filetype = filetype;

        # inactive.modified.button = "󰗖";
        inactive.modified = modified;

        inactive = {
          button = "󰅚";
          filetype = filetype;
          separator = { left = " "; right = " "; };
        };

        pinned = {
          button = "";
          filename = true;
          separator = { left = ""; right = "▎"; };
        };
      };

      # keymaps = {
      #   # Reordering tabs
      #   moveNext = "<m-s-j>";
      #   movePrevious = "<m-s-k>";
      #   pin = "<m-p>";
      #
      #   # Navigating tabs
      #   next = "<m-j>";
      #   previous = "<m-k>";
      #   goTo1 = "<m-1>";
      #   goTo2 = "<m-2>";
      #   goTo3 = "<m-3>";
      #   goTo4 = "<m-4>";
      #   goTo5 = "<m-5>";
      #   goTo6 = "<m-6>";
      #   goTo7 = "<m-7>";
      #   goTo8 = "<m-8>";
      #   goTo9 = "<m-9>";
      #   last = "<m-0>";
      #
      #   # Close tab
      #   close = "<m-x>";
      # };
    };

    maps.normal = {
      # Reordering tabs
      "<m-s-j>" = "<cmd>BufferMoveNext<cr>";
      "<m-s-k>" = "<cmd>BufferMovePrevious<cr>";
      "<m-p>" = "<cmd>BufferPin<cr>";

      # Navigating tabs
      "<m-j>" = "<cmd>BufferNext<cr>";
      "<m-k>" = "<cmd>BufferPrevious<cr>";
      "<m-1>" = "<cmd>BufferGoto 1<cr>";
      "<m-2>" = "<cmd>BufferGoto 2<cr>";
      "<m-3>" = "<cmd>BufferGoto 3<cr>";
      "<m-4>" = "<cmd>BufferGoto 4<cr>";
      "<m-5>" = "<cmd>BufferGoto 5<cr>";
      "<m-6>" = "<cmd>BufferGoto 6<cr>";
      "<m-7>" = "<cmd>BufferGoto 7<cr>";
      "<m-8>" = "<cmd>BufferGoto 8<cr>";
      "<m-9>" = "<cmd>BufferGoto 9<cr>";
      "<m-0>" = "<cmd>BufferLast<cr>";

      # Close tab
      "<m-x>" = "<cmd>BufferClose<cr>";
    };
  };
}
