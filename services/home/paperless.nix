{config, ...}: {
  sops = {
    secrets = {
      "paperless/password" = {
        owner = "paperless";
      };
    };
    templates."paperless.env" = {
      content = ''
        PAPERLESS_URL="https://paperless.${config.sops.placeholder.fqdn}"
      '';
      owner = "paperless";
    };
  };

  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets."paperless/password".path;
    environmentFile = config.sops.templates."paperless.env".path;
    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "spa+eng+fra";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };
}
