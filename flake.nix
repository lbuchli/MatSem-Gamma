{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-18.11";
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
    in rec {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          (python3.withPackages(ps: with ps; [
            ipython
            jupyter
            numpy
            scipy
            pillow
          ]))
        ];
        shellHook = "echo \"start with 'jupyter notebook'\"";
      };
    }
  );
}


