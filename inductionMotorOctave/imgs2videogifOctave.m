function imgs2videogif(nome_gif, imgsdir, padrao_nomeframes, delay_s)
% Gera vídeo gif a partir de imagens.
%
% Sintaxe:
%   imgs2videogif(nome_gif, imgsdir, padrao_nomeframes, delay_s)
%
%
% INPUTS
% - nome_gif
%     nome do arquivo gif a ser gerado.
%
% - imgsdir
%     nome do diretório com as imagens a serem utilizadas como quadros no
%     vídeo.
%
% - padrao_nomeframes
%     Nome do formato em que estão os nomes dos frames.
%
%     Os nomes dos frames devem estar no formato de uma string constante
%     acrescida de número, que é a posição do frame no vídeo. No
%     padrao_nomeframes, o lugar em que aparece o número dos frames deve
%     estar indicado com '*'.
%
%     Por exemplo, se os frames do vídeo estão com os nomes quadro1.png,
%     quadro2.png, ..., padrao_nomeframes = 'quadro*.png'.
%
%     Se for test0.bmp, test1.bmp, test2.bmp, ...
%     padrao_nomeframes = 'test*.bmp'.
%
% - delay_s
%     atraso em segundos entre quadros consecutivos do gif.
%
%
% EXEMPLOS
%   delay_s = 0.5;
%   imgs2videogif('video.gif', './', 'test*.bmp', delay_s);
%
%     Gera vídeo de nome 'video.gif' em que os quadros estão no diretório
%     atual ('./'), e têm os nomes 'test0.bmp', 'test1.bmp', ...
%     No vídeo, o atraso entre um quadro e o seguinte é de 0.5 segundo.


% retorna os nomes dos arquivos com os frames do vídeo
nomes_frames = get_nomes_frames(imgsdir, padrao_nomeframes);

is_first = true;

for i = 1:length(nomes_frames)
    nome = nomes_frames{i};
    
    fprintf('Processando frame ''%s'' ...\n', nome);
    
    % carregar imagem do frame
    frame_rgb = imread(nome);
    

    % passar frame para imagem indexada e obter mapa de cores
    try % matlab
        [frame_ind, colormap] = rgb2ind(frame_rgb, 256);

    catch % octave
        try
            [frame_ind, colormap] = rgb2ind(frame_rgb);
        catch
            error('Não consegui executar a função rgb2ind()!!');
        end
    end
    
    
    % adicionar frame ao vídeo
    addframe(is_first, frame_ind, colormap, nome_gif, delay_s);
    
    
    is_first = false;
end




function nomes_frames = get_nomes_frames(pasta, padrao_nomes)
% Retorna os nomes dos arquivos com os frames na sequência correta, do
% primeiro ao último.

Inum = find(padrao_nomes == '*');

if numel(Inum) ~= 1
    error(['Padrão nomes arquivos=''%s'' inválido!!\n' ...
        'Deve ter exatamente um ''*'' no nome do padrão para indicar ' ...
        'o número do quadro'], padrao_nomes);
end


% nomes dos arquivos em <pasta> que obedecem ao formato <padrao_nomes>
arquivos_padrao = dir( fullfile(pasta, padrao_nomes) );
arquivos_padrao = { arquivos_padrao.name }';


inds_frames = zeros(length(arquivos_padrao), 1);


padrao_printf = strrep(padrao_nomes, '*', '%d');


% pegar o índice do frame pelo nome do arquivo
for i = 1:length(arquivos_padrao)
    inds_frames(i) = sscanf(arquivos_padrao{i}, padrao_printf);
end


% reordenar nomes dos frames em sequência crescente do índice
[~,I] = sort(inds_frames);

nomes_frames = arquivos_padrao(I);

for i = 1:length(nomes_frames)
    nomes_frames{i} = fullfile(pasta, nomes_frames{i});
end




function addframe(is_first, frame_ind, colormap, nome_gif, delay_s)
% Adiciona quadro ao vídeo gif.
%
% INPUTS
% - is_first
%     booleano indicando se este é o primeiro quadro do vídeo.
%
% - frame_ind
%     imagem indexada do frame.
%
% - colormap
%     cores rgb do mapa de cores. É uma matriz de 3 colunas, em que cada
%     linha é o código rgb de uma cor diferente do mapa.
%
% - nome_gif
%     nome do arquivo gif a ser gerado.
%
% - delay
%     atraso em segundos entre quadros consecutivos do gif.


% gerar quadro para o gif. O comando para o primeiro quadro
% é diferente dos demais.
if is_first == true
    imwrite(frame_ind, colormap, nome_gif, 'gif', ...
        'Loopcount',Inf, 'DelayTime',delay_s);
else
    imwrite(frame_ind, colormap, nome_gif, 'gif', ...
        'WriteMode','append', 'DelayTime',delay_s);
end

