{ pkgs, stdenv, ghc, all-cabal-hashes
, compilerConfig ? (self: super: {})
, packageSetConfig ? (self: super: {})
, overrides ? (self: super: {})
, initialPackages ? import ./hackage-packages.nix
}:

let

  inherit (stdenv.lib) extends makeExtensible;
  inherit (import ./lib.nix { inherit pkgs; }) overrideCabal makePackageSet;

  haskellPackages = makePackageSet {
    package-set = initialPackages;
    inherit ghc;
  };

  commonConfiguration = import ./configuration-common.nix { inherit pkgs; };
  nixConfiguration = import ./configuration-nix.nix { inherit pkgs; };

in

  makeExtensible
    (extends overrides
      (extends packageSetConfig
        (extends compilerConfig
          (extends commonConfiguration
            (extends nixConfiguration haskellPackages)))))
