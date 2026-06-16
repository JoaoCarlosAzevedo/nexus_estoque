#!/usr/bin/env bash
#
# Build do projeto para Web com workaround para o pacote `bluetooth_print_plus`.
#
# Contexto:
#   O pacote `bluetooth_print_plus ^1.5.2` declara suporte à plataforma Web,
#   porém a classe `BluetoothPrintPlusWeb` no pub-cache tem o método
#   `registerWith` comentado (stub vazio). Isso faz o Flutter gerar um
#   `web_plugin_registrant.dart` que invoca `BluetoothPrintPlusWeb.registerWith`,
#   quebrando o `dart2js` com:
#     Error: Member not found: 'BluetoothPrintPlusWeb.registerWith'.
#
# Estratégia (zero refatoração de código):
#   1. `flutter pub get` para garantir `.flutter-plugins-dependencies` atualizado.
#   2. Primeiro build web (esperado falhar no dart2js APÓS gerar o registrant).
#   3. Remove do(s) `web_plugin_registrant.dart` gerado(s) o import e a chamada
#      problemática de `BluetoothPrintPlusWeb`.
#   4. Build web final. O Flutter NÃO regera o registrant porque o conteúdo de
#      `.flutter-plugins-dependencies` não mudou (build incremental).
#
# Uso:
#   ./tool/build_web.sh                    # default: --release
#   ./tool/build_web.sh --profile
#   ./tool/build_web.sh --release --web-renderer canvaskit
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

if command -v fvm >/dev/null 2>&1 && [ -d "$PROJECT_ROOT/.fvm" ]; then
  FLUTTER=(fvm flutter)
else
  FLUTTER=(flutter)
fi

if [ $# -eq 0 ]; then
  BUILD_ARGS=(--release)
else
  BUILD_ARGS=("$@")
fi

log() { printf '\n==> %s\n' "$*"; }

patch_registrant_files() {
  local count=0
  local patched_any=0
  while IFS= read -r -d '' file; do
    if grep -q "BluetoothPrintPlusWeb" "$file"; then
      sed -i.bak \
        -e "/import 'package:bluetooth_print_plus\/bluetooth_print_plus_web\.dart';/d" \
        -e "/BluetoothPrintPlusWeb\.registerWith(registrar);/d" \
        "$file"
      rm -f "$file.bak"
      printf '    patched: %s\n' "$file"
      patched_any=1
    fi
    count=$((count + 1))
  done < <(find .dart_tool/flutter_build -name "web_plugin_registrant.dart" -type f -print0 2>/dev/null)

  if [ "$count" -eq 0 ]; then
    echo "    nenhum web_plugin_registrant.dart encontrado em .dart_tool/flutter_build"
  elif [ "$patched_any" -eq 0 ]; then
    echo "    nenhum arquivo precisou de patch (BluetoothPrintPlusWeb não encontrado)"
  fi
}

log "Flutter: ${FLUTTER[*]}"
log "Build args: ${BUILD_ARGS[*]}"

log "[1/4] flutter pub get"
"${FLUTTER[@]}" pub get

log "[2/4] Build web inicial (pode falhar no dart2js para forçar geração do registrant)"
set +e
"${FLUTTER[@]}" build web "${BUILD_ARGS[@]}"
FIRST_EXIT=$?
set -e

log "[3/4] Aplicando patch no(s) web_plugin_registrant.dart"
patch_registrant_files

if [ $FIRST_EXIT -eq 0 ]; then
  log "Primeiro build já passou; nada a refazer."
  exit 0
fi

log "[4/4] Build web final"
"${FLUTTER[@]}" build web "${BUILD_ARGS[@]}"

log "Build web concluído com sucesso. Saída em build/web/"
