cd "/Users/yueqian/Desktop"
log using "table_Qian_2018_JMF", text

**************************************************************************
*********Stata codes used to produce Table 2 and Table 3******************
/* Qian, Yue. (2018). Educational assortative mating and income dynamics in couples: A longitudinal dyadic perspective. Journal of Marriage and Family, 80(3), 607-621. https://doi.org/10.1111/jomf.12470
*/
**************************************************************************

/*
Stata package outreg2 needs to be installed to export regression results.
This module can be installed from within Stata by typing "ssc install outreg2". 
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
clear
use "regsample", clear

/* note about data structure

Data have two rows for each couple. Both rows contain all the variables in the models (for the wife row, all husband variables = 0; for the husband row, all wife variables = 0). 
 
lninc is my dependent variable. My slope is marital duration. caseid_1979 is my couple id.
 
For the "wife" row, lninc is wife's income; f_int = 1, f_slope = marital duration, m_int = 0, m_slope = 0.

For the "husband" row, lninc is husband's income; f_int = 0, f_slope = 0, m_int = 1, m_slope = marital duration. 

*/


// #2
// Table 2, Model 1
xtmixed lninc f_int ///
			  f_slope ///
			  f_slopesq ///
			  m_int ///
			  m_slope ///
			  m_slopesq, noconstant /// 
	|| caseid_1979: f_slopesq m_slopesq, noconstant cov(identity) ///
	|| caseid_1979: f_int m_int f_slope m_slope, ml noconstant cov(un)
outreg2 using "table_Qian_2018_JMF", excel bdec(3) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +)

	
// #3
// Table 3, Model 2	
xtmixed lninc f_int i.fhyper i.fhypo i.flhs i.fsc i.fc ///
			  f_slope fhyper#c.f_slope fhypo#c.f_slope flhs#c.f_slope fsc#c.f_slope fc#c.f_slope ///
			  f_slopesq fhyper#c.f_slopesq fhypo#c.f_slopesq flhs#c.f_slopesq fsc#c.f_slopesq fc#c.f_slopesq ///
			  m_int i.mhyper i.mhypo i.mlhs i.msc i.mc ///
			  m_slope mhyper#c.m_slope mhypo#c.m_slope mlhs#c.m_slope msc#c.m_slope mc#c.m_slope ///
			  m_slopesq mhyper#c.m_slopesq mhypo#c.m_slopesq mlhs#c.m_slopesq msc#c.m_slopesq mc#c.m_slopesq, noconstant /// 
	|| caseid_1979: f_slopesq m_slopesq, noconstant cov(identity) ///
	|| caseid_1979: f_int m_int f_slope m_slope, ml noconstant cov(un)
outreg2 using "table_Qian_2018_JMF", excel bdec(3) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +)


// #4
// Table 3, Model 3	
xtmixed lninc f_int i.fhyper i.fhypo i.flhs i.fsc i.fc ///
					w_cafm i.fresp_wife i.fhispanic i.fblack ///
			  f_slope fhyper#c.f_slope fhypo#c.f_slope flhs#c.f_slope fsc#c.f_slope fc#c.f_slope ///
					c.w_cafm#c.f_slope fresp_wife#c.f_slope fhispanic#c.f_slope fblack#c.f_slope ///
			  f_slopesq fhyper#c.f_slopesq fhypo#c.f_slopesq flhs#c.f_slopesq fsc#c.f_slopesq fc#c.f_slopesq ///
					c.w_cafm#c.f_slopesq fresp_wife#c.f_slopesq fhispanic#c.f_slopesq fblack#c.f_slopesq ///
			  fminor reg_fthr ///
			  m_int i.mhyper i.mhypo i.mlhs i.msc i.mc ///
					h_cafm i.mresp_wife i.mhispanic i.mblack ///
			  m_slope mhyper#c.m_slope mhypo#c.m_slope mlhs#c.m_slope msc#c.m_slope mc#c.m_slope ///
					c.h_cafm#c.m_slope mresp_wife#c.m_slope mhispanic#c.m_slope mblack#c.m_slope ///
			  m_slopesq mhyper#c.m_slopesq mhypo#c.m_slopesq mlhs#c.m_slopesq msc#c.m_slopesq mc#c.m_slopesq ///
					c.h_cafm#c.m_slopesq mresp_wife#c.m_slopesq mhispanic#c.m_slopesq mblack#c.m_slopesq ///
			 mminor reg_mthr, noconstant ///
	|| caseid_1979: f_slopesq m_slopesq, noconstant cov(identity) ///
	|| caseid_1979: f_int m_int f_slope m_slope, ml noconstant cov(un)
outreg2 using "table_Qian_2018_JMF", excel bdec(3) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +)


log close
exit
