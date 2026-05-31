{ lib, ... }:
{
  config.vim = {
    # Ensure CodeCompanion loads on command invocation (lazy loading fix)
    lazy.plugins.codecompanion-nvim = {
      cmd = [
        "CodeCompanion"
        "CodeCompanionChat"
        "CodeCompanionActions"
        "CodeCompanionInline"
        "CodeCompanionCmd"
      ];
    };

    # GitHub Copilot for inline completions and auth infrastructure
    assistant.copilot = {
      enable = true;
      setupOpts = {
        suggestion = {
          enabled = true;
          auto_trigger = true;
          keymap = {
            accept = "<M-l>";
            accept_word = "<M-w>";
            accept_line = "<M-'>";
            next = "<M-]>";
            prev = "<M-[>";
            dismiss = "<C-]>";
          };
        };
        panel = {
          enabled = true;
        };
      };
    };

    # CodeCompanion.nvim - Multi-provider AI chat assistant
    assistant.codecompanion-nvim = {
      enable = true;
      setupOpts = {
        # Use GitHub Copilot as the LLM provider
        adapters = lib.generators.mkLuaInline ''
          {
            copilot = require("codecompanion.adapters.copilot"),
          }
        '';

        strategies = {
          chat = {
            adapter = "copilot";
          };
          inline = {
            adapter = "copilot";
          };
        };

        # Display configuration
        display = {
          diff = {
            enabled = true;
            provider = "mini_diff";
            close_chat_at = 240;
            layout = "vertical";
          };
          inline = {
            layout = "vertical";
          };
          chat = {
            auto_scroll = true;
            show_settings = false;
            start_in_insert_mode = true;
            show_header_separator = true;
            show_references = true;
            show_token_count = true;
            show_separator = true;
            separator = "─";
            intro_message = "Welcome to CodeCompanion ✨! Press ? for options.";
            icons = {
              pinned_buffer = " ";
              watched_buffer = "👀 ";
            };
          };
          action_palette = {
            width = 95;
            height = 10;
            prompt = "Prompt ";
            provider = "default";
            opts = {
              show_default_actions = true;
              show_default_prompt_library = true;
            };
          };
        };

        # General options
        opts = {
          send_code = true;
          log_level = "ERROR";
          language = "English";
        };

        # Chat strategy config (slash commands, variables, tools)
        strategies_config = {
          chat = {
            slash_commands = lib.generators.mkLuaInline ''
              {
                ["file"] = {
                  callback = "strategies.chat.slash_commands.file",
                  description = "Select a file to add to the chat",
                  opts = {
                    contains_code = true,
                    max_lines = 1000,
                  },
                },
                ["buffer"] = {
                  callback = "strategies.chat.slash_commands.buffer",
                  description = "Select a buffer to add to the chat",
                  opts = {
                    contains_code = true,
                  },
                },
                ["help"] = {
                  callback = "strategies.chat.slash_commands.help",
                  description = "Search the help docs",
                },
                ["fetch"] = {
                  callback = "strategies.chat.slash_commands.fetch",
                  description = "Fetch content from a URL",
                  opts = {
                    contains_code = false,
                  },
                },
                ["symbols"] = {
                  callback = "strategies.chat.slash_commands.symbols",
                  description = "Search symbols in the workspace",
                  opts = {
                    contains_code = false,
                  },
                },
              }
            '';
            variables = lib.generators.mkLuaInline ''
              {
                ["filetype"] = {
                  callback = "strategies.chat.variables.filetype",
                  description = "Get the filetype of the current buffer",
                },
                ["telescope"] = {
                  callback = "strategies.chat.variables.telescope",
                  description = "Insert a telescope picker result",
                },
                ["register"] = {
                  callback = "strategies.chat.variables.quickfix",
                  description = "Insert the contents of a register",
                },
                ["#buffer"] = {
                  callback = "strategies.chat.variables.buffer",
                  description = "Select a buffer from the current session",
                  opts = {
                    contains_code = true,
                    max_files = 5,
                  },
                },
              }
            '';
            tools = lib.generators.mkLuaInline ''
              {
                ["code_runner"] = {
                  callback = "strategies.chat.tools.code_runner",
                  description = "Run code in the terminal and get the output",
                  opts = {
                    auto_submit = false,
                  },
                },
                ["filesystem"] = {
                  callback = "strategies.chat.tools.filesystem",
                  description = "Search the filesystem for files",
                  opts = {
                    auto_submit = false,
                  },
                },
                ["list_files"] = {
                  callback = "strategies.chat.tools.list_files",
                  description = "List the files in the current working directory",
                  opts = {
                    auto_submit = false,
                  },
                },
                ["diagnostics"] = {
                  callback = "strategies.chat.tools.diagnostics",
                  description = "Get the LSP diagnostics for the current buffer",
                  opts = {
                    auto_submit = true,
                  },
                },
                ["lsp"] = {
                  callback = "strategies.chat.tools.lsp",
                  description = "Get LSP information for the current buffer",
                  opts = {
                    auto_submit = false,
                  },
                },
                ["plenary"] = {
                  callback = "strategies.chat.tools.plenary",
                  description = "Use a plenary job to run a shell command",
                  opts = {
                    auto_submit = false,
                  },
                },
                ["terminal"] = {
                  callback = "strategies.chat.tools.terminal",
                  description = "Run a command in the terminal",
                  opts = {
                    auto_submit = true,
                  },
                },
              }
            '';
          };
        };

        # Prompt library for quick actions
        prompt_library = lib.generators.mkLuaInline ''
          {
            ["Explain"] = {
              strategy = "chat",
              description = "Explain the selected code in detail",
              opts = {
                auto_submit = true,
                user_prompt = "Explain the selected code. Describe what it does, how it works, and any important details.",
                stop_context_insertion = false,
              },
              shortcuts = {
                {
                  key = "<leader>ae",
                  modes = { "v" },
                  description = "Explain selected code",
                },
              },
            },
            ["Review"] = {
              strategy = "chat",
              description = "Review the selected code for issues",
              opts = {
                auto_submit = true,
                user_prompt = "Review the selected code. Identify bugs, security issues, performance problems, and suggest improvements.",
                stop_context_insertion = false,
              },
            },
            ["Fix"] = {
              strategy = "chat",
              description = "Fix issues in the selected code",
              opts = {
                auto_submit = true,
                user_prompt = "Fix any issues in the selected code. Return only the corrected code.",
                stop_context_insertion = false,
              },
            },
            ["Tests"] = {
              strategy = "chat",
              description = "Generate tests for the selected code",
              opts = {
                auto_submit = true,
                user_prompt = "Generate comprehensive unit tests for the selected code.",
                stop_context_insertion = false,
              },
            },
            ["Optimize"] = {
              strategy = "chat",
              description = "Optimize the selected code",
              opts = {
                auto_submit = true,
                user_prompt = "Optimize the selected code for better performance and readability.",
                stop_context_insertion = false,
              },
            },
            ["Docs"] = {
              strategy = "chat",
              description = "Generate documentation for the selected code",
              opts = {
                auto_submit = true,
                user_prompt = "Generate comprehensive documentation and docstrings for the selected code.",
                stop_context_insertion = false,
              },
            },
          }
        '';
      };
    };
  };
}
