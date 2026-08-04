---
name: clima
description: Consulta información del clima (tiempo actual y pronóstico) para una ciudad o ubicación; por defecto Córdoba, Argentina. Úsala cuando el usuario pregunte por el clima, el tiempo, la temperatura, si va a llover, el pronóstico, o pida datos meteorológicos de un lugar. Ejemplos - "¿qué clima hace?", "el tiempo de mañana", "¿va a llover en Buenos Aires?".
---

# Clima

Obtiene el clima de forma local usando el servicio gratuito `wttr.in`, que no
requiere API key ni registro. Funciona vía HTTP simple, por lo que basta con
`curl` (o el fallback de PowerShell) disponible en la máquina.

## Cómo usarla

1. Determina la **ubicación** a partir de lo que pidió el usuario:
   - Si menciona una ciudad, país o lugar, úsalo (p. ej. `Madrid`, `Buenos+Aires`, `Tokyo`).
   - Si NO menciona ninguna ubicación, deja el argumento vacío: el script usa
     **Córdoba, Argentina** como ubicación por defecto.
   - Para nombres con espacios, reemplaza los espacios por `+` (p. ej. `New+York`).

2. Ejecuta el script auxiliar `scripts/clima.sh` con la ubicación como argumento
   (o sin argumento para el clima de Córdoba, Argentina):

   ```bash
   bash .claude/skills/clima/scripts/clima.sh "Madrid"
   bash .claude/skills/clima/scripts/clima.sh            # Córdoba, Argentina (por defecto)
   ```

   El script usa `curl` y cae a PowerShell (`Invoke-RestMethod`) si `curl` no está
   disponible. Devuelve un resumen compacto con temperatura, sensación térmica,
   condición, humedad y viento, más un pronóstico corto.

3. **Presenta el resultado** al usuario en español, de forma clara y breve. Resume
   los datos relevantes (temperatura, condición, si conviene llevar paraguas, etc.)
   en lugar de volcar la salida cruda, salvo que el usuario pida el detalle completo.

## Notas

- Todos los textos hacia el usuario van en **español**.
- Si la petición es sobre el pronóstico de los próximos días, incluye el bloque de
  pronóstico; si solo pregunta "¿qué tiempo hace ahora?", basta con las condiciones
  actuales.
- Si `wttr.in` no responde (sin conexión o servicio caído), infórmalo con claridad
  y no inventes datos meteorológicos.
- El servicio acepta unidades: el script pide métricas (`?m`, grados Celsius y km/h).
