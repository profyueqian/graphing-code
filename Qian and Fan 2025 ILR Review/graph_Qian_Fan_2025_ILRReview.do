**************************************************************************
*********Stata codes used to produce Figures 1–4**************************
/* Qian, Yue, & Fan, Wen. Did the COVID-19 Pandemic Make It Worse? Working from Home and Affective Well-Being at the Intersections of Parental Status and Occupation. ILR Review. https://doi.org/10.1177/00197939251390748
*/
**************************************************************************


***********************************************************
**************************set up program*******************
***********************************************************
// change directory
global root "/Users/yueqian/Downloads"
cd "$root"

// open log file
capture log close
log using "graph_Qian_Fan_2025_ILRReview", text

/*
Stata packages coefplot and cleanplots need to be installed to produce the graphs
coefplot - https://repec.sowi.unibe.ch/stata/coefplot/
cleanplots - https://www.trentonmize.com/software/cleanplots
*/

// version control
version 18.0
clear all
set more off
matrix drop _all
set linesize 120

// set up macros
global date "09062024"

global par "i.female i.r i.ed3 age lnearn health painkill kidund6 kid6to12 kid13to17 i.spouse i.wkhours durcare durhw ib22.ind14 i.region"

global occ "mean_unemp mean_female_acs mean_white_acs mean_col_acs mean_parttime_acs lnwkearn"

global notpar "i.female i.r i.ed3 age lnearn health painkill i.spouse i.wkhours durcare durhw ib22.ind14 i.region"


***********************************************************
*****main analysis: two way interaction********************
***********************************************************
use reg_sample, clear
count

// label variables to more easily create graph with loops
label var par "Parents"
gen notpar = not_par
label var notpar "Non-parents"
label var per_negative4 "Negative affect"


// two-way interactions
foreach v in negative4{
		
	reg per_`v' ib2.loc6 i.pandemic loc6#pandemic ///
		mean_home i.par ///
		$par $occ [pw=wbwt], vce(cluster hocc)
	estimates store `v'2
	outreg2 using "$date results", excel dec(3) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +)	
}

// post-estimation test
foreach p in 0 1{
	foreach v in negative4{
			
		estimates restore `v'2 
		margins, dydx(loc6) at(pandemic=`p')
		
}
}

// two-way interactions: graphs
foreach p in 0 1{
	foreach v in negative4{
			
		estimates restore `v'2 
		margins loc6, at(pandemic=`p') post
		estimates store all`p'`v'2
		
}
}

// two-way interactions: graphs (negative4)
foreach v in negative4{
	
	coefplot (all0`v'2, recast(bar) barwidth(0.3) fcolor(red*.5) ///
		ciopt(recast(rcap) lcolor(red)) citop lcolor(%0)) ///
		|| (all1`v'2, recast(bar) barwidth(0.3) fcolor(eltblue*.5) ///
		ciopt(recast(rcap) lcolor(eltblue)) citop lcolor(%0))  ///
		|| , vertical format(%9.2f) ///
		ytitle("`: var label per_`v''") ///
		mlabel mlabpos(2) mlabcolor(black) ///
		xlabel(1 "Working from home" 2 "Working away from home", tlength(0)) ///
		legend(position(6) row(1)) ///
		ylabel(0(.5)2) ///
		xscale(lstyle(none)) ///
		bylabels("Pre-pandemic (2010, 2012, 2013)" "Pandemic (2021)") ///
		norecycle byopts(legen(off))
	graph save all`v'2

}

graph export "Figure 1.pdf"


***********************************************************
*****main analysis: two way interaction by parent status***
***********************************************************
estimates clear

// two-way interactions
foreach s in par notpar{
	foreach v in negative4{
		
		display "sample = `s'"
		reg per_`v' ib2.loc6 i.pandemic loc6#pandemic ///
			mean_home ///
			$`s' $occ [pw=wbwt] if `s'==1, vce(cluster hocc)
		estimates store `s'_`v'2
		outreg2 using "$date results", excel bdec(3) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +)
	
}
}

