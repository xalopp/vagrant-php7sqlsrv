# Vagrant Box installing PHP7 with Microsoft SQLSRV PECL extension for testing

This package will provide you a ready to run Ubuntu 16.04 virtual machine preinstalled
with [PHP7](http://php.net) and [Microsoft Drivers for PHP for SQL Server](https://github.com/Azure/msphpsql).

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
vagrant up --provision
```

## Testing Doctrine DBAL

SSH to the vagrant box with `vagrant ssh`

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


