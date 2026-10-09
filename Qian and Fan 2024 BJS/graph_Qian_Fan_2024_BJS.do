**************************************************************************
*********Stata codes used to produce Figure 1 and Figure 2****************
/* Qian, Yue, & Fan, Wen. (2024). Stressful life events and depressive symptoms during COVID‐19: A gender comparison. The British Journal of Sociology, 75(1), 38-47. https://doi.org/10.1111/1468-4446.13067 
*/
**************************************************************************

/*
Stata packages coefplot and cleanplots need to be installed to produce the graphs
coefplot - https://repec.sowi.unibe.ch/stata/coefplot/
cleanplots - https://www.trentonmize.com/software/cleanplots
*/

cd "/Users/yueqian/Desktop"
log using "graph_Qian_Fan_2024_BJS", text

// #0
// program setup
version 18.0
clear all
set more off
matrix drop _all
set linesize 120

// #1
// open data
clear
use regdata_bjs.dta, clear 

* survey set the data
svyset RespId [pweight=weight]

// #2
// define macro
global events "none money relation lockdown death worry moving society health jobloss care politics work freetime novisit allother"
global events_yes "money relation lockdown death worry moving society health jobloss care politics work freetime novisit allother"
global controls "ppage i.ppeducat i.race4 i.mar i.ppreg4"

// #3
// life events by gender: Figure 1
foreach v in $events{	
	svy, subpop(female): proportion `v'
	estimates store `v'f
	svy, subpop(male): proportion `v'
	estimates store `v'm
}

coefplot (nonem, keep(1.none)) ///
	(politicsm, keep(1.politics)) ///
	(novisitm, keep(1.novisit)) ///	
	(workm, keep(1.work)) ///
	(carem, keep(1.care)) ///
	(healthm, keep(1.health)) ///
	(deathm, keep(1.death)) ///
	(freetimem, keep(1.freetime)) ///
	(joblossm, keep(1.jobloss)) ///
	(societym, keep(1.society)) ///	
	(movingm, keep(1.moving)) ///
	(worrym, keep(1.worry)) ///
	(lockdownm, keep(1.lockdown)) ///
	(relationm, keep(1.relation)) ///	
	(moneym, keep(1.money)) ///
	(allotherm, keep(1.allother)), ///
	fcolor(green*.5) lcolor(green*.5) ciopts(recast(rcap) color(green)) ///
	recast(bar) barwidth(0.3) ///
	citop citype(logit) legend(off) ///
	rescale(100) ///
	offset(0) bylabel(Men) nokey ///     
	|| ///
	(nonef, keep(1.none)) ///
	(politicsf, keep(1.politics)) ///
	(novisitf, keep(1.novisit)) ///	
	(workf, keep(1.work)) ///
	(caref, keep(1.care)) ///
	(healthf, keep(1.health)) ///
	(deathf, keep(1.death)) ///
	(freetimef, keep(1.freetime)) ///
	(joblossf, keep(1.jobloss)) ///
	(societyf, keep(1.society)) ///
	(movingf, keep(1.moving)) ///
	(worryf, keep(1.worry)) ///
	(lockdownf, keep(1.lockdown)) ///
	(relationf, keep(1.relation)) ///	
	(moneyf, keep(1.money)) ///
	(allotherf, keep(1.allother)), ///
	fcolor(orange*.5) lcolor(orange*.5) ciopts(recast(rcap) color(orange)) ///
	recast(bar) barwidth(0.3) ///
	citop citype(logit) nokey ///
	rescale(100) ///
	offset(0) bylabel(Women) legend(off) /// 
	||,	norecycle coeflabels(1.none = "None**" 1.politics = "Politics***" 1.death = "Death*" ///
	1.novisit = "No social life*" 1.work = "Paid work**" 1.health = "Health*" 1.care = "Care work*" ///
	1.relation = "Relationships" 1.freetime = "Activities" 1.lockdown = "Staying home" ///
	1.jobloss = "Job loss" 1.money = "Finances" 1.moving = "Residential" ///
	1.society = "Society" 1.worry = "Emotional state" 1.allother = "Other", labgap(2)) ///
	headings(1.none = "{bf:women < men}" 1.novisit = "{bf:women > men}" 1.freetime = "{bf:women = men}") ///
	ytitle("Type of Life Events", size(small)) xtitle("Percentage", margin(20 0 0 0) size(small)) ///
	xlabel(, nogrid) xscale(range(0(5)20)) yscale(noline) ///
	addplot(scatter @at @b, ms(i) mlabel(@b) mlabcolor(black) mlabposition(2) mlabformat("%9.2f")) ///
	grid(none) subtitle(, bcolor(gs15) bmargin(zero))
graph export "graph_Qian_Fan_2024_BJS_Figure1.pdf"

// #4
// life events and mental distress: Figure 2	
foreach v in $events_yes{
	gen `v'3 = 0 if none==1
	replace `v'3 = 1 if `v'==1
	replace `v'3 = 2 if `v'==0 & none==0
	label define `v'3 0 "none" 1 "`v'" 2 "other"
	label values `v'3 `v'3
	tab `v'3, m
}

svy: reg mh female $controls
	estimates store base
	
foreach v in $events_yes{	
	svy: reg mh female $controls i.`v'3 dmultiple
	estimates store `v'
}

coefplot allother novisit freetime work politics care jobloss health society moving worry death lockdown relation money, ///
	keep(1.allother3 1.novisit3 1.freetime3 1.work3 1.politics3 ///
	1.care3 1.jobloss3 1.health3 1.society3 1.moving3 1.worry3 ///
	1.death3 1.lockdown3 1.relation3 1.money3) /// 
	legend(off) nooffset msymbol(O) msize(vsmall) mcolor(blue*.7) ciopts(recast(rcap) color(blue*.7)) ///
	mlabel mlabcolor(blue*.7) format(%9.2f) mlabposition(12) ///
	yscale(noline) xlabel(-1(1)5, nogrid) xscale(range(-1(1)5)) xline(0, lcolor(red*.7)) ///
	coeflabels(1.politics3 = "Politics" 1.death3 = "Death" 1.novisit3 = "No social life" ///
	1.work3 = "Paid work" 1.health3 = "Health" 1.care3 = "Care work" ///
	1.relation3 = "Relationships" 1.freetime3 = "Activities" 1.lockdown3 = "Staying home" ///
	1.jobloss3 = "Job loss" 1.money3 = "Finances" 1.moving3 = "Residential" ///
	1.society3 = "Society" 1.worry3 = "Emotional state" 1.allother3 = "Other", labgap(2)) ///
	grid(none) ///
	ytitle("Type of Life Events", size(small)) ///
	xtitle("Coefficient (Relative to No Stressful Life Events)", size(small) margin(0 5 0 2.5)) 
graph export "graph_Qian_Fan_2024_BJS_Figure2.pdf"

log close
exit
