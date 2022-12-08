# Custom $PATH with extra locations.
export PATH=$HOME/.local/bin:$PATH

# Source antigen
. /usr/share/zsh-antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle aliases
antigen bundle autojump
antigen bundle command-not-found
antigen bundle docker
antigen bundle docker-compose
antigen bundle git
antigen bundle git-flow
antigen bundle helm
antigen bundle kubectl
antigen bundle lpass
antigen bundle pip
antigen bundle terraform
antigen bundle tmux

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply

# Molecule autocompletion
eval "$(_MOLECULE_COMPLETE=zsh_source molecule)"

# Source .aliases if it exists.
if [ -f "$XDG_DATA_HOME/dotfiles/.aliases" ]; then
  . "$XDG_DATA_HOME/dotfiles/.aliases"
fi

# Source .exports if it exists.
if [ -f "$XDG_DATA_HOME/dotfiles/.exports" ]; then
  . "$XDG_DATA_HOME/dotfiles/.exports"
fi

# Source .personal if it exists.
if [ -f "$XDG_DATA_HOME/dotfiles/.personal" ]; then
  . "$XDG_DATA_HOME/dotfiles/.personal"
fi
