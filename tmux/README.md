# Tmux Configuration

## Getting Started

1. Install [tmux](https://github.com/tmux/tmux)

```
brew install tmux
```

2. Install [tmuxinator](https://github.com/tmuxinator/tmuxinator)

```
gem install tmuxinator
```

3. Install [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

4. Add this to `.zshrc`

```
export EDITOR=nvim
alias tx=tmuxinator
```

5. Reload ZSH

```
source ~/.zshrc
```

6. Symlink the configuration file

```
make link
```

7. Install tmux plugins by going inside tmux and doing `prefix` + I (`CTRL + B` + `I`)

8. Follow tmuxinator instructions on [how to use the tool](https://github.com/tmuxinator/tmuxinator#usage). There is also a sample tmuxinator project in this directory, so you can get started.

## Troubleshooting

### Duplicating/Flickering characters in MacOS 

You can follow the series of commands listed [in this answer in StackOverflow](https://stackoverflow.com/a/74042519/395972)
