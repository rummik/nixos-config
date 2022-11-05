{
  services.pass-secret-service.enable = true;

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY = "9AE525FD";
    };
  };
}
