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

1. Init nix-secrets
   ```bash
   cd nix-secrets
   git init
   ```

2. Run nix and select corresponding output
   ```bash
   nix run home-manager/master -- switch --flake .#x86_64-linux
   nix run home-manager/master -- switch --flake .#aarch64-darwin
   ```

### Note

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# Save it to /home/{your-user-here}/.ssh/id_ed25519
```

```bash
# encrypt id_ed25519
openssl enc -aes-256-cbc -pbkdf2 -in id_ed25519 -out id_ed25519.enc
# decrypt id_ed25519
openssl enc -d -aes-256-cbc -pbkdf2 -in id_ed25519.enc -out id_ed25519

# encrypt sign_key
openssl enc -aes-256-cbc -pbkdf2 -in sign_key -out sign_key.enc
# decrypt sign_key
openssl enc -d -aes-256-cbc -pbkdf2 -in sign_key.enc -out sign_key
```

```
# Have .ssh/config with the following
Host github.com
   IdentityFile ~/.ssh/id_ed25519
```

## Author

Created by [Breno Salles](https://brenosalles.com).

## License

This repository is licensed under [GPL-3.0](./LICENSE).
