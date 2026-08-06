import pandas as pd
import numpy as np
from scipy import stats
from linearmodels.panel import PanelOLS, RandomEffects
from linearmodels.iv import IV2SLS
import statsmodels.api as sm
from causalinference import CausalModel



"""
Pregunta 1: Datos en panel para consumo de gasolina

Base de datos:
country  = pais
year     = año
lgaspcar = ln(gas/car)
lincomep = ln(y/n)
lrpmg    = ln(pmg/pgdp)
lcarpcap = ln(car/n)
"""

# Abrimos la base de datos
datos = pd.read_csv(r"C:\Users\HP\Documents\Analisis de datos\Python\TP Econometria II\datos_procesados.csv")
print(datos.describe())

# Seteamos los datos en panel
datos = datos.set_index(['COUNTRY', 'YEAR'])
datos = datos.sort_index()

# Creo las variables dummy para los años
year_dummies = pd.get_dummies(datos.index.get_level_values('YEAR'), prefix='d', drop_first=True)
year_dummies.index = datos.index
datos = pd.concat([datos, year_dummies], axis=1)
print(datos.head())

# Corremos la regresion
y = datos['LGASPCAR']
cols_dummies = [c for c in datos.columns if c.startswith('d_')]
vars_x = ['LINCOMEP','LRPMG','LCARPCAP'] + cols_dummies
x = datos[vars_x]
x = sm.add_constant(x)
mod = RandomEffects(y, x)
res = mod.fit(small_sample=True)
print(res)

# Evaluamos el test de Hausman:

# Fixed effects
vars_interes = ['LINCOMEP','LRPMG','LCARPCAP']
mod_fe = PanelOLS(datos.LGASPCAR, datos[vars_interes], entity_effects=True)
res_fe = mod_fe.fit()
# Random effects
x_re = sm.add_constant(datos[vars_interes])
mod_re = RandomEffects(datos.LGASPCAR, x_re)
res_re = mod_re.fit()

b_fe = res_fe.params
b_re = res_re.params[vars_interes]
cov_fe = res_fe.cov
cov_re = res_re.cov.loc[vars_interes, vars_interes]
b_diff = b_fe - b_re
v_diff = cov_fe - cov_re
stat = b_diff.T @ np.linalg.inv(v_diff) @ b_diff
df = len(vars_interes)
p_value = 1 - stats.chi2.cdf(stat, df)
print(f'Chi-Cuadrado: {stat:.4f}')
print(f'p-valor: {p_value:.6f}')
#El test de hausman obtuvo un p-valor de 0. Esto significa que se prefiere el modelo de efectos fijos.

# Modelo dinamico autoregresivo
datos['LGASPCAR_lag'] = datos.groupby('COUNTRY')['LGASPCAR'].shift(1)
datos_reg = datos.dropna().copy()
y_lag = datos_reg['LGASPCAR']
vars_lag = ['LINCOMEP','LRPMG','LCARPCAP','LGASPCAR_lag']
x_lag = datos_reg[vars_lag]
x_lag = sm.add_constant(x_lag)
mod_lag = PanelOLS(y_lag, x_lag, entity_effects=True, time_effects=True)
res_lag = mod_lag.fit()
print(res_lag)

# Estimar elasticidades de largo plazo, contrastar por hipotesis nula que son 0:

# Elasticidad largo plazo del ingreso
beta_ingreso = res_lag.params['LINCOMEP']
coef_lag = res_lag.params['LGASPCAR_lag']
elasticidad_largo_plazo = beta_ingreso / (1 - coef_lag)
print(f"Elasticidad largo plazo: {elasticidad_largo_plazo}")
# Elasticidad largo plazo del precio
beta_precio = res_lag.params['LRPMG']
elasticidad_largo_plazo = beta_precio / (1 - coef_lag)
print(f"Elasticidad largo plazo: {elasticidad_largo_plazo}")
# Elasticidad largo plazo de autos per cápita
beta_autos = res_lag.params['LCARPCAP']
elasticidad_largo_plazo = beta_autos / (1 - coef_lag)
print(f"Elasticidad largo plazo: {elasticidad_largo_plazo}")

# Conclusión: Las elasticidades a largo plazo son distintas de cero, excepto la elasticidad del ingreso



"""
Pregunta 2: Efecto de la capacitacion en los salarios

Base de datos:
earnings      = ingresos acumulados en 30 meses;
jtpa offer    = dummy para la oferta de la capacitacion con JTPA;
jtpa training = dummy para los que efectivamente hicieron la capacitacion con JTPA;
sex           = dummy para sexo del individuo;
hsorged       = dummy para individuos con secundaria completa;
black         = dummy;
hispanic      = dummy;
married       = dummy;
wkless13      = dummy para individuos que trabajaron menos de 13 semanas el ultimo año;
age2225,age2629,age3035,age3644 y age4554 = dummies para rango de edad.
"""

jtpa = pd.read_stata(r"C:\Users\HP\Documents\Analisis de datos\Python\TP Econometria II\jtpa.dta")

# Modelo por niveles
y = jtpa['income']
x = jtpa[['treatment','male','hsorged','black','hispanic','married','wkless13','age2225','age2629','age3035','age3644','age4554']]
x = sm.add_constant(x)
model = sm.OLS(y, x).fit()
print(model.summary())

# Modelo logaritmico
jtpa['lincome'] = np.log(jtpa['income'])
ly = jtpa['lincome']
modell = sm.OLS(ly, x).fit()
print(modell.summary())

# Estimo el efecto causal promedio del tratamiento utilizando Propensity Score Matching (PSM).
# Propensity Score Matching es una técnica que busca comparar tratados y no tratados que sean similares en sus características observables (los controles),
# para aproximar un experimento aleatorizado y estimar el efecto del tratamiento.
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

# Posible endogeneidad del programa debido a que la variable treatment no es completamente aleatoria, 
# lo que significa que la decisión de participar puede estar relacionada con características no observadas del individuo y a su vez afectar al ingreso.
# Esto da lugar al "sesgo por selección" (un caso particular de sesgo por variable omitida).

# Modelo con varible instrumental
jtpa = sm.add_constant(jtpa)
ins = IV2SLS(jtpa['income'], jtpa[['const','male','hsorged','black','hispanic','married','wkless13','age2225','age2629','age3035','age3644','age4554']], jtpa['treatment'], jtpa['instrument'])
reg_ins = ins.fit()
print(reg_ins)

lins = IV2SLS(jtpa['lincome'], jtpa[['const','male','hsorged','black','hispanic','married','wkless13','age2225','age2629','age3035','age3644','age4554']], jtpa['treatment'], jtpa['instrument'])
reg_lins = lins.fit()
print(reg_lins)

# Interpretación de coeficiente de tratamiento:

"""
Modelo en niveles:
Para los compliers (aquellos individuos a los que la participación efectiva cambia de 0 a 1 gracias a la oferta aleatoria), 
recibir la capacitación del programa (treatment = 1) aumenta en promedio el ingreso acumulado en 30 meses en $1,730 dólares, 
en comparación con no recibirla y manteniendo constantes las demás características individuales (sexo, educación, raza, estado civil, historial laboral y edad). 
Este efecto es estadísticamente significativo al 1% (p < 0.01).

Modelo logaritmico:
Para los compliers, recibir la capacitación del programa aumenta en promedio el ingreso acumulado en 30 meses en aproximadamente 11,7%, 
en comparación con no recibirla y manteniendo constantes las demás características individuales (sexo, educación, raza, estado civil, historial laboral y edad). 
Este efecto es estadísticamente significativo al 5% (p < 0.05).
"""