// post-estimation test
foreach s in par notpar{
	foreach p in 1 2{
			foreach v in negative4{
			
		estimates restore `s'_`v'2  
		margins, dydx(pandemic) at(loc6=`p')
		
}
}
}

// two-way interactions: graphs
foreach s in par notpar{
	foreach p in 0 1{
			foreach v in negative4{
			
				estimates restore `s'_`v'2 
				margins loc6, at(pandemic=`p') post
				estimates store `s'`p'`v'2
		
}
}
}

foreach s in par{
	foreach v in negative4{
	
		coefplot (`s'0`v'2, recast(bar) barwidth(0.3) fcolor(red*.5) ///
			ciopt(recast(rcap) lcolor(red)) citop lcolor(%0)) ///
			(`s'1`v'2, recast(bar) barwidth(0.3) fcolor(eltblue*.5) ///
			ciopt(recast(rcap) lcolor(eltblue)) citop lcolor(%0)), ///
			bylabel(loc6) ///
			|| (not`s'0`v'2, recast(bar) barwidth(0.3) fcolor(red*.5) ///
			ciopt(recast(rcap) lcolor(red)) citop lcolor(%0)) ///
			(not`s'1`v'2, recast(bar) barwidth(0.3) fcolor(eltblue*.5) ///
			ciopt(recast(rcap) lcolor(eltblue)) citop lcolor(%0)), ///
			bylabel(loc6) ///
			|| , vertical format(%9.2f) ///
			ytitle("`: var label per_`v''") ///
			plotlabels("Pre-pandemic (2010, 2012, 2013)" "Pandemic (2021)") ///
			mlabel mlabpos(2) mlabcolor(black) ///
			xlabel(1 "Working from home" 2 "Working away from home", tlength(0)) ///
			ylabel(0(.5)2) ///
			xscale(lstyle(none)) ///
			bylabels("`: var label `s''" "`: var label not`s''") ///
			byopts(legend(position(6))) ///
			legend(row(1))
		graph save `s'`v'2

}
}

graph export "Figure 2.pdf"


***********************************************************
*****full models: three way interaction by parent status***
***********************************************************
estimates clear

// parents
foreach s in par notpar{
	foreach v in negative4{
		
		display "sample = `s'"
		reg per_`v' ib2.loc6 i.pandemic mean_home ///
			loc6#pandemic c.mean_home#loc6 c.mean_home#pandemic ///
			c.mean_home#loc6#pandemic ///
			$`s' $occ [pw=wbwt] if `s'==1, vce(cluster hocc)
		estimates store `s'_`v'_occ
		outreg2 using "$date results", excel bdec(3) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +)
		
}
}

// post-estimation test
foreach s in par{
	foreach p in 1{
			foreach v in negative4{
			
		estimates restore `s'_`v'_occ  
		margins pandemic, at(loc6=`p' mean_home=(.1 .4))
		margins, dydx(pandemic) at(loc6=`p' mean_home=(.1 .4))
		
}
}
}


foreach s in par notpar{
	foreach p in 0 1{
		foreach loc in 1 2{
			foreach v in negative4{
			
				estimates restore `s'_`v'_occ
				margins, at(pandemic=`p' loc6=`loc' mean_home=(0(.1).6)) post
				estimates store `s'`p'`loc'`v'
		
}
}
}
}

foreach s in par{
	foreach v in negative4{
	
		coefplot (`s'01`v', label("Pre-pandemic (2010, 2012, 2013)") ///
			recast(line) lcolor(red) ///
			ciopts(recast(rarea) fcolor(red%50) lcolor(red*.5) lpattern(dash))) ///
			(`s'11`v', label("Pandemic (2021)") ///
			recast(line) lcolor(eltblue) ///
			ciopts(recast(rarea) fcolor(eltblue%50) lcolor(eltblue*.5) lpattern(dash))), ///
			bylabel("`: var label `s'' working from home") ///
			|| (`s'02`v', label("Pre-pandemic (2010, 2012, 2013)") ///
			recast(line) lcolor(red) ///
			ciopts(recast(rarea) fcolor(red%50) lcolor(red*.5) lpattern(dash))) ///
			(`s'12`v', label("Pandemic (2021)") ///
			recast(line) lcolor(eltblue) ///
			ciopts(recast(rarea) fcolor(eltblue%50) lcolor(eltblue*.5) lpattern(dash))), ///
			bylabel("`: var label `s'' working away from home") ///
			|| (not`s'01`v', label("Pre-pandemic (2010, 2012, 2013)") ///
			recast(line) lcolor(red) ///
			ciopts(recast(rarea) fcolor(red%50) lcolor(red*.5) lpattern(dash))) ///
			(not`s'11`v', label("Pandemic (2021)") ///
			recast(line) lcolor(eltblue) ///
			ciopts(recast(rarea) fcolor(eltblue%50) lcolor(eltblue*.5) lpattern(dash))), ///
			bylabel("`: var label not`s'' working from home") ///
			|| (not`s'02`v', label("Pre-pandemic (2010, 2012, 2013)") ///
			recast(line) lcolor(red) ///
			ciopts(recast(rarea) fcolor(red%50) lcolor(red*.5) lpattern(dash))) ///
			(not`s'12`v', label("Pandemic (2021)") ///
			recast(line) lcolor(eltblue) ///
			ciopts(recast(rarea) fcolor(eltblue%50) lcolor(eltblue*.5) lpattern(dash))), ///
			bylabel("`: var label not`s'' working away from home") ///
			vertical format(%9.2f) ///
			xlabel(1 "0" 2 ".1" 3 ".2" 4 ".3" 5 ".4" 6 ".5" 7 ".6") ///
			xtitle("Occupational teleworkability", size(small)) ///
			ytitle("`: var label per_`v''") ///
			ylabel(0(.5)3) ///
			byopts(legend(position(6))) ///
			offset(0) ///
			legend(row(1))
		graph save `s'`v'3full_occ

}
}

graph export "Figure 3.pdf"


***********************************************************
**************************oxford data**********************
***********************************************************

***********************************************************
***main analysis: three way interaction by parent status***
***********************************************************
estimates clear

use "$root/reg_sample", clear
count

merge m:1 statefip date using "$root/oxford"
bysort _merge: tab year, m
drop if _merge==2
drop _merge

tab c1m_schoolclosing, m
/*
0 - no measures
1 - recommend closing or all schools open with alterations resulting in significant differences compared to non-Covid-19 operations
2 - require closing (only some levels or categories, eg just high school, or just public schools)
3 - require closing all levels
*/
gen opandemic = pandemic
replace pandemic = 1 if year==2021 & (c1m_schoolclosing==0 | c1m_schoolclosing==1)
replace pandemic = 2 if year==2021 & (c1m_schoolclosing==2 | c1m_schoolclosing==3)
tab pandemic, m


// label variables to more easily create graph with loops
label var par "Parents"
gen notpar = not_par
label var notpar "Non-parents"
label var per_negative4 "Negative affect"

***********************************************************
*****full models: three way interaction by parent status***
***********************************************************
estimates clear

// parents
foreach s in par notpar{
	foreach v in negative4{

	
		display "sample = `s'"
		reg per_`v' ib2.loc6 i.pandemic mean_home ///
			loc6#pandemic c.mean_home#loc6 c.mean_home#pandemic ///
			c.mean_home#loc6#pandemic ///
			$`s' $occ [pw=wbwt] if `s'==1, vce(cluster hocc)
		estimates store `s'_`v'_occ
		outreg2 using "$date results", excel bdec(3) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +)
	
}
}


// post-estimation test
foreach s in par{
	foreach p in 1{
			foreach v in negative4{
			
		estimates restore `s'_`v'_occ  
		margins pandemic, at(loc6=`p' mean_home=(.1)) 
		margins pandemic, at(loc6=`p' mean_home=(.1)) pwcompare(pveffects)
		
}
}
}


foreach s in par notpar{
	foreach p in 0 1 2{
		foreach loc in 1 2{
			foreach v in negative4{
			
				estimates restore `s'_`v'_occ
				margins, at(pandemic=`p' loc6=`loc' mean_home=(0(.1).6)) post
				estimates store `s'`p'`loc'`v'
		
}
}
}
}

foreach s in par{
	foreach v in negative4{
	
		coefplot (`s'01`v', label("Pre-pandemic (2010, 2012, 2013)") ///
			recast(line) lcolor(red) ///
			ciopts(recast(rarea) fcolor(red%50) lcolor(red*.5) lpattern(dash))) ///
			(`s'11`v', label("Pandemic (2021), School Open") ///
			recast(line) lcolor(eltblue) ///
			ciopts(recast(rarea) fcolor(eltblue%50) lcolor(eltblue*.5) lpattern(dash))) ///
			(`s'21`v', label("Pandemic (2021), School Closure") ///
			recast(line) lcolor(blue) ///
			ciopts(recast(rarea) fcolor(blue%50) lcolor(blue*.5) lpattern(dash))), ///
			bylabel("`: var label `s'' working from home") ///
			|| (`s'02`v', label("Pre-pandemic (2010, 2012, 2013)") ///
			recast(line) lcolor(red) ///
			ciopts(recast(rarea) fcolor(red%50) lcolor(red*.5) lpattern(dash))) ///
			(`s'12`v', label("Pandemic (2021), School Open") ///
			recast(line) lcolor(eltblue) ///
			ciopts(recast(rarea) fcolor(eltblue%50) lcolor(eltblue*.5) lpattern(dash))) ///
			(`s'22`v', label("Pandemic (2021), School Closure") ///
			recast(line) lcolor(blue) ///
			ciopts(recast(rarea) fcolor(blue%50) lcolor(blue*.5) lpattern(dash))), ///
			bylabel("`: var label `s'' working away from home") ///
			|| (not`s'01`v', label("Pre-pandemic (2010, 2012, 2013)") ///
			recast(line) lcolor(red) ///
			ciopts(recast(rarea) fcolor(red%50) lcolor(red*.5) lpattern(dash))) ///
			(not`s'11`v', label("Pandemic (2021), School Open") ///
			recast(line) lcolor(eltblue) ///
			ciopts(recast(rarea) fcolor(eltblue%50) lcolor(eltblue*.5) lpattern(dash))) ///
			(not`s'21`v', label("Pandemic (2021), School Closure") ///
			recast(line) lcolor(blue) ///
			ciopts(recast(rarea) fcolor(blue%50) lcolor(blue*.5) lpattern(dash))), ///
			bylabel("`: var label not`s'' working from home") ///
			|| (not`s'02`v', label("Pre-pandemic (2010, 2012, 2013)") ///
			recast(line) lcolor(red) ///
			ciopts(recast(rarea) fcolor(red%50) lcolor(red*.5) lpattern(dash))) ///
			(not`s'12`v', label("Pandemic (2021), School Open") ///
			recast(line) lcolor(eltblue) ///
			ciopts(recast(rarea) fcolor(eltblue%50) lcolor(eltblue*.5) lpattern(dash))) ///
			(not`s'22`v', label("Pandemic (2021), School Closure") ///
			recast(line) lcolor(blue) ///
			ciopts(recast(rarea) fcolor(blue%50) lcolor(blue*.5) lpattern(dash))), ///
			bylabel("`: var label not`s'' working away from home") ///
			vertical format(%9.2f) ///
			xlabel(1 "0" 2 ".1" 3 ".2" 4 ".3" 5 ".4" 6 ".5" 7 ".6") ///
			xtitle("Occupational teleworkability", size(small)) ///
			ytitle("`: var label per_`v''") ///
			ylabel(0(.5)3) ///
			byopts(legend(position(6))) ///
			offset(0) ///
			legend(row(1) stack)
		graph save `s'`v'3full_occ_oxford

}
}

graph export "Figure 4.pdf"

log close
exit
