import type { CommonKey } from './zh.ts'

/**
 * Brazilian Portuguese dictionary for the common namespace.
 *
 * Unlike `en`, this one is NOT required to be complete: the runtime falls back
 * to English per key, so a namespace can be translated as it goes without ever
 * leaving a screen half-rendered. `Partial` states that intent — a key added to
 * the source set does not break the build here, it simply reads in English
 * until someone writes the Portuguese.
 */
export const pt = {
  'ok': 'OK',
  'cancel': 'Cancelar',
  'close': 'Fechar',
  'copy': 'Copiar',
  'copied': 'Copiado',
  'retry': 'Tentar de novo',
  'loading': 'Carregando…',
  'load.failed': 'Falha ao carregar',
  'submit': 'Enviar',
  'submitting': 'Enviando…',
  'next': 'Avançar',
  'previous': 'Voltar',
  'skip': 'Pular',
  'delete': 'Excluir',
  'edit': 'Editar',
  'save': 'Salvar',
  'search': 'Buscar',
  'more': 'Mais',
  'collapse': 'Recolher',
  'expand': 'Expandir',
  'back': 'Voltar',
  'unknown': 'Desconhecido',
  'none': 'Nenhum',
  'truncated': 'Truncado',
} satisfies Partial<Record<CommonKey, string>>
