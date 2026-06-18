<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "app.php";
$aplicacao_descricao = "Configuracao principal do sistema.";



define('APP_NAME', 'Allop');
define('APP_DATE', '01/06/2026');
define('BASE_PATH', dirname(__DIR__));

$scriptName = str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? ''));
$baseUrl = preg_replace('#/(api|mod)(/.*)?$#', '', $scriptName) ?: '';
$baseUrl = rtrim($baseUrl, '/');
define('BASE_URL', $baseUrl === '' ? '' : $baseUrl);

function app_url(string $path = ''): string
{
    return BASE_URL . '/' . ltrim($path, '/');
}

function h(?string $value): string
{
    return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
}
