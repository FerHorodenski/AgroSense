#include "DHT.h"

#define DHTTYPE DHT11   // Troque para DHT22 se estiver usando DHT22

struct Cultura {
  String nome;
  int soloMin;
  int soloMax;
  int luzMin;
  int luzMax;
  float tempMin;
  float tempMax;
  float umidArMin;
  float umidArMax;
};

struct Canteiro {
  String nome;
  Cultura cultura;
  int pinoSolo;
  int pinoLuz;
  int pinoChuva;
  int pinoDHT;
};

// Culturas cadastradas
Cultura manjericao = {"Manjericão verde", 45, 70, 60, 100, 18, 30, 40, 75};
Cultura cenoura    = {"Cenoura",          40, 65, 50, 90,  15, 25, 45, 80};
Cultura agriao     = {"Agrião",           70, 95, 40, 80,  10, 24, 60, 90};

// Canteiros
Canteiro canteiros[] = {
  {"Canteiro 1", manjericao, 32, 35, 13, 4},
  {"Canteiro 2", cenoura,    33, 36, 14, 16},
  {"Canteiro 3", agriao,     34, 39, 27, 17}
};

DHT dht1(4, DHTTYPE);
DHT dht2(16, DHTTYPE);
DHT dht3(17, DHTTYPE);

DHT* sensoresDHT[] = {&dht1, &dht2, &dht3};

int quantidadeCanteiros = 3;

// Ajuste conforme o seu sensor de solo
int valorSoloSeco = 3000;
int valorSoloMolhado = 1200;

int converterSoloParaPorcentagem(int leitura) {
  int porcentagem = map(leitura, valorSoloSeco, valorSoloMolhado, 0, 100);
  return constrain(porcentagem, 0, 100);
}

int converterLuzParaPorcentagem(int leitura) {
  int porcentagem = map(leitura, 4095, 0, 0, 100);
  return constrain(porcentagem, 0, 100);
}

String avaliarFaixa(float valor, float minimo, float maximo) {
  if (valor < minimo) return "BAIXO";
  if (valor > maximo) return "ALTO";
  return "OK";
}

void setup() {
  Serial.begin(115200);

  for (int i = 0; i < quantidadeCanteiros; i++) {
    pinMode(canteiros[i].pinoChuva, INPUT);
  }

  dht1.begin();
  dht2.begin();
  dht3.begin();

  Serial.println("AgroSense iniciado!");
}

void loop() {
  Serial.println();
  Serial.println("===== LEITURA DOS CANTEIROS =====");

  for (int i = 0; i < quantidadeCanteiros; i++) {
    Canteiro c = canteiros[i];

    int leituraSolo = analogRead(c.pinoSolo);
    int umidadeSolo = converterSoloParaPorcentagem(leituraSolo);

    int leituraLuz = analogRead(c.pinoLuz);
    int luminosidade = converterLuzParaPorcentagem(leituraLuz);

    int chuva = digitalRead(c.pinoChuva);

    float temperatura = sensoresDHT[i]->readTemperature();
    float umidadeAr = sensoresDHT[i]->readHumidity();

    Serial.println();
    Serial.println(c.nome + " - " + c.cultura.nome);

    if (isnan(temperatura) || isnan(umidadeAr)) {
      Serial.println("ERRO: sensor DHT não respondeu.");
      continue;
    }

    Serial.print("Umidade do solo: ");
    Serial.print(umidadeSolo);
    Serial.print("% - ");
    Serial.println(avaliarFaixa(umidadeSolo, c.cultura.soloMin, c.cultura.soloMax));

    Serial.print("Luminosidade: ");
    Serial.print(luminosidade);
    Serial.print("% - ");
    Serial.println(avaliarFaixa(luminosidade, c.cultura.luzMin, c.cultura.luzMax));

    Serial.print("Temperatura: ");
    Serial.print(temperatura);
    Serial.print(" °C - ");
    Serial.println(avaliarFaixa(temperatura, c.cultura.tempMin, c.cultura.tempMax));

    Serial.print("Umidade do ar: ");
    Serial.print(umidadeAr);
    Serial.print("% - ");
    Serial.println(avaliarFaixa(umidadeAr, c.cultura.umidArMin, c.cultura.umidArMax));

    Serial.print("Chuva: ");
    if (chuva == LOW) {
      Serial.println("CHOVENDO / sensor molhado");
    } else {
      Serial.println("Sem chuva");
    }
  }

  delay(5000);
}