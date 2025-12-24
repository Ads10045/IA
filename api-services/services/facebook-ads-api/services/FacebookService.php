<?php

class FacebookService {
    private $accessToken;
    private $pageId;
    private $apiVersion;
    private $baseUrl;

    public function __construct($config) {
        $this->accessToken = $config['access_token'];
        $this->pageId = $config['page_id'];
        $this->apiVersion = $config['api_version'];
        $this->baseUrl = $config['base_url'];
    }

    public function getLatestPosts($limit = 5, $keyword = null) {
        // Endpoint: /PAGE_ID/posts?fields=message...
        // Note: Graph API search is limited, so we fetch and filter in PHP for simplicity
        // We request MORE data (up to 100) if filtering to scan deeper into the history
        $fetchLimit = $keyword ? 100 : $limit;

        $endpoint = "/{$this->pageId}/posts";
        $params = [
            'fields' => 'id,message,full_picture,permalink_url,created_time,attachments',
            'limit' => $fetchLimit,
            'access_token' => $this->accessToken
        ];

        $url = $this->baseUrl . '/' . $this->apiVersion . $endpoint . '?' . http_build_query($params);

        $posts = $this->makeRequest($url);

        if ($keyword && !empty($posts)) {
            $posts = array_filter($posts, function($post) use ($keyword) {
                if (empty($post['message'])) return false;
                return stripos($post['message'], $keyword) !== false;
            });
            // Re-index and slice to original limit
            $posts = array_values($posts);
            $posts = array_slice($posts, 0, $limit);
        }

        return $posts;
    }

    private function makeRequest($url) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        // SSL verification (peut être désactivé en dev local si nécessaire, mais risqué)
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); 
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        if (curl_errno($ch)) {
            throw new Exception('Curl Error: ' . curl_error($ch));
        }
        curl_close($ch);

        $json = json_decode($response, true);

        if ($httpCode !== 200) {
            $errorMsg = $json['error']['message'] ?? 'Unknown Facebook API Error';
            throw new Exception("Facebook API Error ($httpCode): $errorMsg");
        }

        return $json['data'] ?? [];
    }
}
