function fish_greeting; end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

#ENV
set -Ux EDITOR nvim

# PATH
set -U fish_user_paths ~/.local/bin $fish_user_paths

# prompt
function fish_prompt
    set_color red
    echo -n "["

    set_color yellow
    echo -n (whoami)

    set_color green
    echo -n "@"

    set_color blue
    echo -n (hostname)

    set_color magenta
    echo -n " "(prompt_pwd)

    set_color red
    echo -n "]"

   
    if command git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
        set branch (git branch --show-current 2>/dev/null)
        echo -n " ["

        if test (git status --porcelain | wc -l) -gt 0
            set_color red
        else
            set_color green
        end
        echo -n $branch
        set_color red
        echo -n "]"
    end

    set_color normal
    echo -n "\$ "
end

function fish_right_prompt
    echo -n (set_color magenta)(date "+%d")(set_color green)"/"(set_color magenta)(date "+%m")(set_color green)"/"(set_color magenta)(date "+%Y")" "(date "+%H:%M:%S")(set_color normal);
end

# aliases

# config
function config
    switch $argv[1]
        case "fish"
            if test "$argv[2]" = "source"
                source ~/.config/fish/config.fish
                echo "Fish configuration sourced!"
            else
                $EDITOR ~/.config/fish/config.fish
            end
        case "nvim"
            $EDITOR ~/.config/nvim/init.lua  
        case "tmux"
            if test "$argv[2]" = "source"
                source ~/.tmux.conf
                echo "Tmux configuration sourced!"
            else
                $EDITOR ~/.tmux.conf
            end
        case "*"
            echo "Usage: config <fish|nvim|tmux> [source]"
    end
end

# carapace
set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
mkdir -p ~/.config/fish/completions
carapace --list | awk '{print $1}' | xargs -I{} touch ~/.config/fish/completions/{}.fish # disable auto-loaded completions (#185)
carapace _carapace | source

# zoxide
zoxide init fish | source
