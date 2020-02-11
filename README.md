# ubuntu-how-to
## Table of Contents
- [About and Disclaimer](#about-and-disclaimer)
- [Steps](#steps)
- [Author](#author)
- [License](#license)
## About and Disclaimer
This repository is merely for personal use. It's not private since someone might find it useful and, even for me, it saves the pain of login while in a strangers computer.

The purpose of this reposity is when I start a freshly Ubuntu image. If you want to use it, do it at your own risk.

Also, most of this steps are copy & paste from their respective installation guides.
## Steps
1. Copy [`.bash_aliases`](https://github.com/Guergeiro/ubuntu-how-to/blob/master/.bash_aliases) to home (re-open terminal after this)
2. Update everything
    ```bash
    $ update
    ```
3. Install [Vim](https://www.vim.org/)
    ```bash
    $ sudo apt-get install vim -y
    ```
4. Copy [`.vimrc`](https://github.com/Guergeiro/ubuntu-how-to/blob/master/.vimrc) and [`.vim/`](https://github.com/Guergeiro/ubuntu-how-to/tree/master/.vim) to home (re-open vim after this)
5. Install [Git](https://git-scm.com/)
    ```bash
    $ sudo apt-get install git -y
    ```
    ```bash
    $ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    # Save it to /home/your-user-here/.ssh/GitHub
    ```
    ```bash
    $ echo -e "Host github.com\n    Hostname ssh.github.com\n    IdentityFile ~/.ssh/GitHub.pub\n    Port 443 #Only if the default 22 is blocked" > ~/.ssh/config
    # Remove port option if possible
    ```
6. Install [VisualStudioCodium](https://vscodium.com/)
    ```bash
    $ wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
    ```
    ```bash
    $ echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list
    ```
    ```bash
    $ update && sudo apt-get install codium -y
    ```
    With the following extensions:
    - [Vim](https://github.com/VSCodeVim/Vim)
    - [Beautify](https://github.com/HookyQR/VSCodeBeautify)
    - [Live Server](https://github.com/ritwickdey/vscode-live-server)
    - [Material Icon Theme](https://github.com/PKief/vscode-material-icon-theme)
    - [Debugger for Java](https://github.com/Microsoft/vscode-java-debug)
    - [Java Dependency Viewer](https://github.com/Microsoft/vscode-java-dependency)
    - [Java Test Runner](https://github.com/Microsoft/vscode-java-test)
    - [Language Support for Java(TM) by Red Hat](https://github.com/redhat-developer/vscode-java)
    - [Maven for Java](https://github.com/Microsoft/vscode-maven)
    - [Python](https://github.com/Microsoft/vscode-python)
7. Install [cURL](https://curl.haxx.se/)
    ```bash
    $ sudo apt-get install curl -y
    ```
8. Install [Node](https://nodejs.org/) (change **Y** to current LTS)
    ```bash
    $ curl -sL https://deb.nodesource.com/setup_Y.x | sudo -E bash -
    ```
    ```bash
    $ update && sudo apt-get install nodejs -y
    ```
9. Install [TypeScript](https://www.typescriptlang.org/)
    ```bash
    $ sudo npm install -g typescript
    ```
10. Install [Python](https://www.python.org/) (version 3)
    ```bash
    $ sudo apt-get install python3 -y
    ```
11. Install [OpenJDK](http://openjdk.java.net/)
    ```bash
    $ sudo apt-get install default-jdk-headless -y
    ```
12. Install [Docker](https://www.docker.com/)
    ```bash
    $ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
    ```
    ```bash
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    ```
    ```bash
    $ sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
    ```
    ```bash
    $ update && sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    ```
    ```bash
    $ sudo usermod -aG docker your-user-here
    ```
## Author
Created by [Breno Salles](https://brenosalles.com).
## License
This repository is licensed under [MIT License](https://github.com/Guergeiro/ubuntu-how-to/blob/master/LICENSE).