---
name: ebook-writer
description: Pipeline completo de ebook (ideia → outline → capítulo → ediçêo → consistência → build). Use sempre que o usuário pedir para gerar ideia de livro, montar outline, escrever capítulo, editar capítulo, verificar consistência cruzada entre capítulos, ou montar o manuscrito final. Acione também em pedidos como "gere 5 ideias de livro", "monte o blueprint", "escreva o capítulo X", "edite com olhos cruéis", "verifique consistência", "build do epub". Sempre lê bible.md, outline.md, stories.md antes de escrever qualquer coisa.
---

# ebook-writer

Skill que orquestra os 7 prompts do framework "Bestseller Book in 30 Days" como pipeline real de arquivos do projeto `mkbook`.

## Fontes da verdade (sempre ler antes de escrever)

| Arquivo | Para que serve |
|---|---|
| `bible.md` | Voz, audiência, promessa, glossário, linhas vermelhas |
| `outline.md` | Estrutura de capítulos, promessas por capítulo, contagem alvo |
| `stories.md` | Banco de histórias pessoais — puxar pelo menos 1 por capítulo |
| `chapters/NN-edited.md` | Capítulos já finalizados (pra evitar repetiçêo) |

## Pipeline (mapeamento ao framework dos 7 prompts)

### Prompt 1 — Bestseller Idea Finder
**Trigger:** "gere ideias de livro", "5 ideias", "qual livro escrever"
**Inputs:** nicho/expertise do usuário (perguntar em texto livre se ausente)
**Output:** 5 ideias com título+subtítulo, avatar, promessa, análise competitiva, potencial de receita. Recomendaçêo final + por quê.
**Onde salvar:** `ideas.md` na raiz do projeto

### Prompt 2 — Book Blueprint Architect
**Trigger:** "monte o outline", "blueprint", "estrutura do livro"
**Input:** `bible.md` (especialmente título, avatar, promessa)
**Output:** outline preenchendo `templates/outline.md` com 10-12 capítulos, intro, conclusêo, contagem de palavras, componentes obrigatórios.
**Onde salvar:** `outline.md` na raiz

### Prompt 3 — Chapter Writing Engine
**Trigger:** "escreva capítulo N", "draft cap N"
**Inputs:**
- `bible.md` (voz, glossário, linhas vermelhas)
- `outline.md` (seçêo do Cap N)
- `stories.md` (puxar 1+ história relevante)
- Capítulos anteriores em `chapters/*-edited.md` (pra continuidade e evitar repetiçêo)
**Output:** draft do capítulo com hook, tom da bíblia, exemplos reais, takeaways acionáveis, cliffhanger pro próximo capítulo. Contagem de palavras alinhada ao outline.
**Onde salvar:** `chapters/NN-draft.md` (NN com zero-padding)

### Prompt 4 — Ruthless Editor
**Trigger:** "edite capítulo N", "passa o crivo no cap N"
**Inputs:** `chapters/NN-draft.md` + `bible.md`
**Output:** versêo editada (nêo relatório) — cortes, reescritas de aberturas/fechamentos fracos, conversêo de telling→showing, eliminaçêo de jargêo e repetiçêo.
**Onde salvar:** `chapters/NN-edited.md`
**Resposta no chat:** APENAS nota antes/depois (1-10) + 3 mudanças principais.

### Prompt 4.5 — Consistency Check (acréscimo do mkbook, nêo no framework original)
**Trigger:** "verifique consistência", "cheque o livro inteiro"
**Inputs:** todos `chapters/*-edited.md` + `bible.md`
**Output:** relatório de problemas em glossário, voz, repetiçêo, promessas, cliffhangers, linhas vermelhas. Cada problema com fix sugerido.

### Prompt 5 — Launch Plan
**Trigger:** "plano de lançamento", "30 dias", "estratégia de launch"
**Input:** `bible.md` + livro pronto
**Output:** plano 30 dias (pré + launch + pós), Amazon optimization, 10 posts sociais, 5 templates de e-mail, outreach de podcast.
**Onde salvar:** `launch/plan.md`

### Prompt 6 — Publishing Pathway
**Trigger:** "publicar onde", "KDP ou tradicional", "pathway"
**Input:** `bible.md` (especialmente metas) + manuscrito
**Output:** comparaçêo tradicional vs self vs híbrido + recomendaçêo + checklist do path escolhido (se KDP, formataçêo/preço/cover/ISBN; se tradicional, query letter + 10 agentes).
**Onde salvar:** `publishing/path.md`

### Prompt 7 — Author Income Multiplier
**Trigger:** "monetizaçêo", "produtos pós-livro", "income streams"
**Input:** `bible.md` (seçêo Modelo de Negócio) + livro pronto
**Output:** pitch de palestra, oferta de consultoria, módulos de curso, workshop, lead magnet, segundo livro, licenciamento corporativo.
**Onde salvar:** `monetization/streams.md`

## Regras invioláveis

1. **Nunca escrever capítulo sem ter lido `bible.md` na mesma invocaçêo.** A voz e o glossário só funcionam com a bíblia carregada.
2. **Puxar pelo menos 1 história de `stories.md` por capítulo.** Capítulo sem história pessoal soa LLM genérico.
3. **Respeitar contagem alvo do outline.** Se o outline pede 4.000 palavras e você gerou 2.200, está abaixo.
4. **Glossário é lei.** Se a bíblia diz "agente de IA", nêo use "AI agent" nem "bot" — use exatamente o termo.
5. **Linhas vermelhas sêo linhas vermelhas.** Se a bíblia diz "nêo promete dinheiro rápido", recusar e propor alternativa.
6. **Cliffhanger obrigatório no fim de cada capítulo** (exceto o último).
7. **Salvar em arquivos, nêo responder no chat.** O chat é só pra relatórios curtos (nota, decisêo, próximo passo). O conteúdo vai pro disco.

## Quando o usuário pedir algo ambíguo

Perguntar em **texto livre** (regra global do usuário — sem AskUserQuestion):

- "Qual capítulo? (1-12)"
- "Você quer draft novo ou re-editar o existente?"
- "Bíblia está preenchida? Posso conferir?"

## Saída padrêo

Resposta no chat sempre curta:
1. O que foi feito (1 linha)
2. Arquivo gerado (caminho)
3. Próximo comando sugerido

Exemplo:
```
✓ Cap 3 escrito (4.200 palavras, voz checada contra bíblia).
→ chapters/03-draft.md
Próximo: ./scripts/edit-chapter.sh 3
```
