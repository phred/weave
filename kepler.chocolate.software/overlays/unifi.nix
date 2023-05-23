self: super:
let
    unifiVersion = "7.3.83";
    unifiHash = "9836c5f6f7e85a3bc007170e2119e04ad8e2ef106596065f521540f6417a1115";
in
{
  unifiCustom = super.unifi.overrideAttrs(attrs: {
    name = "unifi-controller-${unifiVersion}";
    src = self.fetchurl {
        url = "https://dl.ubnt.com/unifi/${unifiVersion}/unifi_sysvinit_all.deb";
        sha256 = unifiHash;
    };
  });
}