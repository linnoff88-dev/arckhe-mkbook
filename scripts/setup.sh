#!/usr/bin/env bash
# setup.sh — wizard interativo pra preencher bible.md, outline.md e stories.md
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BIBLE="$ROOT/bible.md"
STORIES="$ROOT/stories.md"

# cores
C_TITLE='\033[1;33m'  # amarelo
C_OK='\033[0;32m'     # verde
C_DIM='\033[2;37m'    # cinza
C_ASK='\033[1;36m'    # ciano
C_END='\033[0m'

ask() {
  # ask "Pergunta" "valor_padrão" → ecoa resposta no stdout
  local q="$1" default="${2:-}" ans
  if [[ -n "$default" ]]; then
    echo -e "${C_ASK}❯${C_END} $q ${C_DIM}[$default]${C_END}" >&2
  else
    echo -e "${C_ASK}❯${C_END} $q" >&2
  fi
  read -r ans
  echo "${ans:-$default}"
}

ask_multi() {
  # ask_multi "Pergunta" → captura múltiplas linhas até linha vazia
  echo -e "${C_ASK}❯${C_END} $1 ${C_DIM}(linha vazia pra terminar)${C_END}" >&2
  local out="" line
  while IFS= read -r line; do
    [[ -z "$line" ]] && break
    out+="$line"$'\n'
  done
  printf "%s" "$out"
}

ask_paste() {
  # ask_paste "Pergunta" → captura até "EOF" sozinho na linha
  echo -e "${C_ASK}❯${C_END} $1 ${C_DIM}(cole, depois digite EOF numa linha sozinha)${C_END}" >&2
  local out="" line
  while IFS= read -r line; do
    [[ "$line" == "EOF" ]] && break
    out+="$line"$'\n'
  done
  printf "%s" "$out"
}

echo ""
echo -e "${C_TITLE}╔═══════════════════════════════════════════╗${C_END}"
echo -e "${C_TITLE}║   📚  mkbook — setup guiado                ║${C_END}"
echo -e "${C_TITLE}╚═══════════════════════════════════════════╝${C_END}"
echo ""
echo "Vou te perguntar 12 coisas pra montar bible.md + stories.md."
echo "Tempo estimado: 20-30 min. Pode pular qualquer pergunta (enter vazio)."
echo ""

if [[ -f "$BIBLE" ]]; then
  echo -e "${C_DIM}⚠  bible.md já existe.${C_END}"
  conf=$(ask "Sobrescrever? (y/N)" "N")
  [[ "$conf" =~ ^[yY]$ ]] || { echo "Abortado."; exit 0; }
fi

# -------- IDENTIDADE --------
echo ""
echo -e "${C_TITLE}━━━ 1/4  Identidade do livro ━━━${C_END}"
TITLE=$(ask "Título de trabalho")
SUBTITLE=$(ask "Subtítulo")
GENRE=$(ask "Gênero/categoria (ex: business, self-help, técnico)" "business")
KEYWORDS=$(ask "Palavras-chave (separadas por vírgula)")

# -------- PROMESSA --------
echo ""
echo -e "${C_TITLE}━━━ 2/4  Promessa central ━━━${C_END}"
echo "Em 1 frase: o que o leitor vai ter ao terminar o livro?"
echo -e "${C_DIM}Fórmula: 'Ao terminar, [avatar] terá [transformação] mesmo [objeção].'${C_END}"
PROMISE=$(ask "Promessa")

# -------- AVATAR --------
echo ""
echo -e "${C_TITLE}━━━ 3/4  Avatar do leitor (1 pessoa real) ━━━${C_END}"
AV_NAME=$(ask "Nome do avatar (real ou fictício)")
AV_AGE=$(ask "Idade + profissão")
AV_PAIN=$(ask "Dor principal (o que tira o sono)")
AV_DESIRE=$(ask "Desejo principal (o que ela quer ter/ser/sentir)")
AV_NOW=$(ask "Onde está hoje (nível de conhecimento)")
AV_THEN=$(ask "Onde quer chegar (estado final)")

