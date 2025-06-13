clear all

local temp "C:\01 Research\Inequality\Data\Temp"
local output "C:\01 Research\Inequality\Data\Output"
global tables "C:\01 Research\Inequality\Tables\" 

use "`temp'\se\out_dfl_7080.dta"  

*90/10
****** generate standard deviation
forvalues i = 1(1)21 {
  egen sd9010_`i'= sd(DR9010`i')
 }
 
gen denominator=sqrt(100)

 forvalues i = 1(1)21 {
  gen se9010_`i'= sd9010_`i'/denominator
 }

 *** compute sample means
  forvalues i = 1(1)21 {
  egen mean_DR9010`i'=mean(DR9010`i')
 }

****** t-values = coeff/se
 forvalues i = 1(1)21 {
  gen t9010_`i'= abs(mean_DR9010`i'/se9010_`i')
 }
 
***** p-values
  forvalues i = 1(1)21 {
  gen p9010_`i'= 2*ttail(49, t9010_`i')
 }
 
* mark significance
  forvalues i = 1(1)21 {
  gen star_9010_`i' =""
  replace star_9010_`i' = "*" if p9010_`i'<= 0.1
  replace star_9010_`i' = "**" if p9010_`i'<= 0.05
  replace star_9010_`i' = "***" if p9010_`i'<= 0.01
 }
 
* multiply with -1  
forvalues i = 1(1)21 {
  replace mean_DR9010`i'= mean_DR9010`i' * (-1)
 } 
 
* generate coefficients with significance signs  
forvalues i = 1(1)21 {
  gen coeff_mean_DR9010`i'= string(mean_DR9010`i', "%10.4f")
  replace coeff_mean_DR9010`i' = coeff_mean_DR9010`i' +  star_9010_`i'
 }
 
*gen strings of standard errors 
 forvalues i = 1(1)21 {
 gen coef_se_9010_`i' = string(se9010_`i', "%10.4f")
 }
  
keep if bsloop==98
gen test=_n

forvalues i = 1(1)21 {
replace coef_se_9010_`i' = "(" + coef_se_9010_`i'+ ")"
}

gen id="test" 
reshape long coef, i(bsloop id) j(def) string
replace bsloop=_n
reshape wide coef, i(bsloop def) j(id) string

keep def coeftest bsloop

gen id1 = substr(def, 10,2)
destring id1, replace
gen id2 = substr(def, 14,2)
destring id2, replace
replace id1 = id2 if id1 >= 90
sort id1 id2

replace def= "group1_9010"				if def== "f_mean_DR90101"
replace def= "group2_9010"				if def== "f_mean_DR90102"
replace def= "Total change"				if def== "f_mean_DR90103"
replace def= "Abstract tasks"			if def== "f_mean_DR90104"
replace def= "Interactive tasks"		if def== "f_mean_DR90105"
replace def= "Manual tasks"				if def== "f_mean_DR90106"
replace def= "Routine tasks"			if def== "f_mean_DR90107"
replace def= "Education"				if def== "f_mean_DR90108"
replace def= "Firm controls"			if def== "f_mean_DR90109"
replace def= "Experience"				if def== "f_mean_DR901010"
replace def= "Composition effect"		if def== "f_mean_DR901011"
replace def= "Abstract tasks"			if def== "f_mean_DR901012"
replace def= "Interactive tasks"		if def== "f_mean_DR901013"
replace def= "Manual tasks"				if def== "f_mean_DR901014"
replace def= "Routine tasks"			if def== "f_mean_DR901015"
replace def= "Education"				if def== "f_mean_DR901016"
replace def= "Firm controls"			if def== "f_mean_DR901017"
replace def= "Experience"				if def== "f_mean_DR901018"
replace def= "Constant"					if def== "f_mean_DR901019"
replace def= "Wage structure effect"	if def== "f_mean_DR901020"
replace def= "Specification error"		if def== "f_mean_DR901021"

drop if id1==1
drop if id1==2

