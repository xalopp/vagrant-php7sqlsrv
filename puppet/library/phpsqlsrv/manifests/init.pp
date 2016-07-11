class phpsqlsrv(
    $sqlsrv_ini = '/etc/php7/conf.d/sqlsrv.ini'
) {
    $extension_dir  = '/usr/lib/php/20151012'
    $extension_name = 'sqlsrv.so'
    $extension_file = "${extension_dir}/${extension_name}"

    class { 'msodbcsql' :
        use_unixodbc_packages => true
    } ->
    vcsrepo { '/tmp/pecl-sqlsrv':
        ensure   => latest,
        provider => git,
        source   => 'https://github.com/Azure/msphpsql/',
        revision => 'PHP-7.0-Linux',
        user     => 'root',
        require  => Class['php'],
    } ->
    exec { 'sqlsrv pecl extension':
        command => "/bin/cp /tmp/pecl-sqlsrv/Ubuntu1604/php_sqlsrv_7_ts.so ${$extension_file}",
        creates => $extension_file,
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
