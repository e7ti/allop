<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "admin_senha.php";
$aplicacao_descricao = "API para alterar a senha do usuario admin.";

require_once __DIR__ . '/../bootstrap.php';

$data = request_data();
$novaSenha = (string) ($data['nova_senha'] ?? '');
$confirmarSenha = (string) ($data['confirmar_senha'] ?? '');

if (strlen($novaSenha) < 6) {
    api_response(false, ['message' => 'A senha deve ter pelo menos 6 caracteres.'], 422);
}

if ($novaSenha !== $confirmarSenha) {
    api_response(false, ['message' => 'A confirmacao da senha nao confere.'], 422);
}

try {
    $stmt = db()->prepare("UPDATE seg_usuarios SET senha = :senha WHERE login = 'admin'");
    $stmt->execute(['senha' => password_hash($novaSenha, PASSWORD_DEFAULT)]);

    if ($stmt->rowCount() < 1) {
        api_response(false, ['message' => 'Usuario admin nao encontrado.'], 404);
    }

    api_response(true, ['message' => 'Senha do admin alterada com sucesso.']);
} catch (Throwable $e) {
    api_response(false, ['message' => $e->getMessage()], 500);
}
