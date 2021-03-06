import math


def Cordic(T): #algoritmo de calculo para un logaritmo natural 


    #condiciones iniciales 
    Z_ant=0
    C_ant=T+1
    S_ant=T-1

    #look-up table
    Bm=[0.54930614, 0.25541281, 0.12565721, 0.06258157, 0.06258157, 0.03126018, 0.01562627, 0.00781266, 0.00781266, 0.00390627, 0.00195313, 0.00097656, 0.00048828, 0.00048828, 0.00024414, 0.00012207, 0.00006104, 0.00006104, 0.00003052, 0.00001526, 0.00001526, 0.00000763, 0.00000381, 0.00000381]
    i=0
    Em=[ 2**-1, 2**-2, 2**-3,2**-4,2**-4,2**-5,2**-6,2**-7,2**-7,2**-8,2**-9,2**-10,2**-11,2**-11,2**-12,2**-13,2**-14,2**-14,2**-15,2**-16,2**-16,2**-17,2**-18,2**-18]
    cont=0;
    Dm= -S_ant/(abs(S_ant))

    
    while cont<10:

        
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
        

    return (C_ant, S_ant,Z_ant,Bm[i],Dm,ln)
    

         
