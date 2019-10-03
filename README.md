### docker-default
This repository is merely for personal use. It's not private since someone might find it useful and, even for me, it saves the pain of login while in a strangers computer.

The purpose of this reposity is if you want to use a freshly Ubuntu image, you can and it already comes configured to NOT use root for managing it. It uses the user `docker` and you'll need to `sudo` anything that normally can't be used by normal users in Ubuntu. Useful, in my opinion, to make sure you (or me) are aware of what you're doing.

I also use it for simulating Ubuntu in any host. Example, I use it in my Windows machines so that I can simulate a Linux environment without having one. Useful if you want the perks of a VM but not the drawbacks of heavy computation power, etc.

If you want to use it, take a good look at the comments in both `Dockerfile` and `docker-compose.yml`.