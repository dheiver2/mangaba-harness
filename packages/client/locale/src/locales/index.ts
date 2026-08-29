/**
 * The common-namespace dictionaries. zh is the source of truth for the key set
 * (Chinese-first repo convention); en is checked complete against it — a
 * missing or extra en key is a compile error. pt is partial by design: the
 * runtime resolves each key against the active locale and then English, so an
 * untranslated key reads in English instead of rendering blank.
 */
export { zh } from './zh.ts'
export { en } from './en.ts'
export { pt } from './pt.ts'
export type { CommonKey } from './zh.ts'
