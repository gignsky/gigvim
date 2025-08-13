# beepboop.nvim Plugin Configuration  
# Audio feedback plugin for Neovim with minecraft block sounds
# Repository: https://github.com/EggbertFluffle/beepboop.nvim
#
# beepboop.nvim provides audio feedback for various Neovim actions,
# creating a more immersive editing experience with sound effects.
# This configuration uses minecraft block sounds for different file types.
#
# Features enabled:
# - Audio feedback on cursor movement, text insertion, deletion
# - Different sounds for different file types (rust, nix, toml, yaml, bash, nu, python)
# - Volume control and sound customization
# - Event-based sound triggering
#
# Sound mapping by file type:
# - Rust files: Netherite block sounds (strong, metallic for systems programming)
# - Nix files: Sculk sounds (mysterious, functional programming vibes)
# - TOML files: Tuff sounds (solid, configuration-like)
# - YAML files: Bamboo sounds (structured, organic data format)
# - Bash/shell files: Vine sounds (scripting, growing automation)
# - Nu shell files: Spore blossom sounds (modern, blooming shell)
# - Python files: Mud bricks sounds (earthy, versatile, building blocks)
# - Default: Cobweb sounds (neutral, web-like connections)
#
# Settings configured:
# - File type specific sound mappings
# - Volume levels optimized for coding
# - Event triggers for typing, movement, and edits
#
# Settings still need to be configured:
# - User customizable volume controls
# - Per-project sound themes
# - Additional file type mappings
# - Integration with LSP events for error/success sounds

{ inputs, pkgs, ... }:
let
  beepboop-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "beepboop-nvim";
    src = inputs.beepboop-nvim;
  };
  
  # Get the absolute path to minecraft sounds
  soundPath = "/home/runner/work/gigvim/gigvim/resources/sounds/minecraft";
in
{
  config.vim.extraPlugins = {
    beepboop = {
      package = beepboop-from-source;
      setup = ''
        -- Helper function to get random sound from a block type
        local function get_random_sound(block_type, action)
          local sound_dir = "${soundPath}/block/" .. block_type
          action = action or "step"
          
          -- List of possible sound numbers (most minecraft blocks have 1-6 variants)
          local variants = {"1", "2", "3", "4", "5", "6"}
          local random_variant = variants[math.random(#variants)]
          local sound_file = sound_dir .. "/" .. action .. random_variant .. ".ogg"
          
          -- Check if file exists, fallback to step1 if not
          local file = io.open(sound_file, "r")
          if file then
            file:close()
            return sound_file
          else
            return sound_dir .. "/step1.ogg"
          end
        end
        
        -- File type to block type mapping
        local file_type_sounds = {
          rust = "netherite",      -- Strong metallic sounds for systems programming
          nix = "sculk",           -- Mysterious functional programming vibes  
          toml = "tuff",           -- Solid configuration sounds
          yaml = "bamboo_wood_hanging_sign", -- Structured organic data
          yml = "bamboo_wood_hanging_sign",  -- YAML alias
          sh = "vine",             -- Scripting, growing automation
          bash = "vine",           -- Shell scripting
          zsh = "vine",            -- Shell scripting  
          fish = "vine",           -- Shell scripting
          nu = "spore_blossom",    -- Modern blooming shell
          python = "mud_bricks",   -- Earthy versatile building blocks
          py = "mud_bricks",       -- Python alias
          lua = "end_portal",      -- Mystical embedded language
          default = "cobweb"       -- Neutral web-like connections
        }
        
        -- Get current file type and determine block sound
        local function get_current_sound(action)
          local filetype = vim.bo.filetype
          local block_type = file_type_sounds[filetype] or file_type_sounds.default
          return get_random_sound(block_type, action)
        end
        
        require('beepboop').setup({
          -- Volume settings (0.0 to 1.0)
          volume = 0.3,
          
          -- Enable/disable sound for different events
          events = {
            on_insert_enter = true,
            on_insert_leave = true,
            on_cursor_moved = false, -- Disabled to avoid too much noise
            on_text_changed = true,
            on_text_deleted = true,
          },
          
          -- Sound configuration function
          get_sound = function(event)
            local action = "step"
            
            -- Map events to different actions for variety
            if event == "insert_enter" then
              action = "step"
            elseif event == "insert_leave" then  
              action = "step"
            elseif event == "text_changed" then
              action = "step"
            elseif event == "text_deleted" then
              action = "break" 
            end
            
            return get_current_sound(action)
          end,
          
          -- Minimum time between sounds (in milliseconds) to prevent spam
          cooldown = 50,
          
          -- Enable debug logging
          debug = false,
        })
        
        -- Key mappings for controlling beepboop
        vim.keymap.set('n', '<leader>sb', '<cmd>BeepBoopToggle<cr>', { desc = 'Toggle BeepBoop sounds' })
        vim.keymap.set('n', '<leader>sv', '<cmd>BeepBoopVolumeUp<cr>', { desc = 'BeepBoop volume up' })
        vim.keymap.set('n', '<leader>sV', '<cmd>BeepBoopVolumeDown<cr>', { desc = 'BeepBoop volume down' })
        
        -- Custom commands for demonstration (recreating the video example)
        vim.api.nvim_create_user_command('BeepBoopDemo', function()
          local demo_sounds = {
            "${soundPath}/block/netherite/step1.ogg",
            "${soundPath}/block/sculk/step1.ogg", 
            "${soundPath}/block/tuff/step1.ogg",
            "${soundPath}/block/bamboo_wood_hanging_sign/step1.ogg",
            "${soundPath}/block/vine/step1.ogg",
            "${soundPath}/block/spore_blossom/step1.ogg",
            "${soundPath}/block/mud_bricks/step1.ogg",
          }
          
          for i, sound in ipairs(demo_sounds) do
            vim.defer_fn(function()
              require('beepboop').play_sound(sound)
            end, i * 200) -- Play sounds with 200ms intervals
          end
        end, { desc = 'Demo BeepBoop sounds for different file types' })
      '';
    };
  };
  
  # Ensure audio tools are available (might need pulseaudio/alsa)
  config.vim.extraPackages = with pkgs; [
    # Audio playback tools that beepboop might use
    sox
    alsa-utils
  ];
}