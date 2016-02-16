import math

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


def Cordic(T): #algoritmo de cordic para resolver un Ln 

    #condiciones iniciales 
    Z_ant=0
    C_ant=T+1
    S_ant=T-1
    Bm=[0.54930614, 0.25541281, 0.12565721, 0.06258157, 0.06258157, 0.03126018, 0.01562627, 0.00781266, 0.00781266, 0.00390627, 0.00195313, 0.00097656, 0.00048828, 0.00048828, 0.00024414, 0.00012207, 0.00006104, 0.00006104, 0.00003052, 0.00001526, 0.00001526, 0.00000763, 0.00000381, 0.00000381]
    i=0
    Em=[ 2**-1, 2**-2, 2**-3,2**-4,2**-4,2**-5,2**-6,2**-7,2**-7,2**-8,2**-9,2**-10,2**-11,2**-11,2**-12,2**-13,2**-14,2**-14,2**-15,2**-16,2**-16,2**-17,2**-18,2**-18]
    cont=0
    Dm= -S_ant/(abs(S_ant))

    
    while cont<23:

        
        Z_act= Z_ant - Dm*Bm[i]
        
        
        C_act= C_ant + Em[i]*Dm*S_ant
        S_act= S_ant + Em[i]*Dm*C_ant
        Dm= -S_act/(abs(S_act))
        Z_ant = Z_act
        S_ant = S_act
        C_ant = C_act
        i = i + 1
        cont=cont + 1
        
        ln=2*Z_act
        

    #return (C_ant, S_ant,Z_ant,Bm[i],Dm,ln)
    return ln
    

def parametros():

    #Evalua los parametros Ipv y Vpv en el modelo del panel
    ModelPV()

    
    j=0
    while j< numpoints: #agrega los valores para cada tiempo de Vpv e Ipv en los parametros y,z  
            y.append(Cordic(Lambda - Vpv[j]/Rp - ipv[j] )) 
            z.append(Vpv[j])
            j=j+1
        
    return y, z

    
