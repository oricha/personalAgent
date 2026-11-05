# CLAUDE.md — AgenteManager-1-1

**Usa siempre `assistant-agent.md`** como instrucciones principales. Léelo al inicio de cada sesión junto con `about-me.md`.

## Ficheros, plantillas y flujos

### Estructura
| Ruta | Qué contiene |
|---|---|
| `assistant-agent.md` | Rol, contexto del equipo, responsabilidades, cómo pensar y cómo trabajar conmigo. |
| `about-me.md` | Quién soy como manager: estilo, objetivos de liderazgo, puntos ciegos conocidos. |
| `raw-transcripts/` | Transcripciones o notas libres **sin procesar** (1:1s, reuniones). Nunca se editan. |
| `1-1-processed/` | Resúmenes de 1:1 generados con `templates/post-1-1-template.md`. |
| `meetings-processed/` | Resúmenes de otras reuniones con `templates/post-meeting-template.md`. |
| `people-profiles/` | Un perfil vivo por persona con `templates/profile-template.md`. |
| `task-tracker/` | Compromisos y acciones abiertas con `templates/task-template.md`. |
| `leadership-reflections/` | Reflexiones sobre mi liderazgo, patrones propios y puntos ciegos. |
| `exchange/requests-to-engineers/` | Peticiones de preparación que envío al agente **Engineer-1-1** antes del 1:1. |
| `exchange/engineer-updates/` | Respuestas que el agente **Engineer-1-1** me devuelve (lo que el ingeniero decide compartir). |
| `templates/` | Plantillas. No se editan salvo para mejorar el sistema. |

### Convención de nombres
- Transcripciones: `raw-transcripts/AAAA-MM-DD_nombre-persona_1-1.md` o `AAAA-MM-DD_nombre-reunion.md`
- 1:1 procesado: `1-1-processed/AAAA-MM-DD_nombre-persona.md`
- Perfil: `people-profiles/nombre-persona.md`
- Tareas: `task-tracker/nombre-persona.md` (una por persona) + `task-tracker/_mis-compromisos.md`
- Exchange: `exchange/requests-to-engineers/AAAA-MM-DD_nombre-persona_request.md` y `exchange/engineer-updates/AAAA-MM-DD_nombre-persona_response.md`

## Flujos de trabajo (workflows)

### 1. Preparar un 1:1 — "prepara mi 1:1 con <persona>"
1. Lee `people-profiles/<persona>.md`, los 2–3 últimos `1-1-processed/` de esa persona y `task-tracker/<persona>.md`.
2. Lee la última respuesta en `exchange/engineer-updates/` si existe.
3. Genera la preparación con `templates/pre-1-1-template.md`.
4. Si hace falta, genera la petición para el ingeniero con `templates/1-1-request-template.md` en `exchange/requests-to-engineers/`. **Nunca** incluyas en la petición notas privadas del perfil ni hipótesis sobre la persona.
5. Sincroniza con el agente del ingeniero: `./sync-exchange.sh <persona>` desde la raíz del proyecto (añade `--engineer-dir <carpeta>` si cada ingeniero tiene su propia carpeta, y `--dry-run` para ver qué haría). Envía la petición y recoge las respuestas que el ingeniero ya haya aprobado.

### 2. Procesar un 1:1 — "procesa el 1:1 de <persona>"
1. Lee la transcripción en `raw-transcripts/`.
2. Rellena `templates/post-1-1-template.md` → `1-1-processed/`.
3. Actualiza `people-profiles/<persona>.md` (solo con hechos con fuente).
4. Actualiza `task-tracker/<persona>.md` y `task-tracker/_mis-compromisos.md`.
5. Señala patrones que se repitan en ≥2 conversaciones y propón máximo 3 acciones.

### 3. Procesar otra reunión — "procesa la reunión <x>"
`templates/post-meeting-template.md` → `meetings-processed/`; extrae compromisos al `task-tracker/`.

### 4. Situación difícil — "ayúdame con <situación>"
Usa el modo *thinking partner*: separa hechos de interpretaciones, pregunta lo que falte, ofrece 2–3 enfoques con pros/contras. La decisión es mía.

### 5. Revisión de desempeño — "prepara la review de <persona>"
Reúne evidencia de los últimos 6 meses (1:1s, reuniones, engineer-updates, tareas). Presenta hechos con fuente. **No propongas la calificación**: la decisión y el feedback son humanos.

### 6. Salud del equipo — "¿cómo está el equipo?"
Cruza perfiles y 1:1s recientes contra las 6 condiciones (ver `assistant-agent.md`). Distingue problemas individuales de sistémicos.

### 7. Reflexión de liderazgo — "quiero reflexionar sobre <x>"
`templates/reflection-template.md` → `leadership-reflections/AAAA-MM-DD_tema.md`. Busca patrones con reflexiones anteriores y con los puntos ciegos de `about-me.md`.

### 8. Mantenimiento del jardín — "revisa el sistema" (mensual)
Poda contexto obsoleto, cierra tareas resueltas, detecta plantillas que no se usan y propone mejoras a reglas/estructura.

## Guardrails
- **No asumas, pregunta.** Si falta contexto, dilo y pregunta.
- **Referencia fuentes.** Cada afirmación sobre una persona cita el fichero y la fecha de origen, p. ej. `[1-1-processed/2026-10-20_ana.md]`.
- **No inventes motivaciones.** Describe comportamientos observados, no intenciones.
- Los datos de las personas son confidenciales: no salen de esta carpeta salvo lo que yo decida compartir.
