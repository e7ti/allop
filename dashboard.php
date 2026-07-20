<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "dashboard.php";
$aplicacao_descricao = "Dashboard responsivo do sistema.";

require_once __DIR__ . '/includes/layout.php';
require_login();

function dashboard_compra_stats(): array
{
    $empty = [
        'total' => 0,
        'abertos' => 0,
        'aprovados' => 0,
        'aprovados_sem_fotos' => 0,
        'recusados' => 0,
        'valor_total' => 0.0,
        'valor_abertos' => 0.0,
        'valor_aprovados' => 0.0,
        'valor_aprovados_sem_fotos' => 0.0,
        'valor_recusados' => 0.0,
    ];

    try {
        // IDs fixos do catalogo cp_compras_status:
        // 0-Aberto, 1-Aprovado Aguardando Foto Fornecedor,
        // 2-Aprovado, 3-Recusado.
        $stmt = db()->query(
            "SELECT
                    COUNT(*) AS total,
                    SUM(CASE WHEN c.status_id = 0 THEN 1 ELSE 0 END) AS abertos,
                    SUM(CASE WHEN c.status_id = 2 THEN 1 ELSE 0 END) AS aprovados,
                    SUM(CASE WHEN c.status_id = 1 THEN 1 ELSE 0 END) AS aprovados_sem_fotos,
                    SUM(CASE WHEN c.status_id = 3 THEN 1 ELSE 0 END) AS recusados,
                    COALESCE(SUM(c.ValorTotalPedido), 0) AS valor_total,
                    COALESCE(SUM(CASE WHEN c.status_id = 0 THEN c.ValorTotalPedido ELSE 0 END), 0) AS valor_abertos,
                    COALESCE(SUM(CASE WHEN c.status_id = 2 THEN c.ValorTotalPedido ELSE 0 END), 0) AS valor_aprovados,
                    COALESCE(SUM(CASE WHEN c.status_id = 1 THEN c.ValorTotalPedido ELSE 0 END), 0) AS valor_aprovados_sem_fotos,
                    COALESCE(SUM(CASE WHEN c.status_id = 3 THEN c.ValorTotalPedido ELSE 0 END), 0) AS valor_recusados
               FROM cp_compras c"
        );
        $row = $stmt->fetch() ?: [];
    } catch (Throwable $e) {
        return $empty;
    }

    return [
        'total' => (int) ($row['total'] ?? 0),
        'abertos' => (int) ($row['abertos'] ?? 0),
        'aprovados' => (int) ($row['aprovados'] ?? 0),
        'aprovados_sem_fotos' => (int) ($row['aprovados_sem_fotos'] ?? 0),
        'recusados' => (int) ($row['recusados'] ?? 0),
        'valor_total' => (float) ($row['valor_total'] ?? 0),
        'valor_abertos' => (float) ($row['valor_abertos'] ?? 0),
        'valor_aprovados' => (float) ($row['valor_aprovados'] ?? 0),
        'valor_aprovados_sem_fotos' => (float) ($row['valor_aprovados_sem_fotos'] ?? 0),
        'valor_recusados' => (float) ($row['valor_recusados'] ?? 0),
    ];
}

function dashboard_status_labels(): array
{
    // Mesmos textos padrão semeados por cp_status_catalog_seed() em api/compras/cp_compras.php.
    $labels = [
        0 => 'Aberto',
        1 => 'Aprovado Aguardando Foto Fornecedor',
        2 => 'Aprovado',
        3 => 'Recusado',
    ];

    try {
        $stmt = db()->query(
            "SELECT id, descricao_compras FROM cp_compras_status WHERE id IN (0, 1, 2, 3)"
        );
        foreach ($stmt->fetchAll() as $row) {
            $descricao = trim((string) ($row['descricao_compras'] ?? ''));
            if ($descricao !== '') {
                $labels[(int) $row['id']] = $descricao;
            }
        }
    } catch (Throwable $e) {
        // Mantém os textos padrão quando a tabela ainda não existir.
    }

    return $labels;
}

