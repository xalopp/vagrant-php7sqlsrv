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


$conn = sqlsrv_connect($serverName, ['Database' => $database, 'Uid' => $username, 'PWD' => $password]);
print 'PDO sqlsrv connection successfull: '.($conn !== false ? 'yes' : 'no').PHP_EOL;

$result = sqlsrv_query($conn, $sqlStatement);
print 'PDO sqlsrv query successfull: '.($result !== false ? 'yes' : 'no').PHP_EOL;

if ($result === false) {
    printErrorInfo(sqlsrv_errors());
}

while ($row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC)) {
    var_dump($row);
}
sqlsrv_free_stmt($result);

