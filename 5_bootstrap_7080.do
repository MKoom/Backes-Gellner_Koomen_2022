clear all
set more off
set matsize 10000 

local bibb "C:\01 Research\Inequality\Data\Bibb\"  
local siab "C:\01 Research\Inequality\Data\Siab\" 
local match "C:\01 Research\Inequality\Data\Matched" 
local temp "C:\01 Research\Inequality\Data\Temp"

program drop _all
*define the program to do the bootstrap std 
    program define bootdecomp
	version 13
      {  
        local reps = `1'
        *** bootstrap loop 
                local j 1  
                di "bootstrap loop step " `j'                    
         while `j'<= `reps' {  
                display  "doing rep `j' "  
              	use "`match'\match80.dta", clear	
				gen time=1
				drop if cens==1
			    bsample 
                save "`temp'\temp80.dta", replace
							
                use "`match'\match70.dta", clear 
				gen time=0
				drop if cens==1
				bsample 
                save "`temp'\temp70.dta", replace
							
				*** use artificial time=2 to store reweighted sample
				replace time=2
				append using "`temp'\temp80.dta"
                append using "`temp'\temp70.dta"
                
				gen bsloop=`j' 
                scalar bsrep=`reps'  
                save "`temp'\temp7080.dta", replace
								
        quietly do "C:\01 Research\Inequality\Do-files\boot_7080.do" 
                local j = `j' + 1 
                } 
                *** end j loop  
                
       } 
      display "bsdecomp done" 
      end 

****** 
* 1) begin by setting the no of reps below to 1 and save the output files for each of the quantile  
* 	 of interest as "out_dfl9010.dta", "out_dfl9050.dta", and "out_dfl5010.dta" 
* 2) put back the no of reps to 100 (or the no of desired reps) 
* 3) 100 estimates of the measures of interest will be found in the "out_genrif*.data" files 
* 4) use the summary command to compute the related standard errors  
****** 

****** 
* number indicates no reps 
bootdecomp 100
****** 







