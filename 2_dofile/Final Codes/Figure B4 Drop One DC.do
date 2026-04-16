* Figure 4
*******************************************************************************
*                   1. Set Up the Environment                                 *
*******************************************************************************

clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

*******************************************************************************
*               Figure: Robustness Drop One District Council                  *
*******************************************************************************	

levelsof dc_eng, local(all_dc)

local i = 1

foreach drop_dc in `all_dc' {
	
	gen Treatment_`i' = log_Events_Count_1124
	reghdfe d2_投票率 Treatment_`i' $Demo $Origin $Education $Employment $Income if dc_eng != "`drop_dc'", absorb(dc_class) vce(robust)
	label var Treatment_`i' "`drop_dc'"
	estimates store Result_`i'

	local i = `i' + 1
}	

reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income, absorb(dc_class) vce(robust)
local main = _b[log_Events_Count_1124]

coefplot (Result_*), drop(_cons) aseq noeqlabels msymbol(d) ciopts(recast(rcap)) levels(90) ///
keep(Treatment*)  ///
xscale(range(0 1.5)) xlabel(0(0.5)1.5, format(%5.1f) tstyle(major_notick)) ///
xline(`main', lc(gs12) lp(dash)) ///
xtitle("Estimated Coeffient of Protest Intensity") ///
plotregion(m(medium)) graphregion(color(white)) scheme(lean1) 

graph export "$output/Final Figures/Figure_B4_Robust_Drop_DC.eps", as(eps) replace