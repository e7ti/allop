<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "bootstrap.php";
$aplicacao_descricao = "Inicializacao padrao das APIs.";


require_once __DIR__ . '/../includes/auth.php';

header('Content-Type: application/json; charset=utf-8');

function api_response(bool $success, array $data = [], int $status = 200): void
{
    http_response_code($status);
    echo json_encode(['success' => $success] + $data, JSON_UNESCAPED_UNICODE);
    exit;
}

function request_data(): array
{
    $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
    if (stripos($contentType, 'application/json') !== false) {
        $raw = file_get_contents('php://input');
        return $raw ? (json_decode($raw, true) ?: []) : [];
    }
    return $_POST ?: $_GET;
}

function api_require_login(): void
{
    if (!current_user()) {
        api_response(false, ['message' => 'Sessao expirada.'], 401);
    }
}

