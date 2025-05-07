{...}: {
  enable = true;
  settings = {
    pages = [
      {
        name = "Home";
        hide-desktop-navigation = true;
        columns = [
          {
            size = "small";
            widgets = [
              {
                type = "bookmarks";
                groups = [
                  {
                    title = "Entertainment";
                    links = [
                      {
                        title = "YouTube";
                        url = "https://youtube.com/";
                      }
                      {
                        title = "TikTok";
                        url = "https://tiktok.com/";
                      }
                    ];
                  }
                  {
                    title = "Utilities";
                    links = [
                      {
                        title = "Todoist";
                        url = "https://app.todoist.com/";
                      }
                      {
                        title = "HammerTime";
                        url = "https://hammertime.cyou/";
                      }
                    ];
                  }
                  {
                    title = "Nix/NixOS";
                    links = [
                      {
                        title = "NixOS Search";
                        url = "https://search.nixos.org/";
                      }
                      {
                        title = "NixOS Wiki";
                        url = "https://wiki.nixos.org/";
                      }
                      {
                        title = "Home Manager Search";
                        url = "https://home-manager-options.extranix.com/";
                      }
                      {
                        title = "Stylix Docs";
                        url = "https://stylix.danth.me/";
                      }
                      {
                        title = "Nix Functions";
                        url = "https://teu5us.github.io/nix-lib.html/";
                      }
                    ];
                  }
                ];
              }
              {
                type = "server-stats";
                servers = [
                  {
                    type = "local";
                  }
                ];
              }
            ];
          }
          {
            size = "full";
            widgets = [
              {
                type = "search";
              }
              {
                type = "reddit";
                subreddit = "nixos";
                style = "vertical-list";
                show-thumbnails = true;
              }
            ];
          }
          {
            size = "small";
            widgets = [
              {
                type = "calendar";
              }
              {
                type = "rss";
                title = "RSS Feeds";
                single-line-titles = true;
                feeds = [
                  {
                    title = "S.T.E.M.M.";
                    url = "https://git.squishcat.net/YinYang/stemm.rss";
                  }
                ];
              }
            ];
          }
        ];
      }
    ];
  };
}
