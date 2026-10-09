**************************************************************************
*********Stata codes used to produce Figure 1 and Figure 2****************
/* Qian, Yue, & Hu, Yang. (2025). Straight jacket: The implications of multidimensional sexuality for relationship quality and stability. Sociological Science, 12, 51-75. https://doi.org/10.15195/v12.a3 

Full replication package for this study is available at https://osf.io/n32ty/
*/
**************************************************************************

/*
Stata packages coefplot and cleanplots need to be installed to produce the graphs
coefplot - https://repec.sowi.unibe.ch/stata/coefplot/
cleanplots - https://www.trentonmize.com/software/cleanplots
*/

cd "/Users/yueqian/Desktop"
log using "graph_Qian_Hu_2025_SocSci", text

// #0
// program setup
version 18.0
clear all
set more off
matrix drop _all
set linesize 120

// #1
// open data for Figure 1
clear
use regressdata_quality, clear

// #2
// define macro for Figure 1
global controls "dur_yr c.dur_yr#c.dur_yr i.relstatus age c.age#c.age i.rrace i.col i.wave"

// #3
// graph Figure 1
foreach v in dif_iden dif_attract{

regress satisfy i.`v' i.samesex i.female ///
	`v'#samesex `v'#female samesex#female ///
	`v'#samesex#female ///
	$controls, vce(cluster pid) 
	
margins female#samesex, dydx(`v') post
estimates store `v'_main

}

coefplot dif_iden_main, bylabel({bf:Identity–partnership inconsistency}) || ///
	dif_attract_main, bylabel({bf:Attraction–partnership inconsistency}) ///
	||, yline(0) ytitle("Average maginal effects", size(small)) vertical ///
	mlabel format(%9.2f) mlabposition(2) ///
	levels(95 90) ///
	coeflabels(0.female#0.samesex = `""Men in" "different-sex" "partnerships""' ///
	0.female#1.samesex = `""Men in" "same-sex" "partnerships""' ///
	1.female#0.samesex = `""Women in" "different-sex" "partnerships""' ///
	1.female#1.samesex = `""Women in" "same-sex" "partnerships""', labsize(small)) ///
	subtitle(, size(small) bcolor(gs15) bmargin(zero)) ///
	yscale(range(-1(0.5)1)) ylabel(-1(0.5)1)
graph export "graph_Qian_Hu_2025_SocSci_Figure1.pdf"

// #4
// open data Figure 2
clear
use regressdata_breakup, clear

* clear macro / stored estimates
macro drop _all
estimates clear

// #5
// define macro Figure 2
global controls "dur_yr c.dur_yr#c.dur_yr i.relstatus age_vary c.age_vary#c.age_vary i.rrace i.col i.retro"

// #6
// graph Figure 2
foreach v in dif_iden dif_attract{

logit _d i.`v' i.samesex i.female ///
	`v'#samesex `v'#female samesex#female ///
	`v'#samesex#female ///
	$controls, vce(cluster pid) 
	
margins female#samesex, dydx(`v') post
estimates store `v'_main

}

coefplot dif_iden_main, bylabel({bf:Identity–partnership inconsistency}) || ///
	dif_attract_main, bylabel({bf:Attraction–partnership inconsistency}) ///
	||, yline(0) ytitle("Average maginal effects in percentage points (%)", size(small)) vertical ///
	mlabel format(%9.2f) mlabposition(2) ///
	levels(95 90) rescale(100) ///
	coeflabels(0.female#0.samesex = `""Men in" "different-sex" "partnerships""' ///
	0.female#1.samesex = `""Men in" "same-sex" "partnerships""' ///
	1.female#0.samesex = `""Women in" "different-sex" "partnerships""' ///
	1.female#1.samesex = `""Women in" "same-sex" "partnerships""', labsize(small)) ///
	subtitle(, size(small) bcolor(gs15) bmargin(zero)) ///
	yscale(range(-1(0.5)1)) ylabel(-1(0.5)1)
graph export "graph_Qian_Hu_2025_SocSci_Figure2.pdf"

log close
exit
