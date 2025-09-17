{
  inputs,
  pkgs,
  ...
}:
let
  # Import the git-dev module with inputs passed through
  gitDevModule = import ./plugins/optional/git-dev-nvim.nix { inherit inputs pkgs; };
  snacksModule = import ./plugins/optional/snacks-nvim.nix { inherit inputs pkgs; };
in
{
  imports = [
    ./minimal.nix
    gitDevModule
    snacksModule
    ./plugins/optional/themery-nvim.nix
    ./plugins/optional/commasemi-nvim.nix
    ./config/optional/notes.nix
  ];

  # Enhanced git integration with comprehensive gutter information
  config.vim = {
    git = {
      enable = true;
      gitsigns = {
        enable = true;
        codeActions.enable = true;
      };
    };

    # Enhanced diagnostics for comprehensive gutter information
    diagnostics = {
      enable = true;
      config = {
        signs = {
          text = {
            ERROR = "";
            WARN = "";
            INFO = "";
            HINT = "";
          };
          numhl = {
            ERROR = "DiagnosticSignError";
            WARN = "DiagnosticSignWarn";  
            INFO = "DiagnosticSignInfo";
            HINT = "DiagnosticSignHint";
          };
          linehl = {};
        };
        severity_sort = true;
        float = {
          focusable = false;
          style = "minimal";
          border = "rounded";
          source = "always";
          header = "";
          prefix = "";
        };
        virtual_text = {
          spacing = 4;
          source = "if_many";
          prefix = "●";
        };
        update_in_insert = false;
      };
    };
  };
}
