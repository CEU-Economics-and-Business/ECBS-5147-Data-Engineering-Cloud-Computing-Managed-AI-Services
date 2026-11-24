# Creating a public keypair

Run these commands in a terminal from the repository root (in Codespaces, a new terminal already opens there).

Generate SSH keys
```
ssh-keygen -t rsa -f my_keypair -N ''
```

Where:
* `ssh-keygen` is a standard command for generating a keypair
* `-t rsa` tells the keygen that we want to create an RSA keypair (there are many different algorithms for keypair generation)
* `-f my_keypair` indicates where the key files will be located: `my_keypair` (private key) and `my_keypair.pub` (public key) in the current folder
* `-N ''` means we don't want to protect the keypair with a password

## Taking a look at the results
Public Key:
```cat my_keypair.pub```

Private Key:
```cat my_keypair```
