#!/usr/bin/env bash
# sync-exchange.sh — Sincroniza la carpeta exchange/ entre AgenteManager-1-1 y Engineer-1-1.
#
#   Manager → Engineer: exchange/requests-to-engineers/*_<persona>_request.md
#                       → <engineer>/exchange/manager-requests/
#   Engineer → Manager: exchange/responses-to-manager/AAAA-MM-DD_response.md
#                       → AgenteManager-1-1/exchange/engineer-updates/AAAA-MM-DD_<persona>_response.md
#
# Las respuestas solo se envían si contienen la línea "Estado: APROBADO".
# Al enviarlas se eliminan las secciones "## ⚠️ Preguntas pendientes" y "## 🔒 Solo para mí".
# Nunca sobrescribe un fichero de destino distinto: avisa y lo salta.
#
# Uso:
#   ./sync-exchange.sh <persona> [--engineer-dir DIR] [--dry-run]
#
#   <persona>          nombre usado en los ficheros del manager (p. ej. ana)
#   --engineer-dir DIR carpeta del agente del ingeniero (por defecto: Engineer-1-1)
#   --dry-run          muestra qué haría sin copiar nada

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
MANAGER_DIR="${MANAGER_DIR:-$ROOT/AgenteManager-1-1}"
ENGINEER_DIR="$ROOT/Engineer-1-1"
PERSONA=""
DRY_RUN=0

usage() { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --engineer-dir) ENGINEER_DIR="$(cd "$2" && pwd)"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage ;;
    -*) echo "Opción desconocida: $1" >&2; usage ;;
    *) [[ -z "$PERSONA" ]] || usage; PERSONA="$1"; shift ;;
  esac
done
[[ -n "$PERSONA" ]] || usage

REQ_SRC="$MANAGER_DIR/exchange/requests-to-engineers"
REQ_DST="$ENGINEER_DIR/exchange/manager-requests"
RES_SRC="$ENGINEER_DIR/exchange/responses-to-manager"
RES_DST="$MANAGER_DIR/exchange/engineer-updates"

for d in "$REQ_SRC" "$REQ_DST" "$RES_SRC" "$RES_DST"; do
  [[ -d "$d" ]] || { echo "No existe la carpeta: $d" >&2; exit 1; }
done

copied=0; skipped=0; pending=0

# Copia $1 (o el contenido de stdin si $1 es "-") a $2 sin sobrescribir cambios.
deliver() {
  local src="$1" dst="$2" tmp
  tmp="$(mktemp)"
  if [[ "$src" == "-" ]]; then cat > "$tmp"; else cat "$src" > "$tmp"; fi
  if [[ -e "$dst" ]]; then
    if cmp -s "$tmp" "$dst"; then
      rm -f "$tmp"; return
    fi
    echo "  ⚠️  $(basename "$dst") ya existe con otro contenido; no se sobrescribe."
    skipped=$((skipped + 1)); rm -f "$tmp"; return
  fi
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "  [dry-run] → $dst"; rm -f "$tmp"
  else
    mv "$tmp" "$dst"; echo "  ✓ → $dst"
  fi
  copied=$((copied + 1))
}

# Elimina las secciones privadas de una respuesta.
strip_private() {
  awk '
    /^## / { skip = ($0 ~ /^## (⚠️|🔒)/) }
    !skip
  ' "$1" | awk '
    # Quita separadores "---" y líneas vacías sobrantes al final
    { lines[NR] = $0 }
    END {
      n = NR
      while (n > 0 && (lines[n] ~ /^[[:space:]]*$/ || lines[n] == "---")) n--
      for (i = 1; i <= n; i++) print lines[i]
    }
  '
}

echo "Manager → Engineer (peticiones de $PERSONA)"
shopt -s nullglob
for f in "$REQ_SRC"/*_"${PERSONA}"_request.md; do
  deliver "$f" "$REQ_DST/$(basename "$f")"
done

echo "Engineer → Manager (respuestas aprobadas)"
for f in "$RES_SRC"/*_response.md; do
  name="$(basename "$f")"
  if ! grep -qE '^Estado:[[:space:]]*APROBADO' "$f"; then
    echo "  … $name sigue en BORRADOR; no se envía."
    pending=$((pending + 1)); continue
  fi
  date="${name%%_*}"
  strip_private "$f" | deliver - "$RES_DST/${date}_${PERSONA}_response.md"
done

echo "Hecho: $copied copiados, $skipped en conflicto, $pending borradores sin aprobar."
[[ $DRY_RUN -eq 1 ]] && echo "(dry-run: no se ha copiado nada)"
exit 0
