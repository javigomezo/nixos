{outputs, ...}: {
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];
    # overlays = [
    #   (final: prev: {
    #     cliphist = prev.cliphist.overrideAttrs (_old: {
    #       src = final.fetchFromGitHub {
    #         owner = "sentriz";
    #         repo = "cliphist";
    #         rev = "c49dcd26168f704324d90d23b9381f39c30572bd";
    #         sha256 = "sha256-2mn55DeF8Yxq5jwQAjAcvZAwAg+pZ4BkEitP6S2N0HY=";
    #       };
    #       vendorHash = "sha256-M5n7/QWQ5POWE4hSCMa0+GOVhEDCOILYqkSYIGoy/l0=";
    #     });
    #   })
    #   # If you want to use overlays exported from other flakes:
    #   # neovim-nightly-overlay.overlays.default

    #   # Or define it inline, for example:
    #   # (final: prev: {
    #   #   hi = final.hello.overrideAttrs (oldAttrs: {
    #   #     patches = [ ./change-hello-to-hi.patch ];
    #   #   });
    #   # })
    # ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };
}
