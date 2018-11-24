{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.vscode;

in

{
  options = {
    programs.vscode = {
      enable = mkEnableOption "Visual Studio Code";

      userSettings = mkOption {
        type = types.attrs;
        description = ''
          Configuration written to
          <filename>~/.config/Code/User/settings.json</filename>.
        '';
        example = {
          "update.channel" = "none";
          "[nix]"."editor.tabSize" = 2;
        };
      };

      extensions = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "The extensions Visual Studio Code should be started with (will override but not delete manually installed ones).";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.vscode-with-extensions.override {
        vscodeExtensions = cfg.extensions;
      }
    ];

    xdg.configFile."Code/User/settings.json".text = builtins.toJSON cfg.userSettings;
  };
}
