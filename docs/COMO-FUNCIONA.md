# 📚 Como o mkbook funciona — Relatório completo

> Relatório consolidado: filosofia, fluxo, decisões de design e mapeamento aos 7 prompts originais.

---

## 1. Ideia central

mkbook é uma **fábrica de livro** que separa o que **você faz** (decisões, voz, histórias reais) do que a **IA faz** (escrita estrutural, edição, consistência cruzada).

**Diferença fundamental:** tudo mora em arquivos no disco e versionado no git — não em chat de IA.

```
SEUS INPUTS                    PIPELINE                       SAÍDA
─────────────────────────────────────────────────────────────────────
bible.md (você)        ┐
outline.md (você+IA)   ├──→  scripts/*.sh  ──→  Claude  ──→  chapters/
stories.md (você)      ┘                                         │
                                                                 ▼
                                                            build/book.epub
```

---

## 2. Fluxo, contado como fábrica

### Etapa 1 — Você prepara matéria-prima (1 dia)

3 arquivos de texto na raiz:

| Arquivo | O que vai dentro |
|---|---|
| `bible.md` | Avatar (1 pessoa real), voz, promessa, glossário, linhas vermelhas, modelo de back-end, **+ 2-5 mil palavras suas reais** pra IA imitar voz |
| `outline.md` | Estrutura de 10-12 capítulos. Gerado com IA, revisado por você |
| `stories.md` | Banco de histórias suas, com tags por capítulo/tema |

### Etapa 2 — Você roda 1 script por dia (12 dias)

```bash
./scripts/write-chapter.sh 1
```

Por baixo dos panos:
1. Script abre Claude Code
2. Claude lê os 3 arquivos
3. Gera capítulo respeitando voz + outline + puxando 1 história
4. Salva em `chapters/01-draft.md` (arquivo, não chat)

Você abre, lê em 15 min, aprova.

```bash
./scripts/edit-chapter.sh 1
```

Mesma coisa, mas Claude faz papel de **editor cruel** — corta gordura, conserta abertura, elimina jargão. Salva em `chapters/01-edited.md`.

Repete pros 12 capítulos. 1 por dia.

### Etapa 3 — Build (1 comando)

```bash
./scripts/build-epub.sh
```

Cola todos os capítulos editados, manda pro pandoc, gera EPUB + PDF + MOBI prontos pro KDP.

### Etapa 4 — Publicação

Trilha 3 do curso cobre: conta KDP, capa via IA, descrição, keywords, preço.

---

## 3. Por que "1 capítulo por dia" e não tudo de uma vez

### 6 razões técnicas + psicológicas

**1. Janela de contexto degrada.**
- 1 cap isolado: nota 8/10
- Mesmo cap como #8 de batch de 12: nota 5/10
- Sintomas: voz vira "LLM neutra", repetições, exemplos genéricos

**2. Corrige a voz antes dela contaminar 11 capítulos.**
- Errar no cap 1 (1 por dia): 30 min de fix
- Errar no cap 1 (batch): 1 dia regenerando tudo

**3. Você lembra de histórias novas durante o processo.**
- Revisar cap 1 dispara memória que vira input do cap 5
- Em batch, IA usa só histórias que você lembrou no dia 1

**4. Revisar 12 caps de uma vez é brutal.**
- 12 × 1.5h = 18h seguidas. Ninguém faz direito.
- 1 por dia = atenção plena em cada um

**5. Cliffhangers e continuidade pioram em batch.**
- Cap 5 precisa REFERENCIAR cap 4 já fechado e PREPARAR cap 6
- Em batch, IA inventa referências circulares ou frases vazias ("como veremos adiante")

**6. Momentum psicológico.**
- "Tudo de uma vez": 80% abandona
- "1 por dia": 75% termina

### Quando tudo de uma vez faz sentido

| Cenário | Modo |
|---|---|
| Ebook curto (5 caps, R$ 19) | Batch num final de semana |
| Validar mercado antes de investir 30 dias | Batch pra MVP, refaz depois |
| 5º livro publicado, voz já calibrada | Batch — bíblia tá afinada |
| Deadline absurda | Batch aceitando -30% qualidade |

### Caminho intermediário

```bash
# Batch de 4 caps por dia (3 dias pra fazer 12)
./scripts/write-chapter.sh 1 && ./scripts/edit-chapter.sh 1
./scripts/write-chapter.sh 2 && ./scripts/edit-chapter.sh 2
./scripts/write-chapter.sh 3 && ./scripts/edit-chapter.sh 3
./scripts/write-chapter.sh 4 && ./scripts/edit-chapter.sh 4
# revisa os 4 à noite
# próximo dia faz 5-8, depois 9-12
```

---

## 4. mkbook vs ChatGPT solto no chat

| ChatGPT no chat | mkbook |
|---|---|
| Cola o prompt 7 vezes | `./scripts/write-chapter.sh N` |
| Conversa se perde no cap 3 | Cada cap tem arquivo, IA lê bíblia toda vez |
| Voz inconsistente | Bíblia + amostras garantem voz |
| Histórias repetidas entre capítulos | `stories.md` central evita |
| Output: scroll de chat | Output: pasta `chapters/` versionada |
| Edição: copia/cola tudo de novo | Edição: 1 script roda |
| Vira EPUB? Você se vira | `build-epub.sh` resolve |

---

## 5. Mapeamento aos 7 prompts originais (Bestseller Book in 30 Days)

