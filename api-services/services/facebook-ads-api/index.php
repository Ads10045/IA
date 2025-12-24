<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once __DIR__ . '/services/FacebookService.php';

// Charger la config
$config = require __DIR__ . '/config/config.php';

// Routeur simple
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Swagger Documentation
if ($uri === '/swagger') {
    header('Content-Type: text/html');
    readfile(__DIR__ . '/swagger.html');
    exit;
}
if ($uri === '/openapi.yaml') {
    header('Content-Type: application/yaml');
    readfile(__DIR__ . '/openapi.yaml');
    exit;
}

if ($uri === '/api/ads' || $uri === '/api/posts') {
    // Instancier le service
    $fbService = new FacebookService($config);
    
    // Récupérer les params
    $limit = $_GET['limit'] ?? 5;
    $keyword = $_GET['keyword'] ?? null;
    
    try {
        $data = $fbService->getLatestPosts($limit, $keyword);
        echo json_encode(['success' => true, 'data' => $data]);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
} else {
    echo json_encode([
        'status' => 'online',
        'service' => 'Facebook Ads API',
        'endpoints' => [
            'GET /api/posts' => 'Retrieve latest page posts/ads'
        ]
    ]);
}
