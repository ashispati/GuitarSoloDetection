%% Compute features for noisy files
close all;
clear all;
clc;

%% Set file paths
project_folder = '/Users/Som/Desktop/Georgia Tech Acads/2nd Sem/MUSI 7100 AL/';
noisy_audio_folder = 'NoisyData/';

%% Set global variables
fs = 22050;
hop_size = 512;
window_size = 1024;

%% Read and process audio files
noisy_audio_filenames = dir(strcat(project_folder, noisy_audio_folder, '*.wav'));
num_files = length(noisy_audio_filenames);
feat_mat = cell(1,num_files);

for i = 1:num_files
    filename = noisy_audio_filenames(i).name;
    filelocation = strcat(project_folder,noisy_audio_folder,filename);
    noisy_audio = audioread(filelocation);
    
    % Divide the signal into overlapping blocks
    frames = WindowsTimeDomain(noisy_audio, window_size, hop_size);
    frames_spectra = WindowsFreqDomain(noisy_audio,window_size,hop_size);
    spectra = abs(fft(frames_spectra));
    
    % Compute block-wise features
    vector_sc = mySpecCentroid(spectra);
    vector_me = myMaxEnv(frames);
    vector_zcr = myZCR(frames);
    vector_scr = mySpecCrest(spectra);
    vector_sf = mySpecFlux(spectra);
    vector_mfcc = FeatureSpectralMfccs(spectra,fs);
    
    % Store feature matrix
    feat_mat{i} = [vector_sc; vector_me; vector_zcr; vector_scr; vector_sf; vector_mfcc];
    
    disp(strcat('Completed File No: ',int2str(i)));
end

save('feat_mat.mat','feat_mat');

%% Assign Labels
len = length(vector_sc);
final_time = (len-1)*hop_size/fs;
time_stamp = linspace(0,final_time,len);
labels = zeros(1,len);
for i = 1:len
    if time_stamp(i) < 5
        labels(i) = 0;
    elseif time_stamp(i) < 10
        labels(i) = 1;
    elseif time_stamp(i) < 15
        labels(i) = 0;
    elseif time_stamp(i) < 20
        labels(i) = 1;
    else
        labels(i) = 0;
    end
end

save('labels.mat','labels');





