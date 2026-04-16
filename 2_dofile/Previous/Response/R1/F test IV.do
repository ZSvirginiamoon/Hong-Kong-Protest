
cap log close
set more off
clear all

cd "E:\OneDrive - Syracuse University\E盘\Google Drive\Hong Kong"

use "Cleaned Data\Final.dta", clear

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

local IV log_NumofBusStop
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `IV'
qui estadd local F_stat = round(`r(F)',.001)
qui estadd local IV "Bus"
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

local IV log_NumofXiaobaStop
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `IV'
qui estadd local F_stat = round(`r(F)',.001)
qui estadd local IV "Minibus"
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

local IV log_MinimumDistancetoMTRStation
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `IV'
qui estadd local F_stat = round(`r(F)',.001)
qui estadd local IV "MTR"
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

local IV log_NumofBusStop log_NumofXiaobaStop
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `IV'
qui estadd local F_stat = round(`r(F)',.001)
qui estadd local IV "Bus + Minibus"
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

local IV log_NumofBusStop log_MinimumDistancetoMTRStation
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `IV'
qui estadd local F_stat = round(`r(F)',.001)
qui estadd local IV "Bus + MTR"
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

local IV log_NumofXiaobaStop log_MinimumDistancetoMTRStation
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `IV'
qui estadd local F_stat = round(`r(F)',.001)
qui estadd local IV "Minibus + MTR"
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

local IV log_NumofBusStop log_NumofXiaobaStop log_MinimumDistancetoMTRStation 
eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `IV'
qui estadd local F_stat = round(`r(F)',.001)
qui estadd local IV "Bus + Minibus + MTR"
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

esttab using "./Proposals/Response/F Test IV.tex", replace f ///
prehead(\begin{table}[H]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Effects of Local Public Transportation on the Protest Intensity, Different Instruments" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
keep( $Instrument2 ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
label booktabs nonotes collabels(none) ///
nomtitles ///
obslast ///
scalars("IV IV Used" "F_stat F-stat" "Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "r2 \(R^2\)" ) sfmt(%6.3fc) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})


