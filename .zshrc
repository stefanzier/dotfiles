# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zmodload zsh/zprof
export ZSH=$HOME/.oh-my-zsh
export PATH="$HOME/bin:$PATH"
alias takeover="tmux detach -a"
eval "$(/Users/szier/src/idl/idldev-tool/bin/idldev init -)"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-z
)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
