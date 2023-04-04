
*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      ReplicationPVS.do                               * 
*       Date:           October 24, 2019                                * 
*       Author:         Engst, Gschwend, Sternberg                      * 
*       Purpose:      	replicate analysis of  PVS paper                * 
* 	    Input File:                                                     * 
*       Data Output:                                                    *              
*     ****************************************************************  * 
*     ****************************************************************  * 


* You need to dowload the following ado's before running this code:
* - parmest - 
* - parmby - 
* - dsconcat - 
* - fre - 
* - coefplot -




clear
set more off
version 15.1



* ************************************************** * 
*  	DCE baseline analysis, DCE Figures in German     * 
*   DCE analysis and Graph with Ideol. Proximity     * 
* 	Input File:   analysis.dta (based on Wave 26)    *
*                 GIP_W26_PVS (individual covariats) *
*   Data Output:  dce_base.dta                       *               
* *************************************************  * 

do analysisPVS



* ************************************************** * 
*   Simulate low/high quality hyp. candidates;       *
*   draw respective figure                           *
*   Input File:     dce_base.dta                     * 
*   Output File:                                     *              
* *************************************************  * 

do rankingPVS



* ************************************************** * 
*   DCE baseline analysis, DCE tables                *
*   Input File:     dce_base.dta                     * 
*   Output File:                                     *              
* *************************************************  * 

do tablePVS




* ************************************************** * 
*   DCE extended analysis, Simulate low/high quality *
*   for hyp. candidates;   draw respective figure    * 
*   Input File:     dce_base.dta                     * 
*   Output File:    tradeoffPVS.pdf (Abbildung)      *              
* *************************************************  * 

do graphtradeoff1PVS



* ************************************************** * 
*   DCE baseline analysis, Robustness Tests          *
*   Input File:     analysis.dta                     * 
*   Output File:                                     *              
* *************************************************  * 

do robust1PVS


