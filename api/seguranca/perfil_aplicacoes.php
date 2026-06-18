<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "perfil_aplicacoes.php";
$aplicacao_descricao = "API para manutencao em lote das permissoes por perfil.";



require_once __DIR__ . '/../bootstrap.php';
api_require_login();

$data = request_data();
$action = (string) ($_GET['action'] ?? $data['action'] ?? 'list');

try {
    if ($action === 'profiles') {
        $perfilId = (int) ($_GET['perfil_id'] ?? $data['perfil_id'] ?? 0);
        $term = trim((string) ($_GET['q'] ?? $data['q'] ?? ''));
        $where = '';
        $params = [];

        if ($perfilId > 0) {
            $where = ' WHERE p.id = :perfil_id';
            $params['perfil_id'] = $perfilId;
        } elseif ($term !== '') {
            $where = ' WHERE p.nome LIKE :q';
            $params['q'] = '%' . $term . '%';
        }

        $stmt = db()->prepare(
            "SELECT p.id AS perfil_id,
                    p.nome AS perfil_nome,
                    COUNT(pp.id) AS total_permissoes
               FROM seg_perfil p
               LEFT JOIN seg_perfil_permissoes pp ON pp.perfil_id = p.id
              $where
              GROUP BY p.id, p.nome
              ORDER BY p.nome"
        );
        $stmt->execute($params);

        api_response(true, ['data' => $stmt->fetchAll()]);
    }

    if ($action === 'list') {
        $perfilId = (int) ($_GET['perfil_id'] ?? $data['perfil_id'] ?? 0);
        if ($perfilId < 1) {
            api_response(false, ['message' => 'Informe o perfil.'], 422);
        }

        $stmt = db()->prepare(
            "SELECT a.id AS aplicacao_id,
                    a.nome AS aplicacao_nome,
                    a.rota,
                    a.ordem,
                    m.menu,
                    COALESCE(pp.visualizar, 0) AS visualizar,
                    COALESCE(pp.inserir, 0) AS inserir,
                    COALESCE(pp.editar, 0) AS editar,
                    COALESCE(pp.excluir, 0) AS excluir,
                    COALESCE(pp.imprimir, 0) AS imprimir,
                    COALESCE(pp.exportar, 0) AS exportar,
                    COALESCE(pp.processar, 0) AS processar
               FROM seg_aplicacoes a
               LEFT JOIN seg_menu m ON m.id = a.menu_id
               LEFT JOIN seg_perfil_permissoes pp
                      ON pp.aplicacao_id = a.id
                     AND pp.perfil_id = :perfil_id
              ORDER BY m.menu, a.ordem, a.nome"
        );
        $stmt->execute(['perfil_id' => $perfilId]);

        api_response(true, ['data' => $stmt->fetchAll()]);
    }

    if ($action === 'delete_profile') {
        $perfilId = (int) ($data['perfil_id'] ?? $_GET['perfil_id'] ?? 0);
        if ($perfilId < 1) {
            api_response(false, ['message' => 'Informe o perfil.'], 422);
        }

        $stmt = db()->prepare("DELETE FROM seg_perfil_permissoes WHERE perfil_id = :perfil_id");
        $stmt->execute(['perfil_id' => $perfilId]);
        api_response(true, ['message' => 'Permissoes excluidas com sucesso.']);
    }

    if ($action === 'save') {
        $perfilId = (int) ($data['perfil_id'] ?? 0);
        $permissions = json_decode((string) ($data['permissions'] ?? '[]'), true);

        if ($perfilId < 1) {
            api_response(false, ['message' => 'Informe o perfil.'], 422);
        }

        if (!is_array($permissions)) {
            api_response(false, ['message' => 'Permissoes invalidas.'], 422);
        }

        db()->beginTransaction();

        $find = db()->prepare(
            "SELECT id
               FROM seg_perfil_permissoes
              WHERE perfil_id = :perfil_id
                AND aplicacao_id = :aplicacao_id
              LIMIT 1"
        );
        $insert = db()->prepare(
            "INSERT INTO seg_perfil_permissoes
                (aplicacao_id, perfil_id, visualizar, inserir, editar, excluir, imprimir, exportar, processar)
             VALUES
                (:aplicacao_id, :perfil_id, :visualizar, :inserir, :editar, :excluir, :imprimir, :exportar, :processar)"
        );
        $update = db()->prepare(
            "UPDATE seg_perfil_permissoes
                SET visualizar = :visualizar,
                    inserir = :inserir,
                    editar = :editar,
                    excluir = :excluir,
                    imprimir = :imprimir,
                    exportar = :exportar,
                    processar = :processar
              WHERE id = :id"
        );

        foreach ($permissions as $row) {
            $aplicacaoId = (int) ($row['aplicacao_id'] ?? 0);
            if ($aplicacaoId < 1) {
                continue;
            }

            $payload = [
                'aplicacao_id' => $aplicacaoId,
                'perfil_id' => $perfilId,
                'visualizar' => (int) !empty($row['visualizar']),
                'inserir' => (int) !empty($row['inserir']),
                'editar' => (int) !empty($row['editar']),
                'excluir' => (int) !empty($row['excluir']),
                'imprimir' => (int) !empty($row['imprimir']),
                'exportar' => (int) !empty($row['exportar']),
                'processar' => (int) !empty($row['processar']),
            ];

            $find->execute(['perfil_id' => $perfilId, 'aplicacao_id' => $aplicacaoId]);
            $id = (int) ($find->fetchColumn() ?: 0);

            if ($id > 0) {
                $updatePayload = $payload;
                unset($updatePayload['aplicacao_id'], $updatePayload['perfil_id']);
                $updatePayload['id'] = $id;
                $update->execute($updatePayload);
            } else {
                $insert->execute($payload);
            }
        }

        db()->commit();
        api_response(true, ['message' => 'Permissoes atualizadas com sucesso.']);
    }

    api_response(false, ['message' => 'Acao invalida.'], 404);
} catch (Throwable $e) {
    if (db()->inTransaction()) {
        db()->rollBack();
    }
    api_response(false, ['message' => $e->getMessage()], 500);
}
