if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr rm trash
    abbr nvim ec
    abbr cd z
    zoxide init fish | source
    starship init fish | source
    pyenv init --no-rehash - fish | source
end
export PATH="$HOME/.local/bin:$PATH"
