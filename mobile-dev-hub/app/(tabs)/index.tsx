import { StyleSheet, ScrollView, View, Text, TouchableOpacity, Linking } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';

export default function HomeScreen() {
  const router = useRouter();
  const cards = [
    { title: 'GPS Vocal', desc: 'Obtenir ma position', color: '#3B82F6', route: '/gps' },
    { title: 'Sites Favoris', desc: 'Mes liens préférés', color: '#10B981', route: '/favorites' },
    { title: 'IPTV Player', desc: 'Streaming & Casting', color: '#8B5CF6', route: '/iptv' },
    { title: 'Dev Tests', desc: 'APIs & Outils', color: '#F59E0B', route: '/dev-tests' },
  ];

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <Text style={styles.title}>🚀 Mobile Dev Hub</Text>
        <Text style={styles.subtitle}>Bonjour ! Que voulez-vous faire ?</Text>

        <View style={styles.grid}>
          {cards.map((card, index) => (
            <TouchableOpacity
              key={index}
              style={[styles.card, { backgroundColor: card.color }]}
              onPress={() => router.push(card.route as any)}
            >
              <Text style={styles.cardTitle}>{card.title}</Text>
              <Text style={styles.cardDesc}>{card.desc}</Text>
            </TouchableOpacity>
          ))}
        </View>

        <View style={styles.quickActions}>
          <Text style={styles.sectionTitle}>Accès Rapides</Text>
          <TouchableOpacity
            style={styles.actionButton}
            onPress={() => Linking.openURL('http://localhost:8002/swagger.html')}
          >
            <Text style={styles.actionText}>📡 Facebook Ads API</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.actionButton}
            onPress={() => Linking.openURL('http://localhost:8085/swagger-ui/index.html')}
          >
            <Text style={styles.actionText}>🔧 Gestion Garage API</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#1F2937',
  },
  scrollContent: {
    padding: 20,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#9CA3AF',
    marginBottom: 24,
  },
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    gap: 12,
  },
  card: {
    width: '48%',
    padding: 20,
    borderRadius: 16,
    marginBottom: 12,
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginBottom: 4,
  },
  cardDesc: {
    fontSize: 14,
    color: 'rgba(255,255,255,0.8)',
  },
  quickActions: {
    marginTop: 24,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginBottom: 12,
  },
  actionButton: {
    backgroundColor: '#374151',
    padding: 16,
    borderRadius: 12,
    marginBottom: 8,
  },
  actionText: {
    color: '#FFFFFF',
    fontSize: 16,
  },
});
