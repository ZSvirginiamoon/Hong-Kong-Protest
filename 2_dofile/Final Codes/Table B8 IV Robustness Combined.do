
cap log close
set more off
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
********************* I then define the instrument variables and dependent variables

** Panel A

local IV log_NumofBusStop
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)

local IV log_NumofXiaobaStop
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)

local IV log_MinimumDistancetoMTRStation
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)

local IV log_NumofBusStop log_NumofXiaobaStop
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)

local IV log_NumofBusStop log_MinimumDistancetoMTRStation
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)

local IV log_NumofXiaobaStop log_MinimumDistancetoMTRStation
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)

local IV log_NumofBusStop log_NumofXiaobaStop log_MinimumDistancetoMTRStation 
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)


esttab using "$output/Final Tables/Table B8 Table B8 Different IV Combination.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Effects of Local Public Transportation on the Protest Intensity, Using Different Instruments" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
posthead(\midrule \multicolumn{6}{l}{ \textit{First-Stage Regression Results} } \\ ) ///
postfoot( \addlinespace ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  /// 
keep( $Instrument2 ) ///
label booktabs noobs nonotes nolines collabels(none) ///
nomtitles


** Panel B
est clear 

local IV log_NumofBusStop
eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = `IV' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

local IV log_NumofXiaobaStop
eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = `IV' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

local IV log_MinimumDistancetoMTRStation
eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = `IV' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

local IV log_NumofBusStop log_NumofXiaobaStop
eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = `IV' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

local IV log_NumofBusStop log_MinimumDistancetoMTRStation
eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = `IV' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

local IV log_NumofXiaobaStop log_MinimumDistancetoMTRStation
eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = `IV' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

local IV log_NumofBusStop log_NumofXiaobaStop log_MinimumDistancetoMTRStation 
eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = `IV' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"


esttab using "$output/Final Tables/Table B8 Table B8 Different IV Combination.tex", append f ///
posthead(\midrule \multicolumn{6}{l}{ \textit{Second-stage Regression Results} } \\ ) ///
postfoot( \addlinespace \midrule ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  /// 
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
label booktabs noobs nonotes nomtitles nolines nonum collabels(none) ///
alignment(D{.}{.}{-1}) ///
nomtitles

esttab using "$output/Final Tables/Table B8 Table B8 Different IV Combination.tex", append f ///
drop(*) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table}) ///
label booktabs collabels(none) nomtitles nolines nonum alignment(D{.}{.}{-1}) ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weight" "Method Method" "widstat Kleibergen-Paap F" "j Hansen J stat." "jp \( \chi^2(2) \) P-value" "r2 \(R^2\)") sfmt(%9.3f %9.3f %9.3f %9.3f) 