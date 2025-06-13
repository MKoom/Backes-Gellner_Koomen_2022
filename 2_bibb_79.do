clear all
set more off

local raw "C:\01 Research\Inequality\Data\Bibb\"  
local edited "C:\01 Research\Inequality\Data\Bibb\" 

use "`raw'/1979.dta", clear

gen jahr=1

********************************************************************************
* SAMPLE PREPARATION

*exclude unemployed
drop if V64==2
drop if V64==.

*exclude self-employed
mvdecode V68, mv(99)
mvdecode V68, mv(00) 
drop if V68==40 | V68==41 | V68==42 | V68==43 | V68==44 | V68==45
drop if V68==.

*keep fulltime employees (>90% of average working hours, here 40 hrs)
mvdecode V71, mv(999)
gen fulltime=0
replace fulltime=1 if V71>35
keep if fulltime==1

*age
mvdecode V437, mv(99)
gen age=79-V437 if V437!=.
keep if age>19
keep if age<61

*gender
gen male=(V438==1)
keep if male==1

*education
*drop missings
drop if V31==.
drop if V30==.
*gen three educ categories
gen bild=2 if V8==2
replace bild=3 if V31!=0 | V30!=0
replace bild=1 if (V8==1 & bild!=3) 

********************************************************************************
* OCCUPATIONS
gen beruf=int(V67/10000)
tab beruf

*exclude agriculture
drop if beruf<7
*drop occupations that are not identified according to the 1988 classification
drop if beruf == 38
drop if beruf == 55 | beruf == 56 | beruf == 57 | beruf == 58 | beruf == 59
drop if beruf == 64 | beruf == 65 | beruf == 66 | beruf == 67
drop if beruf>93
drop if beruf==89
drop if beruf==81

*combine categories to make them compatible with SIAB data 
gen gruppe = .					
qui	replace	gruppe=	1	if beruf==	 7 | beruf == 8 | beruf == 9 | beruf == 10 | beruf == 11
qui	replace	gruppe=	2	if beruf==	12 | beruf == 13
qui	replace	gruppe=	3	if beruf==	14
qui	replace	gruppe=	4	if beruf==	15
qui	replace	gruppe=	5	if beruf==	16
qui	replace	gruppe=	6	if beruf==	17
qui	replace	gruppe=	7	if beruf==	18
qui	replace	gruppe=	8	if beruf==	19 | beruf == 20
qui	replace	gruppe=	9	if beruf==	21
qui	replace	gruppe=	10	if beruf==	22 | beruf == 23
qui	replace	gruppe=	11	if beruf==	24
qui	replace	gruppe=	12	if beruf==	25 | beruf == 26
qui	replace	gruppe=	13	if beruf==	27
qui	replace	gruppe=	14	if beruf==	28
qui	replace	gruppe=	15	if beruf==	29
qui	replace	gruppe=	16	if beruf==	30
qui	replace	gruppe=	17	if beruf==	31
qui	replace	gruppe=	18	if beruf==	32
qui	replace	gruppe=	19	if beruf==	33 | beruf == 34
qui	replace	gruppe=	20	if beruf==	35 | beruf == 36 | beruf == 37
qui	replace	gruppe=	21	if beruf==	39
qui	replace	gruppe=	22	if beruf==	40
qui	replace	gruppe=	23	if beruf==	41
qui	replace	gruppe=	24	if beruf==	42 | beruf == 43
qui	replace	gruppe=	25	if beruf==	44
qui	replace	gruppe=	26	if beruf==	45
qui	replace	gruppe=	27	if beruf==	46
qui	replace	gruppe=	28	if beruf==	47
qui	replace	gruppe=	29	if beruf==	48
qui	replace	gruppe=	30	if beruf==	49
qui	replace	gruppe=	31	if beruf==	50
qui	replace	gruppe=	32	if beruf==	51
qui	replace	gruppe=	33	if beruf==	52
qui	replace	gruppe=	34	if beruf==	53
qui	replace	gruppe=	35	if beruf==	54
qui	replace	gruppe=	36	if beruf==	60
qui	replace	gruppe=	37	if beruf==	61
qui	replace	gruppe=	38	if beruf==	62 | beruf == 63
qui	replace	gruppe=	39	if beruf==	68
qui	replace	gruppe=	40	if beruf==	69
qui	replace	gruppe=	41	if beruf==	70
qui	replace	gruppe=	42	if beruf==	71
qui	replace	gruppe=	43	if beruf==	72
qui	replace	gruppe=	44	if beruf==	73
qui	replace	gruppe=	45	if beruf==	74
qui	replace	gruppe=	46	if beruf==	75
qui	replace	gruppe=	47	if beruf==	76
qui	replace	gruppe=	48	if beruf==	77
qui	replace	gruppe=	49	if beruf==	78
qui	replace	gruppe=	50	if beruf==	79 | beruf == 80 | beruf == 81
qui	replace	gruppe=	51	if beruf==	82
qui	replace	gruppe=	52	if beruf==	83
qui	replace	gruppe=	53	if beruf==	84
qui	replace	gruppe=	54	if beruf==	85
qui	replace	gruppe=	55	if beruf==	86
qui	replace	gruppe=	56	if beruf==	87
qui	replace	gruppe=	57	if beruf==	88 | beruf == 89
qui	replace	gruppe=	58	if beruf==	90
qui	replace	gruppe=	59	if beruf==	91
qui	replace	gruppe=	60	if beruf==	92
qui	replace	gruppe=	61	if beruf==	93

