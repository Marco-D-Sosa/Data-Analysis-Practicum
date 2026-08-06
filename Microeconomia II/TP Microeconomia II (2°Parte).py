# TP Micro II - Analisis de datos

# Importamos las librerías habituales numpy y pyplot e importamos también la librería pandas para crear dataframes. 
# Las funciones de pandas van a comenzar con el prefijo "pd"
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd



# 5) Patrones de consumo e ingreso. Utilizando datos de la ENGHO realizada por el INDEC 
# Buscamos caracterizar bienes como normales, superiores o inferiores.

# Necesitamos que el programa lea el archivo "engho-divisiones.csv", como leer datos es una función de pandas usamos el prefijo "pd"
# Para indicarle que lea usamos la función "read" le indicamos también que el formato original de los datos es "csv" y le pedimos que al dataframe que genera lo llame "datos"
datos = pd.read_csv(r"C:\Users\HP\Documents\Python\TP Micro II\data\engho-divisiones.csv")

# Podemos visualizar las primeras 5 observaciones utilizando la función "head" y las últimas 5 observaciones utilizando la función "tail"
print(datos.head())
print("_________________________________________________________________________")
print(datos.tail())
print("_________________________________________________________________________")

# Le pedimos que cuente el número de observaciones de cada variable "count"
datos.count()

# Para referirnos a una variable del dataframe usamos corchetes y comillas simples
# por ejemplo, queremos describir la variable alimentos usando la función "describe"
datos['alimentos'].describe()

# También podemos visualizar algunas filas (observaciones) en particular para ver las observaciones que corresponden a los índices 40 a 45
print(datos[40:46])
print("_________________________________________________________________________")

# Para ver las observaciones del percentil 1 al 10 utilizamos un condicional
print(datos[datos.percentil<=10])
print("_________________________________________________________________________")

# Para ver las observaciones del percentil 10 al 15 utilizamos un doble condicional
print(datos[(datos.percentil>=10) & (datos.percentil<=15)])

# Podemos crear una variable nueva, en este caso nos interesa crear una variable que indique la participación de la división "alimentos" en el gasto total
# A la nueva variable la llamamos shalimentos
datos['shalimentos']=datos['alimentos']/datos['gastototal']*100

# Queremos visualizar la nueva variable que creamos junto a la variable alimentos
# Le pedimos que nos muestres las primeras y últimas cinco observaciones de esas dos variables y del percentil
# IMPORTANTE: como estamos utilizando una lista de variables necesitamos utilizar DOBLE CORCHETE. El corchete de adentro indica que estamos en presencia de una lista (en este caso lista de variables)
print(datos[['percentil','alimentos','shalimentos']].head())
print("_________________________________________________________________________")
print(datos[['percentil','alimentos','shalimentos']].tail())

# Al crear la figura indicamos que el numero de filas (nrows) es 1 y el número de columnas (ncols) es 2
fig, (ax1, ax2) = plt.subplots(nrows=1, ncols=2, figsize=(8,4))

# Le indicamos que estamos usando el data frame "datos" al comienzo del comando y también le indicamos que el gráfico es una nube de puntos ("scatter")
# Le indicamos qué variable va en el eje horizontal ("x") y qué variables en el eje vertical ("y")
datos.plot.scatter(ax=ax1, x='percentil', y='alimentos')
ax1.set_title('Gasto en pesos')
ax1.set_ylabel('')
ax1.set_xlabel('percentil')

# El segundo gráfico es similar, con diferente variable en el eje vertical ("y")
datos.plot.scatter(ax=ax2, x='percentil', y='shalimentos')
ax2.set_title('Participación en gasto')
ax2.set_ylabel('')
ax2.set_xlabel('percentil')
fig.suptitle('Alimentos')
plt.show()

# Sería útil agregarle al gráfico una predicción lineal, hay varias formas de hacerlo, una de ellas es utilizando la librería seaborn que hace gráficos basados en matplotlib
# Vamos a utilizar el prefijo "sns" para referirnos a funciones de seaborn
import seaborn as sns

# Realizamos el gráfico nuevamente. Utilizamos la función sns.regplot (es un plot con recta de regresión)
fig, (ax1, ax2) = plt.subplots(nrows=1, ncols=2, figsize=(8,4))
sns.regplot(ax=ax1, x="percentil", y="alimentos", data=datos, ci=None, line_kws={"color":"tab:orange"})
ax1.set_title('Gasto en pesos')
ax1.set_ylabel('')
ax1.set_xlabel('percentil')
sns.regplot(ax=ax2, x="percentil", y="shalimentos", data=datos, ci=None, line_kws={"color":"tab:orange"})
ax2.set_title('Participación en gasto')
ax2.set_ylabel('')
ax2.set_xlabel('percentil')
fig.suptitle('Alimentos')
plt.show()

