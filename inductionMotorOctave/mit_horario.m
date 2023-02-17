clear
clc

addpath('C:\femm42\mfiles');
savepath;

openfemm

opendocument('mit.fem');

pf = fopen('results.txt', 'w');
fprintf(pf, ['# freq\tcorrente real\tcorrente imag\ttensao real\t' ...
    'tensao imag\tfluxo real\tfluxo imag\ttorque\n']);


for k = 1:1:4

	freq = k/4;
	mi_probdef(freq,"millimeters","planar",1e-8,100,20);
	mi_seteditmode('group');
  mi_selectgroup(4);
  mi_moverotate(0,0,5);
	mi_zoomnatural();
%  mi_saveas(['MIT' num2str(k) '.fem']);  %%% Salve all runs
  mi_saveas('temp.fem');  %%% don't salve all runs
  mi_analyze;
	mi_loadsolution;

  %look at the flux linkage for phase B.
	out = mo_getcircuitproperties('B');  %% i, v ,flux
    corrente = out(:, 1);
    V = out(:, 2);
    flux = out(:, 3);

  mo_showdensityplot(1,0,8.72e-5,3,'mag');
  mo_savebitmap(['MIT' num2str(k) '.bmp']);

  % get the torque on the rotor
	mo_groupselectblock(4);
	torque = mo_blockintegral(22);

    fprintf(pf, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', freq, real(corrente), imag(corrente), ...
        real(V), imag(V), real(flux), imag(flux), torque);

	mo_close()
end


fclose(pf);

closefemm

imgs2videogifOctave('video.gif','.\', 'MIT*.bmp', 0.2);


