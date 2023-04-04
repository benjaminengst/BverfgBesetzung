*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      graphtradeoff1.do                               * 
*       Date:           January 10, 2018                                * 
*       Author:         Engst, Gschwend, Sternberg                      * 
*       Purpose:      	Simulate low/high quality hyp. candidates;      * 
*                       draw respective figure                          *
* 	    Input File:     dce_base.dta                                    * 
*       Data Output:    tradeoffPVS.pdf (Abbildung)                     *              
*     ****************************************************************  * 
*     ****************************************************************  * 


* TG introduced new labels (4/4/19)
* TG updated code to version 15.1 (9/18/18)

set seed 123345
set more off




***** Analysis with individual-level covariates (from GIP wave 26)
use dce_base, clear
merge m:1 id_g using GIP_W26_PVS
keep if _merge==3

/*
party -- Party of Judge
---------------------------------------------------------------------------------------
                                          |      Freq.    Percent      Valid       Cum.
------------------------------------------+--------------------------------------------
Valid   1 Parteilos                       |       4001      12.13      12.13      12.13
        2 Steht den Grünen nahe           |       4178      12.67      12.67      24.79
        3 Steht der AfD nahe              |       4078      12.36      12.36      37.16
        4 Steht der CDU nahe              |       8310      25.19      25.19      62.35
        5 Steht der FDP nahe              |       4216      12.78      12.78      75.13
        6 Steht der Partei die LINKE nahe |       4077      12.36      12.36      87.49
        7 Steht der SPD nahe              |       4128      12.51      12.51     100.00
        Total                             |      32988     100.00     100.00           
---------------------------------------------------------------------------------------
*/

* we code "parteilos" as the same position as the respondent. hence likeihood contribution is "0"
gen lr_party = .
replace lr_party = lr_self if party==1
*replace lr_party = 6 if party==1    // code "parteilos" to midpoint of scale as alternative (only party fixed effects do not disappear, otherwise no difference) 
replace lr_party = lr_b90  if party==2
replace lr_party = lr_afd  if party==3
replace lr_party = lr_cdu  if party==4
replace lr_party = lr_fdp  if party==5
replace lr_party = lr_lin  if party==6
replace lr_party = lr_spd  if party==7

* Perceived spatial distance between self and party of nominee
gen lr_dist = abs(lr_self - lr_party)
lab var lr_dist "Idiological distance (abs)"

* Perceived squared distance between self and party of nominee
gen lr_sqdist = (lr_self - lr_party)^2/10   // to make support of variable comparable (on [0,10])
lab var lr_sqdist "Idiological distance (srt)"


sum lr_*dist, detail