# Por tener gasto creciente y participacion del gasto decreciente en el ingreso son bienes normales
print("---BIEN NORMAL---")



# 6) Utilizando datos del Ministerio de la produccion buscamos caracterizar el numero de empresas por industria
dataemp=pd.read_csv(r"C:\Users\HP\Documents\Python\TP Micro II\data\industrias.csv")

# En lugar de las funciones head() y tail() podemos imprimir directamente las primeras y últimas cinco observaciones
print(dataemp)
print("_________________________________________________________________________")

# Estadísticos descriptivos
print(dataemp.describe())
print("_________________________________________________________________________")

# Vemos que el número mínimo de empresas es -99. Esto se debe a que cuando un sector tiene 2 o menos firmas, no hay información por secreto estadístico
# Queremos saber cuántos son estos casos problemáticos (notar que en las condiciones o filtros se usa doble signo igual)
dataemp[dataemp["empresas"]==-99].empresas.describe()

# Para no tirar esas observaciones vamos a asignarles un valor de 2 (El valor correcto es 2 o 1)
dataemp.empresas = dataemp.empresas.replace(-99,2)

# Chequamos haciendo nuevamente "describe"
print(dataemp.describe())
print("_________________________________________________________________________")

# Vamos a crear un dataframe reducido para diciembre de 2010 y diciembre de 2020. Es un condicional en donde usamos "or" en lugar de "and"
# es decir, que nos quedamos con las observaciones que cumplen con al menos una de las dos condiciones
datar=dataemp[(dataemp["fecha"]=='01/12/2010') | (dataemp["fecha"]=='01/12/2020')]
print(datar)

# Para reformatear utilizamos la función "pivot". Generamos un nuevo dataframe "dataf"
# Le indicamos que las nuevas filas (index) van a estar dadas por el indicador "clae6", que queremos crear columnas (columns) a partir de la variable "fecha" y que los valores (values) están dados por la variable "empresa"
# Reseteamos el índice usando la función "reset"
dataf = datar.pivot(index='clae6', columns='fecha', values='empresas').reset_index()
print(dataf)
print("_________________________________________________________________________")

# Ahora vamos a renombrar las variables de fecha, les vamos a poner los nombres dic2010 y dic2020
# Usamos "inplace" para que reemplace en el dataframe en lugar de crear uno nuevo
dataf.rename(columns={'01/12/2010':'dic2010','01/12/2020':'dic2020'}, inplace=True)
print(dataf)

# Ahora tenemos los años 2010 y 2020 definidos como dos variables podemos calcular estadísticos descriptivos e histogramas para cada año y podemos calcular la correlación y nube de puntos entre los dos años

# Para la media, mediana y percentiles
print(dataf.describe())
dataf.quantile([0.1, 0.25, 0.5 ,0.75, 0.9])

# Para el histograma de 2010
ax1 = dataf.dic2010.plot.hist(figsize=(2, 2))
plt.show()

# Hay valores extremos (muy altos). 
# Agregamos un condicional para que solamente grafique las industrias con menos de 1000 empresas, eso nos permite ver mejor la parte inicial de la distribución
ax1 = dataf[dataf["dic2010"]<1000].dic2010.plot.hist(figsize=(2, 2))
plt.show()

# Para el histograma de 2020
ax2 = dataf.dic2020.plot.hist(figsize=(2, 2))
plt.show()

# Hay valores extremos (muy altos)
# Agregamos un condicional para que solamente grafique las industrias con menos de 1000 empresas, eso nos permite ver mejor la parte inicial de la distribucion
ax2 = dataf[dataf["dic2020"]<1000].dic2020.plot.hist(figsize=(2, 2))
plt.show()

# Correlacion entre las variables
print(dataf.corr())

# Grafico el scatterplot con la recta de 45°
x=[0,40000]
y=[0,40000]
fig, ax1= plt.subplots(figsize=(6,4))
dataf.plot.scatter(ax=ax1, x='dic2010', y='dic2020')
ax1.set_title('Scatterplot')
ax1.set_ylabel('numero de empresas en diciembre de 2020')
ax1.set_xlabel('numero de empresas en diciembre de 2010')
plt.plot(x, y, color='tab:orange')
plt.show()

