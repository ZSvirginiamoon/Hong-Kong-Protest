* Figure B6
*******************************************************************************
*                   1. Set Up the Environment                                 *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

*******************************************************************************
*                   2. Set Up the Regression Specification                    *
*******************************************************************************
gen Bus_pop = NumofBusStop/t_pop_2016 * 1000
gen Xiaoba_pop = NumofXiaobaStop/t_pop_2016 * 1000
gen Total_pop = NumofTotalStops/t_pop_2016 * 1000

gen Bus_area = NumofBusStop/Area_Sqkm
gen Xiaoba_area = NumofXiaobaStop/Area_Sqkm
gen Total_area = NumofTotalStops/Area_Sqkm

gen log_Bus_pop = ln(1 + Bus_pop)
gen log_Xiaoba_pop = ln(1 + Xiaoba_pop)
gen log_Total_pop = ln(1 + Total_pop)

gen log_Bus_area = ln(1 + Bus_area)
gen log_Xiaoba_area = ln(1 + Xiaoba_area)
gen log_Total_area = ln(1 + Total_area)

*******************************************************************************
*               Figure: Robustness of IV Using Different Measures             *
*******************************************************************************	

* 1 Main
gen Treatment_1 = log_Events_Count_1124
local Instrument log_NumofBusStop log_NumofXiaobaStop log_MinimumDistancetoMTRStation 
ivreg2 d2_投票率 (Treatment_1 = `Instrument' ) $Demo $Origin $Education $Employment $Income i.dc_class_f , r
label var Treatment_1 "Bus & Minibus (Main Result)"
estimates store Result_1

* 2 Total Stops
gen Treatment_2 = log_Events_Count_1124
local Instrument log_NumofTotalStops log_MinimumDistancetoMTRStation
ivreg2 d2_投票率 (Treatment_2 = `Instrument' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
label var Treatment_2 "Total Stops (Bus + Minibus)"
estimates store Result_2

* 3 Divide by 2016 Pop log
gen Treatment_3 = log_Events_Count_1124
local Instrument log_Bus_pop log_Xiaoba_pop log_MinimumDistancetoMTRStation 
ivreg2 d2_投票率 (Treatment_3 = `Instrument' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
label var Treatment_3 "Bus & Minibus, per 1000 person"
estimates store Result_3

* 4 Divide by 2016 Pop log
gen Treatment_4 = log_Events_Count_1124
local Instrument log_Bus_area log_Xiaoba_area log_MinimumDistancetoMTRStation 
ivreg2 d2_投票率 (Treatment_4 = `Instrument' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
label var Treatment_4 "Bus & Minibus, per square area"
estimates store Result_4

coefplot (Result_1 \ Result_2 \ Result_3 \ Result_4 ), drop(_cons) aseq noeqlabels msymbol(d) ciopts(recast(rcap)) levels(90) mlabel format(%9.2fc) mlabposition(12) mlabgap(*2) ///
keep(Treatment*)  ///
xscale(range(0 4)) xlabel(0(1)4, format(%5.0f) tstyle(major_notick)) ///
xline(0, lc(gs12) lp(dash)) ///
xtitle("Second-stage Coef. of Protest Intensity") ///
plotregion(m(medium)) graphregion(color(white)) scheme(lean1) 

graph export "$output/Final Figures/Figure_B6_IV_Robustness.eps", as(eps) replace