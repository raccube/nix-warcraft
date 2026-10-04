{githubReleaseAddon, ...}:
with {
  owner = "DeadlyBossMods";
}; {
  core = githubReleaseAddon {
    name = "DBM-Core";
    inherit owner;
    repo = "DeadlyBossMods";
    rev = "12.1.12";
    asset = "DBM-Core-12.1.12.zip";
    sha256 = "1rj05l1xljnq2hwi4q78spyipgh0njalnjygisfh5zxbvb3vr2sw";
    subdir = "DBM-Core";
  };

  dungeons = githubReleaseAddon {
    name = "DBM-Dungeons";
    inherit owner;
    repo = "DBM-Dungeons";
    rev = "r264";
    asset = "DBM-Dungeons-r264.zip";
    sha256 = "0yclbkys3649brs8srnp9i88dhh84v49i7wdyig9ff7gvwkhb8v3";
    subdir = ".";
  };

  classic = githubReleaseAddon {
    name = "DBM-Vanilla_SoD";
    inherit owner;
    repo = "DBM-Vanilla";
    rev = "r830";
    asset = "DBM-Vanilla_SoD-r830.zip";
    sha256 = "0qw40j7zxlm2v1v9vhqwsw2xf9c1gwdvcdi8dk1xmqcsb6q9smbw";
    subdir = ".";
  };

  burning-crusade = githubReleaseAddon {
    name = "DBM-Raids-BC";
    inherit owner;
    repo = "DBM-BurningCrusade";
    rev = "r20";
    asset = "DBM-Raids-BC-r20.zip";
    sha256 = "0ngadmc8j01qkmchfbbfav1mm1xc71ipi3zkl4j6zv5zn5i1q4hb";
    subdir = "DBM-Raids-BC";
  };

  wrath-of-the-lich-king = githubReleaseAddon {
    name = "DBM-Raids-WoTLK";
    inherit owner;
    repo = "DBM-WotLK";
    rev = "r353";
    asset = "DBM-Raids-WoTLK-r353.zip";
    sha256 = "0qmlqbi99f1i56jwnb3vbxf1gpb80b94xc9wxwivr6znic542bm6";
    subdir = "DBM-Raids-WoTLK";
  };

  cataclysm = githubReleaseAddon {
    name = "DBM-Raids-Cata";
    inherit owner;
    repo = "DBM-Cataclysm";
    rev = "r263";
    asset = "DBM-Raids-Cata-r263.zip";
    sha256 = "0ig1kffsfb9glyywkv799ddj149dvjlgianbxkk9mwz13m9dr1xf";
    subdir = "DBM-Raids-Cata";
  };

  mists-of-pandaria = githubReleaseAddon {
    name = "DBM-Raids-MoP";
    inherit owner;
    repo = "DBM-MoP";
    rev = "r191";
    asset = "DBM-Raids-MoP-r191.zip";
    sha256 = "1m2n19wq5853wqg2r0iwzxikahi4vszjspwdlx10ynb7vgifnkh7";
    subdir = "DBM-Raids-MoP";
  };

  warlords-of-draenor = githubReleaseAddon {
    name = "DBM-Raids-WoD";
    inherit owner;
    repo = "DBM-WoD";
    rev = "r97";
    asset = "DBM-Raids-WoD-r97.zip";
    sha256 = "1xiblxd5vdx7898ixqsvdx74y9ryp339bdgzk4p44p4y4xvrr247";
    subdir = "DBM-Raids-WoD";
  };

  legion = githubReleaseAddon {
    name = "DBM-Raids-Legion";
    inherit owner;
    repo = "DBM-Legion";
    rev = "r67";
    asset = "DBM-Raids-Legion-r67.zip";
    sha256 = "1cik8lpmyzbha37vcmqlr1c63wj2ra03lrjfnk5hh11ln2mxn6vc";
    subdir = "DBM-Raids-Legion";
  };

  battle-for-azeroth = githubReleaseAddon {
    name = "DBM-Raids-BfA";
    inherit owner;
    repo = "DBM-BfA";
    rev = "r50";
    asset = "DBM-Raids-BfA-r50.zip";
    sha256 = "1iq7q0mdl8al4lm3pw01ss1hhxys2whzzhkwicwq3gnd2g9j67nb";
    subdir = "DBM-Raids-BfA";
  };

  shadowlands = githubReleaseAddon {
    name = "DBM-Raids-Shadowlands";
    inherit owner;
    repo = "DBM-Shadowlands";
    rev = "r32";
    asset = "DBM-Raids-Shadowlands-r32.zip";
    sha256 = "14xd75r0ja6fqhhcclqasj8fd5f5jf97ijqrgcdapgcinf1zf732";
    subdir = "DBM-Raids-Shadowlands";
  };

  dragonflight = githubReleaseAddon {
    name = "DBM-Raids-Dragonflight";
    inherit owner;
    repo = "DBM-Dragonflight";
    rev = "r12";
    asset = "DBM-Raids-Dragonflight-r12.zip";
    sha256 = "1i4lwc5zix2nfafcpf8968a131sxzaaih04haprcb57knd88lhs1";
    subdir = "DBM-Raids-Dragonflight";
  };

  the-war-within = githubReleaseAddon {
    name = "DBM-Raids-WarWithin";
    inherit owner;
    repo = "DBM-TWW";
    rev = "r6";
    asset = "DBM-Raids-WarWithin-r6.zip";
    sha256 = "0xh1bcpb55bhgahs2gpq2xvbrsd6w3yy9hzja8lmk4qqblrsxsyj";
    subdir = "DBM-Raids-WarWithin";
  };
}
