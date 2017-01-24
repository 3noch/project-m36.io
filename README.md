# Try Project:M36 Online

This repository manages a website for learning about and trying the amazing [Project:M36](https://github.com/agentm/project-m36) database system, built by [@agentm](https://github.com/agentm).

This setup uses the powerful [Nix](https://nixos.org/nix/) package management system and its accompanying toolset:

  - [NixOps](https://nixos.org/nixops/) for deployments
  - [NixOS](https://nixos.org/) as the Linux-based server OS

**Note:** Nix does not support Windows. If you're on Windows, you'll need to run this from within a Virtual Machine (VM).

With this setup, you can easily deploy your site to one or more servers with minimal effort. You can (and should) also deploy to local [VirtualBox](https://www.virtualbox.org/) virtual machines. And, you can even use the Nix packages to install the site directly on your local host.


## Requirements

  1. First install [Nix](https://nixos.org/nix/). It is not invasive and can be removed easily if you change your mind (using `rm -r /nix`).

  2. Deployments are done with [NixOps](https://nixos.org/nixops/). You can install `nixops` with `nix` by running `nix-env -i nixops`. However, you don't need to because this repository has a `deploy/manage` script that you'll use which will run `nixops` tasks for you.

  3. Install [VirtualBox](https://www.virtualbox.org/) in order to test your server deployments.

  4. If you plan to deploy to a real server, you will likely need to keep secrets in this repository. That will require installing [git-crypt](https://www.agwa.name/projects/git-crypt/) and setting it up. See `SETUP-SECRETS.md` for information on that.


## Deploying to VirtualBox

Create a VirtualBox deployment:

  1. `deploy/manage vbox create '<server/logical.vbox.nix>' '<server/physical.vbox.nix>'`
  2. `deploy/manage vbox deploy`

**Notes:**

  * `nixops` deployments can sometimes be finicky. If something hangs or fails, try running it again. It is a very deterministic system so this should not be a problem.
  * Run `deploy/manage --help` to see all options (this is just `nixops` underneath).

You should then be able to open the IP of the VM in your browser and test it. If you don't know the IP, run `deploy/manage vbox info`.


### Troubleshooting

  * Sometimes VirtualBox will give your machine a new IP. If this happens, `nixops` (i.e. the `manage` script) may fail to connect to your machine via SSH. If this happens, remove the line with the old IP from your `~/.ssh/known_hosts` file and try again.
  * If the state of your VirtualBox VM changes in a way that `nixops` didn't notice, your deployments may fail. Try running `./manage vbox deploy --check` (using the `--check` flag) to tell `nixops` to reassess the state of the machine.


## Deploying to Real Servers

With this setup you can deploy to any PaaS/IaaS service supported by `nixops`. This project uses [DigitalOcean](https://www.digitalocean.com/). See `DEPLOY-DIGITAL-OCEAN.md` for details.
