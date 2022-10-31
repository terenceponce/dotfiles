# Terence's Dev Setup

## Overview

This is a collection of config files that I use to do my day to day work.

## Do the following before getting started

1. Install [FZF](https://github.com/junegunn/fzf)

```
brew install fzf
```

2. Install [ripgrep](https://github.com/BurntSushi/ripgrep)

```
brew install ripgrep
```

3. Install [bat](https://github.com/sharkdp/bat)

```
brew install bat
```

4. Add this to `.zshrc`

```
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

export BAT_THEME="Solarized (light)"
```
