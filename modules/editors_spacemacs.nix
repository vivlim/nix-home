{ pkgs, ... }: 
{
  home.packages = [ pkgs.emacs ];

  #home.file.".emacs.d" = {
    # don't make the directory read only so that impure melpa can still happen
    # for now
    #recursive = true;
    #source = pkgs.fetchFromGitHub {
      #owner = "syl20bnr";
      #repo = "spacemacs";
      #rev = "f1c7979b63a9f0d01c38348177ed27094d95de75";
      #sha256 = "sha256-yBCCJ+zn4AnHpPD4cdDFz9aoR1y17RvFp7rAdp4NAd8=";
    #};
  #};
}
