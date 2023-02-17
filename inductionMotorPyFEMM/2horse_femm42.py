## libs
import femm
import matplotlib.pyplot as plt

##- open up the base geometry file

femm.openfemm()

femm.opendocument('2horse.fem')

##-- save in a temporary file for purposes of """
##-- performing the analysis


femm.mi_saveas("temp.fem")

with open('resultsPyFemm.txt', 'w') as txt:
	txt.write('#freq	i_real	i_imag	V_real	V_imag	flux_real	flux_imag	torque \n')

	for k in range (0,13):  

		freq = k/4

	##	-- change the frequency to the desired one
	##	-- for this particular iteration
		femm.mi_probdef(freq,"millimeters","planar",1e-8,100,20)

	##	-- run the analysis and load the solution
		femm.mi_analyze()
		femm.mi_loadsolution()

	##	-- look at the flux linkage for phase A.
	
		z = femm.mo_getcircuitproperties('A')
		corrente = z[0]
		V = z[1]
		flux = z[2]  
	
	##	-- get the torque on the rotor
		femm.mo_groupselectblock(4)
		torque = femm.mo_blockintegral(22)
	
##	-- write results to a data file, multiplying by 4 to get
##	-- the results for all 4 poles of the machine.
	
		txt.write(str(freq) + '\t' + 
		str(corrente.real) + '\t' + str(corrente.imag) + '\t' + 
		str(V.real) + '\t' + str(V.imag) + '\t' +
		str(4*flux.real) + '\t' + str(4*flux.imag) + '\t' +
		str(4*torque) + '\n')
		
femm.closefemm()



