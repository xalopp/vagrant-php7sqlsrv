class phpsqlsrv(
    $sqlsrv_ini = '/etc/php7/conf.d/sqlsrv.ini'
) {
    $extension_dir  = '/usr/lib/php/20151012'
    $extension_name = 'sqlsrv.so'
    $extension_file = "${extension_dir}/${extension_name}"

    $repo_dir = '/tmp/pecl-sqlsrv'
    $lc_osname = downcase($::operatingsystem)
    $os_rel    = regsubst($::operatingsystemrelease, '^(\d+)\.(\d+)$','\1\2')

    class { 'msodbcsql' :
        use_unixodbc_packages => true
    } ->
    vcsrepo { $repo_dir:
        ensure   => latest,
        provider => git,
        source   => 'https://github.com/Azure/msphpsql/',
        revision => 'PHP-7.0-Linux',
        user     => 'root',
        require  => Class['php'],
    } ->
    file { $extension_file :
        ensure  => present,
        source => "${repo_dir}/binaries/${lc_osname}${os_rel}_binaries/php_sqlsrv_7_nts.so",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    } ->
    file { '/etc/php/7.0/mods-available/sqlsrv.ini':
        ensure  => present,
        content => "extension=${extension_name}\n",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    } ->
    exec { 'enabel extension':
        command => '/usr/sbin/phpenmod sqlsrv',
        creates => '/etc/php/7.0/cli/conf.d/20-sqlsrv.ini',
    }
}
