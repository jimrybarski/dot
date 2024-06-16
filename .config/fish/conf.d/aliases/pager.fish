# Add color highlighting to man pagers
set -x GROFF_NO_SGR 1  # Prevent groff from emitting SGR escape codes
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
