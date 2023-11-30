{
  description = "System flake for wizard-spire";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [  pkgs.fish
           pkgs.jless
           pkgs.jq
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      networking = {
        localHostName="Wizard-Spire";
        hostName="wizard-spire.auroch-bebop.ts.net";
      };

      # programs.ssh.knownHosts
      # programs.tmux.enable
      # users.user.<name>.openssh.authorizedKeys.keyFiles / .keys
      # fonts.fonts
      # homebrew.enable
      # homebrew.brews
      # services.tailscale.enable

      # Define a user account. Don't forget to set a password with ‘passwd’.
      # users.fred = {
        # isNormalUser = true;
        # extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
        # packages = with pkgs; [
        # ];
      users.users.fred = {
        openssh.authorizedKeys.keys = [ "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBK1yqrG2Wka4Oc4pMFpYprhjvewNnD4pC5OBx2UWJk7wc7mDM2ZT3+hqLZ9wBA3GDNPg0PetUNDz3OlF5WYlSPU= fred@Grim.local" ];
        # hashedPassword = "$6$HKD4AZMBXuKbDI2B$jOef1pEvI6XLigVz/O.G0ubltUbF5dLoCdMrWCA7VNNvypdCkKLBd4zaDjC6iIRzi639KnCahoOnswIZTgYwt0";
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#wizard-spire
    darwinConfigurations."wizard-spire" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    # darwinPackages = self.darwinConfigurations."Wizard-Spire".pkgs;
  };
}
