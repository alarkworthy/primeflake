{
  description = "Jupyter Data Science Environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
	  nativeBuildInputs = [ pkgs.bashInteractive ];
	  buildInputs = with pkgs;
	    [
	    #define python version + package set
              (python3.withPackages (ps:
	        with ps;
		with python3Packages; [
                  jupyter
		  ipython

		  #Optional
		  #pandas
		  #numpy
		  #matplotlib
		]))
	    ];

	    shellHook = ''
	      echo "`${pkgs.python3}/bin/python --version`"
	      '';
	};
      });
}
