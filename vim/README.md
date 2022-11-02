# Vim Configuration

This works for both [Vim](https://www.vim.org/) and [Neovim](https://neovim.io/)

## Quick Start

1. Install Neovim

```
brew install neovim
```

2. Symlink this folder to the locations where Vim/Neovim will use them

```
make link
```

3. Open Neovim

```
nvim
```

4. Install Vim Plugins

```
:PlugInstall
```

## Ruby LSP/Autocompletion

In order for [COC](https://github.com/neoclide/coc.nvim) to work with Ruby codebases, you need to install [solargraph](https://solargraph.org/):

```
gem install solargraph
gem install solargraph-rails
```

Once installed, you should initialize solargraph in your project:

```
solargraph config
```

Add this to the generated `.solargraph.yml`:

```
plugins:
  - solargraph-rails
```

Afterwards, run the following to index the gems used in your project:

```
yard gems
```

## List of Vim plugins used

- [FZF.vim](https://github.com/junegunn/fzf.vim) - File/Text Search
- [NERDTree](https://github.com/preservim/nerdtree) - Directory Explorer
