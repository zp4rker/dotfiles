# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle :compinstall filename '/home/zp4rker/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=/home/zp4rker/.config/zsh/histfile
HISTSIZE=1000
SAVEHIST=5000
bindkey -e
# End of lines configured by zsh-newuser-installa

# Setup antigen
export ADOTDIR="/home/zp4rker/.config/zsh/antigen"
source /home/zp4rker/.config/zsh/antigen.zsh
antigen init /home/zp4rker/.config/zsh/antigen/antigenrc
# End of antigen setup

# Setup PROMPT
PROMPT='%B%F{10}%n@%M%b%f:%B%F{4}%~%f%b%(!.#.$) '
# End of PROMPT setup