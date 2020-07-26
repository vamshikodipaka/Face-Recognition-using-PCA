%%%% This is a file/data management system %%%%

function [Data_MAT, Label_MAT] = CreateTrainDatabase(Path)
%% CREATE_TRAIN_DATABASE creates a Matrix to store Train Images.
%% -----Inputs::
%       Path - Path to the dir containing Imgs
%  -----Outputs::
%       D  - Mat contains each Training Img as 1D vector
%       L  - Mat with label of each Img in Training set
%%%
%%

Img_dir = [dir(fullfile(Path,'*jpg')); dir(fullfile(Path,'*JPG')); dir(fullfile(Path,'*jpeg'))];

Data_MAT = []; % Data Mat
Label_MAT = []; % Label Mat

for Index = 1:length(Img_dir)
    
    % Reading Images from dir>>
    Image_name = Img_dir(Index).name;
    file_name = strcat(Path,Image_name);
    Img = imread(file_name);
    [row, col] = size(Img);
    
    temp = reshape(Img',1,row*col);   % Reshaping 2D Imgs into 1D Img Vect
    Data_MAT = [Data_MAT; temp];
    Label_MAT = [Label_MAT; Image_name(1:5)];
    
end

end