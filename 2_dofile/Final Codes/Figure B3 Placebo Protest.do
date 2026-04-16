* Figure B3
*******************************************************************************
*                   1. Set Up the Environment                                 *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

*******************************************************************************
*                    Figure: Pseudo Protest Intensity                         *   
*******************************************************************************	

set seed 520

reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)

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
save `plot', replace

local i = 1

forvalues i = 1(1)1000 {

	use `main', clear

	qui gen id = _n
	qui generate double u1=runiform()
	qui generate double u2=runiform()
	qui sort u1 u2

	qui generate simu_treat = log_Events_Count_1124[id]
	
	qui reghdfe d2_投票率 simu_treat $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
	
	use `plot', clear
	qui replace b_pt = _b[simu_treat] if trial == `i'
	qui replace se_pt = _se[simu_treat] if trial == `i'
	qui replace t_pt = b_pt / se_pt if trial == `i'

	qui save `plot', replace

	local i = `i' + 1
	
	}

# delimit ;
twoway (histogram b_pt , fraction lw(none) fc(gs13) ) , 
	ytitle("Fraction")
	xline(`full', lc(black) lp(solid) lwidth(vthick))
	xscale(range(-1 1)) xlabel(-1(0.4)1, format(%5.1f) tstyle(major_notick))
	ylabel(0(0.02)0.08, angle(0) format(%5.2f) tstyle(major_notick) )
	xtitle("Estimated Coefficient of Placebo Protest Intensity")
	plotregion(m(zero)) graphregion(color(white)) scheme(lean1);
	graph export "$output/Final Figures/Figure_B3_Placebo_Protest.eps", as(eps) replace;
# delimit cr	