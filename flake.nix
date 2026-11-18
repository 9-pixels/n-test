{
  description = "nxXtend multi-output test flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      # 3 packages
      packages.${system} = {
        default = pkgs.hello;
        hello = pkgs.hello;
        cowsay = pkgs.cowsay;
        jq = pkgs.jq;
      };

      # 2 development shells
      devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            git
            jq
          ];
        };

        python = pkgs.mkShell {
          packages = with pkgs; [
            python3
            ruff
          ];
        };
      };

      # 2 NixOS modules
      nixosModules = {
        default = self.nixosModules.base;

        base = { pkgs, ... }: {
          environment.systemPackages = with pkgs; [
            git
            curl
          ];
        };

        development = { pkgs, ... }: {
          environment.systemPackages = with pkgs; [
            jq
            ripgrep
            fd
          ];
        };
      };

      # 2 overlays
      overlays = {
        default = self.overlays.helloAlias;

        helloAlias = final: prev: {
          nxxtend-test-hello = prev.hello;
        };

        toolsAlias = final: prev: {
          nxxtend-test-cowsay = prev.cowsay;
          nxxtend-test-jq = prev.jq;
        };
      };

      # 2 applications
      apps.${system} = {
        default = self.apps.${system}.hello;

        hello = {
          type = "app";
          program = "${pkgs.hello}/bin/hello";
        };

        cowsay = {
          type = "app";
          program = "${pkgs.cowsay}/bin/cowsay";
        };
      };

      # Formatter
      formatter.${system} = pkgs.nixfmt-rfc-style;

      # 2 templates
      templates = {
        default = self.templates.basic;

        basic = {
          path = ./templates/basic;
          description = "Basic test template";
        };

        rust = {
          path = ./templates/rust;
          description = "Rust development template";
        };
      };
    };
}
