import { fileURLToPath } from 'node:url'
import { Context } from '@deepseek-ai/cordis'
import { describe, expect, it } from 'vitest'
import SkillRegistry from '@deepseek-ai/dsh-skill'
import * as SkillBadge from '@deepseek-ai/dsh-skill-badge'

describe('dsh-skill-badge', () => {
  it('registers and disposes the bundled badge skill', async () => {
    const ctx = new Context()
    await ctx.plugin(SkillRegistry)
    const fiber = await ctx.plugin(SkillBadge)
    const resourcePath = fileURLToPath(new URL('../assets/', import.meta.url))

    expect(await ctx.skills.list()).toEqual([{
      name: 'mangaba-badge',
      description: 'Add the official “powered by mangaba” badge to documents, pull requests, merge requests, and other content produced with Mangaba Harness. Use whenever creating a pull request or merge request. Also use when the user asks for a mangaba badge, powered-by-mangaba attribution, or a reusable badge asset or snippet.',
      invocation: { modelInvocable: true, userInvocable: true },
      provider: 'mangaba-badge',
      source: 'bundled',
      resourceBase: { kind: 'directory', path: resourcePath },
    }])
    const loaded = await ctx.skills.get('mangaba-badge')
    expect(loaded?.content).toContain('Preserve the badge\'s 121×20 dimensions')
    expect(loaded?.resourceBase).toEqual({ kind: 'directory', path: resourcePath })

    await fiber.dispose()
    expect(await ctx.skills.list()).toEqual([])
  })

})
