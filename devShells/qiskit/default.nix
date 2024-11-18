{
  description = "Qiskit with Jupyter development enviroment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          #build inputs
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = with pkgs; [
            #Defines a python + set if packages.
            (python3.withPackages (
              ps:
              with ps;
              with python3Packages;
              [
                juypter
                ipython
                qiskit

              ]
            ))
          ];

          shellHook = ''
              echo "`${pkgs.python3}/bin/python --version`"
          '';
        };
      }
    );
}
