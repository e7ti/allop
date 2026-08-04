<?php
/*
    Autor: Claudio Barto
    Data : 04/08/2026
*/
$aplicacao_nome = "sx.php";
$aplicacao_descricao = "Aplicacao externa para alterar a senha de usuarios.";

session_name('allop_sx');
session_start();

require_once __DIR__ . '/config/database.php';

$acao = (string) ($_GET['acao'] ?? '');

function sx_json(bool $success, array $data = [], int $status = 200): void
{
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['success' => $success] + $data, JSON_UNESCAPED_UNICODE);
    exit;
}

function sx_token(): string
{
    if (empty($_SESSION['sx_token'])) {
        $_SESSION['sx_token'] = bin2hex(random_bytes(32));
    }

    return (string) $_SESSION['sx_token'];
}

if ($acao === 'usuarios') {
    try {
        $q = '%' . trim((string) ($_GET['q'] ?? '')) . '%';
        $stmt = db()->prepare(
            "SELECT id, nome, login, ativo
               FROM seg_usuarios
              WHERE nome LIKE :q_nome OR login LIKE :q_login
              ORDER BY nome, login
              LIMIT 30"
        );
        $stmt->execute([
            'q_nome' => $q,
            'q_login' => $q,
        ]);

        $results = array_map(static function (array $usuario): array {
            $nome = trim((string) $usuario['nome']);
            $login = trim((string) $usuario['login']);
            $status = ((int) $usuario['ativo'] === 1) ? '' : ' - inativo';

            return [
                'id' => (int) $usuario['id'],
                'text' => $nome . ' (' . $login . ')' . $status,
            ];
        }, $stmt->fetchAll());

        sx_json(true, ['results' => $results]);
    } catch (Throwable $e) {
        sx_json(false, ['message' => 'Nao foi possivel carregar os usuarios.'], 500);
    }
}

if ($acao === 'salvar') {
    try {
        $token = (string) ($_POST['token'] ?? '');
        $usuarioId = (int) ($_POST['usuario_id'] ?? 0);
        $novaSenha = (string) ($_POST['nova_senha'] ?? '');
        $confirmarSenha = (string) ($_POST['confirmar_senha'] ?? '');

        if (!hash_equals(sx_token(), $token)) {
            sx_json(false, ['message' => 'Formulario expirado. Recarregue a pagina.'], 419);
        }

        if ($usuarioId < 1) {
            sx_json(false, ['message' => 'Selecione um usuario.'], 422);
        }

        if (strlen($novaSenha) < 6) {
            sx_json(false, ['message' => 'A senha deve ter pelo menos 6 caracteres.'], 422);
        }

        if ($novaSenha !== $confirmarSenha) {
            sx_json(false, ['message' => 'A confirmacao da senha nao confere.'], 422);
        }

        $stmt = db()->prepare('SELECT id, nome, login FROM seg_usuarios WHERE id = :id LIMIT 1');
        $stmt->execute(['id' => $usuarioId]);
        $usuario = $stmt->fetch();

        if (!$usuario) {
            sx_json(false, ['message' => 'Usuario nao encontrado.'], 404);
        }

        $stmt = db()->prepare('UPDATE seg_usuarios SET senha = :senha WHERE id = :id');
        $stmt->execute([
            'senha' => password_hash($novaSenha, PASSWORD_DEFAULT),
            'id' => $usuarioId,
        ]);

        sx_json(true, [
            'message' => 'Senha alterada com sucesso.',
            'usuario' => trim((string) $usuario['nome']) . ' (' . trim((string) $usuario['login']) . ')',
        ]);
    } catch (Throwable $e) {
        sx_json(false, ['message' => 'Nao foi possivel alterar a senha.'], 500);
    }
}

