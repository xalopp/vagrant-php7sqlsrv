<?php

$serverName = getenv('MSSQL_SERVERNAME') ?: '192.168.123.41';
$database   = getenv('MSSQL_DATABASE') ?: 'AdventureWorks2016CTP3';
$username   = getenv('MSSQL_USERNAME') ?: 'test';
$password   = getenv('MSSQL_PASSWORD') ?: 'test';

$sqlStatement = getenv('MSSQL_SQL') ?: 'SELECT [AccountNumber] FROM Sales.Customer';

/**
 * @param array $error
 */
function printErrorInfo(array $error)
{
    echo "SQLSTATE: ".$error[0].PHP_EOL;
    echo "Code:     ".$error[1].PHP_EOL;
    echo "Message:  ".$error[2].PHP_EOL;
}

print 'PDO sqlsrv driver available: '.(in_array('sqlsrv', PDO::getAvailableDrivers()) ? 'yes' : 'no').PHP_EOL;

$dbo = new PDO("sqlsrv:server=$serverName ; Database = $database", $username, $password);
print 'PDO sqlsrv connection successfull: '.($dbo ? 'yes' : 'no').PHP_EOL;


$result = $dbo->query($sqlStatement);
print 'PDO sqlsrv query successfull: '.($result !== false ? 'yes' : 'no').PHP_EOL;

if ($result === false) {
    printErrorInfo($dbo->errorInfo());
}

while($row = $result->fetch(PDO::FETCH_ASSOC))
{
    var_dump($row);
}
