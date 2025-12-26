import { StyleSheet, View, Text, TouchableOpacity, FlatList, TextInput, Alert, ActivityIndicator } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useState, useEffect } from 'react';
import { Video, ResizeMode } from 'expo-av';

import { Config } from '@/constants/Config';

export default function IPTVScreen() {
    const [channels, setChannels] = useState<{ id: string; name: string; url: string; group: string }[]>([]);
    const [categories, setCategories] = useState<string[]>([]);
    const [selectedCategory, setSelectedCategory] = useState<string>('Tout');
    const [selectedChannel, setSelectedChannel] = useState<string | null>(null);
    const [searchQuery, setSearchQuery] = useState('');
    const [isFullScreen, setIsFullScreen] = useState(false);
    const [playlistUrl, setPlaylistUrl] = useState(Config.iptv.defaultUrl);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        loadPlaylist();
    }, []);

    const loadPlaylist = async () => {
        if (!playlistUrl) {
            Alert.alert('Erreur', 'Entrez une URL de playlist M3U');
            return;
        }

        setLoading(true);
        try {
            const response = await fetch(playlistUrl);
            if (!response.ok) throw new Error('Échec du téléchargement');
            const text = await response.text();

            const lines = text.split('\n');
            const newChannels = [];

            for (let i = 0; i < lines.length; i++) {
                const line = lines[i].trim();
                if (line.startsWith('#EXTINF:')) {
                    const url = lines[i + 1]?.trim();

                    if (url && url.startsWith('http')) {
                        // Robust name extraction for M3U Plus
                        const nameIndex = line.lastIndexOf(',');
                        const name = nameIndex !== -1 ? line.substring(nameIndex + 1).trim() : 'Chaîne inconnue';

                        // Optional: Extract group-title if present
                        const groupMatch = line.match(/group-title="([^"]*)"/);
                        const group = groupMatch ? groupMatch[1] : undefined;

                        const newChannel = {
                            id: String(newChannels.length + 1),
                            name: name || `Chaîne ${newChannels.length + 1}`,
                            url,
                            group: group || 'Autres'
                        };
                        newChannels.push(newChannel);
                    }
                }
            }

            if (newChannels.length === 0) {
                Alert.alert('Info', 'Aucune chaîne trouvée. Vérifiez le format M3U.');
            } else {
                setChannels(newChannels);

                // Extract unique categories and sort them with priority
                const uniqueCategories = ['Tout', ...new Set(newChannels.map(c => c.group))];

                // Custom sort: Maroc first, then BeIN, then alphabetical
                uniqueCategories.sort((a, b) => {
                    if (a === 'Tout') return -1;
                    if (b === 'Tout') return 1;

                    const isMarocA = a.toLowerCase().includes('maroc');
                    const isMarocB = b.toLowerCase().includes('maroc');
                    const isBeinA = a.toLowerCase().includes('bein');
                    const isBeinB = b.toLowerCase().includes('bein');

                    if (isMarocA && !isMarocB) return -1;
                    if (!isMarocA && isMarocB) return 1;

                    if (isBeinA && !isBeinB) return -1;
                    if (!isBeinA && isBeinB) return 1;

                    return a.localeCompare(b);
                });

                setCategories(uniqueCategories);

                Alert.alert('Succès', `${newChannels.length} chaînes chargées !`);
            }
        } catch (error) {
            Alert.alert('Erreur', 'Impossible de charger la playlist. Vérifiez l\'URL.');
            console.error(error);
        } finally {
            setLoading(false);
        }
    };

    const castToTV = () => {
        Alert.alert(
            '📺 Casting WiFi',
            'Recherche de TVs sur le réseau...\n\nFonctionnalité disponible sur appareil réel avec Chromecast ou DLNA.',
            [{ text: 'OK' }]
        );
    };

    const currentChannel = channels.find(c => c.id === selectedChannel);

    // Filtering logic: Category + Search
    const filteredChannels = channels.filter(c => {
        const matchesCategory = selectedCategory === 'Tout' || c.group === selectedCategory;
        const matchesSearch = c.name.toLowerCase().includes(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
    });

    return (
        <SafeAreaView style={styles.container}>
            <Text style={styles.title}>📺 IPTV Player</Text>

            {/* Playlist is loaded automatically from Config */}

            <View style={styles.splitLayout}>
                {/* Section Gauche : Lecteur Vidéo */}
                <View style={styles.videoSection}>
                    {currentChannel ? (
                        <View style={styles.playerWrapper}>
                            <Video
                                source={{
                                    uri: currentChannel.url,
                                    headers: {
                                        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
                                    }
                                }}
                                rate={1.0}
                                volume={1.0}
                                isMuted={false}
                                resizeMode={ResizeMode.CONTAIN}
                                shouldPlay
                                useNativeControls
                                style={styles.video}
                                onError={(e) => {
                                    console.log("Video Error:", e);
                                    Alert.alert('Erreur', 'Impossible de lire ce flux. Vérifiez votre connexion ou le format du lien.');
                                }}
                            />
                            <View style={styles.playerOverlay}>
                                <Text style={styles.channelTitleMain}>{currentChannel.name}</Text>
                                <View style={styles.overlayControls}>
                                    <TouchableOpacity
                                        style={styles.controlButton}
                                        onPress={() => setIsFullScreen(!isFullScreen)}
                                    >
                                        <Text style={styles.controlButtonText}>
                                            {isFullScreen ? '↙️ Réduire' : '↗️ Plein Écran'}
                                        </Text>
                                    </TouchableOpacity>
                                    <TouchableOpacity style={[styles.controlButton, styles.castButton]} onPress={castToTV}>
                                        <Text style={styles.controlButtonText}>📡 Caster</Text>
                                    </TouchableOpacity>
                                </View>
                            </View>
                        </View>
                    ) : (
                        <View style={styles.placeholderContainer}>
                            <Text style={styles.placeholderIcon}>📺</Text>
                            <Text style={styles.placeholderText}>Sélectionnez une chaîne</Text>
                        </View>
                    )}
                </View>

                {/* Section Droite : Liste des Chaînes (Masquée en plein écran) */}
                {!isFullScreen && (
                    <View style={styles.sidebar}>
                        <View style={styles.sidebarHeader}>
                            <Text style={styles.sidebarTitle}>Chaînes TV</Text>
                            <TextInput
                                style={styles.searchInput}
                                placeholder="🔍 Rechercher..."
                                placeholderTextColor="#94A3B8"
                                value={searchQuery}
                                onChangeText={setSearchQuery}
                            />
                        </View>

                        {loading ? (
                            <View style={styles.loadingContainer}>
                                <ActivityIndicator size="large" color="#8B5CF6" />
                            </View>
                        ) : (
                            <>
                                {/* Catégories */}
                                <View style={styles.categoriesContainer}>
                                    <FlatList
                                        data={categories}
                                        horizontal
                                        style={{ flex: 1 }}
                                        showsHorizontalScrollIndicator={true}
                                        keyExtractor={(item) => item}
                                        contentContainerStyle={{ paddingHorizontal: 10, alignItems: 'center' }}
                                        renderItem={({ item }) => (
                                            <TouchableOpacity
                                                style={[
                                                    styles.categoryChip,
                                                    selectedCategory === item && styles.selectedCategoryChip
                                                ]}
                                                onPress={() => setSelectedCategory(item)}
                                            >
                                                <Text style={[
                                                    styles.categoryText,
                                                    selectedCategory === item && styles.selectedCategoryText
                                                ]}>
                                                    {item}
                                                </Text>
                                            </TouchableOpacity>
                                        )}
                                    />
                                </View>

                                {/* Liste */}
                                <FlatList
                                    data={filteredChannels}
                                    style={{ flex: 1 }}
                                    keyExtractor={(item) => item.id}
                                    contentContainerStyle={{ padding: 10 }}
                                    renderItem={({ item }) => (
                                        <TouchableOpacity
                                            style={[
                                                styles.channelItem,
                                                selectedChannel === item.id && styles.selectedChannel,
                                            ]}
                                            onPress={() => setSelectedChannel(item.id)}
                                        >
                                            <Text
                                                style={[
                                                    styles.channelName,
                                                    selectedChannel === item.id && styles.selectedChannelText
                                                ]}
                                                numberOfLines={1}
                                            >
                                                {item.name}
                                            </Text>
                                            {selectedChannel === item.id && <Text style={styles.playingIndicator}>▶</Text>}
                                        </TouchableOpacity>
                                    )}
                                    ListEmptyComponent={
                                        <Text style={styles.emptyText}>Aucune chaîne</Text>
                                    }
                                />
                            </>
                        )}
                    </View>
                )}
            </View>
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#0F172A', // Darker elegant blue
    },
    splitLayout: {
        flex: 1,
        flexDirection: 'row',
    },
    // Left Section
    videoSection: {
        flex: 1,
        backgroundColor: '#000',
        justifyContent: 'center',
        alignItems: 'center',
        borderRightWidth: 1,
        borderRightColor: '#1E293B',
    },
    playerWrapper: {
        width: '100%',
        height: '100%', // Full height of the left section
    },
    video: {
        flex: 1,
        width: '100%',
    },
    playerOverlay: {
        position: 'absolute',
        top: 20,
        left: 20,
        right: 20,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        zIndex: 10,
    },
    overlayControls: {
        flexDirection: 'row',
        gap: 10,
    },
    controlButton: {
        backgroundColor: 'rgba(0,0,0,0.6)',
        paddingHorizontal: 12,
        paddingVertical: 8,
        borderRadius: 20,
    },
    controlButtonText: {
        color: 'white',
        fontWeight: 'bold',
        fontSize: 12,
    },
    channelTitleMain: {
        color: 'white',
        fontSize: 18, // Reduced for mobile
        fontWeight: 'bold',
        backgroundColor: 'rgba(0,0,0,0.5)',
        paddingHorizontal: 12,
        paddingVertical: 6,
        borderRadius: 8,
        overflow: 'hidden',
    },
    castButton: {
        backgroundColor: 'rgba(239, 68, 68, 0.9)',
    },
    castButtonText: {
        color: 'white',
        fontWeight: 'bold',
        fontSize: 12,
    },
    placeholderContainer: {
        justifyContent: 'center',
        alignItems: 'center',
        opacity: 0.7,
    },
    placeholderIcon: {
        fontSize: 48,
        marginBottom: 10,
    },
    placeholderText: {
        color: '#64748B',
        fontSize: 16,
    },

    // Right Section (Sidebar)
    sidebar: {
        width: '40%', // Takes 40% of the screen
        backgroundColor: '#1E293B',
        borderLeftWidth: 1,
        borderLeftColor: '#334155',
    },
    sidebarHeader: {
        padding: 15,
        borderBottomWidth: 1,
        borderBottomColor: '#334155',
        backgroundColor: '#0F172A',
    },
    sidebarTitle: {
        fontSize: 16,
        fontWeight: '900',
        color: '#F1F5F9',
        textAlign: 'center',
        marginBottom: 10,
        letterSpacing: 1,
    },
    searchInput: {
        backgroundColor: '#334155',
        color: '#FFFFFF',
        paddingHorizontal: 12,
        paddingVertical: 8,
        borderRadius: 8,
        fontSize: 14,
    },
    categoriesContainer: {
        height: 50,
        backgroundColor: '#0F172A',
        justifyContent: 'center',
        borderBottomWidth: 1,
        borderBottomColor: '#334155',
    },
    categoryChip: {
        paddingHorizontal: 12,
        paddingVertical: 6,
        borderRadius: 16,
        marginRight: 8,
        backgroundColor: '#334155',
        height: 32,
        justifyContent: 'center',
        alignSelf: 'center',
    },
    selectedCategoryChip: {
        backgroundColor: '#8B5CF6',
    },
    categoryText: {
        color: '#94A3B8',
        fontSize: 12,
        fontWeight: '600',
    },
    selectedCategoryText: {
        color: '#FFFFFF',
    },
    channelItem: {
        padding: 12,
        borderRadius: 8,
        marginBottom: 6,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        backgroundColor: 'rgba(255,255,255,0.03)',
    },
    selectedChannel: {
        backgroundColor: '#8B5CF6',
        transform: [{ scale: 1.02 }],
    },
    channelName: {
        color: '#CBD5E1',
        fontSize: 13,
        flex: 1,
    },
    selectedChannelText: {
        color: '#FFFFFF',
        fontWeight: 'bold',
    },
    playingIndicator: {
        color: '#FFFFFF',
        fontSize: 12,
        marginLeft: 6,
    },
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    emptyText: {
        color: '#64748B',
        textAlign: 'center',
        marginTop: 30,
        fontStyle: 'italic',
    },
});
