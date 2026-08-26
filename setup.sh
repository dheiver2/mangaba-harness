#!/usr/bin/env bash
# Mangaba Harness — setup on a fresh machine.
#
#   ./setup.sh            deps, build, one local model, settings — then tells you how to start
#   ./setup.sh --run      the same, and starts the Web UI when it finishes
#   ./setup.sh --full     also pull the 8B model (slower on 16GB machines)
#   ./setup.sh --no-model skip Ollama entirely (remote provider only)
#
# The default pulls ONE model: qwen3:4b, ~2.5GB. The instruct variant answers
# far faster, but measured against this harness it does not call the tools —
# it replies that it cannot read files. A fast wrong first answer is worse than
# a slower right one, so the default is the variant that actually works.
#
# Re-running is safe: every step checks before it acts.
set -euo pipefail

PORT="${MH_PORT:-3081}"
DSH_HOME="${DSH_HOME:-$HOME/.dsh}"
SETTINGS="$DSH_HOME/settings.yaml"
WITH_MODEL=1
FULL=0
RUN=0
for arg in "$@"; do
  case "$arg" in
    --no-model) WITH_MODEL=0 ;;
    --full) FULL=1 ;;
    --run) RUN=1 ;;
    -h|--help) sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "flag desconhecida: $arg" >&2; exit 2 ;;
  esac
done

say() { printf '\n\033[1m==> %s\033[0m\n' "$1"; }
die() { printf '\033[31merro: %s\033[0m\n' "$1" >&2; exit 1; }

# Everything missing is reported in one pass. Failing on the first gap sends a
# newcomer through install → rerun → next gap → rerun, which is the slowest way
# to learn what the project needs.
say "Checando pré-requisitos"
MISSING=""
if ! command -v node >/dev/null; then
  MISSING="$MISSING\n  node        brew install node          (precisa de >= 22.19)"
elif [ "$(node -p 'process.versions.node.split(".")[0]')" -lt 22 ]; then
  MISSING="$MISSING\n  node $(node -v)  brew upgrade node          (precisa de >= 22.19)"
fi
command -v pnpm >/dev/null || MISSING="$MISSING\n  pnpm        npm i -g pnpm@11"
if [ "$WITH_MODEL" = 1 ] && ! command -v ollama >/dev/null; then
  MISSING="$MISSING\n  ollama      brew install ollama && brew services start ollama"
  MISSING="$MISSING\n              (ou rode com --no-model e configure um provider remoto)"
fi
if [ -n "$MISSING" ]; then
  printf '\033[31mFaltam pré-requisitos:\033[0m'
  printf "$MISSING\n\n"
  exit 1
fi
echo "node $(node -v), pnpm $(pnpm -v)$(command -v ollama >/dev/null && echo ", ollama $(ollama --version 2>/dev/null | tail -1)")"

say "Instalando dependências (pnpm install)"
pnpm install

say "Compilando (pnpm run build)"
pnpm run build

if [ "$WITH_MODEL" = 1 ]; then
  say "Modelo local (Ollama)"
  curl -sf -m 3 http://127.0.0.1:11434/api/tags >/dev/null \
    || die "Ollama instalado mas não responde em 11434. Rode: brew services start ollama"

  # One model by default: the smallest that actually completes a tool-using
  # task here. Measured on this machine, a simple "read a file and answer"
  # takes about a minute on the 4B — the 8B takes several, which is why --full
  # is opt-in rather than the first thing a newcomer waits for.
  MODELS="mangaba:4b qwen3:4b"
  [ "$FULL" = 1 ] && MODELS="$MODELS
mangaba:8b qwen3:8b"

  # `ollama create -f -` is NOT supported — it reports "no Modelfile or
  # safetensors files found" and the whole setup dies there. The Modelfile has
  # to be a real file.
  MODELFILE=$(mktemp)
  trap 'rm -f "$MODELFILE"' EXIT

  echo "$MODELS" | while read -r name base; do
    [ -z "$name" ] && continue
    if ollama list | grep -q "^$name[[:space:]]"; then
      echo "$name já existe"
      continue
    fi
    echo "baixando $base (~2.5GB na primeira vez) e criando $name"
    ollama pull "$base"
    # The harness system prompt is large: with Ollama's 4k default it is
    # truncated and the model starts writing tool calls as loose text.
    printf 'FROM %s\nPARAMETER num_ctx 32768\n' "$base" > "$MODELFILE"
    ollama create "$name" -f "$MODELFILE"
  done
fi

say "Configuração ($SETTINGS)"
mkdir -p "$DSH_HOME"
if [ -f "$SETTINGS" ] && grep -q "mangaba-local" "$SETTINGS"; then
  echo "provider mangaba-local já configurado — mantido como está"
elif [ "$WITH_MODEL" = 1 ]; then
  [ -f "$SETTINGS" ] && cp "$SETTINGS" "$SETTINGS.bak.$(date +%s)" && echo "backup do settings anterior gravado"
  cat >> "$SETTINGS" <<'YAML'
llm-pi-ai:
  providers:
    mangaba-local:
      displayName: Mangaba (local)
      api: openai-completions
      baseURL: http://127.0.0.1:11434/v1
      apiKeyEnv: OLLAMA_API_KEY
      compat:
        supportsDeveloperRole: false
        maxTokensField: max_tokens
      models:
        - id: mangaba:4b
agent-default-model:
  provider: mangaba-local
  model: mangaba:4b
YAML
  echo "provider mangaba-local gravado"
else
  echo "sem modelo local — configure um provider pela tela (Settings → Models)"
fi

say "Atalho global (opcional)"
BIN_DIR="$HOME/.local/bin"
# A second checkout must not silently steal the command from the first: the
# next `mangaba` would start a different tree than the user expects, and
# nothing on screen would say so.
if [ -e "$BIN_DIR/mangaba" ] && ! grep -q "$(pwd)/start.sh" "$BIN_DIR/mangaba" 2>/dev/null; then
  echo "$BIN_DIR/mangaba já aponta para outro checkout — mantido."
  echo "Para usar este: MANGABA_HOME=$(pwd) mangaba"
elif [ -d "$BIN_DIR" ] && [ -w "$BIN_DIR" ]; then
  cat > "$BIN_DIR/mangaba" <<SH
#!/usr/bin/env bash
# Atalho global para o Mangaba Harness: sobe Ollama + Web UI de qualquer diretório.
exec "\${MANGABA_HOME:-$(pwd)}/start.sh" "\$@"
SH
  chmod +x "$BIN_DIR/mangaba"
  echo "instalado: mangaba -> $(pwd)/start.sh"
else
  echo "$BIN_DIR não existe ou não é gravável — pulando o atalho"
fi

say "Pronto"
cat <<TXT
Subir tudo (Ollama + Web UI):

  mangaba              # ou ./start.sh, se o atalho não foi instalado
  mangaba --detach     # em background
  mangaba --stop       # derruba

Rodar uma tarefa só, sem UI:

  OLLAMA_API_KEY=ollama pnpm dsh --profile headless "sua tarefa"
TXT

if [ "$RUN" = 1 ]; then
  say "Subindo a Web UI em http://127.0.0.1:$PORT"
  OLLAMA_API_KEY=ollama exec pnpm dsh web --port "$PORT"
fi
