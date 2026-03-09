{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      pythonEnv = pkgs.python3.withPackages(ps: with ps; [
        ipython
        jupyter
        numpy
        scipy
        matplotlib
        (buildPythonPackage rec {
          pname = "jupyterlab_rise";
          version = "0.43.1";
          format = "wheel";
          src = pkgs.fetchurl {
            url = "https://files.pythonhosted.org/packages/5d/6b/ccc3f8d9940719b1d6c0c12aab9417d4008ff6aa419c8d103aa4c29ee3d1/jupyterlab_rise-0.43.1-py3-none-any.whl";
            hash = "sha256-YrptjAeoDf8pNYlRLVeQECmACiOoYJBLFOuW1ZfLhXM=";
          };
        })
      ]);
    in {

      packages.default = pkgs.stdenv.mkDerivation {
        pname = "presentation";
        version = "1.0.0";
        src = ./.;

        buildInputs = [ pythonEnv ];

        buildPhase = ''
          export HOME=$(mktemp -d)
          jupyter nbconvert presentation.ipynb --to slides
        '';

        installPhase = ''
          mkdir -p $out
          cp presentation.slides.html $out/index.html
        '';
      };

      devShell = pkgs.mkShell {
        buildInputs = [ pythonEnv ];
        shellHook = "echo \"start with 'jupyter notebook'\"";
      };
    }
  );
}


