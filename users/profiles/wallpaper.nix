{ self, ... }: {
  home.file.".background-image" = {
    source = "${self}/profiles/graphical/wallpaper.png";
  };
}
