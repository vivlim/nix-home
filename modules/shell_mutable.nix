{ pkgs, lib, system, bonusShellAliases ? {}, ... }: let 
  addLineIfNotPresent = file: line: pkgs.writeScript "updateFile" ''
    if [[ -f ${file} ]]; then
      LINE='${line}'
      FILE="${file}"
      FILE="''${FILE/#\~/$HOME}" # expand tilde

      if ! grep -qF -- "$LINE" "$FILE"; then
        BACKUPDIR="$HOME/.nix_hm/modified_files/"
        BACKUPFILE="$BACKUPDIR/$(basename -- $FILE)_$(date '+%Y-%m-%d_%H-%M-%S')"
        echo "updating $FILE to add '$LINE', backing up to $BACKUPFILE"

        mkdir -p $BACKUPDIR
        cp $FILE $BACKUPFILE
        if [[ $? == 0 ]]; then
          echo "$LINE" >> "$FILE"
        else
          echo "backup failed, did not write to $FILE"
        fi
      fi
    else
      echo "skipping nonexistant ${file}"
    fi
  '';
  
  addShellSourceFileIfPresent = file: sourceTarget: lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${addLineIfNotPresent file "FILE=${sourceTarget} && test -f $FILE && source $FILE"}
  '';
in {
  home.file.".nix_hm/shell_aliases" = {
    text = builtins.toString (lib.attrsets.mapAttrsToList (name: value: "alias ${name}=\"${value}\"\n") bonusShellAliases);
  };

  home.activation = {
    bashSourceRc = addShellSourceFileIfPresent "~/.bashrc" "~/.nix_hm/bashrc";
    bashSourceShellAliases = addShellSourceFileIfPresent "~/.bashrc" "~/.nix_hm/shell_aliases";
    bashSourceHmSessionVars = addShellSourceFileIfPresent "~/.bashrc" "~/.nix-profile/etc/profile.d/hm-session-vars.sh";
    bashSourceProfile = addShellSourceFileIfPresent "~/.bash_profile" "~/.nix_hm/bash_profile";
  } // (if lib.strings.hasSuffix "darwin" system then {
    # on mac, source .bashrc in .bash_profile since terminals create login shells
    bashSourceProfile = addShellSourceFileIfPresent "~/.bash_profile" "~/.bashrc";
  } else {
  });
}
