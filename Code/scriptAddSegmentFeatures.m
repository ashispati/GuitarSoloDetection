%% script to add Structural Segmentation based features

close all
clear all
clc

addpath('SegmentFeatures/');
addpath('Utils');

% intialize parameters
window_size = 2018;
hop = 1024;

% load feature data
load('data_60.mat');
num_files = length(data);
num_features = size(data(1).feature_matrix,1);

% update segment feature
for i = 1:num_files
   aggre_time_stamp =  data(i).time_stamp;
   filepath = data(i).filename(1:end-4);
   filepath = strcat('../Dataset/Segments/', filepath, '.txt');
   songpath = strcat('../Dataset/Songs/',data(i).filename);
   [x,fs] = audioread(songpath);
   if size(x,2) > 1
        x = mean(x, 2);
   end
   x = x / max(x);
   [~, time_stamp] = WindowsFreqDomain(x, window_size, hop);
   time_stamp = (time_stamp - 1) / fs;
   segment_features = GetSegmentFeaturesForTrack(filepath, aggre_time_stamp, time_stamp);
   data(i).feature_matrix = segment_features;
   %location = data(i).time_stamp / data(i).time_stamp(end);
   %data(i).feature_matrix = [data(i).feature_matrix; location];
end

save('data_60_only_seg.mat','data');

rmpath('SegmentFeatures/');
rmpath('Utils');