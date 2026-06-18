<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "dashboard.php";
$aplicacao_descricao = "Dashboard responsivo do sistema.";



require_once __DIR__ . '/includes/layout.php';
require_login();

$cards = [
    ['titulo' => 'Usuarios', 'texto' => 'Controle de acessos', 'link' => 'mod/seguranca/usuarios_lista.php'],
    ['titulo' => 'Perfis', 'texto' => 'Grupos e permissoes', 'link' => 'mod/seguranca/perfis_lista.php'],
    ['titulo' => 'Aplicacoes', 'texto' => 'Menu dinamico', 'link' => 'mod/seguranca/aplicacoes_lista.php'],
    ['titulo' => 'Perfil x Aplicacoes', 'texto' => 'Permissoes por perfil', 'link' => 'mod/seguranca/perfil_aplicacoes_lista.php'],
    ['titulo' => 'Usuario x Aplicacoes', 'texto' => 'Permissoes individuais', 'link' => 'mod/seguranca/usuarios_permissoes_lista.php'],
];

render_header('Dashboard');
?>
<div class="row g-3">
    <?php foreach ($cards as $card): ?>
        <div class="col-12 col-md-6 col-xl-3">
            <a class="text-decoration-none text-reset" href="<?= app_url($card['link']) ?>">
                <section class="card card-slim dashboard-tile h-100">
                    <div class="card-body">
                        <span class="page-kicker">Seguranca</span>
                        <h2><?= h($card['titulo']) ?></h2>
                        <p class="mb-0 text-muted"><?= h($card['texto']) ?></p>
                    </div>
                </section>
            </a>
        </div>
    <?php endforeach; ?>
</div>
<?php render_footer(); ?>

