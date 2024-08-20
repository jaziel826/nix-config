{ inputs, config, pkgs, ...}:
{
  sops = {
   
    defaultSopsFile = ../secrets.yaml;
    validateSopsFiles = false;
    age = {
      # automatically import host SSH key
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;

      };

    secrets = {
      tailscale-auth = {};
    };
  };
}
