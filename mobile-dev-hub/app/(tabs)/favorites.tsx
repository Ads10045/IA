import { StyleSheet, View, Text, TouchableOpacity, FlatList, Linking, TextInput, Alert } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useState } from 'react';

const initialFavorites = [
    { id: '1', name: 'Facebook Ads API', url: 'http://localhost:8002/swagger.html', icon: '📡' },
    { id: '2', name: 'Gestion Garage', url: 'http://localhost:8085/swagger-ui/index.html', icon: '🔧' },
    { id: '3', name: 'GitHub', url: 'https://github.com', icon: '🐙' },
    { id: '4', name: 'Google', url: 'https://google.com', icon: '🔍' },
];

export default function FavoritesScreen() {
    const [favorites, setFavorites] = useState(initialFavorites);
    const [newName, setNewName] = useState('');
    const [newUrl, setNewUrl] = useState('');

    const addFavorite = () => {
        if (!newName || !newUrl) {
            Alert.alert('Erreur', 'Veuillez remplir tous les champs');
            return;
        }
        const newFav = {
            id: Date.now().toString(),
            name: newName,
            url: newUrl.startsWith('http') ? newUrl : `https://${newUrl}`,
            icon: '🌐',
        };
        setFavorites([...favorites, newFav]);
        setNewName('');
        setNewUrl('');
    };

    const removeFavorite = (id: string) => {
        setFavorites(favorites.filter(f => f.id !== id));
    };

    return (
        <SafeAreaView style={styles.container}>
            <Text style={styles.title}>⭐ Sites Favoris</Text>

            <View style={styles.addSection}>
                <TextInput
                    style={styles.input}
                    placeholder="Nom du site"
                    placeholderTextColor="#9CA3AF"
                    value={newName}
                    onChangeText={setNewName}
                />
                <TextInput
                    style={styles.input}
                    placeholder="URL"
                    placeholderTextColor="#9CA3AF"
                    value={newUrl}
                    onChangeText={setNewUrl}
                />
                <TouchableOpacity style={styles.addButton} onPress={addFavorite}>
                    <Text style={styles.addButtonText}>+ Ajouter</Text>
                </TouchableOpacity>
            </View>

            <FlatList
                data={favorites}
                keyExtractor={(item) => item.id}
                renderItem={({ item }) => (
                    <TouchableOpacity
                        style={styles.favoriteItem}
                        onPress={() => Linking.openURL(item.url)}
                        onLongPress={() => removeFavorite(item.id)}
                    >
                        <Text style={styles.icon}>{item.icon}</Text>
                        <View style={styles.textContainer}>
                            <Text style={styles.name}>{item.name}</Text>
                            <Text style={styles.url}>{item.url}</Text>
                        </View>
                    </TouchableOpacity>
                )}
            />
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#1F2937',
        padding: 20,
    },
    title: {
        fontSize: 28,
        fontWeight: 'bold',
        color: '#FFFFFF',
        marginBottom: 20,
    },
    addSection: {
        marginBottom: 20,
    },
    input: {
        backgroundColor: '#374151',
        color: '#FFFFFF',
        padding: 12,
        borderRadius: 8,
        marginBottom: 8,
    },
    addButton: {
        backgroundColor: '#10B981',
        padding: 12,
        borderRadius: 8,
        alignItems: 'center',
    },
    addButtonText: {
        color: '#FFFFFF',
        fontWeight: 'bold',
    },
    favoriteItem: {
        backgroundColor: '#374151',
        padding: 16,
        borderRadius: 12,
        marginBottom: 10,
        flexDirection: 'row',
        alignItems: 'center',
    },
    icon: {
        fontSize: 24,
        marginRight: 12,
    },
    textContainer: {
        flex: 1,
    },
    name: {
        color: '#FFFFFF',
        fontSize: 16,
        fontWeight: '600',
    },
    url: {
        color: '#9CA3AF',
        fontSize: 12,
    },
});
