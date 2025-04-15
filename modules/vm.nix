{
  config,
  pkgs,
  ...
}:
{
programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
      spiceUSBRedirection.enable = true;
  };

users.groups.libvirtd.members = ["jaziel"];

#virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-viewer
    virtio-win
    win-spice
  ];

#virtualisation.spiceUSBRedirection.enable = true;
services.qemuGuest.enable = true;
services.spice-vdagentd.enable = true;  # enable copy and paste between host and guest

home-manager.users.${username} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
};
};
