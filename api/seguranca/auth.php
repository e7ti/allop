<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "auth.php";
$aplicacao_descricao = "API de login do sistema.";



require_once __DIR__ . '/../bootstrap.php';

$data = request_data();
$login = trim((string) ($data['login'] ?? ''));
$senha = (string) ($data['senha'] ?? '');

if ($login === '' || $senha === '') {
    api_response(false, ['message' => 'Informe usuário e senha.'], 422);
}

$stmt = db()->prepare("SELECT id, nome, login, senha, perfil_id, ativo FROM seg_usuarios WHERE login = :login LIMIT 1");
$stmt->execute(['login' => $login]);
$usuario = $stmt->fetch();

if (!$usuario || !(int) ($usuario['ativo'] ?? 1)) {
    api_response(false, ['message' => 'Usuário ou senha inválidos.'], 401);
}

$hash = (string) $usuario['senha'];
$senhaOk = password_verify($senha, $hash) || hash_equals($hash, $senha);

if (!$senhaOk) {
    api_response(false, ['message' => 'Usuário ou senha inválidos.'], 401);
}

login_user($usuario);
api_response(true, ['message' => 'Login realizado.', 'redirect' => app_url('dashboard.php')]);

