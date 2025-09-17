{
  config.vim = {
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
          linehl = { };
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
