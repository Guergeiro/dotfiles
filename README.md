# dotfiles

## Table of Contents

- [About and Disclaimer](#about-and-disclaimer)
- [Steps](#steps)
- [Author](#author)
- [License](#license)

## About and Disclaimer

This repository is merely for personal use. It's not private since someone might
find it useful and, even for me, it saves the pain of login while in a strangers
computer.

The purpose of this reposity is when I start a freshly Linux image, a bit more
than just dotfiles. If you want to use it, do it at your own risk.

## Steps

_It is recommended that you use my
[iac repository](https://github.com/guergeiro/iac)._

1. Install stow

   ```bash
   sudo apt-get install stow
   ```

2. Unstow for each directory
   ```bash
   stow --target $HOME --stow {dirname} # this should be scripted
   ```

3. Remove original `.bashrc`
   ```bash
   /bin/rm $HOME/.bashrc
   ```

4. Stow for each directory
   ```bash
   stow --target $HOME --stow {dirname} # this should be scripted
   ```

### Note

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
# Save it to /home/{your-user-here}/.ssh/GitHub
```

```
# Have .ssh/config with the following
Host github.com
   IdentityFile ~/.ssh/GitHub
```

## Author

Created by [Breno Salles](https://brenosalles.com).

## License

This repository is licensed under [GPL-3.0](./LICENSE).
