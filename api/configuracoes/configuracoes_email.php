<?php
/*
    Autor: Claudio Barto
    Data : 02/06/2026
*/
$aplicacao_nome = "configuracoes_email.php";
$aplicacao_descricao = "API para listar, inserir, editar e excluir configurações de e-mail.";

require_once __DIR__ . '/../bootstrap.php';
api_require_login();

$action = (string) ($_GET['action'] ?? $_POST['action'] ?? 'list');
$data = request_data();

$columns = [
    'cd_id',
    'empresa_id',
    'NomeConta',
    'Habilitado',
    'Servidor',
    'Porta',
    'ModoAutenticado',
    'ModoSSL',
    'Email',
    'Senha',
    'Status',
];

function email_payload(array $data, array $columns): array
{
    $payload = [];
    foreach ($columns as $column) {
        if (array_key_exists($column, $data)) {
            $payload[$column] = $data[$column];
        }
    }

    if (array_key_exists('Habilitado', $payload)) {
        $payload['Habilitado'] = (int) (bool) $payload['Habilitado'];
    }

    return $payload;
}

try {
    if ($action === 'list') {
        $term = trim((string) ($data['q'] ?? ''));
        $where = '';
        $params = [];

        if ($term !== '') {
            $where = " WHERE NomeConta LIKE :q_nome OR Servidor LIKE :q_servidor OR Email LIKE :q_email OR Status LIKE :q_status";
            $params['q_nome'] = '%' . $term . '%';
            $params['q_servidor'] = '%' . $term . '%';
            $params['q_email'] = '%' . $term . '%';
            $params['q_status'] = '%' . $term . '%';
        }

        $stmt = db()->prepare(
            "SELECT Codigo AS id,
                    cd_id,
                    empresa_id,
                    NomeConta,
                    Habilitado,
                    Servidor,
                    Porta,
                    ModoAutenticado,
                    ModoSSL,
                    Email,
                    Senha,
                    Status
               FROM config_email
               $where
              ORDER BY Codigo DESC
              LIMIT 200"
        );
        $stmt->execute($params);
        api_response(true, ['data' => $stmt->fetchAll()]);
    }

    if ($action === 'get') {
        $id = (int) ($data['id'] ?? 0);
        $stmt = db()->prepare(
            "SELECT ce.Codigo AS id,
                    ce.cd_id,
                    cd.NomeCD AS cd_id_text,
                    ce.empresa_id,
                    COALESCE(NULLIF(e.Fantasia, ''), e.Nome) AS empresa_id_text,
                    ce.NomeConta,
                    ce.Habilitado,
                    ce.Servidor,
                    ce.Porta,
                    ce.ModoAutenticado,
                    ce.ModoSSL,
                    ce.Email,
                    ce.Senha,
                    ce.Status
               FROM config_email ce
               LEFT JOIN empresas_cd cd ON cd.Codigo = ce.cd_id
               LEFT JOIN empresas e ON e.Codigo = ce.empresa_id
              WHERE ce.Codigo = :id"
        );
        $stmt->execute(['id' => $id]);
        api_response(true, ['data' => $stmt->fetch()]);
    }

    if ($action === 'delete') {
        $id = (int) ($data['id'] ?? 0);
        $stmt = db()->prepare("DELETE FROM config_email WHERE Codigo = :id");
        $stmt->execute(['id' => $id]);
        api_response(true, ['message' => 'Registro excluído.']);
    }

    if ($action === 'save') {
        $id = (int) ($data['id'] ?? 0);
        $payload = email_payload($data, $columns);

        if (!$payload) {
            api_response(false, ['message' => 'Nenhum dado enviado.'], 422);
        }

        if ($id > 0) {
            $sets = implode(', ', array_map(fn ($column) => "$column = :$column", array_keys($payload)));
            $payload['id'] = $id;
            $stmt = db()->prepare("UPDATE config_email SET $sets WHERE Codigo = :id");
            $stmt->execute($payload);
            api_response(true, ['message' => 'Registro atualizado.', 'id' => $id]);
        }

        $columnsSql = implode(', ', array_keys($payload));
        $binds = implode(', ', array_map(fn ($column) => ":$column", array_keys($payload)));
        $stmt = db()->prepare("INSERT INTO config_email ($columnsSql) VALUES ($binds)");
        $stmt->execute($payload);
        api_response(true, ['message' => 'Registro inserido.', 'id' => (int) db()->lastInsertId()]);
    }

    api_response(false, ['message' => 'Ação inválida.'], 404);
} catch (Throwable $e) {
    api_response(false, ['message' => $e->getMessage()], 500);
}
