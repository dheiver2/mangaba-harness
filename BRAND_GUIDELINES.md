# Mangaba Harness Brand Notes

English | [中文](BRAND_GUIDELINES.zh.md)

Mangaba Harness is a rebranded distribution of [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness),
used under its [MIT license](LICENSE). It is not affiliated with, sponsored by, or endorsed by DeepSeek.

## Upstream marks

"DeepSeek" and "DeepSeek Harness" are trademarks of DeepSeek, and upstream's own brand
guidelines ask forks not to carry them in a product name. This distribution therefore ships
none of upstream's brand artwork: the whale mark, the `deepseek` letterforms, and the official
wordmark were removed — not recolored — and replaced with Mangaba's own. Upstream is credited in
prose only, which those guidelines explicitly allow.

## Mangaba marks

The mangaba mark, the `mangaba` wordmark, and the Mangaba palette (`#E94A12` on cream) belong to
Mangaba. They live in:

- `packages/client/ui-primitives/src/MangabaLogo.tsx` — the mark
- `packages/client/ui-primitives/src/BrandWordmark.tsx` — mark + `mangaba` + `HARNESS` badge
- `apps/web/public/favicon.svg` — browser/PWA icon

Downstream forks of *this* repository should replace those three files with their own artwork
rather than shipping Mangaba's.
