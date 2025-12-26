import { StyleSheet, View, Text, TouchableOpacity, FlatList, Linking } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

const devTests = [
    { id: '1', name: 'Facebook Ads API', url: 'http://localhost:8002/swagger.html', status: '🟢', icon: '📡' },
    { id: '2', name: 'Gestion Garage API', url: 'http://localhost:8085/swagger-ui/index.html', status: '🟢', icon: '🔧' },
    { id: '3', name: 'Gestion Garage Frontend', url: 'http://localhost:4200', status: '🔴', icon: '🖥️' },
    { id: '4', name: 'Laravel Shop', url: 'http://localhost:8001', status: '🔴', icon: '🛒' },
    { id: '5', name: 'Visite Technique API', url: 'http://localhost:8000/api', status: '🔴', icon: '🚗' },
];

const quickCommands = [
    { id: 'c1', name: 'Start Garage Backend', command: 'mvn spring-boot:run', icon: '▶️' },
    { id: 'c2', name: 'Start Garage Frontend', command: 'npm start', icon: '▶️' },
    { id: 'c3', name: 'Start FB Ads API', command: 'php -S localhost:8002', icon: '▶️' },
];

export default function DevTestsScreen() {
    const openUrl = (url: string) => {
        Linking.openURL(url).catch(() => {
            // Handle error silently
        });
    };

    return (
        <SafeAreaView style={styles.container}>
            <Text style={styles.title}>🛠️ Dev Tests</Text>
            <Text style={styles.subtitle}>APIs et outils de développement</Text>

            <Text style={styles.sectionTitle}>Services</Text>
            <FlatList
                data={devTests}
                keyExtractor={(item) => item.id}
                scrollEnabled={false}
                renderItem={({ item }) => (
                    <TouchableOpacity
                        style={styles.serviceItem}
                        onPress={() => openUrl(item.url)}
                    >
                        <Text style={styles.serviceIcon}>{item.icon}</Text>
                        <View style={styles.serviceInfo}>
                            <Text style={styles.serviceName}>{item.name}</Text>
                            <Text style={styles.serviceUrl}>{item.url}</Text>
                        </View>
                        <Text style={styles.status}>{item.status}</Text>
                    </TouchableOpacity>
                )}
            />

            <Text style={styles.sectionTitle}>Commandes Rapides</Text>
            {quickCommands.map((cmd) => (
                <TouchableOpacity key={cmd.id} style={styles.commandItem}>
                    <Text style={styles.commandIcon}>{cmd.icon}</Text>
                    <View style={styles.commandInfo}>
                        <Text style={styles.commandName}>{cmd.name}</Text>
                        <Text style={styles.commandText}>{cmd.command}</Text>
                    </View>
                </TouchableOpacity>
            ))}
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
        marginBottom: 4,
    },
    subtitle: {
        fontSize: 14,
        color: '#9CA3AF',
        marginBottom: 20,
    },
    sectionTitle: {
        fontSize: 18,
        fontWeight: 'bold',
        color: '#FFFFFF',
        marginBottom: 12,
        marginTop: 16,
    },
    serviceItem: {
        backgroundColor: '#374151',
        padding: 14,
        borderRadius: 12,
        marginBottom: 8,
        flexDirection: 'row',
        alignItems: 'center',
    },
    serviceIcon: {
        fontSize: 24,
        marginRight: 12,
    },
    serviceInfo: {
        flex: 1,
    },
    serviceName: {
        color: '#FFFFFF',
        fontSize: 16,
        fontWeight: '600',
    },
    serviceUrl: {
        color: '#9CA3AF',
        fontSize: 12,
    },
    status: {
        fontSize: 16,
    },
    commandItem: {
        backgroundColor: '#374151',
        padding: 14,
        borderRadius: 12,
        marginBottom: 8,
        flexDirection: 'row',
        alignItems: 'center',
    },
    commandIcon: {
        fontSize: 20,
        marginRight: 12,
    },
    commandInfo: {
        flex: 1,
    },
    commandName: {
        color: '#FFFFFF',
        fontSize: 14,
        fontWeight: '600',
    },
    commandText: {
        color: '#9CA3AF',
        fontSize: 12,
        fontFamily: 'monospace',
    },
});
