* Figure 3
*******************************************************************************
*                   1. Set Up the Environment                                 *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "Cleaned Data\Final.dta", clear

*******************************************************************************
*                    Figure: Pseudo Protest Intensity                         *   
*******************************************************************************	

local Instrument log_NumofBusStop log_NumofXiaobaStop log_MinimumDistancetoMTRStation 

set seed 520

ivreg2 d2_投票率 (log_Events_Count_1124 = `Instrument') $Demo $Origin $Education $Employment $Income i.dc_class_f, r

local full = _b[log_Events_Count_1124]
local full_se = _se[log_Events_Count_1124]
local full_t = `full' / `full_se'

keep if d2_投票率 != . & log_Events_Count_1124 != .

tempfile main
save `main', replace

tempfile plot
clear
set obs 1000
gen trial = _n
gen b_pt = .
gen se_pt = .
gen t_pt = .
save `plot',empty replace	

local i = 1

forvalues i = 1(1)1000 {

	use `main', clear

	qui gen id = _n
	qui generate double u1=runiform()
	qui generate double u2=runiform()
	qui sort u1 u2

	qui generate simu_treat = log_Events_Count_1124[id]
	
	qui gen simu_ins_1 = log_NumofBusStop[id]
	qui gen simu_ins_2 = log_NumofXiaobaStop[id]
	qui gen simu_ins_3 = log_MinimumDistancetoMTRStation[id]
	
	qui ivreg2 d2_投票率 (simu_treat = simu_ins_1 simu_ins_2 simu_ins_3) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
	
	use `plot', clear
	qui replace b_pt = _b[simu_treat] if trial == `i'
	qui replace se_pt = _se[simu_treat] if trial == `i'
	qui replace t_pt = b_pt / se_pt if trial == `i'

	qui save `plot',empty replace	
	
	local i = `i' + 1
	
	}

# delimit ;
twoway (histogram b_pt , fraction lw(none) fc(gs13) ) , 
	ytitle("Fraction")
	xline(`full', lc(black) lp(solid) lwidth(vthick))
	xlabel(, format(%5.1f) tstyle(major_notick))
	ylabel(, angle(0) format(%5.2f) tstyle(major_notick) )
	xtitle("Estimated Coefficient of Pseudo Protest Intensity")
	plotregion(m(zero)) graphregion(color(white)) scheme(lean1);
# delimit cr	