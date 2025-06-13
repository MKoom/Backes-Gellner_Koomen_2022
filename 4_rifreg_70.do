clear all
set more off
set matsize 10000 

local bibb "C:\01 Research\Inequality\Data\Bibb\"  
local siab "C:\01 Research\Inequality\Data\Siab\" 
local match "C:\01 Research\Inequality\Data\Matched" 
local temp "C:\01 Research\Inequality\Data\Temp"

use "`match'/match80.dta", clear
gen time=1
drop if cens==1
save "`temp'/temp80.dta", replace

use "`match'/match70.dta", clear
gen time=0
drop if cens==1
save "`temp'/temp70.dta", replace

*** use artificial time=2 to store reweighted sample
replace time=2
append using "`temp'/temp70.dta"
append using "`temp'/temp80.dta"

*** gen experience dummies
gen exp1=0
replace exp1=1 if exp>0 & exp<=5
gen exp2=0
replace exp2=1 if exp>5 & exp<=10
gen exp3=0
replace exp3=1 if exp>10 & exp<=15
gen exp4=0
replace exp4=1 if exp>15 & exp<=20
gen exp5=0
replace exp5=1 if exp>20 & exp<=25
gen exp6=0
replace exp6=1 if exp>25 & exp<=30
gen exp7=0
replace exp7=1 if exp>30 & exp<=35
gen exp8=0
replace exp8=1 if exp>35 

*** generate interactions
gen exp1bild1=exp1*bild1
gen exp1bild2=exp1*bild2
gen exp1bild3=exp1*bild3
gen exp1bild4=exp1*bild4
gen exp1bild5=exp1*bild5
gen exp1bild6=exp1*bild6
global exo1 = "exp1bild1 exp1bild2 exp1bild3 exp1bild4 exp1bild5 exp1bild6"

gen exp2bild1=exp2*bild1
gen exp2bild2=exp2*bild2
gen exp2bild3=exp2*bild3
gen exp2bild4=exp2*bild4
gen exp2bild5=exp2*bild5
gen exp2bild6=exp2*bild6
global exo2 = "exp2bild1 exp2bild2 exp2bild3 exp2bild4 exp2bild5 exp2bild6"

gen exp3bild1=exp3*bild1
gen exp3bild2=exp3*bild2
gen exp3bild3=exp3*bild3
gen exp3bild4=exp3*bild4
gen exp3bild5=exp3*bild5
gen exp3bild6=exp3*bild6
global exo3 = "exp3bild1 exp3bild2 exp3bild3 exp3bild4 exp3bild5 exp3bild6"

gen exp4bild1=exp4*bild1
gen exp4bild2=exp4*bild2
gen exp4bild3=exp4*bild3
gen exp4bild4=exp4*bild4
gen exp4bild5=exp4*bild5
gen exp4bild6=exp4*bild6
global exo4 = "exp4bild1 exp4bild2 exp4bild3 exp4bild4 exp4bild5 exp4bild6"

gen exp5bild1=exp5*bild1
gen exp5bild2=exp5*bild2
gen exp5bild3=exp5*bild3
gen exp5bild4=exp5*bild4
gen exp5bild5=exp5*bild5
gen exp5bild6=exp5*bild6
global exo5 = "exp5bild1 exp5bild2 exp5bild3 exp5bild4 exp5bild5 exp5bild6"

gen exp6bild1=exp6*bild1
gen exp6bild2=exp6*bild2
gen exp6bild3=exp6*bild3
gen exp6bild4=exp6*bild4
gen exp6bild5=exp6*bild5
gen exp6bild6=exp6*bild6
global exo6 = "exp6bild1 exp6bild2 exp6bild3 exp6bild4 exp6bild5 exp6bild6"

gen exp7bild1=exp7*bild1
gen exp7bild2=exp7*bild2
gen exp7bild3=exp7*bild3
gen exp7bild4=exp7*bild4
gen exp7bild5=exp7*bild5
gen exp7bild6=exp7*bild6
global exo7 = "exp7bild1 exp7bild2 exp7bild3 exp7bild4 exp7bild5 exp7bild6"

gen exp8bild1=exp8*bild1
gen exp8bild2=exp8*bild2
gen exp8bild3=exp8*bild3
gen exp8bild4=exp8*bild4
gen exp8bild5=exp8*bild5
gen exp8bild6=exp8*bild6
global exo8 = "exp8bild1 exp8bild2 exp8bild3 exp8bild4 exp8bild5 exp8bild6"