function dashboard_percent(int $value, int $total): float
{
    if ($total <= 0) {
        return 0.0;
    }

    return round(($value / $total) * 100, 2);
}

function dashboard_ultimos_pedidos(): array
{
    try {
        $stmt = db()->query(
            "SELECT c.id,
                    c.id AS ID,
                    c.DataPedido,
                    c.ValorTotalPedido,
                    c.status_id,
                    COALESCE(cst.descricao_compras, '') AS descricao_compras,
                    COALESCE(cst.descricao_compras, '') AS Sts,
                    c.Localizacao,
                    c.Publicado,
                    cd.NomeCD AS cd_nome,
                    COALESCE(NULLIF(e.Fantasia, ''), e.Nome) AS empresa_nome,
                    COALESCE(NULLIF(f.NomeFornecedor, ''), c.Fornecedor_id) AS fornecedor_nome
               FROM cp_compras c
               LEFT JOIN empresas_cd cd ON cd.Codigo = c.cd_id
               LEFT JOIN empresas e ON e.Codigo = c.empresa_id
               LEFT JOIN produtos_fornecedor f ON f.Codigo = c.Fornecedor_id
               LEFT JOIN cp_compras_status cst ON cst.id = c.status_id
              ORDER BY c.id DESC
              LIMIT 10"
        );

        return $stmt->fetchAll();
    } catch (Throwable $e) {
        return [];
    }
}

function dashboard_date_br($value): string
{
    $value = trim((string) ($value ?? ''));
    if ($value === '' || $value === '0000-00-00') {
        return '';
    }

    $date = DateTime::createFromFormat('Y-m-d', substr($value, 0, 10));
    return $date ? $date->format('d/m/Y') : $value;
}

function dashboard_status_badge($status, $localizacao = ''): string
{
    $status = trim((string) ($status ?? ''));
    $label = $status !== '' ? $status : 'Aberto';
    $normalized = strtolower($label);

    if (
        strpos($normalized, 'aprovado aguardando foto fornecedor') === 0 ||
        strpos($normalized, 'aprovado aguardando foto') === 0 ||
        strpos($normalized, 'aprovado sem fotos') === 0
    ) {
        $class = 'badge-status-awaiting-photo';
    } elseif (strpos($normalized, 'aprovado') === 0) {
        $class = 'badge-status-approved';
    } elseif ($normalized === 'recusado') {
        $class = 'badge-status-rejected';
    } else {
        $class = 'badge-status-open';
    }

    return '<span class="badge dashboard-grid-badge ' . h($class) . '">' . h($label) . '</span>';
}

function dashboard_localizacao_badge($localizacao): string
{
    $localizacao = trim((string) ($localizacao ?? 'KidStok'));
    $value = $localizacao !== '' ? $localizacao : 'KidStok';

    if (strcasecmp($value, 'KidStok') === 0) {
        $class = 'badge-localizacao-kidstok';
        $label = 'KidStok';
    } elseif (strcasecmp($value, 'Fornecedor') === 0) {
        $class = 'badge-localizacao-fornecedor';
        $label = 'Fornecedor';
    } else {
        $class = 'badge-localizacao-allop';
        $label = $value;
    }

    return '<span class="badge cp-localizacao-badge ' . h($class) . '">' . h($label) . '</span>';
}

function dashboard_publicado_badge($publicado): string
{
    $published = (int) ($publicado ?? 0) === 1;
    $class = $published ? 'dashboard-publicado-sim' : 'dashboard-publicado-nao';
    $label = $published ? 'Publicado' : 'Não Publicado';

    return '<span class="badge dashboard-grid-badge ' . h($class) . '">' . h($label) . '</span>';
}

