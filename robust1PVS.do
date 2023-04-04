*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      robust1PVS.do                                   * 
*       Date:           Oktober 24, 2019                                * 
*       Author:         Engst, Gschwend, Sternberg                      * 
*       Purpose:      	DCE baseline analysis, Robustness Tests         * 
* 	    Input File:     analysis.dta                                    *            
*     ****************************************************************  * 
*     ****************************************************************  * 


* You need to dowload the following ado's before running this code:
* - fre - 
* - coefplot -




version 15.1
set seed 123345
set more off
set niceness 3





* Load data
use analysisPVS, clear

egen csid = group(id_g screen)

* set base levels
fvset base 5 selec age
fvset base 1 party 
fvset base 2 gender
fvset base 3 origin
fvset base 4 marit occu



*** Robustheist Check: carryover effect
* This is our baseline model for the first screen only
clogit chosen i.occu i.party i.selec i.age i.origin i.gender i.marit if screen==1, group(csid) vce(clu id_g) baselevels


* average marginal effect using observed value approach (relative to refernce category)
margins, dydx(*) post predict(pu0) asobserved cformat(%5.3f) vce(unconditional) mcomp(bonferroni)


* No substantive difference between sceen 1 and all screens


exit
