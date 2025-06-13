version 13
clear all
set more off
capture log close
set matsize 10000 

/* DATA ACCESS
We use the following data for the analysis:
1. SIAB 2008-R 7508; the "Regionalfile" of the Sample of Integrated Labour Market Biographies 1975-2008.
This dataset represents the factual anonymous version of the Sample of Integrated Labour Market 
Biographies and may be delivered to research institutions after concluding a use contract with the 
Institut fuer Arbeitsmarkt- und Berufsforschung (IAB); https://fdz.iab.de/en/data-access/scientific-use-files/
2. BIBB/IAB (BIBB/BAuA) Employment Surveys
The Employment Survey is repeated cross-sectional, representative survey of core employed persons in Germany.
We use the following survey waves: 1979, 1985/85, 1991/92, 1998/99, 2006.
The data can be accessed by research institutions after concluding a use contract with the 
Bundesinstitut fuer Berufsbildung (BIBB); https://www.bibb.de/de/1403.php
 */
 
  
/* ADO FILES INSTRUCTIONS
1. To impute censored wages in the SIAB data, download the PDF on Gartner's imputation method from
"https://doku.iab.de/fdz/reporte/2005/MR_2.pdf". The ado "imputew" is spelled out at the end of the document.
2. To run the RIF regression-based decompositions, download the zip folder "rifreg.zip" from Nicole Fortin's Google site 
"https://sites.google.com/view/nicole-m-fortin/data-and-programs". The files can be found under the header of 
the 2009 paper by Firpo, Fortin, and Lemieux on "Unconditional Quantile Regressions" published in Econometrics. 
Simply unzip the files into the STATA directory and use STATA help command for the syntax of the procedure. 
 */
  
local datapath "C:\01 Research\Inequality\Do-files\"  

/* In the first step, we prepare the SIAB sample following Dustmann et 
al. (2009) and Riphan and Schnitzlein (2011) */

do "`datapath'/1_edit_1978.do"
do "`datapath'/1_edit_1979.do"
do "`datapath'/1_edit_1985.do"
do "`datapath'/1_edit_1986.do"
do "`datapath'/1_edit_1991.do"
do "`datapath'/1_edit_1992.do"
do "`datapath'/1_edit_1998.do"
do "`datapath'/1_edit_1999.do"
do "`datapath'/1_edit_2005.do"
do "`datapath'/1_edit_2006.do"

********************************************************************************

/* Next, we prepare the BIBB sample following Gathmann and 
Schoenberg (2010) and Spitz-Oener (2006). */

do "`datapath'/2_bibb_79.do"
do "`datapath'/2_bibb_86.do"
do "`datapath'/2_bibb_92.do"
do "`datapath'/2_bibb_99.do"
do "`datapath'/2_bibb_06.do"

********************************************************************************

/* Next, we match the BIBB and the SIAB samples. */

do "`datapath'/3_match.do"

********************************************************************************

/* Then, we run the RIF regression-based decomposition using the 
BIBB-SIAB matched data. */

do "`datapath'/4_rifreg_70.do"
do "`datapath'/4_rifreg_80.do"
do "`datapath'/4_rifreg_90.do"
do "`datapath'/4_rifreg_00.do"

********************************************************************************

* We bootstrap standard errors. 

do "`datapath'/5_bootstrap_7080.do"
do "`datapath'/5_bootstrap_8090.do"
do "`datapath'/5_bootstrap_9090.do"
do "`datapath'/5_bootstrap_9000.do"

********************************************************************************

* Then, we construct the aggregate results table

do "`datapath'/6_aggregate_results_7080.do"
do "`datapath'/6_aggregate_results_8090.do"
do "`datapath'/6_aggregate_results_9090.do"
do "`datapath'/6_aggregate_results_9000.do"

********************************************************************************

* Lastly, we construct the detailed results table

do "`datapath'/7_detailed_results_7080.do"
do "`datapath'/7_detailed_results_8090.do"
do "`datapath'/7_detailed_results_9090.do"
do "`datapath'/7_detailed_results_9000.do"


********************************************************************************
********************************************************************************
********************************************************************************

* Descriptive figures and tables in the paper

do "`datapath'/Fig1_tasks_over_time_across_wage_deciles.do"
do "`datapath'/Fig2_tasks_at_different_wage_deciles.do"
do "`datapath'/Fig3_changes_in_wages_over_time.do"
do "`datapath'/Fig4_std_dev_wage_SIAB.do"
do "`datapath'/Fig5_all_occup.do"
do "`datapath'/FigA1_imputed_censored.do"
do "`datapath'/Tab2_sum_wages.do"
do "`datapath'/Tab3_wage_hierarchy.do"