sum lr_dist
scalar sd =  `r(sd)'

* set base levels
fvset base 5 selec age
fvset base 1 party 
fvset base 2 gender
fvset base 3 origin
fvset base 4 marit occu


*** aus Manual "asclogit postestimation"

/*
Saved results
estat mfx saves the following in r():
Scalars
r(pr_alt) scalars containing the computed probability of each alternative evaluated at the value that is
          labeled X in the table output. Here alt are the labels in the macro e(alteqs).
Matrices
r(alt)     matrices containing the computed marginal effects and associated statistics. There is one matrix
           for each alternative, where alt are the labels in the macro e(alteqs). Column 1 of each
           matrix contains the marginal effects; column 2, their standard errors; column 3, their z
           statistics; and columns 4 and 5 ("well, I think, it is 5 & 6"), the confidence intervals. 
           Column 6 contains the values of the independent variables used to compute the probabilities r(pr_alt).
*/



asclogit chosen oc1 oc2 oc3 oc5 oc6 pa2 pa3 pa4 pa5 pa6 pa7 se1 se2 se3 se4 se6 se7 ag1 ag2 ag3 ag4 ag6 ag7  ///
                or1 or2 or4 ge1 ma1 ma2 ma3 ma5 lr_dist, case(csid) alternatives(alt) vce(clu id_g)  noconstant nolog

drop if !e(sample)
estat summarize, equation labels
matrix list e(b)


*include estimation uncertainty
set seed 1234
drawnorm beta1-beta32, n(1000) means(e(b)) cov(e(V)) clear 
postutil clear


postfile mypost prob_hat20 prob_hat30 lo20 hi20 lo30 hi30 xaxis prob_hat21 prob_hat31 lo21 hi21 lo31 hi31 using sim , replace
            noisily display "start"

 
*Define scenario 

* 1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23   24  25  26  27  28  29  30  31  32
* oc1 oc2 oc3 oc5 oc6 pa2 pa3 pa4 pa5 pa6 pa7 se1 se2 se3 se4 se6 se7 ag1 ag2 ag3 ag4 ag6 ag7  or1 or2 or4 ge1 ma1 ma2 ma3 ma5 lr
* beta 1,...., beta32



* (1) Judge1, low judiciousness, Lawyer==1 & Partisan (SPD), dist=0 (SPD supporter);						
generate Vcan1 =    exp(beta1*1 + beta11*1 )

* (2) Judge2, low judiciousness, Lawyer==1 & Partisan (SPD), dist=sd (No SPD supporter);						
generate Vcan2 =    exp(beta1*1 + beta11*1 + beta32*sd)

* (3) Judge3, High judiciousness (judge at federal court == baseline) & Partisan (SPD), dist=0 (SPD supporter);						
generate Vcan3 =    exp(beta11 *1 ) 

* (4) Judge4, High judiciousness (judge at federal court == baseline) & Partisan (SPD), dist=sd (No SPD supporter);						
generate Vcan4 =    exp(beta11 *1 + beta32*sd) 


* Judge0, high independence, i.e. no Partisan leaning == baseline, high judiciousness (judge at federal court == baseline);			
generate Vcan0 =    exp(0) 				



gen prob10 = Vcan1 / (Vcan1 + Vcan0)	/* Predicted Probs Scenario 1 */ 
gen prob20 = Vcan2 / (Vcan2 + Vcan0)	/* Predicted Probs Scenario 2 */ 
gen prob30 = Vcan3 / (Vcan3 + Vcan0)	/* Predicted Probs Scenario 3 */ 
gen prob40 = Vcan4 / (Vcan4 + Vcan0)	/* Predicted Probs Scenario 4 */ 
*gen prob50 = Vcan5 / (Vcan5 + Vcan0)	/* Predicted Probs Scenario 5 */ 


egen ev10 = mean(prob10) /*Expected value is the mean over all 1000 pred probs for scenario 1 */
egen ev20 = mean(prob20) /*Expected value is the mean over all 1000 pred probs for scenario 2 */
egen ev30 = mean(prob30) /*Expected value is the mean over all 1000 pred probs for scenario 3 */
egen ev40 = mean(prob40) /*Expected value is the mean over all 1000 pred probs for scenario 4 */
*egen ev50 = mean(prob50) /*Expected value is the mean over all 1000 pred probs for scenario 5 */


scalar prob_hat10 = ev10 
scalar prob_hat20 = ev20 
scalar prob_hat30 = ev30 
scalar prob_hat40 = ev40 
*scalar prob_hat50 = ev50 



* lower & upper bound for expected value of scenario 1-5
_pctile prob10, p(2.5,97.5) 
scalar    lo10 = r(r1)
scalar    up10 = r(r2) 

_pctile prob20, p(2.5,97.5) 
scalar    lo20 = r(r1)
scalar    up20 = r(r2) 

_pctile prob30, p(2.5,97.5) 
scalar    lo30 = r(r1)
scalar    up30 = r(r2) 

_pctile prob40, p(2.5,97.5) 
scalar    lo40 = r(r1)
scalar    up40 = r(r2) 



	
* In case we are interested in a first-difference of those scenarios: *

* (0,1)-Scenario: calculate first-difference	
    gen diff14 = prob10-prob40  /* 1000 different values for the differences */
    egen  fd14 = mean(diff14)
    scalar diff_hat14 = fd14 		
	* lower & upper bound for first-difference	
	_pctile diff14, p(2.5,97.5) 
    scalar lod14 = r(r1)
    scalar upd14 = r(r2) 
	
* (0,1)-Scenario: calculate first-difference	
    gen diff34 = prob30-prob40  /* 1000 different values for the differences */
    egen  fd34 = mean(diff34)
    scalar diff_hat34 = fd34 		
	* lower & upper bound for first-difference	
	_pctile diff34, p(2.5,97.5) 
    scalar lod34 = r(r1)
    scalar upd34 = r(r2) 


// * (0,1)-Scenario: calculate first-difference	
//     gen diff13 = prob10-prob30  /* 1000 different values for the differences */
//     egen  fd13 = mean(diff13)
//     scalar diff_hat13 = fd13 		
// 	* lower & upper bound for first-difference	
// 	_pctile diff13, p(2.5,97.5) 
//     scalar lod13 = r(r1)
//     scalar upd13 = r(r2) 


	
	
gen coef = .
replace coef = prob_hat10 in 1
replace coef = prob_hat20 in 2
replace coef = prob_hat30 in 3
replace coef = prob_hat40 in 4
*replace coef = prob_hat50 in 5
format coef %9.2f
 

gen up = .
replace up = up10 in 1
replace up = up20 in 2
replace up = up30 in 3
replace up = up40 in 4
*replace up = up50 in 5

gen lo = .
replace lo = lo10 in 1
replace lo = lo20 in 2
replace lo = lo30 in 3
replace lo = lo40 in 4
*replace lo = lo50 in 5


* Lower and Upper bounds of FD
gen lod = .
replace lod = lod14 in 1
replace lod = lod34 in 2


gen upd = .
replace upd = upd14 in 1
replace upd = upd34 in 2


* Result: Those fd's are all sign. different from zero!
list lod upd if lod!=.


* (1) Judge1, low judiciousness, Lawyer==1 & Partisan (SPD), dist=0;						
* (2) Judge2, low judiciousness, Lawyer==1 & Partisan (SPD), dist=sd;						
* (3) Judge3, High judiciousness (judge at federal court == baseline) & Partisan (SPD), dist=0;						
* (4) Judge4, High judiciousness (judge at federal court == baseline) & Partisan (SPD), dist=sd;	


gen xaxis = _n in 1/5




** Deutsche Graphik
#delimit ;
twoway (scatter xaxis coef,  mlwidth(vthin) mfcolor(gs15)  lcolor(black) mlabel(coef) mlabcolor(black) mlabposition(12) mlabgap(*3) mlabsize(vsmall) ) 
( rspike lo up xaxis,  lwidth(vthin) lcolor(black) horizontal),
legend(off) ytitle(" ") 
ylabel( 1 `""niedrige juristische Kompetenz," "steht derselben Partei wie Befragter nahe"'  
		2 `""niedrige juristische Kompetenz," "steht {it:nicht} derselben Partei wie Befragter nahe"' 
        3 `""hohe juristische Kompetenz," "steht derselben Partei wie Befragter nahe"'    
		4 `""hohe juristische Kompetenz," "steht {it:nicht} derselben Partei wie Befragter nahe"' 
, labsize(vsmall) angle(horizontal) noticks nogrid) 
yscale(noline) xscale( nofextend) 
xtitle("Vorhergesagte Wahrscheinlichkeit die beschriebene Kandidatin auszuwählen," "statt einer politisch unabhängigen Kandidatin mit hoher juristischer Kompetenz", color(black) size(vsmall) alignment(bottom )) xscale(titlegap(3) )
xlabel(.1(.1).6,  labsize(vsmall) labels tick)
graphregion(color(white)) plotregion( color(white) ) bgcolor(white)
saving(tradeoffPVS, replace)
;
#delimit cr



graph export tradeoffPVS.pdf, replace
graph export tradeoffPVS.eps, replace preview(on)
graph export tradeoffPVS.tif, replace
