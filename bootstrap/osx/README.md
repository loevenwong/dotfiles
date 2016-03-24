#### Brew install:

First install brew

```shell
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
```

install packages 
```shell
$ export HOMEBREW_CASK_OPTS="--appdir=/Applications"
$ brew tap Homebrew/bundle
$ brew bundle
```

change shell:
```shell
$ chsh -s $(which zsh)
```

install ohmyzsh:
```shell
$ curl -L http://install.ohmyz.sh | sh
```

install fresh for dotfiles
```shell
$ git clone https://github.com/lxhunter/dotfiles.git ~/.dotfiles
$ bash -c "`curl -sL get.freshshell.com`"
$ fresh install
```

manualy install:
- Photoshop 5.5
- HMA! Pro VPN
- SnapNDrag Pro
- readkit
- screenium
- wunderlist
- themes: https://github.com/altercation/solarized