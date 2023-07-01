{ pkgs, ... }: {
  programs.plasma.enable = true;

  home.packages = [ pkgs.plasmaPackages.bismuth ];

  programs.plasma.files.kwinrc = {
    files.kwinrc = {
      Plugins.bismuthEnabled = true;

      Script-bismuth = {
        ignoreClass = "yakuake,spectacle,Conky,zoom,plasma.emojier";
        screenGapBottom = 4;
        screenGapLeft = 4;
        screenGapRight = 4;
        screenGapTop = 4;
        tileLayoutGap = 4;
      };
    };
  };

  programs.plasma.shortcuts.bismuth = {
    decrease_master_size = [];
    decrease_master_win_count = [ "Meta+[" "Meta+D" ];
    decrease_window_height = "Meta+Ctrl+K";
    decrease_window_width = "Meta+Ctrl+H";
    focus_bottom_window = "Meta+J";
    focus_left_window = "Meta+H";
    focus_next_window = [];
    focus_prev_window = [];
    focus_right_window = "Meta+L";
    focus_upper_window = "Meta+K";
    increase_master_size = [];
    increase_master_win_count = [ "Meta+I" "Meta+]" ];
    increase_window_height = "Meta+Ctrl+J";
    increase_window_width = "Meta+Ctrl+L";
    move_window_to_bottom_pos = "Meta+Shift+J";
    move_window_to_left_pos = "Meta+Shift+H";
    move_window_to_next_pos = [];
    move_window_to_prev_pos = [];
    move_window_to_right_pos = "Meta+Shift+L";
    move_window_to_upper_pos = "Meta+Shift+K";
    next_layout = "Meta+\\,Meta+\\,Switch to the Next Layout";
    prev_layout = "Meta+|";
    push_window_to_master = "Meta+Return";
    rotate = "Meta+R";
    rotate_part = "Meta+Shift+R";
    rotate_reverse = [];
    toggle_float_layout = "Meta+Shift+F";
    toggle_monocle_layout = "Meta+M";
    toggle_quarter_layout = [];
    toggle_spiral_layout = [];
    toggle_spread_layout = [];
    toggle_stair_layout = [];
    toggle_three_column_layout = [];
    toggle_tile_layout = "Meta+T";
    toggle_window_floating = "Meta+F";
  };
}
