/** Locale preference stored in the Host user-settings document. */

import z from '@deepseek-ai/schemastery'

/** Settings namespace owned by the locale plugin. */
export const LOCALE_SETTINGS_NAMESPACE = 'locale'

/** Field carrying an explicit locale selection; absence delegates to the browser. */
export const LOCALE_PREFERENCE_FIELD = 'preference'

/** Accepted BCP 47-style language ids. */
export const LOCALE_ID_PATTERN = /^[A-Za-z]{2,8}(?:-[A-Za-z0-9]{1,8})*$/u

/**
 * Locale identifiers shipped by the browser client.
 *
 * Each id is a primary subtag, which is what browser detection matches against
 * — `pt-BR` and `pt-PT` both land on `pt`. The shipped Portuguese copy is
 * written in Brazilian Portuguese; the `<html lang>` tag names that variant.
 */
export const LOCALE_IDS = ['zh', 'en', 'pt'] as const

/** Locale identifier shipped by the browser client. */
export type BuiltInLocaleId = typeof LOCALE_IDS[number]

/** Open locale identifier accepted from language-pack plugins. */
export type LocaleId = string

/**
 * The locales every namespace must ship. zh is the repo's key-set source of
 * truth and en is the runtime fallback, so a namespace missing either would
 * leave keys unresolvable; any other locale is optional and may be partial.
 */
export type SourceLocaleId = Extract<LocaleId, 'zh' | 'en'>

/** Durable locale section shared by the Host schema and the browser scope. */
export interface LocaleSettings {
  /** Explicit locale selection; absence delegates to the browser. */
  preference?: LocaleId
}

/** Durable locale schema; also the wire envelope the browser scope validates against. */
export const LocaleSettingsSchema: z<LocaleSettings> = z.object({
  [LOCALE_PREFERENCE_FIELD]: z.string().pattern(LOCALE_ID_PATTERN).required(false),
})
