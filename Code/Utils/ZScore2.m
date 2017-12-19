%% ZScore Nomarlization
% [featMat_norm] = ZScore2(featMat)
% objective: Return the z-score normalized feature matrix. Normalization in
% done based on input mean and std
%
% INPUTS
% featMat: 10x500 feature matrix returned by getMetaData.m
%
% OUTPUTS
% featMat_norm: 10x500 z-score normalized featurematrix 

function [featMat_norm] = ZScore2(featMat, feat_mean, feat_std)

length = size(featMat,2);
feat_mean_mat = feat_mean*ones(1,length);
feat_std_mat = feat_std * ones(1,length);
featMat_norm = (featMat - feat_mean_mat)./feat_std_mat;

end