# Como expandir os módulos restantes

O curso vem com **1 módulo canônico totalmente construído** (`curso/trilha1/modulo-1-1.html`) como referência visual. Os outros 15 módulos têm página de trilha completa (header + mapa + 6 tópicos expansíveis por módulo) mas faltam suas páginas `modulo-X-Y.html` individuais (deep dive).

## Por que assim

Cada modulo HTML no formato INEMA.CLUB tem 500-800 linhas (6 seções ricas com componentes variados). 16 módulos × 700 linhas ≈ 11.000 linhas — inviável de gerar com qualidade em uma única sessão.

A página de trilha (`trilha*/index.html`) já é conteúdo completo e navegável. Os deep-dives são camada extra opcional.

## Como gerar os 15 restantes

Abra o repositório com Claude Code e rode:

```
/formato-curso

Use a skill formato-curso pra gerar o arquivo curso/trilha1/modulo-1-2.html
no padrão INEMA.CLUB.

Use como referência canônica: curso/trilha1/modulo-1-1.html
Conteúdo dos 6 tópicos: o que já está em curso/trilha1/index.html
                        no card "modulo-1-2" (expandir cada tópico em seção
                        de modulo com componentes variados — ver MASTER 1.8).

Cor da trilha: emerald (T1).
```

Repita pra cada modulo-X-Y faltante, ajustando cor:
- T1 modulos 1.2, 1.3, 1.4 — emerald
- T2 modulos 2.1, 2.2, 2.3, 2.4 — blue
- T3 modulos 3.1, 3.2, 3.3, 3.4 — purple
- T4 modulos 4.1, 4.2, 4.3, 4.4 — amber

Ou rode em loop:

```
/loop 0 — gere os 15 módulos restantes do curso, um por iteração,
seguindo o padrão de modulo-1-1.html e a cor da trilha correspondente.
Pare quando todos existirem em disco.
```

## Checklist do que cada modulo precisa

A skill `formato-curso` já valida automaticamente, mas pra referência:

- [ ] Nav completo (4 trilhas + theme toggle + INEMA.CLUB)
- [ ] Breadcrumb
- [ ] Header com gradiente da cor da trilha + stats grid
- [ ] 6 seções (`<section id="topico-N">`) com:
  - Círculo numerado grande (w-12 h-12)
  - Parágrafo introdutório com palavras-chave em `<strong>` da cor da trilha
  - Variedade de componentes (≥2 grids ✓/✗, ≥1 timeline, ≥2 tip boxes, ≥1 code box)
- [ ] Seção de resumo com checklist + próximo modulo + CTAs
- [ ] Light mode CSS completo (4 partes)
- [ ] JavaScript de theme toggle
- [ ] Bordas suaves no dark
- [ ] 500-800 linhas totais

## Dica

Use `modulo-1-1.html` como ponto de partida (copie + adapte) ao invés de gerar do zero. Mais rápido e mantém consistência visual.
