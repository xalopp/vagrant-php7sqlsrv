class mssqltestenv(
    $servername = '192.168.56.102',
    $database = 'AdventureWorks2016CTP3',
    $username = 'test',
    $password = 'test'
) {
    file { '/etc/profile.d/mssqlserver.sh' :
        ensure  => present,
        mode    => '0644',
        content => "
export MSSQL_SERVERNAME='${servername}'
export MSSQL_DATABASE='${database}'
export MSSQL_USERNAME='${username}'
export MSSQL_PASSWORD='${password}'
",
    }
}
