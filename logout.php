<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "logout.php";
$aplicacao_descricao = "Encerra a sessao do usuario.";



require_once __DIR__ . '/includes/auth.php';

logout_user();
header('Location: ' . app_url('login.php'));
exit;

