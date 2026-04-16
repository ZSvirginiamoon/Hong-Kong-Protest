use "$clean_data\Final.dta", clear

*******************************************************************************
*                   2. Set Up the Regression Specification                    *
*******************************************************************************

********************* I then define the instrument variables and dependent variables

binscatter log_Events_Count_1124 log_NumofBusStop if d2_投票率 != ., controls($Demo $Origin $Education $Employment $Income) absorb(dc_class)  reportreg ///
xtitle("ln(1 + Number of Bus Stops)") ytitle("Protest Intensity") ///
xlabel(0(1)4, format(%5.1f) tstyle(major_notick)) ///
ylabel(0(0.5)1.5, format(%5.1f) tstyle(major_notick)) ///
plotregion(m(medium)) graphregion(color(white)) scheme(lean1) 

graph export "$output/Final Figures/Figure_B5a_First_stage_1.eps", as(eps) replace

binscatter log_Events_Count_1124 log_NumofXiaobaStop if d2_投票率 != .,  controls($Demo $Origin $Education $Employment $Income) absorb(dc_class) reportreg ///
xtitle("ln(1 + Number of Minibus Stops)") ytitle("Protest Intensity") ///
xlabel(, format(%5.1f) tstyle(major_notick)) ///
ylabel(, format(%5.1f) tstyle(major_notick)) ///
plotregion(m(medium)) graphregion(color(white)) scheme(lean1) 

graph export "$output/Final Figures/Figure_B5b_First_stage_2.eps", as(eps) replace

binscatter log_Events_Count_1124 log_MinimumDistancetoMTRStation if d2_投票率 != .,  controls($Demo $Origin $Education $Employment $Income) absorb(dc_class) reportreg ///
xtitle("ln(Distance to MTR Stations (km))") ytitle("Protest Intensity") ///
xlabel(, format(%5.1f) tstyle(major_notick)) ///
ylabel(, format(%5.1f) tstyle(major_notick)) ///
plotregion(m(medium)) graphregion(color(white)) scheme(lean1) 

graph export "$output/Final Figures/Figure_B5c_First_stage_3.eps", as(eps) replace