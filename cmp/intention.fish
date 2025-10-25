# Completion for `intention` command
# This file should be in: ~/.config/fish/completions/intention.fish

# Disable file completion for `intention` command
complete -c intention -f

complete -c intention -n '__fish_use_subcommand' -a list -d 'List all available intents'
complete -c intention -n '__fish_use_subcommand' -a run -d 'Execute your intention immediately'
complete -c intention -n '__fish_use_subcommand' -a set -d 'Set your intention for later use'
complete -c intention -n '__fish_use_subcommand' -a unset -d 'Unset your intention for later use'
complete -c intention -n '__fish_use_subcommand' -a status -d 'Show your current intention status'
complete -c intention -n '__fish_use_subcommand' -a help -d 'Show help'
complete -c intention -n '__fish_use_subcommand' -a init -d 'Initialize intention config'


complete -c intention -n '__fish_seen_subcommand_from set' -a '(intention list)'
complete -c intention -n '__fish_seen_subcommand_from unset' -a '(intention list)'
complete -c intention -n '__fish_seen_subcommand_from status' -a '(intention list)'
complete -c intention -n '__fish_seen_subcommand_from run' -a '(intention list)'
