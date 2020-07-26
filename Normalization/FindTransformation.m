function [cc_1, cc_2, F_prime] = FindTransformation(F1_bar, F_pxco, F_pyco)
%% FINDTRANSFORMATION finds the best transformation,
%   ----Inputs::
%       F1_bar  - Feat of Image [(x,y) coords]
%       F_pxco  - Predetermined Sample Feature [xcord]
%       F_pyco  - Predetermined Sample Feature [ycord]
%   ----Outputs::
%       cc_1, cc_2 - Params of Affine Transformation
%       F_prime  - New Avg Loc of Feats in 64 x 64 img

%% Function starts here

F_1 = [F1_bar ones(5,1)];

cc_1 = pinv(F_1)*F_pxco;  % To Calculate Params of Affine Transform>>

F_prime = F_1 * [cc_1 cc_2];

end

