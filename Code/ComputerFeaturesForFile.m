function [feature_matrix, time_stamp] = ComputerFeaturesForFile(x, window_size, hop, fs)

% objective: Computes the audio features of the input audio signal 
% specified by the window size and hop size
%
% INPUTS
% x: L x 1 float array, single-channel audio signal 
% window_size: window size
% hop: hop size
% fs = sampling rate of audio file
%
% OUTPUTS
% feature_matrix: n x m matrix of frames, m being the number of overlapping windows
% time_stamp: 1 x m vector containing the time stamp of individual feature
% vectors in seconds

% window for spectral features
[windowed_x, time_stamp] = WindowsFreqDomain(x, window_size, hop);

% compute and scale fft
mag_spectra = abs(fft(windowed_x))*window_size/2;
width = floor(size(mag_spectra,1)/2);
mag_spectra = mag_spectra(1:width,:);

% compute MFCCs
feature_matrix = FeatureSpectralMfccs(mag_spectra, fs);
feature_matrix = feature_matrix(2:end,:);

% % compute hps
% mag_spectra = ComputeHps(mag_spectra);

% compute spectral features
vector_sc = SpecCentroid(mag_spectra);
vector_sf = SpecFlux(mag_spectra);
vector_scr = SpecCrest(mag_spectra);

% window for time domain features
windowed_x = WindowsTimeDomain(x, window_size, hop);

% compute time domain features
vector_me = MaxEnv(windowed_x);
vector_zcr = ZCR(windowed_x);


feature_matrix = [feature_matrix; vector_sf; vector_sc; vector_scr; vector_zcr; vector_me];
time_stamp = (time_stamp - 1) / fs;

end