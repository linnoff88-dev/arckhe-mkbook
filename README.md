# ðŸ“š mkbook

<div align="center">
  <img src="capa/logo.svg" alt="Arckhé AI" height="48" />
  <p><strong>Arckhé AI</strong></p>
</div>


> Pipeline completo pra transformar uma ideia em ebook publicado em **30 dias**, usando Claude Code como motor de escrita, ediÃ§Ã£o, consistÃªncia e build.

Baseado no framework dos 7 prompts (Idea â†’ Outline â†’ Chapter â†’ Edit â†’ Launch â†’ Publishing â†’ Monetization), mas operando como **pipeline real de arquivos versionados** â€” nÃ£o prompts soltos no chat.

ðŸŒ **Curso completo (GitHub Pages):** [inematds.github.io/mkbook](https://inematds.github.io/mkbook/)
ðŸ“– **RepositÃ³rio:** [github.com/inematds/mkbook](https://github.com/inematds/mkbook)

---

## âš¡ TL;DR â€” 5 comandos pra ter um livro

```bash
git clone https://github.com/inematds/mkbook.git && cd mkbook
./scripts/setup.sh                         # ðŸ§¬ wizard interativo (preenche bÃ­blia em 20 min)
./scripts/write-chapter.sh 1               # Claude gera cap 1
./scripts/edit-chapter.sh 1                # Claude edita
./scripts/build-epub.sh                    # EPUB/PDF/MOBI prontos pro KDP
```

## ðŸ§¬ Duas formas de preencher a bÃ­blia

| Modo | Como rodar | Quando usar |
|---|---|---|
| **Web (visual)** | Acesse [inematds.github.io/mkbook/setup/](https://inematds.github.io/mkbook/setup/) â†’ preencha 12 perguntas â†’ baixe `bible.md` â†’ coloque na raiz do projeto | Quer ver progresso visual, prefere formulÃ¡rio com previews |
| **CLI (terminal)** | `./scripts/setup.sh` | JÃ¡ tÃ¡ no terminal, prefere fluxo rÃ¡pido sem trocar de janela |
| **Manual** | `./scripts/new-book.sh "TÃ­tulo"` + edita `bible.md` direto | JÃ¡ fez antes, sabe o que quer preencher |

Os 3 modos geram o mesmo `bible.md` â€” sÃ³ muda a experiÃªncia.

Repete `write-chapter.sh N` + `edit-chapter.sh N` pra cada capÃ­tulo (1 por dia recomendado). Em 30 dias, ebook na Amazon.

---

## ðŸŽ¯ Por que existe

Os 7 prompts virais funcionam em chat curto, mas falham em livro real:

| Problema do chat | SoluÃ§Ã£o do mkbook |
|---|---|
| Contexto perdido no cap 3 | Cada capÃ­tulo Ã© arquivo separado, alimentado por bÃ­blia + outline + stories |
| Sem persistÃªncia | Git versiona tudo |
| EdiÃ§Ã£o manual copy/paste | Skill `ebook-writer` automatiza |
| InconsistÃªncia entre capÃ­tulos | Agente verificador cruza glossÃ¡rio, voz, promessas |
| Texto solto no chat | `build-epub.sh` gera EPUB + PDF + MOBI |

---

## ðŸ“‚ Estrutura

```
mkbook/
â”œâ”€â”€ templates/                  # Templates iniciais
â”‚   â”œâ”€â”€ bible.md                # Voz, audiÃªncia, promessa, glossÃ¡rio
â”‚   â”œâ”€â”€ outline.md              # Estrutura dos 10-12 capÃ­tulos
â”‚   â””â”€â”€ stories.md              # Banco de histÃ³rias pessoais
â”œâ”€â”€ chapters/                   # Cada capÃ­tulo em arquivo prÃ³prio (gitignored)
â”‚   â”œâ”€â”€ 01-draft.md
â”‚   â”œâ”€â”€ 01-edited.md
â”‚   â””â”€â”€ ...
â”œâ”€â”€ scripts/                    # AutomaÃ§Ã£o shell
â”‚   â”œâ”€â”€ new-book.sh             # Bootstrap em 1 comando
â”‚   â”œâ”€â”€ write-chapter.sh        # Gera cap N
â”‚   â”œâ”€â”€ edit-chapter.sh         # Editor cruel
â”‚   â”œâ”€â”€ consistency-check.sh    # VerificaÃ§Ã£o cruzada
â”‚   â””â”€â”€ build-epub.sh           # EPUB + PDF + MOBI
â”œâ”€â”€ build/                      # SaÃ­das (gitignored)
â”‚   â”œâ”€â”€ manuscript.md
â”‚   â”œâ”€â”€ book.epub
â”‚   â”œâ”€â”€ book.pdf
â”‚   â””â”€â”€ book.mobi
â”œâ”€â”€ .claude/skills/ebook-writer/  # Skill custom que orquestra os 7 prompts
â””â”€â”€ docs/                       # Curso GitHub Pages (formato INEMA.CLUB)
```

---

## ðŸ› ï¸ PrÃ©-requisitos

```bash
# obrigatÃ³rio
brew install pandoc git                    # macOS
# ou: sudo apt install pandoc git           # Ubuntu/Debian

# Claude Code instalado e autenticado
npm install -g @anthropic-ai/claude-code
claude --version

# opcional â€” PDF de alta qualidade
brew install --cask basictex               # macOS
# ou: sudo apt install texlive-xetex        # Ubuntu

# opcional â€” geraÃ§Ã£o de MOBI
brew install --cask calibre                # macOS
# ou: sudo apt install calibre              # Ubuntu
```

---

## ðŸ“– Como criar um livro novo (passo a passo)

### Dia 1 â€” Setup (30 minutos)

```bash
cd ~/projetos/mkbook
./scripts/new-book.sh "TÃ­tulo ProvisÃ³rio"
```

O script:
- Copia `templates/bible.md`, `outline.md`, `stories.md` pra raiz
- Faz `git init` e primeiro commit
- Substitui o tÃ­tulo placeholder pelo que vocÃª passou

---

### Dia 1-3 â€” Preencher a bÃ­blia (3-4h totais, dividido em 3 dias)

A bÃ­blia Ã© a **lei** do livro. Tudo daqui pra frente lÃª dela.

Abra `bible.md` e preencha:

| SeÃ§Ã£o | O que colocar |
|---|---|
| **Identidade** | TÃ­tulo, subtÃ­tulo, gÃªnero, categorias Amazon, keywords |
| **Promessa central** | 1 frase: "Ao terminar, [avatar] terÃ¡ [transformaÃ§Ã£o] mesmo [objeÃ§Ã£o]" |
| **PÃºblico-alvo (avatar)** | 1 pessoa real ou semi-fictÃ­cia: idade, profissÃ£o, dor, desejo, onde estÃ¡ hoje |
| **Voz e tom** | 3 adjetivos + autor de referÃªncia + **amostras suas** (cola 2-5 mil palavras suas: posts longos, e-mails, threads) |
| **Estrutura por capÃ­tulo** | Promessa especÃ­fica de cada cap (vocÃª preenche depois do outline) |
| **GlossÃ¡rio controlado** | 5-10 termos com definiÃ§Ã£o + variaÃ§Ãµes proibidas |
| **Linhas vermelhas** | O que o livro NUNCA faz |
| **Modelo de negÃ³cio pÃ³s-livro** | Curso? Consultoria? Palestras? Comunidade? |

> **âš ï¸ NÃ£o pule "amostras de voz".** Sem 2k+ palavras suas coladas, o agente vai gerar prosa LLM-padrÃ£o. Isso Ã© a diferenÃ§a entre "parece que vocÃª escreveu" e "parece IA".

---

### Dia 4 â€” Gerar ideia + outline (~2h)

```bash
claude
> /ebook-writer Gere 5 ideias de livro baseadas no inventÃ¡rio em bible.md.
                Salve em ideas.md.
```

Escolha a vencedora (marque âœ“ em `ideas.md`).

```bash
> /ebook-writer Monte o outline completo do livro escolhido em outline.md.
                12 capÃ­tulos, ~4000 palavras cada, com promessa por capÃ­tulo.
```

Revise `outline.md` Ã  mÃ£o. Cap por cap. Ajuste promessas que nÃ£o convencem.

---

### Dia 5 â€” Banco de histÃ³rias (~2h)

Abra `stories.md` e cole **todas** suas anedotas relevantes (cruas, sem polir). Tagueia:

```markdown
### A vez que perdi US$ 30k por nÃ£o ter mailing list
**Tags:** #cap1 #lanÃ§amento #arrependimento
**Ano:** 2022
**O que aconteceu:** Lancei pra "todo mundo" via Instagram. 12 vendas...
**LiÃ§Ã£o:** AudiÃªncia > oferta
**Onde encaixa:** Cap 1, abertura
```

Isso Ã© o que separa seu livro de LLM-genÃ©rico.

---

### Dia 6-17 â€” 1 capÃ­tulo por dia (~2h cada)

```bash
./scripts/write-chapter.sh 1
# Claude lÃª bible.md + outline.md + stories.md
# â†’ chapters/01-draft.md

# revisa rapido o draft (lÃª todo, anota o que mudar)
$EDITOR chapters/01-draft.md

./scripts/edit-chapter.sh 1
# editor cruel: corta gordura, melhora aberturas, elimina repetiÃ§Ã£o
# â†’ chapters/01-edited.md

git add chapters/ && git commit -m "cap 1"
```

Pode automatizar com `/loop` do Claude Code:

```bash
claude
> /loop 1d Execute: ./scripts/write-chapter.sh $((dia_atual)) && ./scripts/edit-chapter.sh $((dia_atual))
```

---

### Dia 18-21 â€” VerificaÃ§Ã£o de consistÃªncia

```bash
./scripts/consistency-check.sh
```

RelatÃ³rio:
- Termos do glossÃ¡rio usados de forma inconsistente?
- CapÃ­tulos destoam da voz da bÃ­blia?
- HistÃ³rias repetidas?
- Promessas do outline cumpridas?
- Cliffhangers funcionando entre capÃ­tulos?
- Linhas vermelhas respeitadas?

Corrija o que aparecer.

---

### Dia 22-25 â€” Build

```bash
./scripts/build-epub.sh
```

Gera em `build/`:
- `manuscript.md` (Markdown consolidado)
- `book.epub` (pra KDP, Kobo, Apple Books, Google Play)
- `book.pdf` (alta qualidade via xelatex, se instalado)
- `book.mobi` (Kindle antigo, se Calibre instalado)

---

### Dia 26-30 â€” PublicaÃ§Ã£o no Amazon KDP

Siga a **Trilha 3** do curso (`docs/curso/trilha3/`):

1. Conta KDP + W8-BEN (pra nÃ£o perder 30% de imposto)
2. Capa via Midjourney/DALL-E + composiÃ§Ã£o no Canva
3. Subir EPUB
4. 3 categorias estratÃ©gicas (2 nichos pequenos + 1 amplo)
5. 7 keywords long-tail
6. DescriÃ§Ã£o com HTML bÃ¡sico (bullets, bold)
7. PreÃ§o estratÃ©gico (US$ 2.99 / 5.99 / 9.99 sÃ£o sweet spots)
8. KDP Select sim/nÃ£o

Vai pro ar em ~12h apÃ³s submit.

---

## ðŸŽ¬ Plano de lanÃ§amento (paralelo Ã  escrita)

Veja **Trilha 4** do curso pra plano de 30 dias com prÃ©-launch, dia do bestseller e 7 streams de monetizaÃ§Ã£o atrÃ¡s do livro.

---

## ðŸ”§ Comandos de referÃªncia rÃ¡pida

```bash
# Bootstrap
./scripts/new-book.sh "TÃ­tulo"

# Pipeline diÃ¡ria de capÃ­tulos
./scripts/write-chapter.sh N            # gera cap N
./scripts/edit-chapter.sh N             # edita cap N

# VerificaÃ§Ã£o cruzada (rodar quando todos os caps estiverem prontos)
./scripts/consistency-check.sh

# Build final
./scripts/build-epub.sh                 # â†’ build/book.{epub,pdf,mobi}

# Ver o curso local
python3 -m http.server -d docs 8000     # abre em localhost:8000
```

---

## ðŸ†˜ Troubleshooting

| Problema | SoluÃ§Ã£o |
|---|---|
| `command not found: pandoc` | `brew install pandoc` ou `apt install pandoc` |
| `xelatex ausente â€” PDF pulado` | `brew install --cask basictex` (macOS) |
| Voz do livro tÃ¡ genÃ©rica | Falta amostras suas em `bible.md`. Adicione mais 2k palavras |
| CapÃ­tulo curto demais | Outline pediu 4k palavras mas saiu 2k â€” reforce a quantidade no prompt |
| Sobrescrever capÃ­tulo por engano | `git log chapters/03-edited.md` + `git checkout <hash> -- chapters/03-edited.md` |
| Quero recomeÃ§ar do zero | `rm bible.md outline.md ideas.md && ./scripts/new-book.sh "Novo"` |
| EPUB nÃ£o abre no Kindle | Use o Send to Kindle do Amazon ou converta pra MOBI com Calibre |

---

## ðŸŒ Curso (GitHub Pages)

O treinamento completo em 4 trilhas (16 mÃ³dulos Â· 96 tÃ³picos) estÃ¡ em `docs/`:

| Trilha | Foco | Cor |
|---|---|---|
| **T1 Fundamentos** | Ideia validada + bÃ­blia + outline | ðŸŸ¢ Emerald |
| **T2 Escrita** | Pipeline de capÃ­tulos + ediÃ§Ã£o + consistÃªncia | ðŸ”µ Blue |
| **T3 PublicaÃ§Ã£o** | EPUB, KDP, capa, formataÃ§Ã£o | ðŸŸ£ Purple |
| **T4 LanÃ§amento** | 30 dias, bestseller, 7 streams de receita | ðŸŸ¡ Amber |

Deploy automÃ¡tico via `.github/workflows/pages.yml`. ApÃ³s push, vai pro ar em ~2 min.

URL: **[inematds.github.io/mkbook](https://inematds.github.io/mkbook/)**

---

## ðŸ“œ LicenÃ§a

MIT â€” use, modifique, publique seu livro e fique com 100% da grana.

---

## ðŸ™ CrÃ©ditos

Framework dos 7 prompts originais: domÃ­nio pÃºblico (viralizou em 2024). ImplementaÃ§Ã£o como pipeline em arquivos versionados: [INEMA.CLUB](https://inema.club).

---

<div align="center">
  <img src="capa/logo.svg" alt="Arckhé AI" height="32" />
  <p><strong>Arckhé AI</strong></p>
</div>