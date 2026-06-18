<?php
/*
    Autor: Claudio Barto
    Data : 02/06/2026
*/
$aplicacao_nome = "empresas.php";
$aplicacao_descricao = "API para listar, inserir, editar e excluir empresas.";

require_once __DIR__ . '/../bootstrap.php';
api_require_login();

$action = (string) ($_GET['action'] ?? $_POST['action'] ?? 'list');
$data = request_data();

function only_digits_empresa(?string $value): string
{
    return preg_replace('/\D+/', '', (string) $value);
}

function valid_cnpj(string $cnpj): bool
{
    $cnpj = only_digits_empresa($cnpj);
    if (strlen($cnpj) !== 14 || preg_match('/^(\d)\1{13}$/', $cnpj)) {
        return false;
    }

    $weights = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    $sum = 0;
    for ($i = 0; $i < 12; $i++) {
        $sum += (int) $cnpj[$i] * $weights[$i];
    }
    $digit = $sum % 11 < 2 ? 0 : 11 - ($sum % 11);
    if ($digit !== (int) $cnpj[12]) {
        return false;
    }

    array_unshift($weights, 6);
    $sum = 0;
    for ($i = 0; $i < 13; $i++) {
        $sum += (int) $cnpj[$i] * $weights[$i];
    }
    $digit = $sum % 11 < 2 ? 0 : 11 - ($sum % 11);
    return $digit === (int) $cnpj[13];
}

function next_empresa_codigo(): int
{
    return (int) db()->query("SELECT COALESCE(MAX(Codigo), 0) + 1 FROM empresas")->fetchColumn();
}

function validate_empresa_payload(array $payload): void
{
    $required = [
        'EmpresaCD' => 'CD',
        'Nome' => 'Nome',
        'Fantasia' => 'Fantasia',
        'CNPJ' => 'CNPJ',
        'Status' => 'Status',
    ];

    foreach ($required as $field => $label) {
        if (trim((string) ($payload[$field] ?? '')) === '') {
            api_response(false, ['message' => "Informe $label."], 422);
        }
    }

    if (!valid_cnpj((string) $payload['CNPJ'])) {
        api_response(false, ['message' => 'Informe um CNPJ valido.'], 422);
    }

    if ($payload['CEP'] !== '' && strlen($payload['CEP']) !== 8) {
        api_response(false, ['message' => 'CEP deve conter 8 digitos.'], 422);
    }

    if ($payload['ibge'] !== '' && strlen($payload['ibge']) !== 7) {
        api_response(false, ['message' => 'Codigo IBGE deve conter 7 digitos.'], 422);
    }

    foreach (['FoneDDD', 'CelularDDD'] as $field) {
        if ($payload[$field] !== '' && strlen($payload[$field]) !== 2) {
            api_response(false, ['message' => 'DDD deve conter 2 digitos.'], 422);
        }
    }

    foreach (['FoneNro', 'CelularNro'] as $field) {
        if ($payload[$field] !== '' && !ctype_digit($payload[$field])) {
            api_response(false, ['message' => 'Telefones devem conter apenas digitos.'], 422);
        }
    }

    $ufs = ['AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'];
    if ($payload['UF'] !== '' && !in_array($payload['UF'], $ufs, true)) {
        api_response(false, ['message' => 'Selecione uma UF valida.'], 422);
    }
}

function empresa_payload(array $data): array
{
    return [
        'EmpresaCD' => (int) ($data['EmpresaCD'] ?? 0),
        'Nome' => trim((string) ($data['Nome'] ?? '')),
        'Fantasia' => trim((string) ($data['Fantasia'] ?? '')),
        'CNPJ' => only_digits_empresa($data['CNPJ'] ?? ''),
        'IE' => only_digits_empresa($data['IE'] ?? ''),
        'CEP' => only_digits_empresa($data['CEP'] ?? ''),
        'TipoEndereco' => trim((string) ($data['TipoEndereco'] ?? '')),
        'Endereco' => trim((string) ($data['Endereco'] ?? '')),
        'Numero' => trim((string) ($data['Numero'] ?? '')),
        'Complemento' => trim((string) ($data['Complemento'] ?? '')),
        'Bairro' => trim((string) ($data['Bairro'] ?? '')),
        'Cidade' => trim((string) ($data['Cidade'] ?? '')),
        'UF' => strtoupper(trim((string) ($data['UF'] ?? ''))),
        'ibge' => only_digits_empresa($data['ibge'] ?? ''),
        'FoneDDD' => only_digits_empresa($data['FoneDDD'] ?? ''),
        'FoneNro' => only_digits_empresa($data['FoneNro'] ?? ''),
        'CelularDDD' => only_digits_empresa($data['CelularDDD'] ?? ''),
        'CelularNro' => only_digits_empresa($data['CelularNro'] ?? ''),
        'Responsavel' => trim((string) ($data['Responsavel'] ?? '')),
        'Observacoes' => trim((string) ($data['Observacoes'] ?? '')),
        'CRT' => trim((string) ($data['CRT'] ?? '3')),
        'Status' => trim((string) ($data['Status'] ?? '')),
    ];
}

