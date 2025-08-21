{ pkgs, ... }:
{
  config.vim.languages.rust = {
    enable = true;
    crates = {
      enable = true;
      codeActions = true;
    };
    # dap.enable = false;
    format = {
      enable = true;
      type = "rustfmt";
    };
    lsp = {
      enable = true;
      package = pkgs.rust-analyzer;
      # [docs](https://rust-analyzer.github.io/book/configuration#assist.termSearch.borrowcheck)
      opts = ''
        ['rust-analyzer'] = {
          cargo = {
            features = "all",
            allTargets = true,
            autoreload = true,
            buildScripts = {
              enable = true,
            },
            targetDir = true,
          },
          checkOnSave = true,
          check = {
            allTargets = true,
            features = "all",
          },
          procMacro = {
            enable = true,
          },
          assist = {
            emitMustUse = true,
            preferSelf = true,
            termSearch = {
              borrowcheck = true,
              fuel = 3600,
            },
          },
          completion = {
            addSemicolonToUnit = true,
            autoAwait = {enable = true},
            autoIter = {enable = true},
            autoImport = {enable = true},
            autoself = {enable = true},
            fullFunctionSignatures = {enable = true},
            privateEditable = {enable = true},
            termSearch = {enable = true},
          },
          diagnostics = {
            styleLints = {enable = true},
          },
          hover = {
            actions = {
              references = {enable = true},
            },
            memoryLayout = {
              niches = true,
            },
          },
          imports = {
            granularity = {
              enforce = true,
              group = "crate",
            },
            merge = {glob = false},
            preferPrelude = true,
          },
          inlayHints = {
            bindingModeHints = {enable = true},
            closingBraceHints = {
              minLines = 2,
            },
            closureCaptureHints = {enable = true},
            closureReturnTypeHints = {enable = true},
            discriminantHints = {enable = true},
            genericParameterHints = {
              lifetime = {enable = true},
              type = {enable = true},
            },
            implicitDrops = {enable = true},
          },
          interpret = {tests = true},
          lens = {
            enable = true,
            references = {
              adt = {enable = true},
              enumVariant = {enable = true},
              method = {enable = true},
              trait = {enable = true},
            },

          },
          semanticHighlighting = {
            operator = {
              specialization = {enable = true},
            },
            punctuation = {
              enable = true,
              seperate = {
                macro = {bang = true},
              },
              specialization = {enable = true},
            },
          },
        },
      '';
    };
    treesitter.enable = true;
  };
}
