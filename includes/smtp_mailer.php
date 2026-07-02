<?php
/*
    Autor: Claudio Barto
    Data : 29/06/2026
*/

function smtp_read_response($socket): array
{
    $lines = [];
    while (($line = fgets($socket, 515)) !== false) {
        $lines[] = rtrim($line, "\r\n");
        if (strlen($line) >= 4 && $line[3] === ' ') {
            break;
        }
    }

    if (!$lines) {
        throw new RuntimeException('O servidor SMTP encerrou a conexao sem responder.');
    }

    return [
        'code' => (int) substr($lines[0], 0, 3),
        'message' => implode(' ', $lines),
    ];
}

function smtp_expect($socket, array $expectedCodes): array
{
    $response = smtp_read_response($socket);
    if (!in_array($response['code'], $expectedCodes, true)) {
        throw new RuntimeException('Resposta inesperada do servidor SMTP: ' . $response['message']);
    }

    return $response;
}

function smtp_command($socket, string $command, array $expectedCodes): array
{
    if (fwrite($socket, $command . "\r\n") === false) {
        throw new RuntimeException('Nao foi possivel enviar um comando ao servidor SMTP.');
    }

    return smtp_expect($socket, $expectedCodes);
}

function smtp_header_text(string $value): string
{
    $value = trim(str_replace(["\r", "\n"], '', $value));
    return '=?UTF-8?B?' . base64_encode($value) . '?=';
}

function smtp_mailbox(string $email, string $name = ''): string
{
    $email = trim(str_replace(["\r", "\n"], '', $email));
    return $name === '' ? '<' . $email . '>' : smtp_header_text($name) . ' <' . $email . '>';
}

function smtp_send(array $config, array $recipients, string $subject, string $body): void
{
    $host = trim((string) ($config['Servidor'] ?? ''));
    $port = (int) ($config['Porta'] ?? 0);
    $username = trim((string) ($config['Email'] ?? ''));
    $password = (string) ($config['Senha'] ?? '');
    $fromName = trim((string) ($config['NomeConta'] ?? 'Kidstok'));
    $authenticated = strtoupper(trim((string) ($config['ModoAutenticado'] ?? 'N'))) === 'S';
    $sslEnabled = strtoupper(trim((string) ($config['ModoSSL'] ?? 'N'))) === 'S';

    if ($host === '' || $port <= 0 || !filter_var($username, FILTER_VALIDATE_EMAIL)) {
        throw new RuntimeException('A configuracao de e-mail esta incompleta.');
    }

    $validRecipients = [];
    foreach ($recipients as $recipient) {
        $email = trim((string) ($recipient['email'] ?? ''));
        if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $validRecipients[$email] = [
                'email' => $email,
                'name' => trim((string) ($recipient['nome'] ?? '')),
            ];
        }
    }
    if (!$validRecipients) {
        throw new RuntimeException('Nenhum destinatario possui um e-mail valido.');
    }

    $implicitSsl = $sslEnabled && $port === 465;
    $remote = ($implicitSsl ? 'ssl://' : 'tcp://') . $host . ':' . $port;
    $context = stream_context_create([
        'ssl' => [
            'peer_name' => $host,
            'verify_peer' => true,
            'verify_peer_name' => true,
        ],
    ]);
    $socket = @stream_socket_client(
        $remote,
        $errorNumber,
        $errorMessage,
        20,
        STREAM_CLIENT_CONNECT,
        $context
    );
    if (!$socket) {
        throw new RuntimeException('Nao foi possivel conectar ao servidor SMTP: ' . $errorMessage);
    }

    stream_set_timeout($socket, 20);
    try {
        smtp_expect($socket, [220]);
        $clientName = gethostname() ?: 'localhost';
        smtp_command($socket, 'EHLO ' . $clientName, [250]);

        if ($sslEnabled && !$implicitSsl) {
            smtp_command($socket, 'STARTTLS', [220]);
            $cryptoMethod = defined('STREAM_CRYPTO_METHOD_TLS_CLIENT')
                ? STREAM_CRYPTO_METHOD_TLS_CLIENT
                : STREAM_CRYPTO_METHOD_SSLv23_CLIENT;
            if (!stream_socket_enable_crypto($socket, true, $cryptoMethod)) {
                throw new RuntimeException('Nao foi possivel ativar a conexao segura com o servidor SMTP.');
            }
            smtp_command($socket, 'EHLO ' . $clientName, [250]);
        }

        if ($authenticated) {
            smtp_command($socket, 'AUTH LOGIN', [334]);
            smtp_command($socket, base64_encode($username), [334]);
            smtp_command($socket, base64_encode($password), [235]);
        }

        smtp_command($socket, 'MAIL FROM:<' . $username . '>', [250]);
        foreach ($validRecipients as $recipient) {
            smtp_command($socket, 'RCPT TO:<' . $recipient['email'] . '>', [250, 251]);
        }
        smtp_command($socket, 'DATA', [354]);

        $to = implode(', ', array_map(
            static fn(array $recipient): string => smtp_mailbox($recipient['email'], $recipient['name']),
            array_values($validRecipients)
        ));
        $headers = [
            'Date: ' . date(DATE_RFC2822),
            'From: ' . smtp_mailbox($username, $fromName),
            'To: ' . $to,
            'Subject: ' . smtp_header_text($subject),
            'MIME-Version: 1.0',
            'Content-Type: text/plain; charset=UTF-8',
            'Content-Transfer-Encoding: base64',
        ];
        $message = implode("\r\n", $headers)
            . "\r\n\r\n"
            . chunk_split(base64_encode($body), 76, "\r\n");

        if (fwrite($socket, $message . "\r\n.\r\n") === false) {
            throw new RuntimeException('Nao foi possivel transmitir o e-mail ao servidor SMTP.');
        }
        smtp_expect($socket, [250]);
        smtp_command($socket, 'QUIT', [221]);
    } finally {
        fclose($socket);
    }
}
