<?php

$serverName = getenv('MSSQL_SERVERNAME') ?: '192.168.123.41';
$database   = getenv('MSSQL_DATABASE') ?: 'AdventureWorks2016CTP3';
$username   = getenv('MSSQL_USERNAME') ?: 'test';
$password   = getenv('MSSQL_PASSWORD') ?: 'test';

print 'PDO sqlsrv driver available: '.(in_array('sqlsrv', PDO::getAvailableDrivers()) ? 'yes' : 'no').PHP_EOL;

$dbo = new PDO("sqlsrv:server=$serverName ; Database = $database", $username, $password);
print 'PDO sqlsrv connection successfull: '.($dbo ? 'yes' : 'no').PHP_EOL;
