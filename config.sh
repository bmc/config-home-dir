#!/usr/bin/env bash

function die
{
  echo "$@" 2>/dev/null
  exit 1
}

function link
{
  echo "linking $1 -> $2"
  ln -s $1 $2
}

function clone
{
  source=$1
  target=${2:-$1}
  if [ -d $target ]
  then
    echo "$target already exists in $(pwd)"
  else
    g=git@github.com:bmc/$source.git
    echo "Cloning $g in $(pwd)"
    git clone $g $target
  fi
}

h=${1:-$HOME}

cd $h || die "No $h directory"

type -p ruby >/dev/null || die "ruby not found in path"
type -p rake >/dev/null || die "rake not found in path"

mkdir -p lib bin src/mystuff

mkdir -p lib
cd lib
clone dotfiles
clone elisp emacs
clone lib-sh

cd dotfiles
rake 

cd $h
clone init-sh
rm -f .zshrc .bashrc
link init-sh/zshrc .zshrc
link init-sh/bashrc .bashrc

cd $h/src/mystuff
clone misc-scripts
cd misc-scripts
rake install
cd ..

# Fish-specific. Disabled for now.
#mkdir -p shell
#cd shell
#clone fish-config
#cd fish-config
#bash install.sh

#echo "Installing Oh-My-Fish"
#curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish

# Zsh-specific.
echo "Installing Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
