{ pkgs, config, lib, ... }:
{
  imports = [
    ./options.nix
  ] ++ lib.optionals config.gigvim.languages.bash [ ./bash.nix ]
    ++ lib.optionals config.gigvim.languages.nix [ ./nix.nix ]
    ++ lib.optionals config.gigvim.languages.nu [ ./nu.nix ]
    ++ lib.optionals config.gigvim.languages.python [ ./python.nix ]
    ++ lib.optionals config.gigvim.languages.rust [ ./rust.nix ]
    ++ lib.optionals config.gigvim.languages.sql [ ./sql.nix ]
    ++ lib.optionals config.gigvim.languages.toml [ ./toml.nix ]
    ++ lib.optionals config.gigvim.languages.yaml [ ./yaml.nix ]
    ++ lib.optionals config.gigvim.languages.lean [ ./lean.nix ];
}
