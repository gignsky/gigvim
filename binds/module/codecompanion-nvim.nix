{
  config.vim.keymaps = [
    # WhichKey group description for AI Assistant
    {
      key = "<leader>a";
      mode = "n";
      action = "";
      desc = "+AI Assistant";
    }

    # CodeCompanion Chat toggle
    {
      key = "<leader>ac";
      mode = "n";
      silent = true;
      action = "<cmd>CodeCompanionChat<cr>";
      desc = "Toggle AI Chat";
    }
    {
      key = "<leader>ac";
      mode = "v";
      silent = true;
      action = "<cmd>CodeCompanionChat<cr>";
      desc = "Toggle AI Chat with selection";
    }

    # CodeCompanion Action Palette
    {
      key = "<leader>aa";
      mode = "n";
      silent = true;
      action = "<cmd>CodeCompanionActions<cr>";
      desc = "AI Action Palette";
    }
    {
      key = "<leader>aa";
      mode = "v";
      silent = true;
      action = "<cmd>CodeCompanionActions<cr>";
      desc = "AI Action Palette with selection";
    }

    # Inline AI assistant (visual mode)
    {
      key = "<leader>ai";
      mode = "v";
      silent = true;
      action = "<cmd>CodeCompanionInline<cr>";
      desc = "AI Inline Suggestion";
    }
    {
      key = "<leader>ai";
      mode = "n";
      silent = true;
      action = "<cmd>CodeCompanionInline<cr>";
      desc = "AI Inline Suggestion";
    }

    # Add file to chat context
    {
      key = "<leader>af";
      mode = "n";
      silent = true;
      action = "<cmd>CodeCompanionChat /file<cr>";
      desc = "Add file to chat";
    }

    # Explain selected code - uses prompt library
    {
      key = "<leader>ae";
      mode = "v";
      silent = true;
      action = "<cmd>CodeCompanionChat Explain<cr>";
      desc = "Explain selected code";
    }
  ];
}
