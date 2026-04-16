
use "$clean_data\Final.dta", clear

*******************************************************************************
*                   2. Set Up the Regression Specification                    *
*******************************************************************************

tab dc_class_f, gen(region_dummy)
drop region_dummy18

*******************************************************************************
*                        4. Figures for Conley                                *
*******************************************************************************

local rf = 0.1607996
local rf_v = .5214535
local rf_pre:  display %05.3f `rf'
local rf_v_pre: display %05.3f `rf_v'

forvalues i = 1(1)6 {
	local gap = 0.2
	local delta_`i' = `gap' * (`i' - 1)
	
	local mu_`i' = `rf' * `delta_`i''
	local omega_`i' = (`rf_v' * `delta_`i'')^2
}

plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 =  log_NumofXiaobaStop log_NumofBusStop log_MinimumDistancetoMTRStation ), mu(0 0 0) omega(0.074 0.181 0.148) level(.90) vce(robust) graph(log_Events_Count_1124) graphmu(`mu_1' `mu_2' `mu_3' `mu_4' `mu_5' `mu_6') graphomega(`omega_1' `omega_2' `omega_3' `omega_4' `omega_5' `omega_6') graphdelta(`delta_1' `delta_2' `delta_3' `delta_4' `delta_5' `delta_6') /// 
ytitle(Estimated Coefficient {&beta}) ///
xtitle(Potential Endogeneity {&delta}) ///
xlabel(, format(%5.1f) tstyle(major_notick))  ///
ylabel(-1(1)3, angle(0) format(%5.1f) tstyle(major_notick) nogrid ) ///
yline(0, lc(gs12) lp(dash)) ///
legend(rows(1) region(col(white)) order(1 "Point Estimate (LTZ)" 2 "90% CI (LTZ)") position(6)) ///
text(-2 0 "RF Beta: `rf_pre', S.E.: `rf_v_pre'", place(se) size(small) color(black)) ///
plotregion(m(zero)) graphregion(color(white)) scheme(lean1) 
graph export "$output/Final Figures/Figure_B7a_Conley_1.eps", as(eps) replace

local rf = .8351065
local rf_v = .5398744
local rf_pre:  display %05.3f `rf'
local rf_v_pre: display %05.3f `rf_v'

forvalues i = 1(1)6 {
	local gap = 0.2
	local delta_`i' = `gap' * (`i' - 1)
	
	local mu_`i' = `rf' * `delta_`i''
	local omega_`i' = (`rf_v' * `delta_`i'' )^2
}

plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = log_NumofBusStop log_NumofXiaobaStop  log_MinimumDistancetoMTRStation ), mu(0 0 0) omega(0.074 0.181 0.148) level(.90) vce(robust) graph(log_Events_Count_1124) graphmu(`mu_1' `mu_2' `mu_3' `mu_4' `mu_5' `mu_6') graphomega(`omega_1' `omega_2' `omega_3' `omega_4' `omega_5' `omega_6') graphdelta(`delta_1' `delta_2' `delta_3' `delta_4' `delta_5' `delta_6') /// 
ytitle(Estimated Coefficient {&beta}) ///
xtitle(Potential Endogeneity {&delta}) ///
xlabel(, format(%5.1f) tstyle(major_notick))  ///
ylabel(-1(1)3, angle(0) format(%5.1f) tstyle(major_notick) nogrid ) ///
yline(0, lc(gs12) lp(dash)) ///
legend(rows(1) region(col(white)) order(1 "Point Estimate (LTZ)" 2 "90% CI (LTZ)") position(6)) ///
text(-2 0 "RF Beta: `rf_pre', S.E.: `rf_v_pre'", place(se) size(small) color(black)) ///
plotregion(m(zero)) graphregion(color(white)) scheme(lean1)
graph export "$output/Final Figures/Figure_B7a_Conley_2.eps", as(eps) replace

local rf = -.6264106
local rf_v = .4234641
local rf_pre = "(" + string(abs(`rf'), "%6.3f") + ")"
local rf_v_pre: display %05.3f `rf_v'

forvalues i = 1(1)6 {
	local gap = 0.2
	local delta_`i' = `gap' * (`i' - 1)
	
	local mu_`i' = `rf' * `delta_`i''
	local omega_`i' = (`rf_v' * `delta_`i'' )^2
}

plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = log_MinimumDistancetoMTRStation log_NumofXiaobaStop log_NumofBusStop  ), mu(0 0 0) omega(0.074 0.181 0.148) level(.90) vce(robust) graph(log_Events_Count_1124) graphmu(`mu_1' `mu_2' `mu_3' `mu_4' `mu_5' `mu_6') graphomega(`omega_1' `omega_2' `omega_3' `omega_4' `omega_5' `omega_6') graphdelta(`delta_1' `delta_2' `delta_3' `delta_4' `delta_5' `delta_6') /// 
ytitle(Estimated Coefficient {&beta}) ///
xtitle(Potential Endogeneity {&delta}) ///
xlabel(, format(%5.1f) tstyle(major_notick))  ///
ylabel(-1(1)3, angle(0) format(%5.1f) tstyle(major_notick) nogrid ) ///
yline(0, lc(gs12) lp(dash)) ///
legend(rows(1) region(col(white)) order(1 "Point Estimate (LTZ)" 2 "90% CI (LTZ)") position(6)) ///
text(-2 0 "RF Beta: `rf_pre', S.E.: `rf_v_pre'", place(se) size(small) color(black)) ///
plotregion(m(zero)) graphregion(color(white)) scheme(lean1)
graph export "$output/Final Figures/Figure_B7a_Conley_3.eps", as(eps) replace









