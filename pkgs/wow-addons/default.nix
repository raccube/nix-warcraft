{pkgs}: let
  inherit
    (import ../../modules/wow/addons.nix {inherit pkgs;})
    githubAddon
    githubReleaseAddon
    zipAddon
    svnAddon
    ;
in {
  AdventureGuideLockouts = githubAddon {
    name = "AdventureGuideLockouts";
    owner = "Meivyn";
    repo = "AdventureGuideLockouts";
    rev = "v1.5.3";
    hash = "0567dvmfdvgr9i17vqnrqlrjqd4p5ypyxgjhb0v9qr4y8cjsvlfv";
  };
  MogCompanions = githubAddon {
    owner = "Zensunim";
    repo = "MogCompanions";
    rev = "1.7";
    hash = "179h6c4i0wc9nldsw17zicxz8nm0dzzva1q3gcnwhhgnz1f45wzd";
  };
  Narcissus = githubAddon {
    owner = "Peterodox";
    repo = "Narcissus";
    rev = "v1.8.6";
    hash = "19wyqklsijgb2j6gm2v5kwqzz9hiyk4if86y8hpphasw9a683b19";
  };
  Plumber = githubAddon {
    owner = "Peterodox";
    repo = "Plumber";
    rev = "v1.9.5";
    hash = "0nzlw5yqvdd6xczakr1d4fschhsir3yvggj53r5hfyr7fdd43gh5";
  };
  WeeklyKnowledge = githubAddon {
    owner = "DennisRas";
    repo = "WeeklyKnowledge";
    rev = "v1.4.0";
    hash = "0kjrda2illzfg0pjr49qyj4rh79qw5y7nvl288p83748ck2k9gvc";
  };
  YUI-Dialogue = githubReleaseAddon {
    name = "YUI-Dialogue";
    owner = "Peterodox";
    repo = "YUI-Dialogue";
    rev = "v1.0.5-e";
    asset = "DialogueUI-1.0.5-e.zip";
    sha256 = "0082zazqzq9669v0x8qgqay5ak68wpqj1nb6wzald8dy5ri0hddz";
    subdir = "DialogueUI";
  };
  abilitytimeline = githubAddon {
    owner = "Jods-GH";
    repo = "AbilityTimeline";
    rev = "v0.35";
    hash = "1wxiscjcjq4zf0lslmdmw2qqid0hvzd931qppprhvs976gb8xnd8";
  };
  angleur = githubAddon {
    owner = "LegolandoBloom";
    repo = "Angleur";
    rev = "2.9.615-hotfix";
    hash = "0icgq14vaqw7lsc1vr19d02agz6d9lfiwxa0vniaw7pdxwyhpiyl";
  };
  bigwigs = githubAddon {
    owner = "BigWigsMods";
    repo = "BigWigs";
    rev = "v424.5";
    hash = "01rv14w6h90lj45b19zvcfqvvyv3k83rf1p7247d7d6r4c8lks1c";
  };
  bigwigs_burningcrusade = githubAddon {
    owner = "BigWigsMods";
    repo = "BigWigs_BurningCrusade";
    rev = "v12.1.9";
    hash = "05j6b05hzvq8jxivb7caxlzgp1qadsn99n0r990n37zbl8x0c9zq";
  };
  bigwigs_cataclysm = githubAddon {
    owner = "BigWigsMods";
    repo = "BigWigs_Cataclysm";
    rev = "v12.0.5";
    hash = "1ml5h8ix9s2pya34n3lh72pm9djzcrlhgljpigw21qmij2sgsw65";
  };
  bigwigs_classic = githubAddon {
    owner = "BigWigsMods";
    repo = "BigWigs_Classic";
    rev = "v12.1.2";
    hash = "1h0j354s5ar2i1schqmg19s5lazwg3fqrzzlrf0g0px06nas7za1";
  };
  bigwigs_mistsofpandaria = githubAddon {
    owner = "BigWigsMods";
    repo = "BigWigs_MistsOfPandaria";
    rev = "v12.0.9";
    hash = "1f92xv5gzradfwg68d0ar79fhyifif590nba4rd305nh81nn51jr";
  };
  bigwigs_thewarwithin = githubAddon {
    owner = "BigWigsMods";
    repo = "BigWigs_TheWarWithin";
    rev = "v12.0.4";
    hash = "04bqgfxxlsdwc73wlnvx4xgky5krbf5ggvqcfbj9al0rg29bwyq1";
  };
  btwquestslegion = githubAddon {
    owner = "Breeni";
    repo = "BtWQuestsLegion";
    rev = "v30.22";
    hash = "08byi362rff8g3gcq8ycprigswhvrzp0aqazvl6vqp6lllw33xhb";
  };
  btwquestsshadowlands = githubAddon {
    owner = "Breeni";
    repo = "BtWQuestsShadowlands";
    rev = "v6.27";
    hash = "1wa5aaw4m0v4hjwnqdjdxa8li7747yvdbz7lyxfsc5y9r6j0gb43";
  };
  bugsack = githubAddon {
    owner = "funkydude";
    repo = "BugSack";
    rev = "v12.0.13";
    hash = "0cmygxf84asr9i5am82qi1zn01b067q5w7jw0gw363msdzlz3cp6";
  };
  craftsim = githubAddon {
    owner = "derfloh205";
    repo = "CraftSim";
    rev = "27.0.2";
    hash = "1q2h17zbqrgxr0y86jbqgw2knk7yq1z7wgxl85ywzchhyj54cd70";
  };
  handynotes = githubAddon {
    owner = "Nevcairiel";
    repo = "HandyNotes";
    rev = "v1.6.31";
    hash = "0sdva3w14ph557q03w3bv76pd9qw89368na9yz17m5863xvgd6jn";
  };
  idtip = githubAddon {
    owner = "silverwind";
    repo = "idTip";
    rev = "12.0.19";
    hash = "0fybd45iblxiqicd8w3vvdjw6n5cs72ahia85abyln3k8afpg8mm";
  };
  littlewigs = githubAddon {
    owner = "BigWigsMods";
    repo = "LittleWigs";
    rev = "v12.1.12";
    hash = "1xx0290v9nyyn5nv9qsnr8n393kwn8q1qbz75gxx2n4kjxpnhm9l";
  };
  simc-addon = githubReleaseAddon {
    name = "Simulationcraft";
    owner = "simulationcraft";
    repo = "simc-addon";
    rev = "12.1.0-04";
    asset = "Simulationcraft-12.1.0-04.zip";
    sha256 = "03q81kfhxrhka5xm3qd2rwk8fxmsmdsa1kaa67jkkiv83mx2p6gj";
    subdir = "Simulationcraft";
  };
  wow-handynotes-midnight = githubAddon {
    owner = "kemayo";
    repo = "wow-handynotes-midnight";
    rev = "v65";
    hash = "18rfzpch2r0h0w7lsyv3d7vll78n73d3a9c8bfd3pxrabls4sfd6";
  };
  Altoholic = zipAddon {
    name = "Altoholic";
    version = "12.1.001";
    url = "https://www.curseforge.com/api/v1/mods/13402/files/8667083/download";
    sha256 = "1axdx2m95pf7f6gpc0jisv9kr06vavpzzy37n4k43wbgz4c524sd";
  };
  btwquests = zipAddon {
    name = "btwquests";
    version = "2.63.2";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=24680&d=1787511282&minion";
    sha256 = "0ds74fbgrhzcmxgyq8asg0cc6sqbqsid2q6h5dk7sw514xaj1zj4";
  };
  btwquests-the-burning-crusade = zipAddon {
    name = "btwquests-the-burning-crusade";
    version = "4.24";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=25631&d=1786803155&minion";
    sha256 = "0ajwyi4dh6qjhbh23pxmh9c01svw2qdz8mk9fxl17lw4dq2vbfn1";
  };
  btwquests-wrath-of-the-lich-king = zipAddon {
    name = "btwquests-wrath-of-the-lich-king";
    version = "1.27";
    url = "https://cdn.wowinterface.com/downloads/getfile.php?id=25784&d=1786803140&minion";
    sha256 = "0zgsd84mr1id3v8xdyw6gdn3xicgh6crpvj16gxd8zncid1qrqjw";
  };
  gtfo = zipAddon {
    name = "gtfo";
    version = "6.9.1";
    url = "https://www.wowinterface.com/downloads/getfile.php?id=17996&aid=171263";
    sha256 = "1bhqmbs2psbm3kpaanlw5manq63sppnxkrzmk7pj797k2jr18bd8";
  };
  bug-grabber = svnAddon {
    name = "bug-grabber";
    url = "https://repos.curseforge.com/wow/bug-grabber/trunk";
    rev = "399";
    sha256 = "17m83zcpc2kswhgcw6fdcr79qymk426j9h4zdd3z7xi38b2cfgcf";
    target = "!BugGrabber";
  };
  snake-says = githubReleaseAddon {
    name = "SnakeSays";
    owner = "lgkern";
    repo = "SnakeSays";
    rev = "v3.3.5";
    asset = "SnakeSays-v3.3.5.zip";
    sha256 = "01xn8m3mvad51vrgxsqnirwm6hy2ajg8am1k6r8i696zbny832bh";
    subdir = "SnakeSays";
  };
  oilvl = zipAddon {
    name = "Oilvl";
    version = "12.1.0";
    url = "https://edge.forgecdn.net/files/8631/184/Oilvl12.1.0.zip";
    sha256 = "0vbk22rrj0a8mdlc484wsyqlw1plf6yrk1wa8qc6668i3mdrrcpz";
  };
  OPie = zipAddon {
    name = "OPie";
    version = "8.8.1";
    url = "https://edge.forgecdn.net/files/8646/911/OPie-8.8.1.zip";
    sha256 = "1ip5ccda5i51a1ijri7r5m3xdzkg4pw8c438r335nia55w1m1s31";
  };
}
