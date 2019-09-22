% 三月份数据图 plot3

% 原始数据去坏点范围：
Bz(Bz>9000)=NaN;
FS(FS>90000)=NaN; %(Flow Speed)
FP(FP>50)=NaN;FP(FP<0)=NaN; %(Flow Pressure)
AE(AE>3000)=NaN;
FLUX(FLUX<0)=NaN;

% 无后序为去坏点后的全年原始数据
% 后序Mar为去坏点后的三月份原始数据
AEMar = AE(16992:25920 ,1);
BzMar = Bz(16992:25920 ,1);
FPMar = FP(16992:25920 ,1);
FSMar = FS(16992:25920 ,1);
FLUXMar = FLUX(16992:25920 ,1);

% 后序MarS为smooth后的三月份数据
% AEMarS = smooth(AEMar, 4*12);
% BzMarS = smooth(BzMar, 4*12);
% FPMarS = smooth(FPMar, 2*12);
% FSMarS = smooth(FSMar, 2*12);
% FLUXMarS = smooth(FLUXMar, 2*12);


% 后序S为smooth后的全年数据
% AES = smooth(AE, 4*12);
% BzS = smooth(Bz, 4*12);
% FPS = smooth(FP, 2*12);
% FSS = smooth(FS, 2*12);
% FLUXS = smooth(FLUXMar, 2*12);

% 后序Plot为绘图数据
AEPlot = AES;
BzPlot = BzS;
FPPlot = FPS;
FSPlot = FSS;
FLUXPlot = FLUXS;
DstPlot = Dst;

%绘图：
subplot(6,1,1);
plot(FPPlot, 'k');
title('2015 FP FS BZ AE Dst FLUX Data Combination');
set(gca, 'XTick',[0, 105120]);
set(gca,'xminortick','on');
axis([0 105120 0 20]);
ylabel('Flow Pressure (nPa)');

subplot(6,1,2);
plot(FSPlot, 'k');
set(gca, 'XTick',[0, 105120]);
set(gca,'xminortick','on');
axis([0 105120 200 800]);
ylabel('Flow Speed (km/s)');

subplot(6,1,3);
plot(BzPlot, 'k');
set(gca, 'XTick',[0, 105120]);
set(gca,'xminortick','on');
axis([0 105120 -30 30]);
ylabel('BZ (nT)');

subplot(6,1,4);
plot(AEPlot, 'k');
set(gca, 'XTick',[0, 105120]);
set(gca,'xminortick','on');
axis([0 105120 -100 1500]);
ylabel('AE (nT)');

subplot(6,1,5);
plot(DstPlot, 'k');
set(gca, 'XTick',[0,744,1416,2160,2880,3624,4344,5088,5832,6552,7296,8016,8760]);
set(gca,'xminortick','on');
axis([1416 2160 -250 100]);
ylabel('DST (nT)');

subplot(6,1,6);
plot(FLUXPlot, 'k');
legend('E1>475 keV');
set(gca, 'XTick',[0, 105120]);
set(gca, 'XTicklabel', {'Mar', 'Apr'});
set(gca,'xminortick','on');
axis([0 105120 1 8000]);
ylabel('Electron flux (e/(cm^2/s/sr))');
