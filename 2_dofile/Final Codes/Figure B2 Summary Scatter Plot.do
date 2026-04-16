
clear all

use "$clean_data\Final.dta", clear

*******************************************************************************
*                   2. Set Up the Regression Specification                    *
*******************************************************************************
********************* I then define the instrument variables and dependent variables

binscatter d2_投票率 log_Events_Count_1124 if d2_投票率 != ., controls($Demo $Origin $Education $Employment $Income) absorb(dc_class)  reportreg ///
xtitle("Protest Intensity") ytitle("Difference in Voter Turnout") ///
xlabel(, format(%5.1f) tstyle(major_notick)) ///
ylabel(, format(%5.1f) tstyle(major_notick)) ///
plotregion(m(medium)) graphregion(color(white)) scheme(lean1) 

graph export "$output/Final Figures/Figure_B2_Desc_Scatter.eps", as(eps) replace
