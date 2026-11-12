<?php
/*
    Autor: Claudio Barto
    Data : 30/10/2026
*/
$aplicacao_nome = 'produtos_workflow.php';
$aplicacao_descricao = 'Regras de produtos convertidas dos eventos e bibliotecas do Scriptcase.';

final class ProdutosWorkflow
{
    private PDO $pdo;
    private string $usuario;
    private array $schemas;

    public function __construct(PDO $pdo, string $usuario)
    {
        $this->pdo = $pdo;
        $this->usuario = mb_substr($usuario, 0, 30, 'UTF-8');
        $this->schemas = json_decode(file_get_contents(__DIR__ . '/../config/produtos_schema.json'), true, 512, JSON_THROW_ON_ERROR);
    }

    private function query(string $sql, array $params = []): PDOStatement
    {
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        return $stmt;
    }

    private function lock(): string
    {
        return $this->pdo->getAttribute(PDO::ATTR_DRIVER_NAME) === 'mysql' ? ' FOR UPDATE' : '';
    }

    public function row(string $table, string $key, string $id, bool $lock = false): ?array
    {
        if (!isset($this->schemas[$table]['fields'][$key])) {
            throw new InvalidArgumentException('Cadastro inválido.');
        }
        return $this->query("SELECT * FROM `$table` WHERE `$key` = ?" . ($lock ? $this->lock() : ''), [$id])->fetch() ?: null;
    }

    private function write(string $table, array $values, string $key, ?string $id = null): string
    {
        $values = array_intersect_key($values, $this->schemas[$table]['fields']);
        if ($id !== null) {
            unset($values[$key]);
            $set = implode(', ', array_map(static fn($f) => "`$f` = ?", array_keys($values)));
            $this->query("UPDATE `$table` SET $set WHERE `$key` = ?", [...array_values($values), $id]);
            return $id;
        }
        $fields = implode(', ', array_map(static fn($f) => "`$f`", array_keys($values)));
        $marks = implode(', ', array_fill(0, count($values), '?'));
        $this->query("INSERT INTO `$table` ($fields) VALUES ($marks)", array_values($values));
        return isset($values[$key]) ? (string) $values[$key] : $this->pdo->lastInsertId();
    }

    public function defaults(): array
    {
        return $this->query('SELECT * FROM produtos_prm ORDER BY Codigo LIMIT 1')->fetch() ?: [];
    }

    private function active(string $table, string $key, string $id): void
    {
        $row = $this->row($table, $key, $id);
        if (!$row || (isset($row['Status']) && $row['Status'] !== 'Ativo') || (isset($row['Sts']) && $row['Sts'] !== 'Ativo')) {
            throw new InvalidArgumentException('Cadastro inexistente ou inativo: ' . $id . '.');
        }
    }

