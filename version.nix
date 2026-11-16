# Build-time version stamp. Exposes the version as `vim.g.gigvim_version`
# (e.g. "v0.1.0", "v0.1.0-full", "v0.1.0-mini") and `:GigvimVersion`.
# No plugins are added, so this costs nothing in the minimal closure.
{ version, distro }:
let
  label = "v${version}" + (if distro == null then "" else "-${distro}");
in
{
  config.vim.globals = {
    gigvim_version = label;
    gigvim_distro = if distro == null then "default" else distro;
  };

  config.vim.luaConfigRC.gigvim-version = ''
    vim.api.nvim_create_user_command("GigvimVersion", function()
      print("gigvim " .. vim.g.gigvim_version)
    end, { desc = "Show the gigvim version and distro" })
  '';
}
