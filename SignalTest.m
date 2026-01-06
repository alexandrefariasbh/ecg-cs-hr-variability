%% Gerar um sinal ECG de amostragem em 360Hz
% Parâmetros do sinal ECG
frequencia_cardiaca = 60;  % Frequência cardíaca em batimentos por minuto
duracao = 10;              % Duração do sinal em segundos
frequencia_amostragem = 360;  % Frequência de amostragem em Hz

% Conversão da frequência cardíaca para frequência em Hz
frequencia = frequencia_cardiaca / 60;

% Número de pontos no sinal
num_pontos = duracao * frequencia_amostragem;

% Tempo do sinal ECG
tempo = linspace(0, duracao, num_pontos);

% Geração do sinal ECG usando funções senoidais
componente_p = 0.1*sin(2*pi*frequencia*tempo + 0.2*pi);  % Onda P com menor amplitude e deslocamento de fase
componente_qrs = 0.7*sin(2*pi*frequencia*tempo + pi/3);  % Complexo QRS com maior amplitude
componente_t = 0.2*sin(2*pi*frequencia*tempo + 0.5*pi) + 0.1*sin(2*pi*frequencia*tempo + pi);  % Onda T com duas componentes e diferentes amplitudes

% Adição dos picos do ECG
pico_r = 0.9*max(componente_qrs)*sin(2*pi*frequencia*tempo + 0.9*pi);  % Pico R
ponto_s = -0.3*max(componente_qrs)*sin(2*pi*frequencia*tempo + 0.7*pi);  % Ponto S
ponto_t = 0.5*max(componente_t)*sin(2*pi*frequencia*tempo + 0.6*pi);  % Ponto T

% Sinal ECG completo
sinal_ecg = componente_p + componente_qrs + componente_t + pico_r + ponto_s + ponto_t;

% Adição de ruído ao sinal ECG
ruido = 0.05*randn(size(tempo));  % Ruído gaussiano com amplitude 0.05
sinal_ecg = sinal_ecg + ruido;
ECG = sinal_ecg(1:1024);
t = 1:1024;

% Plot do sinal ECG
plot(t, ECG);
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Sinal ECG');
