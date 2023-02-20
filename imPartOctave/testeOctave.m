clear
clc

addpath('C:\femm42\mfiles');
savepath;

openfemm

opendocument("2horse.fem")   %%%%%%

%%save in a temporary file for purposes of
%%performing the analysis
mi_saveas("tempOctave.fem")

pf = fopen('resultsOctave.txt', 'w'); % abrir antes do laço
fprintf(pf, ['# freq\t  i_real\t  i_imag\t  V_real\t' ...
    '  V_imag\t  flux_real\t flux_imag\t torque\n']);

for k = 1:1:12

	freq = k/4;

	%change the frequency to the desired one
	%for this particular iteration
	mi_probdef(freq,"millimeters","planar",1e-8,100,20)

	% run the analysis and load the solution
	mi_analyze;  %%%%
	mi_loadsolution; %%%%

	%look at the flux linkage for phase A.

  out =  mo_getcircuitproperties('A');
  corrente = out(:, 1);
  V = out(:, 2);
  flux = out(:, 3);

	%get the torque on the rotor
	mo_groupselectblock(4);
	torque = mo_blockintegral(22);

	%write results to a data file, multiplying by 4 to get
	%the results for all 4 poles of the machine.

  fprintf(pf, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', freq, real(corrente), imag(corrente), ...
        real(V), imag(V), 4*real(flux), 4*imag(flux), 4*torque);

end

fclose(pf);

closefemm
