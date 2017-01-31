close all
clear all
clc

% load feature data
load('data_60_seg.mat');
num_files = length(data);
num_features = size(data(1).feature_matrix,1);

% update segment feature
for i = 1:num_files
   aggre_time_stamp =  data(i).time_stamp;
   filepath = data(i).filename(1:end-4);
   filepath = strcat('../Dataset/Pitch/', filepath, '.txt');
   pitch_features = GetPitchFeaturesForTrack(filepath,aggre_time_stamp);
   data(i).feature_matrix = [data(i).feature_matrix; pitch_features];
end

save('data_60_seg_pitch.mat','data');