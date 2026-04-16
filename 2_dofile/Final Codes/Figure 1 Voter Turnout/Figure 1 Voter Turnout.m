clc
clear
cd('E:\OneDrive - Syracuse University\E盘\Google Drive\Hong Kong\3_output\Final Figures')

Turnout = [35.82 44.1 38.83	41.49 47.01	71.23];
Year = [1999 2003 2007 2011 2015 2019];

p = plot(Year,Turnout);
p.LineStyle = "-";
p.Marker = "square";
p.Color = "red";
p.LineWidth = 1.5;
xticks(1999:4:2019)
xlim([1998,2020])
yticks(30:10:70)
ylabel('Turnout (%)')
xlabel("Year")
box on
grid on

saveas(gcf,'Figure_1_Turnout.eps','epsc')