function dashboard_pedido_editavel(array $pedido): bool
{
    if (strcasecmp((string) ($pedido['Localizacao'] ?? ''), 'Fornecedor') === 0) {
        return false;
    }

    return (int) ($pedido['status_id'] ?? 0) === 0;
}

$stats = dashboard_compra_stats();
$statusLabels = dashboard_status_labels();
$ultimosPedidos = dashboard_ultimos_pedidos();
$chartKnownTotal = $stats['abertos'] + $stats['aprovados'] + $stats['aprovados_sem_fotos'] + $stats['recusados'];
$chartTotal = max(1, $chartKnownTotal);
$abertosPct = dashboard_percent($stats['abertos'], $chartTotal);
$aprovadosPct = dashboard_percent($stats['aprovados'], $chartTotal);
$aprovadosSemFotosPct = dashboard_percent($stats['aprovados_sem_fotos'], $chartTotal);
$recusadosPct = dashboard_percent($stats['recusados'], $chartTotal);
$aprovadosStart = $abertosPct;
$aprovadosSemFotosStart = $abertosPct + $aprovadosPct;
$recusadosStart = $aprovadosSemFotosStart + $aprovadosSemFotosPct;
$donutStyle = sprintf(
    '--abertos:%s%%; --aprovados:%s%%; --aprovados-sem-fotos:%s%%; --recusados:%s%%; --aprovados-start:%s%%; --aprovados-sem-fotos-start:%s%%; --recusados-start:%s%%;',
    number_format($abertosPct, 2, '.', ''),
    number_format($aprovadosPct, 2, '.', ''),
    number_format($aprovadosSemFotosPct, 2, '.', ''),
    number_format($recusadosPct, 2, '.', ''),
    number_format($aprovadosStart, 2, '.', ''),
    number_format($aprovadosSemFotosStart, 2, '.', ''),
    number_format($recusadosStart, 2, '.', '')
);
$donutClass = $chartKnownTotal > 0 ? '' : ' dashboard-donut-empty';

$cards = [
    [
        'titulo' => $statusLabels[0],
        'valor' => $stats['abertos'],
        'valor_pedidos' => $stats['valor_abertos'],
        'texto' => 'Aguardando andamento',
        'classe' => 'dashboard-status-open',
    ],
    [
        'titulo' => $statusLabels[2],
        'valor' => $stats['aprovados'],
        'valor_pedidos' => $stats['valor_aprovados'],
        'texto' => 'Aprovados no fluxo',
        'classe' => 'dashboard-status-approved',
    ],
    [
        'titulo' => $statusLabels[1],
        'valor' => $stats['aprovados_sem_fotos'],
        'valor_pedidos' => $stats['valor_aprovados_sem_fotos'],
        'texto' => 'Aprovado aguardando foto fornecedor',
        'classe' => 'dashboard-status-awaiting-photo',
    ],
    [
        'titulo' => $statusLabels[3],
        'valor' => $stats['recusados'],
        'valor_pedidos' => $stats['valor_recusados'],
        'texto' => 'Recusados no fluxo',
        'classe' => 'dashboard-status-rejected',
    ],
    [
        'titulo' => 'Total de pedidos',
        'valor' => $stats['total'],
        'valor_pedidos' => $stats['valor_total'],
        'texto' => 'Pedidos cadastrados',
        'classe' => 'dashboard-status-total',
    ],
];