/*
ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) $Demo $Origin $Education $Employment $Income i.dc_class_f, r

ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) $New_Demo $Origin $Education $Employment $Income region_dummy* , r

plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = $Instrument2), mu(0 0 0) omega(0.074 0.181 0.148) level(.95) vce(robust)

plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = $Instrument2), mu(0 0 0) omega(0.148 0.362 0.296) level(.95) vce(robust)

plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = $Instrument2), mu(0 0 0) omega(0.074 0.181 0.148) level(.90) vce(robust) graph(log_Events_Count_1124) graphmu(0 0 0 0 0) graphomega(0.1 0.2 0.3 0.4 0.5) graphdelta(0.1 0.2 0.3 0.4 0.5)

plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = $Instrument2), mu(0 0 0) omega(0.074 0.181 0.148) level(.90) vce(robust) graph(log_Events_Count_1124) graphmu(0 0 0 0 0) graphomega(0.1 0.2 0.3 0.4 0.5) graphdelta(0.1 0.2 0.3 0.4 0.5) /// 
ytitle(Estimated Coefficient {&beta}) ///
xtitle(Variance of {&gamma}) ///
xlabel(, format(%5.1f) tstyle(major_notick))  ///
ylabel(-1(1)4, angle(0) format(%5.1f) tstyle(major_notick) nogrid ) ///
yline(0, lc(gs12) lp(dash)) ///
legend(rows(1) region(col(white)) order(1 "Point Estimate (LTZ)" 2 "90% CI (LTZ)") position(6)) ///
plotregion(m(zero)) graphregion(color(white)) scheme(lean1)

plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = $Instrument2), mu(0 0 0) omega(0.074 0.181 0.148) level(.90) vce(robust) graph(log_Events_Count_1124) graphmu(0 0.1 0.2 0.3 0.4 0.5) graphomega(0 0.01 0.04 0.09 0.16 0.25) graphdelta(0 0.1 0.2 0.3 0.4 0.5) /// 
ytitle(Estimated Coefficient {&beta}) ///
xtitle(Variance of {&gamma}) ///
xlabel(, format(%5.1f) tstyle(major_notick))  ///
ylabel(-1(1)4, angle(0) format(%5.1f) tstyle(major_notick) nogrid ) ///
yline(0, lc(gs12) lp(dash)) ///
legend(rows(1) region(col(white)) order(1 "Point Estimate (LTZ)" 2 "90% CI (LTZ)") position(6)) ///
plotregion(m(zero)) graphregion(color(white)) scheme(lean1)
*/

*******************************************************************************
*                        3. Tables and Figures                                *
*******************************************************************************
* plausexog uci d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (tt = $Instrument2), gmin(0 0 -.6264106 ) gmax(.1607996 .8351065 0) grid(2) level(.90) vce(robust)
* plausexog uci d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (tt = $Instrument2) [aw=t_pop_2016], gmin(0 0 -.7247205) gmax(.2798508 .7375263 0) grid(2) level(.90) vce(robust)

/*
local a = 0.4
est clear

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "N"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

local mean = ( 0.1607996* `a' )
local var = ( 0.1607996* `a' ) ^2
eststo: plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = $Instrument2), mu(`mean' 0 0) omega(`var' 0 0) level(.95) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "N"

local mean = ( .2798508* `a' )
local var = ( .2798508* `a' ) ^2
eststo: plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = $Instrument2) [aw=t_pop_2016], mu(`mean' 0 0) omega(`var' 0 0) level(.95) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"

local mean = ( .8351065* `a' )
local var = ( .8351065* `a' ) ^2
eststo: plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = $Instrument2), mu(0 `mean' 0) omega(0 `var' 0) level(.95) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "N"

local mean = ( .7375263* `a' )
local var = ( .7375263* `a' ) ^2
eststo: plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = $Instrument2) [aw=t_pop_2016], mu(0 `mean' 0) omega(0 `var' 0) level(.95) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"

local mean = (-.6264106* `a' )
local var = (-.6264106* `a' ) ^2
eststo: plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = $Instrument2), mu(0 0 `mean') omega(0 0 `var') level(.95) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "N"

local mean = (-.7247205* `a' )
local var = (-.7247205* `a' ) ^2
eststo: plausexog ltz d2_投票率 $New_Demo $Origin $Education $Employment $Income region_dummy* (log_Events_Count_1124 = $Instrument2) [aw=t_pop_2016], mu(0 0 `mean') omega(0 0 `var') level(.95) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"

esttab using "./Proposals/Response/Conley.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Second Stage IV Regression Results on Turnouts" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 " Protest Intensity" ) ///
label booktabs nonotes collabels(none) ///
mgroups("IV Results" "Bus" "Minibus" "MTR", pattern(1 0 1 0 1 0 1 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1}) ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "widstat Kleibergen-Paap F" "r2 \(R^2\)" ) sfmt(%6.3fc) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})
*/

