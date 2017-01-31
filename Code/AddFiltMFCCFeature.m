close all
clear all
clc

% load feature data
load('data_seg_pitch.mat');
num_files = length(data);
num_features = size(data(1).feature_matrix,1);

% update segment feature
for i = 1:num_files
   aggre_time_stamp =  data(i).time_stamp;
   audio_filename = data(i).filename;
   filepath = data(i).filename(1:end-4);
   filepath = strcat('../Dataset/Pitch/', filepath, '.txt');
   
   filt_mfcc_feature = GetFiltMFCCFeature(filepath, audio_filename);
   
end
