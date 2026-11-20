#!/usr/bin/env bash
# write-chapter.sh N — escreve o capítulo N usando Claude Code + skill ebook-writer
set -euo pipefail

N="${1:?uso: $0 N (numero do capitulo)}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PAD=$(printf "%02d" "$N")

OUT="$ROOT/chapters/${PAD}-draft.md"

if [[ -f "$OUT" ]]; then
  echo "⚠  $OUT já existe."
  read -rp "Sobrescrever? [y/N] " r
  [[ "$r" == "y" || "$r" == "Y" ]] || exit 0
fi

# Verifica que bible/outline existem
for f in bible.md outline.md; do
  [[ -f "$ROOT/$f" ]] || { echo "❌ Falta $f. Rode ./scripts/new-book.sh primeiro."; exit 1; }
done

echo "✍  Escrevendo capítulo $N..."
echo "   bible: $(wc -l < "$ROOT/bible.md") linhas"
echo "   outline: $(wc -l < "$ROOT/outline.md") linhas"
echo "   stories: $(wc -l < "$ROOT/stories.md") linhas"
echo ""

# Invoca Claude Code com a skill. Pipeline:
#   1. lê bible.md, outline.md, stories.md
#   2. extrai a seção do Cap N do outline
#   3. gera draft seguindo Prompt 3 do framework
#   4. salva em chapters/NN-draft.md
claude --no-interactive <<PROMPT
Use a skill ebook-writer.

Tarefa: escreva o Capítulo $N do livro.

Leia:
- $ROOT/bible.md (voz, audiência, promessa, glossário)
- $ROOT/outline.md (extraia a seção do Capítulo $N)
- $ROOT/stories.md (puxe histórias relevantes ao capítulo)

Aplique o Prompt 3 (Chapter Writing Engine) com estas regras adicionais da bíblia:
- mantenha a voz definida em "Voz e Tom"
- respeite o glossário controlado
- não viole as linhas vermelhas
- inclua pelo menos 1 história real puxada de stories.md
- ao final, deixe um gancho-cliffhanger pro Cap $((N+1))

Salve o resultado em: $OUT

Depois rode: \`wc -w $OUT\` e me reporte a contagem de palavras.
PROMPT

echo ""
echo "✅ Draft pronto: $OUT"
echo "   próximo: ./scripts/edit-chapter.sh $N"
