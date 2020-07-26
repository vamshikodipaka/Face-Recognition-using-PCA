function [FirstMatch, SecondMatch, ThirdMatch, Accu] = ComputeEigenFaces(Test_Img, Img_Name, P, D, L, TestPath)
%% COMPUTE_EIGEN_FACES recognizes the Correct Matches for the give Test Img.
%   ----Input::
%       P    - PCA Projection Matrix
%       D    - Mat contains each Training Img as 1D vector
%       L    - Mat with the label of each Img in Training set
%   ---Output::
%       Match 1, 2, 3 - All three Matches
%       Accuracy      - Recognition Accuracy

%% Function starts here

%% Performing PCA on Train and Test Imgs
%/////////Computing Feat Vectors of all Train Imgs
%>>>>>>>>>
Feature_Vect_Train = double(D) * P; % pxN_pca Matrix

% Reshape 2D Test_Img into 1D Img Vector
[row, col] = size(Test_Img);
Img = reshape(Test_Img',1,row*col);
D_Img = double(Img);

% Computing Feat Vector for the Test Img
Feat_Vect_Test = D_Img * P;  % 1xN_pca Mat

%% Calculating Euclidean Dist. b/w Test Vect and all Train Vects
Euc_dist = [];
[row,~] = size(Feature_Vect_Train);

for i = 1 : row
    temp = Feature_Vect_Train(i,:);
    Difference = (norm(Feat_Vect_Test - temp))^2;
    Euc_dist = [Euc_dist Difference];
end

% Sorting the Euclidean dists in Ascending order>>
[~,Index] = sort(Euc_dist);

%% Finding Best Matches of Face and Construct Eigen Faces
Err = 0;
Length = size(D,1);

%........>>>Label_name 
for i = 1:Length
    if strcmp(L(Index(i),:),Img_Name(1:5)) 
        
        FirstMatch = reshape(D(Index(i),:),64,64)';
        %output the recognised Img
        
        break;
    else
        Err = Err + 1; 
    end
end

for j = i+1:Length
    if strcmp(L(Index(j),:),Img_Name(1:5))  
        
        SecondMatch = reshape(D(Index(j),:),64,64)'; %output is recognised Img
        break;
    end
end

for k = j+1:Length
    if strcmp(L(Index(k),:),Img_Name(1:5)) 
        
        ThirdMatch = reshape(D(Index(k),:),64,64)'; %output is recognised Img
        break;
    end
end

%% Calcualte Accuracy

%........>>>Label_name>>>>>>
TestImgs = length(TestPath);
Acc = (1-Err/TestImgs)*100;
Accu = round(Acc,2);

end

