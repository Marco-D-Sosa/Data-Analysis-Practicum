# TP Micro II - Graficos

#Librerias:
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d
from scipy.optimize import root


# 1) Graficar la demanda del bien 1 en funcion de su propio precio. 
# Realizar un segundo grafico en donde se muestre como se desplaza la funcion de demanda si el ingreso aumenta en un 25%.

#Parametros
alfa1 = 0.4
alfa2 = 0.6

#Demanda
def demanda(p1,p2,m):
    return alfa1/(alfa1+alfa2)*m/p1
print("Cantidad demandada:", demanda(2,4,1000))

#Vectores
vectorp=np.linspace(1,5,39)
print(vectorp)
vectorx1=demanda(vectorp,4,1000)
print(vectorx1)

#Grafico de la demanda del bien 1 en funcion de su propio precio
fig, ax1 = plt.subplots(figsize=(4, 3))
ax1.plot(vectorx1,vectorp, label='m')
ax1.set_ylabel('precio')
ax1.set_xlabel('cantidad')
plt.title('Demanda Cobb-Douglas')
plt.legend()
plt.show()

#Incremento del 25%
vectorx1b=demanda(vectorp,4,1000*1.25)
fig, ax1 = plt.subplots(figsize=(4, 3))
ax1.plot(vectorx1,vectorp, label='m')
ax1.plot(vectorx1b,vectorp, label='m*1.25')
ax1.set_ylabel('precio')
ax1.set_xlabel('cantidad')
plt.title('Demanda Cobb-Douglas')
plt.legend()
plt.show()



# 2) Graficar el costo medio y costo marginal en funcion de la cantidad Q.
# Agregar al grafico el precio de mercado, la cantidad optima, y el area que representa los beneficios.
# Determinar si los beneficios son positivos o negativos.

#Parametros
F=10
a=1
p=10

#Funciones
def costo(q):
    return F + a*q**2
def cmg(q):
    return 2*a*q
def cme(q):
    return F/q + a*q
def qóptima(p):
    return p/(2*a)
def beneficio(p):
    qaux=qóptima(p)
    return p*qaux - costo(qaux)
q1=qóptima(p)
beneficio1=beneficio(p)

#Respuestas
print('valores de los parametros y variables exógenas:')
print('F=',F)
print('a=',a)
print('p=',p)
print ('Solución:')
print('q=',q1 )
print('beneficio=',beneficio1 )
if beneficio1>0: print('el beneficio es mayor a 0')
if beneficio1==0: print('el beneficio es menor a 0')
if beneficio1<0: print('el beneficio es menor a 0')

#vectores
vectorq=np.linspace(1,7,25)

#Gráfico
fig, ax1 = plt.subplots(figsize=(4, 3))
ax1.plot(vectorq,cmg(vectorq), linewidth=2, color="tab:blue",label="cmg")
ax1.plot(vectorq,cme(vectorq), linewidth=2, color="tab:red",label="cme")
ax1.plot((0,7),(p,p), linewidth=2, color="tab:orange", label="p")
ax1.plot((q1,q1),(0,p), linewidth=2, linestyle="dotted", color="tab:blue", label="p")
ax1.fill_between((0,q1), (p,p), (cme(q1),cme(q1)), alpha=0.3 , color='orange')
ax1.set_xlabel('q')
ax1.set_ylabel('p')
plt.legend()
plt.show()



# 3) Grafico tridimensional de una funcion de produccion Cobb-Douglas. 
# Comentar como son los rendimientos a escala y si los productos marginales de los factores son crecientes o decrecientes.

# Parámetros
A = 1
alpha = 0.5
beta = 0.5

# Función de producción
def f(L,K):
    return A*(L**alpha)*(K**beta)

# Creamos una figura vacía y le indicamos que los ejes son 3d
fig = plt.figure(figsize=(6,4))
ax1 = plt.axes(projection='3d')

# Creamos vectores de L y K usando el comando "arange". Le damos el primer valor, el último valor, y la separación entre valores
# los valores van desde 0.1 a 0.9 (excluye el 1)
vectorL=np.arange(0.1,1,0.1)
vectorK=np.arange(0.1,1,0.1)
print("Vector L:")
print(vectorL)
print("Vector K:")
print(vectorK)
print("__________________________")

# Usamos el comando meshgrid para generar combinaciones de L y K
matL,matK=np.meshgrid(vectorL,vectorK)
print("Matriz de valores de L:")
print(matL)
print("__________________________")
print("Matriz de valores de K:")
print(matK)
print("__________________________")

# Ahora podemos usar las combinaciones para evaluar los valores de q
matq=f(matL,matK)
print("Matriz de valores de q")
print(matq)

