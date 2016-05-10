import math
import csv

#Modelo PV caso sin resistencia en serie 
Lambda=0.5  #Teoricamente deberia ser Ig+Is, pero como Is<<Ig suponemos que es Ig   
Psi=1.35e-7 #Is
alpha=0.026 #1/(n*Vt)
V_oc=1/alpha*(math.log(Lambda/Psi))
V_mpp=572
I_mpp=5.72
P_mpp=3267
y=math.log(Lambda)
b=math.log(Psi)
Rp=100
e=math.exp(1)

# Create the time samples for the output of the ODE solver.
stoptime = 0.005
numpoints = 1000#00
t = [stoptime * int(j) / (numpoints - 1) for j in range(numpoints)]

Vpv=[]# arreglo para los valores de Vpv en el tiempo 
ipv=[]# arreglo para los valores de Ipv en el tiempo
    
z=[]#entrada z para el estimador
y=[]#entrada y para el estimador
yreal = []
ynorm = [] #entrada y normalizada para el estimador



    
def InputVoltage(t):
    "This functions defines the time evolution of v"
    V_cte=18
    return V_cte+0.3*V_cte*math.sin(2*math.pi*100*t)

def ModelPV():
    j=0
    while j< numpoints: #agrega los valores para cada tiempo de Vpv e Ipv 
            Vpv.append(InputVoltage(t[j])) 
            ipv.append((Lambda-(Vpv[j]/Rp)-Psi*(e**(Vpv[j]*alpha)))/2)
            j=j+1
        
    return ipv


def CordicLn(T): #Algoritmo de cordic para resolver un Ln 

    #Condiciones iniciales 
    Z_ant=0
    X_ant=T+1
    Y_ant=T-1

    #Look-up table
    Bm=[0.54930614, 0.25541281, 0.12565721, 0.06258157, 0.06258157, 0.03126018, 0.01562627, 0.00781266, 0.00781266, 0.00390627, 0.00195313, 0.00097656, 0.00048828, 0.00048828, 0.00024414, 0.00012207, 0.00006104, 0.00006104, 0.00003052, 0.00001526, 0.00001526, 0.00000763, 0.00000381, 0.00000381]
    i=0

    #Cantidad de desplazamientos por iteracion 
    Em=[ 2**-1, 2**-2, 2**-3,2**-4,2**-4,2**-5,2**-6,2**-7,2**-7,2**-8,2**-9,2**-10,2**-11,2**-11,2**-12,2**-13,2**-14,2**-14,2**-15,2**-16,2**-16,2**-17,2**-18,2**-18]
    

    
    while i<23:

        Dm= -Y_ant/(abs(Y_ant))         # Signo de Y
        Z_act= Z_ant + Dm*-2*Bm[i]      # Calcula el valor de Z actual 
        X_act= X_ant + Em[i]*Dm*Y_ant   # Calcula el valor X actual 
        Y_act= Y_ant + Em[i]*Dm*X_ant   # Calcula el valor Y actual
        Z_ant = Z_act   # Agrega el valor actual al valor anterior de Z 
        Y_ant = Y_act   # Agrega el valor actual al valor anterior de Y
        X_ant = X_act   # Agrega el valor actual al valor anterior de X
        i = i + 1       # Contador para cada iteracion 
        ln=Z_act        # Resultado para cada iteracion
        
    return ln #resulado final del logaritmo natural
    

def parametros():

    #Evalua los parametros Ipv y Vpv en el modelo del panel
    ModelPV()

    
    j=0
    while j< numpoints: #agrega los valores para cada tiempo de Vpv e Ipv en los parametros y,z  
            yesc = CordicLn(16*(Lambda - Vpv[j]/Rp - ipv[j] ))
            y.append(yesc - math.log(16))
            ynorm.append(y[j]/2.23639972) #para normalizar se divide entre el valor maximo del calculo del Ln(0.106843) (2.23639972)
            yreal.append(math.log(Lambda - Vpv[j]/Rp - ipv[j] ))
            z.append(Vpv[j])
            # print(yreal[j], y[j], ynorm[j], t[j])
            j=j+1
    
    
    
    
    return ynorm , z

    
