close all
clear all
clc

%% read file names
cd('../Dataset/Songs');
filenames = dir('*.mp3');
cd('../../Code');

%% initialize parameters
num_files = length(filenames);
window_size = 2048;
hop = 1024;
duration = 2; % texture window length in seconds
data = struct('filename',{},'feature_matrix',{},'class_labels',{},'time_stamp',{});
data_points_cumulative = 0;

%% iterate through files to compute features
for i = 1:num_files
    filename = strcat('../Dataset/Songs/',filenames(i).name);
    [x,fs] = audioread(filename);
    
    % resample
    if fs ~= 44100
        resample(x, 44100, fs);
    end
    
    % downmix and normalize
    if size(x,2) > 1
        x = mean(x, 2);
    end
    x = x / max(x);
    
    % store filename
    data(i).filename = filenames(i).name;
    
    % compute and aggregate features
    [feature_matrix, time_stamp] = ComputerFeaturesForFile(x, window_size, hop, fs);
    len = GetLengthOfTextureWindow(fs, duration, hop);
    [data(i).feature_matrix, aggre_time_stamp] = AggregateFeatureVector(feature_matrix,len, 0.5, time_stamp);
    
    %      % compute segment features
    %      filepath = filenames(i).name(1:end-4);
    %      filepath = strcat('../Dataset/Segments/', filepath, '.txt');
    %      segment_labels = GetSegmentFeaturesForTrack(filepath,aggre_time_stamp);
    %      data(i).feature_matrix = [data(i).feature_matrix; segment_labels];
    
    % determine class labels from annotations
    filepath  = filenames(i).name(1:end-4);
    filepath = strcat('../Dataset/Annotations/',filepath,'_segment.txt');
    data(i).class_labels = GetClassLabelsFromAnnotations(filepath, aggre_time_stamp);
    
    data(i).time_stamp = aggre_time_stamp;
    
    % display status
    disp(strcat('Finished file: ',num2str(i)));
end

save('data_60.mat','data');
