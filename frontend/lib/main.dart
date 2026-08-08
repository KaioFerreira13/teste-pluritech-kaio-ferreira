import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const PluritechApp());

class PluritechApp extends StatelessWidget {
  const PluritechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pluritech',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  String _status = 'Verificando API...';

  @override
  void initState() {
    super.initState();
    _checkApi();
  }

  Future<void> _checkApi() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/health'));
      setState(
        () => _status = response.statusCode == 200
            ? 'Backend conectado'
            : 'Backend respondeu com erro',
      );
    } catch (_) {
      setState(() => _status = 'Backend indisponível');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pluritech')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.web, size: 72),
            const SizedBox(height: 16),
            Text(
              'Ambiente pronto!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(_status, key: const Key('api-status')),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _checkApi,
              child: const Text('Testar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
