<?php
/*
    Autor: Claudio Barto
    Data : 12/11/2026
*/
$aplicacao_nome = 'pre_cadastro_tributos.php';
$aplicacao_descricao = 'Carrega os padroes tributarios de Produtos para o pre-cadastro.';

function pc_tributos_padrao(PDO $pdo): array
{
    $parametros = $pdo->query('SELECT * FROM produtos_prm ORDER BY Codigo LIMIT 1')->fetch(PDO::FETCH_ASSOC);
    if (!$parametros) {
        return [];
    }

    $padroes = [];
    $dominios = [
        'cfop' => ['CFOP', 'cfops', 'CFOP'],
        'origem' => ['Origem', 'st_origem', 'Codigo'],
        'cst_icms' => ['CST_ICMS', 'st_icms', 'Codigo'],
        'cst_pis' => ['CST_PIS', 'st_pis', 'Codigo'],
        'cst_cofins' => ['CST_COFINS', 'st_cofins', 'Codigo'],
        'cst_ipi' => ['CST_IPI', 'st_ipi', 'Codigo'],
    ];
    foreach ($dominios as $campo => [$coluna, $tabela, $chave]) {
        $codigo = trim((string) ($parametros[$coluna] ?? ''));
        $descricao = '';
        if ($codigo !== '') {
            $stmt = $pdo->prepare("SELECT Descricao FROM `$tabela` WHERE `$chave` = :codigo LIMIT 1");
            $stmt->execute(['codigo' => $codigo]);
            $descricao = trim((string) $stmt->fetchColumn());
        }
        $padroes[$campo] = $codigo;
        $padroes[$campo . '_text'] = $codigo . ($descricao !== '' && $descricao !== $codigo ? ' - ' . $descricao : '');
    }
    foreach ([
        'aliquota_icms' => 'AliquotaICMS',
        'reducao_icms' => 'ReducaoBaseICMS',
        'aliquota_pis' => 'AliquotaPIS',
        'aliquota_cofins' => 'AliquotaCOFINS',
        'aliquota_ipi' => 'AliquotaIPI',
    ] as $campo => $coluna) {
        $padroes[$campo] = (float) ($parametros[$coluna] ?? 0);
    }
    return $padroes;
}

function pc_tributos_com_padrao(array $item, array $padroes): array
{
    foreach ($padroes as $campo => $valor) {
        if (substr($campo, -5) === '_text') {
            continue;
        }
        if (!isset($item[$campo]) || trim((string) $item[$campo]) === '') {
            $item[$campo] = $valor;
            if (isset($padroes[$campo . '_text'])) {
                $item[$campo . '_text'] = $padroes[$campo . '_text'];
            }
        }
    }
    return $item;
}
