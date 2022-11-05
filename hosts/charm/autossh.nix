{
  services.autossh.sessions = [{
      name = "charm";
      user = "rummik";
      monitoringPort = 20000;
      extraArguments = "rummik.com -t tmux at";
  }];
}
