%% Código de Compressed Sensing - Métodos tradicionais
% OMP, BP, COSAMP, IRLS, SP e BSBL_FM

clear all,close all;

%% 
N=1024; %Numero de amostras do sinal original
load('BernoulliSample.mat'); %Matriz de medição (1024 x 1024)
%Compressão
for num_CR=10:10 % 50 de compressão
    fprintf('>> %d \n',num_CR)
    M=fix((1 - num_CR*5*0.01)* N); %Número de amostras do sinal comprimido 
    Phi=BernoulliSample(1:M,:);    %Matriz de medição
   
    %Phi=BernoulliMtx( M,N );        
         for num_algo=2:2
                   fprintf('> %d - %d \n',num_CR,num_algo)
                   toc_sum = 0;
                   PRD_sum = 0;
                   for num_ECG = 2:2
                            
                            fprintf('loading ECG%d\n',num_ECG)
                            ecgstr = ['ecg',num2str(num_ECG)];       %Carregar o arquivo do ECG               
                            
                            x = cell2mat(struct2cell(load(ecgstr))); %Sinal ECG original
                            y = Phi*x;                               %Sinal ECG comprimido                                             
                            [ww]=dwtmtx( N,'db2',5); %A = dftmtx(n) returns the n-by-n complex matrix, where y = A*x is the same as y = fft(x)
                            Psi=[ww];                %Base do dicionário                                   
                            T=Phi*Psi';              %Não entendi isso ainda
                            
                            tic %Início da contagem de tempo
                            
                            %Reconstrução
                                        switch num_algo
                                            case 1
                                                 algo = 'OMP';
                                                 hat_s=cs_omp(y,T,N);
                                                 hat_x=real(Psi'*hat_s.');                  
                                            case 2
                                                algo = 'BP';
                                                hat_s=cs_bp(y,T,N);    
                                                hat_x=real(Psi'*hat_s);        
                                            case 3
                                                 algo = 'COSAMP';
                                                 hat_s=cs_cosamp(y,T,N);
                                                 hat_x=real(Psi'*hat_s.');         
                                            case 4
                                                 algo = 'IRLS';
                                                 hat_s=cs_irls(y,T,N);  
                                                 hat_x=real(Psi'*hat_s);       
                                            case 5
                                                 algo = 'SP';
                                                 hat_s=cs_sp(y,T,N); 
                                                 hat_x=real(Psi'*hat_s.');   
                                            %case 6
                                                 %algo = 'BSBL_FM';
                                                 %blkLen = 192;
                                                 % the user-defined block partition
                                                 %groupStartLoc = 1:blkLen:N;
                                                 %hat_s = BSBL_FM(T,y,groupStartLoc,99,'epsilon',1e-4,'learnType',0,'verbose',0);
                                                 %hat_x=real(Psi'*hat_s.x);
                                        end
                            time_end=toc;               %Fim da contagem de tempo
                            toc_sum=toc_sum+time_end;   %Tempo total de processamento
                            
                            %Métrica de desempenho
                            PRD=norm(x-hat_x)/norm(x)*100; 
                            PRD_sum=PRD_sum+PRD;           
                            
                            %Plotar ECG's
                            clf; %Limpar as figuras existentes
                            plot(x+1,'k','linewidth',1)            %Sinal original
                            hold on
                            plot((hat_x-0.15),'r','linewidth',1)   %Sinal original
                            plot((x-hat_x-0.9),'b', 'LineWidth',1) %Erro de reconstrução
                            legend('ECG Original','ECG Reconstruído','Erro')
                            set(gca,'xlim',[0 1024])
                            xlabel('Samples');
                            ylabel('Volts');
                            title('Resultados');
                            %suptitle(['CS ECG_CF- Wavelet ' wtype,'......', ' CR ',num2str(round(CR,0)),'% ','......',' PRD ',num2str(round(PRD,1))] );

                   end
                    %fprintf('>??????%d-????%d?????????? \n',num_CR,num_algo)
                    PRD_aver=PRD_sum/num_ECG;
                    time_aver=toc_sum/num_ECG;
                    
                    fprintf('Processando Método %s: \nCR=%2.0f%% \nPRD=%f \nTaver=%f \nsnr=%f \nMSE=%f... Wavelet %s\n',algo,M/N*100,PRD_aver, time_aver);
                    
                    A(num_algo,num_CR)=PRD_aver;
                    B(num_algo,num_CR)=toc_sum;
         end
         
         fprintf('\n>>%d \n',num_CR)
end
%%