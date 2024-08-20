{
  config,
  pkgs,
  impermanence,
  ...
}: {
  imports = [
    impermanence.nixosModule
  ];

 # fileSystems."/persist".options = ["compress=zstd" "noatime"];
  #fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
 };
}
