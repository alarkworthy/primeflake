{ pkgs, config, lib, ... }:
let
  unityVersion = "2022.3.22f1";
  unityChangeset = "887be4894c44";
  myLibxml2 = pkgs.libxml2.overrideAttrs (oldAttrs: {
    version = "2.13.8";
    src = pkgs.fetchurl {
      url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor "2.13.8"}/libxml2-2.13.8.tar.xz";
      sha256 = "J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
    };
  });
  # Correct fhsEnv with all runtime libraries Unity might need
  unityhub = pkgs.unityhub.override {
    extraPkgs = pkgs: [
      myLibxml2
    ];
  };

  unity = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "unity";
    version = unityVersion;
    dontFixup = true;

    unitySrc = pkgs.fetchurl {
      url = "https://download.unity3d.com/download_unity/${unityChangeset}/LinuxEditorInstaller/Unity-${version}.tar.xz";
      hash = "sha256-eE//d2kFHA9p7bA52NCUMeeuQASmSh20QDcJ3biKpQY=";
    };

    androidSupportSrc = pkgs.fetchurl {
      url = "https://download.unity3d.com/download_unity/${unityChangeset}/MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-${version}.pkg";
      hash = "sha256-Vqk8HgnFsUzjLvjIhIdJTLFHpyE6UDhwR7hN7/Jjpak=";
    };

    windowsSupportSrc = pkgs.fetchurl {
      url = "https://download.unity3d.com/download_unity/${unityChangeset}/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-${version}.pkg";
      hash = "sha256-iBGBpsg3IwooTqQSC/y14qq5QLuQEOvftQ07iGXCBZ0=";
    };

    nativeBuildInputs = [ pkgs.cpio pkgs.xarMinimal ];
    buildInputs = [ unityhub.fhsEnv ];

    unpackPhase = ''
      mkdir android
      xar -C android -xf "${androidSupportSrc}"
      mkdir windows
      xar -C windows -xf "${windowsSupportSrc}"
    '';

    installPhase = ''
      mkdir -p "$out/bin" "$out/Editor/${version}/Editor/Data/PlaybackEngines/AndroidPlayer"
      mkdir -p "$out/Editor/${version}/Editor/Data/PlaybackEngines/WindowsStandaloneSupport"

      tar -C "$out/Editor/${version}" -xf "${unitySrc}"
      gzip -d < android/TargetSupport.pkg.tmp/Payload | cpio -iD "$out/Editor/${version}/Editor/Data/PlaybackEngines/AndroidPlayer"
      gzip -d < windows/TargetSupport.pkg.tmp/Payload | cpio -iD "$out/Editor/${version}/Editor/Data/PlaybackEngines/WindowsStandaloneSupport"

      # Create FHS-aware wrapper script
      cat > "$out/bin/unity" <<-EOF
      #!/bin/sh
      UNITY_VERSION="${version}"
      UNITY_CACHE_DIR="\$HOME/.cache/unity-local/\$UNITY_VERSION"
      UNITY_SYSTEM_DIR="$out/Editor/\$UNITY_VERSION"

      if [ ! -d "\$UNITY_CACHE_DIR" ]; then
        mkdir -p "\$UNITY_CACHE_DIR"
        cp -rT "\$UNITY_SYSTEM_DIR" "\$UNITY_CACHE_DIR"
      fi

      exec ${unityhub.fhsEnv}/bin/unityhub-fhs-env bash -c '"\$0" "\$@"' "$out/Editor/${version}/Editor/Unity" "\$@"
      EOF
      chmod +x "$out/bin/unity"

      # Font fallback patch
      cat > "$out/Editor/${version}/Editor/Data/Resources/fontsettings.txt" <<-EOF
      English|default=Inter, IPAPGothic, Verdana, Tahoma
      English|Inter-Regular=Inter, IPAPGothic, Verdana, Tahoma
      English|Inter-SemiBold=Inter, IPAPGothic, Verdana, Tahoma
      English|Inter-Small=Inter, IPAPGothic, Verdana, Tahoma
      English|Inter-Italic=Inter, IPAPGothic, Verdana, Tahoma
      English|Inter-SemiBoldItalic=Inter, IPAPGothic, Verdana, Tahoma
      EOF
    '';

  };
in {
  home.packages = [
    unityhub
    unity
  ];
}
