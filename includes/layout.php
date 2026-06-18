<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$pagina_aplicacao_descricao = $aplicacao_descricao ?? '';
$aplicacao_nome = $aplicacao_nome ?? "layout.php";
$aplicacao_descricao = $aplicacao_descricao ?? "Header, menu e footer padrao do sistema.";


require_once __DIR__ . '/permissions.php';

if ($pagina_aplicacao_descricao !== '') {
    $aplicacao_descricao = $pagina_aplicacao_descricao;
}

function menu_icon(string $name): string
{
    $key = strtolower(trim($name));
    $icons = [
        'principal' => '<svg viewBox="0 0 24 24"><path d="M12 3 3 11h2v9h5v-6h4v6h5v-9h2L12 3Z"/></svg>',
        'configurações' => '<svg viewBox="0 0 24 24"><path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32.59.22 2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.21.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/></svg>',
        'produtos' => '<svg viewBox="0 0 24 24"><path d="M21 8.5 12 3 3 8.5v7L12 21l9-5.5v-7ZM12 5.3l5.4 3.3L12 11.8 6.6 8.6 12 5.3Zm-7 5.2 6 3.6v4.6l-6-3.6v-4.6Zm8 8.2v-4.6l6-3.6v4.6l-6 3.6Z"/></svg>',
        'cadastros' => '<svg viewBox="0 0 24 24"><path d="M4 4h16v4H4V4Zm0 6h7v10H4V10Zm9 0h7v4h-7v-4Zm0 6h7v4h-7v-4Z"/></svg>',
        'compras' => '<svg viewBox="0 0 24 24"><path d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2Zm10 0c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2ZM7.2 14h7.4c.8 0 1.5-.4 1.8-1.1L20 6H6.2L5.4 4H2v2h2l3.6 7.6L6.2 16c-.4.7.1 1.5.9 1.5H19v-2H8.4l.8-1.5Z"/></svg>',
        'operacional' => '<svg viewBox="0 0 24 24"><path d="M4 6h10v6H4V6Zm0 8h6v4H4v-4Zm8 0h8v4h-8v-4Zm4-8h4v6h-4V6Z"/></svg>',
        'gerencial' => '<svg viewBox="0 0 24 24"><path d="M4 19h18v2H4v-2Zm2-8h3v6H6v-6Zm5-7h3v13h-3V4Zm5 4h3v9h-3V8Z"/></svg>',
        'ajuda' => '<svg viewBox="0 0 24 24"><path d="M11 18h2v-2h-2v2Zm1-16a9 9 0 1 0 0 18 9 9 0 0 0 0-18Zm0 16a7 7 0 1 1 0-14 7 7 0 0 1 0 14Zm0-12a3 3 0 0 0-3 3h2a1 1 0 1 1 1 1c-1.7 0-3 1.3-3 3v1h2v-1c0-.6.4-1 1-1a3 3 0 0 0 0-6Z"/></svg>',
        'sair' => '<svg viewBox="0 0 24 24"><path d="M10 17v-2h4V9h-4V7l-5 5 5 5Zm1-15h9v20h-9v-2h7V4h-7V2Z"/></svg>',
        'e-mail' => '<svg viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4-8 5-8-5V6l8 5 8-5v2z"/></svg>',
        'seguranca' => '<svg viewBox="0 0 24 24"><path d="M12 2 4 5v6c0 5 3.4 9.7 8 11 4.6-1.3 8-6 8-11V5l-8-3Zm0 5a2 2 0 0 1 2 2v1h1v6H9v-6h1V9a2 2 0 0 1 2-2Z"/></svg>',
        'segurança' => '<svg viewBox="0 0 24 24"><path d="M12 2 4 5v6c0 5 3.4 9.7 8 11 4.6-1.3 8-6 8-11V5l-8-3Zm0 5a2 2 0 0 1 2 2v1h1v6H9v-6h1V9a2 2 0 0 1 2-2Z"/></svg>',
        'usuarios' => '<svg viewBox="0 0 24 24"><path d="M8 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm8 0a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM8 13c-2.7 0-6 1.3-6 3v2h12v-2c0-1.7-3.3-3-6-3Zm8 0c-.5 0-1 .1-1.5.2 1 .7 1.5 1.6 1.5 2.8v2h6v-2c0-1.7-3.3-3-6-3Z"/></svg>',
        'perfis' => '<svg viewBox="0 0 24 24"><path d="M12 2 5 5v6c0 4.4 3 8.6 7 10 4-1.4 7-5.6 7-10V5l-7-3Zm0 5a3 3 0 1 1 0 6 3 3 0 0 1 0-6Zm0 12a7.2 7.2 0 0 1-4-2.8c.4-1.4 3-2.2 4-2.2s3.6.8 4 2.2a7.2 7.2 0 0 1-4 2.8Z"/></svg>',
        'aplicacoes' => '<svg viewBox="0 0 24 24"><path d="M4 4h7v7H4V4Zm9 0h7v7h-7V4ZM4 13h7v7H4v-7Zm9 0h7v7h-7v-7Z"/></svg>',
        'perfil x aplicacoes' => '<svg viewBox="0 0 24 24"><path d="M12 2 4 5v6c0 5 3.4 9.7 8 11 4.6-1.3 8-6 8-11V5l-8-3Zm4.5 7.5-5.2 5.2-2.3-2.3 1.4-1.4.9.9 3.8-3.8 1.4 1.4Z"/></svg>',
        'usuario x aplicacoes' => '<svg viewBox="0 0 24 24"><path d="M10 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm0 2c-2.7 0-8 1.3-8 4v2h10.5a6.5 6.5 0 0 1-.5-2.5c0-1.2.3-2.4.9-3.3A15 15 0 0 0 10 13Zm8.7 1.3 1.4 1.4-4.6 4.6-2.6-2.6 1.4-1.4 1.2 1.2 3.2-3.2Z"/></svg>',
    ];

    return $icons[$key] ?? '<svg viewBox="0 0 24 24"><path d="M5 4h14v16H5V4Zm2 4v2h10V8H7Zm0 4v2h10v-2H7Z"/></svg>';
}

