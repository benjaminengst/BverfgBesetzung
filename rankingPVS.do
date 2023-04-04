*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      rankingPVS.do                                   * 
*       Date:           March 23, 2017                                  * 
*       Author:         Engst, Gschwend, Sternberg                      * 
*       Purpose:      	Simulate ranking of actual Judges               * 
*                       Draw respective figure                          *
* 	    Input File:     dce_base.dta                                    * 
*       Data Output:                                                    *              
*     ****************************************************************  * 
*     ****************************************************************  * 





version 15.1
set seed 123345
set more off




* Load data
use dce_base, clear

*egen csid = group(id_g screen)

* set base levels
fvset base 5 selec age
fvset base 1 party 
fvset base 2 gender
fvset base 3 origin
fvset base 4 marit occu


asclogit chosen oc1 oc2 oc3 oc5 oc6 pa2 pa3 pa4 pa5 pa6 pa7 se1 se2 se3 se4 se6 se7 ag1 ag2 ag3 ag4 ag6 ag7  or1 or2 or4 ge1 ma1 ma2 ma3 ma5, case(csid) alternatives(alt) vce(clu id_g)  noconstant nolog


*asclogit chosen oc1 oc2 oc3 oc5 oc6 pa2 pa3 pa4 pa5 pa6 pa7 se1 se2 se3 se4 se6 se7 ag1 ag2 ag3 ag4 ag6 ag7 ///
*         or1 or2 or4 ge1 ma1 ma2 ma3 ma5, case(csid) alternatives(alt) basealternative(1) vce(boot, seed(1234) rep(1000)  cluster(id_g) saving(boot, replace))


drop if !e(sample)
estat summarize, equation labels
matrix list e(b)

*`r(mean)'

*include fundamental uncertainty
*preserve 
set seed 1234
drawnorm beta1-beta31, n(1000) means(e(b)) cov(e(V)) clear 
*postutil clear


 


* Include actual characteristics of existing judges

* 1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23   24  25  26  27  28  29  30  31 
* oc1 oc2 oc3 oc5 oc6 pa2 pa3 pa4 pa5 pa6 pa7 se1 se2 se3 se4 se6 se7 ag1 ag2 ag3 ag4 ag6 ag7  or1 or2 or4 ge1 ma1 ma2 ma3 ma5
* beta 1,...., beta31


// * (1) Angelika	Nußberger 1; Richterin am Europäischen Gerichtshof für Menschenrechte (EGMR) coded as Bundesrichter
generate Vcan1 =    exp(beta8 + beta14) 
gen Vnam1 = "Angelika Nußberger"

// * (2) Christian	Waldhoff 1;
generate Vcan2 =    exp(beta2 + beta8 + beta14 + beta27) 
gen Vnam2 = "Christian Waldhoff"

// * (3) Frank	Schorkopf 1;
generate Vcan3 =    exp(beta2 + beta8 + beta14 + beta21  + beta27) 
gen Vnam3 = "Frank Schorkopf"

// * (4) Günther	Krings 1;
generate Vcan4 =    exp(beta1 + beta8 + beta14 + beta21  + beta27 + beta30) 
gen Vnam4 = "Günther Krings"

gen Vcan5 = .
gen Vnam5 = " "


// * (5) Stephan Harbarth 1;
generate Vcan6 =    exp(beta1 + beta8 + beta14 + beta20 + beta27) 
gen Vnam6 = "Stephan Harbarth"



* (6) Johannes	Masing, 1;						
generate Vcan7 =    exp(beta2 + beta11 + beta13 + beta21 + beta27) 
gen Vnam7 = "Johannes Masing"


* (7) Andreas	Paulus, 1;						
generate Vcan8 =    exp(beta2 + beta9 + beta19 + beta27 + beta30)
gen Vnam8 = "Andreas Paulus"

* (8) Susanne	Baer, 1;
generate Vcan9 =    exp(beta2 + beta6 + beta20 + beta28)
gen Vnam9 = "Susanne Baer" 

* (9) Gabriele	Britz, 1;						
generate Vcan10 =    exp(beta2 + beta11 + beta13 + beta19)
gen Vnam10 = "Gabriele Britz" 

* (10) Yvonne	Ott, 1;						
generate Vcan11 =    exp(beta11 + beta13) 
gen Vnam11 = "Yvonne Ott"

* (11) Josef Christ, 1;						
generate Vcan12 =    exp(beta8 + beta14 + beta22 + beta27) 
gen Vnam12 = "Josef Christ"

* (12) Henning Radtke, 1; coded as Bundesrichter rather than Professor.				
generate Vcan13 =    exp(beta8 + beta13 + beta27) 
gen Vnam13 = "Henning Radtke"

gen Vcan14 = .
gen Vnam14 = " "


* (13) Andreas	Voßkuhle, 2;						
generate Vcan15 =    exp(beta2 + beta11 + beta13 + beta20 + beta27) 
gen Vnam15 = "Andreas Voßkuhle"

* (14) Peter	Huber, 2;						
generate Vcan16 =    exp(beta1 + beta8 + beta21 + beta27)
gen Vnam16 = "Peter Huber"

* (15) Peter	Müller, 2;
generate Vcan17 =    exp(beta1 + beta8 + beta13 + beta27) 
gen Vnam17 = "Peter Müller"

* (16) Monika	Hermanns, 2;						
generate Vcan18 =    exp(beta11 + beta21) 
gen Vnam18 = "Monika Hermanns"

* (17) Sibylle	Kessal-Wulf, 2;						
generate Vcan19 =    exp(beta8 + beta13) 
gen Vnam19 = "Sibylle Kessal-Wulf"

* (18) Doris	König, 2;						
generate Vcan20 =    exp(beta2 + beta11) 
gen Vnam20 = "Doris König"

* (19) Ulrich	Maidowski, 2;						
generate Vcan21 =    exp(beta11 + beta27)
gen Vnam21 = "Ulrich Maidowski"

* (20) Christine	Langenfeld, 2;
generate Vcan22 =    exp(beta2 + beta8 + beta13 + beta26) 
gen Vnam22 = "Christine Langenfeld"


// * (5) Stephan Harbarth 1; als Rechtsanwalt
generate Vcan23 =    exp(beta3 + beta8 + beta14 + beta20 + beta27) 
gen Vnam23 = "Stephan Harbarth, Rechtsanwalt"

// * (5) Stephan Harbarth 1; als Professor
generate Vcan24 =    exp(beta2 + beta8 + beta14 + beta20 + beta27) 
gen Vnam24 = "Stephan Harbarth, Professor"


* parteilos, high quality baseline;			
generate Vcan0 =    exp(0) 			
gen Vnam0 = " "	



gen coef = .
gen up = .
gen lo = .
gen name = " "

foreach j of numlist 1/24 {
   gen prob`j'  = Vcan`j' /  (Vcan`j'  + Vcan0)	/* Predicted Probs Scenario `j' */ 
   egen ev`j' = mean(prob`j')                   /* Expected value is the mean over all 1000 pred probs for scenario `j' */
   scalar prob_hat`j' = ev`j' 
   * lower & upper bound for expected value of scenario `j'
   _pctile prob`j', p(2.5,97.5) 
   scalar    lo`j' = r(r1)
   scalar    up`j' = r(r2)  
   * generate variable holding predicted probs
   replace coef = prob_hat`j' in `j'
   replace up = up`j' in `j'
   replace lo = lo`j' in `j'
   replace name =Vnam`j' in `j'
   } 
