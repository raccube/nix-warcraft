addonLib:
with addonLib; {
  core = zipAddon {
    name = "btwquests";
    version = "2.63.2";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=24680&d=1787511282&minion";
    sha256 = "0ds74fbgrhzcmxgyq8asg0cc6sqbqsid2q6h5dk7sw514xaj1zj4";
  };
  burningcrusade = zipAddon {
    name = "btwquests-the-burning-crusade";
    version = "4.24";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=25631&d=1786803155&minion";
    sha256 = "0ajwyi4dh6qjhbh23pxmh9c01svw2qdz8mk9fxl17lw4dq2vbfn1";
  };
  wrath-of-the-lich-king = zipAddon {
    name = "btwquests-wrath-of-the-lich-king";
    version = "1.27";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=25784&d=1786803140&minion";
    sha256 = "0zgsd84mr1id3v8xdyw6gdn3xicgh6crpvj16gxd8zncid1qrqjw";
  };
  legion = githubReleaseAddon {
    name = "BtWQuestsLegion";
    owner = "Breeni";
    repo = "BtWQuestsLegion";
    rev = "v30.22";
    asset = "BtWQuestsLegion-v30.22.zip";
    sha256 = "1ldl644lxr1m9z6hzi67pl19m32jxmnwa117rkkvr6fz448xkzdw";
    subdir = "BtWQuestsLegion";
  };
  shadowlands = githubReleaseAddon {
    name = "BtWQuestsShadowlands";
    owner = "Breeni";
    repo = "BtWQuestsShadowlands";
    rev = "v6.27";
    asset = "BtWQuestsShadowlands-v6.27.zip";
    sha256 = "1ivind5z8w70lh990ypypzwfvb6w804kmi2nr269pagsqifggjjn";
    subdir = "BtWQuestsShadowlands";
  };
}
