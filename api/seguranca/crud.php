<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "crud.php";
$aplicacao_descricao = "API CRUD genérica para o módulo de segurança.";



require_once __DIR__ . '/../bootstrap.php';
api_require_login();

$entities = [
    'usuarios' => [
        'table' => 'seg_usuarios',
        'columns' => ['nome', 'login', 'senha', 'perfil_id', 'ativo', 'chequesapp'],
        'search' => ['nome', 'login'],
    ],
    'perfis' => [
        'table' => 'seg_perfil',
        'columns' => ['nome'],
        'search' => ['nome'],
    ],
    'aplicacoes' => [
        'table' => 'seg_aplicacoes',
        'columns' => ['nome', 'rota', 'menu_id', 'ordem'],
        'search' => ['nome', 'rota'],
    ],
    'perfil_aplicacoes' => [
        'table' => 'seg_perfil_permissoes',
        'columns' => [
            'perfil_id', 'aplicacao_id', 'visualizar', 'inserir', 'editar', 'excluir',
            'imprimir', 'exportar', 'processar'
        ],
        'search' => [],
    ],
    'usuarios_permissoes' => [
        'table' => 'seg_usuarios_permissoes',
        'columns' => [
            'usuario_id', 'aplicacao_id', 'visualizar', 'inserir', 'edtiar', 'excluir',
            'imprirmir', 'exportar', 'processar'
        ],
        'search' => [],
    ],
    'cp_compras_emails' => [
        'table' => 'cp_compras_emails',
        'columns' => ['config_email_id', 'Nome', 'email', 'status'],
        'search' => ['Nome', 'email'],
    ],
    'cp_depara_cor' => [
        'table' => 'cp_depara_cor',
        'columns' => ['cor_fornecedor', 'codigo_ks'],
        'search' => ['cor_fornecedor'],
    ],
    'menus' => [
        'table' => 'seg_menu',
        'columns' => ['menu'],
        'search' => ['menu'],
    ],
];

$entityName = (string) ($_GET['entity'] ?? $_POST['entity'] ?? '');
$action = (string) ($_GET['action'] ?? $_POST['action'] ?? 'list');

if (!isset($entities[$entityName])) {
    api_response(false, ['message' => 'Entidade inválida.'], 404);
}

$entity = $entities[$entityName];
$table = $entity['table'];
$data = request_data();

function next_table_id(string $table): int
{
    return (int) db()->query("SELECT COALESCE(MAX(id), 0) + 1 FROM $table")->fetchColumn();
}

