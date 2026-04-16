clear all

use "$clean_data\Final.dta", clear
*******************************************************************************
*                   2. Set Up the Regression Specification                    *
*******************************************************************************

* Basic Demographic characteristics
global Demo ratio_pop_f_2016 ratio_age_1_2016 ratio_age_2_2016 ratio_age_3_2016 ratio_age_4_2016 ratio_age_5_2016 ratio_married_2016
global New_Demo ratio_pop_f_2016 ratio_age_1_2016 ratio_age_2_2016 ratio_age_3_2016 ratio_age_4_2016 ratio_married_2016

global Origin ratio_born_hk_2016 ratio_born_chi_2016 ratio_ul_can_2016 ratio_ul_put_2016

* This is sum of education
global Education ratio_edu_dip_2016 ratio_edu_sub_2016 ratio_edu_deg_2016 
* global Education ratio_post_college_2016

* global Employment ratio_t_lf_2016 
global Employment ratio_t_wp_2016

*global Income ma_hh_2016
global Income ma_econhh_2016 

global Instrument2 log_NumofBusStop log_NumofXiaobaStop log_MinimumDistancetoMTRStation 

merge 1:1 dcca_class using "$raw_data\区议会\Redistributing.dta", gen(_merge_re)
gen re_5 = (Diff_ratio >= 5 & Diff_ratio != .)
gen re_10 = (Diff_ratio >= 10 & Diff_ratio != .)

eststo clear

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income [aw=t_pop_2016] , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income  if re_10 != 1, absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income [aw=t_pop_2016] if re_10 != 1, absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income if re_5 != 1, absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income [aw=t_pop_2016] if re_5 != 1, absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

esttab using "$output/Final Tables/Table B2 Redistricting.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Robustness Checks: OLS Regression Results on Turnouts, Dropping Large Redistributing Areas" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
keep( log_Events_Count_1124 ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
mgroups("Original" "Drop \(> 10\%\)" "Drop \(> 5\%\)", pattern(1 0 1 0 1 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1})  ///
label booktabs nonotes collabels(none) ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "r2 \(R^2\)" ) sfmt(%6.3fc) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})


