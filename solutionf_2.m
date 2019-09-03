%%
%程序作用，通过观察AE值的变化及每日AE大小的扰动，选取出合适的平静期和活动期
%attention 这个程序是用f的差值进行求解的
%需要控制的，输入数据文件，name，dc，ds，de  
%%
%数据导入区
clc;
clear;
close;
load("C:\Users\many_\OneDrive\桌面\events\1415mins.mat");
%替换数据文件名 1516mins&h     1415mins

%%
%参数输入区
%需要输入的参数有
%事件编号
%AE曲线的横坐标范围dTs,dTe   
%平静期开始时间dc，活动期开始时间ds，活动期结束时间de       
%前缀d表示输入数据的单位是天，平静期区间是[dc,ds] 活动期区间是(ds,de]
%会自动换算为5mins计数时间  c是平静期那天的第一个数据，s是活动期开始的第一个数据，e是活动期结束的最后一个数据

%事件编号
name='1516事件编号 NO.08';
 
% time=(day-1)*288+1;
dc=285;  % calm time
ds=290; % start time
de=306;  % end time

%%
if dc>345
    dTs=dc-30;
    dTe=de+1;
elseif dc<20
        dTs=0;
        dTe=de+30;       
else
    dTs=dc-20;
    dTe=de+20;
end


%Time
Ts=288*(dTs-1)+1;
Te=288*(dTe-1)+1;
c=288*(dc-1)+1;
s=288*ds+1;
e=288*de;



%%
%程序区1-1 绘制AE曲线
figure;
subplot(4,1,1)
set(gcf,'position',[500 30 1000 750]);
plot(AE,'-k');
axis([Ts Te 0 1500]);
set(gca, 'XTick',[0,8940,17004,25932,34572,43500,52140,61068,70596,78636,87564,96204,105120]);
set(gca, 'XTicklabel',{'14Jan','Feb','Mar','Apr','May','Jun','July','Agu','Sep','Oct','Nov','Dec','15Jan'}); 
xlabel("时间（mins）");
ylabel('AE nT');
title(name)

% 点标记
% text(c,AE(c,1),'o','color','r')
% text(s,AE(s,1),'o','color','r')
% text(e,AE(e,1),'o','color','r')

%线标记
line([c c],[0 1500],'linestyle','-', 'Color','r', 'LineWidth', 0.5);
line([s s],[0 1500],'linestyle','-', 'Color','r', 'LineWidth', 0.5);
line([e e],[0 1500],'linestyle','-', 'Color','r', 'LineWidth', 0.5);

%%

%程序1-2 绘制electron flux曲线

subplot(4,1,2)
plot(f,'-k')
set(gca, 'XTick',[0,8940,17004,25932,34572,43500,52140,61068,70596,78636,87564,96204,105120]);
set(gca, 'XTicklabel',{'14Jan','Feb','Mar','Apr','May','Jun','July','Agu','Sep','Oct','Nov','Dec','15Jan'}); 
fmax=4000;
axis([Ts Te 0 fmax]);
ylabel("f e/(cm^2-s-sr-keV");
ylabel('475keV e/(cm^2-s-sr-keV)');
%title('GOES15 EPS-MAGED>Energetic Particle Sensor - Magnetospheric Electron Detector' );

line([c c],[1 fmax],'linestyle','-', 'Color','r', 'LineWidth', 0.5);
line([s s],[1 fmax],'linestyle','-', 'Color','r', 'LineWidth', 0.5);
line([e e],[1 fmax],'linestyle','-', 'Color','r', 'LineWidth', 0.5);



%%
% 求差值扰动
% d=[];
% for i=1:364
%     t1=(i-1)*288+1;
%     t2=i*288;
%     t3=t1+288;
%     t4=t2+288;
%     delta=AE(t3:t4,2)-AE(t1:t2,2);
%     d=[d;delta];
% end

%%
%绘图区2 绘制AE扰动

%求扰动
error=[];
for i=0:364
    j=i*288+1;
    err = std (AE(j:j+287,1),1);
    error = [error;err];
end

%绘制扰动大小
t=1:365;
t=t';
subplot(4,1,3)
plot(t,error);
axis([dTs dTe 0 450]);
xlabel("时间(day)");
ylabel('扰动大小（标准差）');
%title("扰动值");
terror=[t error];

% text(dc,error(dc,1),'o','color','r')
% text(ds,error(ds,1),'o','color','r')
% text(de,error(de,1),'o','color','r')
line([dc dc],[0 450],'linestyle','-', 'Color','r', 'LineWidth', 0.5);
line([ds ds],[0 450],'linestyle','-', 'Color','r', 'LineWidth', 0.5);
line([de de],[0 450],'linestyle','-', 'Color','r', 'LineWidth', 0.5);






%%
%%
%%

%%
%程序区3-1平静期AE平均值求解

cf(1:288,1)=0; %平静期AE值
%calm time AE   %cAE 
for m=dc:ds
    for n=1:288
        cf(n,1)=cf(n,1)+AE((m-1)*288+n,1);
    end
end
cf=cf/(ds-dc+1);    %平静期AE值的平均 


%%
%程序实现区3-2 活动期求解

ff=[];  %f活动期与平静期差值
for j=ds+1:de
    for i=1:288
        k=f((j-1)*288+i,1)-cf(i,1);
        ff=[ff;k];
    end
end
% 
% 
% 

%%
%参数
%截取时间平移
g=96;  %时间平移范围个数 
d=6;  %时间间隔多少个5min
en=288*(de-ds-2);  %进行平移的数据量 en+g*d<e-s


%%
%程序区4-时间平移及相关系数求解
%ff=f(s:e,1); %活动期对应electron flux值
A=AE(s:e,1);
A=A(1:en,1);
rrf=[];
ttf=[];

for i=0:g
    a=1+d*i;
    b=en+d*i;
    f1=ff(a:b,1);
    
    com=[A f1];
    com(isnan(com(:,1)),:)=[];
    com(isnan(com(:,2)),:)=[];
    A1=com(:,1);
    f1=com(:,2);
    
    matrix=corrcoef(A1,f1);
    r=matrix(1,2);
    rrf=[rrf;r];

    t=0.5*i;
    ttf=[ttf;t]; 
end

%求出峰值
[x y]=find(rrf==max(max(rrf)));
Time=ttf(x,y);
Correlation=rrf(x,y);

if min(rrf)<0
    min=min(rrf)-0.01;
else
    min=0;
end



%绘制曲线
subplot(4,1,4);
%set(gcf,'position',[300 480 1000 300]);
plot(ttf,rrf)
xlabel("响应时间/h");
ylabel('electron flux & AE 相关系数');
%title("electron flux & AE 相应时间--相关系数")
axis([0 g/2 min Correlation+0.05]);

%插入峰值标记
line([Time Time],[0 Correlation],'linestyle','-', 'Color','r', 'LineWidth', 0.8);
line([0 g/2],[0 0],'linestyle','--', 'Color','k', 'LineWidth', 0.5);
%text(Time,Correlation,'o','color','r');

%%
%程序区5-插入说明表格
cnames= {'daycalm','daystart','dayend','数据量','响应峰值','响应时间(h)'};
h_uitable=uitable('ColumnName',cnames);
table_data={dc,ds,de,en/288,Correlation,Time};
%uit.Position = [0.73,0.22,0.8,0.7];
set(h_uitable,'data',table_data,'position',[513 9 393 45]);








