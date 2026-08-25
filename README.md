<p align="center">
  <img src="apps/web/public/favicon.svg" alt="Mangaba" width="96" height="96">
</p>

# Mangaba Harness

English | [中文](README.zh.md)

Mangaba Harness (`mh`) is an open-source agent harness — a rebranded distribution of
[DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) (MIT), carrying the
Mangaba identity and defaults.

It is built on an **everything-is-a-plugin** architecture and powered by [Cordis](https://github.com/cordiverse/cordis), whose design is described in [_A Programming Paradigm for Spatiotemporal Composability_](https://arxiv.org/abs/2608.25512).

## Developer preview

Mangaba Harness is currently in _developer preview_ and is iterating rapidly.
**THERE WILL BE COMPATIBILITY-BREAKING CHANGES.**

Review the [safety notice](SAFETY.md) before running the project.

## Run

On a fresh machine, `setup.sh` does everything — dependencies, build, the local
Ollama models, and the provider settings:

```sh
git clone https://github.com/dheiver2/mangaba-harness.git
cd mangaba-harness
./setup.sh --run
```

It needs Node >= 22.19 and pnpm; it skips the model step when Ollama is absent
(`--no-model` skips it on purpose). Re-running is safe: each step checks first,
and an existing `settings.yaml` is backed up rather than overwritten.

Day to day, `start.sh` brings up both servers at once — Ollama on 11434 and the
Web UI on 3081:

```sh
./start.sh            # both, in the foreground; Ctrl-C stops both
./start.sh --detach   # both in the background
./start.sh --stop     # stop what the script started
```

An Ollama that was already running is reused and left alone on exit; only what
the script started is stopped.

By hand:

```sh
pnpm install
pnpm run build
pnpm dsh web
```

The command starts the Web UI at `http://127.0.0.1:3080` by default. Pass `--no-open` to run
the server without opening a browser. See the [Web UI guide](docs/user/guide/index.md).

## Local models

Any OpenAI-compatible endpoint works as a custom provider. For a local Ollama model with tool
calling, add this to `$DSH_HOME/settings.yaml`:

```yaml
llm-pi-ai:
  providers:
    ollama-local:
      name: Ollama (local)
      api: openai-completions
      baseURL: http://127.0.0.1:11434/v1
      apiKeyEnv: OLLAMA_API_KEY
      compat:
        supportsDeveloperRole: false
        maxTokensField: max_tokens
      models:
        - id: qwen3-4b-32k
agent-default-model:
  provider: ollama-local
  model: qwen3-4b-32k
```

The harness system prompt is large, so give the model real context — Ollama's 4k default
truncates it and the model then emits tool calls as plain text instead of calling tools.
Create a wider variant once:

```sh
printf 'FROM qwen3:4b\nPARAMETER num_ctx 32768\n' | ollama create qwen3-4b-32k -f -
```

See the [provider guide](docs/user/guide/providers.md).

## Community and support

Submit feedback or bug reports through [GitHub Issues](https://github.com/dheiver2/mangaba-harness/issues).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Branding

The Mangaba mark, wordmark, and palette belong to Mangaba. Everything else is upstream
DeepSeek Harness under [MIT](LICENSE); this distribution is not affiliated with or endorsed
by DeepSeek. Upstream brand assets have been removed rather than reused — see
[BRAND_GUIDELINES.md](BRAND_GUIDELINES.md).

## Development

Start with the [development guide](docs/development.md) and [architecture documentation](docs/architecture.md).

For agents, follow [AGENTS.md](AGENTS.md).

## License

[MIT](LICENSE)

Third-party dependencies and their licenses are disclosed in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