gen def2=def
replace def2=" " if def== "_se_9010_1"
replace def2=" " if def== "_se_9010_2"
replace def2=" " if def== "_se_9010_4"
replace def2=" " if def== "_se_9010_5"
replace def2=" " if def== "_se_9010_6"
replace def2=" " if def== "_se_9010_7"
replace def2=" " if def== "_se_9010_8"
replace def2=" " if def== "_se_9010_9"
replace def2=" " if def== "_se_9010_10"
replace def2=" " if def== "_se_9010_12"
replace def2=" " if def== "_se_9010_13"
replace def2=" " if def== "_se_9010_14"
replace def2=" " if def== "_se_9010_15"
replace def2=" " if def== "_se_9010_16"
replace def2=" " if def== "_se_9010_17"
replace def2=" " if def== "_se_9010_18"
replace def2=" " if def== "_se_9010_19"
replace def2=" " if def== "_se_9010_21"

keep def2 coeftest
order def2 coeftest

gen gap=9010

save "`output'\se\rifreg_7080_9010.dta", replace

********************************************************************************
clear all
use "`temp'\se\out_dfl_7080.dta"  
 
*90/50
****** generate standard deviation
forvalues i = 1(1)21 {
  egen sd9050_`i'= sd(DR9050`i')
 }
 
gen denominator=sqrt(100)

 forvalues i = 1(1)21 {
  gen se9050_`i'= sd9050_`i'/denominator
 }

 *** compute sample means
   forvalues i = 1(1)21 {
  egen mean_DR9050`i'=mean(DR9050`i')
 }

****** t-values = coeff/se
   forvalues i = 1(1)21 {
  gen t9050_`i'= abs(mean_DR9050`i'/se9050_`i')
 }
 
***** p-values
 forvalues i = 1(1)21 {
  gen p9050_`i'= 2*ttail(49, t9050_`i')
 }
 
* mark significance
  forvalues i = 1(1)21 {
  gen star_9050_`i' =""
  replace star_9050_`i' = "*" if p9050_`i'<= 0.1
  replace star_9050_`i' = "**" if p9050_`i'<= 0.05
  replace star_9050_`i' = "***" if p9050_`i'<= 0.01
 }
 
* multiply with -1  
forvalues i = 1(1)21 {
  replace mean_DR9050`i'= mean_DR9050`i' * (-1)
 } 
   
* generate coefficients with significance signs  
forvalues i = 1(1)21 {
  gen coeff_mean_DR9050`i'= string(mean_DR9050`i', "%10.4f")
  replace coeff_mean_DR9050`i' = coeff_mean_DR9050`i' +  star_9050_`i'
 } 
 
* gen strings of standard errors 
 forvalues i = 1(1)21 {
 gen coef_se_9050_`i' = string(se9050_`i', "%10.4f")
 }
 
keep if bsloop==98
gen test=_n

forvalues i = 1(1)21 {
replace coef_se_9050_`i' = "(" + coef_se_9050_`i'+ ")"
}

gen id="test" 
reshape long coef, i(bsloop id) j(def) string
replace bsloop=_n
reshape wide coef, i(bsloop def) j(id) string

keep def coeftest bsloop
gen id1 = substr(def, 10,2)
destring id1, replace
gen id2 = substr(def, 14,2)
destring id2, replace
replace id1 = id2 if id1 >= 90
sort id1 id2

