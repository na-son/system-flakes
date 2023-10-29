{ pkgs, home-manager, ... }:
{
    home.stateVersion = "23.05";
    home.packages = with pkgs; [
        silver-searcher
    ];
}