{
  description = "Clang development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils}:
  flake-utils.lib.eachDefaultSystem (system: 
    let pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
	#nativeBuildInputs = [ pkgs.bashInteractive ];
	buildInputs = with pkgs; [
          gcc
	  clang
	  llvmPackages.libclang
	  cmake
	  ccls
	];

	shellHook = ''
	  echo "`${pkgs.gcc}/bin/gcc --version`"
	  echo "`${pkgs.clang}/bin/clang --version`"
	  echo "`${pkgs.ccls}/bin/ccls --version`"
	  echo "`${pkgs.cmake}/bin/cmake --version`"
	'';
      };
    
    });
}
