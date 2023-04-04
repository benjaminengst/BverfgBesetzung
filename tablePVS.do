*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      tablePVS.do                                     * 
*       Date:           September 25, 2018                              * 
*       Author:         Engst, Gschwend, Sternberg                      * 
*       Purpose:      	DCE baseline analysis, DCE tables               *
* 	    Input File:     dce_base.dta                                    * 
*       Data Output:    dce_base.dta                                    *              
*     ****************************************************************  * 
*     ****************************************************************  * 




*version 15.1
set seed 123345
set more off
set niceness 3





use dce_base, replace



***** Generating estimation tables
* This is our baseline model


asclogit chosen oc1 oc2 oc3 oc5 oc6 pa2 pa3 pa4 pa5 pa6 pa7 se1 se2 se3 se4 se6 se7 ag1 ag2 ag3 ag4 ag6 ag7  ///
                or1 or2 or4 ge1 ma1 ma2 ma3 ma5, case(csid) alternatives(alt) vce(clu id_g)  noconstant nolog

eststo clogit1

#delimit ;
esttab clogit1  using PVSrawestimates, cells("b(star fmt(2) label(Koef.)) se(label(Std. Fehler))") mlabel(" ", nodep noti nonum)
 varlabels(oc1 "Politiker" oc2 "Professor an einer Universität" oc3 "Rechtsanwalt" oc5 "Richter an einem Landgericht" oc6 "Staatsanwalt"
           pa2 "Grüne" pa3 "AfD" pa4 "CDU" pa5 "FDP" pa6 "LINKE" pa7 "SPD"
           se1 "Präsident" se2 "Bundesrat" se3 "Bundestag nach nichtöffentlicher Anhörung" 
		   se4 "Bundestag nach öffentlicher Anhörung" se6 "Bundesregierung" se7 "überparteiliches Expertengremium"
           ag1 "35 Jahre" ag2 "40 Jahre" ag3 "45 Jahre" ag4 "50 Jahre" ag6 "60 Jahre" ag7 "65 Jahre" 
		   or1 "Ostdeutschland" or2 "Ostdeutschland mit Migrationshintergrund" or4 "Westdeutschland mit Migrationshintergrund" ge1 "männlich"
		   ma1 "eingetragene Lebenspartnerschaft" ma2 "geschieden" ma3 "ledig" ma5 "verwitwet")
 refcat(ag1 "Alter (Ref. 55 Jahre):" pa2 "Parteinähe (Ref. Parteilos): " se1 "Ausgewählt durch ... (Ref. Richterwahlausschuß):" or1 "Herkunft (Ref. Westdeutschland):" 
        ge1 "Geschlecht (Ref. weiblich):" 
		ma1 "Familienstand (Ref. verheiratet):" oc1 "Derzeitiger Beruf (Ref. Richter an Bundesgericht):", nolabel)
 sfmt(%9.0f) sca("ll Log-Likelihood" "N_case N (Entscheidungen der Befragten)" "N N (Profile)" "N_clust N (Befragte)")  noobs 
 varwidth(50) nonumbers
 rtf replace nonotes addnote("Quelle: GIP (Welle 26); *  p < 0.10; ** p < 0.05; *** p < 0.01.")  star(* 0.10 ** 0.05 *** 0.01) 
 eqlabels(none)
;
#delimit cr




exit

