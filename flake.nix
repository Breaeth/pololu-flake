{
  description = "Environnement de dev Arduino avec PlatformIO, Zed et Pololu 3pi+";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShells.default = pkgs.mkShell {
          name = "arduino-dev";

          buildInputs = [
            pkgs.platformio
            pkgs.zed-editor
          ];

          shellHook = ''
            echo "📦 Environnement Arduino prêt avec PlatformIO, Zed, et AVR toolchain"

            if [ ! -f "platformio.ini" ]; then
              echo "🛠️  Initialisation du projet PlatformIO (a-star32U4)..."
              pio project init --board a-star32U4

              echo "📚 Ajout de la dépendance Pololu3piPlus32U4..."
              echo "" >> platformio.ini
              echo "lib_deps = " >> platformio.ini
              echo "  Pololu3piPlus32U4@^1.1.3" >> platformio.ini

              echo "🔁 Mise à jour du projet PlatformIO..."
              pio init --environment a-star32U4
            else
              echo "✅ Projet PlatformIO déjà initialisé."
            fi

            if command -v zeditor &> /dev/null; then
              echo "🚀 Lancement de Zed..."
              zeditor .
            else
              echo "⚠️ Zed n'est pas installé ou non disponible dans le PATH"
            fi
          '';
        };
      });
}