try {
    if ($action === 'list') {
        $term = trim((string) ($data['q'] ?? ''));
        $where = '';
        $params = [];

        if ($term !== '') {
            $termDigits = only_digits_empresa($term);
            $where = " WHERE e.Nome LIKE :q_nome OR e.Fantasia LIKE :q_fantasia OR e.CNPJ LIKE :q_cnpj OR e.Cidade LIKE :q_cidade";
            $params = [
                'q_nome' => '%' . $term . '%',
                'q_fantasia' => '%' . $term . '%',
                'q_cnpj' => $termDigits !== '' ? '%' . $termDigits . '%' : '__sem_cnpj__',
                'q_cidade' => '%' . $term . '%',
            ];
        }

        $stmt = db()->prepare(
            "SELECT e.Codigo AS id,
                    e.Codigo,
                    e.Nome,
                    e.Fantasia,
                    e.CNPJ,
                    e.Cidade,
                    e.UF,
                    e.ibge,
                    e.Status,
                    cd.NomeCD AS EmpresaCD_text
               FROM empresas e
               LEFT JOIN empresas_cd cd ON cd.Codigo = e.EmpresaCD
               $where
              ORDER BY e.Codigo DESC
              LIMIT 200"
        );
        $stmt->execute($params);
        api_response(true, ['data' => $stmt->fetchAll()]);
    }

    if ($action === 'get') {
        $id = (int) ($data['id'] ?? 0);
        $stmt = db()->prepare(
            "SELECT e.*,
                    e.Codigo AS id,
                    cd.NomeCD AS EmpresaCD_text
               FROM empresas e
               LEFT JOIN empresas_cd cd ON cd.Codigo = e.EmpresaCD
              WHERE e.Codigo = :id"
        );
        $stmt->execute(['id' => $id]);
        api_response(true, ['data' => $stmt->fetch()]);
    }

    if ($action === 'delete') {
        $id = (int) ($data['id'] ?? 0);
        $stmt = db()->prepare("DELETE FROM empresas WHERE Codigo = :id");
        $stmt->execute(['id' => $id]);
        api_response(true, ['message' => 'Registro excluido.']);
    }

    if ($action === 'save') {
        $id = (int) ($data['id'] ?? 0);
        $codigo = (int) ($data['Codigo'] ?? 0);
        $payload = empresa_payload($data);
        validate_empresa_payload($payload);

        $user = current_user();
        $payload['Usuario'] = (string) ($user['login'] ?? $user['nome'] ?? '');

        if ($id > 0) {
            $payload['Alteracao'] = date('Y-m-d');
            $payload['id'] = $id;
            $stmt = db()->prepare(
                "UPDATE empresas
                    SET EmpresaCD = :EmpresaCD,
                        Nome = :Nome,
                        Fantasia = :Fantasia,
                        CNPJ = :CNPJ,
                        IE = :IE,
                        CEP = :CEP,
                        TipoEndereco = :TipoEndereco,
                        Endereco = :Endereco,
                        Numero = :Numero,
                        Complemento = :Complemento,
                        Bairro = :Bairro,
                        Cidade = :Cidade,
                        UF = :UF,
                        ibge = :ibge,
                        FoneDDD = :FoneDDD,
                        FoneNro = :FoneNro,
                        CelularDDD = :CelularDDD,
                        CelularNro = :CelularNro,
                        Responsavel = :Responsavel,
                        Observacoes = :Observacoes,
                        CRT = :CRT,
                        Status = :Status,
                        Usuario = :Usuario,
                        Alteracao = :Alteracao
                  WHERE Codigo = :id"
            );
            $stmt->execute($payload);
            api_response(true, ['message' => 'Registro atualizado.', 'id' => $id]);
        }

        $payload['Codigo'] = $codigo > 0 ? $codigo : next_empresa_codigo();
        $payload['Inclusao'] = date('Y-m-d');
        $payload['Alteracao'] = null;
        $stmt = db()->prepare(
            "INSERT INTO empresas
                (Codigo, EmpresaCD, Nome, Fantasia, CNPJ, IE, CEP, TipoEndereco, Endereco, Numero,
                 Complemento, Bairro, Cidade, UF, ibge, FoneDDD, FoneNro, CelularDDD, CelularNro,
                 Responsavel, Observacoes, CRT, Status, Usuario, Inclusao, Alteracao)
             VALUES
                (:Codigo, :EmpresaCD, :Nome, :Fantasia, :CNPJ, :IE, :CEP, :TipoEndereco, :Endereco, :Numero,
                 :Complemento, :Bairro, :Cidade, :UF, :ibge, :FoneDDD, :FoneNro, :CelularDDD, :CelularNro,
                 :Responsavel, :Observacoes, :CRT, :Status, :Usuario, :Inclusao, :Alteracao)"
        );
        $stmt->execute($payload);
        api_response(true, ['message' => 'Registro inserido.', 'id' => $payload['Codigo']]);
    }

    api_response(false, ['message' => 'Acao invalida.'], 404);
} catch (Throwable $e) {
    api_response(false, ['message' => $e->getMessage()], 500);
}
