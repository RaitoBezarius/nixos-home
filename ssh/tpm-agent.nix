{ pkgs, ... }: {
  systemd.user.services.ssh-tpm-agent = {
    Unit = {
      Description = "SSH TPM agent service";
      Documentation = "man:ssh-agent(1) man:ssh-add(1) man:ssh(1)";
      Requires = "ssh-tpm-agent.socket";
      ConditionEnvironment = "!SSH_AGENT_PID";
    };
    Service = {
      Environment = "SSH_AUTH_SOCK=%t/ssh-tpm-agent.socket";
      ExecStart = "${pkgs.ssh-tpm-agent}/bin/ssh-tpm-agent";
      PassEnvironment = "SSH_AGENT_PID";
      SuccessExitStatus = 2;
      Type = "simple";
    };
    Install.Also = "ssh-agent.socket";
  };

  systemd.user.sockets.ssh-tpm-agent = {
    Unit = {
      Description = "SSH TPM agent socket";
      Documentation = "man:ssh-agent(1) man:ssh-add(1) man:ssh(1)";
    };

    Socket = {
      ListenStream = "%t/ssh-tpm-agent.sock";
      SocketMode = "0600";
      Service = "ssh-tpm-agent.service";
    };

    Install.WantedBy = [ "sockets.target" ];
  };
}
