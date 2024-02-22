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

1. Create ssh key for your git provider (GitHub in this example)

   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   # Save it to /home/{your-user-here}/.ssh/GitHub
   ```

   ```
   # Have .ssh/config with the following
   Host github.com
       IdentityFile ~/.ssh/GitHub
   ```

2. Install [Python3](https://www.python.org/)

   ```bash
   sudo apt-get install python3 -y
   ```
3. Install Ansible

   ```bash
   python3 -m pip install --user ansible-core
   ```

4. Navigate to a place of your choice

   ```bash
   cd $HOME/Documents/guergeiro
   ```

5. Clone the my Infrastructure as Code
   [repository](https://github.com/guergeiro/iac)

   ```bash
   git clone git@github.com:Guergeiro/iac.git
   ```

6. Install playbook dependencies

   ```bash
   ansible-galaxy install -r requirements.yml --force
   ```

7. Run the playbook

   ```bash
   ansible-playbook localhost.yml --ask-vault-password --ask-become-pass \
       --vault-id @prompt
   ```

## Author

Created by [Breno Salles](https://brenosalles.com).

## License

This repository is licensed under [GPL-3.0](./LICENSE).
