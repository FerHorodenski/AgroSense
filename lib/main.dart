import 'package:flutter/material.dart';

void main() {
  runApp(const AgroSenseApp());
}

class AgroSenseApp extends StatelessWidget {
  const AgroSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agrosense',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const TelaInicial(),
    );
  }
}

// ============================================================
// TELA 1 - BOAS-VINDAS
// ============================================================

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.eco,
                size: 100,
                color: Colors.green,
              ),

              const SizedBox(height: 30),

              const Text(
                'Seja bem-vindo ao Agrosense',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaCulturas(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Ver como está a horta',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TELA 2 - ESCOLHA DA CULTURA
// ============================================================

class TelaCulturas extends StatelessWidget {
  const TelaCulturas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agrosense'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            const Text(
              'Qual cultura você deseja ver?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 35),

            botaoCultura(
              context,
              nome: 'Manjericão',
              emoji: '🌿',
              solo: 55,
              ar: 60,
              luminosidade: 75,
              chuva: 20,
              temperatura: 24,
            ),

            botaoCultura(
              context,
              nome: 'Agrião',
              emoji: '🌱',
              solo: 80,
              ar: 70,
              luminosidade: 55,
              chuva: 40,
              temperatura: 20,
            ),

            botaoCultura(
              context,
              nome: 'Cenoura',
              emoji: '🥕',
              solo: 50,
              ar: 65,
              luminosidade: 70,
              chuva: 10,
              temperatura: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget botaoCultura(
      BuildContext context, {
        required String nome,
        required String emoji,
        required double solo,
        required double ar,
        required double luminosidade,
        required double chuva,
        required double temperatura,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaDados(
                cultura: nome,
                emoji: emoji,
                solo: solo,
                ar: ar,
                luminosidade: luminosidade,
                chuva: chuva,
                temperatura: temperatura,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            '$emoji  $nome',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TELA 3 - DADOS DA CULTURA
// ============================================================

class TelaDados extends StatelessWidget {
  final String cultura;
  final String emoji;

  final double solo;
  final double ar;
  final double luminosidade;
  final double chuva;
  final double temperatura;

  const TelaDados({
    super.key,
    required this.cultura,
    required this.emoji,
    required this.solo,
    required this.ar,
    required this.luminosidade,
    required this.chuva,
    required this.temperatura,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cultura),
        backgroundColor: Colors.green.shade100,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 70),
            ),

            Text(
              cultura,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            cardSensor(
              'Luminosidade',
              '$luminosidade%',
              Icons.wb_sunny,
            ),

            cardSensor(
              'Umidade do solo',
              '$solo%',
              Icons.grass,
            ),

            cardSensor(
              'Umidade do ar',
              '$ar%',
              Icons.water_drop,
            ),

            cardSensor(
              'Chuva',
              '$chuva%',
              Icons.cloud,
            ),

            cardSensor(
              'Temperatura',
              '$temperatura °C',
              Icons.thermostat,
            ),

            const SizedBox(height: 25),

            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🌱 O que precisa melhorar?',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      gerarRecomendacao(),
                      style: const TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardSensor(
      String titulo,
      String valor,
      IconData icone,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icone,
          size: 35,
          color: Colors.green,
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontSize: 17),
        ),
        trailing: Text(
          valor,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ANALISA OS DADOS E DÁ UMA RECOMENDAÇÃO
  // ============================================================

  String gerarRecomendacao() {
    if (cultura == 'Manjericão') {
      if (solo < 45) {
        return 'O solo está seco. O manjericão precisa de mais água.';
      }

      if (luminosidade < 60) {
        return 'O manjericão está recebendo pouca luz.';
      }

      if (temperatura < 18) {
        return 'A temperatura está baixa para o manjericão.';
      }

      if (temperatura > 30) {
        return 'A temperatura está muito alta para o manjericão.';
      }
    }

    if (cultura == 'Agrião') {
      if (solo < 70) {
        return 'O agrião precisa de mais umidade no solo.';
      }

      if (luminosidade < 40) {
        return 'O agrião está recebendo pouca luz.';
      }

      if (temperatura > 24) {
        return 'A temperatura está alta para o agrião.';
      }
    }

    if (cultura == 'Cenoura') {
      if (solo < 40) {
        return 'O solo está seco. A cenoura precisa de mais água.';
      }

      if (luminosidade < 50) {
        return 'A cenoura está recebendo pouca luminosidade.';
      }

      if (temperatura > 25) {
        return 'A temperatura está alta para a cenoura.';
      }
    }

    return 'Tudo certo! As condições estão adequadas para esta cultura. ✅';
  }
}