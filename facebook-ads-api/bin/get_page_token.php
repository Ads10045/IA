<?php

$config = require __DIR__ . '/../config/config.php';
$userToken = $config['access_token'];
$pageId = $config['page_id'];

if (empty($userToken)) {
    die("❌ No access_token in config.\n");
}

echo "🔍 Fetching Page Access Token for Page ID: $pageId ...\n";

$url = "https://graph.facebook.com/v18.0/$pageId?fields=access_token&access_token=$userToken";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);

if (isset($data['error'])) {
    echo "❌ Error:\n";
    print_r($data['error']);
    echo "\n";
    exit;
}

if (isset($data['access_token'])) {
    echo "✅ Success! Found Page Access Token.\n\n";
    echo $data['access_token'];
    echo "\n\n👉 I will now update config.php with this new token.\n";
    
    // Auto-update config ?
    // Let's print it for now or we can use another tool to update it.
} else {
    echo "⚠️ No access_token found in response. Are you admin of this page?\n";
    print_r($data);
}