    public function saveProduct(array $input, ?string $id): array
    {
        $old = $id === null ? null : $this->row('produtos_cab', 'Referencia', $id, true);
        if ($id !== null && !$old) {
            throw new InvalidArgumentException('Produto não encontrado.');
        }
        $defaults = $this->defaults();
        $values = $old ?? [];
        foreach ($this->schemas['produtos_cab']['fields'] as $field => $definition) {
            $values[$field] ??= $definition['default'];
        }
        foreach (['CFOP', 'Origem', 'CST_ICMS', 'AliquotaICMS', 'CST_PIS', 'AliquotaPIS', 'CST_COFINS', 'AliquotaCOFINS', 'CST_IPI', 'AliquotaIPI'] as $field) {
            if ($old === null && isset($defaults[$field])) {
                $values[$field] = $defaults[$field];
            }
        }
        if ($old === null) {
            $values['ReducaoICMS'] = $defaults['ReducaoBaseICMS'] ?? 0;
        }
        foreach (produtos_campos_form(produtos_config('produtos')) as $field => $_) {
            if (array_key_exists($field, $input)) {
                $values[$field] = $input[$field];
            }
        }
        foreach (['Cor', 'Tamanho'] as $field) {
            $parts = is_array($values[$field] ?? null) ? $values[$field] : explode(';', (string) ($values[$field] ?? ''));
            $parts = array_values(array_unique(array_filter(array_map(static fn($v) => is_scalar($v) ? trim((string) $v) : '', $parts), static fn($v) => $v !== '')));
            if (count($parts) > 150) {
                throw new InvalidArgumentException('Selecione até 150 opções por tamanho ou cor.');
            }
            foreach ($parts as $part) {
                if (strlen($part) !== 2) {
                    throw new InvalidArgumentException('Código de tamanho ou cor inválido.');
                }
                $this->active($field === 'Cor' ? 'produtos_cor' : 'produtos_tamanho', 'Codigo', $part);
            }
            $values[$field] = implode(';', $parts);
        }
        if (($values['Cor'] === '') !== ($values['Tamanho'] === '') || ($old === null && $values['Cor'] === '')) {
            throw new InvalidArgumentException('Selecione tamanhos e cores para gerar a grade.');
        }
        foreach (['Fornecedor' => 2, 'Categoria' => 2, 'CodFornecedorR3' => 4] as $field => $length) {
            $values[$field] = trim((string) ($values[$field] ?? ''));
            if (strlen($values[$field]) !== $length || !preg_match('/^[A-Za-z0-9]+$/D', $values[$field])) {
                throw new InvalidArgumentException(produtos_label($field) . ": informe $length caracteres alfanuméricos.");
            }
        }
        $reference = $values['Fornecedor'] . $values['Categoria'] . $values['CodFornecedorR3'];
        if ($old && $reference !== $id) {
            throw new InvalidArgumentException('Fornecedor, categoria R2 e R3 não podem alterar a referência existente.');
        }
        $values['Referencia'] = $reference;
        $values['DescricaoComplementar'] ??= '';
        if (trim((string) ($values['Descricao'] ?? '')) === '') {
            $genero = $this->row('produtos_generos', 'Codigo', (string) $values['Genero']);
            $composicao = $this->row('produtos_composicoes', 'Codigo', (string) $values['Composicao']);
            $caracteristica = $this->row('produtos_caracteristicas', 'Codigo', (string) $values['Caracteristica']);
            $values['Descricao'] = mb_substr(trim(implode(' ', [$values['GrupoCategoria'], $genero['Abreviado'] ?? '', $composicao['Composicao'] ?? '', $caracteristica['Caracteristica'] ?? ''])), 0, 50, 'UTF-8');
        }
        if (($defaults['UpperCase'] ?? 'N') === 'S') {
            $values['Descricao'] = mb_strtoupper($values['Descricao'], 'UTF-8');
            $values['DescricaoComplementar'] = mb_strtoupper($values['DescricaoComplementar'], 'UTF-8');
        }
        $values['Consolidado'] = 'N';
        $values['Foto'] = $old['Foto'] ?? 0;
        $config = produtos_config('produtos');
        // Derivados e auditoria são controlados pelo servidor.
        $values = produtos_validar($config, $values, false);
        $values['Consolidado'] = 'N';
        $values['Foto'] = $old['Foto'] ?? 0;
        if ($old) {
            $values['Inclusao'] = $old['Inclusao'];
        }
        $this->validateProductRelations($values);
        $this->validatePrices($values);
        $this->write('produtos_cab', $values, 'Referencia', $id);
        $skipped = [];
        $created = 0;
        $colors = $values['Cor'] === '' ? [] : explode(';', $values['Cor']);
        $sizes = $values['Tamanho'] === '' ? [] : explode(';', $values['Tamanho']);
        if (count($colors) * count($sizes) > 3000) {
            throw new InvalidArgumentException('A grade excede 3000 combinações.');
        }
        foreach ($sizes as $size) {
            foreach ($colors as $color) {
                $full = $reference . $size . $color;
                if ($this->row('produtos_cab_grade', 'Distribuidora', $full)) {
                    continue;
                }
                if ($this->query('SELECT 1 FROM produtos_referencias_prod WHERE Referencia = ? LIMIT 1', [$full])->fetchColumn()) {
                    $skipped[] = $full;
                    continue;
                }
                $grade = $values;
                $grade['Distribuidora'] = $full;
                $grade['Tamanho'] = $size;
                $grade['Cor'] = $color;
                $grade['GTIN'] = '';
                $grade['CodigoAlternativo'] = '';
                $grade['LocalFisico'] = null;
                $this->write('produtos_cab_grade', $grade, 'Distribuidora');
                $created++;
            }
        }
        // O legado mantém as grades anteriores e seus valores, mesmo ao mudar a seleção de tamanhos/cores.
        if ($old) {
            $propagate = array_intersect_key($values, array_flip(['Linha', 'Colecao', 'GrupoCategoria', 'Composicao', 'Caracteristica', 'Descricao', 'DescricaoComplementar', 'Unidade', 'CodFornecedor', 'NCM', 'CST_ICMS', 'Origem', 'AliquotaICMS', 'ReducaoICMS', 'CST_PIS', 'AliquotaPIS', 'CST_COFINS', 'AliquotaCOFINS', 'CST_IPI', 'AliquotaIPI', 'CFOP', 'Peso', 'Alteracao', 'Usuario', 'Consolidado', 'CFOP_ProducaoProria']));
            // Atualiza o grupo junto com a categoria para manter a chave estrangeira composta válida.
            $propagate['Grupo'] = $values['Grupo'];
            foreach ($this->query('SELECT Distribuidora FROM produtos_cab_grade WHERE Referencia = ?' . $this->lock(), [$reference])->fetchAll() as $grade) {
                $this->write('produtos_cab_grade', $propagate, 'Distribuidora', $grade['Distribuidora']);
            }
        }
        return ['id' => $reference, 'created' => $created, 'skipped' => $skipped];
    }

