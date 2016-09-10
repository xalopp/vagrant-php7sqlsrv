# Vagrant Box installing PHP7 with Microsoft SQLSRV PECL extension for testing

This package will provide you a ready to run virtual machine preinstalled
with [PHP7](http://php.net) and [Microsoft Drivers for PHP for SQL Server](https://github.com/Azure/msphpsql).

Currently, following operating systems are supported:
* Ubuntu 16.04 `xenial` 64 bit
* Debian 8.5 `jessie` 64 bit

# Prerequisites
* [VirtualBox](https://www.virtualbox.org/)
* [vagrant](https://www.vagrantup.com/)
* MS SQL Server to test with
* Access to the Internet

# Recommended Vagrant plugins
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
* [vagrant-cachier](http://fgrehm.viewdocs.io/vagrant-cachier/)

# Installation

Clone the project from github, change to the subdirectory and launch vagrant.

```
git clone https://github.com/xalopp/vagrant-php7sqlsrv.git
cd vagrant-php7sqlsrv
vagrant up xenial --provision 
```

This will launch a Ubuntu `xenial` box.

## Debian support

To start a Debian `jessie` box, simply replaces `xenial` by `jessie` in the commands.
I might be necessary to re-provison the box with
```
vagrant provision jessie --provision-with puppet
```
if some puppet errors are shown.

## Testing Doctrine DBAL

SSH to the vagrant box with `vagrant ssh xenial`

The execute in your box following commands:
```
git clone https://github.com/doctrine/dbal.git
cd dbal
cp /vagrant/config/doctrine-dbal/sqlsrv.travis.xml.dist tests/travis/sqlsrv.travis.xml
composer update
```

You should edit the file `tests/travis/sqlsrv.travis.xml` before you run the test.

```
./vendor/bin/phpunit --configuration tests/travis/sqlsrv.travis.xml
```

# License

The project is released under the permissive MIT license.
See the [LICENSE](LICENSE) file for more details.


