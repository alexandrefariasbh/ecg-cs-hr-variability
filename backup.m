%% 1.18  ??????????????
%????5??????????????????
%????????????????db2???????????????????????? 
%19????????  ??100??ECG????????????

%% Matriz de Bernoulli
%Phi = randi([0,1],M,N);%If your MATLAB version is too low,please use randint instead
%Phi(Phi==0) = -1;

clear all,close all, clc;
%%                                
N=1024;   
load('BernoulliSample.mat');   %???????????????????? 1024*1024
for num_CR=12:12         %19??CR
    fprintf('>>??????%d??????????\n',num_CR)
    M=fix((1-num_CR*5*0.01)*N);             %????CR??????????  CR??95%??90% ~ 5%??????M=972??921~51   
    Phi=BernoulliSample(1:M,:);                %????CR??????????????M??????????????????M*N
   % Phi=BernoulliMtx( M,N );        
         for num_algo=6:6       % 5?????????? 
                   fprintf('>??????%d-????%d??????????\n',num_CR,num_algo)
                   toc_sum=0;      %????????????
                   PRD_sum=0;       %??????????  ????????????????????????CR??  ??100????????????????????
                    for num_ECG=103:103;    %100??ECG
                            fprintf('loading ECG%d\n',num_ECG)
                            ecgstr=['ecg',num2str(num_ECG)];                 
                            x=cell2mat(struct2cell(load(ecgstr)));        %????????????ecg  ??ecg1~ecg100
                            y=Phi*x;                                                     
                            [ww]=dwtmtx( N,'db2',5);     %??????????
                            Psi=[ww];                                  
                            T=Phi*Psi'; 
                            tic       %????????   ????????????
                                        switch num_algo                                         %????????????  K????
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
                                            case 6
                                                algo = 'BSBL_BO';
                                                blkLen = 16;
                                                % the user-defined block partition
                                                groupStartLoc = 1:blkLen:N;
                                                %hat_s = BSBL_FM(T,y,groupStartLoc,99,'epsilon',1e-4,'learnType',0,'verbose',0);
                                                hat_s = BSBL_BO(Phi,y,groupStartLoc,1,'learnType',0);
                                                %(Phi, y, blkStartLoc, LearnLambda, varargin)
                                                hat_x=real(Psi'*hat_s.x);
                                            case 7
                                                algo = 'BSBL_FM';
                                                blkLen = 4;
                                                % the user-defined block partition
                                                groupStartLoc = 1:blkLen:N;
                                                hat_s = BSBL_FM(T,y,groupStartLoc,99,'epsilon',1e-4,'learnType',0,'verbose',0);
                                                hat_x=real(Psi'*hat_s.x);
                                                
                                        end

                                time_end=toc;   %????????   ????????????
                                toc_sum=toc_sum+time_end;          %????????
                                PRD=norm(x-hat_x)/norm(x)*100;     %????????????
                                PRD_sum=PRD_sum+PRD;                %????????      
                                                                   
                    
                                %                             figure(num_ECG)
                                clf;
                               
                                plot(x+1,'k','linewidth',1)
                                hold on

                                plot((hat_x-0.15),'r','linewidth',1)
                                plot((x-hat_x-2),'b', 'LineWidth',1)
                                set(legend('$\ {x(t)}$ ','$\hat{x}(t)$','Difference'),'Interpreter','Latex','FontSize', 10)
            
                                set(gca,'xlim',[0 1024])
                                xlabel('Samples');
                                ylabel('Volts');
%                                  suptitle(['CS ECG_CF- Wavelet ' wtype,'......', ' CR ',num2str(round(CR,0)),'% ','......',' PRD ',num2str(round(PRD,1))] );
                                 suptitle(['BSBL-BO  ', ' CR ',num2str(round(M/1024*100,0)),'% '] );


                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    end           %  100??ECG????????
%                     fprintf('>??????%d-????%d?????????? \n',num_CR,num_algo)
                    PRD_aver=PRD_sum/num_ECG;  %100??ECG????????????
                    time_aver=toc_sum/num_ECG;   %100??ECG????????????

                    
                     fprintf('Processing %s CR=%2.0f%% PRD=   %f    Taver= %f snr= %f MSE= %f... Wavelet %s \n',algo,M/N*100,PRD_aver, time_aver);

                    
                    
                    A(num_algo,num_CR)=PRD_aver;     %A?? ????????
                    B(num_algo,num_CR)=toc_sum;     %B?? ????????
                   
          end        %????????????????
          fprintf('>>??????%d?????????? \n',num_CR)
end          % 19??CR ????????
fprintf('>>>??????????????????????????????... \n')

xlswrite('algo_19CR_100ecg.xlsx',A,'Sheet1','B3');  %??????????????????????????
xlswrite('algo_19CR_100ecg.xlsx',B,'Sheet2','B3');  %??????????????????????????
fprintf('>>>>>>>> ????????????????<<<<<<<<\n')
sprintf('>>All Completed<<\n')