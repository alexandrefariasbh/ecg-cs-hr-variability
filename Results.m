%% Compressed Sensing - Comparaçao entre os métodos
% Comparação de valores PRD em diferentes CRs
% PRD = 9% é o indicativo de bom
% OMP, BP, COSAMP, IRLS, SP e BSBL_FM
close all, clear all, clc
% --------------------------------------------------------------
fprintf('Carregar sinal ECG\n')   %Carregar o arquivo do ECG 
ECG = cell2mat(struct2cell(load('117.mat')));
ECG = double(ECG(1:1024));

figure(1)
plot(ECG+300,'r')  %Sinal original
set(gca,'xlim',[0 1024])
xlabel('Amostras');
ylabel('Amplitude (V)');
titulo = sprintf('ECG MIT 117');
title(titulo);
% --------------------------------------------------------------
CR = [10 20 30 40 50 60 70 80 90];
OMP = [0.828218 1.507702 1.817786 2.355695 2.725323 3.213812 4.201297 6.793330 114.928456];
BP = [1.118384 2.035244 2.679346 4.872576 5.075624 7.477639 12.723521 33.215235 87.537932];
COSAMP = [1.290479 1.546885 1.793203 2.243666 2.708545 3.183151 3.717019 8.381033 113.271591];
IRLS = [0.515495 0.983009 1.346942 2.033419 2.331993 3.216563 5.346389 13.327263 87.057856];
SP = [1.419832 1.623698 1.923407 2.348459 2.391834 3.155938 3.376440 7.215951 109.955403];

figure(2)
plot(CR,OMP,'-*')
hold on
plot(CR,BP,'-O')
hold on
plot(CR,COSAMP,'-GS')
hold on
plot(CR,IRLS,'-x')
hold on
plot(CR,SP,'-d')
hold on
xlabel('CR(%)');
ylabel('PRD(%)'); 
x = [10 90];
y = [9 9];
line(x,y,'Color','red','LineStyle','--','LineWidth',0.75)
escala = [0 2 4 6 8 10 12 14 16 18 20]; % Valores desejados para o eixo y
yticks(escala)
axis([10 90 0 20])  
title('Comparação de valores PRD em diferentes CRs');
legend('OMP','BP','COSAMP','IRLS','SP','PRD=9%');