function render_header(string $titulo, array $actions = []): void
{
    global $aplicacao_descricao;
    $user = current_user();
    $descricao = trim((string) ($aplicacao_descricao ?? ''));
    ?>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= h($titulo) ?> | <?= h(APP_NAME) ?></title>
    <link rel="stylesheet" href="<?= app_url('assets/vendor/bootstrap/css/bootstrap.min.css') ?>">
    <link rel="stylesheet" href="<?= app_url('assets/vendor/select2/css/select2.min.css') ?>">
    <link rel="stylesheet" href="<?= app_url('assets/css/style.css') ?>">
</head>
<body>
<div class="app-shell d-flex flex-column">
    <header>
        <nav class="navbar navbar-expand-lg navbar-dark bg-apPF">
            <div class="container-fluid">
                <a class="navbar-brand app-brand" href="<?= app_url('dashboard.php') ?>">
                    <img src="<?= app_url('assets/img/Allop.png') ?>" alt="<?= h(APP_NAME) ?>">
                    <img src="<?= app_url('assets/img/logo_kidstok.png') ?>" alt="Kidstok">
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainMenu">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="mainMenu">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <?php foreach (menu_items() as $grupo => $itens): ?>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle menu-main-link" href="#" role="button" data-bs-toggle="dropdown">
                                    <span class="menu-svg" aria-hidden="true"><?= menu_icon((string) $grupo) ?></span>
                                    <span><?= h($grupo) ?></span>
                                </a>
                                <ul class="dropdown-menu">
                                    <?php foreach ($itens as $item): ?>
                                        <li>
                                            <a class="dropdown-item menu-link" href="<?= app_url($item['arquivo']) ?>">
                                                <span class="menu-svg submenu-svg" aria-hidden="true"><?= menu_icon((string) $item['nome']) ?></span>
                                                <span><?= h($item['nome']) ?></span>
                                            </a>
                                        </li>
                                    <?php endforeach; ?>
                                </ul>
                            </li>
                        <?php endforeach; ?>
                        <li class="nav-item">
                            <a class="nav-link menu-main-link" href="<?= app_url('logout.php') ?>">
                                <span class="menu-svg" aria-hidden="true"><?= menu_icon('sair') ?></span>
                                <span>Sair</span>
                            </a>
                        </li>
                    </ul>
                    <?php if ($user): ?>
                        <span class="navbar-text text-white me-3"><?= h($user['nome']) ?></span>
                    <?php endif; ?>
                </div>
            </div>
        </nav>
    </header>
    <main class="app-content container-fluid flex-grow-1 py-3">
        <div id="app-alert" class="alert d-none" role="alert"></div>
        <div class="page-heading">
            <div>
                <h1 class="page-title mb-1"><?= h($titulo) ?></h1>
                <?php if ($descricao !== ''): ?>
                    <p class="page-description"><?= h($descricao) ?></p>
                <?php endif; ?>
            </div>
            <?php if ($actions): ?>
                <div class="page-actions">
                    <?php foreach ($actions as $action): ?>
                        <a class="<?= h($action['class'] ?? 'btn btn-outline-secondary') ?>" href="<?= h($action['href'] ?? '#') ?>"><?= h($action['label'] ?? '') ?></a>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
        </div>
    <?php
}

function render_footer(): void
{
    ?>
    </main>
    <footer class="border-top py-2 text-center small text-muted">
        <?= h(APP_NAME) ?> - <?= h(APP_DATE) ?>
    </footer>
</div>
<script src="<?= app_url('assets/vendor/jquery/jquery.min.js') ?>"></script>
<script src="<?= app_url('assets/vendor/bootstrap/js/bootstrap.bundle.min.js') ?>"></script>
<script src="<?= app_url('assets/vendor/select2/js/select2.min.js') ?>"></script>
<script src="<?= app_url('assets/js/app.js') ?>"></script>
</body>
</html>
    <?php
}
