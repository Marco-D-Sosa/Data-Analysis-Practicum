# Micro II Assignment – ​​Graphs
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import root



# 1) Plot the demand for good 1 as a function of its own price.
# Create a second graph showing how the demand function shifts if income increases by 25%.

# Parameters
alpha1 = 0.4
alpha2 = 0.6

# Demand
def demand(p1,p2,m):
    return alpha1/(alpha1+alpha2)*m/p1
print("Quantity demanded:", demand(2,4,1000))

# Vectors
vectorp=np.linspace(1,5,39)
print(vectorp)
vectorx1=demand(vectorp,4,1000)
print(vectorx1)

# Graph of the demand for good 1 as a function of its own price.
fig, ax1 = plt.subplots(figsize=(4, 3))
ax1.plot(vectorx1,vectorp, label='m')
ax1.set_ylabel('price')
ax1.set_xlabel('quantity')
plt.title('Cobb-Douglas Demand')
plt.legend()
plt.show()

# 25% increase
vectorx1b=demand(vectorp,4,1000*1.25)
fig, ax1 = plt.subplots(figsize=(4, 3))
ax1.plot(vectorx1,vectorp, label='m')
ax1.plot(vectorx1b,vectorp, label='m*1.25')
ax1.set_ylabel('price')
ax1.set_xlabel('quantity')
plt.title('Cobb-Douglas Demand')
plt.legend()
plt.show()



# 2) Graph the average cost and marginal cost as a function of quantity Q.
# Add the market price, the optimal quantity, and the area representing profits to the graph.
# Determine whether the benefits are positive or negative.

# Parameters
F=10
a=1
p=10

# Functions
def cost(q):
    return F + a*q**2
def mc(q):
    return 2*a*q
def atc(q):
    return F/q + a*q
def qoptimal(p):
    return p/(2*a)
def profit(p):
    qaux=qoptimal(p)
    return p*qaux - cost(qaux)
q1=qoptimal(p)
profit1=profit(p)

# Answers
print('values ​​of parameters and exogenous variables:')
print('F=',F)
print('a=',a)
print('p=',p)
print ('Solution:')
print('q=',q1 )
print('profit=',profit1 )
if profit1>0: print('the benefit is greater than 0')
if profit1==0: print('the profit equals 0')
if profit1<0: print('the profit is less than 0')

# Vectors
vectorq=np.linspace(1,7,25)

# Graph
fig, ax1 = plt.subplots(figsize=(4, 3))
ax1.plot(vectorq,mc(vectorq), linewidth=2, color="tab:blue",label="mc")
ax1.plot(vectorq,atc(vectorq), linewidth=2, color="tab:red",label="atc")
ax1.plot((0,7),(p,p), linewidth=2, color="tab:orange", label="p")
ax1.plot((q1,q1),(0,p), linewidth=2, linestyle="dotted", color="tab:blue", label="p")
ax1.fill_between((0,q1), (p,p), (mc(q1),atc(q1)), alpha=0.3 , color='orange')
ax1.set_xlabel('q')
ax1.set_ylabel('p')
plt.legend()
plt.show()



# 3) Three-dimensional graph of a Cobb-Douglas production function.
# Comment on the returns to scale and whether the marginal products of the factors are increasing or decreasing.

# Parameters
A = 1
alpha = 0.5
beta = 0.5

# Production function
def f(L,K):
    return A*(L**alpha)*(K**beta)

# Create an empty figure and specify that the axes are 3D
fig = plt.figure(figsize=(6,4))
ax1 = plt.axes(projection='3d')

# Create vectors L and K using the "arange" command. We specify the start value, the end value, 
# and the step size; the values ​​range from 0.1 to 0.9 (excluding 1)
vectorL=np.arange(0.1,1,0.1)
vectorK=np.arange(0.1,1,0.1)
print("Vector L:")
print(vectorL)
print("Vector K:")
print(vectorK)
print("__________________________")

# Use the meshgrid command to generate combinations of L and K
matL,matK=np.meshgrid(vectorL,vectorK)
print("Matrix of values ​​of L:")
print(matL)
print("__________________________")
print("Matrix of values of K:")
print(matK)
print("__________________________")

# Now we can use the combinations to evaluate the values ​​of q
matq=f(matL,matK)
print("Matrix of values of q")
print(matq)

