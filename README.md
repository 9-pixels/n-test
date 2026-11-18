# nxXtend Flake Test

A test flake exposing multiple output types and entries.

## Available outputs

- packages:
  - default
  - hello
  - cowsay
  - jq

- devShells:
  - default
  - python

- nixosModules:
  - default
  - base
  - development

- overlays:
  - default
  - helloAlias
  - toolsAlias

- apps:
  - default
  - hello
  - cowsay

- templates:
  - default
  - basic
  - rust

- formatter:
  - nixfmt-rfc-style

## Tests

```bash
nix flake show
nix flake check

nix build .#hello
nix build .#cowsay
nix build .#jq

nix develop
nix develop .#python

nix run .#hello
nix run .#cowsay

nix fmt
```
