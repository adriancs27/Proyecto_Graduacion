import struct
import math
import csv

#getBin = lambda x: x > 0 and str(bin(x))[2:] or "-" + str(bin(x))[3:]

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


P= []
PV = []
FIX = []
FIXV = []

def InputVoltage(t):
    "This functions defines the time evolution of v"
    V_cte=12
    return V_cte+0.3*V_cte*math.sin(2*math.pi*100*t)

def ModelPV():
    j=0
    while j< numpoints: #agrega los valores para cada tiempo de Vpv e Ipv 
            Vpv.append(InputVoltage(t[j])) 
            ipv.append((Lambda-(Vpv[j]/Rp)-Psi*(e**(Vpv[j]*alpha)))/2)
            j=j+1
        
    


    
def binary(num):
    return ''.join(bin(ord(c)).replace('0b', '').rjust(8, '0') for c in struct.pack('!f', num))

def creartxt():
    I=open('LINEALIZACION_NORMALIZACION_I.txt','w')
    I.close()
    ipv_d=open('Valores_ipv_decimal.txt','w')
    ipv_d.close()
    V=open('NORMALIZACION_V.txt','w')
    V.close()
    Vpv_d=open('Valores_Vpv_decimal.txt','w')
    Vpv_d.close()
    I_LI_NOR=open('Corriente_lineal_y_normalizada.txt','w')
    I_LI_NOR.close()
    V_LI_NOR=open('Tension_lineal_y_normalizada.txt','w')
    V_LI_NOR.close()
    
def grabartxt():
    j=0;
    I=open('LINEALIZACION_NORMALIZACION_I.txt','a')
    ipv_d=open('Valores_ipv_decimal.txt','a')
    V=open('NORMALIZACION_V.txt','a')
    Vpv_d=open('Valores_Vpv_decimal.txt','a')
    V_LI_NOR=open('Tension_lineal_y_normalizada.txt','a')
    I_LI_NOR=open('Corriente_lineal_y_normalizada.txt','a')
    
    while j< numpoints: #convierte los valores de Vpv e Ipv a punto flotante y guarda cada uno en un TXT
            ipv_f = binary(ipv[j])
            Vpv_f = binary(Vpv[j])
            ILN = math.log(ipv[j])*0.19964110454
            VLN = Vpv[j]*0.05524861878
            I.write(ipv_f)
            I.write(" ")
            ipv_d.write(str(ipv[j]))
            ipv_d.write("\n")
            V.write(Vpv_f)
            V.write(" ")
            Vpv_d.write(str(Vpv[j]))
            Vpv_d.write("\n")
            I_LI_NOR.write(str(ILN))
            I_LI_NOR.write("\n")
            V_LI_NOR.write(str(VLN))
            V_LI_NOR.write("\n")
            j=j+1
    I.close()
    ipv_d.close()
    V.close()
    Vpv_d.close()
    V_LI_NOR.close()
    I_LI_NOR.close()


def fixed_to_dec(FLOAT):
    cont = 0
    dec = 0
    #str(y) 
    if FLOAT[0] == '1':
        Iter = 1
        y = FLOAT.replace("1", "2")
        z = y.replace("0", "1")
        F = z.replace("2", "0")
        resultado = int(F, 2) + 1
        resultadoP = bin(resultado)
        FF=resultadoP.replace("0b", "000")
        #print(F)
        #print (resultadoP)
        #print(FF)
        while cont < 32:
            dec = dec + int(FF[cont])*(2**Iter)
            Iter = Iter - 1
            cont = cont + 1
        dec = -dec
    else:
        Iter = 1
        while cont < 32:
            dec = dec + int(FLOAT[cont])*(2**Iter)
            Iter = Iter - 1
            cont = cont + 1


    return dec

def leertxtI():
    I_fixed=open('I_LINEAL_NORM.txt','r')
       
    lineaI=I_fixed.readline()
    
    while lineaI!="":
        #print lineaI
        P.append(lineaI)
        lineaI=I_fixed.readline()

    I_fixed.close()

def leertxtV():
    V_fixed=open('V_NORM.txt','r')
       
    lineaV=V_fixed.readline()
    
    while lineaV!="":
        #print lineaI
        PV.append(lineaV)
        lineaV=V_fixed.readline()

    V_fixed.close()
    
def FixedI():
    leertxtI()
    contador=0
    y=P[0]
    contador2=0
    while contador < 1000:
        
        FIX.append(y[contador2:contador2+32])
        contador2 = contador2 + 33;
        print(fixed_to_dec(FIX[contador]))
        contador = contador +1    
        

def FixedV():
    leertxtV()
    contador=0
    y=PV[0]
    contador2=0
    while contador < 999:
        
        FIXV.append(y[contador2:contador2+32])
        contador2 = contador2 + 33;
        print(fixed_to_dec(FIXV[contador]))
        contador = contador +1    

    
    
    
