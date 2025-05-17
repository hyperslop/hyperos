{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/firefox/userfirefox.nix
  ];

  home.username = "hyperslop";
  home.homeDirectory = "/home/hyperslop";

  programs.git = {
    enable = true;
    userName = "hyperslop";
    userEmail = "hyperslop@proton.me";
    extraConfig = {
    #git default branch is master, on git hosting sites its main.
	init.defaultBranch = "main";
	#solves dubious ownership warning
	safe.directory = "/etc/nixos/";
    };
  };

  home.stateVersion = "24.11";


  home.packages = [

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

  };

  #program.kitty.enable = true;
  wayland.windowManager.hyprland = {
    
    enable = true;

    #plugins = [
    #  inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
    #];

    settings = {
      "$mod" = "SUPER";
      bind =
        [
	  "$mod, F, exec, firefox"
	  ", Print, exec, grimblast copy area"
	]
	++ (
	# workspaces
	# binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
	builtins.concatLists (builtins.genList (i:
	  let ws = i + 1;
	  in [
	    "$mod, code:1${toString i}, workspace, ${toString ws}"
	    "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
	    ]
	  )
	  9)
	);
      };
     
    #  "plugin:borders-plus-plus" = {
    #    add_borders = 1; # 0 - 9
    #
        # you can add up to 9 borders
    #    "col.border_1" = "rgb(ffffff)";
    #    "col.border_2" = "rgb(2222ff)";

        # -1 means "default" as in the one defined in general:border_size
    #   border_size_1 = 10;
    #    border_size_2 = -1;

        # makes outer edges match rounding of the parent. Turn on/off to better understand. Default = on.
    #    natural_rounding = "yes";
    #  };
    #};
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/hyperslop/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
