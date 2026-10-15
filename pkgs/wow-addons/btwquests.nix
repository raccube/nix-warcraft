addonLib:
with addonLib; {
  core = zipAddon {
    name = "btwquests";
    version = "2.65.0";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=24680&minion=";
    sha256 = "0ds74fbgrhzcmxgyq8asg0cc6sqbqsid2q6h5dk7sw514xaj1zj4";
  };
  burningcrusade = zipAddon {
    name = "btwquests-the-burning-crusade";
    version = "4.25";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=25631&minion=";
    sha256 = "0ajwyi4dh6qjhbh23pxmh9c01svw2qdz8mk9fxl17lw4dq2vbfn1";
  };
  wrath-of-the-lich-king = zipAddon {
    name = "btwquests-wrath-of-the-lich-king";
    version = "1.28";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=25784&minion=";
    sha256 = "0zgsd84mr1id3v8xdyw6gdn3xicgh6crpvj16gxd8zncid1qrqjw";
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
