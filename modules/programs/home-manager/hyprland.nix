{ config, pkgs, inputs, ... }:

{
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
}
