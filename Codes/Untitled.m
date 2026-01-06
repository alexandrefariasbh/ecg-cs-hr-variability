% Dados de exemplo para o sinal
x = linspace(0, 2*pi, 100);
sinal = sin(x);

% Dados de exemplo para o erro
erro = randn(size(x));  % Ruído aleatório

% Criar uma figura e ajustar o tamanho da figura
%figure('Position', [100, 100, 800, 600]);

% Plotar o sinal na parte superior e ajustar o tamanho do subplot
subplot('Position', [0.1, 0.50, 0.8, 0.35]);
plot(x, sinal, 'b-', 'LineWidth', 2);
title('Sinal');
ylabel('Amplitude');

% Plotar o gráfico de erro embaixo e ajustar o tamanho do subplot
subplot('Position', [0.1, 0.15, 0.8, 0.25]);
plot(x, erro, 'r-', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Erro');
