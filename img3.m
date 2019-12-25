% view events correlation

%%

clc;
clear all;
close all;
load("D:\Code\pbl\OMNI_HRO_1MIN_10to15.mat");

AE = OMNIHRO1MIN10(:,4);
B = OMNIHRO1MIN10(:,1);

AE(AE>1500) = NaN;
B(B>1000) = NaN;

times = 1:21900:525601;
result = [];

%%

for num = 1:5

%%

Ts = times(num);
Te = times(num+1);

%%
% electron flux �����

% IndMin=find(diff(sign(diff(f)))>0)+1;
% IndMax=find(diff(sign(diff(f)))<0)+1;

[pks1,locs1]=findpeaks(B,'minpeakdistance',4);
[pks2,locs2]=findpeaks(-B,'minpeakdistance',4);
pks2 = -pks2;

xi = 1:1:525600;    %������ֵ��ַ����1Ϊ��С���
yi1 = (interp1(locs1,pks1,xi,'spline'))';   %��ֵ
yi2 = (interp1(locs2,pks2,xi,'spline'))';   %��ֵ

Bi = yi1 - yi2 ;

%%

% ��ȡʱ��ƽ��
g=60*120;  %ʱ��ƽ�Ʒ�Χ1min���� 
en=Te-Ts-g;  %����ƽ�Ƶ������� en+g*d<e-s

A = AE(Ts:Te,1);  Bf = Bi(Ts:Te,1);  AA = A(1:en,1);
[ttf,rrf] = corr(g,en,Bf,AA);   %���ú���
 
%%

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
ylabel('Bz & AE ���ϵ��');
%title("Bz & AE ��Ӧʱ��--���ϵ��")
axis([0 g/60 mins Correlation+0.05]);

% �����ֵ���
line([Time Time],[0 Correlation],'linestyle','-', 'Color','r', 'LineWidth', 0.8);
line([0 g/2],[0 0],'linestyle','--', 'Color','k', 'LineWidth', 0.5);

hold on;
cnames= {'��ֵ','ʱ��(h)'};
h_uitable=uitable('ColumnName',cnames);
table_data={Correlation,Time};
set(h_uitable,'data',table_data,'position',[750 515 150 39]);

[zz,zzz]=findpeaks(rrf);
peaks = [zz zzz/60];

%%

% д������

result(1,num) = Correlation;
result(2,num) = Time;

%%

% ƽ�ƺ��AE-f
subplot(3,1,2);

if Time ==0
    B1 = Bi(1:end,1);
else
    B1 = Bi(Time*60:end,1);
end

figure_y1_y2(AE,B1,Ts,Te);
title("Bz ʱ��ƽ�ƺ�����");

%%

% δƽ�ƺ��AE-f
subplot(3,1,3);
figure_y1_y2(AE,Bi,Ts,Te);
title("Bz AE ʱ������");

%%

% ����ͼƬ

saveas(gcf, num2str(num), 'fig')

end


%%

function [ttf,rrf] = corr(g,en,Bf,AA)

rrf=[];
ttf=[];

for i=0:g
    a=1+i;
    b=en+i;
    B1=Bf(a:b,1);
    
    com=[AA B1];
    com(isnan(com(:,1)),:)=[];
    com(isnan(com(:,2)),:)=[];
    A1=com(:,1);
    B1=com(:,2);
    
    matrix=corrcoef(A1,B1);
    r=matrix(1,2);
    rrf=[rrf;r];

    t=i/60;
    ttf=[ttf;t]; 

end

end

%%

function figure_y1_y2(AE,B,Ts,Te)

yyaxis left;
plot(AE,'b');
ylabel('AE nT');
AEmax = 1.1 * max(AE(Ts:Te,1));
axis([Ts Te -1.2*AEmax AEmax]);

% hold on;
% [pks,locs]=findpeaks(AE,'minpeakdistance',36);
% xi = 1:1:105120;    %������ֵ��ַ����1Ϊ��С���
% yi = interp1(locs,pks,xi,'spline');   %��ֵ
% plot(xi,yi,'r');

yyaxis right;
plot(B,'k');
ylabel("BZ GSE nT");

set(gca, 'XTick',[0,44640,84960,129600,172800,217440,260640,305280,349920,393120,437760,480960,525600]);
set(gca, 'XTicklabel',{'14Jan','Feb','Mar','Apr','May','Jun','July','Agu','Sep','Oct','Nov','Dec','15Jan'}); 
hold on;
ts = changetime(Ts);
te = changetime(Te);
set(gca,'Xtick',[Ts,Te]);
set(gca, 'XTicklabel',{ts,te});

fmax = max(B(Ts:Te,1));
fmin = min(B(Ts:Te,1));
axis([Ts Te fmin fmax]);
% hold on;
% [pks2,locs2]=findpeaks(f,'minpeakdistance',36);
% xi2 = 1:1:105120;    %������ֵ��ַ����0.01Ϊ��С���
% yi2 = interp1(locs2,pks2,xi2,'spline');   %��ֵ
% plot(xi2,yi2,'r');

% legend('AE','AEpeaks','electron flux','fluxpeaks');

end

function  sT = changetime(Ts)
Tn = [0,44640,84960,129600,172800,217440,260640,305280,349920,393120,437760,480960,525600];

k = 2;

while Ts > Tn(1,k)
        k = k + 1;
end
        month = k-1;
        day = floor((Ts - Tn(1,k-1))/1440 );
        hour = floor((Ts - Tn(1,k-1) - 1440*day)/60);
        min = Ts - Tn(1,k-1) - 1440*day - 60*hour;  
        
        sT = [num2str(month,'%02d') '-' num2str(day,'%02d') '  ' num2str(hour,'%02d') ':' num2str(min,'%02d')];
end


