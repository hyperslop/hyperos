# Shared helpers for override-aware file resolution.
#
# Naming convention:
#   MODULE.nix         → merge with all lower-priority configs (default)
#   MODULE.override.nix → replace all lower-priority configs; lower files are NOT imported
#
# Usage:
#   let helpers = import ./mkOverrideHelpers.nix { inherit lib; };
#       inherit (helpers) resolveFile applyOverrides resolveFiles;

{ lib }:
let
  # Given a base path (e.g. ../modules/programs/nixos/foo.nix), resolves to:
  #   { path = .../foo.override.nix; isOverride = true;  }  if foo.override.nix exists
  #   { path = .../foo.nix;          isOverride = false; }  if foo.nix exists
  #   null                                                   if neither exists
  resolveFile = path:
    let
      dir = builtins.dirOf path;
      base = builtins.baseNameOf path;
      overridePath = dir + "/${lib.removeSuffix ".nix" base}.override.nix";
    in
    if builtins.pathExists overridePath
    then { path = overridePath; isOverride = true; }
    else if builtins.pathExists path
    then { path = path; isOverride = false; }
    else null;

  # Given a list of nullable {path, isOverride} entries ordered from lowest to
  # highest priority (e.g. [global, host, user]), drops all entries that come
  # before the last (highest-priority) override entry.
  #
  # Examples:
  #   [global, host.override, user]  →  [host.override, user]
  #   [global, host, user.override]  →  [user.override]
  #   [global, host, user]           →  [global, host, user]  (no override, keep all)
  applyOverrides = entries:
    let
      filtered = builtins.filter (x: x != null) entries;
      indexed  = lib.imap0 (i: e: e // { originalIdx = i; }) filtered;
      # Search reversed list so findFirst returns the LAST override
      lastOverride = lib.findFirst (e: e.isOverride) null (lib.reverseList indexed);
      cutIdx = if lastOverride == null then 0 else lastOverride.originalIdx;
    in
    lib.drop cutIdx filtered;

  # Convenience: resolve a list of nullable entries and return just the paths.
  resolveFiles = entries: map (e: e.path) (applyOverrides entries);

in
{ inherit resolveFile applyOverrides resolveFiles; }