render_header('Dashboard');
?>
<div class="dashboard-compras">
    <div class="d-flex flex-wrap gap-2 justify-content-between align-items-center mb-3">
        <div>
            <span class="page-kicker">Compras</span>
            <h2 class="dashboard-section-title mb-0">Pedidos de Compra</h2>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-orange btn-sync" title="Sincronizar dashboard" href="<?= app_url('dashboard.php') ?>">Sincronizar</a>
            <a class="btn btn-orange btn-new" href="<?= app_url('mod/compras/cp_compras_lista.php') ?>">Ver pedidos</a>
        </div>
    </div>

    <div class="row g-3 mb-3">
        <?php foreach ($cards as $card): ?>
            <div class="col-12 col-md-6 col-xl">
                <section class="card card-slim dashboard-tile dashboard-compra-tile h-100 <?= h($card['classe']) ?>">
                    <div class="card-body">
                        <span class="page-kicker">Pedidos</span>
                        <h2><?= h($card['titulo']) ?></h2>
                        <div>
                            <span class="tile-total"><?= h(number_format((int) $card['valor'], 0, ',', '.')) ?></span>
                            <span class="tile-caption"><?= h($card['texto']) ?></span>
                        </div>
                        <div class="tile-value">R$ <?= h(number_format((float) $card['valor_pedidos'], 2, ',', '.')) ?></div>
                    </div>
                </section>
            </div>
        <?php endforeach; ?>
    </div>

    <div class="row g-3">
        <div class="col-12 col-xl-8">
            <section class="card card-slim dashboard-chart-card h-100">
                <div class="card-header"><strong>Gráfico de pedidos por status</strong></div>
                <div class="card-body">
                    <div class="dashboard-status-bars">
                        <div class="dashboard-status-row" style="grid-template-columns: 150px 360px 220px; justify-content: start;">
                            <div class="dashboard-status-label" style="white-space: nowrap;">
                                <span style="display: block;">Abertos</span>
                            </div>
                            <div class="dashboard-status-track" style="width: 360px;">
                                <span class="dashboard-status-bar dashboard-status-open" style="width: <?= h((string) $abertosPct) ?>%"></span>
                            </div>
                            <div class="dashboard-status-value"><strong><?= h($stats['abertos']) ?></strong><span>R$ <?= h(number_format($stats['valor_abertos'], 2, ',', '.')) ?></span></div>
                        </div>
                        <div class="dashboard-status-row" style="grid-template-columns: 150px 360px 220px; justify-content: start;">
                            <div class="dashboard-status-label" style="white-space: nowrap;">
                                <span style="display: block;">Aprovados</span>
                            </div>
                            <div class="dashboard-status-track" style="width: 360px;">
                                <span class="dashboard-status-bar dashboard-status-approved" style="width: <?= h((string) $aprovadosPct) ?>%"></span>
                            </div>
                            <div class="dashboard-status-value"><strong><?= h($stats['aprovados']) ?></strong><span>R$ <?= h(number_format($stats['valor_aprovados'], 2, ',', '.')) ?></span></div>
                        </div>
                        <div class="dashboard-status-row" style="grid-template-columns: 150px 360px 220px; justify-content: start;">
                            <div class="dashboard-status-label" style="white-space: nowrap;">
                                <span style="display: block;">Aguardando Foto</span>
                            </div>
                            <div class="dashboard-status-track" style="width: 360px;">
                                <span class="dashboard-status-bar dashboard-status-awaiting-photo" style="width: <?= h((string) $aprovadosSemFotosPct) ?>%"></span>
                            </div>
                            <div class="dashboard-status-value"><strong><?= h($stats['aprovados_sem_fotos']) ?></strong><span>R$ <?= h(number_format($stats['valor_aprovados_sem_fotos'], 2, ',', '.')) ?></span></div>
                        </div>
                        <div class="dashboard-status-row" style="grid-template-columns: 150px 360px 220px; justify-content: start;">
                            <div class="dashboard-status-label" style="white-space: nowrap;">
                                <span style="display: block;">Recusados</span>
                            </div>
                            <div class="dashboard-status-track" style="width: 360px;">
                                <span class="dashboard-status-bar dashboard-status-rejected" style="width: <?= h((string) $recusadosPct) ?>%"></span>
                            </div>
                            <div class="dashboard-status-value"><strong><?= h($stats['recusados']) ?></strong><span>R$ <?= h(number_format($stats['valor_recusados'], 2, ',', '.')) ?></span></div>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <div class="col-12 col-xl-4">
            <section class="card card-slim dashboard-chart-card h-100">
                <div class="card-header"><strong>Resumo financeiro</strong></div>
                <div class="card-body dashboard-donut-wrap">
                    <div class="dashboard-donut<?= h($donutClass) ?>" style="<?= h($donutStyle) ?>">
                        <div>
                            <span><?= h(number_format($stats['total'], 0, ',', '.')) ?></span>
                            <small>pedidos</small>
                        </div>
                    </div>
                    <div class="dashboard-donut-legend">
                        <span><i class="dashboard-status-open"></i>Abertos</span>
                        <span><i class="dashboard-status-approved"></i>Aprovados</span>
                        <span><i class="dashboard-status-awaiting-photo"></i>Aguardando Foto</span>
                        <span><i class="dashboard-status-rejected"></i>Recusados</span>
                    </div>
                    <div class="dashboard-total-value">
                        <span class="page-kicker">Valor total</span>
                        <strong>R$ <?= h(number_format($stats['valor_total'], 2, ',', '.')) ?></strong>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <section class="card card-slim grid-shell dashboard-latest-orders mt-3">
        <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
            <strong>Últimos 10 pedidos</strong>
            <span class="text-muted small">Ordenado por número do pedido decrescente</span>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Pedido</th>
                            <th>Data</th>
                            <th>CD</th>
                            <th>Empresa</th>
                            <th>Fornecedor</th>
                            <th>Status</th>
                            <th>Localização</th>
                            <th>Publicado</th>
                            <th class="text-end">Valor</th>
                            <th class="text-end">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (!$ultimosPedidos): ?>
                            <tr><td colspan="10" class="text-center text-muted">Nenhum pedido encontrado.</td></tr>
                        <?php endif; ?>
                        <?php foreach ($ultimosPedidos as $pedido): ?>
                            <?php
                            $pedidoEditavel = dashboard_pedido_editavel($pedido);
                            $acaoClasse = $pedidoEditavel ? 'btn-edit' : 'btn-view';
                            $acaoTitulo = $pedidoEditavel ? 'Editar pedido' : 'Visualizar pedido';
                            ?>
                            <tr>
                                <td data-label="Pedido"><?= h((string) ($pedido['ID'] ?? '')) ?></td>
                                <td data-label="Data"><?= h(dashboard_date_br($pedido['DataPedido'] ?? '')) ?></td>
                                <td data-label="CD"><?= h((string) ($pedido['cd_nome'] ?? '')) ?></td>
                                <td data-label="Empresa"><?= h((string) ($pedido['empresa_nome'] ?? '')) ?></td>
                                <td data-label="Fornecedor"><?= h((string) ($pedido['fornecedor_nome'] ?? '')) ?></td>
                                <td data-label="Status"><?= dashboard_status_badge($pedido['descricao_compras'] ?? $pedido['Sts'] ?? '', $pedido['Localizacao'] ?? '') ?></td>
                                <td data-label="Localização"><?= dashboard_localizacao_badge($pedido['Localizacao'] ?? '') ?></td>
                                <td data-label="Publicado"><?= dashboard_publicado_badge($pedido['Publicado'] ?? 0) ?></td>
                                <td data-label="Valor" class="text-end">R$ <?= h(number_format((float) ($pedido['ValorTotalPedido'] ?? 0), 2, ',', '.')) ?></td>
                                <td data-label="Ações" class="text-end">
                                    <a class="btn btn-sm btn-outline-secondary <?= h($acaoClasse) ?> btn-icon-only" title="<?= h($acaoTitulo) ?>" aria-label="<?= h($acaoTitulo) ?>" href="<?= app_url('mod/compras/cp_compras_form.php?id=' . (int) ($pedido['id'] ?? 0)) ?>"></a>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
</div>
<?php render_footer(); ?>
