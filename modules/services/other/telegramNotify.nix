{self, ...}: {
  flake.nixosModules.telegramNotify = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.my.telegramNotify = {
      enable = lib.mkEnableOption "Telegram notifications for failed systemd units";
      notifyUnits = lib.mkOption {
        description = "Systemd units that should trigger a Telegram notification when they fail.";
        type = lib.types.listOf lib.types.str;
        default = ["nixos-upgrade.service"];
        example = ["nixos-upgrade.service" "restic-backups-nas.service"];
      };
    };

    config = lib.mkIf config.my.telegramNotify.enable {
      sops = {
        secrets = {
          "telegram/bot-token" = {
            sopsFile = self + "/modules/sops/common/_secrets.yaml";
          };
          "telegram/chat-id" = {
            sopsFile = self + "/modules/sops/common/_secrets.yaml";
          };
        };
        templates."telegram-notify.env".content = ''
          BOT_TOKEN=${config.sops.placeholder."telegram/bot-token"}
          CHAT_ID=${config.sops.placeholder."telegram/chat-id"}
        '';
      };

      systemd.services =
        (lib.genAttrs config.my.telegramNotify.notifyUnits (unit: {
          onFailure = ["telegram-notify@${unit}.service"];
        }))
        // {
          "telegram-notify@" = {
            description = "Send a Telegram notification about a failed unit (%i)";
            after = ["network-online.target"];
            path = [pkgs.curl];
            serviceConfig = {
              Type = "oneshot";
              EnvironmentFile = config.sops.templates."telegram-notify.env".path;
            };
            script = ''
              set -euo pipefail

              UNIT="%i"
              HOST="${config.networking.hostName}"
              LOG="$(journalctl -u "$UNIT" -n 20 --no-pager 2>/dev/null || true)"

              TEXT="⚠️ *$UNIT* failed on \`$HOST\`
              \`\`\`
              $LOG
              \`\`\`"

              TEXT="''${TEXT:0:4000}"

              curl -sS --max-time 10 \
                -X POST "https://api.telegram.org/bot''${BOT_TOKEN}/sendMessage" \
                --data-urlencode "chat_id=''${CHAT_ID}" \
                --data-urlencode "parse_mode=Markdown" \
                --data-urlencode "text=$TEXT" \
                -o /dev/null
            '';
          };
        };
    };
  };
}
