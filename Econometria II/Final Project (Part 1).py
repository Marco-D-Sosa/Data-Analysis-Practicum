import pandas as pd
import numpy as np
from scipy import stats
from linearmodels.panel import PanelOLS, RandomEffects
import statsmodels.api as sm



"""
Question 1: Panel data on gasoline consumption

Dataset:
country
year
lgaspcar = ln(gas/car)
lincomep = ln(y/n)
lrpmg    = ln(pmg/pgdp)
lcarpcap = ln(car/n)
"""

# Open dataset
data = pd.read_csv(r".\datos_procesados.csv")  # Put the path here <----
print(data.describe())

# Set the data as panel data
data = data.set_index(['COUNTRY', 'YEAR'])
data = data.sort_index()

# Dummy variables are created for the years
year_dummies = pd.get_dummies(data.index.get_level_values('YEAR'), prefix='d', drop_first=True)
year_dummies.index = data.index
data = pd.concat([data, year_dummies], axis=1)
print(data.head())

# Run the regression
y = data['LGASPCAR']
cols_dummies = [c for c in data.columns if c.startswith('d_')]
vars_x = ['LINCOMEP','LRPMG','LCARPCAP'] + cols_dummies
x = data[vars_x]
x = sm.add_constant(x)
mod = RandomEffects(y, x)
res = mod.fit(small_sample=True)
print(res)

# Evaluate the Hausman test:

# Fixed effects
vars_interest = ['LINCOMEP','LRPMG','LCARPCAP']
mod_fe = PanelOLS(data.LGASPCAR, data[vars_interest], entity_effects=True)
res_fe = mod_fe.fit()
# Random effects
x_re = sm.add_constant(data[vars_interest])
mod_re = RandomEffects(data.LGASPCAR, x_re)
res_re = mod_re.fit()

b_fe = res_fe.params
b_re = res_re.params[vars_interest]
cov_fe = res_fe.cov
cov_re = res_re.cov.loc[vars_interest, vars_interest]
b_diff = b_fe - b_re
v_diff = cov_fe - cov_re
stat = b_diff.T @ np.linalg.inv(v_diff) @ b_diff
df = len(vars_interest)
p_value = 1 - stats.chi2.cdf(stat, df)
print(f'Chi-Square: {stat:.4f}')
print(f'p-value: {p_value:.6f}')
# The Hausman test yielded a p-value of 0. This means that the fixed-effects model is preferred

# Dynamic autoregressive model
data['LGASPCAR_lag'] = data.groupby('COUNTRY')['LGASPCAR'].shift(1)
data_reg = data.dropna().copy()
y_lag = data_reg['LGASPCAR']
vars_lag = ['LINCOMEP','LRPMG','LCARPCAP','LGASPCAR_lag']
x_lag = data_reg[vars_lag]
x_lag = sm.add_constant(x_lag)
mod_lag = PanelOLS(y_lag, x_lag, entity_effects=True, time_effects=True)
res_lag = mod_lag.fit()
print(res_lag)

# Estimate long-run elasticities and test the null hypothesis that they are zero:

# Long-run income elasticity
beta_income = res_lag.params['LINCOMEP']
coef_lag = res_lag.params['LGASPCAR_lag']
long_term_elasticity = beta_income / (1 - coef_lag)
print(f"long-term elasticity: {long_term_elasticity}")
# Long-run price elasticity
beta_price = res_lag.params['LRPMG']
long_term_elasticity = beta_price / (1 - coef_lag)
print(f"long-term elasticity: {long_term_elasticity}")
# Long-run elasticity of cars per capita
beta_cars = res_lag.params['LCARPCAP']
long_term_elasticity = beta_cars / (1 - coef_lag)
print(f"long-term elasticity: {long_term_elasticity}")

# Conclusion: The long-run elasticities are non-zero, except for the income elasticity.