$token = sx_token();
?>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>SX | <?= h(APP_NAME) ?></title>
    <link rel="stylesheet" href="<?= app_url('assets/vendor/bootstrap/css/bootstrap.min.css') ?>">
    <link rel="stylesheet" href="<?= app_url('assets/vendor/select2/css/select2.min.css') ?>">
    <style>
        body {
            min-height: 100vh;
            background: #f4f6f8;
            color: #20252b;
        }

        .sx-wrap {
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 24px;
        }

        .sx-panel {
            width: min(100%, 460px);
            background: #ffffff;
            border: 1px solid #d9e0e7;
            border-radius: 8px;
            box-shadow: 0 16px 40px rgba(20, 35, 50, 0.12);
            padding: 28px;
        }

        .sx-title {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 22px;
        }

        .sx-mark {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            display: grid;
            place-items: center;
            background: #1f6feb;
            color: #ffffff;
            font-weight: 700;
        }

        .sx-title h1 {
            margin: 0;
            font-size: 1.35rem;
            line-height: 1.2;
        }

        .sx-title p {
            margin: 2px 0 0;
            color: #67717d;
            font-size: 0.92rem;
        }

        .select2-container {
            width: 100% !important;
        }

        .select2-container .select2-selection--single {
            height: 38px;
            border-color: #ced4da;
        }

        .select2-container--default .select2-selection--single .select2-selection__rendered {
            line-height: 36px;
        }

        .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 36px;
        }

        .btn-sx {
            background: #1f6feb;
            border-color: #1f6feb;
            color: #ffffff;
        }

        .btn-sx:hover,
        .btn-sx:focus {
            background: #195ec7;
            border-color: #195ec7;
            color: #ffffff;
        }
    </style>
</head>
<body>
<main class="sx-wrap">
    <section class="sx-panel">
        <div class="sx-title">
            <span class="sx-mark">SX</span>
            <div>
                <h1>Senha</h1>
                <p>Usuarios do banco principal</p>
            </div>
        </div>

        <div id="sx-alert" class="alert d-none" role="alert"></div>

        <form id="sx-form" autocomplete="off">
            <input type="hidden" name="token" value="<?= h($token) ?>">

            <div class="mb-3">
                <label class="form-label" for="usuario_id">Usuario</label>
                <select id="usuario_id" name="usuario_id" class="form-select" required></select>
            </div>

            <div class="mb-3">
                <label class="form-label" for="nova_senha">Nova senha</label>
                <input id="nova_senha" name="nova_senha" class="form-control" type="password" minlength="6" autocomplete="new-password" required>
            </div>

            <div class="mb-4">
                <label class="form-label" for="confirmar_senha">Confirmar senha</label>
                <input id="confirmar_senha" name="confirmar_senha" class="form-control" type="password" minlength="6" autocomplete="new-password" required>
            </div>

            <button id="sx-submit" class="btn btn-sx w-100" type="submit">Alterar senha</button>
        </form>
    </section>
</main>

<script src="<?= app_url('assets/vendor/jquery/jquery.min.js') ?>"></script>
<script src="<?= app_url('assets/vendor/select2/js/select2.min.js') ?>"></script>
<script>
$(function () {
    const $alert = $('#sx-alert');
    const $form = $('#sx-form');
    const $submit = $('#sx-submit');

    function showAlert(type, message) {
        $alert
            .removeClass('d-none alert-success alert-danger')
            .addClass(type === 'success' ? 'alert-success' : 'alert-danger')
            .text(message);
    }

    $('#usuario_id').select2({
        ajax: {
            url: 'sx.php?acao=usuarios',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return { q: params.term || '' };
            },
            processResults: function (data) {
                return { results: data.results || [] };
            }
        },
        placeholder: 'Selecione',
        minimumInputLength: 0,
        width: '100%'
    });

    $form.on('submit', function (event) {
        event.preventDefault();
        $alert.addClass('d-none').removeClass('alert-success alert-danger');
        $submit.prop('disabled', true).text('Alterando...');

        $.post('sx.php?acao=salvar', $form.serialize(), function (response) {
            showAlert('success', response.message || 'Senha alterada com sucesso.');
            $form[0].reset();
            $('#usuario_id').val(null).trigger('change');
        }, 'json').fail(function (xhr) {
            const response = xhr.responseJSON || {};
            showAlert('danger', response.message || 'Nao foi possivel alterar a senha.');
        }).always(function () {
            $submit.prop('disabled', false).text('Alterar senha');
        });
    });
});
</script>
</body>
</html>