try {
    if ($action === 'list') {
        if ($entityName === 'perfil_aplicacoes') {
            $term = trim((string) ($data['q'] ?? ''));
            $where = '';
            $params = [];
            if ($term !== '') {
                $where = " WHERE p.nome LIKE :q_perfil OR a.nome LIKE :q_aplicacao";
                $params['q_perfil'] = '%' . $term . '%';
                $params['q_aplicacao'] = '%' . $term . '%';
            }

            $sql = "SELECT pp.id,
                           pp.perfil_id,
                           p.nome AS perfil_nome,
                           pp.aplicacao_id,
                           a.nome AS aplicacao_nome,
                           pp.visualizar,
                           pp.inserir,
                           pp.editar,
                           pp.excluir,
                           pp.imprimir,
                           pp.exportar,
                           pp.processar
                      FROM seg_perfil_permissoes pp
                      LEFT JOIN seg_perfil p ON p.id = pp.perfil_id
                      LEFT JOIN seg_aplicacoes a ON a.id = pp.aplicacao_id
                     $where
                     ORDER BY p.nome, a.ordem, a.nome
                     LIMIT 300";
            $stmt = db()->prepare($sql);
            $stmt->execute($params);
            api_response(true, ['data' => $stmt->fetchAll()]);
        }

        if ($entityName === 'usuarios_permissoes') {
            $term = trim((string) ($data['q'] ?? ''));
            $where = '';
            $params = [];
            if ($term !== '') {
                $where = " WHERE u.nome LIKE :q_usuario OR u.login LIKE :q_login OR a.nome LIKE :q_aplicacao";
                $params['q_usuario'] = '%' . $term . '%';
                $params['q_login'] = '%' . $term . '%';
                $params['q_aplicacao'] = '%' . $term . '%';
            }

            $sql = "SELECT up.id,
                           up.usuario_id,
                           u.nome AS usuario_nome,
                           up.aplicacao_id,
                           a.nome AS aplicacao_nome,
                           up.visualizar,
                           up.inserir,
                           up.edtiar,
                           up.excluir,
                           up.imprirmir,
                           up.exportar,
                           up.processar
                      FROM seg_usuarios_permissoes up
                      LEFT JOIN seg_usuarios u ON u.id = up.usuario_id
                      LEFT JOIN seg_aplicacoes a ON a.id = up.aplicacao_id
                     $where
                     ORDER BY u.nome, a.ordem, a.nome
                     LIMIT 300";
            $stmt = db()->prepare($sql);
            $stmt->execute($params);
            api_response(true, ['data' => $stmt->fetchAll()]);
        }

        if ($entityName === 'cp_compras_emails') {
            $term = trim((string) ($data['q'] ?? ''));
            $where = '';
            $params = [];
            if ($term !== '') {
                $where = " WHERE cpe.Nome LIKE :q_nome OR cpe.email LIKE :q_email OR ce.NomeConta LIKE :q_conta OR ce.Email LIKE :q_conta_email";
                $params['q_nome'] = '%' . $term . '%';
                $params['q_email'] = '%' . $term . '%';
                $params['q_conta'] = '%' . $term . '%';
                $params['q_conta_email'] = '%' . $term . '%';
            }

            $stmt = db()->prepare(
                "SELECT cpe.id,
                        cpe.config_email_id,
                        COALESCE(NULLIF(ce.NomeConta, ''), ce.Email) AS config_email_id_text,
                        cpe.Nome,
                        cpe.email,
                        cpe.status,
                        CASE WHEN cpe.status = 1 THEN 'Ativo' ELSE 'Inativo' END AS status_text
                   FROM cp_compras_emails cpe
                   LEFT JOIN config_email ce ON ce.Codigo = cpe.config_email_id
                   $where
                  ORDER BY cpe.id DESC
                  LIMIT 200"
            );
            $stmt->execute($params);
            api_response(true, ['data' => $stmt->fetchAll()]);
        }

        if ($entityName === 'cp_depara_cor') {
            $term = trim((string) ($data['q'] ?? ''));
            $where = '';
            $params = [];
            if ($term !== '') {
                $where = " WHERE d.cor_fornecedor LIKE :q_cor_fornecedor OR pc.Codigo LIKE :q_codigo OR pc.Nome LIKE :q_nome";
                $params['q_cor_fornecedor'] = '%' . $term . '%';
                $params['q_codigo'] = '%' . $term . '%';
                $params['q_nome'] = '%' . $term . '%';
            }

            $stmt = db()->prepare(
                "SELECT d.cor_fornecedor AS id,
                        d.cor_fornecedor,
                        d.codigo_ks,
                        CONCAT(d.codigo_ks, ' - ', COALESCE(pc.Nome, '')) AS codigo_ks_text
                   FROM cp_depara_cor d
                   LEFT JOIN produtos_cor pc ON pc.Codigo = d.codigo_ks
                   $where
                  ORDER BY d.cor_fornecedor
                  LIMIT 300"
            );
            $stmt->execute($params);
            api_response(true, ['data' => $stmt->fetchAll()]);
        }

        $term = trim((string) ($data['q'] ?? ''));
        $params = [];
        $where = '';
        if ($term !== '' && $entity['search']) {
            $parts = [];
            foreach ($entity['search'] as $index => $column) {
                $param = 'q_' . $index;
                $parts[] = "$column LIKE :$param";
                $params[$param] = '%' . $term . '%';
            }
            $where = ' WHERE ' . implode(' OR ', $parts);
        }
        $order = $entityName === 'aplicacoes' ? ' ORDER BY menu_id, ordem, nome' : ' ORDER BY id DESC';
        $stmt = db()->prepare("SELECT * FROM $table$where$order LIMIT 200");
        $stmt->execute($params);
        api_response(true, ['data' => $stmt->fetchAll()]);
    }

    if ($action === 'get') {
        $id = (int) ($data['id'] ?? 0);
        if ($entityName === 'perfil_aplicacoes') {
            $stmt = db()->prepare(
                "SELECT pp.*,
                        p.nome AS perfil_id_text,
                        a.nome AS aplicacao_id_text
                   FROM seg_perfil_permissoes pp
                   LEFT JOIN seg_perfil p ON p.id = pp.perfil_id
                   LEFT JOIN seg_aplicacoes a ON a.id = pp.aplicacao_id
                  WHERE pp.id = :id"
            );
            $stmt->execute(['id' => $id]);
            api_response(true, ['data' => $stmt->fetch()]);
        }

        if ($entityName === 'usuarios_permissoes') {
            $stmt = db()->prepare(
                "SELECT up.*,
                        u.nome AS usuario_id_text,
                        a.nome AS aplicacao_id_text
                   FROM seg_usuarios_permissoes up
                   LEFT JOIN seg_usuarios u ON u.id = up.usuario_id
                   LEFT JOIN seg_aplicacoes a ON a.id = up.aplicacao_id
                  WHERE up.id = :id"
            );
            $stmt->execute(['id' => $id]);
            api_response(true, ['data' => $stmt->fetch()]);
        }

        if ($entityName === 'usuarios') {
            $stmt = db()->prepare(
                "SELECT u.*,
                        p.nome AS perfil_id_text
                   FROM seg_usuarios u
                   LEFT JOIN seg_perfil p ON p.id = u.perfil_id
                  WHERE u.id = :id"
            );
            $stmt->execute(['id' => $id]);
            api_response(true, ['data' => $stmt->fetch()]);
        }

        if ($entityName === 'cp_compras_emails') {
            $stmt = db()->prepare(
                "SELECT cpe.*,
                        COALESCE(NULLIF(ce.NomeConta, ''), ce.Email) AS config_email_id_text
                   FROM cp_compras_emails cpe
                   LEFT JOIN config_email ce ON ce.Codigo = cpe.config_email_id
                  WHERE cpe.id = :id"
            );
            $stmt->execute(['id' => $id]);
            api_response(true, ['data' => $stmt->fetch()]);
        }

        if ($entityName === 'cp_depara_cor') {
            $stmt = db()->prepare(
                "SELECT d.cor_fornecedor AS id,
                        d.cor_fornecedor,
                        d.codigo_ks,
                        CONCAT(d.codigo_ks, ' - ', COALESCE(pc.Nome, '')) AS codigo_ks_text
                   FROM cp_depara_cor d
                   LEFT JOIN produtos_cor pc ON pc.Codigo = d.codigo_ks
                  WHERE d.cor_fornecedor = :id"
            );
            $stmt->execute(['id' => (string) ($data['id'] ?? '')]);
            api_response(true, ['data' => $stmt->fetch()]);
        }

        $stmt = db()->prepare("SELECT * FROM $table WHERE id = :id");
        $stmt->execute(['id' => $id]);
        api_response(true, ['data' => $stmt->fetch()]);
    }

    if ($action === 'delete') {
        if ($entityName === 'cp_depara_cor') {
            $stmt = db()->prepare("DELETE FROM cp_depara_cor WHERE cor_fornecedor = :id");
            $stmt->execute(['id' => (string) ($data['id'] ?? '')]);
            api_response(true, ['message' => 'Registro excluÃ­do.']);
        }

        $id = (int) ($data['id'] ?? 0);
        $stmt = db()->prepare("DELETE FROM $table WHERE id = :id");
        $stmt->execute(['id' => $id]);
        api_response(true, ['message' => 'Registro excluído.']);
    }

    if ($action === 'save') {
        if ($entityName === 'cp_depara_cor') {
            $id = trim((string) ($data['id'] ?? ''));
            $corFornecedor = trim((string) ($data['cor_fornecedor'] ?? ''));
            $codigoKs = trim((string) ($data['codigo_ks'] ?? ''));

            if ($corFornecedor === '' || $codigoKs === '') {
                api_response(false, ['message' => 'Informe a cor do fornecedor e a cor KidStok.'], 422);
            }

            if ($id !== '') {
                $stmt = db()->prepare(
                    "UPDATE cp_depara_cor
                        SET cor_fornecedor = :cor_fornecedor,
                            codigo_ks = :codigo_ks
                      WHERE cor_fornecedor = :id"
                );
                $stmt->execute([
                    'cor_fornecedor' => $corFornecedor,
                    'codigo_ks' => $codigoKs,
                    'id' => $id,
                ]);
                api_response(true, ['message' => 'Registro atualizado.', 'id' => $corFornecedor]);
            }

            $stmt = db()->prepare(
                "INSERT INTO cp_depara_cor (cor_fornecedor, codigo_ks)
                 VALUES (:cor_fornecedor, :codigo_ks)"
            );
            $stmt->execute([
                'cor_fornecedor' => $corFornecedor,
                'codigo_ks' => $codigoKs,
            ]);
            api_response(true, ['message' => 'Registro inserido.', 'id' => $corFornecedor]);
        }

        $id = (int) ($data['id'] ?? 0);
        $payload = [];
        foreach ($entity['columns'] as $column) {
            if (array_key_exists($column, $data)) {
                $payload[$column] = $data[$column];
            }
        }

        foreach ($payload as $column => $value) {
            if (in_array($column, ['visualizar', 'inserir', 'editar', 'edtiar', 'excluir', 'imprimir', 'imprirmir', 'exportar', 'processar', 'ativo', 'chequesapp', 'status'], true)) {
                $payload[$column] = (int) (bool) $value;
            }
        }

        if ($entityName === 'usuarios') {
            if (!empty($payload['senha'])) {
                $payload['senha'] = password_hash((string) $payload['senha'], PASSWORD_DEFAULT);
            } elseif ($id > 0) {
                unset($payload['senha']);
            }
        }

        if (!$payload) {
            api_response(false, ['message' => 'Nenhum dado enviado.'], 422);
        }

        if ($entityName === 'perfil_aplicacoes') {
            if (empty($payload['perfil_id']) || empty($payload['aplicacao_id'])) {
                api_response(false, ['message' => 'Informe perfil e aplicação.'], 422);
            }

            if ($id < 1) {
                $stmt = db()->prepare(
                    "SELECT id
                       FROM seg_perfil_permissoes
                      WHERE perfil_id = :perfil_id
                        AND aplicacao_id = :aplicacao_id
                      LIMIT 1"
                );
                $stmt->execute([
                    'perfil_id' => (int) $payload['perfil_id'],
                    'aplicacao_id' => (int) $payload['aplicacao_id'],
                ]);
                $id = (int) ($stmt->fetchColumn() ?: 0);
            }
        }

        if ($entityName === 'usuarios_permissoes') {
            if (empty($payload['usuario_id']) || empty($payload['aplicacao_id'])) {
                api_response(false, ['message' => 'Informe usuário e aplicação.'], 422);
            }

            if ($id < 1) {
                $stmt = db()->prepare(
                    "SELECT id
                       FROM seg_usuarios_permissoes
                      WHERE usuario_id = :usuario_id
                        AND aplicacao_id = :aplicacao_id
                      LIMIT 1"
                );
                $stmt->execute([
                    'usuario_id' => (int) $payload['usuario_id'],
                    'aplicacao_id' => (int) $payload['aplicacao_id'],
                ]);
                $id = (int) ($stmt->fetchColumn() ?: 0);
            }
        }

        if ($id > 0) {
            $sets = implode(', ', array_map(fn ($column) => "$column = :$column", array_keys($payload)));
            $payload['id'] = $id;
            $stmt = db()->prepare("UPDATE $table SET $sets WHERE id = :id");
            $stmt->execute($payload);
            api_response(true, ['message' => 'Registro atualizado.', 'id' => $id]);
        }

        if ($entityName === 'menus') {
            $payload = ['id' => next_table_id($table)] + $payload;
        }
        $columns = implode(', ', array_keys($payload));
        $binds = implode(', ', array_map(fn ($column) => ":$column", array_keys($payload)));
        $stmt = db()->prepare("INSERT INTO $table ($columns) VALUES ($binds)");
        $stmt->execute($payload);
        api_response(true, ['message' => 'Registro inserido.', 'id' => (int) ($payload['id'] ?? db()->lastInsertId())]);
    }

    api_response(false, ['message' => 'Ação inválida.'], 404);
} catch (Throwable $e) {
    api_response(false, ['message' => $e->getMessage()], 500);
}

