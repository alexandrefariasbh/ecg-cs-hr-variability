%% Código de Compressed Sensing - Métodos tradicionais
% OMP, BP, COSAMP, IRLS, SP e BSBL_FM
% 100,101,102,107,109,111,115,117,118,119
% CRs: 10,20,30,40,50,60,70,80,90

clear all,close all;clc
%% 

N=1024;                          %Numero de amostras do sinal original
load('BernoulliSample.mat');     %Matriz de medição (1024 x 1024)
%num_algoritmo = 1; %Escolher algoritmo
num_ECG = 30;     %Buscar o ECG na pasta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k = 100;
erro = zeros(N,k);
sinal = zeros(N,k);
reco = zeros(N,k);
NMSE = zeros(1,k);
PRD =  zeros(1,k);
SNR =  zeros(1,k);

tic
for num_algoritmo = 1:6
    for i = 1:k
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %fprintf('Carregar ECG MIT %d\n',num_ECG);  %Carregar o arquivo do ECG  
        %ECG = cell2mat(struct2cell(load('119.mat')));
        %ECG = double(ECG(1:1024));
        %x = ECG';          %Sinal ECG original
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %fprintf('Carregar ECG %d BPM\n',num_ECG);  %Carregar o arquivo do ECG
        ECG = cell2mat(struct2cell(load('ECG_30.mat'))); 
        idx = randperm(length(ECG), N);    % índices aleatórios exclusivos
        ECG = ECG(idx);                    % seleção das amostras
        x = 100*(ECG);          %Sinal ECG original
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %Compressão
        CR = 10;                         %CR = N-M/N *100% (taxa de compressão)
        M = fix((1-CR/100)* N);          %Número de amostras do sinal comprimido - representa (100 - CR) dos dados
                                         %fix(x) arredonda o número para o inteiro mais próximo de 0
        Phi = BernoulliSample(1:M,:);    %Matriz de medição

        y = Phi*x;                 %Sinal ECG comprimido                                             
        [ww] = dwtmtx( N,'db2',5); %A = dftmtx(n) returns the n-by-n complex matrix, where y = A*x is the same as y = fft(x)
        Psi = [ww];                %Base do dicionário                                   
        T = Phi*Psi';              %Não entendi isso ainda

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
                 blkLen = 30;
                 % the user-defined block partition
                 groupStartLoc = 1:blkLen:N;
                 hat_s = BSBL_FM(T,y,groupStartLoc,99,'epsilon',1e-4,'learnType',0,'verbose',0);
                 hat_x = real(Psi'*hat_s.x);
        end
        
        %Métrica de desempenho
        erro(:,i)  = erro(:,(i)) + (x-hat_x);                  %Erro absoluto e = x - xc
        NMSE(i) = NMSE(i)+ (norm(x-hat_x)/norm(x));            %Calcular o Normalized Mean Square Error
        PRD(i)  = PRD(i) + ((norm(x-hat_x)/norm(x))*100);      %Cálcular o PRD = ||x-xc|| / ||x|| * 100
        SNR(i)  = SNR(i) + (10*log10(norm(x)/norm(x-hat_x)));  %Signal-to-Noise Ratio (SNR)
    end
    %Calcular as médias e desvio padrão
    M_erro = mean(erro,2); D_erro = std(erro,0,2);
    M_NMSE = mean(NMSE); D_NMSE = std(NMSE);
    M_PRD = mean(PRD); D_PRD = std(PRD);
    M_SNR = mean(SNR); D_SNR = std(SNR);
    
    fprintf('---------------------------------');
    fprintf('\nDesempenho do Método %s:', algo);
    fprintf('\nCR = %2.0f%%', CR);
    fprintf('\nPRD = %f%%', M_PRD);
    fprintf('\nSNR = %fdB', M_SNR);
    fprintf('\nNMSE = %f', M_NMSE);
    fprintf('\n');
    fprintf('\nSTD PRD = %f', D_PRD);
    fprintf('\nSTD SNR = %f', D_SNR);
    fprintf('\nSTD NMSE = %f', D_NMSE);
    fprintf('\n---------------------------------\n');    
end 
toc
%%