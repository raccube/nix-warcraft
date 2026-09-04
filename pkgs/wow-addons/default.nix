{pkgs}: let
  addonLib = import ../../modules/wow/addons.nix {inherit pkgs;};
in {
  bigwigs = import ./bigwigs.nix addonLib;
  btwquests = import ./btwquests.nix addonLib;
  adventure-guide-lockouts = import ./adventure-guide-lockouts.nix addonLib;
  mog-companions = import ./mog-companions.nix addonLib;
  narcissus = import ./narcissus.nix addonLib;
  plumber = import ./plumber.nix addonLib;
  weekly-knowledge = import ./weekly-knowledge.nix addonLib;
  yui-dialogue = import ./yui-dialogue.nix addonLib;
  ability-timeline = import ./ability-timeline.nix addonLib;
  angleur = import ./angleur.nix addonLib;
  bugsack = import ./bugsack.nix addonLib;
  craftsim = import ./craftsim.nix addonLib;
  handynotes = import ./handynotes.nix addonLib;
  idtip = import ./idtip.nix addonLib;
  littlewigs = import ./littlewigs.nix addonLib;
  simc-addon = import ./simc-addon.nix addonLib;
  wow-handynotes-midnight = import ./wow-handynotes-midnight.nix addonLib;
  altoholic = import ./altoholic.nix addonLib;
  gtfo = import ./gtfo.nix addonLib;
  bug-grabber = import ./bug-grabber.nix addonLib;
  snake-says = import ./snake-says.nix addonLib;
  oilvl = import ./oilvl.nix addonLib;
  opie = import ./opie.nix addonLib;
}
