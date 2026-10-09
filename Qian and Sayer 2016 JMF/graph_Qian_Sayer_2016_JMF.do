cd "/Users/yueqian/Desktop"
log using "graph_Qian_Sayer_2016_JMF", text

**************************************************************************
*********Stata codes used to produce Figure 1*****************************
/* Qian, Yue, & Sayer, Liana C. (2016). Division of labor, gender ideology, and marital satisfaction in East Asia. Journal of Marriage and Family, 78(2), 383-400. https://doi.org/10.1111/jomf.12274
*/
**************************************************************************

// #0
// program setup
version 12.0
clear all
set more off
matrix drop _all
set linesize 120

* we used Stata's default graphic scheme
set scheme s2color, perm


// #1
// open data
clear
use "regsample", clear


// #2
// graph Figure 1
reg ms4 rel_hw gi2 c.rel_hw#c.gi2 rel_wrhrs totalw_hw age lessHS college goodhealth low_fses high_fses d_presch minor d_adult coresid if tw==1 & female==1, cluster(cluster)
margins, at(rel_hw=(10(10)100) gi2=(1(3)7)) vsquish
** Figure 1. Predicted Marital Satisfaction, by Relative Share of Housework and Gender Ideology, Taiwanese Women
marginsplot, plot1opts(lcolor(black) lpattern("shortdash")) plot2opts(lcolor(black) lpattern("solid")) plot3opts(lcolor(black) lpattern("longdash")) ///
	noci x(rel_hw) recast(line) ytitle("Marital Satisfaction", size(large)) xlabel(0(10)100, labsize(small)) ylabel(2.4(0.2)3.8) xtitle("Relative Share of Housework", size(medlarge)) ///
	legend(order(1 "GI = 1" 2 "GI = 4" 3 "GI = 7") cols(3)) ///
	title("")
graph export "graph_Qian_Sayer_2016_JMF_Figure1.pdf"

log close
exit
