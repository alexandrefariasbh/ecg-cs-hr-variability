%% Código de Compressed Sensing - Métodos tradicionais
% OMP, BP, COSAMP, IRLS, SP e BSBL_FM
% 100,101,102,107,109,111,115,117,118,119
% CRs: 10,20,30,40,50,60,70,80,90

clear all,close all;clc;
%% 

N=1024;                          %Numero de amostras do sinal original
load('BernoulliSample.mat');     %Matriz de medição (1024 x 1024)

%Compressão
CR = 50;                         %CR = N-M/N *100% (taxa de compressão)
M = fix((1-CR/100)* N);          %Número de amostras do sinal comprimido - representa (100 - CR) dos dados
                                 %fix(x) arredonda o número para o inteiro mais próximo de 0
Phi = BernoulliSample(1:M,:);    %Matriz de medição

num_algoritmo = 3; %Escolher algoritmo
num_ECG = 30;     %Buscar o ECG na pasta

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fprintf('Carregar ECG%d\n',num_ECG)      %Carregar o arquivo do ECG  
%ecgstr = ['ecg',num2str(num_ECG)];  
%x = cell2mat(struct2cell(load(ecgstr))); %Sinal ECG original
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fprintf('Carregar nosso ECG 360 Hz\n')   %Carregar o arquivo do ECG 
%ECG = cell2mat(struct2cell(load('ECG_360Hz.mat')));
%ECG = double(ECG(1:1024));
 %ECG = normalize(ECG,'range');      % normalizar sinais
 %idx = randperm(length(ECG), N);    % índices aleatórios exclusivos
 %ECG = ECG(idx);                    % seleção das amostras
%x = ECG';         %Sinal ECG original (nosso)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fprintf('Carregar ECG MIT%d\n',num_ECG);  %Carregar o arquivo do ECG  
%ECG = cell2mat(struct2cell(load('102.mat')));
%ECG = double(ECG(1:1024));
%x = ECG';          %Sinal ECG original
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = 100;
erro = zeros(N,k);
sinal = zeros(N,k);
reco = zeros(N,k);
NMSE = zeros(1,k);
PRD =  zeros(1,k);
SNR =  zeros(1,k);

for i = 1:k
    
    %fprintf('Carregar ECG %d BPM\n',num_ECG);  %Carregar o arquivo do ECG
    ECG = cell2mat(struct2cell(load('ECG_30.mat'))); 
    idx = randperm(length(ECG), N);    % índices aleatórios exclusivos
    ECG = ECG(idx);                    % seleção das amostras
    x = 100*(ECG);          %Sinal ECG original


    y = Phi*x;                 %Sinal ECG comprimido                                             
    [ww] = dwtmtx( N,'db2',5); %A = dftmtx(n) returns the n-by-n complex matrix, where y = A*x is the same as y = fft(x)
    Psi = [ww];                %Base do dicionário                                   
    T = Phi*Psi';              %Não entendi isso ainda
                           
    tic %Início da contagem de tempo
    %Reconstrução
    switch num_algoritmo
        case 1
            algo = 'OMP';
            hat_s = cs_omp(y,T,N);
            hat_x = real(Psi'*hat_s.');                  
        case 2
             algo = 'BP';
             hat_s = cs_bp(y,T,N);    
             hat_x = real(Psi'*hat_s);        
        case 3
             algo = 'COSAMP';
             hat_s = cs_cosamp(y,T,N);
             hat_x = real(Psi'*hat_s.');         
        case 4
             algo = 'IRLS';
             hat_s = cs_irls(y,T,N);  
             hat_x = real(Psi'*hat_s);       
        case 5
             algo = 'SP';
             hat_s = cs_sp(y,T,N); 
             hat_x = real(Psi'*hat_s.');   
        case 6
             % Olha mais a fundo https://github.com/liubenyuan/BSBL-FM
             algo = 'BSBL_FM';
             blkLen = 30; %34 %62 %30
             groupStartLoc = 1:blkLen:N;
             hat_s = BSBL_FM(T,y,groupStartLoc,99,'epsilon',1e-4,'learnType',0,'verbose',0);
             hat_x = real(Psi'*hat_s.x);
        case 7 
             algo = 'BSBL_BO';
             blkLen = 16;                % 32 tbm the block size in the user-defined block partition
             groupStartLoc = 1:blkLen:N;
             hat_s = BSBL_BO(Phi,y,groupStartLoc,1,'learnType',0);
             hat_x = real(Psi'*hat_s.x);
             %blkStartLoc = 1:blkLen:N;   % user-defined block partition
             %hat_s = BSBL_BO(Phi, y, blkStartLoc, 2); 
             %hat_x = real(Psi'*hat_s.x);
    end

    sinal(:,i) = sinal(:,(i))+ x;                          %Sinal Original
    reco(:,i)  = reco(:,(i)) + hat_x;                      %Sina Reconstruído
    
    %Métrica de desempenho
    erro(:,i)  = erro(:,(i)) + (x-hat_x);                  %Erro absoluto e = x - xc
    NMSE(i) = NMSE(i)+ (norm(x-hat_x)/norm(x));            %Calcular o Normalized Mean Square Error
    PRD(i)  = PRD(i) + ((norm(x-hat_x)/norm(x))*100);      %Cálcular o PRD = ||x-xc|| / ||x|| * 100
    SNR(i)  = SNR(i) + (10*log10(norm(x)/norm(x-hat_x)));  %Signal-to-Noise Ratio (SNR)
end

%Calcular as médias e desvio padrão
M_sinal = normalize(mean(sinal,2),'range');
M_reco = normalize(mean(reco,2),'range');
M_erro = M_sinal - M_reco; %mean(erro,2);
M_NMSE = mean(NMSE);
M_PRD = mean(PRD);
M_SNR = mean(SNR);

x = normalize(x,'range');
hat_x = normalize(hat_x,'range');
    
%Plotar ECG's
clf; %Limpar as figuras existentes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Time = cell2mat(struct2cell(load('Time.mat'))); 
Time = double(Time(1:1024)); %Tempo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,1)
plot(x ,'r')  %Sinal original
hold on
plot(hat_x ,'b')        %Sinal reconstruido
legend('Original Signal','Reconstructed Signal');
ylabel('Amplitude (V)');
set(gca,'xlim',[0 1024]);
titulo = sprintf('CR = %2.0f%%', CR);
title(titulo);

subplot(2,1,2)
plot(M_erro,'k')           %Erro de reconstrução
set(gca,'xlim',[0 1024]);
xlabel('Time (s)');
ylabel('Error (V)');

fprintf('---------------------------------');
fprintf('\nDesempenho do Método %s:', algo);
fprintf('\nCR = %2.0f%%', CR);
fprintf('\nPRD = %f%%', M_PRD);
fprintf('\nSNR = %fdB', M_SNR);
fprintf('\nNMSE = %f', M_NMSE);
fprintf('\n---------------------------------\n');

%%