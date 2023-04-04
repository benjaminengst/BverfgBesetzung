*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      analysisPVS.do                                  * 
*       Date:           July 17, 2019                                   * 
*       Author:         Engst, Gschwend, Sternberg                      * 
*       Purpose:      	DCE baseline analysis, DCE Figures in German    *
*                       DCE analysis and Graph with Ideol. Proximity    * 
* 	    Input File:     analysisPVS.dta                                 * 
*       Data Output:    dce_base.dta                                    *              
*     ****************************************************************  * 
*     ****************************************************************  * 


* - fre - 
* - coefplot -


version 15.1
set seed 123345
set more off
set niceness 3

capture log close
log using "results.log", replace

* Load data
use analysisPVS, clear

egen csid = group(id_g screen)

* set base levels
fvset base 5 selec age
fvset base 1 party 
fvset base 2 gender
fvset base 3 origin
fvset base 4 marit occu



* This is our baseline model
clogit chosen i.occu i.party i.selec i.age i.origin i.gender i.marit, group(csid) vce(clu id_g) baselevels
predict pc1
predict pu0, pu0



// * Marginal effect of attributes (vs previous level); see -contrast-
 margins ar.occu ar.party ar.selec ar.age ar.origin ar.gender ar.marit, predict(pu0) asobserved cformat(%5.3f)


* average marginal effect using observed value approach (relative to refernce category)
margins, dydx(*) post predict(pu0) asobserved cformat(%5.3f) vce(unconditional) mcomp(bonferroni)


log close







**** Figure in German
coefplot , xline(0, lwidth(vthin)lcolor(black)  ) order(. *occu . *party . *selec . *age . *origin . *gender . *marit) ///
baselevels  legend(off) mcolor(black) mlwidth(vthin) mfcolor(gs14) msize(.6) lcolor(black) ///
headings( 1.occu = "{bf:Derzeitiger Beruf}" 1.party = "{bf:Parteinähe}" 1.selec = "{bf:Ausgewählt durch ...}" 1.age = "{bf:Alter}" ///
          1.origin = "{bf:Herkunft}" 1.gender = "{bf:Geschlecht}" 1.marit = "{bf:Familienstand}", labgap(1) labsize(vsmall) ) ///
yscale(alt noline) ysize(8) ///
ylabel(,  grid nogextend glcolor(gs14)) ///
coeflabels(, notick labgap(3) labsize(vsmall) grid  glcolor(gs14)) ///
xscale( nofextend) xlabel(-.3(.1)0, labsize(small) grid  glcolor(gs14))  ///
xtitle("Effekt von Eigenschaften möglicher Verfassungsrichter" "(im Vergleich zur Referenzkategorie)", j(left) size(small) color(black) alignment(bottom )) xscale(titlegap(3) ) ///
graphregion(color(white)) plotregion( color(white) margin(zero)) bgcolor(white) ///
saving(dceg, replace)

graph export dceg.pdf, replace
graph export dceg.png, replace
graph export dceg.tif, replace
graph export dceg.eps, replace preview(on)

save dce_base, replace




***** Analysis with individual-level covariates (from GIP wave 26)
use dce_base, clear
merge m:1 id_g using GIP_W26_PVS  //  108 respondents that never answered (_merge==2)
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
lab var lr_dist "Distanz auf ideologischer Dimension"

clogit chosen i.occu i.party  lr_dist i.selec i.age i.origin i.gender i.marit, group(csid) vce(clu id_g) baselevels


* average marginal effect using observed value approach (relative to refernce category)
margins, dydx(*) post predict(pu0) asobserved cformat(%5.3f) vce(unconditional) mcomp(bonferroni)





**** Figure in German
coefplot , xline(0, lwidth(vthin)lcolor(black)  ) order(. *occu . lr_dist . *party . *selec . *age . *origin . *gender . *marit) ///
baselevels  legend(off) mcolor(black) mlwidth(vthin) mfcolor(gs14) msize(.6) lcolor(black) ///
headings( 1.occu = "{bf:Derzeitiger Beruf}" 1.party = "{bf:Parteinähe}" lr_dist = "{bf:Ideologische Nähe}" 1.selec = "{bf:Ausgewählt durch ...}" 1.age = "{bf:Alter}" ///
          1.origin = "{bf:Herkunft}" 1.gender = "{bf:Geschlecht}" 1.marit = "{bf:Familienstand}", labgap(1) labsize(vsmall) ) ///
yscale(alt noline) ysize(8) ///
ylabel(,  grid nogextend glcolor(gs14)) ///
coeflabels(, notick labgap(3) labsize(vsmall) grid  glcolor(gs14)) ///
xscale( nofextend) xlabel(-.3(.1)0, labsize(small) grid  glcolor(gs14))  ///
xtitle("Effekt von Eigenschaften möglicher Verfassungsrichter" "(im Vergleich zur Referenzkategorie)", j(left) size(small) color(black) alignment(bottom )) xscale(titlegap(3) ) ///
graphregion(color(white)) plotregion( color(white) margin(zero)) bgcolor(white) ///
saving(dceideog, replace)


graph export dceideog.pdf, replace
graph export dceideog.eps, replace preview(on)
graph export dceideog.tif, replace

*lab var lr_dist "Absolute Distance to Party Judge is leaning towards"






exit