# Let's plot it. We will place the plot inside a function; the function 
# has no exogenous variables, so we leave the parentheses empty.
# The type of chart we need is called "surface". We use the "view_init" option 
# to rotate the chart and choose the viewing perspective.
def graph():
    fig = plt.figure(figsize=(6,4))
    ax1 = plt.axes(projection='3d')
    ax1.plot_surface(matL,matK,matq)
    ax1.set_title('alpha=' + str(alpha) + ' beta=' + str(beta))
    ax1.view_init(10, -30)
    plt.show()
    return

# Created a function that generates comments about technology
def comments():
    h=alpha+beta
    if h==1:
        a="constants"
    if h<1:
        a="decreasing"
    if h>1:
        a="increasing"
    if alpha==1:
        b="constant"
    if alpha<1:
        b="decreasing"
    if alpha>1:
        b="increacing"
    print('--------------------------------------------------')
    print('The production function is homogeneous of degree', h)
    print('Returns to scale are', a)
    print('The marginal product of labor is', b)
    print('--------------------------------------------------')
    return

# Execute
graph()
comments()



# 4) Graph of the contract curve and the PPF.
# In a production equilibrium model with two goods and two factors, the production technology in each sector is:
# Q1 = L^alphaL * K^alphaK y Q2 = L^betaL * K^betaK. 
# Briefly comment on whether the PPF is linear or concave and whether the contract curve coincides with the diagonal of the box.

# L and K allocations
L=2000
K=1000

# Coefficients
alphaL1=0.5
alphaK1=0.5
alphaL2=0.5
alphaK2=0.5

# Production functions
def f1(L1,K1):
    return L1**alphaL1*K1**alphaK1
def f2(L2,K2):
    return L2**alphaL2*K2**alphaK2

# Marginal rates of substitution (MRS)
def mrs1(L1,K1):
    return (alphaL1/alphaK1)/(L1/K1)
def mrs2(L2,K2):
    return (alphaL2/alphaK2)/(L2/K2)

# System of equations: Maximization of the production of good 1 subject to an arbitrary production level of good 2
def sistem1(assignment,x2):
    L1=assignment[0]
    K1=assignment[1]
    return [mrs1(L1,K1)-mrs2(L-L1,K-K1),f2(L-L1,K-K1)-x2]

# PPF limits (the maximum that can be produced if 0 of the other good is produced)
m1=f1(L,K)
m2=f2(L,K)

# Create a vector x2 that takes values ​​between 1 and the maximum value (-1).
# Note that the MRS is undefined if the quantity of a good is zero; that is why we start at 1 and end at m2–1
# (instead of starting at 0 and ending at m2)
increase=1
x2=np.arange(1,m2-1,increase)
aux=np.shape(x2)
size=aux[0]

# Initialize vectors x1, L1, K1, L2, and K2 with a zero, then fill them in using a loop
L1=[]
K1=[]
L2=[]
K2=[]
x1=[]

# Initial guess for the L1 and K1 solution. We use it for the first evaluation of the loop
assignmentinitial=[L-1,K-1]

# Find the solution for a range of ARBITRARY values ​​of x2
for i in range(0,size,1):
    solution1=root(sistem1, assignmentinitial, args=(x2[i]), tol=0.00000001)
    assignment=solution1.x
    L1.append(assignment[0])
    K1.append(assignment[1])
    x1.append(f1(L1[i],K1[i]))
    L2.append(L-L1[i])
    K2.append(K-K1[i])

# The solution serves as the initial value for the next iteration
assignmentinitial=solution1.x

# Graphs
fig, (ax1,ax2) = plt.subplots(1, 2, figsize=[6,2.5])

# PPF graph
ax1.plot(x1, x2, linewidth=3, color="tab:blue")
ax1.set_xlim([0,m1])
ax1.set_ylim([0,m2])
ax1.set_xlabel('x1')
ax1.set_ylabel('x2')
ax1.set_xticks([])
ax1.set_yticks([])
ax1.set_title('PPF', fontsize=15)

# Contract Curve Graph
ax2.plot(L1, K1, linewidth=3, color="tab:orange")
ax2.set_xlim([0,L])
ax2.set_ylim([0,K])
ax2.set_xlabel('L1')
ax2.set_ylabel('K1')
ax2.set_xticks([])
ax2.set_yticks([])

ax2.set_title('Contract Curve', fontsize=15)
plt.figtext(0.01, -0.1, fr'$\alpha L1={alphaL1:.2f} , \alpha K1={alphaK1:.2f}$, $\alpha L2={alphaL2:.2f} , \alpha K2={alphaK2:.2f}$' , fontsize=14)
plt.show()
