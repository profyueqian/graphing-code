**************************************************************************
*********Stata codes used to produce Figure 2*****************************
/* Fan, Wen, & Qian, Yue. (2023). State contexts, job insecurity, and subjective well-being in the time of COVID-19. Journal of Happiness Studies, 24(6), 2039-2059. https://doi.org/10.1007/s10902-023-00669-9
*/
**************************************************************************

/*
Stata packages coefplot and cleanplots need to be installed to produce the graphs
coefplot - https://repec.sowi.unibe.ch/stata/coefplot/
cleanplots - https://www.trentonmize.com/software/cleanplots
*/

cd "/Users/yueqian/Desktop"
log using "graph_Fan_Qian_2023_JOHS", text

// #0
// program setup
version 16.1
clear all
set more off
matrix drop _all
set linesize 120


// #1
// open data
use insecure_wave123, clear

* xtset
xtset RespId
sort RespId wave


// #2
// demean variables
gen insec1 = insecurity==1
gen insec2 = insecurity==2
gen insec3 = insecurity==3
bysort RespId: egen minsec1 = mean(insec1)
bysort RespId: egen minsec2 = mean(insec2)
bysort RespId: egen minsec3 = mean(insec3)
forvalues v = 1/3{
	gen dminsec`v' = insec`v' - minsec`v'
	tab dminsec`v', m
}

bysort RespId: egen mcase = mean(daycase)
gen dmcase = daycase - mcase
sum dmcase


// #3
// graph Figure 2
sum dmcase
xtreg mh c.dminsec2##c.dmcase c.dminsec3##c.dmcase mstringencyindex unemp covidc i.wkunit i.wkhome i.wkhours, fe vce(cluster ppstaten)
margins, dydx(dminsec2) at(dmcase=(-7(1)10)) post
estimates store case2

xtreg mh c.dminsec2##c.dmcase c.dminsec3##c.dmcase mstringencyindex unemp covidc i.wkunit i.wkhome i.wkhours, fe vce(cluster ppstaten)
margins, dydx(dminsec3) at(dmcase=(-7(1)10)) post
estimates store case3

coefplot (case2, label(not too likely)) (case3, label(fairly/very likely)), yline(0) vertical at recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash))
coefplot (case2, lcolor(black)), bylabel("Average marginal effect of 'not too likely'") ///
		|| (case3, lcolor(black)), bylabel("Average marginal effect of 'fairly/very likely'") ///
		xtitle(Change in COVID-19 case rate) xscale(r(-10(2)10)) ///
		ytitle(Change in mental health) ///
		yline(0, lcolor(gray) lpattern(solid)) vertical at recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash) color(gray)) yscale(r(-1(0.2)1))
graph export "graph_Fan_Qian_2023_JOHS_Figure2.pdf"


log close
exit