# -------- VOZ --------
echo ""
echo -e "${C_TITLE}━━━ 4/4  Voz e tom ━━━${C_END}"
TONE=$(ask "3 adjetivos do tom (ex: direto, irreverente, didático)")
REF_AUTHOR=$(ask "Autor de referência (voz que admira)" "")
RED_LINES=$(ask_multi "Linhas vermelhas (o que o livro NUNCA faz)")
BACKEND=$(ask "Modelo de back-end (curso? mentoria? palestras?)")

echo ""
echo "📝 Agora cole 2-5 mil palavras suas reais (e-mail, post longo, thread)."
echo "   Sem isso, a IA escreve LLM-genérico. ISSO É O MAIS IMPORTANTE."
echo ""
VOICE_SAMPLES=$(ask_paste "Cole amostras suas")

# -------- ESCREVE BIBLE.MD --------
cat > "$BIBLE" <<EOF
# Bíblia do Livro

> Gerada via \`./scripts/setup.sh\` em $(date +%Y-%m-%d).
> Este é o documento mais importante do projeto. Toda decisão de escrita parte daqui.

---

## 1. Identidade

- **Título de trabalho:** $TITLE
- **Subtítulo:** $SUBTITLE
- **Gênero/Categoria:** $GENRE
- **Palavras-chave:** $KEYWORDS

## 2. Promessa Central

> $PROMISE

## 3. Público-alvo (Avatar)

- **Nome:** $AV_NAME
- **Idade + profissão:** $AV_AGE
- **Dor principal:** $AV_PAIN
- **Desejo principal:** $AV_DESIRE
- **Onde está hoje:** $AV_NOW
- **Onde quer chegar:** $AV_THEN

## 4. Voz e Tom

- **3 adjetivos:** $TONE
- **Autor de referência:** $REF_AUTHOR
- **Modelo de back-end:** $BACKEND

### Amostras de voz própria (CRÍTICO)

\`\`\`
$VOICE_SAMPLES
\`\`\`

## 5. Glossário Controlado

| Termo | Definição curta | Variações proibidas |
|---|---|---|
| (preencha) | | |

## 6. Linhas Vermelhas

$RED_LINES

## 7. Estrutura por Capítulo

> Preencha após gerar outline.md com \`/ebook-writer monte outline a partir do bible.md\`.

| Cap | Promessa específica | Transformação |
|---|---|---|
| 1 | | |
| 2 | | |

EOF

# -------- STORIES --------
if [[ ! -f "$STORIES" ]] || [[ ! -s "$STORIES" ]]; then
  cp "$ROOT/templates/stories.md" "$STORIES" 2>/dev/null || cat > "$STORIES" <<'EOF'
# Banco de Histórias

> Cole suas histórias reais aqui. Use tags como #cap1 #abertura #fracasso.

## Template

```
### [Título curto]
**Tags:** #capX #tema #emoção
**Ano:**
**O que aconteceu:**
**Lição:**
**Onde encaixa:**
```

---

EOF
fi

# -------- GIT INIT (se ainda não) --------
if [[ ! -d "$ROOT/.git" ]]; then
  ( cd "$ROOT" && git init -q && git add . && git commit -qm "init via setup.sh: $TITLE" 2>/dev/null || true )
fi

echo ""
echo -e "${C_OK}✅ Setup concluído!${C_END}"
echo ""
echo "Próximos passos:"
echo ""
echo "  1. Revise bible.md — preencha glossário e linhas vermelhas se ficaram vazios"
echo "  2. Cole suas histórias em stories.md"
echo "  3. Gere o outline:"
echo -e "     ${C_DIM}claude${C_END}"
echo -e "     ${C_DIM}> /ebook-writer monte outline a partir do bible.md${C_END}"
echo "  4. Escreva o primeiro capítulo:"
echo -e "     ${C_DIM}./scripts/write-chapter.sh 1${C_END}"
echo ""
