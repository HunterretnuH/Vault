
{ pkgs }:

[
  pkgs.chezmoi
  pkgs.kitty
  pkgs.fzf
  pkgs.fd
  pkgs.zoxide
  pkgs.neovim
  pkgs.neovim-remote
  pkgs.ranger # TODO: Remove after switching fully to Yazi
  pkgs.yazi
  pkgs.uv
  pkgs.starship
  pkgs.interception-tools
  pkgs.interception-tools-plugins.dual-function-keys
  pkgs.nixgl.nixGLMesa
]
