import { StyleSheet, View, Text, TouchableOpacity, Alert, FlatList } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useState } from 'react';
import * as Location from 'expo-location';
import * as Speech from 'expo-speech';

interface LocationEntry {
    id: string;
    address: string;
    timestamp: string;
}

export default function GPSScreen() {
    const [currentAddress, setCurrentAddress] = useState<string | null>(null);
    const [loading, setLoading] = useState(false);
    const [history, setHistory] = useState<LocationEntry[]>([]);
    const [speaking, setSpeaking] = useState(false);

    const getLocation = async () => {
        // DEBUG: Confirm press
        Alert.alert("Test", "Le bouton fonctionne ! Recherche en cours...");

        setLoading(true);
        try {
            // 1. Check Permissions
            const { status } = await Location.requestForegroundPermissionsAsync();
            if (status !== 'granted') {
                Alert.alert('Permission refusée', 'Veuillez autoriser la localisation dans les réglages.');
                setLoading(false);
                return;
            }

            // 2. Get Location (with Timeout & Fallback)
            let loc = await Promise.race([
                Location.getCurrentPositionAsync({ accuracy: Location.Accuracy.Balanced }),
                new Promise<null>((_, reject) => setTimeout(() => reject(new Error('Timeout')), 10000))
            ]);

            if (!loc) {
                // Fallback to last known position
                console.log("Timeout: Essai dernière position connue...");
                loc = await Location.getLastKnownPositionAsync({});
            }

            if (!loc) {
                throw new Error("Impossible de localiser l'appareil.");
            }

            // 3. Reverse Geocode
            const [address] = await Location.reverseGeocodeAsync({
                latitude: loc.coords.latitude,
                longitude: loc.coords.longitude,
            });

            if (address) {
                const parts = [
                    address.country,
                    address.city,
                    address.district || address.subregion,
                    address.street,
                    address.name !== address.street ? address.name : null
                ].filter(Boolean);

                const fullAddress = parts.join(', ');
                setCurrentAddress(fullAddress);

                const newEntry: LocationEntry = {
                    id: Date.now().toString(),
                    address: fullAddress,
                    timestamp: new Date().toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })
                };
                setHistory(prev => [newEntry, ...prev]);

                // 4. Voice Output
                const speechText = `Vous êtes à ${address.city || ''}, ${address.district || ''}`;
                console.log("Speech text:", speechText);

                Speech.stop();
                Speech.speak(speechText, {
                    language: 'fr',
                    onStart: () => setSpeaking(true),
                    onDone: () => setSpeaking(false),
                    onError: () => setSpeaking(false) // Silent fail if voice missing
                });
            }

        } catch (error) {
            console.error("GPS Error:", error);
            Alert.alert('Erreur GPS', 'Impossible de récupérer la position.\nVérifiez que le GPS est activé.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <SafeAreaView style={styles.container}>
            <View style={styles.header}>
                <Text style={styles.title}>📍 GPS Vocal</Text>
                <Text style={styles.subtitle}>Obtenez votre position détaillée</Text>
            </View>

            <View style={styles.actionSection}>
                <TouchableOpacity
                    style={[styles.mainButton, speaking && styles.speakingButton]}
                    onPress={getLocation}
                    disabled={loading || speaking}
                >
                    <Text style={styles.mainButtonText}>
                        {loading ? '⏳ Recherche...' : speaking ? '🔊 Lecture en cours...' : '🎙️ "Où suis-je ?"'}
                    </Text>
                </TouchableOpacity>

                {currentAddress && (
                    <View style={styles.currentLocationBox}>
                        <Text style={styles.label}>Position Actuelle :</Text>
                        <Text style={styles.addressText}>{currentAddress}</Text>
                    </View>
                )}
            </View>

            <View style={styles.historySection}>
                <Text style={styles.historyTitle}>📜 Historique des visites</Text>
                <FlatList
                    data={history}
                    keyExtractor={item => item.id}
                    contentContainerStyle={{ paddingBottom: 20 }}
                    renderItem={({ item }) => (
                        <View style={styles.historyItem}>
                            <Text style={styles.historyTime}>{item.timestamp}</Text>
                            <Text style={styles.historyAddress}>{item.address}</Text>
                        </View>
                    )}
                    ListEmptyComponent={
                        <Text style={styles.emptyText}>Aucune position enregistrée</Text>
                    }
                />
            </View>
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#0F172A',
    },
    header: {
        padding: 20,
        alignItems: 'center',
    },
    title: {
        fontSize: 28,
        fontWeight: 'bold',
        color: '#F8FAFC',
        marginBottom: 5,
    },
    subtitle: {
        fontSize: 14,
        color: '#94A3B8',
    },
    actionSection: {
        padding: 20,
        alignItems: 'center',
        borderBottomWidth: 1,
        borderBottomColor: '#1E293B',
    },
    mainButton: {
        backgroundColor: '#3B82F6',
        paddingHorizontal: 30,
        paddingVertical: 15,
        borderRadius: 30,
        marginBottom: 20,
        shadowColor: "#3B82F6",
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 10,
        elevation: 6,
    },
    speakingButton: {
        backgroundColor: '#10B981', // Green when speaking
    },
    mainButtonText: {
        color: 'white',
        fontSize: 18,
        fontWeight: 'bold',
    },
    currentLocationBox: {
        backgroundColor: '#1E293B',
        padding: 15,
        borderRadius: 12,
        width: '100%',
        alignItems: 'center',
    },
    label: {
        color: '#64748B',
        fontSize: 12,
        marginBottom: 4,
        textTransform: 'uppercase',
    },
    addressText: {
        color: '#F1F5F9',
        fontSize: 16,
        fontWeight: '600',
        textAlign: 'center',
    },
    historySection: {
        flex: 1,
        padding: 20,
    },
    historyTitle: {
        color: '#94A3B8',
        fontSize: 14,
        fontWeight: 'bold',
        marginBottom: 15,
        textTransform: 'uppercase',
        letterSpacing: 1,
    },
    historyItem: {
        flexDirection: 'row',
        backgroundColor: '#1E293B',
        padding: 12,
        borderRadius: 8,
        marginBottom: 8,
        alignItems: 'center',
    },
    historyTime: {
        color: '#3B82F6',
        fontWeight: 'bold',
        marginRight: 10,
        fontSize: 12,
    },
    historyAddress: {
        color: '#CBD5E1',
        flex: 1,
        fontSize: 13,
    },
    emptyText: {
        color: '#475569',
        textAlign: 'center',
        marginTop: 20,
        fontStyle: 'italic',
    },
});
