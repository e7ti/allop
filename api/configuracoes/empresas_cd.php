<?php
/*
    Autor: Claudio Barto
    Data : 02/06/2026
*/
$aplicacao_nome = "empresas_cd.php";
$aplicacao_descricao = "API para listar, inserir, editar e excluir empresas CD.";

require_once __DIR__ . '/../bootstrap.php';
api_require_login();

$action = (string) ($_GET['action'] ?? $_POST['action'] ?? 'list');
$data = request_data();

function next_empresas_cd_codigo(): int
{
    return (int) db()->query("SELECT COALESCE(MAX(Codigo), 0) + 1 FROM empresas_cd")->fetchColumn();
}

try {
    if ($action === 'list') {
        $term = trim((string) ($data['q'] ?? ''));
        $where = '';
        $params = [];

        if ($term !== '') {
            $where = " WHERE NomeCD LIKE :q_nome OR Status LIKE :q_status OR Codigo = :codigo";
            $params['q_nome'] = '%' . $term . '%';
            $params['q_status'] = '%' . $term . '%';
            $params['codigo'] = ctype_digit($term) ? (int) $term : 0;
        }

        $stmt = db()->prepare(
            "SELECT Codigo AS id,
                    Codigo,
                    NomeCD,
                    Status
               FROM empresas_cd
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
            "SELECT Codigo AS id,
                    Codigo,
                    NomeCD,
                    Status
               FROM empresas_cd
              WHERE Codigo = :id"
        );
        $stmt->execute(['id' => $id]);
        api_response(true, ['data' => $stmt->fetch()]);
    }

    if ($action === 'delete') {
        $id = (int) ($data['id'] ?? 0);
        $stmt = db()->prepare("DELETE FROM empresas_cd WHERE Codigo = :id");
        $stmt->execute(['id' => $id]);
        api_response(true, ['message' => 'Registro excluido.']);
    }

    if ($action === 'save') {
        $id = (int) ($data['id'] ?? 0);
        $codigo = (int) ($data['Codigo'] ?? 0);
        $payload = [
            'Codigo' => $codigo > 0 ? $codigo : next_empresas_cd_codigo(),
            'NomeCD' => trim((string) ($data['NomeCD'] ?? '')),
            'Status' => trim((string) ($data['Status'] ?? '')),
        ];

        if ($payload['NomeCD'] === '' || $payload['Status'] === '') {
            api_response(false, ['message' => 'Informe nome do CD e status.'], 422);
        }

        if ($id > 0) {
            $stmt = db()->prepare(
                "UPDATE empresas_cd
                    SET NomeCD = :NomeCD,
                        Status = :Status
                  WHERE Codigo = :Codigo"
            );
            $stmt->execute([
                'Codigo' => $id,
                'NomeCD' => $payload['NomeCD'],
                'Status' => $payload['Status'],
            ]);
            api_response(true, ['message' => 'Registro atualizado.', 'id' => $id]);
        }

        $stmt = db()->prepare(
            "INSERT INTO empresas_cd (Codigo, NomeCD, Status)
             VALUES (:Codigo, :NomeCD, :Status)"
        );
        $stmt->execute($payload);
        api_response(true, ['message' => 'Registro inserido.', 'id' => $payload['Codigo']]);
    }

    api_response(false, ['message' => 'Acao invalida.'], 404);
} catch (Throwable $e) {
    api_response(false, ['message' => $e->getMessage()], 500);
}
