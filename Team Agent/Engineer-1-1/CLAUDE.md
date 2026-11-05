# CLAUDE.md — Engineer-1-1

**Usa siempre `assistant-agent.md`** como instrucciones principales. Léelo al inicio de cada sesión junto con `about-me.md`.

## Ficheros, plantillas y flujos

### Estructura
| Ruta | Qué contiene |
|---|---|
| `assistant-agent.md` | Rol, mi contexto, responsabilidades, cómo pensar y cómo trabajar conmigo. |
| `about-me.md` | Quién soy como ingeniero: rol, stack, objetivos, cómo trabajo mejor. |
| `raw-notes/` | Notas libres, transcripciones de mis 1:1s, ideas sueltas. **Sin procesar**, nunca se editan. |
| `work-log/` | Registro semanal de lo que hago, logros e impacto (evidencia para 1:1s y reviews). |
| `goals-growth/` | Mis objetivos de carrera y plan de crecimiento. |
| `1-1-processed/` | Mi resumen de cada 1:1 (mi perspectiva). |
| `task-tracker/` | Compromisos que asumo en los 1:1s y lo que mi manager me debe. |
| `exchange/manager-requests/` | Peticiones de preparación que llegan del agente **AgenteManager-1-1**. |
| `exchange/responses-to-manager/` | Respuestas que envío al agente Manager (**solo lo que yo apruebo compartir**). |
| `templates/` | Plantillas. |

### Convención de nombres
- Notas: `raw-notes/AAAA-MM-DD_tema.md`
- Work log: `work-log/AAAA-Wsemana.md` (p. ej. `2026-W43.md`)
- 1:1 procesado: `1-1-processed/AAAA-MM-DD_1-1.md`
- Exchange: `exchange/manager-requests/AAAA-MM-DD_request.md` → `exchange/responses-to-manager/AAAA-MM-DD_response.md`

## Flujos de trabajo (workflows)

### 1. Responder a la petición del manager — "responde a la petición del 1:1"
1. Lee la petición más reciente en `exchange/manager-requests/`.
2. Reúne evidencia: `work-log/` desde el último 1:1, `task-tracker/`, `goals-growth/`, último `1-1-processed/`.
3. Genera un **borrador** con `templates/1-1-response-template.md`, contestando **todas** las secciones de la petición.
4. Marca con `⚠️ PREGUNTA` lo que no puedas responder con mis ficheros — pregúntamelo, no lo inventes.
5. **Revisión obligatoria:** muéstrame el borrador y señala cualquier información personal o sensible. Se guarda en `exchange/responses-to-manager/` con `Estado: BORRADOR`; solo tras mi OK explícito cambias la línea a `Estado: APROBADO`.
6. Para enviarla al manager: `./sync-exchange.sh <mi-nombre>` desde la raíz del proyecto. El script solo envía respuestas aprobadas y elimina las secciones "⚠️ Preguntas pendientes" y "🔒 Solo para mí".

### 2. Preparar mi 1:1 — "prepara mi 1:1"
`templates/pre-1-1-template.md`: qué quiero pedir, qué feedback dar, qué decisiones necesito de mi manager.

### 3. Procesar mi 1:1 — "procesa mi 1:1"
Transcripción/notas en `raw-notes/` → `templates/post-1-1-template.md` → `1-1-processed/`. Actualiza `task-tracker/` y `goals-growth/`.

### 4. Registro semanal — "registra mi semana" (viernes)
`templates/work-log-template.md` → `work-log/`. Pregunta por impacto, no solo actividad.

### 5. Objetivos y crecimiento — "revisa mis objetivos"
`templates/goals-template.md` → `goals-growth/`. Contrasta con evidencia del `work-log/`.

### 6. Preparar autoevaluación / review — "prepara mi autoevaluación"
Recopila logros con fuente de los últimos 6 meses. La valoración final y el tono los decido yo.

### 7. Mantenimiento del jardín — "revisa el sistema" (mensual)
Poda notas obsoletas, cierra tareas, propone mejoras a reglas y plantillas.

## Guardrails
- **No asumas, pregunta.** **Referencia fuentes** (fichero + fecha) en cada logro o afirmación.
- **Nada sale hacia el manager sin mi aprobación explícita.**
- No incluyas información sobre compañeros salvo que yo lo pida expresamente; describe hechos, no juicios sobre personas.
- No exageres ni minimices logros: evidencia, impacto y contexto.
