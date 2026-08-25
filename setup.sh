#!/usr/bin/env bash
# Mangaba Harness — setup on a fresh machine.
#
#   ./setup.sh            install deps, build, create the Ollama models, write settings
#   ./setup.sh --no-model skip the Ollama part (remote gateway only)
#   ./setup.sh --run      do all of the above, then start the Web UI
#
# Re-running is safe: every step checks before it acts.
set -euo pipefail

PORT="${MH_PORT:-3081}"
DSH_HOME="${DSH_HOME:-$HOME/.dsh}"
SETTINGS="$DSH_HOME/settings.yaml"
WITH_MODEL=1
RUN=0
for arg in "$@"; do
  case "$arg" in
    --no-model) WITH_MODEL=0 ;;
    --run) RUN=1 ;;
    -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown flag: $arg" >&2; exit 2 ;;
  esac
done

say() { printf '\n\033[1m==> %s\033[0m\n' "$1"; }
die() { printf '\033[31merro: %s\033[0m\n' "$1" >&2; exit 1; }

say "Checando pré-requisitos"
command -v node >/dev/null || die "Node não encontrado. Instale Node >= 22.19 (brew install node)."
NODE_MAJOR=$(node -p 'process.versions.node.split(".")[0]')
[ "$NODE_MAJOR" -ge 22 ] || die "Node $(node -v) é antigo demais; o harness exige >= 22.19."
command -v pnpm >/dev/null || die "pnpm não encontrado. Instale com: npm i -g pnpm@11"
echo "node $(node -v), pnpm $(pnpm -v)"

say "Instalando dependências (pnpm install)"
pnpm install

say "Compilando (pnpm run build)"
pnpm run build

if [ "$WITH_MODEL" = 1 ]; then
  say "Modelos locais (Ollama)"
  if ! command -v ollama >/dev/null; then
    echo "ollama não encontrado — pulando os modelos locais."
    echo "Para instalar: brew install ollama && brew services start ollama"
    WITH_MODEL=0
  else
    curl -sf -m 3 http://127.0.0.1:11434/api/tags >/dev/null \
      || die "Ollama instalado mas não está respondendo em 11434. Rode: brew services start ollama"
    # O system prompt do harness é grande: com os 4k padrão do Ollama ele é
    # truncado e o modelo passa a escrever tool calls como texto solto.
    for pair in "mangaba:8b qwen3:8b" "mangaba:4b qwen3:4b"; do
      set -- $pair
      if ollama list | grep -q "^$1[[:space:]]"; then
        echo "$1 já existe"
      else
        echo "criando $1 a partir de $2 (baixa ~5GB na primeira vez)"
        ollama pull "$2"
        printf 'FROM %s\nPARAMETER num_ctx 32768\n' "$2" | ollama create "$1" -f -
      fi
    done
  fi
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
        - id: mangaba:8b
        - id: mangaba:4b
agent-default-model:
  provider: mangaba-local
  model: mangaba:8b
YAML
  echo "provider mangaba-local gravado"
else
  echo "sem modelo local — configure um provider pela tela (Settings → Models)"
fi

say "Atalho global (opcional)"
BIN_DIR="$HOME/.local/bin"
if [ -d "$BIN_DIR" ] && [ -w "$BIN_DIR" ]; then
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
