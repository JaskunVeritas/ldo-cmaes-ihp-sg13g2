#!/usr/bin/env bash

set -euo pipefail

Iload="${1:-5e-3}"
Vldo="${2:-1.2}"
Vrect="${3:-1.5}"
Vref="${4:-0.6}"

python3 /home/mraffo/amaru/python/ldo01.py \
    "$Iload" "$Vldo" "$Vrect" "$Vref" \
    > /home/mraffo/designs/ldo01_generated.sch

printf 'Generated: /home/mraffo/designs/ldo01_generated.sch\n'
