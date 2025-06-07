dev:
  nvim-dev

run:
  nix run .

format:
  stylua **/*.lua
  nixfmt **/*.nix
