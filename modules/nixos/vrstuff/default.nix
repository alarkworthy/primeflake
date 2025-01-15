{lib, pkgs, config,...}:
{
	options.pluto.gaming.vrstuff.enable = lib.mkEnableOption "Enable VR Utils" // {default = false;};
	config = lib.mkIf config.pluto.gaming.vrstuff.enable {
		programs.git.lfs.enable = true;
		 boot.kernelPatches = [
		 				{
		 		name = "amdgpu-ignore-ctx-privileges";
		 		patch = pkgs.fetchpatch {
		 			name = "cap_sys_nice_begone.patch";
		 			url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
		 			hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
		 		};
		 	}
		 ];
	};
}
