import pandas as pd
import numpy as np
from linearmodels.iv import IV2SLS
import statsmodels.api as sm
from causalinference import CausalModel



"""
Question 2: Effect of training on wages

Dataset:
earnings      = accumulated income over 30 months;
jtpa offer    = dummy for the JTPA training offer;
jtpa training = dummy for those who actually completed the training with JTPA;
sex           = dummy for the individual's sex;
hsorged       = dummy variable for individuals with a completed secondary education;
black         = dummy;
hispanic      = dummy;
married       = dummy;
wkless13      = dummy for individuals who worked less than 13 weeks during the last year;
age2225,age2629,age3035,age3644 and age4554 = Dummies for age ranges.
"""

jtpa = pd.read_stata(r"\jtpa.dta")  # Put the path here <----

# Level model
y = jtpa['income']
x = jtpa[['treatment','male','hsorged','black','hispanic','married','wkless13','age2225','age2629','age3035','age3644','age4554']]
x = sm.add_constant(x)
model = sm.OLS(y, x).fit()
print(model.summary())

# Logarithmic model
jtpa['lincome'] = np.log(jtpa['income'])
ly = jtpa['lincome']
modell = sm.OLS(ly, x).fit()
print(modell.summary())

# Estimate the average causal effect of the treatment using Propensity Score Matching (PSM).
# Propensity Score Matching is a technique that seeks to compare treated and untreated subjects who are 
# similar in terms of their observable characteristics (the controls), in order to approximate a 
# randomized experiment and estimate the treatment effect.
y = jtpa['income'].values
d = jtpa['treatment'].values
x = jtpa[['male','hsorged','black','hispanic','married','wkless13','age2225','age2629','age3035','age3644','age4554']].values
model = CausalModel(y, d, x)
model.est_propensity_s()
model.est_via_matching(bias_adj=True)
print(model.estimates)

ly = jtpa['lincome'].values
modell = CausalModel(ly, d, x)
modell.est_propensity_s()
modell.est_via_matching(bias_adj=True)
print(modell.estimates)

# Potential endogeneity of the program arises because the treatment variable is not completely random; this 
# implies that the decision to participate may be linked to unobserved individual characteristics that, in 
# turn, affect income. This gives rise to "selection bias" (a specific case of omitted variable bias).

# Instrumental variable model
jtpa = sm.add_constant(jtpa)
ins = IV2SLS(jtpa['income'], jtpa[['const','male','hsorged','black','hispanic','married','wkless13','age2225','age2629','age3035','age3644','age4554']], jtpa['treatment'], jtpa['instrument'])
reg_ins = ins.fit()
print(reg_ins)

lins = IV2SLS(jtpa['lincome'], jtpa[['const','male','hsorged','black','hispanic','married','wkless13','age2225','age2629','age3035','age3644','age4554']], jtpa['treatment'], jtpa['instrument'])
reg_lins = lins.fit()
print(reg_lins)

# Interpretation of the treatment coefficient:

"""
Level model:
For "compliers" (individuals whose actual participation shifts from 0 to 1 due to the random offer), receiving the program 
training (treatment = 1) increases cumulative income over 30 months by an average of $1,730, compared to not receiving it, 
while holding other individual characteristics (sex, education, race, marital status, employment history, and age) constant. 
This effect is statistically significant at the 1% level (p < 0.01).

Logarithmic model:
For compliers, receiving the program training increases cumulative income over 30 months by 
approximately 11.7% on average, compared to not receiving it, while holding other individual 
characteristics (gender, education, race, marital status, employment history, and age) constant. 
This effect is statistically significant at the 5% level (p < 0.05).
"""
