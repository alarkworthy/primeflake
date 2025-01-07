{lib, pkgs, config,...}:
{
	options.pluto.gaming.vrstuff.enable = lib.mkEnableOption "Enable VR Utils" // {default = false;};
	config = lib.mkIf config.pluto.gaming.vrstuff.enable {
		programs.envision = {
			enable = false;
			openFirewall = true; # This is set true by default
		};
	services.monado.enable = true;
  services.monado.defaultRuntime = true;

  environment.systemPackages = with pkgs; [ basalt-monado ];

  environment.variables = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
    WMR_HANDTRACKING = "0";

    VIT_SYSTEM_LIBRARY_PATH = "${pkgs.basalt-monado}/lib/libbasalt.so";
  };


		systemd.user.services.monado.environment = {
			STEAMVR_LH_ENABLE = "1";
			XRT_COMPOSITOR_COMPUTE = "1";
		};
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
