class phpsqlsrv(
    $use_source = false
) {
    $extension_dir = '/usr/lib/php/20151012'
    $extension_suffix = 'so'
    $extension_name = 'sqlsrv'
    $extension_file = "${extension_dir}/${extension_name}.${extension_suffix}"
    $pdo_extension_name = 'pdo_sqlsrv'
    $pdo_extension_file = "${extension_dir}/${pdo_extension_name}.${extension_suffix}"

    $repo_dir = '/tmp/pecl-sqlsrv'
    if ($::operatingsystem == 'Debian') {
        $lc_osname = 'ubuntu'
    } else {
        $lc_osname = downcase($::operatingsystem)
    }
    $os_rel    = regsubst($::operatingsystemrelease, '^(\d+)\.(\d+)$','\1')

    vcsrepo { $repo_dir:
        ensure   => latest,
        provider => git,
        source   => 'https://github.com/Azure/msphpsql/',
        revision => 'PHP-7.0-Linux',
        user     => 'root',
        require  => Class['php'],
    } ->
    package { ['g++', 'libssl1.0.0', 'libgss3']:
        ensure => present
    } ->
    exec { 'install msodbcsql':
        command => "/bin/sh '${repo_dir}/ODBC install scripts/installodbc_${lc_osname}.sh'",
        creates => '/opt/microsoft/msodbcsql/lib64/libmsodbcsql-13.0.so.0.0',
    }

    if ($use_source == true) {
        $sqlsrv_so = "${repo_dir}/source/sqlsrv/modules/sqlsrv.so"
        $pdo_sqlsrv_so = "${repo_dir}/source/pdo_sqlsrv/modules/pdo_sqlsrv.so"

    } else {
        $sqlsrv_so = "${repo_dir}/binaries/${::operatingsystem}${os_rel}/php_${extension_name}_7_nts.${extension_suffix}"
        $pdo_sqlsrv_so = "${repo_dir}/binaries/${::operatingsystem}${os_rel}/php_${pdo_extension_name}_7_nts.${extension_suffix}"
    }

    exec { 'build sqlsrv':
        cwd     => "${repo_dir}/source/sqlsrv",
        command => '/usr/bin/phpize && ./configure CXXFLAGS=-std=c++11 && /usr/bin/make',
        creates => $sqlsrv_so,
        require => [Vcsrepo[$repo_dir], Exec['install msodbcsql']],
    } ->
    file { $extension_file :
        ensure  => present,
        source  => $sqlsrv_so,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Vcsrepo[$repo_dir]
    } ->
    file { "/etc/php/7.0/mods-available/${extension_name}.ini":
        ensure  => present,
        content => "extension=${extension_name}.${extension_suffix}\n",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    } ->
    exec { "enable extension ${extension_name}":
        command => "/usr/sbin/phpenmod ${extension_name}",
        creates => "/etc/php/7.0/cli/conf.d/20-${extension_name}.ini",
    }

    exec { 'build pdo_sqlsrv':
        cwd     => "${repo_dir}/source/pdo_sqlsrv",
        command => '/usr/bin/phpize && ./configure CXXFLAGS=-std=c++11 && /usr/bin/make',
        creates => $pdo_sqlsrv_so,
        require => [Vcsrepo[$repo_dir], Exec['install msodbcsql']],
    } ->
    file { $pdo_extension_file :
        ensure  => present,
        source  => $pdo_sqlsrv_so,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Vcsrepo[$repo_dir]
    } ->
    file { "/etc/php/7.0/mods-available/${pdo_extension_name}.ini":
        ensure  => present,
        content => "extension=${pdo_extension_name}.${extension_suffix}\n",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    } ->
    exec { "enable extension ${pdo_extension_name}":
        command => "/usr/sbin/phpenmod ${pdo_extension_name}",
        creates => "/etc/php/7.0/cli/conf.d/20-${pdo_extension_name}.ini",
    }
}