    private function validateProductRelations(array $values): void
    {
        $group = $this->query("SELECT 1 FROM produtos_grupos WHERE Grupo = ? AND SubGrupo = ? AND Status = 'Ativo'", [$values['Grupo'], $values['GrupoCategoria']])->fetchColumn();
        if (!$group) {
            throw new InvalidArgumentException('Grupo não está relacionado à categoria selecionada.');
        }
        foreach (produtos_config('produtos')['relations'] as $field => $relation) {
            if (in_array($field, ['Cor', 'Tamanho', 'Grupo', 'GrupoCategoria'], true) || ($values[$field] ?? '') === '') {
                continue;
            }
            $this->active($relation['table'], $relation['key'], (string) $values[$field]);
        }
    }

    private function validatePrices(array $values): void
    {
        if ((float) $values['PrecoCompraTabela'] > (float) $values['PrecoVendaTabela']) {
            throw new InvalidArgumentException('Atacado deve ser menor ou igual ao varejo.');
        }
        if ((float) $values['PrecoCompra'] > (float) $values['PrecoCompraTabela']) {
            throw new InvalidArgumentException('Compra deve ser menor ou igual ao atacado.');
        }
    }

    public function saveGrade(string $entity, string $id, array $input): array
    {
        $row = $this->row('produtos_cab_grade', 'Distribuidora', $id, true);
        if (!$row) {
            throw new InvalidArgumentException('Referência não encontrada.');
        }
        $config = produtos_config($entity);
        $values = produtos_validar($config, $input, true);
        $next = array_replace($row, $values);
        if ($entity === 'valores') {
            if ($next['PrecoCheio'] === 'S') {
                $values['PrecoCompraTabela'] = $next['PrecoVendaTabela'];
            }
            $this->validatePrices(array_replace($next, $values));
        } elseif ($next['CodigoAlternativo'] !== '') {
            $alternative = $this->query('SELECT * FROM produtos WHERE Distribuidora = ?', [$next['CodigoAlternativo']])->fetch();
            if (!$alternative || $next['CodigoAlternativo'] === $id || $alternative['Tamanho'] !== $row['Tamanho'] || $alternative['Cor'] !== $row['Cor']) {
                throw new InvalidArgumentException('O código alternativo deve ser outra referência consolidada com o mesmo tamanho e cor.');
            }
            if (!$this->query('SELECT 1 FROM produtos WHERE Distribuidora = ?', [$id])->fetchColumn()) {
                throw new InvalidArgumentException('Consolide a referência antes de informar um código alternativo.');
            }
        }
        $values['Consolidado'] = 'N';
        $values['Usuario'] = $this->usuario;
        $values['Alteracao'] = date('Y-m-d H:i:s');
        $this->write('produtos_cab_grade', $values, 'Distribuidora', $id);
        $this->write('produtos_cab', ['Consolidado' => 'N', 'Alteracao' => date('Y-m-d H:i:s'), 'Usuario' => $this->usuario], 'Referencia', $row['Referencia']);
        return ['id' => $id];
    }

    public function bulkGrade(string $entity, array $ids, string $field, $value): array
    {
        if (!in_array($entity, ['valores', 'outras_informacoes'], true)
            || !in_array($field, produtos_config($entity)['form_fields'], true) || $field === 'Distribuidora'
            || !$ids || count($ids) > 200 || count($ids) !== count(array_unique($ids))) {
            throw new InvalidArgumentException('Seleção ou campo inválido para alteração em lote.');
        }
        foreach ($ids as $id) {
            if (!is_string($id)) {
                throw new InvalidArgumentException('Seleção inválida.');
            }
            $row = $this->row('produtos_cab_grade', 'Distribuidora', $id, true);
            if (!$row) {
                throw new InvalidArgumentException('Referência não encontrada: ' . $id);
            }
            $row[$field] = $value;
            if ($entity === 'valores' && $field === 'PrecoVendaTabela') {
                $defaults = $this->defaults();
                if ($row['PrecoCheio'] === 'S' || ($defaults['PrecoAtacadoMetadeVarejo'] ?? 'N') === 'S') {
                    $row['PrecoCompraTabela'] = $this->number($value, 'Varejo') / ($row['PrecoCheio'] === 'S' ? 1 : 2);
                }
            }
            $this->saveGrade($entity, $id, $row);
        }
        return ['processed' => count($ids)];
    }

