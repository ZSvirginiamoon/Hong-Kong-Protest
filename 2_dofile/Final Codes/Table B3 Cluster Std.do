* Table B3 
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

* 2 Obs have no 2019 elections
drop if Latitude == . 
*******************************************************************************
*          Appendix Table B1 OLS Regression Results Cluster                   *
*******************************************************************************

********************* OLS Results
eststo clear

**** Note that using other versions of boottest might result in errors
* net install boottest, replace from(https://raw.github.com/droodman/boottest/v4.5.2)

************************** Column 1 
		reghdfe d2_投票率 log_Events_Count_1124 , noabsorb vce(cluster dc)
		matrix m = r(table)
		local Cluster = m[4,1]
		local Cluster = string(`Cluster', "%9.3f")
		
		reg d2_投票率 log_Events_Count_1124 , vce(cluster dc)
		boottest log_Events_Count_1124, seed(520) boot(wild) nograph
		local wide = `r(p)'
		local wide = string(`wide', "%9.3f")
		
		acreg d2_投票率 log_Events_Count_1124 , spatial latitude(Latitude)  longitude(Longitude) dist(0.5)
		matrix m = r(table)
		local spatial_1 = m[4,1]
		local spatial_1 = string(`spatial_1', "%9.3f")

		acreg d2_投票率 log_Events_Count_1124 , spatial latitude(Latitude)  longitude(Longitude) dist(1)
		matrix m = r(table)
		local spatial_2 = m[4,1]
		local spatial_2 = string(`spatial_2', "%9.3f")
		
eststo: reghdfe d2_投票率 log_Events_Count_1124 , noabsorb vce(robust)
		qui estadd local Cluster = `Cluster'
		qui estadd local wide = `wide'
		qui estadd local spatial_1 = `spatial_1'	
		qui estadd local spatial_2 = `spatial_2'
		qui estadd local Weight "N"

************************** Column 2 
		reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education  , noabsorb vce(cluster dc)
		matrix m = r(table)
		local Cluster = m[4,1]
		local Cluster = string(`Cluster', "%9.3f")

		reg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education  , vce(cluster dc)
		boottest log_Events_Count_1124, seed(520) boot(wild) nograph 
		local wide = `r(p)'
		local wide = string(`wide', "%9.3f")
		
		acreg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education , spatial latitude(Latitude)  longitude(Longitude) dist(0.5)
		matrix m = r(table)
		local spatial_1 = m[4,1]
		local spatial_1 = string(`spatial_1', "%9.3f")

		acreg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education , spatial latitude(Latitude)  longitude(Longitude) dist(1)
		matrix m = r(table)
		local spatial_2 = m[4,1]
		local spatial_2 = string(`spatial_2', "%9.3f")
		
eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education, noabsorb vce(robust)
		qui estadd local Cluster = `Cluster'
		qui estadd local wide = `wide'
		qui estadd local spatial_1 = `spatial_1'	
		qui estadd local spatial_2 = `spatial_2'
		qui estadd local Demographics "Y"
		qui estadd local Weight "N"

************************** Column 3
		reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment , noabsorb vce(cluster dc)
		matrix m = r(table)
		local Cluster = m[4,1]
		local Cluster = string(`Cluster', "%9.3f")

		reg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment , vce(cluster dc)
		boottest log_Events_Count_1124, seed(520) boot(wild) nograph 
		local wide = `r(p)'
		local wide = string(`wide', "%9.3f")
		
		acreg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment , spatial latitude(Latitude)  longitude(Longitude) dist(0.5)
		matrix m = r(table)
		local spatial_1 = m[4,1]
		local spatial_1 = string(`spatial_1', "%9.3f")

		acreg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment , spatial latitude(Latitude)  longitude(Longitude) dist(1)
		matrix m = r(table)
		local spatial_2 = m[4,1]
		local spatial_2 = string(`spatial_2', "%9.3f")
		
eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment , noabsorb vce(robust)
		qui estadd local Cluster = `Cluster'
		qui estadd local wide = `wide'
		qui estadd local spatial_1 = `spatial_1'	
		qui estadd local spatial_2 = `spatial_2'
		qui estadd local Demographics "Y"
		qui estadd local Employment "Y"		
		qui estadd local Weight "N"

************************** Column 4 
		reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income , noabsorb vce(cluster dc)
		matrix m = r(table)
		local Cluster = m[4,1]
		local Cluster = string(`Cluster', "%9.3f")

		reg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income , vce(cluster dc)
		boottest log_Events_Count_1124, seed(520) boot(wild) nograph 
		local wide = `r(p)'
		local wide = string(`wide', "%9.3f")
		
		acreg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income , spatial latitude(Latitude)  longitude(Longitude) dist(0.5)
		matrix m = r(table)
		local spatial_1 = m[4,1]
		local spatial_1 = string(`spatial_1', "%9.3f")

		acreg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income , spatial latitude(Latitude)  longitude(Longitude) dist(1)
		matrix m = r(table)
		local spatial_2 = m[4,1]
		local spatial_2 = string(`spatial_2', "%9.3f")
		
eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income, noabsorb vce(robust)
		qui estadd local Cluster = `Cluster'
		qui estadd local wide = `wide'
		qui estadd local spatial_1 = `spatial_1'	
		qui estadd local spatial_2 = `spatial_2'
		qui estadd local Demographics "Y"
		qui estadd local Employment "Y"	
		qui estadd local Income "Y"		
		qui estadd local Weight "N"

************************** Column 5
		reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income, absorb(dc_class) vce(cluster dc)
		matrix m = r(table)
		local Cluster = m[4,1]
		local Cluster = string(`Cluster', "%9.3f")
		
		reg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income i.dc_class_f, vce(cluster dc)
		boottest log_Events_Count_1124, seed(520) boot(wild) nograph 
		local wide = `r(p)'
		local wide = string(`wide', "%9.3f")
		
		acreg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income i.dc_class_f, spatial latitude(Latitude)  longitude(Longitude) dist(0.5)
		matrix m = r(table)
		local spatial_1 = m[4,1]
		local spatial_1 = string(`spatial_1', "%9.3f")

		acreg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income i.dc_class_f, spatial latitude(Latitude)  longitude(Longitude) dist(1)
		matrix m = r(table)
		local spatial_2 = m[4,1]
		local spatial_2 = string(`spatial_2', "%9.3f")
		
eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income, absorb(dc_class) vce(robust)
		qui estadd local Cluster = `Cluster'
		qui estadd local wide = `wide'
		qui estadd local spatial_1 = `spatial_1'	
		qui estadd local spatial_2 = `spatial_2'
		qui estadd local Demographics "Y"
		qui estadd local Employment "Y"	
		qui estadd local Income "Y"		
		qui estadd local Weight "N"
		qui estadd local District "Y"

************************** Column 6
		reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income [aw=t_pop_2016], absorb(dc_class) vce(cluster dc)
		matrix m = r(table)
		local Cluster = m[4,1]
		local Cluster = string(`Cluster', "%9.3f")

		reg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], vce(cluster dc)
		boottest log_Events_Count_1124, seed(520) boot(wild) nograph 
		local wide = `r(p)'
		local wide = string(`wide', "%9.3f")
	
		acreg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income i.dc_class_f [w=t_pop_2016], spatial latitude(Latitude)  longitude(Longitude) dist(0.5)
		matrix m = r(table)
		local spatial_1 = m[4,1]
		local spatial_1 = string(`spatial_1', "%9.3f")

		acreg d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income i.dc_class_f [w=t_pop_2016], spatial latitude(Latitude)  longitude(Longitude) dist(1)
		matrix m = r(table)
		local spatial_2 = m[4,1]
		local spatial_2 = string(`spatial_2', "%9.3f")
		
eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income [aw=t_pop_2016], absorb(dc_class) vce(robust)
		qui estadd local Cluster = `Cluster'
		qui estadd local wide = `wide'
		qui estadd local spatial_1 = `spatial_1'	
		qui estadd local spatial_2 = `spatial_2'
		qui estadd local Demographics "Y"
		qui estadd local Employment "Y"	
		qui estadd local Income "Y"	
		qui estadd local District "Y"
		qui estadd local Weight "2016 pop"

esttab using "$output/Final Tables/Table B3 Turnout Cluster.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "OLS Regression Results of Protest Intensity on Turnouts, Cluster at District Councils" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) p(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
label booktabs nonotes collabels(none) ///
nomtitles ///
obslast ///
scalars("Cluster Clus. at DC" "wide Roodman et al. (2019)" "spatial_1 Colella et al. (2020) 500m" "spatial_2 Colella et al. (2020) 1km"  "Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "r2 \(R^2\)" ) sfmt(%9.3f) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})
