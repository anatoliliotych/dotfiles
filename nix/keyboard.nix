{
  config,
  lib,
  ...
}:

{
  # User-preference defaults run in the user's context: the darwin
  # activation script executes as root with HOME=/var/root, so bare
  # `defaults` calls there would write root's preferences.  Home-manager
  # activation runs as the user with the right HOME.
  #
  # Keyboard layer: Option+Space selects the previous input source
  # (macOS default), space-move hotkeys stay at their defaults, Cmd+F10
  # minimizes; US+Russian input sources come from the HIToolbox plist.
  # CapsLock acts as the Globe key on every keyboard (global HID
  # mapping; no per-keyboard vendor/product entries needed).  A
  # per-keyboard mapping configured via System Settings coexists with
  # it and maps the same pair, so there is no conflict.
  home.activation.keyboardDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    /usr/bin/defaults import com.apple.symbolichotkeys ${./keyboard/com.apple.symbolichotkeys.plist}
    /usr/bin/defaults import com.apple.HIToolbox ${./keyboard/com.apple.HIToolbox.plist}
    # -int keeps the elements integers (a bare -array writes strings,
    # which macOS ignores for HID mappings); delete first so repeated
    # activations replace instead of appending.
    /usr/bin/defaults -currentHost delete -g HIDKeyboardModifierMappingSrc 2>/dev/null || true
    /usr/bin/defaults -currentHost delete -g HIDKeyboardModifierMappingDst 2>/dev/null || true
    /usr/bin/defaults -currentHost write -g HIDKeyboardModifierMappingSrc -array-add -int 30064771129
    /usr/bin/defaults -currentHost write -g HIDKeyboardModifierMappingDst -array-add -int 1095216660483
  '';
}
