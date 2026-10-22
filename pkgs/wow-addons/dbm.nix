{githubReleaseAddon, ...}: {
  core = githubReleaseAddon {
    name = "DBM-Core";
    owner = "DeadlyBossMods";
    repo = "DeadlyBossMods";
    rev = "12.1.17";
    asset = "DBM-Core-12.1.17.zip";
    sha256 = "0psygpb38qqsi0idzgk343kcghvldh1plapj9inbyhq4ikgv7sqn";
    subdir = "DBM-Core";
  };

  dungeons = githubReleaseAddon {
    name = "DBM-Dungeons";
    owner = "DeadlyBossMods";
    repo = "DBM-Dungeons";
    rev = "r268";
    asset = "DBM-Dungeons-r268.zip";
    sha256 = "06im8xwrndnq486pbzjg4ywmr18vq2v17phwgncxgh7i8n6d6xgl";
    subdir = ".";
  };

  classic = githubReleaseAddon {
    name = "DBM-Vanilla_SoD";
    owner = "DeadlyBossMods";
    repo = "DBM-Vanilla";
    rev = "r833";
    asset = "DBM-Vanilla_SoD-r833.zip";
    sha256 = "0xzgcs3s5jdcpvnr20g9zfcdvp7va894pmrh8454fbdi80jdhafa";
    subdir = ".";
  };

  burning-crusade = githubReleaseAddon {
    name = "DBM-Raids-BC";
    owner = "DeadlyBossMods";
    repo = "DBM-BurningCrusade";
    rev = "r21";
    asset = "DBM-Raids-BC-r21.zip";
    sha256 = "1w5zsvwzpan29ffg0kv4nxfrs6kc3ccg7hcrikg74wvdwm3qpx97";
    subdir = "DBM-Raids-BC";
  };

  wrath-of-the-lich-king = githubReleaseAddon {
    name = "DBM-Raids-WoTLK";
    owner = "DeadlyBossMods";
    repo = "DBM-WotLK";
    rev = "r354";
    asset = "DBM-Raids-WoTLK-r354.zip";
    sha256 = "08xw469hpgwlwan9zwk6kra32a0ndlbfyk3b68h8jywsxlsby9zn";
    subdir = "DBM-Raids-WoTLK";
  };

  cataclysm = githubReleaseAddon {
    name = "DBM-Raids-Cata";
    owner = "DeadlyBossMods";
    repo = "DBM-Cataclysm";
    rev = "r264";
    asset = "DBM-Raids-Cata-r264.zip";
    sha256 = "1nwbw02vjhly12k9w2ycpbyjh40756hwfykdz76vw5wxfzvbv1n7";
    subdir = "DBM-Raids-Cata";
  };

  mists-of-pandaria = githubReleaseAddon {
    name = "DBM-Raids-MoP";
    owner = "DeadlyBossMods";
    repo = "DBM-MoP";
    rev = "r192";
    asset = "DBM-Raids-MoP-r192.zip";
    sha256 = "1g98a6mdldxskmwvs76gn5sqxksa5p776y4bzhc3wsmrwrbv2kcm";
    subdir = "DBM-Raids-MoP";
  };

  warlords-of-draenor = githubReleaseAddon {
    name = "DBM-Raids-WoD";
    owner = "DeadlyBossMods";
    repo = "DBM-WoD";
    rev = "r98";
    asset = "DBM-Raids-WoD-r98.zip";
    sha256 = "1s3hgv4jsm50gjnvhxngsrm89gcwxb61crdwfg9z8na0zg1hgjpl";
    subdir = "DBM-Raids-WoD";
  };

  legion = githubReleaseAddon {
    name = "DBM-Raids-Legion";
    owner = "DeadlyBossMods";
    repo = "DBM-Legion";
    rev = "r68";
    asset = "DBM-Raids-Legion-r68.zip";
    sha256 = "06rf2xg8qz17v9d46rw6plsw4vgcv0wlvp4ql5n7znlralac6dws";
    subdir = "DBM-Raids-Legion";
  };

  battle-for-azeroth = githubReleaseAddon {
    name = "DBM-Raids-BfA";
    owner = "DeadlyBossMods";
    repo = "DBM-BfA";
    rev = "r51";
    asset = "DBM-Raids-BfA-r51.zip";
    sha256 = "0rfq7qqmfmdmqr40w7b2chb9xdnbrnr1xgld5lmfyasmv55n5hr1";
    subdir = "DBM-Raids-BfA";
  };

  shadowlands = githubReleaseAddon {
    name = "DBM-Raids-Shadowlands";
    owner = "DeadlyBossMods";
    repo = "DBM-Shadowlands";
    rev = "r33";
    asset = "DBM-Raids-Shadowlands-r33.zip";
    sha256 = "0jf1v1xqkqm75998kfz4fgya3jn638zh4pwngnls73amax06m10r";
    subdir = "DBM-Raids-Shadowlands";
  };

  dragonflight = githubReleaseAddon {
    name = "DBM-Raids-Dragonflight";
    owner = "DeadlyBossMods";
    repo = "DBM-Dragonflight";
    rev = "r13";
    asset = "DBM-Raids-Dragonflight-r13.zip";
    sha256 = "1srkgjvmfpjkbhbig4yjvcb3jxv8ghyld3k840k5rm5fqz0c6m1a";
    subdir = "DBM-Raids-Dragonflight";
  };

  the-war-within = githubReleaseAddon {
    name = "DBM-Raids-WarWithin";
    owner = "DeadlyBossMods";
    repo = "DBM-TWW";
    rev = "r7";
    asset = "DBM-Raids-WarWithin-r7.zip";
    sha256 = "02b3lzxya5s46rrfnir021df3mklx66ifv5w2hz18xn11808b1hw";
    subdir = "DBM-Raids-WarWithin";
  };
}
