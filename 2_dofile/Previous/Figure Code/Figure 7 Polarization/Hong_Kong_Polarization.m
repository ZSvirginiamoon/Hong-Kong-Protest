clc
clear
cd('H:\我的云端硬盘\Hong Kong\Proposals\Final Figures')

A = readtable("Hong_Kong_Polarization.csv")

hold on 
plot(A.Year,A.HongKong,"LineStyle","-","Color","blue","LineWidth",1.5);
plot(A.Year,A.China,"LineStyle","-.","LineWidth",1.5);
plot(A.Year,A.Taiwan,"LineStyle",":","LineWidth",1.5);
plot(A.Year,A.World,"LineStyle","--","LineWidth",1.5);

legend("Hong Kong","Mainland China","Taiwan","World","Location","northwest")
xticks(1997:2:2019)
xlim([1997,2020])
yticks(0:0.5:4)
ylabel('Political Polarization Index')
xlabel("Year")
box on
grid on

saveas(gcf,'Hong_Kong_Polarization.eps','epsc')

