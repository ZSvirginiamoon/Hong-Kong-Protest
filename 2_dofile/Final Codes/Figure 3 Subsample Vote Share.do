* Figure 3
*******************************************************************************
*                   1. Set Up the Environment                                 *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

*******************************************************************************
*               Figure: Compare Vote Shares in Different Areas                *
*******************************************************************************	
// Start Regression 

tempfile main
save `main', replace

tempfile plot
clear
set obs 6
gen count = _n
gen position = .
gen area = .
gen party = .
gen b_pt = . 
gen se_pt= . 
save `plot', replace

local i = 1
local pos = 1

foreach condition in 0 1 {
	
	local party = 1
	
	foreach var in d2_中立得票_ratio d2_亲民主得票_ratio  d2_亲建制得票_ratio  {
		use `main', clear
		
		ivreg2 `var' (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f if 民主当选_2015 == `condition', r

		// Save the regression results
		use `plot', clear
				
		replace b_pt = _b[log_Events_Count_1124] if count == `i'
		replace se_pt = _se[log_Events_Count_1124] if count == `i'
		replace area = `condition' if count == `i'
		replace party = `party' if count == `i'
		replace position = `pos' if count == `i'
 		
		save `plot', replace
		
		local party = `party' + 1
		local i = `i' + 1		
		local pos = `pos' + 1
		
	}
	
	local pos = `pos' + 1
}

gen se_h = b_pt + invnormal(0.95) * se_pt
gen se_l = b_pt - invnormal(0.95) * se_pt

twoway ///
	(scatter b_pt position if party == 1, sort ms(smdiamond) msize(large) mc(maroon) lc(maroon) ) (rcap se_l se_h position if party == 1, lp(dash) lc(maroon) ) ///
	(scatter b_pt position if party == 2, sort ms(smdiamond) msize(large) mc(green) lc(green) ) (rcap se_l se_h position if party == 2, lp(dash) lc(green) ) ///
	(scatter b_pt position if party == 3, sort ms(smdiamond) msize(large) mc(navy) lc(navy) ) (rcap se_l se_h position if party == 3, lp(dash) lc(navy) ), ///
	legend(rows(1) region(col(white)) order(1 "Neutral" 3 "Pro-democracy" 5 "Pro-establishment") position(6)) ///
	xline(4, lc(gs12) lp(dash)) yline(0, lc(gs12) lp(dash)) ///
	xlabel( 2 "Previous Non-Pro-dem." 6 "Previous Pro-dem." , noticks angle(0)) xtitle("") ///
	xscale(range(0 8)) ///
	ytitle(Percentage Point Changes in Total Vote Share, size(small)) ylabel(-12(4)12, gmax gmin angle(0)) ///
	plotregion(m(zero)) graphregion(color(white)) scheme(lean1)
	graph export "$output/Final Figures/Figure_3_Subsample_Vote_Share.eps", as(eps) replace	