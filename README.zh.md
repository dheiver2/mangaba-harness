<p align="center">
  <img src="apps/web/public/favicon.svg" alt="Mangaba" width="96" height="96">
</p>

# Mangaba Harness

[English](README.md) | 中文

Mangaba Harness（`mh`）是一个开源 agent harness（智能体框架），是
[DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)（MIT）的品牌重塑发行版，
承载 Mangaba 的视觉标识与默认配置。

它构建于**一切皆插件**的架构之上，由 [Cordis](https://github.com/cordiverse/cordis) 驱动，其设计参见论文 [_A Programming Paradigm for Spatiotemporal Composability_](https://arxiv.org/abs/2608.25512)。

## 开发者预览

Mangaba Harness 目前处于 _开发者预览_ 阶段，正在快速迭代。**未来将出现破坏兼容性的变更。**

运行本项目前，请阅读[安全说明](SAFETY.zh.md)。

<a id="run"></a>

## 运行

```sh
pnpm install
pnpm run build
pnpm dsh web
```

该命令默认会在 `http://127.0.0.1:3080` 启动 Web UI。传入 `--no-open` 可仅运行服务器而不打开浏览器。
详见 [Web UI 指南](docs/user/guide/index.zh.md)。

## 本地模型

任何 OpenAI 兼容端点都可作为自定义 provider。以本地 Ollama（带工具调用）为例，在
`$DSH_HOME/settings.yaml` 中加入：

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

harness 的系统提示较长：Ollama 默认的 4k 上下文会将其截断，模型随后会把工具调用当作普通文本输出。
请先创建一个更大上下文的变体：

```sh
printf 'FROM qwen3:4b\nPARAMETER num_ctx 32768\n' | ollama create qwen3-4b-32k -f -
```

详见 [provider 指南](docs/user/guide/providers.zh.md)。

## 社区与支持

通过 [GitHub Issues](https://github.com/dheiver2/mangaba-harness/issues) 提交反馈或 bug 报告。

## 贡献

见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 品牌

Mangaba 的标记、文字标与配色属于 Mangaba；其余部分为上游 DeepSeek Harness，遵循 [MIT](LICENSE)。
本发行版与 DeepSeek 无关联，也未获其背书。上游品牌素材已被移除而非复用，详见
[BRAND_GUIDELINES.md](BRAND_GUIDELINES.md)。

## 开发

请先阅读[开发指南](docs/development.zh.md)与[架构文档](docs/architecture.zh.md)。

面向 agent：请遵循 [AGENTS.md](AGENTS.md)。

## 许可证

[MIT](LICENSE)

第三方依赖及其许可证见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。
