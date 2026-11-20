#!/usr/bin/env bash
# edit-chapter.sh N — passa o draft pelo Prompt 4 (Ruthless Editor)
set -euo pipefail

N="${1:?uso: $0 N}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PAD=$(printf "%02d" "$N")

DRAFT="$ROOT/chapters/${PAD}-draft.md"
EDITED="$ROOT/chapters/${PAD}-edited.md"

[[ -f "$DRAFT" ]] || { echo "❌ Falta $DRAFT. Rode ./scripts/write-chapter.sh $N primeiro."; exit 1; }

echo "✂  Editando capítulo $N..."

claude --no-interactive <<PROMPT
Use a skill ebook-writer.

Tarefa: edite o draft do Capítulo $N como o editor mais cruel do mercado.

Leia: $DRAFT
Contexto: $ROOT/bible.md (para checar voz e linhas vermelhas)

Aplique o Prompt 4 (Ruthless Book Editor):
- corte tudo que arrasta
- aperte aberturas e fechamentos
- substitua "telling" por "showing"
- elimine jargão que confunde o avatar
- remova repetições

Saída: salve a versão editada (não o relatório) em: $EDITED

Depois do arquivo, me responda APENAS com:
- nota antes (1-10)
- nota depois (1-10)
- 3 mudanças principais que fez
PROMPT

echo ""
echo "✅ Capítulo $N editado: $EDITED"
echo "   próximo: ./scripts/write-chapter.sh $((N+1))"
