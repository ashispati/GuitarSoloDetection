%% ZScore Nomarlization
% [featMat_norm] = ZScore(featMat)
% objective: Return the fz-score normalized feature matrix
%
% INPUTS
% feat_mat: n x M feature matrix returned by getMetaData.m
%
% OUTPUTS
% featMat_norm: n x M z-score normalized featurematrix 

function [featMat_norm, feat_mean, feat_std] = ZScore(feat_mat)

length = size(feat_mat,2);
feat_mean = mean(feat_mat,2);
feat_mean_mat = feat_mean*ones(1,length);
feat_std = std(feat_mat')';
feat_std_mat = feat_std * ones(1,length);
featMat_norm = (feat_mat - feat_mean_mat)./feat_std_mat;

end