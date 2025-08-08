{ inputs, pkgs, ... }:
let
  # Import the themery module with inputs passed through
  themeryModule = import ./plugins/optional/themery-nvim.nix { inherit inputs pkgs; };
  # Import the nvim-bacon module with inputs passed through
  nvimBaconModule = import ./plugins/optional/nvim-bacon.nix { inherit inputs pkgs; };
  # Import the beepboop module with inputs passed through
  beepboopModule = import ./plugins/optional/beepboop-nvim.nix { inherit inputs pkgs; };
  # Import the heirline module with inputs passed through
  heirlineModule = import ./plugins/optional/heirline-nvim.nix { inherit inputs pkgs; };
  # Import the lsp-lines module with inputs passed through
  lspLinesModule = import ./plugins/optional/lsp-lines-nvim.nix { inherit inputs pkgs; };
  # Import the diaglist module with inputs passed through
  diaglistModule = import ./plugins/optional/diaglist-nvim.nix { inherit inputs pkgs; };
  # Import the wtf module with inputs passed through
  wtfModule = import ./plugins/optional/wtf-nvim.nix { inherit inputs pkgs; };
  # Import the workspace-diagnostics module with inputs passed through
  workspaceDiagnosticsModule = import ./plugins/optional/workspace-diagnostics-nvim.nix {
    inherit inputs pkgs;
  };
  # Import the lean module with inputs passed through
  leanModule = import ./plugins/optional/lean-nvim.nix { inherit inputs pkgs; };
in
{
  imports = [
    ./minimal.nix
    themeryModule
    nvimBaconModule
    beepboopModule
    heirlineModule
    lspLinesModule
    diaglistModule
    wtfModule
    workspaceDiagnosticsModule
    leanModule
  ];

  # Disable lualine in favor of heirline for the full version
  config.vim.statusline.lualine.enable = pkgs.lib.mkForce false;
}
