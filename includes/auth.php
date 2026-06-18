<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "auth.php";
$aplicacao_descricao = "Funcoes de sessao e autenticacao.";



require_once __DIR__ . '/../config/database.php';

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

function current_user(): ?array
{
    return $_SESSION['usuario'] ?? null;
}

function require_login(): void
{
    if (!current_user()) {
        header('Location: ' . app_url('login.php'));
        exit;
    }
}

function login_user(array $usuario): void
{
    $_SESSION['usuario'] = [
        'id' => (int) $usuario['id'],
        'nome' => $usuario['nome'] ?? $usuario['login'],
        'login' => $usuario['login'],
        'perfil_id' => (int) ($usuario['perfil_id'] ?? 0),
    ];
}

function logout_user(): void
{
    $_SESSION = [];
    if (ini_get('session.use_cookies')) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'], (bool) $params['secure'], (bool) $params['httponly']);
    }
    session_destroy();
}

