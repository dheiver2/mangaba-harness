#!/usr/bin/env bash
# Mangaba Harness — sobe os dois servidores de uma vez: o Ollama (modelos
# locais, porta 11434) e a Web UI do harness (porta 3081).
#
#   ./start.sh              sobe os dois e segue no terminal (Ctrl-C derruba)
#   ./start.sh --detach     sobe os dois em background e devolve o terminal
#   ./start.sh --stop       derruba o que este script subiu
#   MH_PORT=4000 ./start.sh usa outra porta para a Web UI
#
# Um Ollama que já estava rodando é reaproveitado e NÃO é derrubado na saída —
# só o que este script iniciou.
set -euo pipefail

cd "$(dirname "$0")"
PORT="${MH_PORT:-3081}"
RUN_DIR="${TMPDIR:-/tmp}/mangaba-harness"
OLLAMA_PID_FILE="$RUN_DIR/ollama.pid"
WEB_PID_FILE="$RUN_DIR/web.pid"
LOG_DIR="$RUN_DIR/logs"
DETACH=0
mkdir -p "$LOG_DIR"

say() { printf '\033[1m==> %s\033[0m\n' "$1"; }
die() { printf '\033[31merro: %s\033[0m\n' "$1" >&2; exit 1; }
ollama_up() { curl -sf -m 2 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; }
web_up() { curl -sf -m 2 "http://127.0.0.1:$PORT" >/dev/null 2>&1; }

# `pnpm dsh web` roda o servidor num filho, então matar só o pid registrado
# deixa o node de pé segurando a porta. Cada serviço sobe com job control
# ligado (`set -m`), ganhando um process group próprio; matar o grupo inteiro
# (`kill -- -pid`) leva o filho junto. O kill direto fica de reserva para o
# caso de o grupo já não existir.
stop_all() {
  for pair in "web:$WEB_PID_FILE" "ollama:$OLLAMA_PID_FILE"; do
    name="${pair%%:*}"; file="${pair#*:}"
    if [ -f "$file" ]; then
      pid=$(cat "$file")
      if kill -0 "$pid" 2>/dev/null; then
        say "derrubando $name (pid $pid)"
        kill -- "-$pid" 2>/dev/null || kill "$pid" 2>/dev/null || true
      fi
      rm -f "$file"
    fi
  done
}

for arg in "$@"; do
  case "$arg" in
    --detach|-d) DETACH=1 ;;
    --stop) stop_all; exit 0 ;;
    -h|--help) sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "flag desconhecida: $arg" ;;
  esac
done

# --- 1. Ollama -------------------------------------------------------------
if ollama_up; then
  say "Ollama já está rodando em 11434 (reaproveitando)"
else
  command -v ollama >/dev/null || die "ollama não encontrado. Instale: brew install ollama"
  say "Subindo Ollama"
  set -m
  ollama serve > "$LOG_DIR/ollama.log" 2>&1 &
  echo $! > "$OLLAMA_PID_FILE"
  set +m
  for _ in $(seq 1 30); do ollama_up && break; sleep 1; done
  ollama_up || die "Ollama não respondeu em 30s — veja $LOG_DIR/ollama.log"
  echo "ok: http://127.0.0.1:11434"
fi

# --- 1b. Credenciais opcionais ---------------------------------------------
# Um provider remoto configurado em settings.yaml resolve sua chave por
# apiKeyEnv, e o harness recusa a rota inteira quando a variável não existe.
# O token do Hugging Face costuma estar no disco por causa do `hf` CLI; se
# estiver, ele entra no ambiente do servidor. Um HF_TOKEN já exportado vence.
load_key() {
  # $1 variable name, $2 file to read it from
  eval "current=\${$1:-}"
  [ -n "$current" ] && return 0
  [ -r "$2" ] || return 0
  value=$(tr -d '\r\n' < "$2")
  [ -z "$value" ] && return 0
  export "$1=$value"
  say "$1 carregado de $2"
}

HF_TOKEN_FILE="${HF_TOKEN_FILE:-$HOME/.cache/huggingface/token}"
load_key HF_TOKEN "$HF_TOKEN_FILE"

# The Mangaba providers (app.mangaba.ia.br, chat.mangaba.ia.br) resolve this
# one. Kept in a file outside the settings document, which the Models page
# rewrites and which is easy to paste into a screenshot or a commit.
MANGABA_KEY_FILE="${MANGABA_KEY_FILE:-$HOME/.config/mangaba/api-key}"
load_key MANGABA_API_KEY "$MANGABA_KEY_FILE"

# --- 2. Web UI -------------------------------------------------------------
if web_up; then
  die "já existe algo respondendo na porta $PORT — use MH_PORT=outra ou ./start.sh --stop"
fi
say "Subindo a Web UI do Mangaba Harness"
set -m
OLLAMA_API_KEY="${OLLAMA_API_KEY:-ollama}" pnpm dsh web --port "$PORT" --no-open \
  > "$LOG_DIR/web.log" 2>&1 &
echo $! > "$WEB_PID_FILE"
set +m
for _ in $(seq 1 60); do web_up && break; sleep 1; done
web_up || { tail -20 "$LOG_DIR/web.log"; die "a Web UI não subiu — log acima"; }

say "Os dois no ar"
echo "  Ollama:  http://127.0.0.1:11434"
echo "  Web UI:  http://127.0.0.1:$PORT"
echo "  logs:    $LOG_DIR"

if [ "$DETACH" = 1 ]; then
  echo
  echo "Rodando em background. Para derrubar: $0 --stop"
  exit 0
fi

trap 'echo; stop_all; exit 0' INT TERM
echo
echo "Ctrl-C derruba os dois. Seguindo o log da Web UI:"
echo
tail -f "$LOG_DIR/web.log"
