<?php

$config = require __DIR__ . '/../config/config.php';
$token = $config['access_token'];

if (empty($token) || strpos($token, 'VOTRE') !== false) {
    die("❌ Please configure access_token in config/config.php first.\n");
}

$url = "https://graph.facebook.com/v18.0/me/accounts?access_token=$token";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); 
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);

if (isset($data['error'])) {
    echo "❌ Facebook Error:\n";
    print_r($data['error']['message']);
    echo "\n";
    exit;
}

echo "✅ Token valid! Found " . count($data['data']) . " pages:\n\n";

foreach ($data['data'] as $page) {
    echo "📄 Name: " . $page['name'] . "\n";
    echo "🆔 ID:   " . $page['id'] . "\n";
    echo "---------------------------\n";
}

if (count($data['data']) > 0) {
    echo "\n👉 Copy the ID of the page you want to look ads for and put it in config.php under 'page_id'.\n";
} else {
    echo "\n⚠️ No pages found. Make sure you gave 'pages_read_engagement' permission.\n";
}
