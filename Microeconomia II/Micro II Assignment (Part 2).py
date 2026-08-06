# Micro II Assignment – ​​Data analysis
import matplotlib.pyplot as plt
import pandas as pd

path = r"."  # Put the path here <----




# 5) Consumption and income patterns. Using data from the ENGHO survey conducted by INDEC,
# Aim to classify goods as normal, superior, or inferior.

data = pd.read_csv(f"{path}\engho-divisiones.csv")  

# Display the first 5 observations using the "head" function and the last 5 observations using the "tail" function
print(data.head())
print("_________________________________________________________________________")
print(data.tail())
print("_________________________________________________________________________")

# Count the number of observations for each "count" variable
data.count()

# To refer to a variable in the dataframe, we use brackets and single quotes; for example, 
# we want to describe the 'alimentos' variable using the "describe" function.
data['alimentos'].describe()

# We can also view specific rows (observations) to see the observations corresponding to indices 40 through 45
print(data[40:46])
print("_________________________________________________________________________")

# To view the observations from the 1st to the 10th percentile, we use a conditional statement
print(data[data.percentil<=10])
print("_________________________________________________________________________")

# To view the observations from the 10th to the 15th percentile, we use a double conditional
print(data[(data.percentil>=10) & (data.percentil<=15)])

# We can create a new variable; in this case, we want to create a variable 
# indicating the share of the "food" division in total expenditure.
# We name the new variable shalimentos.
data['shalimentos']=data['alimentos']/data['gastototal']*100

# We want to visualize the new variable we created alongside the 'alimentos' variable.
# We ask it to show us the first and last five observations of those two variables and the percentile.
# IMPORTANT: Since we are using a list of variables, we need to use DOUBLE BRACKETS.
# The inner bracket indicates that we are dealing with a list (in this case, a list of variables).
print(data[['percentil','alimentos','shalimentos']].head())
print("_________________________________________________________________________")
print(data[['percentil','alimentos','shalimentos']].tail())

# Create the figure
fig, (ax1, ax2) = plt.subplots(nrows=1, ncols=2, figsize=(8,4))
data.plot.scatter(ax=ax1, x='percentil', y='alimentos')
ax1.set_title('Gasto en pesos')
ax1.set_ylabel('')
ax1.set_xlabel('percentil')

# The second graph is similar, with a different variable on the vertical ("y") axis
data.plot.scatter(ax=ax2, x='percentil', y='shalimentos')
ax2.set_title('Participación en gasto')
ax2.set_ylabel('')
ax2.set_xlabel('percentil')
fig.suptitle('Alimentos')
plt.show()

# It would be useful to add a linear prediction to the graph; there are several ways to do this, one of which is using the 
# seaborn library, which creates plots based on matplotlib. We will use the prefix "sns" to refer to seaborn functions.
import seaborn as sns

# We generate the plot again. We use the `sns.regplot` function (a plot with a regression line)
fig, (ax1, ax2) = plt.subplots(nrows=1, ncols=2, figsize=(8,4))
sns.regplot(ax=ax1, x="percentil", y="alimentos", data=data, ci=None, line_kws={"color":"tab:orange"})
ax1.set_title('Gasto en pesos')
ax1.set_ylabel('')
ax1.set_xlabel('percentil')
sns.regplot(ax=ax2, x="percentil", y="shalimentos", data=data, ci=None, line_kws={"color":"tab:orange"})
ax2.set_title('Participación en gasto')
ax2.set_ylabel('')
ax2.set_xlabel('percentil')
fig.suptitle('Alimentos')
plt.show()

# They are normal goods because expenditure on them increases while their share of total income decreases
print("---BIEN NORMAL---")



# 6) Using data from the Ministry of Production, we aim to characterize the number of companies by industry
dataemp=pd.read_csv(f"{path}\industrias.csv")

# Instead of the head() and tail() functions, we can directly print the first and last five observations
print(dataemp)
print("_________________________________________________________________________")

# Descriptive statistics
print(dataemp.describe())
print("_________________________________________________________________________")

# We see that the minimum number of companies is -99. This is because when a sector has 2 or fewer firms, information is withheld due to statistical confidentiality.
# We want to know how many such problematic cases there are (note that a double equals sign is used in the conditions or filters).
dataemp[dataemp["empresas"]==-99].empresas.describe()

# To avoid discarding those observations, we will assign them a value of 2 (the correct value is 2 or 1)
dataemp.empresas = dataemp.empresas.replace(-99,2)

# Let's check by running "describe" again
print(dataemp.describe())
print("_________________________________________________________________________")

# We are going to create a subset dataframe for December 2010 and December 2020. This involves a conditional 
# using "or" instead of "and"—meaning we retain observations that meet at least one of the two conditions.
datar=dataemp[(dataemp["fecha"]=='01/12/2010') | (dataemp["fecha"]=='01/12/2020')]
print(datar)

# To reformat, we use the "pivot" function. We generate a new dataframe, "dataf"
# We specify that the new rows (index) will be determined by the "clae6" indicator, that we want to create 
# columns based on the "fecha" variable, and that the values ​​are provided by the "empresa" variable.
# We reset the index using the "reset" function.
dataf = datar.pivot(index='clae6', columns='fecha', values='empresas').reset_index()
print(dataf)
print("_________________________________________________________________________")

# Now we are going to rename the date variables, assigning them the names dic2010 and dic2020.
# We use "inplace" to replace them within the dataframe instead of creating a new one.
dataf.rename(columns={'01/12/2010':'dic2010','01/12/2020':'dic2020'}, inplace=True)
print(dataf)

