# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias sc="sesh connect \$(sesh list | fzf)"
eval "$(zoxide init zsh)"
export VISUAL=nvim
export EDITOR=nvim
alias vim=nvim
alias vi=nvim

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# zsh parameter completion for the dotnet CLI
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet
