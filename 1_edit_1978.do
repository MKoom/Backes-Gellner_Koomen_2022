
clear all
set more off
set matsize 10000
version 13

local raw "C:\01 Research\Inequality\Data\Siab\"  
local imputed "C:\01 Research\Inequality\Data\Siab\" 

use "`raw'/cross1978.dta"

*drop missings
keep if tentgelt_gr!=.
drop if tentgelt_gr==0
keep if bild!=.
keep if frau!=.
keep if beruf_gr!=.
keep if w73_gen_gr!=.
keep if ao_region!=.
keep if stib!=.
keep if erwstat_gr!=.
keep if deutsch!=.

*drop unnecessary variables 
drop begepi endepi begorig endorig schbild grund_gr tage_jung tage_alt pendler /* 
*/ quelle_gr level1 level2 ein_erw ein_bet tage_bet ein_job w03_gr 

*gen dummies
tab bild, gen(bild) nofreq
gen bl=int(ao_region/1000)
tab bl, gen(region) nofreq
tab w73_gen_gr, gen(sector) nofreq

*drop apprentices and part-time workers
drop if stib==0 | stib==7 | stib==8 | stib==9
*drop unnecessary variables
drop stib erwstat_gr

*keep German citizens only
keep if deutsch==1
drop deutsch

*keep males only
keep if frau==0
drop frau

*** gen potential experience
*age
gen age=jahr-gebjahr
*Card et al. 2013 >> sample 20-60
keep if age>19
keep if age<61
gen agesq=(age^2)/100
drop gebjahr

*years of education
gen educ=9 if bild==1
replace educ=12 if bild==2
replace educ=13 if bild==3
replace educ=16 if bild==4
replace educ=18 if bild==5 | bild==6

*experience
gen exp=age-educ-6
drop if exp<=0
gen expsq = (exp^2)/100

**** recode occupations
*drop occupations in agriculture sector
drop if beruf_gr==1
drop if beruf_gr==2
*drop music teacher as there's no counterpart in BIBB data
drop if beruf_gr==112

