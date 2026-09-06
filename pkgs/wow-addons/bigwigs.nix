addonLib: let
  fromMainRelease = subdir:
    addonLib.githubReleaseAddon {
      name = "BigWigs";
      owner = "BigWigsMods";
      repo = "BigWigs";
      rev = "v424.5";
      asset = "BigWigs-v424.5.zip";
      sha256 = "1qqandfq9za03dk7xnrz656pcpzkv8ky48dwmvh19ml0wqyilxlz";
      inherit subdir;
    };
in
  with addonLib; {
    bigwigs = fromMainRelease "BigWigs";
    core = fromMainRelease "BigWigs_Core";
    march_on_quel_danas = fromMainRelease "BigWigs_MarchOnQuelDanas";
    midnight_lairs = fromMainRelease "BigWigs_MidnightLairs";
    midnight_world = fromMainRelease "BigWigs_MidnightWorld";
    options = fromMainRelease "BigWigs_Options";
    plugins = fromMainRelease "BigWigs_Plugins";
    sporefall = fromMainRelease "BigWigs_Sporefall";
    the_dreamrift = fromMainRelease "BigWigs_TheDreamrift";
    the_venomous_abyss = fromMainRelease "BigWigs_TheVenomousAbyss";
    the_voidspire = fromMainRelease "BigWigs_TheVoidspire";
    classic = githubReleaseAddon {
      name = "BigWigs_Classic";
      owner = "BigWigsMods";
      repo = "BigWigs_Classic";
      rev = "v12.1.2";
      asset = "BigWigs_Classic-v12.1.2.zip";
      sha256 = "1hg938cxbg0hlh8179akcqaairyayzlz46dzcaayd32kwyx7crgx";
      subdir = "BigWigs_Classic";
    };
    burning-crusade = githubReleaseAddon {
      name = "BigWigs_BurningCrusade";
      owner = "BigWigsMods";
      repo = "BigWigs_BurningCrusade";
      rev = "v12.1.9";
      asset = "BigWigs_BurningCrusade-v12.1.9.zip";
      sha256 = "1fx86h150xlky7lbaz95zl41vm2sjm218fjvzx9vyvhd4bgiwsij";
      subdir = "BigWigs_BurningCrusade";
    };
    cataclysm = githubReleaseAddon {
      name = "BigWigs_Cataclysm";
      owner = "BigWigsMods";
      repo = "BigWigs_Cataclysm";
      rev = "v12.0.5";
      asset = "BigWigs_Cataclysm-v12.0.5.zip";
      sha256 = "0pwpqr7qdc4xlix5r1adj5jp3p0i912slrf1nybsiknsjxcldvfw";
      subdir = "BigWigs_Cataclysm";
    };
    mists-of-pandaria = githubReleaseAddon {
      name = "BigWigs_MistsOfPandaria";
      owner = "BigWigsMods";
      repo = "BigWigs_MistsOfPandaria";
      rev = "v12.0.9";
      asset = "BigWigs_MistsOfPandaria-v12.0.9.zip";
      sha256 = "05wsi82lb79pfhqk1ryy82ny0a91k0vdxraw185gv0sgh98kna51";
      subdir = "BigWigs_MistsOfPandaria";
    };
    warlords-of-draenor = githubReleaseAddon {
      name = "BigWigs_WarlordsOfDraenor";
      owner = "BigWigsMods";
      repo = "BigWigs_WarlordsOfDraenor";
      rev = "v12.0.3";
      asset = "BigWigs_WarlordsOfDraenor-v12.0.3.zip";
      sha256 = "05qljk1mhskdc8vawm6wbqw4b01wqcsq1j4acrgn58r8dzfdgigr";
      subdir = "BigWigs_WarlordsOfDraenor";
    };
    legion = githubReleaseAddon {
      name = "BigWigs_Legion";
      owner = "BigWigsMods";
      repo = "BigWigs_Legion";
      rev = "v12.0.3";
      asset = "BigWigs_Legion-v12.0.3.zip";
      sha256 = "0av8rizqhsz3ab277w5jz9a1i1mfwppr6vw1m5486vcx3r76d5qh";
      subdir = "BigWigs_Legion";
    };
    battle-for-azeroth = githubReleaseAddon {
      name = "BigWigs_BattleForAzeroth";
      owner = "BigWigsMods";
      repo = "BigWigs_BattleForAzeroth";
      rev = "v12.0.5";
      asset = "BigWigs_BattleForAzeroth-v12.0.5.zip";
      sha256 = "0xg9llb727g758yhjpdjw41vpzjksrhssd16q6vw9x9nd8s3y352";
      subdir = "BigWigs_BattleForAzeroth";
    };
    shadowlands = githubReleaseAddon {
      name = "BigWigs_Shadowlands";
      owner = "BigWigsMods";
      repo = "BigWigs_Shadowlands";
      rev = "v12.0.4";
      asset = "BigWigs_Shadowlands-v12.0.4.zip";
      sha256 = "03vvlq8f7nb2lm70spzm1ci2x0lpg0zkxhx92hnkq43k0gwcqx4a";
      subdir = "BigWigs_Shadowlands";
    };
    dragonflight = githubReleaseAddon {
      name = "BigWigs_Dragonflight";
      owner = "BigWigsMods";
      repo = "BigWigs_Dragonflight";
      rev = "v12.0.6";
      asset = "BigWigs_Dragonflight-v12.0.6.zip";
      sha256 = "1c0w2x6zsdb57aqf93hpvf0n9iky44wb612h8i2h9lv6khin6cxl";
      subdir = "BigWigs_Dragonflight";
    };
    the-war-within = githubReleaseAddon {
      name = "BigWigs_TheWarWithin";
      owner = "BigWigsMods";
      repo = "BigWigs_TheWarWithin";
      rev = "v12.0.4";
      asset = "BigWigs_TheWarWithin-v12.0.4.zip";
      sha256 = "15hlynwdb8vj7yy0xvdqzmrg2viy1ndqga00fm1vki790bkqd03s";
      subdir = "BigWigs_TheWarWithin";
    };
  }
