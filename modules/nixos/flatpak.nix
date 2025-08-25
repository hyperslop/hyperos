{ config, ...}:
{
  services.flatpak.packages = [
    { appId = "org.vinegarhq.Sober"; origin = "flathub";  }
  ];
}