*combine categories to make it compatible with BIBB data
gen gruppe = .									
qui	replace	gruppe=	1	if beruf_gr==	3				
qui	replace	gruppe=	2	if beruf_gr==	4				
qui	replace	gruppe=	3	if beruf_gr==	5 | beruf_gr== 6				
qui	replace	gruppe=	4	if beruf_gr==	7				
qui	replace	gruppe=	5	if beruf_gr==	8				
qui	replace	gruppe=	6	if beruf_gr==	9 | beruf_gr== 10				
qui	replace	gruppe=	7	if beruf_gr==	11				
qui	replace	gruppe=	8	if beruf_gr==	12				
qui	replace	gruppe=	9	if beruf_gr==	13				
qui	replace	gruppe=	10	if beruf_gr==	14 | beruf_gr== 15 | beruf_gr== 16  | beruf_gr== 17				
qui	replace	gruppe=	11	if beruf_gr==	18				
qui	replace	gruppe=	12	if beruf_gr==	19 | beruf_gr== 20 | beruf_gr== 21 				
qui	replace	gruppe=	13	if beruf_gr==	22 | beruf_gr== 23 | beruf_gr== 24  				
qui	replace	gruppe=	14	if beruf_gr==	25 | beruf_gr== 26 | beruf_gr== 27				
qui	replace	gruppe=	15	if beruf_gr==	28				
qui	replace	gruppe=	16	if beruf_gr==	29				
qui	replace	gruppe=	17	if beruf_gr==	30 | beruf_gr== 31 | beruf_gr== 32				
qui	replace	gruppe=	18	if beruf_gr==	33 | beruf_gr== 34 | beruf_gr== 35				
qui	replace	gruppe=	19	if beruf_gr==	36				
qui	replace	gruppe=	20	if beruf_gr==	37				
qui	replace	gruppe=	21	if beruf_gr==	38				
qui	replace	gruppe=	22	if beruf_gr==	39				
qui	replace	gruppe=	23	if beruf_gr==	40				
qui	replace	gruppe=	24	if beruf_gr==	41				
qui	replace	gruppe=	25	if beruf_gr==	42				
qui	replace	gruppe=	26	if beruf_gr==	43 | beruf_gr== 44				
qui	replace	gruppe=	27	if beruf_gr==	45 | beruf_gr== 46				
qui	replace	gruppe=	28	if beruf_gr==	47				
qui	replace	gruppe=	29	if beruf_gr==	48 | beruf_gr== 49				
qui	replace	gruppe=	30	if beruf_gr==	50				
qui	replace	gruppe=	31	if beruf_gr==	51				
qui	replace	gruppe=	32	if beruf_gr==	52 | beruf_gr== 53				
qui	replace	gruppe=	33	if beruf_gr==	54 | beruf_gr== 55				
qui	replace	gruppe=	34	if beruf_gr==	56				
qui	replace	gruppe=	35	if beruf_gr==	57 | beruf_gr== 58				
qui	replace	gruppe=	36	if beruf_gr==	59 | beruf_gr== 60 | beruf_gr== 61 | beruf_gr== 62				
qui	replace	gruppe=	37	if beruf_gr==	63				
qui	replace	gruppe=	38	if beruf_gr==	64 | beruf_gr==	65 | beruf_gr==	66 | beruf_gr==	67 | beruf_gr==	68
qui	replace	gruppe=	38	if beruf_gr==	71	| beruf_gr==	70 |	beruf_gr== 	69  		
qui	replace	gruppe=	39	if beruf_gr==	72 | beruf_gr== 73 | beruf_gr== 74 | beruf_gr== 75				
qui	replace	gruppe=	40	if beruf_gr==	76 | beruf_gr== 77				
qui	replace	gruppe=	41	if beruf_gr==	78 | beruf_gr== 79				
qui	replace	gruppe=	42	if beruf_gr==	80 | beruf_gr== 81				
qui	replace	gruppe=	43	if beruf_gr==	82				
qui	replace	gruppe=	44	if beruf_gr==	83				
qui	replace	gruppe=	45	if beruf_gr==	84 | beruf_gr== 85 | beruf_gr== 86				
qui	replace	gruppe=	46	if beruf_gr==	87 | beruf_gr== 88					
qui	replace	gruppe=	47	if beruf_gr==	89					
qui	replace	gruppe=	48	if beruf_gr==	90 | beruf_gr== 91 			
qui	replace	gruppe=	49	if beruf_gr==	93 | beruf_gr== 92|	beruf_gr== 94 | beruf_gr== 95				
qui	replace	gruppe=	50	if beruf_gr==	96 | beruf_gr==97 | beruf_gr==98 				
qui	replace	gruppe=	51	if beruf_gr==	99				
qui	replace	gruppe=	52	if beruf_gr==	100 | beruf_gr==101				
qui	replace	gruppe=	53	if beruf_gr==	102					
qui	replace	gruppe=	54	if beruf_gr==	103 | beruf_gr==104 | beruf_gr==105 | beruf_gr==106 | beruf_gr==107 				
qui	replace	gruppe=	55	if beruf_gr==	108 | beruf_gr==109 | beruf_gr==110				
qui	replace	gruppe=	56	if beruf_gr==	111 | beruf_gr==112				
qui	replace	gruppe=	57	if beruf_gr==	113					
qui	replace	gruppe=	58	if beruf_gr==	114				
qui	replace	gruppe=	59	if beruf_gr==	115 | beruf_gr==116				
qui	replace	gruppe=	60	if beruf_gr==	117				
qui	replace	gruppe=	61	if beruf_gr==	118 | beruf_gr==119 | beruf_gr==120				
rename gruppe beruf

*employment share
bys beruf: gen occup_size=_N
gen total_size=_N
gen occup_share=occup_size/total_size * 100
							
*gen major occupational groups
gen kdlb=0
replace kdlb=1 if beruf >= 1 & beruf < 12
replace kdlb=2 if beruf >= 12 & beruf < 17
replace kdlb=3 if beruf >= 17 & beruf < 23
replace kdlb=4 if beruf >= 23 & beruf < 30
replace kdlb=5 if beruf >= 30 & beruf < 36
replace kdlb=6 if beruf >= 36 & beruf < 38
replace kdlb=7 if beruf >= 38 & beruf < 42
replace kdlb=8 if beruf >= 42 & beruf < 48
replace kdlb=9 if beruf >= 48 & beruf < 52
replace kdlb=10 if beruf >= 52 & beruf < 56
replace kdlb=11 if beruf >= 56 & beruf < 62
*gen occupation dummies
tab kdlb, gen(occup) nofreq

*adjust to 2006 wages, CPI Index in 1978 is 47.5573054706082
gen wage=(tentgelt_gr*93.9083333333333)/47.5573054706082
*drop observations with wages below 12 EUR (Riphahn and Schnitzlein (2016)), which is 11.43 EUR in 2006 wages  
keep if wage > 11.43 

*** impute censored wages
*gen censored dummy
xtile xtent = tentgelt, nq(100)
gen cens=0
replace cens=1 if xtent>=91
drop xtent
xtile xwage= wage, nq(10)
*log wages
gen lnw=log(wage) 
*gen variable "limit"
sum wage
*limit is 122.4274
gen limit=122.4274
*impute censored wages
imputw lnw exp expsq bild1-bild6 region* sector* kdlb*, cens(cens) grenze(limit)
*drop unnecessary variables 
drop limit 

*sort data
sort persnr spell
*smooth years
gen year=1

compress
saveold "`imputed'/ready1978.dta", replace