format coef %9.2f  


list coef in 23/24 // .20
     


gen xaxis = _n in 1/22
gen xaxis1 = xaxis
recode xaxis1  22=18 21=17 20=20 19=16 18=15 17=22 16=21 15=19 13=11 12=9 11=6 10=7 9=8 8=12 7=10 6=13
recode xaxis1 11=7 7=8 10=9 9=10 8=11 17=16 16=17 20=18 18=20

#delimit ;
twoway (scatter xaxis1 coef,  mlwidth(vthin) mfcolor(gs15)  lcolor(black) mlabel(coef) mlabcolor(black) 
                             mlabposition(12) mlabgap(*1) mlabsize(tiny) ) 
( rspike lo up xaxis1,  lwidth(vthin) lcolor(black) horizontal),
legend(off) ytitle(" ") 
ylabel(1  "Angelika Nußberger" 
       2  "Christian Waldhoff"
       3  "Frank Schorkopf"
       4   "Günther Krings"
	   5  " "
       13   "Stephan Harbarth"
       9   "Johannes Masing"
	   12  "Andreas Paulus"
       11   "Susanne Baer"
	   8 "Gabriele Britz"
	   6 "Yvonne Ott"        
	   10 "Josef Christ"
	   7 "Henning Radtke" 
	   14 " "
	   19 "Andreas Voßkuhle"
	   21 "Peter Huber"
	   22 "Peter Müller"
	   15 "Monika Hermanns"
	   17 "Sibylle Kessal-Wulf"
	   18 "Doris König"
	   16 "Ulrich Maidowski"
	   20 "Christine Langenfeld"	  
, labsize(small) angle(horizontal) noticks nogrid) 	   
yscale(noline) xscale( nofextend) 
xtitle("Wahrscheinlichkeit ausgewählt zu werden" , color(black) alignment(bottom )) 
xscale(titlegap(3) )
xlabel(0(.1).5,  labsize(small) labels tick)
graphregion(color(white)) plotregion( color(white) ) bgcolor(white)
saving(rankingPVS, replace)
text( 2.4 0 "{it:Andere}", orientation(vertical) size(medsmall))
text( 9.5 0 "{it:Erster Senat}", orientation(vertical) size(medsmall))
text( 18.3 0 "{it:Zweiter Senat}", orientation(vertical) size(medsmall))
;
#delimit cr
*"gegenüber Referenz-Kandidatin"
capture drop xaxis*

graph export rankingPVS.pdf, replace
graph export rankingPVS.eps, replace preview(on)
graph export rankingPVS.png, replace
graph export rankingPVS.tif, replace



compress
save ranking, replace

