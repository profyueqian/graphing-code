cd "/Users/yueqian/Downloads"
log using "graph_Yavorsky_et_al_2025_GWO", text


**************************************************************************
*********Stata codes used to produce Figures 1-5**************************
/* 
Yavorsky, J. E., Qian, Y., & Glauber, R. (2025). Workplace Productivity: Gender, Parenthood, and Career Consequences in the United States. Gender, Work & Organization. https://doi.org/10.1111/gwao.70027
*/
**************************************************************************

/*
Stata packages coefplot and cleanplots need to be installed to produce the graphs
coefplot - https://repec.sowi.unibe.ch/stata/coefplot/
cleanplots - https://www.trentonmize.com/software/cleanplots
*/


// #0
// program setup
version 18.0
clear all
set more off
matrix drop _all
set linesize 120


// #1
// open data
use regsample, clear


// #2
// two-way interaction - Figure 1
reg rewards_avg i.v_female ib2.v_prod survey ///
	v_female#v_prod 
estimates store n975

***** margins for graph
foreach p in 0 1{
			
	estimates restore n975
	margins v_prod, at(v_female=`p') post
	estimates store two`p'
		
}
** two0 are predictions for men and two1 are predictions for women

***** graph: gray scheme
coefplot (two0, recast(bar) barwidth(0.3) fcolor(gs10%80) ///
		lcolor(%0) ciopt(recast(rcap) lcolor(gs10)) citop) ///
		(two1, recast(bar) barwidth(0.3) fcolor(black%80) ///
		lcolor(%0) ciopt(recast(rcap) lcolor(black)) citop) ///
		, vertical format(%9.2f) ///
		ytitle("Career rewards") ///
		mlabel mlabpos(2) mlabcolor(black) ///
		ylabel(1(1)7) ///
		legend(pos(6) row(1) lab(1 "Fathers") lab(3 "Mothers")) ///
		coeflabels(0.v_prod = "Productivity increases" 1.v_prod = "Productivity constant" ///
		2.v_prod = "Productivity decreases", tlength(0))
graph export "graph_Yavorsky_et_al_2025_GWO_Figure1.pdf"	


// #3
// mediation models - graph for "productivity decrease" group only - Figure 2
foreach m in competent professionally_oriented interest_adv{
			
	reg rewards_avg i.v_female ib2.v_prod survey ///
		v_female#v_prod ///
		`m'
		estimates store m`m'
		
}

coefplot (n975, label("No mediator")) ///
	(mcompetent, label("Add competence")) ///
	(mprofessionally_oriented, label("Add professional commitment")) ///
	(minterest_adv, label("Add interest in advancement")) ///
	, keep(1.v_female) vertical yscale(range(-1 0.5)) ylabel(-1(0.5)0.5) yline(0) ///
	legend(rows(1) position(6)) ///
	coeflabels(1.v_female = "Gender gap in career rewards (mothers – fathers)", ///
	tlength(0) labcolor(white)) ///
	mlabel mlabpos(2) mlabcolor(black) mlabformat(%9.2f) ///
	ytitle("Gender gap in career rewards (mothers – fathers)", size(small))
graph export "graph_Yavorsky_et_al_2025_GWO_Figure2.pdf"


// #4
// regression models, three-way interactions - Figure 3
fre resp_female
gen resp_male = resp_female==0
tab resp_female resp_male, m

estimates clear
reg rewards_avg i.v_female ib2.v_prod survey ///
	v_female#v_prod ///
	i.resp_male ///
	resp_male#v_female resp_male#v_prod ///
	resp_male#v_female#v_prod
estimates store mint3

***** graph
foreach v in 1 0{
	foreach p in 0 1{
	
		estimates restore mint3
		margins v_prod, at(v_female=`p' resp_male=`v') post
		estimates store dv_w`p'_m`v'
}
}

***** gray scheme
coefplot (dv_w0_m1, ///
		recast(bar) barwidth(0.3) fcolor(gs10%80) lcolor(%0) ciopt(recast(rcap) lcolor(gs10)) citop) ///
		(dv_w1_m1, ///
		recast(bar) barwidth(0.3) fcolor(black%80) lcolor(%0) ciopt(recast(rcap) lcolor(black)) citop), /// 
		bylabel("Career rewards assigned by men managers") ///
		|| (dv_w0_m0, ///
		recast(bar) barwidth(0.3) fcolor(gs10%80) lcolor(%0) ciopt(recast(rcap) lcolor(gs10)) citop) ///
		(dv_w1_m0, ///
		recast(bar) barwidth(0.3) fcolor(black%80) lcolor(%0) ciopt(recast(rcap) lcolor(black)) citop), ///
		bylabel("Career rewards assigned by women managers")  ///
		|| , vertical format(%9.2f) ///
		ytitle("Career rewards") ///
		mlabel mlabpos(2) mlabcolor(black) ///
		ylabel(1(1)7) byopts(rows(2)) ///
		legend(pos(6) row(1) lab(1 "Fathers") lab(3 "Mothers")) ///
		coeflabels(0.v_prod = "Productivity increases" 1.v_prod = "Productivity constant" ///
		2.v_prod = "Productivity decreases", tlength(0))
graph export "graph_Yavorsky_et_al_2025_GWO_Figure3.pdf"	
	

// #5
// mediation models (v_female), graph productivity decrease only - Figure 4
estimates clear
reg rewards_avg i.v_female ib2.v_prod survey ///
	v_female#v_prod ///
	i.resp_female ///
	resp_female#v_female resp_female#v_prod ///
	resp_female#v_female#v_prod
	estimate store mint0

foreach m in competent professionally_oriented interest_adv{
			
	reg rewards_avg i.v_female ib2.v_prod survey ///
		v_female#v_prod ///
		i.resp_female ///
		resp_female#v_female resp_female#v_prod ///
		resp_female#v_female#v_prod ///
		`m'
		estimate store m`m'0
}

coefplot (mint0, label("No mediator")) ///
	(mcompetent0, label("Add competence")) ///
	(mprofessionally_oriented0, label("Add professional commitment")) ///
	(minterest_adv0, label("Add interest in advancement")) ///
	, keep(1.v_female) vertical yscale(range(-1 0.5)) ylabel(-1(0.5)0.5) yline(0) ///
	legend(rows(1) position(6))  ///
	coeflabels(1.v_female = "Gender gap in career rewards (mothers – fathers)", ///
	tlength(0) labcolor(white)) ///
	mlabel mlabpos(2) mlabcolor(black) mlabformat(%9.2f) ///
	ytitle("Gender gap in career rewards (mothers – fathers)", size(small))
graph export "graph_Yavorsky_et_al_2025_GWO_Figure4.pdf"


// #6
// mediation models (resp_male), graph productivity decrease only - Figure 5
fre v_female
gen v_male = v_female==0
tab v_female v_male, m

reg rewards_avg i.v_female ib2.v_prod survey ///
	v_female#v_prod ///
	i.resp_male ///
	resp_male#v_female resp_male#v_prod ///
	resp_male#v_female#v_prod
	estimate store mint0

foreach m in competent professionally_oriented interest_adv{
			
	reg rewards_avg i.v_female ib2.v_prod survey ///
		v_female#v_prod ///
		i.resp_male ///
		resp_male#v_female resp_male#v_prod ///
		resp_male#v_female#v_prod ///
		`m'
		estimate store m`m'0
}

coefplot (mint0, label("No mediator")) ///
	(mcompetent0, label("Add competence")) ///
	(mprofessionally_oriented0, label("Add professional commitment")) ///
	(minterest_adv0, label("Add interest in advancement")) ///
	, keep(1.resp_male) ///
	vertical yscale(range(-0.5 1)) ylabel(-0.5(0.5)1) yline(0) ///
	legend(rows(1) position(6)) ///
	coeflabels(1.v_female = "Difference in career rewards assigned by men vs. women managers", ///
	tlength(0) labcolor(white)) ///
	mlabel mlabpos(2) mlabcolor(black) mlabformat(%9.2f) ///
	ytitle("Difference in career rewards assigned by men vs. women managers", size(small))
graph export "graph_Yavorsky_et_al_2025_GWO_Figure5.pdf"


log close
exit
