{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.pluto.communication;
in
{
  options.pluto.communication.enable = mkEnableOption "Enable Communication" // {
    default = true;
  };
  config = mkIf cfg.enable {
    services.easyeffects.enable = true;
    home.packages = with pkgs; [
      #discord#evil uwu
			#discord
      #For screenshare with audio
      #nheko #matrix client
			teamspeak3
			arma3-unix-launcher
      mpg123
      gp-saml-gui
      openconnect
    ];
    #services.easyeffects.enable = true; #need that background filter baby, later learn to autospawn in a workspace with discord
    services.arrpc.enable = true;
    programs.nixcord = {
     	discord.vencord.unstable = true; 
			enable = true;
      discord.enable = true;
      vesktop.enable = true;
      config = {
        useQuickCss = true;
        enabledThemes = [ "stylix.theme.css" ];
        frameless = true;
        plugins = {
          alwaysTrust.enable = true;
          anonymiseFileNames.enable = true;
          betterGifAltText.enable = true;
          betterGifPicker.enable = true;
          blurNSFW.enable = true;
          betterSessions.enable = true;
          biggerStreamPreview.enable = true;
          callTimer = {
            enable = false;
            format = "human";
          };
          clearURLs.enable = true;
          colorSighted.enable = true;
          consoleJanitor.enable = true;
          copyEmojiMarkdown.enable = true;
          copyFileContents.enable = true;
          copyUserURLs.enable = true;
          customIdle = {
            enable = true;
            idleTimeout = 0.0;
          };
          dearrow.enable = true;
          disableCallIdle.enable = false;
          dontRoundMyTimestamps.enable = true;
          fakeNitro = {
            enable = true;
          };
          fixCodeblockGap.enable = true;
          fixSpotifyEmbeds.enable = true;
          fixYoutubeEmbeds.enable = true;
          forceOwnerCrown.enable = true;
          friendsSince.enable = true;
          gameActivityToggle.enable = true;
          greetStickerPicker.enable = true;
          iLoveSpam.enable = true;
          imageLink.enable = true;
          imageZoom.enable = true;
          implicitRelationships.enable = true;
          invisibleChat = {
            enable = true;
          };
          keepCurrentChannel.enable = true;
          memberCount.enable = true;
          mentionAvatars.enable = true;
          messageLatency.enable = true;
          messageLinkEmbeds.enable = true;
          messageLogger.enable = true;
          moreUserTags.enable = true;
          mutualGroupDMs.enable = true;
          noDevtoolsWarning.enable = true;
          noF1.enable = true;
          noOnboardingDelay.enable = true;
          noPendingCount = {
            enable = true;
            hideFriendRequestsCount = false;
          };
          noReplyMention.enable = true;
					#noScreensharePreview.enable = true;
          noTypingAnimation.enable = true;
          noUnblockToJump.enable = true;
          nsfwGateBypass.enable = true;
          openInApp.enable = true;
          pauseInvitesForever.enable = true;
          permissionFreeWill.enable = true;
          permissionsViewer.enable = true;
          pictureInPicture.enable = true;
          pinDMs.enable = true;
          platformIndicators.enable = true;
          previewMessage.enable = true;
          reactErrorDecoder.enable = true;
          readAllNotificationsButton.enable = true;
          relationshipNotifier.enable = true;
          replaceGoogleSearch = {
            enable = true;
          };
          replyTimestamp.enable = true;
          reverseImageSearch.enable = true;
          summaries.enable = true;
          serverInfo.enable = true;
          serverListIndicators.enable = true;
          showConnections.enable = true;
          showHiddenChannels.enable = true;
          showHiddenThings.enable = true;
          showTimeoutDuration.enable = true;
          silentMessageToggle.enable = true;
          sortFriendRequests.enable = true;
          spotifyCrack.enable = true;
          startupTimings.enable = true;
          superReactionTweaks = {
            enable = true;
            superReactionPlayingLimit = 0;
          };
          typingIndicator.enable = true;
          typingTweaks.enable = true;
          unlockedAvatarZoom.enable = true;
          userVoiceShow.enable = true;
          validReply.enable = true;
          validUser.enable = true;
          voiceChatDoubleClick.enable = true;
          viewRaw.enable = true;
          volumeBooster.enable = true;
          whoReacted.enable = true;
          youtubeAdblock.enable = true;
          webKeybinds.enable = true;
          webRichPresence.enable = true;
          webScreenShareFixes.enable = true;
        };
      };
    };
  };
}
