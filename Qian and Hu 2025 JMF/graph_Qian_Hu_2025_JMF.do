**************************************************************************
*********Stata codes used to produce Figure 1 and Figure 2****************
/* Qian, Yue, & Hu, Yang. (2025). How couples meet and assortative mating in Canada. Journal of Marriage and Family, 87(1), 392-407. https://doi.org/10.1111/jomf.12967 */
**************************************************************************

/*
Stata packages coefplot and cleanplots need to be installed to produce the graphs
coefplot - https://repec.sowi.unibe.ch/stata/coefplot/
cleanplots - https://www.trentonmize.com/software/cleanplots
*/

cd "/Users/yueqian/Desktop"
log using "graph_Qian_Hu_2025_JMF", text

// #0
// program setup
version 18.0
clear all
set more off

// #1
// open data
clear
use reg_sample_06022023, clear

// #2
// define macro
global control "i.gender i.edu4 white immig agev2 morder i.mar3 currentrel rtime_yr relstart i.region4 i.resid"
global meet "meet1"

// #3
// regression
foreach v in edu race immig age{

display "DV = `v': start"

logit `v'inter i.online $control
margins online, post
estimates store `v'm1
	

logit `v'inter ib4.$meet $control
margins $meet, post
estimates store `v'm2

display "DV = `v': end"

}

// #4
// graph Figure 1
coefplot edum1 edum2, bylabel("Education") /// 
	|| racem1 racem2, bylabel("Race") ///
	|| immigm1 immigm2, bylabel("Nativity") ///
	|| agem1 agem2, bylabel("Age") ///
	||, vertical ///
	recast(bar) barwidth(0.5) fcolor(*.75) lcolor(*.75) ///
	citop citype(logit) ciopt(recast(rcap)) ///
	mlabel format(%4.2f) mlabposition(1) ///	
	ytitle("Probability of heterogamy (male partner" "different from female partner)", ///
	size(small) margin(0 0 10 0)) ///
	yscale(range(0 .8)) ylabel(0(.2).8, nogrid) ///
	xlabel(1 "Offline" 2 "Online" ///
	4 `""Offline," "formal" "institutions""' 5 `""Offline," "social" "ties""' 6 `""Offline," "other""'  ///
	7 "Online", labsize(small)) ///
	groups(?.online = " " ///
	?.$meet = " ") ///
	nokey ///
	byopts(cols(2)) plotregion(lcolor(gs16)) ///
	subtitle(, bcolor(gs15) bmargin(zero)) ///
	xtitle("How couples met", size(small) margin(8 0 0 -5))
graph export "graph_Qian_Hu_2025_JMF_Figure1.pdf"

// #5
// graph AME (Figure 2)
tab online offline, m

foreach v in edu race immig age{

display "DV = `v': start"

mlogit `v'pair i.offline $control 
estimates store `v'_offm

	foreach num in 1 2{
		
		estimates restore `v'_offm
		margins, dydx(offline) predict(outcome(`num')) post
		estimates store `v'_off`num'
	}

display "DV = `v': end"

}

foreach v in edu race immig age{
		
	mlogit `v'pair ib4.$meet $control
	estimates store `v'_offm4

	foreach iv in 1 2 3{
			foreach num in 1 2{
				
				estimates restore `v'_offm4
				margins, dydx(`iv'.$meet) predict(outcome(`num')) post
				estimates store `v'_meet`iv'_`num'
			}
	}

}

coefplot edu_off1 edu_meet1_1 edu_meet2_1 edu_meet3_1, bylabel("Educational Hypergyny") ///
	  || edu_off2 edu_meet1_2 edu_meet2_2 edu_meet3_2, bylabel("Educational Hypogyny") /// 
	|| race_off1 race_meet1_1 race_meet2_1 race_meet3_1, bylabel("Racial Hypergyny") ///
	|| race_off2 race_meet1_2 race_meet2_2 race_meet3_2, bylabel("Racial Hypogyny") ///
	|| immig_off1 immig_meet1_1 immig_meet2_1 immig_meet3_1, bylabel("Nativity Hypergyny") ///
	|| immig_off2 immig_meet1_2 immig_meet2_2 immig_meet3_2, bylabel("Nativity Hypogyny") ///
	|| age_off1 age_meet1_1 age_meet2_1 age_meet3_1, bylabel("Age Hypergyny") ///
	|| age_off2 age_meet1_2 age_meet2_2 age_meet3_2, bylabel("Age Hypogyny") ///
	||, vertical ///
	ytitle("Average marginal effects of meeting offline on hypergyny (left) or hypogyny (right)", ///
	size(small) margin(0 0 9 0)) ///
	byopts(cols(2)) nokey ///
	yline(0) ///
	p1(msymbol(o)) ///
	p2(msymbol(d)) ///
	p3(pstyle(p2) msymbol(t)) ///
	p4(pstyle(p2) msymbol(s)) ///
	mlabel mlabsize(*.8) format(%4.2f) mlabposition(3) ///
	xlabel(1 `""Offline" "vs. Online""' ///
	3 `""Offline," "formal" "institutions""' 4 `""Offline," "social" "ties""' 5 `""Offline," "other""', ///
	labsize(*.9)) ///
	groups(1.$meet 3.$meet = "vs. Online") ///
	subtitle(, size(small) bcolor(gs15) bmargin(zero)) ///
	ysize(8)
graph export "graph_Qian_Hu_2025_JMF_Figure2.pdf"

log close
exit
