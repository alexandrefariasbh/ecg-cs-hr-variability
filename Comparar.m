%% Comparar os sinais 
%MIT x ARTIFICIAIS
close all,clear all,clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_ECG1 = 111;     %Buscar o ECG na pasta
fprintf('Carregar ECG MIT%d\n',num_ECG1);  %Carregar o arquivo do ECG  
ECG1 = cell2mat(struct2cell(load('111.mat')));
ECG1 = double(ECG1(1:1024));
ECG1 = normalize(ECG1,'range');% normalizar sinais
x1 = ECG1';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_ECG2 = 120;     %Buscar o ECG na pasta
fprintf('Carregar ECG %d BPM\n',num_ECG2);  %Carregar o arquivo do ECG
ECG2 = cell2mat(struct2cell(load('ECG_120.mat'))); 
ECG2 = double(ECG2(1:1024));
ECG2 = normalize(ECG2,'range'); % normalizar sinais
x2 = (ECG2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Time = cell2mat(struct2cell(load('Time.mat'))); 
Time = double(Time(1:1024)); %Tempo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(Time,x1,'r')  %Sinal original
hold on
plot(Time,x2,'b')  %Erro de reconstrução
legend('MIT 111','ECG 120 BPM')
set(gca,'xlim',[0 2.8],'ylim',[-0.2 1.2])
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
titulo = sprintf('Comparação entre os sinais');
title(titulo);
