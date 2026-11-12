<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "database.php";
$aplicacao_descricao = "Conexao PDO com o banco de dados.";



require_once __DIR__ . '/app.php';

const DB_HOST = 'g.gcompdv.com.br';
const DB_NAME = 'allop_devel';
const DB_USER = 'allopdevel';
const DB_PASS = 'Allop@Devel##2022';
const DB_CHARSET = 'utf8mb4';

const DB_FOTOS_HOST = 'g.gcompdv.com.br';
const DB_FOTOS_NAME = 'allop_devel_fotos';
const DB_FOTOS_USER = 'allopdevel';
const DB_FOTOS_PASS = 'Allop@Devel##2022';
const DB_FOTOS_CHARSET = 'utf8mb4';

function db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $dsn = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;
    $pdo = new PDO($dsn, DB_USER, DB_PASS, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);

    return $pdo;
}

function db_fotos(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $dsn = 'mysql:host=' . DB_FOTOS_HOST . ';dbname=' . DB_FOTOS_NAME . ';charset=' . DB_FOTOS_CHARSET;
    $pdo = new PDO($dsn, DB_FOTOS_USER, DB_FOTOS_PASS, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);

    return $pdo;
}

