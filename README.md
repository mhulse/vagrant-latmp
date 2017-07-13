# Vagrant LA(T)MP Stack

**Vagrant CentOS 7 + Apache HTTP + Apache Tomcat 7 + MySQL + PHP5.6**

## Usage

First, [Install Vagrant](https://www.vagrantup.com) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

Visit the links above to install manually … **OR**, install using [Homebrew](https://brew.sh/):

```bash
brew cask install virtualbox vagrant vagrant-manager
# Bonus! Use this to update previously installed casks:
brew cask outdated | xargs brew cask reinstall
```

Somewhere on you machine, create a directory for you Vagrant projects. I put mine here:

```bash
/Users/mhulse/dev/vagrant/<name of project>
```

####### Run installation script

Next, run:

```bash
$ vagrant up
```

**Common commands:**

```bash
$ vagrant ssh
$ vagrant halt
$ vagrant up
```

If you make changes to your `Vagrantfile`:

```bash
# Same as calling `halt` and `up`:
$ vagrant reload [vm-name] [--no-provision]
# Square brackets are optionals.
```

**For a full list of Vagrant’s CLI commands, see: [Command-Line Interface](https://www.vagrantup.com/docs/cli/)**

From here, you can ssh into the current running Vagrant box:

```bash
$ vagrant ssh
```

You are now connected to the Vagrant box at `/home/vagrant`.

Use this to disconnect:

```bash
$ logout
```

… and then this when you are done developing:

```bash
# Terminate the use of any resources by the virtual machine:
$ vagrant destroy
```

**Note:** The vagrant destroy command does not actually remove the downloaded box file. To completely remove the box file, you can use the `vagrant box remove` command.

## Automated provisioning, an example

Vagrant allows us to install dependencies, a.k.a. “[Automatic Provisioning](https://www.vagrantup.com/intro/getting-started/provisioning.html)” when running `vagrant up`; this will create your machine and Vagrant will automatically provision it.

```bash
# Start it:
$ vagrant up
# Reload, no provision:
$ vagrant reload
# Reload and provision:
$ vagrant reload --provision
```

## Using host database

You can use an MySQL database (for example) on the host machine; get the 

```bash
$ vagrant ssh
$ netstat -rn | grep "^0.0.0.0 " | cut -d " " -f10
10.0.2.2
```

From there, just fire up MySQL and make sure your users/database exists.

## Links

Lots of inspiration from [here](https://github.com/spiritix/vagrant-php7) and [here](https://github.com/BetterBrief/vagrant-skeleton/blob/master/Vagrantfile).

## LEGAL

Copyright © 2017 [Michael Hulse](http://mky.io).

Licensed under the Apache License, Version 2.0 (the “License”); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

<img src="https://github.global.ssl.fastly.net/images/icons/emoji/octocat.png">
