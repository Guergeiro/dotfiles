# linux-how-to

## Table of Contents

-   [About and Disclaimer](#about-and-disclaimer)
-   [Steps](#steps)
-   [Author](#author)
-   [License](#license)

## About and Disclaimer

This repository is merely for personal use. It's not private since someone might find it useful and, even for me, it saves the pain of login while in a strangers computer.

The purpose of this reposity is when I start a freshly Linux image, a bit more than just dotfiles. If you want to use it, do it at your own risk.

Also, most of this steps are copy & paste from their respective installation guides.

## Steps

1. Install [cURL](https://curl.haxx.se/)

    ```
    $ sudo apt-get install curl -y
    ```

2. Navigate to where you want this repository to be located

    ```
    $ cd $HOME/Documents/
    ```

3. Run install script (Will take a while)

    ```
    $ curl -fsSL https://raw.githubusercontent.com/Guergeiro/linux-how-to/master/install.sh | sh
    ```

4. Create ssh key for your git provider (GitHub in this example)

    ```
    $ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    # Save it to /home/your-user-here/.ssh/GitHub
    ```

    ```
    $ echo -e "Host github.com\n    Hostname ssh.github.com\n    IdentityFile ~/.ssh/GitHub.pub\n    Port 443 #Only if the default 22 is blocked" > ~/.ssh/config
    # Remove port option if possible
    ```

## Author

Created by [Breno Salles](https://brenosalles.com).

## License

This repository is licensed under [MIT License](./LICENSE).
