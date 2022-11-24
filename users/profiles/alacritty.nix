{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) flatten optionals;
  inherit (pkgs.stdenv) isDarwin isLinux isWindows;
in {
  programs.alacritty = {
    enable = false;

    settings = {
      # Configuration for Alacritty, the GPU enhanced terminal emulator.

      # Any items in the `env` entry below will be added as
      # environment variables. Some entries may override variables
      # set by alacritty itself.
      #env = {
      # TERM variable
      #
      # This value is used to set the `$TERM` environment variable for
      # each instance of Alacritty. If it is not present, alacritty will
      # check the local terminfo database and use `alacritty` if it is
      # available, otherwise `xterm-256color` is used.
      #TERM = "xterm-256color";
      #};

      window = {
        # Window dimensions (changes require restart)
        #
        # Specified in number of columns/lines, not pixels.
        # If both are `0`, this setting is ignored.
        dimensions = {
          columns = 0;
          lines = 0;
        };

        # Window position (changes require restart)
        #
        # Specified in number of pixels.
        # If the position is not set, the window manager will handle the placement.
        #position = {
        #  x = 0;
        #  y = 0;
        #};

        # Window padding (changes require restart)
        #
        # Blank space added around the window in pixels. This padding is scaled
        # by DPI and the specified value is always added at both opposing sides.
        padding = {
          x = 1;
          y = 1;
        };

        # Spread additional padding evenly around the terminal content.
        dynamic_padding = true;

        # Window decorations
        #
        # Values for `decorations`:
        #     - full: Borders and title bar
        #     - none: Neither borders nor title bar
        #
        # Values for `decorations` (macOS only):
        #     - transparent: Title bar, transparent background and title bar buttons
        #     - buttonless: Title bar, transparent background, but no title bar buttons
        decorations = "full";

        # Startup Mode (changes require restart)
        #
        # Values for `startup_mode`:
        #   - Windowed
        #   - Maximized
        #   - Fullscreen
        #
        # Values for `startup_mode` (macOS only):
        #   - SimpleFullscreen
        startup_mode = "Windowed";

        # Window title
        #title = "Alacritty";

        # Window class (Linux only):
        #class = "Alacritty";
      };

      scrolling = {
        # Maximum number of lines in the scrollback buffer.
        # Specifying '0' will disable scrolling.
        history = 0;

        # Number of lines the viewport will move for every line scrolled when
        # scrollback is enabled (history > 0).
        multiplier = 3;

        # Faux Scrolling
        #
        # The `faux_multiplier` setting controls the number of lines the terminal
        # should scroll when the alternate screen buffer is active. This is used
        # to allow mouse scrolling for applications like `man`.
        #
        # Specifying `0` will disable faux scrolling.
        faux_multiplier = 3;

        # Scroll to the bottom when new text is written to the terminal.
        auto_scroll = false;
      };

      # Spaces per Tab (changes require restart)
      #
      # This setting defines the width of a tab in cells.
      #
      # Some applications, like Emacs, rely on knowing about the width of a tab.
      # To prevent unexpected behavior in these applications, it's also required to
      # change the `it` value in terminfo when altering this setting.
      tabspaces = 8;

      # Font configuration (changes require restart)
      font = {
        # Normal (roman) font face
        normal = {
          # Font family
          #
          # Default:
          #   - (macOS) Menlo
          #   - (Linux) monospace
          #   - (Windows) Consolas
          family = "Fira Code";

          # The `style` can be specified to pick a specific face.
          style =
            if isDarwin
            then "Retina"
            else "Regular";
        };

        # Bold font face
        bold = {
          # Font family
          #
          # If the bold family is not specified, it will fall back to the
          # value specified for the normal font.
          # =>
          #family = "monospace";

          # The `style` can be specified to pick a specific face.
          style =
            if isDarwin
            then "Retina"
            else "Regular";
        };

        # Italic font face
        #italic = {
        # Font family
        #
        # If the italic family is not specified, it will fall back to the
        # value specified for the normal font.
        #family = "monospace";

        # The `style` can be specified to pick a specific face.
        #style = "Italic";
        #};

        # Point size
        size =
          if isDarwin
          then 10.0
          else 5.0;

        # Offset is the extra space around each character. `offset.y` can be thought of
        # as modifying the line spacing, and `offset.x` as modifying the letter spacing.
        offset = {
          x = 0;
          y = 0;
        };

        # Glyph offset determines the locations of the glyphs within their cells with
        # the default being at the bottom. Increasing `x` moves the glyph to the right,
        # increasing `y` moves the glyph upwards.
        glyph_offset = {
          x = 0;
          y = 0;
        };

        # Thin stroke font rendering (macOS only)
        #
        # Thin strokes are suitable for retina displays, but for non-retina screens
        # it is recommended to set `use_thin_strokes` to `false`
        #
        # macOS >= 10.14.x:
        #
        # If the font quality on non-retina display looks bad then set
        # `use_thin_strokes` to `true` and enable font smoothing by running the
        # following command:
        #   `defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO`
        #
        # This is a global setting and will require a log out or restart to take
        # effect.
        use_thin_strokes = true;
      };

      # If `true`, bold text is drawn using the bright color variants.
      draw_bold_text_with_bright_colors = true;

      # Colors (Colors*K)
      colors = {
        # Default colors
        primary = {
          background = "0x000000";
          foreground = "0xffffff";

          bright_background = "0x1b1b1b";

          # Bright and dim foreground colors
          #
          # The dimmed foreground color is calculated automatically if it is not present.
          # If the bright foreground color is not set, or `draw_bold_text_with_bright_colors`
          # is `false`, the normal foreground color will be used.
          #dim_foreground = "0x9a9a9a";
          #bright_foreground = "0xffffff";
        };

        # Cursor colors
        #
        # Colors which should be used to draw the terminal cursor. If these are unset,
        # the cursor color will be the inverse of the cell color.
        #cursor = {
        #  text = "0x000000";
        #  cursor = "0xffffff";
        #};

        # Selection colors
        #
        # Colors which should be used to draw the selection area. If selection
        # background is unset, selection color will be the inverse of the cell colors.
        # If only text is unset the cell text color will remain the same.
        #selection = {
        #  text = "0xeaeaea";
        #  background = "0x404040";
        #};

        # Normal colors
        normal = {
          black = "0x2e3436";
          red = "0xcc0000";
          green = "0x4e9a06";
          yellow = "0xc4a000";
          blue = "0x3465a4";
          magenta = "0x75507b";
          cyan = "0x06989a";
          white = "0xd3d7cf";
        };

        # Bright colors
        bright = {
          black = "0x555753";
          red = "0xef2929";
          green = "0x8ae234";
          yellow = "0xfce94f";
          blue = "0x729fcf";
          magenta = "0xad7fa8";
          cyan = "0x34e2e2";
          white = "0xeeeeec";
        };

        # Dim colors
        #
        # If the dim colors are not set, they will be calculated automatically based
        # on the `normal` colors.
        #dim = {
        #  black = "0x000000";
        #  red = "0x8c3336";
        #  green = "0x7a8530";
        #  yellow = "0x97822e";
        #  blue = "0x506d8f";
        #  magenta = "0x80638e";
        #  cyan = "0x497e7a";
        #  white = "0x9a9a9a";
        #};

        # Indexed Colors
        #
        # The indexed colors include all colors from 16 to 256.
        # When these are not set, they're filled with sensible defaults.
        #
        # Example:
        #   `{ index = 16; color = "0xff00ff"; }`
        #
        indexed_colors = [];
      };

      # Visual Bell
      #
      # Any time the BEL code is received, Alacritty "rings" the visual bell. Once
      # rung, the terminal background will be set to white and transition back to the
      # default background color. You can control the rate of this transition by
      # setting the `duration` property (represented in milliseconds). You can also
      # configure the transition function by setting the `animation` property.
      #
      # Values for `animation`:
      #   - Ease
      #   - EaseOut
      #   - EaseOutSine
      #   - EaseOutQuad
      #   - EaseOutCubic
      #   - EaseOutQuart
      #   - EaseOutQuint
      #   - EaseOutExpo
      #   - EaseOutCirc
      #   - Linear
      #
      # Specifying a `duration` of `0` will disable the visual bell.
      visual_bell = {
        animation = "EaseOutExpo";
        duration = 0;
        color = "0xffffff";
      };

      # Background opacity
      #
      # Window opacity as a floating point number from `0.0` to `1.0`.
      # The value `0.0` is completely transparent and `1.0` is opaque.
      background_opacity = 0.93;

      selection = {
        semantic_escape_chars = ",│`|:\"' ()[]{}<>";

        # When set to `true`, selected text will be copied to the primary clipboard.
        save_to_clipboard = false;
      };

      # Allow terminal applications to change Alacritty's window title.
      dynamic_title = true;

      cursor = {
        # Cursor style
        #
        # Values for `style`:
        #   - ▇ Block
        #   - _ Underline
        #   - | Beam
        style = "Block";

        # If this is `true`, the cursor will be rendered as a hollow box when the
        # window is not focused.
        unfocused_hollow = true;
      };

      # Live config reload (changes require restart)
      live_config_reload = true;

      # Shell
      #
      # You can set `shell.program` to the path of your favorite shell, e.g. `/bin/fish`.
      # Entries in `shell.args` are passed unmodified as arguments to the shell.
      #
      # Default:
      #   - (Linux/macOS) /bin/bash --login
      #   - (Windows) powershell
      #shell = {
      #  program = "/bin/bash";
      #  args = [
      #    "--login"
      #  ];
      #};

      # Startup directory
      #
      # Directory the shell is started in. If this is unset, or `None`, the working
      # directory of the parent process will be used.
      #working_directory = "None";

      # Windows 10 ConPTY backend (Windows only)
      #
      # This will enable better color support and may resolve other issues,
      # however this API and its implementation is still young and so is
      # disabled by default, as stability may not be as good as the winpty
      # backend.
      #
      # Alacritty will fall back to the WinPTY automatically if the ConPTY
      # backend cannot be initialized.
      enable_experimental_conpty_backend = false;

      # Send ESC (\x1b) before characters when alt is pressed.
      alt_send_esc = true;

      debug = {
        # Display the time it takes to redraw each frame.
        render_timer = false;

        # Keep the log file after quitting Alacritty.
        persistent_logging = false;

        # Log level
        #
        # Values for `log_level`:
        #   - None
        #   - Error
        #   - Warn
        #   - Info
        #   - Debug
        #   - Trace
        log_level = "Warn";

        # Print all received window events.
        print_events = false;

        # Record all characters and escape sequences as test data.
        ref_test = false;
      };

      mouse = {
        # Click settings
        #
        # The `double_click` and `triple_click` settings control the time
        # alacritty should wait for accepting multiple clicks as one double
        # or triple click.
        double_click = {threshold = 300;};
        triple_click = {threshold = 300;};

        # If this is `true`, the cursor is temporarily hidden when typing.
        hide_when_typing = true;

        url = {
          # URL launcher
          #
          # This program is executed when clicking on a text which is recognized as a URL.
          # The URL is always added to the command as the last parameter.
          #
          # When set to `None`, URL launching will be disabled completely.
          #
          # Default:
          #   - (macOS) open
          #   - (Linux) xdg-open
          #   - (Windows) explorer
          #launcher = {
          #  program = "xdg-open";
          #  args = [];
          #};

          # URL modifiers
          #
          # These are the modifiers that need to be held down for opening URLs when clicking
          # on them. The available modifiers are documented in the key binding section.
          modifiers = "Shift";
        };
      };

      # Mouse bindings
      #
      # Mouse bindings are specified as a list of objects, much like the key
      # bindings further below.
      #
      # Each mouse binding will specify a:
      #
      # - `mouse`:
      #
      #   - Middle
      #   - Left
      #   - Right
      #   - Numeric identifier such as `5`
      #
      # - `action` (see key bindings)
      #
      # And optionally:
      #
      # - `mods` (see key bindings)
      #mouse_bindings = [
      #  { mouse = "Middle"; action = "PasteSelection"; }
      #];

      # Key bindings
      #
      # Key bindings are specified as a list of objects. For example, this is the
      # default paste binding:
      #
      #   `{ key = "V"; mods = "Control|Shift"; action = "Paste"; }`
      #
      # Each key binding will specify a:
      #
      # - `key`: Identifier of the key pressed
      #
      #    - A-Z
      #    - F1-F12
      #    - Key0-Key9
      #
      #    A full list with available key codes can be found here:
      #    https://docs.rs/glutin/*/glutin/enum.VirtualKeyCode.html#variants
      #
      #    Instead of using the name of the keys, the `key` field also supports using
      #    the scancode of the desired key. Scancodes have to be specified as a
      #    decimal number. This command will allow you to display the hex scancodes
      #    for certain keys:
      #
      #       `showkey --scancodes`.
      #
      # Then exactly one of:
      #
      # - `chars`: Send a byte sequence to the running application
      #
      #    The `chars` field writes the specified string to the terminal. This makes
      #    it possible to pass escape sequences. To find escape codes for bindings
      #    like `PageUp` (`"\x1b[5~"`), you can run the command `showkey -a` outside
      #    of tmux. Note that applications use terminfo to map escape sequences back
      #    to keys. It is therefore required to update the terminfo when changing an
      #    escape sequence.
      #
      # - `action`: Execute a predefined action
      #
      #   - Copy
      #   - Paste
      #   - PasteSelection
      #   - IncreaseFontSize
      #   - DecreaseFontSize
      #   - ResetFontSize
      #   - ScrollPageUp
      #   - ScrollPageDown
      #   - ScrollLineUp
      #   - ScrollLineDown
      #   - ScrollToTop
      #   - ScrollToBottom
      #   - ClearHistory
      #   - Hide
      #   - Quit
      #   - ToggleFullscreen
      #   - SpawnNewInstance
      #   - ClearLogNotice
      #   - None
      #
      #   (macOS only):
      #   - ToggleSimpleFullscreen: Enters fullscreen without occupying another space
      #
      # - `command`: Fork and execute a specified command plus arguments
      #
      #    The `command` field must be a map containing a `program` string and an
      #    `args` array of command line parameter strings. For example:
      #       `{ program: "alacritty", args: ["-e", "vttest"] }`
      #
      # And optionally:
      #
      # - `mods`: Key modifiers to filter binding actions
      #
      #    - Command
      #    - Control
      #    - Option
      #    - Super
      #    - Shift
      #    - Alt
      #
      #    Multiple `mods` can be combined using `|` like this:
      #       `mods: Control|Shift`.
      #    Whitespace and capitalization are relevant and must match the example.
      #
      # - `mode`: Indicate a binding for only specific terminal reported modes
      #
      #    This is mainly used to send applications the correct escape sequences
      #    when in different modes.
      #
      #    - AppCursor
      #    - AppKeypad
      #    - Alt
      #
      #    A `~` operator can be used before a mode to apply the binding whenever
      #    the mode is *not* active, e.g. `~Alt`.
      #
      # Bindings are always filled by default, but will be replaced when a new
      # binding with the same triggers is defined. To unset a default binding, it can
      # be mapped to the `None` action.
      key_bindings = flatten [
        # (Windows/Linux only)
        #(optionals (isLinux || isWindows) [
        #  { key = "V";        mods = "Control|Shift";   action = "Paste";             }
        #  { key = "C";        mods = "Control|Shift";   action = "Copy";              }
        #  { key = "Insert";   mods = "Shift";           action = "PasteSelection";    }
        #  { key = "Key0";     mods = "Control";         action = "ResetFontSize";     }
        #  { key = "Equals";   mods = "Control";         action = "IncreaseFontSize";  }
        #  { key = "Add";      mods = "Control";         action = "IncreaseFontSize";  }
        #  { key = "Subtract"; mods = "Control";         action = "DecreaseFontSize";  }
        #  { key = "Minus";    mods = "Control";         action = "DecreaseFontSize";  }
        #  { key = "Return";   mods = "Alt";             action = "ToggleFullScreen";  }
        #])

        # (macOS only)
        (optionals isDarwin [
          #{ key = "Key0";     mods = "Command";         action = "ResetFontSize";     }
          #{ key = "Equals";   mods = "Command";         action = "IncreaseFontSize";  }
          #{ key = "Add";      mods = "Command";         action = "IncreaseFontSize";  }
          #{ key = "Minus";    mods = "Command";         action = "DecreaseFontSize";  }
          #{ key = "K";        mods = "Command";         action = "ClearHistory";      }
          #{ key = "K";        mods = "Command";         chars = "\\x0c";              }
          #{ key = "V";        mods = "Command";         action = "Paste";             }
          #{ key = "C";        mods = "Command";         action = "Copy";              }
          #{ key = "H";        mods = "Command";         action = "Hide";              }
          #{ key = "Q";        mods = "Command";         action = "Quit";              }
          #{ key = "W";        mods = "Command";         action = "Quit";              }
          #{ key = "F";        mods = "Command|Control"; action = "ToggleFullScreen";  }

          {
            key = "Key0";
            mods = "Command";
            action = "None";
          }
          {
            key = "Equals";
            mods = "Command";
            action = "None";
          }
          {
            key = "Add";
            mods = "Command";
            action = "None";
          }
          {
            key = "Minus";
            mods = "Command";
            action = "None";
          }
          {
            key = "K";
            mods = "Command";
            action = "None";
          }
          {
            key = "K";
            mods = "Command";
            action = "None";
          }
          {
            key = "V";
            mods = "Command";
            action = "None";
          }
          {
            key = "C";
            mods = "Command";
            action = "None";
          }
          {
            key = "H";
            mods = "Command";
            action = "None";
          }
          {
            key = "Q";
            mods = "Command";
            action = "None";
          }
          {
            key = "W";
            mods = "Command";
            action = "None";
          }
          {
            key = "F";
            mods = "Command|Control";
            action = "None";
          }

          {
            key = "V";
            mods = "Control|Shift";
            action = "Paste";
          }
          {
            key = "C";
            mods = "Control|Shift";
            action = "Copy";
          }
          {
            key = "Insert";
            mods = "Shift";
            action = "PasteSelection";
          }
          {
            key = "Key0";
            mods = "Control";
            action = "ResetFontSize";
          }
          {
            key = "Equals";
            mods = "Control";
            action = "IncreaseFontSize";
          }
          {
            key = "Add";
            mods = "Control";
            action = "IncreaseFontSize";
          }
          {
            key = "Subtract";
            mods = "Control";
            action = "DecreaseFontSize";
          }
          {
            key = "Minus";
            mods = "Control";
            action = "DecreaseFontSize";
          }
          #{ key = "Return";   mods = "Alt";             action = "ToggleFullScreen";  }
        ])

        {
          key = "N";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
        {
          key = "Paste";
          action = "Paste";
        }
        {
          key = "Copy";
          action = "Copy";
        }
        {
          key = "L";
          mods = "Control";
          action = "ClearLogNotice";
        }
        {
          key = "L";
          mods = "Control";
          chars = "\\x0c";
        }
        {
          key = "Home";
          mods = "Alt";
          chars = "\\x1b[1;3H";
        }
        {
          key = "Home";
          chars = "\\x1bOH";
          mode = "AppCursor";
        }
        {
          key = "Home";
          chars = "\\x1b[H";
          mode = "~AppCursor";
        }
        {
          key = "End";
          mods = "Alt";
          chars = "\\x1b[1;3F";
        }
        {
          key = "End";
          chars = "\\x1bOF";
          mode = "AppCursor";
        }
        {
          key = "End";
          chars = "\\x1b[F";
          mode = "~AppCursor";
        }
        {
          key = "PageUp";
          mods = "Shift";
          action = "ScrollPageUp";
          mode = "~Alt";
        }
        {
          key = "PageUp";
          mods = "Shift";
          chars = "\\x1b[5;2~";
          mode = "Alt";
        }
        {
          key = "PageUp";
          mods = "Control";
          chars = "\\x1b[5;5~";
        }
        {
          key = "PageUp";
          mods = "Alt";
          chars = "\\x1b[5;3~";
        }
        {
          key = "PageUp";
          chars = "\\x1b[5~";
        }
        {
          key = "PageDown";
          mods = "Shift";
          action = "ScrollPageDown";
          mode = "~Alt";
        }
        {
          key = "PageDown";
          mods = "Shift";
          chars = "\\x1b[6;2~";
          mode = "Alt";
        }
        {
          key = "PageDown";
          mods = "Control";
          chars = "\\x1b[6;5~";
        }
        {
          key = "PageDown";
          mods = "Alt";
          chars = "\\x1b[6;3~";
        }
        {
          key = "PageDown";
          chars = "\\x1b[6~";
        }
        {
          key = "Tab";
          mods = "Shift";
          chars = "\\x1b[Z";
        }
        {
          key = "Back";
          chars = "\\x7f";
        }
        {
          key = "Back";
          mods = "Alt";
          chars = "\\x1b\\x7f";
        }
        {
          key = "Insert";
          chars = "\\x1b[2~";
        }
        {
          key = "Delete";
          chars = "\\x1b[3~";
        }
        {
          key = "Left";
          mods = "Shift";
          chars = "\\x1b[1;2D";
        }
        {
          key = "Left";
          mods = "Control";
          chars = "\\x1b[1;5D";
        }
        {
          key = "Left";
          mods = "Alt";
          chars = "\\x1b[1;3D";
        }
        {
          key = "Left";
          chars = "\\x1b[D";
          mode = "~AppCursor";
        }
        {
          key = "Left";
          chars = "\\x1bOD";
          mode = "AppCursor";
        }
        {
          key = "Right";
          mods = "Shift";
          chars = "\\x1b[1;2C";
        }
        {
          key = "Right";
          mods = "Control";
          chars = "\\x1b[1;5C";
        }
        {
          key = "Right";
          mods = "Alt";
          chars = "\\x1b[1;3C";
        }
        {
          key = "Right";
          chars = "\\x1b[C";
          mode = "~AppCursor";
        }
        {
          key = "Right";
          chars = "\\x1bOC";
          mode = "AppCursor";
        }
        {
          key = "Up";
          mods = "Shift";
          chars = "\\x1b[1;2A";
        }
        {
          key = "Up";
          mods = "Control";
          chars = "\\x1b[1;5A";
        }
        {
          key = "Up";
          mods = "Alt";
          chars = "\\x1b[1;3A";
        }
        {
          key = "Up";
          chars = "\\x1b[A";
          mode = "~AppCursor";
        }
        {
          key = "Up";
          chars = "\\x1bOA";
          mode = "AppCursor";
        }
        {
          key = "Down";
          mods = "Shift";
          chars = "\\x1b[1;2B";
        }
        {
          key = "Down";
          mods = "Control";
          chars = "\\x1b[1;5B";
        }
        {
          key = "Down";
          mods = "Alt";
          chars = "\\x1b[1;3B";
        }
        {
          key = "Down";
          chars = "\\x1b[B";
          mode = "~AppCursor";
        }
        {
          key = "Down";
          chars = "\\x1bOB";
          mode = "AppCursor";
        }
        {
          key = "F1";
          chars = "\\x1bOP";
        }
        {
          key = "F2";
          chars = "\\x1bOQ";
        }
        {
          key = "F3";
          chars = "\\x1bOR";
        }
        {
          key = "F4";
          chars = "\\x1bOS";
        }
        {
          key = "F5";
          chars = "\\x1b[15~";
        }
        {
          key = "F6";
          chars = "\\x1b[17~";
        }
        {
          key = "F7";
          chars = "\\x1b[18~";
        }
        {
          key = "F8";
          chars = "\\x1b[19~";
        }
        {
          key = "F9";
          chars = "\\x1b[20~";
        }
        {
          key = "F10";
          chars = "\\x1b[21~";
        }
        {
          key = "F11";
          chars = "\\x1b[23~";
        }
        {
          key = "F12";
          chars = "\\x1b[24~";
        }
        {
          key = "F1";
          mods = "Shift";
          chars = "\\x1b[1;2P";
        }
        {
          key = "F2";
          mods = "Shift";
          chars = "\\x1b[1;2Q";
        }
        {
          key = "F3";
          mods = "Shift";
          chars = "\\x1b[1;2R";
        }
        {
          key = "F4";
          mods = "Shift";
          chars = "\\x1b[1;2S";
        }
        {
          key = "F5";
          mods = "Shift";
          chars = "\\x1b[15;2~";
        }
        {
          key = "F6";
          mods = "Shift";
          chars = "\\x1b[17;2~";
        }
        {
          key = "F7";
          mods = "Shift";
          chars = "\\x1b[18;2~";
        }
        {
          key = "F8";
          mods = "Shift";
          chars = "\\x1b[19;2~";
        }
        {
          key = "F9";
          mods = "Shift";
          chars = "\\x1b[20;2~";
        }
        {
          key = "F10";
          mods = "Shift";
          chars = "\\x1b[21;2~";
        }
        {
          key = "F11";
          mods = "Shift";
          chars = "\\x1b[23;2~";
        }
        {
          key = "F12";
          mods = "Shift";
          chars = "\\x1b[24;2~";
        }
        {
          key = "F1";
          mods = "Control";
          chars = "\\x1b[1;5P";
        }
        {
          key = "F2";
          mods = "Control";
          chars = "\\x1b[1;5Q";
        }
        {
          key = "F3";
          mods = "Control";
          chars = "\\x1b[1;5R";
        }
        {
          key = "F4";
          mods = "Control";
          chars = "\\x1b[1;5S";
        }
        {
          key = "F5";
          mods = "Control";
          chars = "\\x1b[15;5~";
        }
        {
          key = "F6";
          mods = "Control";
          chars = "\\x1b[17;5~";
        }
        {
          key = "F7";
          mods = "Control";
          chars = "\\x1b[18;5~";
        }
        {
          key = "F8";
          mods = "Control";
          chars = "\\x1b[19;5~";
        }
        {
          key = "F9";
          mods = "Control";
          chars = "\\x1b[20;5~";
        }
        {
          key = "F10";
          mods = "Control";
          chars = "\\x1b[21;5~";
        }
        {
          key = "F11";
          mods = "Control";
          chars = "\\x1b[23;5~";
        }
        {
          key = "F12";
          mods = "Control";
          chars = "\\x1b[24;5~";
        }
        {
          key = "F1";
          mods = "Alt";
          chars = "\\x1b[1;6P";
        }
        {
          key = "F2";
          mods = "Alt";
          chars = "\\x1b[1;6Q";
        }
        {
          key = "F3";
          mods = "Alt";
          chars = "\\x1b[1;6R";
        }
        {
          key = "F4";
          mods = "Alt";
          chars = "\\x1b[1;6S";
        }
        {
          key = "F5";
          mods = "Alt";
          chars = "\\x1b[15;6~";
        }
        {
          key = "F6";
          mods = "Alt";
          chars = "\\x1b[17;6~";
        }
        {
          key = "F7";
          mods = "Alt";
          chars = "\\x1b[18;6~";
        }
        {
          key = "F8";
          mods = "Alt";
          chars = "\\x1b[19;6~";
        }
        {
          key = "F9";
          mods = "Alt";
          chars = "\\x1b[20;6~";
        }
        {
          key = "F10";
          mods = "Alt";
          chars = "\\x1b[21;6~";
        }
        {
          key = "F11";
          mods = "Alt";
          chars = "\\x1b[23;6~";
        }
        {
          key = "F12";
          mods = "Alt";
          chars = "\\x1b[24;6~";
        }
        {
          key = "F1";
          mods = "Super";
          chars = "\\x1b[1;3P";
        }
        {
          key = "F2";
          mods = "Super";
          chars = "\\x1b[1;3Q";
        }
        {
          key = "F3";
          mods = "Super";
          chars = "\\x1b[1;3R";
        }
        {
          key = "F4";
          mods = "Super";
          chars = "\\x1b[1;3S";
        }
        {
          key = "F5";
          mods = "Super";
          chars = "\\x1b[15;3~";
        }
        {
          key = "F6";
          mods = "Super";
          chars = "\\x1b[17;3~";
        }
        {
          key = "F7";
          mods = "Super";
          chars = "\\x1b[18;3~";
        }
        {
          key = "F8";
          mods = "Super";
          chars = "\\x1b[19;3~";
        }
        {
          key = "F9";
          mods = "Super";
          chars = "\\x1b[20;3~";
        }
        {
          key = "F10";
          mods = "Super";
          chars = "\\x1b[21;3~";
        }
        {
          key = "F11";
          mods = "Super";
          chars = "\\x1b[23;3~";
        }
        {
          key = "F12";
          mods = "Super";
          chars = "\\x1b[24;3~";
        }
        {
          key = "NumpadEnter";
          chars = "\n";
        }
      ];
    };
  };
}