    public function deleteProduct(string $id): void
    {
        if (!$this->row('produtos_cab', 'Referencia', $id, true)) {
            throw new InvalidArgumentException('Produto não encontrado.');
        }
        if ($this->query('SELECT 1 FROM produtos WHERE Distribuidora LIKE ? LIMIT 1', [$id . '%'])->fetchColumn()) {
            // Mesmo comportamento do botão excluir da grade pendente: mantém as referências consolidadas.
            $this->query('DELETE FROM produtos_cab_grade WHERE Referencia = ? AND Distribuidora NOT IN (SELECT Distribuidora FROM produtos WHERE Distribuidora LIKE ?)', [$id, $id . '%']);
            return;
        }
        $this->query('DELETE FROM produtos_cab_grade WHERE Referencia = ?', [$id]);
        $this->query('DELETE FROM produtos_cab WHERE Referencia = ?', [$id]);
    }

    public function consolidate(string $id): array
    {
        if (!$this->row('produtos_cab', 'Referencia', $id, true)) {
            throw new InvalidArgumentException('Produto não encontrado.');
        }
        $grades = $this->query("SELECT * FROM produtos_cab_grade WHERE Referencia = ? AND Consolidado = 'N' ORDER BY Distribuidora" . $this->lock(), [$id])->fetchAll();
        if (!$grades && !$this->query('SELECT 1 FROM produtos_cab_grade WHERE Referencia = ? LIMIT 1', [$id])->fetchColumn()) {
            throw new InvalidArgumentException('Não há grade para consolidar.');
        }
        $count = 0;
        foreach ($grades as $grade) {
            $old = $this->query('SELECT * FROM produtos WHERE Distribuidora = ?' . $this->lock(), [$grade['Distribuidora']])->fetch();
            $values = array_intersect_key($grade, $this->schemas['produtos']['fields']);
            unset($values['Codigo']);
            if (!$old) {
                $max = $this->query('SELECT MAX(Codigo) FROM produtos')->fetchColumn();
                $code = str_pad((string) ((int) ($max ?: 115000) + 1), 8, '0', STR_PAD_LEFT);
                if (strlen($code) !== 8) {
                    throw new InvalidArgumentException('Faixa de códigos de produtos esgotada.');
                }
                $values['Codigo'] = $code;
                $values['GTIN'] = str_pad($code, 14, '0', STR_PAD_LEFT);
                $values['Fashion'] = 'N';
                if ($grade['CodigoAlternativo'] !== '') {
                    $values['Status'] = 'Inativo';
                }
                $this->write('produtos', $values, 'Codigo');
                $this->query('INSERT INTO produtos_barras (Codigo, CodigoBarra) VALUES (?, ?)', [$code, $grade['CodigoAlternativo'] ?: $code]);
            } else {
                $code = $old['Codigo'];
                // O legado mantém o GTIN do produto consolidado nas atualizações.
                unset($values['GTIN']);
                $this->write('produtos', $values, 'Codigo', $code);
                if ($grade['CodigoAlternativo'] !== '') {
                    $this->query('DELETE FROM produtos_barras WHERE Codigo = ?', [$code]);
                    $this->query('INSERT INTO produtos_barras (Codigo, CodigoBarra) VALUES (?, ?)', [$code, $grade['CodigoAlternativo']]);
                    $this->query("UPDATE produtos SET Status = 'Inativo' WHERE Distribuidora = ?", [$grade['CodigoAlternativo']]);
                    $this->query("UPDATE produtos_cab_grade SET Status = 'Inativo' WHERE Distribuidora = ?", [$grade['CodigoAlternativo']]);
                }
            }
            $this->priceLog($code, $grade['Distribuidora'], $old ?: [], array_replace($old ?: [], $values));
            $this->query("UPDATE produtos_cab_grade SET Consolidado = 'S' WHERE Distribuidora = ?", [$grade['Distribuidora']]);
            $count++;
        }
        $this->query("UPDATE produtos_cab SET Consolidado = 'S' WHERE Referencia = ? AND NOT EXISTS
            (SELECT 1 FROM produtos_cab_grade WHERE Referencia = ? AND Consolidado = 'N')", [$id, $id]);
        return ['processed' => $count];
    }

    public function saveBatch(array $input, ?string $id): array
    {
        $old = $id === null ? null : $this->row('produtos_precos_cab', 'ID', $id, true);
        if ($id !== null && (!$old || (int) $old['Atualizado'] !== 0)) {
            throw new InvalidArgumentException('Somente lotes ainda não aplicados podem ser editados.');
        }
        $values = produtos_validar(produtos_config('precos_lote'), $input, $id !== null);
        if ($values['DataVoltaAtualizacao'] !== null && $values['DataVoltaAtualizacao'] <= $values['DataAtualizacao']) {
            throw new InvalidArgumentException('A data de retorno deve ser posterior à data de aplicação.');
        }
        if (!$old) {
            // O histórico preserva o ID; ele não pode ser reutilizado depois de um arquivamento.
            $values['ID'] = (int) $this->query('SELECT MAX(ID) FROM (SELECT ID FROM produtos_precos_cab UNION ALL SELECT ID FROM produtos_precos_cab_h) ids')->fetchColumn() + 1;
            $values['Atualizado'] = 0;
            $values['QtdeItens'] = 0;
        }
        return ['id' => $this->write('produtos_precos_cab', $values, 'ID', $id)];
    }

    public function batchItem(string $id, array $input, bool $delete = false): array
    {
        $batch = $this->row('produtos_precos_cab', 'ID', $id, true);
        if (!$batch || (int) $batch['Atualizado'] !== 0) {
            throw new InvalidArgumentException('O lote não existe ou já foi aplicado.');
        }
        $itemId = trim((string) ($input['item_id'] ?? ''));
        if ($delete) {
            $this->query('DELETE FROM produtos_precos_itens WHERE IDCab = ? AND IDItens = ?', [$id, $itemId]);
        } else {
            $reference = trim((string) ($input['referencia'] ?? ''));
            if (!preg_match('/^[A-Za-z0-9]{8}(?:[A-Za-z0-9]{4})?$/D', $reference)) {
                throw new InvalidArgumentException('Informe a referência master ou completa.');
            }
            $retail = $this->number($input['varejo'] ?? '', 'Varejo');
            $wholesale = ($input['atacado'] ?? '') === '' ? null : $this->number($input['atacado'], 'Atacado');
            $rows = $this->query('SELECT * FROM produtos WHERE Distribuidora LIKE ? ORDER BY Distribuidora' . $this->lock(), [strlen($reference) === 8 ? $reference . '%' : $reference])->fetchAll();
            if (!$rows) {
                throw new InvalidArgumentException('Não há produtos consolidados para essa referência.');
            }
            if ($itemId !== '' && count($rows) !== 1) {
                throw new InvalidArgumentException('Edite uma referência completa por vez.');
            }
            $defaults = $this->defaults();
            foreach ($rows as $row) {
                $newWholesale = $wholesale;
                if ($row['PrecoCheio'] === 'S') {
                    $newWholesale = $retail;
                } elseif ($newWholesale === null && ($defaults['PrecoAtacadoMetadeVarejo'] ?? 'N') === 'S') {
                    $newWholesale = $retail / 2;
                }
                if ($newWholesale === null || $newWholesale > $retail) {
                    throw new InvalidArgumentException('Informe atacado menor ou igual ao varejo.');
                }
                $existing = $this->query('SELECT IDItens FROM produtos_precos_itens WHERE IDCab = ? AND Produto = ?', [$id, $row['Codigo']])->fetchColumn();
                if ($existing !== false && $itemId === '') {
                    throw new InvalidArgumentException('O produto ' . $row['Distribuidora'] . ' já está neste lote.');
                }
                if ($itemId !== '' && ($existing === false || (string) $existing !== $itemId)) {
                    throw new InvalidArgumentException('Item não pertence ao lote ou à referência selecionada.');
                }
                $values = ['IDCab' => $id, 'ReferenciaMaster' => substr($row['Distribuidora'], 0, 8), 'Produto' => $row['Codigo'], 'Referencia' => $row['Distribuidora'], 'Descricao' => $row['Descricao'], 'PrecoAtacadoAtual' => $row['PrecoCompraTabela'], 'PrecoVarejoAtual' => $row['PrecoVendaTabela'], 'PrecoAtacadoNovo' => $newWholesale, 'PrecoVarejoNovo' => $retail];
                if ($itemId === '') {
                    $values['Sequencia'] = (int) $this->query('SELECT COALESCE(MAX(Sequencia), 0) + 1 FROM produtos_precos_itens WHERE IDCab = ?', [$id])->fetchColumn();
                }
                $this->write('produtos_precos_itens', $values, 'IDItens', $itemId === '' ? null : $itemId);
            }
        }
        $count = (int) $this->query('SELECT COUNT(*) FROM produtos_precos_itens WHERE IDCab = ?', [$id])->fetchColumn();
        $this->write('produtos_precos_cab', ['QtdeItens' => $count, 'Usuario' => $this->usuario, 'Alteracao' => date('Y-m-d')], 'ID', $id);
        return ['items' => $count];
    }

    public function applyBatch(string $id, bool $restore = false): array
    {
        $batch = $this->row('produtos_precos_cab', 'ID', $id, true);
        if (!$batch || (int) $batch['Atualizado'] !== ($restore ? 1 : 0)) {
            throw new InvalidArgumentException('O lote não está disponível para esta operação.');
        }
        $today = date('Y-m-d');
        if (!$restore && $batch['DataAtualizacao'] > $today) {
            throw new InvalidArgumentException('A data de aplicação do lote ainda não chegou.');
        }
        $items = $this->query('SELECT * FROM produtos_precos_itens WHERE IDCab = ? ORDER BY Sequencia, IDItens' . $this->lock(), [$id])->fetchAll();
        if (!$items) {
            throw new InvalidArgumentException('Inclua itens no lote antes de aplicar.');
        }
        foreach ($items as $item) {
            $product = $this->row('produtos', 'Codigo', $item['Produto'], true);
            if (!$product || $product['Distribuidora'] !== $item['Referencia']) {
                throw new InvalidArgumentException('Produto do lote não encontrado: ' . $item['Referencia']);
            }
            if (!$restore) {
                // A foto dos preços para retorno deve refletir o momento da aplicação, não o da digitação.
                $this->write('produtos_precos_itens', ['PrecoAtacadoAtual' => $product['PrecoCompraTabela'], 'PrecoVarejoAtual' => $product['PrecoVendaTabela']], 'IDItens', $item['IDItens']);
            } elseif ((float) $product['PrecoCompraTabela'] !== (float) $item['PrecoAtacadoNovo'] || (float) $product['PrecoVendaTabela'] !== (float) $item['PrecoVarejoNovo']) {
                throw new InvalidArgumentException('O preço de ' . $item['Referencia'] . ' mudou após este lote. Revise o conflito antes de restaurar.');
            }
            $changes = ['PrecoCompraTabela' => $item[$restore ? 'PrecoAtacadoAtual' : 'PrecoAtacadoNovo'], 'PrecoVendaTabela' => $item[$restore ? 'PrecoVarejoAtual' : 'PrecoVarejoNovo'], 'Usuario' => $this->usuario, 'Alteracao' => date('Y-m-d H:i:s')];
            $this->write('produtos', $changes, 'Codigo', $item['Produto']);
            if ($this->row('produtos_cab_grade', 'Distribuidora', $item['Referencia'])) {
                $this->write('produtos_cab_grade', $changes, 'Distribuidora', $item['Referencia']);
            }
            $this->priceLog($item['Produto'], $item['Referencia'], $product, array_replace($product, $changes));
        }
        $state = $restore || !$batch['DataVoltaAtualizacao'] ? 9 : 1;
        $this->write('produtos_precos_cab', ['Atualizado' => $state, 'Usuario' => $this->usuario, 'Alteracao' => $today], 'ID', $id);
        $this->archiveBatch($id);
        return ['processed' => count($items), 'state' => $state];
    }

    private function archiveBatch(string $id): void
    {
        $batch = $this->row('produtos_precos_cab', 'ID', $id);
        $exists = $this->row('produtos_precos_cab_h', 'ID', $id);
        $this->write('produtos_precos_cab_h', $batch, 'ID', $exists ? $id : null);
        $this->query('DELETE FROM produtos_precos_itens_h WHERE IDCab = ?', [$id]);
        foreach ($this->query('SELECT * FROM produtos_precos_itens WHERE IDCab = ?', [$id])->fetchAll() as $item) {
            $this->write('produtos_precos_itens_h', $item, 'IDItens');
        }
    }

    public function deleteBatch(string $id): void
    {
        $batch = $this->row('produtos_precos_cab', 'ID', $id, true);
        if (!$batch || (int) $batch['Atualizado'] !== 0) {
            throw new InvalidArgumentException('Somente lotes não aplicados podem ser excluídos.');
        }
        $this->query('DELETE FROM produtos_precos_itens WHERE IDCab = ?', [$id]);
        $this->query('DELETE FROM produtos_precos_cab WHERE ID = ?', [$id]);
    }

    public function orderSizes(array $ids): array
    {
        if (!$ids || count($ids) !== count(array_unique($ids))) {
            throw new InvalidArgumentException('Ordem de tamanhos inválida.');
        }
        $existing = $this->query('SELECT Codigo FROM produtos_tamanho ORDER BY Codigo' . $this->lock())->fetchAll(PDO::FETCH_COLUMN);
        $sorted = $ids;
        sort($sorted);
        sort($existing);
        if ($sorted !== $existing) {
            throw new InvalidArgumentException('A lista de tamanhos mudou. Recarregue a tela antes de ordenar.');
        }
        foreach ($ids as $order => $code) {
            $old = $this->row('produtos_tamanho_ordem', 'Codigo', $code);
            $this->write('produtos_tamanho_ordem', ['Codigo' => $code, 'Ordem' => $order], 'Codigo', $old ? $code : null);
        }
        return ['processed' => count($ids)];
    }

    public function photo(string $reference, ?string $bytes = null, ?int $sequence = null): array
    {
        if (!$this->row('produtos_cab', 'Referencia', $reference, true)) {
            throw new InvalidArgumentException('Produto não encontrado.');
        }
        if ($bytes === null) {
            if ($sequence === null) {
                throw new InvalidArgumentException('Selecione a foto a excluir.');
            }
            $this->query('DELETE FROM produtos_fotos WHERE Referencia = ? AND Sequencia = ?', [$reference, $sequence]);
        } else {
            $count = (int) $this->query('SELECT COUNT(*) FROM produtos_fotos WHERE Referencia = ?', [$reference])->fetchColumn();
            if ($count >= 5) {
                throw new InvalidArgumentException('Limite de 5 fotos por produto atingido.');
            }
            if (strlen($bytes) > 10 * 1024 * 1024 || !@getimagesizefromstring($bytes)) {
                throw new InvalidArgumentException('Envie uma imagem válida de até 10 MB.');
            }
            $mime = (new finfo(FILEINFO_MIME_TYPE))->buffer($bytes);
            if (!in_array($mime, ['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/bmp', 'image/x-ms-bmp'], true)) {
                throw new InvalidArgumentException('Formato de imagem não permitido.');
            }
            $sequence = (int) $this->query('SELECT COALESCE(MAX(Sequencia), 0) + 1 FROM produtos_fotos WHERE Referencia = ?', [$reference])->fetchColumn();
            $this->query('INSERT INTO produtos_fotos (Referencia, Sequencia, Foto, Usuario, Inclusao) VALUES (?, ?, ?, ?, ?)', [$reference, $sequence, $bytes, $this->usuario, date('Y-m-d')]);
        }
        $count = (int) $this->query('SELECT COUNT(*) FROM produtos_fotos WHERE Referencia = ?', [$reference])->fetchColumn();
        $hasPhoto = $count > 0 ? 1 : 0;
        $this->write('produtos_cab', ['Foto' => $hasPhoto, 'Alteracao' => date('Y-m-d H:i:s')], 'Referencia', $reference);
        $this->query('UPDATE produtos_cab_grade SET Foto = ?, Alteracao = ? WHERE Referencia = ?', [$hasPhoto, date('Y-m-d H:i:s'), $reference]);
        $this->query('UPDATE produtos SET Foto = ?, Alteracao = ? WHERE Distribuidora LIKE ?', [$hasPhoto, date('Y-m-d H:i:s'), $reference . '%']);
        return ['photos' => $count];
    }

    public function importLegacy(string $reference, bool $missing): array
    {
        if (!preg_match('/^[A-Za-z0-9]{8}(?:[A-Za-z0-9]{4})?$/D', $reference)) {
            throw new InvalidArgumentException('Informe referência master com 8 ou completa com 12 caracteres.');
        }
        $master = substr($reference, 0, 8);
        $pattern = strlen($reference) === 8 ? $reference . '%' : $reference;
        if (!$missing && ($this->row('produtos_cab', 'Referencia', $master) || $this->query('SELECT 1 FROM produtos WHERE Distribuidora LIKE ? LIMIT 1', [$pattern])->fetchColumn())) {
            throw new InvalidArgumentException('O produto já existe. Selecione importar apenas referências faltantes.');
        }
        $suffix = null;
        foreach (['gcom', 'antes_gcom'] as $candidate) {
            if ($this->query("SELECT 1 FROM `produtos_cab_$candidate` WHERE Referencia = ? LIMIT 1", [$master])->fetchColumn()
                || $this->query("SELECT 1 FROM `produtos_$candidate` WHERE Distribuidora LIKE ? LIMIT 1", [$pattern])->fetchColumn()) {
                $suffix = $candidate;
                break;
            }
        }
        if ($suffix === null) {
            throw new InvalidArgumentException('Referência não encontrada em GCOM ou na base anterior.');
        }
        $counts = ['cab' => 0, 'grade' => 0, 'produtos' => 0, 'barras' => 0, 'source' => $suffix];
        $head = $this->row('produtos_cab_' . $suffix, 'Referencia', $master);
        if (!$head) {
            throw new InvalidArgumentException('O cabeçalho da referência não existe na origem selecionada.');
        }
        if (!$this->row('produtos_cab', 'Referencia', $master)) {
            $this->write('produtos_cab', $head, 'Referencia');
            $counts['cab']++;
        }
        foreach (['produtos_cab_grade' => ['Distribuidora', 'grade'], 'produtos' => ['Codigo', 'produtos']] as $target => [$key, $counter]) {
            foreach ($this->query("SELECT * FROM `{$target}_$suffix` WHERE Distribuidora LIKE ? ORDER BY Distribuidora", [$pattern])->fetchAll() as $row) {
                $existing = $this->query("SELECT `$key` FROM `$target` WHERE Distribuidora = ?", [$row['Distribuidora']])->fetchColumn();
                if ($existing !== false) {
                    continue;
                }
                if ($this->row($target, $key, $row[$key])) {
                    throw new InvalidArgumentException('Código da origem já pertence a outro produto: ' . $row[$key]);
                }
                $this->write($target, $row, $key);
                $counts[$counter]++;
            }
        }
        foreach ($this->query("SELECT b.Codigo, b.CodigoBarra FROM `produtos_barras_$suffix` b JOIN `produtos_$suffix` p ON p.Codigo = b.Codigo WHERE p.Distribuidora LIKE ?", [$pattern])->fetchAll() as $barcode) {
            $source = $this->row('produtos_' . $suffix, 'Codigo', $barcode['Codigo']);
            $current = $this->row('produtos', 'Codigo', $barcode['Codigo']);
            if (!$current || $current['Distribuidora'] !== $source['Distribuidora']) {
                throw new InvalidArgumentException('Código de barras conflita com um produto atual.');
            }
            if (!$this->query('SELECT 1 FROM produtos_barras WHERE Codigo = ? AND CodigoBarra = ?', array_values($barcode))->fetchColumn()) {
                $this->query('INSERT INTO produtos_barras (Codigo, CodigoBarra) VALUES (?, ?)', array_values($barcode));
                $counts['barras']++;
            }
        }
        return $counts;
    }

    private function number($value, string $label): float
    {
        if (!is_scalar($value)) {
            throw new InvalidArgumentException($label . ' inválido.');
        }
        $value = str_replace(',', '.', trim((string) $value));
        if ($value === '' || !is_numeric($value) || !is_finite((float) $value) || (float) $value < 0) {
            throw new InvalidArgumentException($label . ': informe um número positivo ou zero.');
        }
        return (float) $value;
    }

    private function priceLog(string $code, string $reference, array $old, array $new): void
    {
        if ($old && (float) $old['PrecoVendaTabela'] === (float) $new['PrecoVendaTabela'] && (float) $old['PrecoCompraTabela'] === (float) $new['PrecoCompraTabela'] && (float) $old['PrecoCompra'] === (float) $new['PrecoCompra']) {
            return;
        }
        $this->query('INSERT INTO produtos_log_preco (DataHora, Produto, Referencia, Acao, VarejoOLD, VarejoNEW, AtacadoOLD, AtacadoNEW, CompraOLD, CompraNEW, Usuario)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [date('Y-m-d H:i:s'), $code, $reference, $old ? 'Alteração' : 'Inclusão', $old['PrecoVendaTabela'] ?? 0, $new['PrecoVendaTabela'], $old['PrecoCompraTabela'] ?? 0, $new['PrecoCompraTabela'], $old['PrecoCompra'] ?? 0, $new['PrecoCompra'], $this->usuario]);
    }
}