drop if gruppe==.
rename beruf beruf88
rename gruppe beruf

********************************************************************************
* TASK VARIABLES 

*drop missings
mvdecode V130-V218, mv(8)
mvdecode V130-V218, mv(9)
keep if V130-V218!=.

* Manual 
gen t155=(V155==1)					// restaurieren, reparieren, ausbessern
gen t156=(V156==1|V157==1|V207==1)	// Gaeste bewirten/beherbergen, betreuen, pflegen
gen t158=(V200==1|V158==1) 		 	// Muell/Abfall entsorgen, reinigen, waschen
gen t198=(V198==1) 					// bewachen, absichern, kontrollieren
gen t131=(V138==1|V139==1|V140==1|V141==1|V142==1|/*
		  */V144==1|V145==1|V146==1|V147==1|V148==1|/*
		  */V131==1|V132==1|V136==1|V137==1|V182==1|V189==1) // herstellen, bearbeiten
gen t218=(V218==1) 					// Technische Anlagen/Maschinen einrichten

* Interactive
gen t206=(V206==1) 				 	// erziehen, unterrichten, ausbilden
gen t209=(V209==1)					// publizieren, journalistisch arbeiten
gen t213=(V213==1)					// verhandeln, Interessen vertreten
gen t214=(V214==1)					// koordinieren, organisieren, Mitarbeiter anleiten

* Abstract
gen t171=(V171==1)					// forschen, auswerten, projektieren
gen t172=(V172==1|V173==1)			// planen, konstruieren
gen t202=(V202==1|V203==1)  		// Gesetze auslegen und anwenden
gen t195=(V195==1|V196==1|V197==1) 	// programmieren, EDV 
gen t168=(V168==1|V165==1)			// pruefen, kontrollieren 			
gen t192=(V192==1|V188==1|V193==1)	// Briefe verfassen, kalkulieren/buchen

*die Summe aller genannten Tasks, die im Modell aufgenommen werden
gen sum  = (t131+t155+t156+t158+t198+t218+t209+t206+t213+t214+t171+t172+t202+t195+t168+t192)
drop if sum==0

/* Which of the above tasks are the routine tasks? 
Correlation analysis with the 2 questions measuring routineness of a job */
reg	V276	t131		
reg	V276	t218		
reg	V276	t155 		 
reg	V276	t156
reg	V276	t158 		 
reg	V276	t198		
reg	V276	t206
reg	V276	t209
reg	V276	t213
reg	V276	t214
reg	V276	t171
reg	V276	t172
reg	V276	t202
reg	V276	t195
reg	V276	t192
reg	V276	t168		

reg	V277	t131		
reg	V277	t218		 
reg	V277	t155 		
reg	V277	t156
reg	V277	t158		
reg	V277	t198
reg	V277	t206
reg	V277	t209
reg	V277	t213
reg	V277	t214
reg	V277	t171
reg	V277	t172
reg	V277	t202
reg	V277	t195
reg	V277	t192
reg	V277	t168		

gen abst = (t171+t172+t202+t195+t192)/5
gen inte = (t206+t209+t213+t214)/4
gen manu  = (t155+t156+t198)/3
gen rout = (t131+t218+t158+t168)/4

bys beruf: egen av_abst=mean(abst)
bys beruf: egen av_inte=mean(inte)
bys beruf: egen av_manu=mean(manu)
bys beruf: egen av_rout=mean(rout)

*for descriptives (please view manuscript)
gen abst_tasks = (t171+t172+t202+t195+t192)/(sum)
gen inte_tasks = (t206+t209+t213+t214)/(sum)
gen manu_tasks  = (t155+t156+t198)/(sum)
gen rout_tasks  = (t131+t218+t158+t168)/(sum)

bys beruf: egen av_abst_tasks=mean(abst_tasks)
bys beruf: egen av_inte_tasks=mean(inte_tasks)
bys beruf: egen av_manu_tasks=mean(manu_tasks)
bys beruf: egen av_rout_tasks=mean(rout_tasks)

********************************************************************************
bys beruf: gen n=_N
order beruf V2
sort beruf V2   
		  
saveold "`edited'/bibb79.dta", replace
