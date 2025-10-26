# Completion for `intention` command
# This file should be in: ~/.config/fish/completions/intention.fish

# Disable file completion for `intention` command
complete -c intention -f

complete -c intention -l help -s h -d 'Show help'
complete -c intention -l list -s l -d 'List available procedures'
complete -c intention -l init -s i -d 'Initalize or Reconfigure shared location'

complete -c intention -n '__fish_use_subcommand' -a '(intention --list)' -d 'Available procedures'
