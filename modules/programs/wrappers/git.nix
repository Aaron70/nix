{ ... }: 

{ 
  flake.wrappers.git = { wlib, ... }:
  {
    imports = [ wlib.wrapperModules.git ];
    settings = {
      core = {
        editor = "nvim";
        autocrlf = false;
      };
      pull = {
        rebase = true;
      };
      alias = {
        st = "status";
        lg = "log --oneline --graph";
      };
    };
  };
}
