% view events correlation
% 相关系数 Bz Bz

%%

clc;
clear all;
close all;
load("E:\learning\kjtq\research\1415\1415data\BVDAF1415.mat");
AE = BVDAF1415(:,4);
Bz = BVDAF1415(:,1);
AE(AE>1500)=NaN;
Bz(Bz>50)=NaN;

times = xlsread('E:\learning\kjtq\research\1415\AE_flux\views.xlsx','sheet1');  
times = times(1:17,2:3);

num = 5;
Ts = times(num,1);
Te = times(num,2);
%%

%截取时间平移
g=12*72;  %时间平移范围个5min数 

en=Te-Ts-g;  %进行平移的数据量 en+g*d<e-s

A = Bz(Ts:Te,1);  ff = AE(Ts:Te,1);  AA = A(1:en,1);
[ttf,rrf] = corr(g,en,ff,AA);   %调用函数

%求出峰值
if abs(min(rrf)) < max(rrf)
    [x,y]=find(rrf==max(max(rrf)));
else
    [x,y]=find(rrf==min(min(rrf)));
end

rmins = 1.2 * min(rrf);
rmaxs = 1.2 * max(rrf);
Time = ttf(x,y);               % Time = 相关系数最大的一天
Correlation = rrf(x,y);

figure;
subplot(3,1,1);
set(gcf,'position',[100 100 1000 600]);
plot(ttf,rrf)
xlabel("响应时间/h");
ylabel('Bz & AE  相关系数');
%title("Bz & AE  相关系数 相应时间--相关系数")
axis([0 g/12 rmins rmaxs]);

%插入峰值标记
line([Time Time],[0 Correlation],'linestyle','-', 'Color','r', 'LineWidth', 0.8);
line([0 g/2],[0 0],'linestyle','--', 'Color','k', 'LineWidth', 0.5);

hold on;
cnames= {'峰值','时间(h)'};
h_uitable=uitable('ColumnName',cnames);
table_data={Correlation,Time};
set(h_uitable,'data',table_data,'position',[750 515 150 39]);

%%
% 平移后的Bz-f
subplot(3,1,2);

if Time ==0
    f1 = AE(1:end,1);
else
    f1 = AE(Time*12:end,1);
end

figure_y1_y2(Bz,f1,Ts,Te);
title("AE时间平移后曲线");



%%
%未平移后的Bz-f
subplot(3,1,3);
figure_y1_y2(Bz,AE,Ts,Te);
title("AE—Bz 时间曲线");


% figure;
% scatter(Bz(Ts:Te),f1(Ts+Time*12:Te+Time*12),5);
% figure;
% scatter(Bz(Ts:Te),AE(Ts:Te),5);

























%%
% 相关系数求解
function [ttf,rrf] = corr(g,en,ff,AA)

rrf=[];
ttf=[];

for i=0:g
    a=1+i;
    b=en+i;
    f1=ff(a:b,1);
    
    com=[AA f1];
    com(isnan(com(:,1)),:)=[];
    com(isnan(com(:,2)),:)=[];
    A1=com(:,1);
    f1=com(:,2);
    
    matrix=corrcoef(A1,f1);
    r=matrix(1,2);
    rrf=[rrf;r];

    t=1/12*i;
    ttf=[ttf;t]; 
end
end



%%
%yy轴绘图

function figure_y1_y2(Bz,f,Ts,Te)

yyaxis left;
plot(Bz,'b');
ylabel('Bz nT');
Bzmax = 1.1 * max(Bz(Ts:Te,1));
axis([Ts Te -1.2*Bzmax Bzmax]);

hold on;
[pks,locs]=findpeaks(Bz,'minpeakdistance',36);
xi = 1:1:105120;    %创建插值道址，以1为最小间隔
yi = interp1(locs,pks,xi,'spline');   %插值
plot(xi,yi,'r');


yyaxis right;
plot(f,'k');
ylabel("f e/(cm^2-s-sr-keV");

set(gca, 'XTick',[0,8940,17004,25932,34572,43500,52140,61068,70596,78636,87564,96204,105120]);
set(gca, 'XTicklabel',{'14Jan','Feb','Mar','Apr','May','Jun','July','Agu','Sep','Oct','Nov','Dec','15Jan'}); 
hold on;
ts = changetime(Ts);
te = changetime(Te);
set(gca,'Xtick',[Ts,Te]);
set(gca, 'XTicklabel',{ts,te});

fmax = 3 * max(f(Ts:Te,1));
fmin = min(f(Ts:Te,1));
axis([Ts Te fmin fmax]);
hold on;
[pks2,locs2]=findpeaks(f,'minpeakdistance',36);
xi2 = 1:1:105120;    %创建插值道址，以1为最小间隔
yi2 = interp1(locs2,pks2,xi2,'spline');   %插值
plot(xi2,yi2,'r');

legend('Bz','AE','Bzpeaks','AEpeaks');

end




%%
%时间标记换算

function  sT = changetime(Ts)
Tn = [0,8940,17004,25932,34572,43500,52140,61068,70596,78636,87564,96204,105120];

k = 2;
while Ts > Tn(1,k)
        k = k + 1;
end
        month = k-1;
        day = floor( (Ts - Tn(1,k-1))/288 );
        hour = floor((Ts - Tn(1,k-1) - 288*day)/12);
        min = 5 * ( Ts - Tn(1,k-1) - 288*day - 12*hour);  
        
        sT = [num2str(month,'%02d') '-' num2str(day,'%02d') '  ' num2str(hour,'%02d') ':' num2str(min,'%02d')];
end




