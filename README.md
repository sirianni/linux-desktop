# Ansible Playbooks
Ansible Playbook for provisioning Ubuntu deskktop on Thinkpad X1 Carbon.

# Commands
```
$ sudo ansible-playbook desktop.yaml --connection=local
```

# HiDPI
For supporting HiDPI displays (e.g. the X1 Carbon laptop monitor), the approach from [this github repo](https://github.com/burntcustard/x11-fractional-display-scaling) was used and automated via ansible.  See [roles/x1carbon/tasks/main.yaml](roles/x1carbon/tasks/main.yaml) for details.

## Remove built-in emoji keyboard shortcut
`ctrl-shift-e` is a standard shortcut in many applications.  In the latest Ubuntu, it is intercepted in the shell to insert emojis.  Run `ibus-setup` to disable the keyboard shortcut for emoji choice ([reference](https://askubuntu.com/questions/1039008/how-can-i-change-the-keyboard-shortcut-for-emoji-picker/1039039)).

# References
* [Ubuntu 18.04 + Lenovo X1 Carbon (6G)](https://medium.com/@hkdb/ubuntu-18-04-on-lenovo-x1-carbon-6g-d99d5667d4d5)