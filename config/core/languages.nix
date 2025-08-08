# Global language configuration
# Extracted from lang/default.nix to make it configurable
{
  config.vim.languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = false;
    enableDAP = false;
  };
}