replace def= "group1_9050"				if def== "f_mean_DR90501"
replace def= "group2_9050"				if def== "f_mean_DR90502"
replace def= "Total change"				if def== "f_mean_DR90503"
replace def= "Abstract tasks"			if def== "f_mean_DR90504"
replace def= "Interactive tasks"		if def== "f_mean_DR90505"
replace def= "Manual tasks"				if def== "f_mean_DR90506"
replace def= "Routine tasks"			if def== "f_mean_DR90507"
replace def= "Education"				if def== "f_mean_DR90508"
replace def= "Firm controls"			if def== "f_mean_DR90509"
replace def= "Experience"				if def== "f_mean_DR905010"
replace def= "Composition effect"		if def== "f_mean_DR905011"
replace def= "Abstract tasks"			if def== "f_mean_DR905012"
replace def= "Interactive tasks"		if def== "f_mean_DR905013"
replace def= "Manual tasks "			if def== "f_mean_DR905014"
replace def= "Routine tasks"			if def== "f_mean_DR905015"
replace def= "Education"				if def== "f_mean_DR905016"
replace def= "Firm controls"			if def== "f_mean_DR905017"
replace def= "Experience"				if def== "f_mean_DR905018"
replace def= "Constant"					if def== "f_mean_DR905019"
replace def= "Wage structure effect"	if def== "f_mean_DR905020"
replace def= "Specification error"		if def== "f_mean_DR905021"

drop if id1==1
drop if id1==2

gen def2=def
replace def2=" " if def== "_se_9050_1"
replace def2=" " if def== "_se_9050_2"
replace def2=" " if def== "_se_9050_4"
replace def2=" " if def== "_se_9050_5"
replace def2=" " if def== "_se_9050_6"
replace def2=" " if def== "_se_9050_7"
replace def2=" " if def== "_se_9050_8"
replace def2=" " if def== "_se_9050_9"
replace def2=" " if def== "_se_9050_10"
replace def2=" " if def== "_se_9050_12"
replace def2=" " if def== "_se_9050_13"
replace def2=" " if def== "_se_9050_14"
replace def2=" " if def== "_se_9050_15"
replace def2=" " if def== "_se_9050_16"
replace def2=" " if def== "_se_9050_17"
replace def2=" " if def== "_se_9050_18"
replace def2=" " if def== "_se_9050_19"
replace def2=" " if def== "_se_9050_21"

keep def2 coeftest
order def2 coeftest

gen gap=9050

save "`output'\se\rifreg_7080_9050.dta", replace

********************************************************************************
clear all
use "`temp'\se\out_dfl_7080.dta"  
 
 *50/10
****** generate standard deviation
forvalues i = 1(1)21 {
  egen sd5010_`i'= sd(DR5010`i')
 }
 
gen denominator=sqrt(100)

 forvalues i = 1(1)21 {
  gen se5010_`i'= sd5010_`i'/denominator
 }
  
 *** compute sample means
  forvalues i = 1(1)21 {
  egen mean_DR5010`i'=mean(DR5010`i')
 }
 
****** t-values = coeff/se
   forvalues i = 1(1)21 {
  gen t5010_`i'= abs(mean_DR5010`i'/se5010_`i')
 }
 
***** p-values
    forvalues i = 1(1)21 {
  gen p5010_`i'= 2*ttail(49, t5010_`i')
 }
 
* mark significance
  forvalues i = 1(1)21 {
  gen star_5010_`i' =""
  replace star_5010_`i' = "*" if p5010_`i'<= 0.1
  replace star_5010_`i' = "**" if p5010_`i'<= 0.05
  replace star_5010_`i' = "***" if p5010_`i'<= 0.01
 }
 
* multiply with -1  
forvalues i = 1(1)21 {
  replace mean_DR5010`i'= mean_DR5010`i' * (-1)
 }  
  
* generate coefficients with significance signs  
 forvalues i = 1(1)21 {
  gen coeff_mean_DR5010`i'= string(mean_DR5010`i', "%10.4f")
  replace coeff_mean_DR5010`i' = coeff_mean_DR5010`i' +  star_5010_`i'
 }
 
* gen strings of standard errors 
  forvalues i = 1(1)21 {
 gen coef_se_5010_`i' = string(se5010_`i', "%10.4f")
 }
 
keep if bsloop==98
gen test=_n

forvalues i = 1(1)21 {
replace coef_se_5010_`i' = "(" + coef_se_5010_`i'+ ")"
}

gen id="test" 
reshape long coef, i(bsloop id) j(def) string
replace bsloop=_n
reshape wide coef, i(bsloop def) j(id) string
keep def coeftest bsloop

gen id1 = substr(def, 10,2)
destring id1, replace

