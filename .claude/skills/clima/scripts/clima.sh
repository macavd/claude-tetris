#!/usr/bin/env bash
# Consulta el clima usando wttr.in (gratuito, sin API key).
# Uso:
#   clima.sh "Madrid"        -> clima de Madrid
#   clima.sh                 -> clima de Córdoba, Argentina (ubicación por defecto)
#
# Reemplaza espacios por '+' en el argumento antes de llamar (p. ej. "New+York").

set -euo pipefail

# Ubicación por defecto: Córdoba, Argentina.
# Se usa 'Cordoba,AR' para desambiguar de Córdoba (España).
LOCATION="${1:-Cordoba,AR}"

# Formato compacto y legible (wttr.in interpreta los \n literales):
#   %l ubicacion  %C condicion  %c icono  %t temp  %f sensacion
#   %h humedad    %w viento     %p precip %P presion
FORMAT='Ubicacion: %l\nCondicion: %C %c\nTemperatura: %t (sensacion %f)\nHumedad: %h\nViento: %w\nPrecipitacion: %p\nPresion: %P\n'

BASE="https://wttr.in/${LOCATION}"

fetch_current() {
  if command -v curl >/dev/null 2>&1; then
    # -G + --data-urlencode codifica correctamente formato, espacios y saltos
    curl -fsSL --max-time 20 -H "Accept-Language: es" -G "$BASE" \
      --data-urlencode "format=${FORMAT}" --data-urlencode "m"
  else
    fetch_ps "${BASE}?format=$(ps_encode "${FORMAT}")&m"
  fi
}

fetch_forecast() {
  local url="${BASE}?2nAT&m"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL --max-time 20 -H "Accept-Language: es" "$url"
  else
    fetch_ps "$url"
  fi
}

# Fallback a PowerShell si no hay curl (Windows sin curl en PATH).
fetch_ps() {
  local url="$1"
  powershell.exe -NoProfile -Command \
    "[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; (Invoke-RestMethod -Uri '$url' -Headers @{'Accept-Language'='es'} -TimeoutSec 20)"
}

ps_encode() {
  powershell.exe -NoProfile -Command "[System.Uri]::EscapeDataString('$1')"
}

echo "=== Clima actual ==="
if ! fetch_current; then
  echo "No se pudo obtener el clima (¿sin conexión o wttr.in no disponible?)." >&2
  exit 1
fi

echo ""
echo "=== Pronóstico (2 días) ==="
fetch_forecast || echo "No se pudo obtener el pronóstico extendido." >&2