# Media del número de empresas por año: Volvemos al dataframe original con todas las observaciones "dataemp"
# Primero nos vamos a quedar solamente con las observaciones que corresponden a diciembre, para eso utilizamos un condicional: que la fecha empiece con "01/12"
# Generamos un dataframe reducido en base a esa condición, la condición es que los cinco primeros caracteres de la columna sean iguales a "01/12"
# Simultáneamente reindexamos
datar=dataemp[dataemp['fecha'].str[:5]=="01/12"].reset_index()
print(datar)
print("_________________________________________________________________________")

# Necesitamos calcular la media de la variable "empresas" para distintos grupos de observaciones, los grupos son los distintos años (variable "fecha")
# Utilizamos la función "groupby" (agrupar) con la opción "mean" (media), a esa función la aplicamos al dataframe "datar"
# Generamos un dataframe nuevo que llamamos "media anual"
mediaanual=datar.groupby('fecha')['empresas'].mean().reset_index()
print(mediaanual)

# Graficamos
ax1 = mediaanual.plot.scatter(figsize=(4,2), x='fecha', y='empresas')
ax1.set_ylabel('')
ax1.set_xlabel('')
plt.title('Número promedio de empresas')
plt.show()

# El eje horizontal no sale legible
# Creamos una nueva variable ("año") que solamente indique el año, para eso recortamos los 6 primeros caracteres, que corresponden a "01/12/"
mediaanual['año']=mediaanual['fecha'].str[6:10]
print(mediaanual)

# Graficamos
ax1 = mediaanual.plot.scatter(figsize=(4, 2), x='año', y='empresas')
ax1.set_ylabel('')
ax1.set_xlabel('')
plt.title('Número promedio de empresas')
plt.show()

# Todavía no está bien legible el eje horizontal
# Le indicamos qué "ticks" queremos que ponga (indicamos manualmente la posición)
ax1 = mediaanual.plot.scatter(figsize=(4, 2), x='año', y='empresas')
ax1.set_ylabel('')
ax1.set_xlabel('')
ax1.set_xticks([0,2,4,6,8,10,12])
plt.title('Número promedio de empresas')
plt.show()



# 7) Las empresas multinacionales discriminan precios internacionalmente. 
# Comparamos el precio del BIG MAC entre paıses y buscamos establecer si esta correlacionado con el ingreso per capita.

# Tenemos dos bases de datos para cargar: bigmac y wdi. Vamos a generar dos dataframes
bigmac=pd.read_csv(r"C:\Users\HP\Documents\Python\TP Micro II\data\bigmac.csv")
wdi=pd.read_csv(r"C:\Users\HP\Documents\Python\TP Micro II\data\wdi.csv")

# Miramos el dataframe de big mac
print(bigmac)

# Aplicamos un filtro para quedarnos solamente con las observaciones correspondientes a 1/7/2022
bigmac=bigmac[bigmac.date=='01/07/2020']

# Aplicamos otro filtro para quedarnos solamente con las variables que necesitamos
bigmac=bigmac[['iso_a3','name','dollar_price']]
print(bigmac.head())

#Nos quedamos con las columnas que necesitamos
wdi=wdi[['Country Code','GDP per capita (constant 2015 US$) [NY.GDP.PCAP.KD]']]

#Renombramos la variable para usar un nombre más corto
wdi.rename(columns={'GDP per capita (constant 2015 US$) [NY.GDP.PCAP.KD]':'pbi-pc'},inplace=True)
print(wdi.head())

# Necesitamos unir los dos dataframes, de manera de tener a la par las dos columnas:
# La de precio del big mac y la de PBI-pc
# Creamos un nuevo dataframe llamado data1 usando la función "merge"
# La unión se realiza a partir de que las observaciones tengan el mismo código ISO que identifica a los países
# Esa variable se llama "iso_a3" en la base de big mac y se llama "Country Code" en la base de WDI
data1=bigmac.merge(wdi,left_on='iso_a3',right_on='Country Code')
print(data1.head())

# Para la media (mean), mediana (50%) y desvio (std)
print(bigmac.describe())

# Para el histograma de big mac
ax1 = bigmac.dollar_price.plot.hist(figsize=(4, 3))
plt.show()

# Correlacion entre ambas variables
correlation = data1['pbi-pc'].corr(data1['dollar_price'])
print("Correlacion:")
print(correlation)

# Grafico el scatterplot
fig, ax1= plt.subplots(figsize=(6,4))
data1.plot.scatter(ax=ax1, x='pbi-pc', y='dollar_price')
ax1.set_title('Scatterplot')
ax1.set_ylabel('Precio del big mac')
ax1.set_xlabel('PBI-pc')
plt.show()

