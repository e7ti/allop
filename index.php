<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "index.php";
$aplicacao_descricao = "Entrada principal do sistema.";



require_once __DIR__ . '/includes/auth.php';

header('Location: ' . app_url(current_user() ? 'dashboard.php' : 'login.php'));
exit;