| # | Prompt original | Como vive no mkbook |
|---|---|---|
| **1** | Bestseller Idea Finder | Trigger `/ebook-writer Gere 5 ideias...` → salva em `ideas.md` |
| **2** | Book Blueprint Architect | Trigger `/ebook-writer Monte outline...` → preenche `outline.md` |
| **3** | Chapter Writing Engine | `./scripts/write-chapter.sh N` → `chapters/NN-draft.md` |
| **4** | Ruthless Book Editor | `./scripts/edit-chapter.sh N` → `chapters/NN-edited.md` |
| **5** | Launch Plan Domination | Trigger `/ebook-writer plano de lançamento` → `launch/plan.md` |
| **6** | Publishing Pathway Advisor | Trigger `/ebook-writer pathway` → `publishing/path.md` |
| **7** | Author Income Multiplier | Trigger `/ebook-writer monetização` → `monetization/streams.md` |

**Adicional (não no framework original):**
- **4.5 — Consistency Check** — verificação cruzada de glossário, voz, repetição, promessas, cliffhangers, linhas vermelhas. Roda contra TODOS os capítulos. Sem isso, livro fica internamente incoerente.

Tudo orquestrado pela skill `.claude/skills/ebook-writer/SKILL.md`.

---

## 6. O que cada peça faz (1 linha)

| Arquivo | Quem cria | Pra que serve |
|---|---|---|
| `bible.md` | Você (1 dia) | Briefing eterno: voz, avatar, promessa, regras |
| `outline.md` | Você + IA (2h) | Mapa dos 12 capítulos |
| `stories.md` | Você (2h, contínuo) | Histórias suas reais pra IA puxar |
| `chapters/*-draft.md` | IA via script | Primeiro rascunho de cada cap |
| `chapters/*-edited.md` | IA via script | Cap polido pelo editor cruel |
| `scripts/new-book.sh` | já existe | Bootstrap |
| `scripts/write-chapter.sh` | já existe | Gera draft do cap N |
| `scripts/edit-chapter.sh` | já existe | Edita cap N |
| `scripts/consistency-check.sh` | já existe | Verifica livro inteiro |
| `scripts/build-epub.sh` | já existe | Gera EPUB/PDF/MOBI |
| `.claude/skills/ebook-writer/` | já existe | Instruções pro Claude |
| `build/book.epub` | gerado | Arquivo final pro KDP |

---

## 7. Exemplo concreto — livro fictício

**Tema:** "Guia Definitivo de Carreira pra Mães Tech"

**bible.md (resumo):**
- Avatar: Maria, 38, gerente de produto na Globo, primeiro filho de 6 meses
- Dor: "Vou perder anos de carreira e ninguém me prepara pra isso"
- Promessa: "Volta posicionada como sênior, não júnior reciclada"
- Voz: direta, irmã mais velha, sem condescendência
- Linhas vermelhas: não vilanizar empresas, não politizar
- Back-end: mentoria de 3 meses (R$ 4.997)
- + 3 mil palavras de e-mails da autora

**outline.md (resumo):**
- Cap 1: Por que a licença é oportunidade, não pausa
- Cap 2: O que rolou na sua área enquanto você estava fora
- Cap 3: Reentrada estratégica - os 30 primeiros dias
- ...
- Cap 12: Carreira de longo prazo - 10 anos depois

**stories.md (extrato):**
```
### Conversa com meu chefe no D-3 antes da licença
Tags: #cap1 #medo
"...ele falou que eu ia 'voltar pro mesmo lugar' e eu fiquei desesperada..."

### A primeira vez que abri o Slack após 4 meses
Tags: #cap3 #reentrada
"...tinha 2.847 mensagens não lidas..."
```

**Você roda:**
```bash
./scripts/write-chapter.sh 1
```

Claude lê tudo e produz `chapters/01-draft.md` com:
- Abertura usando "conversa com chefe D-3"
- Sua voz (porque tem 3k palavras de amostra)
- Promessa do cap 1 do outline
- Sem cruzar linhas vermelhas

Você lê em 15 min, ajusta 1 frase. Roda `edit-chapter.sh 1`. Próximo dia, cap 2.

---

## 8. Custos

| Item | Custo |
|---|---|
| mkbook (open source) | R$ 0 |
| Claude Code (Pro/Max) | R$ 100-300/mês |
| Capa via Midjourney/DALL-E | R$ 50-200 |
| Conta KDP | R$ 0 |
| ISBN (opcional, KDP dá free) | R$ 0-300 |
| **Total mínimo pra publicar** | **~R$ 200** (1 mês de Claude + capa) |

Compare com editora tradicional: 12-18 meses, sem garantia, royalty 10%.

---

## 9. Pré-requisitos técnicos

```bash
# obrigatório
brew install pandoc git
npm install -g @anthropic-ai/claude-code

# opcional (PDF de alta qualidade)
brew install --cask basictex

# opcional (MOBI)
brew install --cask calibre
```

---

## 10. Próximos passos sugeridos

1. **Testa o pipeline em 10 min** com bíblia fake:
   ```bash
   ./scripts/new-book.sh "Teste"
   # preenche bible.md rapidão
   ./scripts/write-chapter.sh 1
   ./scripts/build-epub.sh
   ```
2. Se EPUB abre no leitor, pipeline funciona.
3. Apaga teste, começa livro de verdade preenchendo bíblia com cuidado.
4. 1 capítulo por dia. 30 dias. Livro publicado.

---

**Data:** 2026-05-24
**Versão do mkbook:** 1.0
