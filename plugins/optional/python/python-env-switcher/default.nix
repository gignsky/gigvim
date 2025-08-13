# Python Environment Auto-Switcher Plugins
# This folder contains plugins for automatically detecting and switching Python environments
#
# Available plugins:
# - whichpy.nvim: Automatic Python environment detection and switching
# - swenv.nvim: Simple Python virtual environment switcher
#
# Both plugins provide similar functionality but with different approaches:
# - whichpy.nvim: More automatic, detects environments based on project structure
# - swenv.nvim: More manual control, provides a picker interface
#
# Usage:
# The python.nix language configuration imports both plugins (commented out)
# so you can choose which one to enable based on your workflow preferences.

{
  imports = [
    ./whichpy.nix
    ./swenv.nix
  ];
}