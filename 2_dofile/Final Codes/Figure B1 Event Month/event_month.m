clc
clear
cd('E:\OneDrive - Syracuse University\E盘\Google Drive\Hong Kong\2_dofile\Final Codes\Figure B1 Event Month')

A = readtable("event_month.csv")
time = datetime(A.ym,'InputFormat','MMMM-yy-dd','Locale','en_US');

hold on
p = plot(time,A.event_id);
p.LineStyle = "-";
datetick('x','yyyy-mm')
xlim([time(1) time(end)])
p.Color = "blue";
p.LineWidth = 1.5;

x = datetime("2019-11-24");
x1 = xline(x,'--',{'District Council Election'});
x1.LabelVerticalAlignment = 'middle';
x1.LabelHorizontalAlignment = 'center';

ylabel('Number of Events')
box on
grid on

saveas(gcf,'E:\OneDrive - Syracuse University\E盘\Google Drive\Hong Kong\3_output\Final Figures\Figure_B1_event_month.eps','epsc')

