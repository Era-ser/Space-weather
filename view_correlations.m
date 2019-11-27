% view events correlation

%%
clc;
clear all;
close all;
load("C:\Users\many_\OneDrive\Project_based_Learning\data\mat\restart.mat");

Ts = 96030;
Te = 102600;

%��ȡʱ��ƽ��
g=12*72;  %ʱ��ƽ�Ʒ�Χ��5min�� 
d=6;  %ʱ�������ٸ�
en=Te-Ts-g;  %����ƽ�Ƶ������� en+g*d<e-s

%%

A = AE(Ts:Te,1);
ff = f(Ts:Te,1);
AA = A(1:en,1);

[ttf,rrf] = corr(g,en,ff,AA);   
% R: what is ttf & rrf

%�����ֵ
[x,y]=find(rrf==max(max(rrf)));
Time=ttf(x,y);               % Time = ���ϵ������һ��
Correlation=rrf(x,y);

if min(rrf)<0
    mins=min(rrf)-0.01;
else
    mins=0;
end

% if Time ==0
%     Time = 1;
% end

figure;
subplot(3,1,1);
set(gcf,'position',[100 100 1000 600]);
plot(ttf,rrf)
xlabel("��Ӧʱ��/h");
ylabel('electron flux & AE ���ϵ��');
%title("electron flux & AE ��Ӧʱ��--���ϵ��")
axis([0 g/12 mins Correlation+0.05]);

%�����ֵ���
line([Time Time],[0 Correlation],'linestyle','-', 'Color','r', 'LineWidth', 0.8);
line([0 g/2],[0 0],'linestyle','--', 'Color','k', 'LineWidth', 0.5);

hold on;
cnames= {'��ֵ','ʱ��(h)'};
h_uitable=uitable('ColumnName',cnames);
table_data={Correlation,Time};
set(h_uitable,'data',table_data,'position',[750 515 150 39]);

%%
% ƽ�ƺ��AE-f
subplot(3,1,2);

if Time ==0
    f1 = f(1:end,1);
else
    f1 = f(Time*12:end,1);
end

figure_AE_f(AE,f1,Ts,Te);
title("fluxʱ��ƽ�ƺ�����");

%%
%δƽ�ƺ��AE-f
subplot(3,1,3);
figure_AE_f(AE,f,Ts,Te);
title("flux AE ʱ������");

%%

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
function figure_AE_f(AE,f,Ts,Te)

yyaxis left;
plot(AE,'b');
ylabel('AE nT');
AEmax = 1.1 * max(AE(Ts:Te,1));
axis([Ts Te -1.2*AEmax AEmax]);

hold on;
[pks,locs]=findpeaks(AE,'minpeakdistance',36);
xi = 1:1:105120;    %������ֵ��ַ����1Ϊ��С���
yi = interp1(locs,pks,xi,'spline');   %��ֵ
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
xi2 = 1:1:105120;    %������ֵ��ַ����0.01Ϊ��С���
yi2 = interp1(locs2,pks2,xi2,'spline');   %��ֵ
plot(xi2,yi2,'r');

legend('AE','electron flux','AEpeaks','fluxpeaks');

end

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