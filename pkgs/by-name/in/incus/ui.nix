{ lxd
, fetchFromGitHub
, git
}:

lxd.ui.overrideAttrs(prev: rec {
  pname = "incus-ui";

  zabbly = fetchFromGitHub {
    owner = "zabbly";
    repo = "incus";
    rev = "8bbe23f42beedd845bd95069c06f4d0c85e450b6";
    hash = "sha256-X0I8vrhvg5mLGAY8oEU/nr2pvDJ8ZqLUSY9WBqwmolE=";
  };

  nativeBuildInputs = prev.nativeBuildInputs ++ [
    git
  ];

  patchPhase = ''
    for p in $zabbly/patches/ui-canonical*; do
      echo "applying patch $p"
      git apply -p1 "$p"
    done
    sed -i "s/LXD/Incus/g" src/*/*.ts* src/*/*/*.ts* src/*/*/*/*.ts*
    sed -i "s/devlxd/guestapi/g" src/*/*.ts* src/*/*/*.ts* src/*/*/*/*.ts*
    sed -i "s/dev\/lxd/dev\/incus/g" src/*/*.ts* src/*/*/*.ts* src/*/*/*/*.ts*
    sed -i "s/lxd_/incus_/g" src/*/*.ts* src/*/*/*.ts* src/*/*/*/*.ts*
    sed -i "s/\"lxd\"/\"incus\"/g" src/*/*.ts* src/*/*/*.ts* src/*/*/*/*.ts*

  '';
})
