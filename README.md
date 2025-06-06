# dotfiles

## Table of Contents

- [About and Disclaimer](#about-and-disclaimer)
- [Requirements](#requirements)
- [Steps](#steps)
- [Author](#author)
- [License](#license)

## About and Disclaimer

This repository is merely for personal use. It's not private since someone might
find it useful and, even for me, it saves the pain of login while in a strangers
computer.

## Requirements

- `nix`

## Steps

_It is recommended that you use my
[iac repository](https://github.com/guergeiro/iac)._

1. Create `secrets.nix` based on `secrets.example.nix`

2. Remove original `.bashrc`
   ```bash
   /bin/rm $HOME/.bashrc
   ```

3. Run nix and select corresponding output
   ```bash
   nix run home-manager/master -- switch --flake .#breno-linux
   nix run home-manager/master -- switch --flake .#breno-macos
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
