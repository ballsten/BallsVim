dev:
  nvim-dev

run:
  nix run .

format:
  stylua -g '*.lua' -- .
  nixfmt **/*.nix

up:
  nix flake update
