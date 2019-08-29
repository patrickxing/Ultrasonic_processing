%% This function is used to get vp and vs for big GCTS machine
function [time_ult,time_p_cutAdd,time_s_cutAdd]=ult_bigGCTS(fileName_ult,time_ST,time_END)
time_ult=[];
time_p_cutAdd=[];
time_s_cutAdd=[];
%%

 [~,~,co_1]=xlsread(fileName_ult,1,'A1:A1000');

% find the cell match 'P wave Time' 
 for ii=1:1000     
     if (strcmp(co_1{ii}, 'P Wave Time'))
         ST_mark=ii;
         break
     end        
 end
 
 % find the last cell contain data
  [data_1,~,]=xlsread(fileName_ult,1,'A:A');
  cell_last=ST_mark+1+length(data_1);
  % find the recording time
 time_mark=ST_mark-9;
 time_1=xlsread(fileName_ult,1,strcat(num2str( time_mark),':',num2str( time_mark)));
 time=time_1(1:2:end);

 
 % find the data at the beginning of loading
 for jj=1:length(time)
     if (time(jj)>time_ST)
         ult_st=jj;
         break
     end
 end
 
  % find the data at the end of loading
 for jj=1:length(time)
     if (time(jj)>time_END)
         ult_END=jj-1;
         break
     end
 end
  
 % find the coloumn size of the data
 column_size=length(time_1)+3;
 
 % read all the data
 data_all=xlsread(fileName_ult,1,strcat('A',num2str(ST_mark),':','EZ',num2str(cell_last)));

 %data_all=xlsread(fileName_ult,1,strcat('A',num2str(ST_mark),':',ExcelCol(column_size),num2str(cell_last)));
 
 % find the ultrasonic start time to plot
 time_p=data_all(:,1);
 time_s=data_all(:,2);
 time_p_cut=time_p(400:end);
 time_s_cut=time_s(400:end);
 
 % find the time of deviatoric stress
 time_ult=time(ult_st:ult_END);
 %% plot the ult data
fig_p=figure('Name',strcat(fileName_ult,'P wave'),'NumberTitle','off');
 for kk=1:ult_END-ult_st+1
     mm=2+(ult_st-1+kk-1)*2+1;
     volt_p=data_all(:,mm)-(kk-1)*2;
     % plot P wave
     %height_min=-(kk-1)*2+0.3;
     height_min=-(kk-1)*2+1.0;
     volt_p_cut=volt_p(400:end);
     [pks,locs]=findpeaks(volt_p_cut,time_p_cut,'MinPeakDistance',4,'MinPeakHeight',height_min);
     plot(time_p_cut,volt_p_cut)
     hold on
     plot(locs(1),pks(1),'o')
     hold on
     time_p_cutAdd(kk,1)=locs(1);
 end
title('P wave')
xlabel('Time (micro sec)')
ylabel('volts')
savefig(strcat(fileName_ult,'P wave.fig'))

% dcm_obj = datacursormode(fig_p);
%     set(dcm_obj,'DisplayStyle','datatip',...
%     'SnapToDataVertex','off','Enable','on')
% 
% w = waitforbuttonpress;
% c_info_p = getCursorInfo(dcm_obj);


 %% plot S wave
     
 fig=figure('Name',strcat(fileName_ult,'S wave'),'NumberTitle','off');
 for kk=1:ult_END-ult_st+1
     mm=2+(ult_st-1+kk-1)*2+1;
     %velocity_p=data_all(:,mm)-(kk-1)*2;
     volt_s=data_all(:,mm+1)-(kk-1)*2;
     
     volt_s_cut=volt_s(400:end);
     %height_min=-(kk-1)*2+0.4; % for the usual setting
     %height_min=-(kk-1)*2+1.0;
     if kk>4
         height_min=-(kk-1)*2+0.8;
     else
         height_min=-(kk-1)*2+0.5;
     end
     % plot P wave
     [pks,locs]=findpeaks(volt_s_cut,time_s_cut,'MinPeakDistance',4,'MinPeakHeight',height_min);
     for xx=1:length(volt_s_cut)
         if(time_s_cut(xx)>locs(1) && volt_s_cut(xx)<-(kk-1)*2-0.15)
             break
         end
     end
     plot(time_s_cut,volt_s_cut)
     hold on
     plot(time_s_cut(xx),volt_s_cut(xx),'o')
     hold on
     time_s_cutAdd(kk,1)=time_s_cut(xx);     
 end
title('S wave')
xlabel('Time (micro sec)')
ylabel('volts')
savefig(strcat(fileName_ult,'S wave.fig'))

end

