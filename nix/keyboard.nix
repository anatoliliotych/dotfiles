{
  config,
  lib,
  ...
}:

{
  # CapsLock acts as the Globe key on every keyboard (global HID mapping;
  # no per-keyboard vendor/product entries needed).  This runs in
  # home-manager activation because it targets the ByHost global domain
  # (-currentHost -g), which has no nix-darwin typed option, and the
  # darwin activation runs as root with HOME=/var/root while HM runs as
  # the user.  The values are HID usage codes: 30064771129 = 0x700000039
  # (CapsLock), 1095216660483 = 0xFF00000003 (Globe).  A per-keyboard
  # mapping configured via System Settings coexists and maps the same
  # pair, so there is no conflict.
  #
  # Symbolic hotkeys and input sources live in darwin.nix as
  # system.defaults.CustomUserPreferences.
  home.activation.keyboardDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # -int keeps the elements integers (a bare -array writes strings,
    # which macOS ignores for HID mappings); delete first so repeated
    # activations replace instead of appending.
    /usr/bin/defaults -currentHost delete -g HIDKeyboardModifierMappingSrc 2>/dev/null || true
    /usr/bin/defaults -currentHost delete -g HIDKeyboardModifierMappingDst 2>/dev/null || true
    /usr/bin/defaults -currentHost write -g HIDKeyboardModifierMappingSrc -array-add -int 30064771129
    /usr/bin/defaults -currentHost write -g HIDKeyboardModifierMappingDst -array-add -int 1095216660483
  '';
}