*** standardize task variables
egen zabst=std(av_abst)
egen zinte=std(av_inte)
egen zmanu=std(av_manu)
egen zrout=std(av_rout)

*** logit for year effect 
xi: probit time i.bild $exo1 $exo2 $exo3 $exo5 $exo6 $exo7 $exo8 zabst zinte zmanu zrout exp expsq i.w73_gen_gr occup1-occup11 i.bl if time==0 | time==1
predict ps, p
sum ps, d
sum time if time==0 | time==1
gen pbar=r(mean)

*** weighting factor
gen psi=(ps/pbar)/((1-ps)/(1-pbar)) if time==2
replace psi=1 if time!=2

** get rif for 10, 50 and 90 percentiles
forvalues it = 0(1)2 {	
pctile valx=lnw if time==`it' [aweight=psi], nq(100) 
kdensity lnw [aweight=psi] if time==`it', at(valx) gen(evalt`it' denst`it') width(0.065) nograph 
 forvalues qt = 10(40)90 {	
 local qc = `qt'/100.0
 gen rif`it'_`qt'=evalt`it'[`qt']+`qc'/denst`it'[`qt'] if lnw>=evalt`it'[`qt'] & time==`it'
 replace rif`it'_`qt'=evalt`it'[`qt']-(1-`qc')/denst`it'[`qt'] if lnw<evalt`it'[`qt']& time==`it'
  }
 drop valx

}
drop eval* denst*

gen rifat=.
forvalues qt = 10(40)90 {	
di "evaluating quantile= " `qt'
*** get decomposition without reweighing [E(X_1|t=1)- E(X_0|t=0)]B_0   
 replace rifat=rif0_`qt' if time==0
 replace rifat=rif1_`qt' if time==1
 oaxaca rifat zabst zinte zmanu zrout bild1 bild2 bild5 bild6 normalize(region1-region11) normalize(sector1-sector16) normalize(occup1-occup11) exp1-exp3 exp5-exp8 [aweight=psi] if time==0 | time==1, /*
 */  by(time) weight(1) detail(groupexp:exp1-exp8, groupeduc: bild1-bild6, groupfirm: region* occup* sector*)  
 matrix Ra`qt'=e(b)

 replace rifat=.
*** get composition effects with reweighing [E(X_0|t=1)- E(X_0|t=0)]B_c  
 replace rifat=rif2_`qt' if time==2
 replace rifat=rif0_`qt' if time==0
 oaxaca rifat zabst zinte zmanu zrout bild1 bild2 bild5 bild6 normalize(region1-region11) normalize(sector1-sector16) normalize(occup1-occup11) exp1-exp3 exp5-exp8  [aweight=psi] if time==0 | time==2, /*
 */ by(time) weight(1) detail(groupexp:exp1-exp8, groupeduc: bild1-bild6, groupfirm:region* occup* sector*) 
 matrix Rc=e(b)
 
 replace rifat=.
*** get wage structure effects E(X_1|t=1)*[B_1-B_c]
 replace rifat=rif1_`qt' if time==1
 replace rifat=rif2_`qt' if time==2
 oaxaca rifat zabst zinte zmanu zrout bild1 bild2 bild5 bild6 normalize(region1-region11) normalize(sector1-sector16) normalize(occup1-occup11) exp1-exp3 exp5-exp8  [aweight=psi] if time==1 | time==2, /* 
 */  by(time) weight(0) detail(groupexp:exp1-exp8, groupeduc: bild1-bild6, groupfirm: region* occup* sector*) 
  
matrix Rw=e(b)
matrix Rcrwer=Ra`qt'[1,4]-Rc[1,4]
matrix colnames Rcrwer = Rwerror
matrix Rwc=Rw[1,20]
matrix colnames Rwc = constant
matrix Rt`qt'=Ra`qt'[1,1..3],Rc[1,6..12],Rc[1,4],-Rw[1,13..19],-Rwc,-Rw[1,5], Rcrwer
matrix list Rt`qt'

 }

*** matrix with reweighting
matrix DR9010=Rt90-Rt10
matrix DR9050=Rt90-Rt50
matrix DR5010=Rt50-Rt10

matrix list DR9010
matrix list DR9050
matrix list DR5010

svmat DR9010
svmat DR9050
svmat DR5010

clear