# Graficamos. Vamos a poner el gráfico dentro de una función, la función no tiene variables exógenas por lo tanto dejamos vacíos los paréntesis
# El tipo de gráfico que necesitamos se llama "surface". Usamos la opción "view_init" para rotar el gráfico y elegir desde qué perspectiva verlo
def graficar():
    fig = plt.figure(figsize=(6,4))
    ax1 = plt.axes(projection='3d')
    ax1.plot_surface(matL,matK,matq)
    ax1.set_title('alpha=' + str(alpha) + ' beta=' + str(beta))
    ax1.view_init(10, -30)
    plt.show()

# Creamos una función que genera comentarios sobre la tecnología
def comentarios():
    h=alpha+beta
    if h==1:
        a="constantes"
    if h<1:
        a="decrecientes"
    if h>1:
        a="crecientes"
    if alpha==1:
        b="constante"
    if alpha<1:
        b="decreciente"
    if alpha>1:
        b="crecientes"
        print('--------------------------------------------------')
        print('La función de producción es homogénea de grado', h)
        print('Los rendimientos a escala son', a)
        print('El producto marginal del trabajo es', b)
        print('--------------------------------------------------')
        return
    
# Ejecutamos
graficar()
comentarios()



# 4) Grafico de la curva de contrato y de la FPP. 
# En un modelo de equilibrio en la produccion con 2 bienes y 2 factores, la tecnologıa de produccion en cada sector es: Q1 = L^alphaL * K^alphaK y Q2 = L^betaL * K^betaK. 
# Comentar brevemente si la FPP es lineal o concava y si la curva de contrato coincide con la diagonal de la caja.

# Dotaciones de L y K
L=2000
K=1000

# Coeficientes
alphaL1=0.5
alphaK1=0.5
alphaL2=0.5
alphaK2=0.5

# Funciones de producción
def f1(L1,K1):
    return L1**alphaL1*K1**alphaK1
def f2(L2,K2):
    return L2**alphaL2*K2**alphaK2

# Tasas marginales de sustitución (TMS)
def tms1(L1,K1):
    return (alphaL1/alphaK1)/(L1/K1)
def tms2(L2,K2):
    return (alphaL2/alphaK2)/(L2/K2)

# Sistema de ecuaciones: Maximización de la produccion del bien 1 sujeta a una producción arbitraria del bien 2
def sistema1(asignacion,x2):
    L1=asignacion[0]
    K1=asignacion[1]
    return [tms1(L1,K1)-tms2(L-L1,K-K1),f2(L-L1,K-K1)-x2]

# Límites de la FPP (el máximo que se puede producir si se produce 0 del otro bien)
m1=f1(L,K)
m2=f2(L,K)

# Creamos un vector x2 que toma valores entre 1 y el valor máximo (pero -1)
# Ver que la TMS NO está definida si un bien es cero, por eso empezamos en 1 y terminamos en m2-1 (en lugar de empezar en 0 y terminar en m2)
incremento=1
x2=np.arange(1,m2-1,incremento)
aux=np.shape(x2)
size=aux[0]

# Inicializamos vectores x1, L1, K1, L2 y K2 con un cero, luego lo vamos a completar con un loop
L1=[]
K1=[]
L2=[]
K2=[]
x1=[]

# "Guess" inicial para la solución de L1 y K1.  La utilizamos para la primera evaluación del loop
asignacioninicial=[L-1,K-1]

# Encontramos la solución para un rango de valores ARBITRARIOS de x2
for i in range(0,size,1):
    solucion1=root(sistema1, asignacioninicial, args=(x2[i]), tol=0.00000001)
    asignacion=solucion1.x
    L1.append(asignacion[0])
    K1.append(asignacion[1])
    x1.append(f1(L1[i],K1[i]))
    L2.append(L-L1[i])
    K2.append(K-K1[i])

# La solución nos sirve como valor inicial para la siguiente ITERACIÓN
asignacioninicial=solucion1.x

# Gráficos
fig, (ax1,ax2) = plt.subplots(1, 2, figsize=[6,2.5])

# Gráfico de la FPP
ax1.plot(x1, x2, linewidth=3, color="tab:blue")
ax1.set_xlim([0,m1])
ax1.set_ylim([0,m2])
ax1.set_xlabel('x1')
ax1.set_ylabel('x2')
ax1.set_xticks([])
ax1.set_yticks([])
ax1.set_title('FPP', fontsize=15)

# Gráfico de la CURVA DE CONTRATO
ax2.plot(L1, K1, linewidth=3, color="tab:orange")
ax2.set_xlim([0,L])
ax2.set_ylim([0,K])
ax2.set_xlabel('L1')
ax2.set_ylabel('K1')
ax2.set_xticks([])
ax2.set_yticks([])

ax2.set_title('Curva de Contrato', fontsize=15)
plt.figtext(0.01, -0.1, fr'$\alpha L1={alphaL1:.2f} , \alpha K1={alphaK1:.2f}$, $\alpha L2={alphaL2:.2f} , \alpha K2={alphaK2:.2f}$' , fontsize=14)
plt.show()
