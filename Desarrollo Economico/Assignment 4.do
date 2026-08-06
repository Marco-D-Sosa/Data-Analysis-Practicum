cd "" // Put the path here <----

use "cell phone sim.dta", clear
eststo clear



/************
 *  Item b  *
 ************/
 
* Generate the scenario of heterogeneous effects (slides 9–10)
* Add 2 to the price_disp of RII in P2: δ_RII changes from -4.97 to -2.97
gen price_disp_het = price_disp
replace price_disp_het = price_disp + 2 if RII==1 & P2==1

* Slide 11: "Different Effect on RII"
* Comparison of RI (addressed in P1, already covered) vs. RII in P1–P2
* delta_RII should now yield -2.97 (instead of -4.97)
eststo model_RII_het: reg price_disp_het RII P2 RIIP2 if (P1==1 | P2==1) & RIII==0
* RIP1 should yield ~ -2.97

* Check: delta_RI (P0-P1) remains unchanged at -4.85 because the modification was only to RII-P2
eststo model_RI_het: reg price_disp_het RI P1 RIP1 if (P0==1 | P1==1) & RIII==0
* RIP1 should yield ~ -4.85

* Slide 12: "Average Effect with TWFE"
* TWFE with DiD, now with heterogeneous outcomes.
eststo model_TWFE_het: reg price_disp_het RII P1 P2 dI if RIII==0 & P3==0
* dI should yield ~ -3.91

* Verification: average of the two individual effects
display (-4.85 + -2.97)/2
* = -3.91, equal to the coefficient of dI

* Export the stored regressions
esttab model_RII_het model_RI_het model_TWFE_het using "heterogeneous_effects.rtf", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    legend label title("Heterogeneous Effects Scenario") ///
    mtitle("Delta RII (-2.97)" "Delta RI (-4.85)" "TWFE Average") ///
    stats(r2 N, labels("R-squared" "Observations"))	



/************
 *  Item  c *
 ************/

* Generate the "Dynamic Effects" scenario (Slide 16)
* Assume an additional effect of -1 for RI (treated in P1) as the treatment matures in P2
gen price_disp_dyn = price_disp
replace price_disp_dyn = price_disp - 1 if RI == 1 & P2 == 1

* Sub-experiment 1: Estimate delta_{RI} (Comparison P0 vs P1)
* Treated: RI | Control: RII (not yet treated)
* This estimator have to be unbiased and yield -4.85, since the pre-treatment RII provides a valid parallel trend
eststo model_RI: reg price_disp_dyn RI P1 RIP1 if (P0 == 1 | P1 == 1) & RIII == 0

* Sub-experiment 2: Estimate delta_{RII} (Comparison P1 vs P2)
* Treaty: RII | Control: IR (already treated)
* This is where the "forbidden comparison" occurs. RI carries over the dynamic effect of -1
* The interaction coefficient (DiD effect) will capture the bias, decreasing from -4.97 to -3.97
eststo model_RII: reg price_disp_dyn RII P2 RIIP2 if (P1 == 1 | P2 == 1) & RIII == 0

* Full TWFE regression (Average effect)
* We replicate the specification from slide 12/17, but with the dynamic dependent variable
* The coefficient of the treatment dummy (dI) will be a weighted average that carries over the bias from sub-experiment 2
eststo model_TWFE: reg price_disp_dyn RII P1 P2 dI if RIII == 0

* Exporting Results
esttab model_RI model_RII model_TWFE using "replication_dynamic_effects.rtf", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    legend label title("Impact of Dynamic Effects on the TWFE Estimator") ///
    mtitle("Delta RI (Unbiased) " "Delta RII (Biased)" "TWFE (Contaminated Average)") ///
    stats(r2 N, labels("R-squared" "Observations"))
