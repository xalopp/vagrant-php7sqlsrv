class msodbcsql (
    $msodbc_version = '13.0.0.0',
    $use_unixodbc_packages = true
) {
    $msodbc_pkg_name = "msodbcsql-${msodbc_version}.tar.gz"

    $build_dir = "/tmp/msodbcsql-${msodbc_version}"

    package { ['g++-5', 'libssl1.0.0', 'libgss3']:
        ensure => present,
    }

    if ($use_unixodbc_packages == true) {
        package { ['unixodbc', 'unixodbc-dev'] :
            ensure => present,
        }
    }

    exec { "download ${msodbc_pkg_name}" :
        cwd     => '/tmp',
        command => "/usr/bin/wget https://download.microsoft.com/download/2/E/5/2E58F097-805C-4AB8-9FC6-71288AB4409D/${msodbc_pkg_name}",
        creates => "/tmp/${msodbc_pkg_name}",
    } ->
    exec { 'untar msodbcsql package' :
        cwd     => '/tmp',
        command => "/bin/tar xzf ${msodbc_pkg_name}",
        creates => $build_dir,
    } ->
    file { "${build_dir}/build_dm.diff" :
        ensure  => present,
        source  => "puppet:///modules/msodbcsql/build_dm.diff",
    } ->
    exec { 'patch build_dm.sh' :
        cwd     => $build_dir,
        command => '/usr/bin/patch -b < build_dm.diff',
        creates => "${build_dir}/build_dm.sh.orig",
    } ->
    exec { 'build unixODBC' :
        cwd     => $build_dir,
        command => "${build_dir}/build_dm.sh",
        creates => '/usr/bin/odbc_config',
    } ->
    exec { 'install msodbcsql' :
        cwd     => $build_dir,
        command => "${build_dir}/install.sh install --force --accept-license",
        creates => '/usr/bin/sqlcmd',
        require => Package['g++-5', 'libssl1.0.0', 'libgss3'],
    }
}