gen id2 = substr(def, 14,2)
destring id2, replace
replace id1 = id2 if id1 >= 50
sort id1 id2

replace def= "group1_5010"				if def== "f_mean_DR50101"
replace def= "group2_5010"				if def== "f_mean_DR50102"
replace def= "Total change"				if def== "f_mean_DR50103"
replace def= "Abstract tasks"			if def== "f_mean_DR50104"
replace def= "Interactive tasks"		if def== "f_mean_DR50105"
replace def= "Manual tasks"				if def== "f_mean_DR50106"
replace def= "Routine tasks"			if def= "f_mean_DR50107"
replace def= "Education"				if def== "f_mean_DR50108"
replace def= "Firm controls"			if def== "f_mean_DR50109"
replace def= "Experience"				if def== "f_mean_DR501010"
replace def= "Composition effect"		if def== "f_mean_DR501011"
replace def= "Abstract tasks"			if def== "f_mean_DR501012"
replace def= "Interactive tasks"		if def== "f_mean_DR501013"
replace def= "Manual tasks "			if def== "f_mean_DR501014"
replace def= "Routine tasks"			if def== "f_mean_DR501015"
replace def= "Education"				if def== "f_mean_DR501016"
replace def= "Firm controls"			if def== "f_mean_DR501017"
replace def= "Experience"				if def== "f_mean_DR501018"
replace def= "Constant"					if def== "f_mean_DR501019"
replace def= "Wage structure effect"	if def== "f_mean_DR501020"
replace def= "Specification error"		if def== "f_mean_DR501021"

drop if id1==1
drop if id1==2

gen def2=def
replace def2=" " if def== "_se_5010_1"
replace def2=" " if def== "_se_5010_2"
replace def2=" " if def== "_se_5010_4"
replace def2=" " if def== "_se_5010_5"
replace def2=" " if def== "_se_5010_6"
replace def2=" " if def== "_se_5010_7"
replace def2=" " if def== "_se_5010_8"
replace def2=" " if def== "_se_5010_9"
replace def2=" " if def== "_se_5010_10"
replace def2=" " if def== "_se_5010_12"
replace def2=" " if def== "_se_5010_13"
replace def2=" " if def== "_se_5010_14"
replace def2=" " if def== "_se_5010_15"
replace def2=" " if def== "_se_5010_16"
replace def2=" " if def== "_se_5010_17"
replace def2=" " if def== "_se_5010_18"
replace def2=" " if def== "_se_5010_19"
replace def2=" " if def== "_se_5010_21"

keep def2 coeftest
order def2 coeftest

gen gap=5010

save "`output'\se\rifreg_7080_5010.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************
clear all

use "`output'\se\rifreg_7080_9010.dta"
append using "`output'\se\rifreg_7080_9050.dta"
append using "`output'\se\rifreg_7080_5010.dta"

keep if def2=="_se_5010_3" | def2=="_se_5010_11" | def2=="_se_5010_20" |  /*
		*/ def2=="_se_9010_3" | def2=="_se_9010_11" | def2=="_se_9010_20" |  /*	
		*/ def2=="_se_9050_3" | def2=="_se_9050_11" | def2=="_se_9050_20" | /*	
		*/ def2=="Total change" | def2=="Composition effect" | def2=="Wage structure effect" 

replace def2=" " if def== "_se_5010_20"	
replace def2=" " if def== "_se_5010_11"	
replace def2=" " if def== "_se_5010_3"	

replace def2=" " if def== "_se_9010_20"	
replace def2=" " if def== "_se_9010_11"	
replace def2=" " if def== "_se_9010_3"	

replace def2=" " if def== "_se_9050_20"	
replace def2=" " if def== "_se_9050_11"	
replace def2=" " if def== "_se_9050_3"	

gen year=1970
gen n=_n

save "`output'\se\rifreg_7080_aggr.dta", replace

texsave using "`tables'/aggr_results_70.tex", title(Aggregate decomposition results)	///
marker (results_aggr_70) varlabels replace frag


