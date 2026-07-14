<?php
/*
    Autor: Claudio Barto
    Data : 02/07/2026
*/
$aplicacao_nome = "cp_compras_pdf.php";
$aplicacao_descricao = "Gera o PDF completo de um pedido de compra.";

require_once __DIR__ . '/../../includes/auth.php';
require_once __DIR__ . '/../../vendor/autoload.php';

use Dompdf\Dompdf;
use Dompdf\Options;

require_login();

function pdf_h($value): string
{
    $text = (string) ($value ?? '');
    if (
        $text !== ''
        && function_exists('mb_convert_encoding')
        && (strpos($text, 'Ã') !== false || strpos($text, 'Â') !== false)
    ) {
        $text = mb_convert_encoding($text, 'ISO-8859-1', 'UTF-8');
    }

    return htmlspecialchars($text, ENT_QUOTES, 'UTF-8');
}

function pdf_date($value): string
{
    $value = trim((string) ($value ?? ''));
    if ($value === '' || $value === '0000-00-00') {
        return '—';
    }

    $date = DateTime::createFromFormat('Y-m-d', substr($value, 0, 10));
    return $date ? $date->format('d/m/Y') : $value;
}

function pdf_money($value): string
{
    return 'R$ ' . number_format((float) ($value ?? 0), 2, ',', '.');
}

function pdf_number($value, int $decimals = 2): string
{
    return number_format((float) ($value ?? 0), $decimals, ',', '.');
}

function pdf_yes_no($value): string
{
    return (int) $value === 1 ? 'Sim' : 'Não';
}

function pdf_status($value): string
{
    return (int) $value === 1 ? 'Ativo' : 'Inativo';
}

$pedidoId = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$pedidoId || $pedidoId < 1) {
    http_response_code(422);
    exit('Informe um pedido válido.');
}

$stmt = db()->prepare(
    "SELECT c.*,
            c.id AS ID,
            cd.NomeCD AS cd_nome,
            e.Nome AS empresa_razao_social,
            e.Fantasia AS empresa_fantasia,
            e.CNPJ AS empresa_cnpj,
            f.NomeFornecedor AS fornecedor_nome,
            COALESCE(cst.descricao_compras, '') AS descricao_compras,
            COALESCE(cst.descricao_compras, '') AS Sts
       FROM cp_compras c
       LEFT JOIN empresas_cd cd ON cd.Codigo = c.cd_id
       LEFT JOIN empresas e ON e.Codigo = c.empresa_id
       LEFT JOIN produtos_fornecedor f ON f.Codigo = c.Fornecedor_id
       LEFT JOIN cp_compras_status cst ON cst.id = c.status_id
      WHERE c.id = :id"
);
$stmt->execute(['id' => $pedidoId]);
$pedido = $stmt->fetch();

if (!$pedido) {
    http_response_code(404);
    exit('Pedido não encontrado.');
}

$stmt = db()->prepare(
    "SELECT *, id AS ID
       FROM cp_compras_itens
      WHERE cp_compras_id = :pedido_id
      ORDER BY id"
);
$stmt->execute(['pedido_id' => $pedidoId]);
$itens = $stmt->fetchAll();

$detailStmt = db()->prepare(
    "SELECT c.*,
            c.id AS ID,
            t.tamanho,
            t.entrega,
            t.entrega_anterior,
            COALESCE(r.percentual, 0) AS percentual
       FROM cp_compras_itens_tamanhos t
       JOIN cp_compras_itens_cores c
         ON c.compras_itens_tamanho_id = t.id
       LEFT JOIN cp_compras_itens_rateios r
         ON r.compras_itens_tamanho_id = t.id
        AND r.compras_itens_cor_id = c.id
      WHERE t.compras_itens_id = :item_id
      ORDER BY t.tamanho, c.cor, c.id"
);

foreach ($itens as &$item) {
    $detailStmt->execute(['item_id' => $item['id']]);
    $item['detalhes'] = $detailStmt->fetchAll();
}
unset($item);

$empresaNome = trim((string) ($pedido['empresa_fantasia'] ?? '')) ?: (string) ($pedido['empresa_razao_social'] ?? '');
$fornecedorNome = trim((string) ($pedido['fornecedor_nome'] ?? ''));
$fornecedorTexto = trim((string) $pedido['Fornecedor_id'] . ($fornecedorNome !== '' ? ' - ' . $fornecedorNome : ''));

