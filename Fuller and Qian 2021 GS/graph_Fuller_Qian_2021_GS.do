cd "/Users/yueqian/Desktop"
log using "graph_Fuller_Qian_2021_GS", text

**************************************************************************
*Stata codes used to produce Figure 1, Figure 2, Figure A1, and Figure A2*
/* Fuller, S., & Qian, Y. (2021). Covid-19 and the gender gap in employment among parents of young children in Canada. Gender & Society, 35(2), 206-217. https://doi.org/10.1177/08912432211001287
*/
**************************************************************************

/*
Stata packages coefplot and cleanplots need to be installed to produce the graphs
coefplot - https://repec.sowi.unibe.ch/stata/coefplot/
cleanplots - https://www.trentonmize.com/software/cleanplots
*/

// #0
// program setup
version 14.0
clear all
set more off
matrix drop _all
set linesize 120

// #1
// open data
use "LFS_Feb_to_Oct", clear

***********************************************
*********Figure 1: all_emp without controls****
***********************************************

// #2
// overall, Figure 1
forv x = 0/2 {
	logit all_emp i.SURVMNTH##SEX if kidage == `x'  [pweight = FINALWT] 
	estimates store l1_`x'
	margins SURVMNTH if SEX == 1, post
	estimates store l1_m_`x'
	estimates restore l1_`x'
	margins SURVMNTH if SEX == 2, post
	estimates store l1_f_`x'
}
	
coefplot (l1_m_0, label(Men) recast(connected)) ///
		(l1_f_0, label(Women) recast(connected)) ///
		, bylabel(No children) ///
		|| (l1_m_1, label(Men) recast(connected)) ///
		(l1_f_1, label(Women) recast(connected)) /// 
		, bylabel(Youngest child < 6 years) ///
		|| (l1_m_2, label(Men) recast(connected)) ///
		(l1_f_2, label(Women) recast(connected)) /// 
		, bylabel(Youngest child 6 to 12 years) citop ciopts(lc(%30)) rescale(100) vertical offset(0) byopts(compact cols(3))		
graph export "graph_Fuller_Qian_2021_GS_Figure1.pdf"


***********************************************
*********Figure A1: all_emp by education*******
***********************************************

// #3
// by education, Figure A1
forv x = 0/2 {
	forv y = 1/3 {
		logit all_emp i.SURVMNTH##SEX if kidage == `x' & educ_small == `y' [pweight = FINALWT] 
		estimates store l2_`x'_`y'
		margins SURVMNTH if SEX == 1, post
		estimates store l2_m_`x'_`y'
		estimates restore l2_`x'_`y'
		margins SURVMNTH if SEX == 2, post
		estimates store l2_f_`x'_`y'
	}
}

	coefplot (l2_m_1_1, label(Men) recast(connected)) ///
			(l2_f_1_1, label(Women) recast(connected)) /// 
			, bylabel(High school or less) ///
			|| (l2_m_1_2, label(Men) recast(connected)) ///
			(l2_f_1_2, label(Women) recast(connected)) ///
			, bylabel(Postsecondary credential) ///
			|| (l2_m_1_3, label(Men) recast(connected)) ///
			(l2_f_1_3, label(Women) recast(connected)) ///
			, bylabel(University degree) citop ciopts(lc(%30)) ///
			vertical offset(0) rescale(100) byopts(compact rows(1) title("Youngest child < 6 years")) yscale(range(60 100))
	graph save under6.gph

	coefplot (l2_m_2_1, label(Men) recast(connected)) ///
			(l2_f_2_1, label(Women) recast(connected)) /// 
			, bylabel(High school or less) ///
			|| (l2_m_2_2, label(Men) recast(connected)) ///
			(l2_f_2_2, label(Women) recast(connected)) ///
			, bylabel(Postsecondary credential) ///
			|| (l2_m_2_3, label(Men) recast(connected)) ///
			(l2_f_2_3, label(Women) recast(connected)) ///
			, bylabel(University degree) citop ciopts(lc(%30)) ///
			vertical offset(0) rescale(100) byopts(compact rows(1) title("Youngest child 6 to 12 years")) yscale(range(60 100))
	graph save child6_12.gph

graph combine under6.gph child6_12.gph, rows(2)
graph export "graph_Fuller_Qian_2021_GS_FigureA1.pdf"


***********************************************
*********Figure 2: work hours without controls*
***********************************************

// #4
// overall, Figure 2	
	forv x = 0/2 {
		reg wkhrs i.SURVMNTH##SEX if kidage == `x' [pweight = FINALWT] 
		margins, dydx(SEX) over(SURVMNTH) post
		estimates store m_`x'
	}

coefplot (m_0, recast(connected)) ///
		, bylabel(No children) ///
		|| (m_1, recast(connected)) ///
		, bylabel(Youngest child < 6 years) ///
		|| (m_2, recast(connected)) ///
		, bylabel(Youngest child 6 to 12 years) citop ciopts(lc(%30)) vertical offset(0) byopts(compact cols(3)) 
graph export "graph_Fuller_Qian_2021_GS_Figure2.pdf"


***********************************************
******Figure A2: work hours by education*******
***********************************************

// #5
// by education, Figure A2
forv y = 1/3 {
	forv x = 1/2 {
		reg wkhrs i.SURVMNTH##SEX if educ_small == `y' & kidage == `x'  [pweight = FINALWT] 
		margins, dydx(SEX) over(SURVMNTH) post
		estimates store m_`y'_`x'
	}
}

coefplot (m_1_1, recast(connected)), bylabel(High school or less) ///
	|| (m_2_1, recast(connected)), bylabel(Postsecondary credential) ///
	|| (m_3_1, recast(connected)), bylabel(University degree) citop ciopts(lc(%30)) ///
	vertical byopts(compact cols(3) ti("Youngest Child < 6 years")) yscale(range(0 -20))
graph save "wkhrs_edu_0_6"


coefplot (m_1_2, recast(connected)), bylabel(High school or less) ///
	|| (m_2_2, recast(connected)), bylabel(Postsecondary credential) ///
	|| (m_3_2, recast(connected)), bylabel(University degree) citop ciopts(lc(%30)) ///
	vertical byopts(compact cols(3) ti("Youngest child 6 to 12 years")) yscale(range(0 -20))
graph save "wkhrs_edu_6_12"

graph combine "wkhrs_edu_0_6" "wkhrs_edu_6_12", rows(2)
graph export "graph_Fuller_Qian_2021_GS_FigureA2.pdf"


log close
exit
