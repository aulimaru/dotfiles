if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
    pyenv init - fish | source
    starship init fish | source
    abbr rm trash
    abbr nvim ec
    abbr cd z
end
