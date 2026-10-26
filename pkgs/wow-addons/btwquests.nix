addonLib:
with addonLib; {
  core = zipAddon {
    name = "btwquests";
    version = "2.65.0";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=24680&minion=";
    sha256 = "1xca6fd2wj7irhsi5nk7symf37kq8aqqpmsy6gkzjhyl46r84dva";
  };
  burningcrusade = zipAddon {
    name = "btwquests-the-burning-crusade";
    version = "4.25";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=25631&minion=";
    sha256 = "1djv42ps8prlqv39prznx5q58l4w0xi9bhrg6hvi5qw19hhdys51";
  };
  wrath-of-the-lich-king = zipAddon {
    name = "btwquests-wrath-of-the-lich-king";
    version = "1.28";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=25784&minion=";
    sha256 = "1xrbrcb6zmay55m86brbfl57jwp6m8ikfw4sa5mw97x8c3j3mfck";
  };
  legion = githubReleaseAddon {
    name = "BtWQuestsLegion";
    owner = "Breeni";
    repo = "BtWQuestsLegion";
    rev = "v30.23";
    asset = "BtWQuestsLegion-v30.23.zip";
    sha256 = "0l3cdr2ww3zfh4awgp15x6yvqfbfwjy6v9xilc481h00k4jbbmf4";
    subdir = "BtWQuestsLegion";
  };
  shadowlands = githubReleaseAddon {
    name = "BtWQuestsShadowlands";
    owner = "Breeni";
    repo = "BtWQuestsShadowlands";
    rev = "v6.28";
    asset = "BtWQuestsShadowlands-v6.28.zip";
    sha256 = "0178vzq1z9n6r8gz2pa9y2adza210j467nm2mx1swm26q20hi8w6";
    subdir = "BtWQuestsShadowlands";
  };
}