ob_start();
?>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <title>Pedido de Compra <?= pdf_h($pedido['ID']) ?></title>
    <style>
        @page { margin: 18mm 10mm 16mm; }
        * { box-sizing: border-box; }
        body { margin: 0; color: #263238; font-family: DejaVu Sans, sans-serif; font-size: 8px; }
        .header { width: 100%; margin-bottom: 10px; border-bottom: 2px solid #ff6500; }
        .header td { padding: 0 0 8px; vertical-align: middle; }
        .brand { width: 25%; }
        .brand-allop { color: #ff6500; font-size: 18px; font-weight: bold; letter-spacing: .5px; }
        .brand-kidstok { margin-left: 10px; color: #009ec3; font-size: 12px; font-weight: bold; }
        .title { width: 50%; text-align: center; }
        .title h1 { margin: 0; color: #5f6b75; font-size: 18px; }
        .title p { margin: 3px 0 0; color: #75808a; font-size: 9px; }
        .meta { width: 25%; text-align: right; color: #66727c; }
        .section-title {
            margin: 10px 0 5px;
            padding: 5px 7px;
            border-left: 4px solid #ff6500;
            background: #f1f3f5;
            color: #56616b;
            font-size: 10px;
            font-weight: bold;
        }
        .info-grid { width: 100%; border-collapse: collapse; }
        .info-grid td { width: 25%; padding: 4px 6px; border: 1px solid #dfe3e6; vertical-align: top; }
        .label { display: block; margin-bottom: 2px; color: #75808a; font-size: 6.5px; font-weight: bold; text-transform: uppercase; }
        .value { font-size: 8px; font-weight: bold; }
        .item { margin-top: 9px; page-break-inside: avoid; }
        .item-header { width: 100%; border-collapse: collapse; background: #fff3eb; }
        .item-header td { padding: 5px 6px; border: 1px solid #f1c9ae; vertical-align: top; }
        table.data { width: 100%; border-collapse: collapse; table-layout: fixed; }
        table.data th {
            padding: 3px 2px;
            border: 1px solid #cfd5da;
            background: #e9ecef;
            color: #495057;
            font-size: 5.7px;
            text-align: center;
            vertical-align: middle;
        }
        table.data td { padding: 3px 2px; border: 1px solid #dfe3e6; font-size: 6px; vertical-align: middle; word-wrap: break-word; }
        .numeric { text-align: right; white-space: nowrap; }
        .center { text-align: center; }
        .rateio { width: 48%; margin-top: 5px; border-collapse: collapse; }
        .rateio th, .rateio td { padding: 3px 5px; border: 1px solid #dfe3e6; }
        .rateio th { background: #f1f3f5; color: #56616b; font-size: 6.5px; }
        .rateio td { font-size: 6.5px; }
        .rateio-title { margin: 6px 0 3px; color: #56616b; font-size: 7px; font-weight: bold; }
        .empty { padding: 12px; border: 1px solid #dfe3e6; color: #75808a; text-align: center; }
        .summary { margin-top: 10px; text-align: right; font-size: 11px; font-weight: bold; }
        .summary span { display: inline-block; padding: 6px 10px; border: 1px solid #ffb080; background: #fff3eb; }
    </style>
</head>
<body>
    <table class="header">
        <tr>
            <td class="brand">
                <span class="brand-allop">ALLOP</span>
                <span class="brand-kidstok">KidStok</span>
            </td>
            <td class="title">
                <h1>Pedido de Compra #<?= pdf_h($pedido['ID']) ?></h1>
                <p>Relatório completo do pedido</p>
            </td>
            <td class="meta">
                Emitido em <?= date('d/m/Y H:i') ?><br>
                por <?= pdf_h(current_user()['nome'] ?? current_user()['login'] ?? '') ?>
            </td>
        </tr>
    </table>

    <div class="section-title">Dados do pedido</div>
    <table class="info-grid">
        <tr>
            <td><span class="label">Código</span><span class="value"><?= pdf_h($pedido['ID']) ?></span></td>
            <td><span class="label">Data do pedido</span><span class="value"><?= pdf_date($pedido['DataPedido']) ?></span></td>
            <td><span class="label">Status</span><span class="value"><?= pdf_h($pedido['descricao_compras'] ?? $pedido['Sts']) ?></span></td>
            <td><span class="label">Localização</span><span class="value"><?= pdf_h($pedido['Localizacao']) ?></span></td>
        </tr>
        <tr>
            <td><span class="label">CD</span><span class="value"><?= pdf_h($pedido['cd_id'] . ' - ' . ($pedido['cd_nome'] ?? '')) ?></span></td>
            <td colspan="2"><span class="label">Empresa</span><span class="value"><?= pdf_h($pedido['empresa_id'] . ' - ' . $empresaNome) ?></span></td>
            <td><span class="label">CNPJ</span><span class="value"><?= pdf_h($pedido['empresa_cnpj'] ?? '') ?></span></td>
        </tr>
        <tr>
            <td colspan="2"><span class="label">Fornecedor</span><span class="value"><?= pdf_h($fornecedorTexto) ?></span></td>
            <td><span class="label">Publicado</span><span class="value"><?= pdf_yes_no($pedido['Publicado']) ?></span></td>
            <td><span class="label">Possui fotos</span><span class="value"><?= pdf_yes_no($pedido['TemFotos']) ?></span></td>
        </tr>
        <tr>
            <td><span class="label">Markup Franqueadora</span><span class="value"><?= pdf_number($pedido['MarkupFranqueadora']) ?></span></td>
            <td><span class="label">Markup Franquia</span><span class="value"><?= pdf_number($pedido['MarkupFranquia']) ?></span></td>
            <td><span class="label">Markup Total</span><span class="value"><?= pdf_number($pedido['MarkupTotal']) ?></span></td>
            <td><span class="label">Valor total</span><span class="value"><?= pdf_money($pedido['ValorTotalPedido']) ?></span></td>
        </tr>
        <tr>
            <td><span class="label">Inclusão</span><span class="value"><?= pdf_date($pedido['Inclusao']) ?></span></td>
            <td><span class="label">Última alteração</span><span class="value"><?= pdf_date($pedido['Alteracao']) ?></span></td>
            <td><span class="label">Usuário</span><span class="value"><?= pdf_h($pedido['Usuario']) ?></span></td>
            <td><span class="label">Iteração</span><span class="value"><?= pdf_h($pedido['Iteracao']) ?></span></td>
        </tr>
        <tr>
            <td><span class="label">Data da aprovação</span><span class="value"><?= pdf_date($pedido['DataAprovacao']) ?></span></td>
            <td><span class="label">Usuário da aprovação</span><span class="value"><?= pdf_h($pedido['UsuarioAprovacao'] ?: '—') ?></span></td>
            <td><span class="label">Data da recusa</span><span class="value"><?= pdf_date($pedido['DataRecusa']) ?></span></td>
            <td><span class="label">Usuário da recusa</span><span class="value"><?= pdf_h($pedido['UsuarioRecusa'] ?: '—') ?></span></td>
        </tr>
        <?php if (trim((string) ($pedido['StsMotivo'] ?? '')) !== ''): ?>
            <tr>
                <td colspan="4"><span class="label">Motivo/observação</span><span class="value"><?= pdf_h($pedido['StsMotivo']) ?></span></td>
            </tr>
        <?php endif; ?>
    </table>

    <div class="section-title">Itens, tamanhos, cores e percentuais de rateio</div>
    <?php if (!$itens): ?>
        <div class="empty">Este pedido não possui itens.</div>
    <?php endif; ?>

    <?php foreach ($itens as $itemIndex => $item): ?>
        <div class="item">
            <table class="item-header">
                <tr>
                    <td style="width: 8%"><span class="label">Item</span><strong><?= $itemIndex + 1 ?></strong></td>
                    <td style="width: 13%"><span class="label">Referência</span><strong><?= pdf_h($item['referencia_fornecedor']) ?></strong></td>
                    <td style="width: 31%"><span class="label">Descrição</span><?= pdf_h($item['descricao']) ?></td>
                    <td style="width: 22%"><span class="label">Composição</span><?= pdf_h($item['composicao']) ?></td>
                    <td style="width: 8%"><span class="label">NCM</span><?= pdf_h($item['ncm']) ?></td>
                    <td style="width: 8%"><span class="label">Entrega</span><?= pdf_date($item['entrega']) ?></td>
                    <td style="width: 5%"><span class="label">Qtde.</span><?= pdf_number($item['total_qtde'], 0) ?></td>
                    <td style="width: 5%"><span class="label">Status</span><?= pdf_status($item['Sts']) ?></td>
                </tr>
                <tr>
                    <td colspan="4"><span class="label">Identificador interno do item</span><?= pdf_h($item['ID']) ?></td>
                    <td colspan="2"><span class="label">Foto KidStok</span><?= pdf_yes_no($item['Foto']) ?></td>
                    <td colspan="2"><span class="label">Total do item</span><strong><?= pdf_money($item['total_produto']) ?></strong></td>
                </tr>
            </table>

            <?php if (!empty($item['detalhes'])): ?>
                <table class="data">
                    <thead>
                        <tr>
                            <th style="width: 5%">ID</th>
                            <th style="width: 10%">SKU</th>
                            <th style="width: 6%">Tamanho</th>
                            <th style="width: 8%">Cor</th>
                            <th style="width: 5%">Status</th>
                            <th style="width: 5%">Qtde.</th>
                            <th style="width: 6%">Rateio</th>
                            <th style="width: 8%">Preço fornecedor</th>
                            <th style="width: 8%">Preço proposta</th>
                            <th style="width: 8%">Total produto</th>
                            <th style="width: 8%">Preço franqueado</th>
                            <th style="width: 6%">Markup franquia</th>
                            <th style="width: 8%">Preço loja</th>
                            <th style="width: 6%">Markup loja</th>
                            <th style="width: 5%">Markup total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($item['detalhes'] as $detail): ?>
                            <tr>
                                <td class="center"><?= pdf_h($detail['ID']) ?></td>
                                <td><?= pdf_h($detail['sku']) ?></td>
                                <td class="center"><?= pdf_h($detail['tamanho']) ?></td>
                                <td><?= pdf_h($detail['cor']) ?></td>
                                <td class="center"><?= pdf_status($detail['Sts']) ?></td>
                                <td class="numeric"><?= pdf_number($detail['Qtde'], 0) ?></td>
                                <td class="numeric"><?= pdf_number($detail['percentual']) ?>%</td>
                                <td class="numeric"><?= pdf_money($detail['preco_fornecedor']) ?></td>
                                <td class="numeric"><?= pdf_money($detail['preco_proposta']) ?></td>
                                <td class="numeric"><?= pdf_money($detail['valor_total_produto']) ?></td>
                                <td class="numeric"><?= pdf_money($detail['preco_franqueado']) ?></td>
                                <td class="numeric"><?= pdf_number($detail['markup_franquia']) ?></td>
                                <td class="numeric"><?= pdf_money($detail['preco_loja']) ?></td>
                                <td class="numeric"><?= pdf_number($detail['markup_loja']) ?></td>
                                <td class="numeric"><?= pdf_number($detail['markup_total']) ?></td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>

                <div class="rateio-title">Resumo do rateio por tamanho e cor</div>
                <table class="rateio">
                    <thead>
                        <tr>
                            <th>Tamanho</th>
                            <th>Cor</th>
                            <th>Percentual</th>
                            <th>Quantidade</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($item['detalhes'] as $detail): ?>
                            <tr>
                                <td><?= pdf_h($detail['tamanho']) ?></td>
                                <td><?= pdf_h($detail['cor']) ?></td>
                                <td class="numeric"><?= pdf_number($detail['percentual']) ?>%</td>
                                <td class="numeric"><?= pdf_number($detail['Qtde'], 0) ?></td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            <?php else: ?>
                <div class="empty">Item sem tamanhos e cores.</div>
            <?php endif; ?>
        </div>
    <?php endforeach; ?>

    <div class="summary"><span>Total do pedido: <?= pdf_money($pedido['ValorTotalPedido']) ?></span></div>
</body>
</html>
<?php
$html = ob_get_clean();

$options = new Options();
$options->set('defaultFont', 'DejaVu Sans');
$options->set('isRemoteEnabled', false);
$options->set('isHtml5ParserEnabled', true);

$dompdf = new Dompdf($options);
$dompdf->setPaper('A4', 'landscape');
$dompdf->loadHtml($html, 'UTF-8');
$dompdf->render();

$canvas = $dompdf->getCanvas();
$font = $dompdf->getFontMetrics()->getFont('DejaVu Sans', 'normal');
$canvas->page_text(
    $canvas->get_width() - 105,
    $canvas->get_height() - 24,
    'Página {PAGE_NUM} de {PAGE_COUNT}',
    $font,
    7,
    [0.4, 0.45, 0.5]
);

$dompdf->stream('pedido-' . $pedidoId . '.pdf', ['Attachment' => false]);
