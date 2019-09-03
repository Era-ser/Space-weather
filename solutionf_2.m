%%
%�������ã�ͨ���۲�AEֵ�ı仯��ÿ��AE��С���Ŷ���ѡȡ�����ʵ�ƽ���ںͻ��
%attention �����������f�Ĳ�ֵ��������
%��Ҫ���Ƶģ����������ļ���name��dc��ds��de  
%%
%���ݵ�����
clc;
clear;
close;
load("C:\Users\many_\OneDrive\����\events\1415mins.mat");
%�滻�����ļ��� 1516mins&h     1415mins

%%
%����������
%��Ҫ����Ĳ�����
%�¼����
%AE���ߵĺ����귶ΧdTs,dTe   
%ƽ���ڿ�ʼʱ��dc����ڿ�ʼʱ��ds����ڽ���ʱ��de       
%ǰ׺d��ʾ�������ݵĵ�λ���죬ƽ����������[dc,ds] ���������(ds,de]
%���Զ�����Ϊ5mins����ʱ��  c��ƽ��������ĵ�һ�����ݣ�s�ǻ�ڿ�ʼ�ĵ�һ�����ݣ�e�ǻ�ڽ��������һ������

%�¼����
name='1516�¼���� NO.08';
 
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
%������1-1 ����AE����
figure;
subplot(4,1,1)
set(gcf,'position',[500 30 1000 750]);
plot(AE,'-k');
axis([Ts Te 0 1500]);
set(gca, 'XTick',[0,8940,17004,25932,34572,43500,52140,61068,70596,78636,87564,96204,105120]);
set(gca, 'XTicklabel',{'14Jan','Feb','Mar','Apr','May','Jun','July','Agu','Sep','Oct','Nov','Dec','15Jan'}); 
xlabel("ʱ�䣨mins��");
ylabel('AE nT');
title(name)

% ����
% text(c,AE(c,1),'o','color','r')
% text(s,AE(s,1),'o','color','r')
% text(e,AE(e,1),'o','color','r')

%�߱��
line([c c],[0 1500],'linestyle','-', 'Color','r', 'LineWidth', 0.5);
line([s s],[0 1500],'linestyle','-', 'Color','r', 'LineWidth', 0.5);
line([e e],[0 1500],'linestyle','-', 'Color','r', 'LineWidth', 0.5);

%%

%����1-2 ����electron flux����

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
% ���ֵ�Ŷ�
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
%��ͼ��2 ����AE�Ŷ�

%���Ŷ�
error=[];
for i=0:364
    j=i*288+1;
    err = std (AE(j:j+287,1),1);
    error = [error;err];
end

%�����Ŷ���С
t=1:365;
t=t';
subplot(4,1,3)
plot(t,error);
axis([dTs dTe 0 450]);
xlabel("ʱ��(day)");
ylabel('�Ŷ���С����׼�');
%title("�Ŷ�ֵ");
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
%������3-1ƽ����AEƽ��ֵ���

cf(1:288,1)=0; %ƽ����AEֵ
%calm time AE   %cAE 
for m=dc:ds
    for n=1:288
        cf(n,1)=cf(n,1)+AE((m-1)*288+n,1);
    end
end
cf=cf/(ds-dc+1);    %ƽ����AEֵ��ƽ�� 


%%
%����ʵ����3-2 ������

ff=[];  %f�����ƽ���ڲ�ֵ
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
%����
%��ȡʱ��ƽ��
g=96;  %ʱ��ƽ�Ʒ�Χ���� 
d=6;  %ʱ�������ٸ�5min
en=288*(de-ds-2);  %����ƽ�Ƶ������� en+g*d<e-s


%%
%������4-ʱ��ƽ�Ƽ����ϵ�����
%ff=f(s:e,1); %��ڶ�Ӧelectron fluxֵ
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

%�����ֵ
[x y]=find(rrf==max(max(rrf)));
Time=ttf(x,y);
Correlation=rrf(x,y);

if min(rrf)<0
    min=min(rrf)-0.01;
else
    min=0;
end



%��������
subplot(4,1,4);
%set(gcf,'position',[300 480 1000 300]);
plot(ttf,rrf)
xlabel("��Ӧʱ��/h");
ylabel('electron flux & AE ���ϵ��');
%title("electron flux & AE ��Ӧʱ��--���ϵ��")
axis([0 g/2 min Correlation+0.05]);

%�����ֵ���
line([Time Time],[0 Correlation],'linestyle','-', 'Color','r', 'LineWidth', 0.8);
line([0 g/2],[0 0],'linestyle','--', 'Color','k', 'LineWidth', 0.5);
%text(Time,Correlation,'o','color','r');

%%
%������5-����˵�����
cnames= {'daycalm','daystart','dayend','������','��Ӧ��ֵ','��Ӧʱ��(h)'};
h_uitable=uitable('ColumnName',cnames);
table_data={dc,ds,de,en/288,Correlation,Time};
%uit.Position = [0.73,0.22,0.8,0.7];
set(h_uitable,'data',table_data,'position',[513 9 393 45]);








