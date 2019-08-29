%% This code is written by Pengju Xing 04/18/2018
% It is designed to processing the ultrasonic data from the big GCTS
% machine
clc
clear
sheet=2;
%
% for old end cap
% time_cap_P=26.54; % This is for the old end cap
% time_cap_S=48.19; % This is for the old end cap

% for mixed end cap
time_cap_P=35.74; % This is for the old end cap
time_cap_S=56.64; % This is for the old end cap
%% 

% get the ult file name
%targetFolder='C:\Users\pengju.xing\Documents\MATLAB\GCTS\New GCTS\Huntley and huntley\TXC_raw';
targetFolder='C:\Users\xingp\Documents\MATLAB\WDVGWork\ULT_bigGCTS\material';
d = uigetdir(pwd, targetFolder);
files_ult = dir(fullfile(d, '*.csv'));
files_txc = dir(fullfile(d, '*.xlsx'));
cd(targetFolder)
%%
file_Number=size(files_ult);

tic 

%for jj=1:file_Number(1)
jj=1;
    sd_ult=[];
    pc_ult=[];
    sigma_eff=[];
    vp=[];
    vs=[];
    fileName_ult=files_ult(jj).name;
    fileName_TXC=files_txc(jj).name;
     % find the start and end time
    time_txc=xlsread(fileName_TXC,1, strcat('A21',':A20000'));
    sd_txc=xlsread(fileName_TXC,1, strcat('H21',':H20000'));
    sample_len=xlsread(fileName_TXC,1, 'B4');
    [time_ST,time_END]=time_find(time_txc,sd_txc);

    [time_ult,time_p_cutAdd,time_s_cutAdd]=ult_bigGCTS(fileName_ult,time_ST,time_END);
%%
    time_p_cutAddM=time_p_cutAdd-time_cap_P;
    time_s_cutAddM=time_s_cutAdd-time_cap_S;
    vp=sample_len/12./(time_p_cutAddM*1e-6);
    vs=sample_len/12./(time_s_cutAddM*1e-6);

    % get the velocity 

    len=length(time_ult);
    for kk=1:len   
        [d,ix]=min(abs(time_txc-time_ult(kk)));
        sd_ult(kk,1)=sd_txc(ix);  
        pc_ult(kk,1)=2500;
        sigma_eff(kk,1)=(sd_ult(kk)+3*pc_ult(kk))/3;
    end

         xlswrite(fileName_TXC,sd_ult,sheet,'BH21')
         xlswrite(fileName_TXC,pc_ult,sheet,'BI21')
         xlswrite(fileName_TXC,sigma_eff,sheet,'BJ21')
         xlswrite(fileName_TXC,vp,sheet,'BL21')
         xlswrite(fileName_TXC,vs,sheet,'BM21')
     
%end