# Now that we have the years 2010 and 2020 defined as two variables, we can calculate descriptive statistics and 
# histograms for each year, and we can calculate the correlation and scatter plot between the two years.

# For the mean, median, and percentiles
print(dataf.describe())
dataf.quantile([0.1, 0.25, 0.5 ,0.75, 0.9])

# For the 2010 histogram
ax1 = dataf.dic2010.plot.hist(figsize=(2, 2))
plt.show()

# There are extreme (very high) values. We add a condition to plot only industries with fewer than 1,000 companies; 
# this allows us to better see the initial part of the distribution.
ax1 = dataf[dataf["dic2010"]<1000].dic2010.plot.hist(figsize=(2, 2))
plt.show()

# For the 2020 histogram
ax2 = dataf.dic2020.plot.hist(figsize=(2, 2))
plt.show()

# There are extreme (very high) values. We add a condition to plot only industries with fewer than 1,000 companies; 
# this allows us to better see the initial part of the distribution.
ax2 = dataf[dataf["dic2020"]<1000].dic2020.plot.hist(figsize=(2, 2))
plt.show()

# Correlation between the variables
print(dataf.corr())

# Plot the scatterplot with the 45-degree line.
x=[0,40000]
y=[0,40000]
fig, ax1= plt.subplots(figsize=(6,4))
dataf.plot.scatter(ax=ax1, x='dic2010', y='dic2020')
ax1.set_title('Scatterplot')
ax1.set_ylabel('numero de empresas en diciembre de 2020')
ax1.set_xlabel('numero de empresas en diciembre de 2010')
plt.plot(x, y, color='tab:orange')
plt.show()

# Average number of companies per year: We return to the original dataframe containing all observations, "dataemp".
# First, we retain only the observations corresponding to December; to do this, we use a condition: the date must start with "01/12".
# We create a subset dataframe based on this condition—specifically, that the first five characters of the column match "01/12".
# At the same time, we reindex.
datar=dataemp[dataemp['fecha'].str[:5]=="01/12"].reset_index()
print(datar)
print("_________________________________________________________________________")

# We need to calculate the mean of the "empresas" variable for different groups of observations; the groups are the different years (the "fecha" variable).
# We use the "groupby" function with the "mean" option, applying it to the "datar" dataframe.
# We create a new dataframe named "media anual".
mediaanual=datar.groupby('fecha')['empresas'].mean().reset_index()
print(mediaanual)

# Graph
ax1 = mediaanual.plot.scatter(figsize=(4,2), x='fecha', y='empresas')
ax1.set_ylabel('')
ax1.set_xlabel('')
plt.title('Número promedio de empresas')
plt.show()

# The horizontal axis is not legible. We create a new variable ("year") that indicates only the year; 
# to do this, we trim the first 6 characters, which correspond to "01/12/".
mediaanual['año']=mediaanual['fecha'].str[6:10]
print(mediaanual)

# Graph
ax1 = mediaanual.plot.scatter(figsize=(4, 2), x='año', y='empresas')
ax1.set_ylabel('')
ax1.set_xlabel('')
plt.title('Número promedio de empresas')
plt.show()

# The horizontal axis is not yet clearly legible. We specify which "ticks" we want displayed (we manually indicate the position)
ax1 = mediaanual.plot.scatter(figsize=(4, 2), x='año', y='empresas')
ax1.set_ylabel('')
ax1.set_xlabel('')
ax1.set_xticks([0,2,4,6,8,10,12])
plt.title('Número promedio de empresas')
plt.show()



# 7) Multinational companies engage in international price discrimination. 
# We compare the price of the Big Mac across countries and seek to determine whether it is correlated with per capita income.
bigmac = pd.read_csv(rf"{path}\bigmac.csv")
wdi = pd.read_csv(rf"{path}\wdi.csv")

# We looked at the Big Mac dataframe
print(bigmac)

# We apply a filter to retain only the observations corresponding to July 1, 2022
bigmac=bigmac[bigmac.date=='01/07/2020']

# We apply another filter to retain only the variables we need
bigmac=bigmac[['iso_a3','name','dollar_price']]
print(bigmac.head())

# We keep the columns we need
wdi=wdi[['Country Code','GDP per capita (constant 2015 US$) [NY.GDP.PCAP.KD]']]

# We rename the variable to use a shorter name
wdi.rename(columns={'GDP per capita (constant 2015 US$) [NY.GDP.PCAP.KD]':'pbi-pc'},inplace=True)
print(wdi.head())

# We need to merge the two dataframes so that the two columns—Big Mac price and GDP per capita—are aligned.
# We create a new dataframe named "data1" using the "merge" function.
# The merge is performed based on the observations sharing the same ISO code that identifies the countries.
# This variable is named "iso_a3" in the Big Mac dataset and "Country Code" in the WDI dataset.
data1=bigmac.merge(wdi,left_on='iso_a3',right_on='Country Code')
print(data1.head())

# For the mean, median (50%), and standard deviation (std)
print(bigmac.describe())

# For the big mac histogram
ax1 = bigmac.dollar_price.plot.hist(figsize=(4, 3))
plt.show()

# Correlation between the two variables
correlation = data1['pbi-pc'].corr(data1['dollar_price'])
print("Correlacion:")
print(correlation)

# Plot the scatterplot
fig, ax1= plt.subplots(figsize=(6,4))
data1.plot.scatter(ax=ax1, x='pbi-pc', y='dollar_price')
ax1.set_title('Scatterplot')
ax1.set_ylabel('Precio del big mac')
ax1.set_xlabel('PBI-pc')
plt.show()
