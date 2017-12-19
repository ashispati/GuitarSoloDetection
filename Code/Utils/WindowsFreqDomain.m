function [frames, time_stamp] = WindowsFreqDomain(x, window_size, hop_size)

% objective: Return overlapping windows given a array, window size and hop size  
%
% INPUTS
% x: N x 1 float array, audio signal 
% window_size: window size
% hop_size: hop size
%
% OUTPUTS
% frames: window_size x n matrix of frames, n being the number of overlapping windows
% time_stamp: 1 x n vector containing the time_stamp in terms of sample
% numbers

% zeropadding in the beginning
zeropadaudio = [zeros(window_size/2,1);x;zeros(window_size/2,1)];
N = length(zeropadaudio); %length of audio file

% creating frames based on wSize and hop
idx = 1; % sample index 
num_windows = ceil((N-window_size)/hop_size);
frames = zeros(window_size,num_windows);
time_stamp = zeros(1,num_windows);
hammingW = hamming(window_size);

for i = 1:num_windows
    frames(1:min(idx+window_size,N)-idx,i) = zeropadaudio(idx:min(idx+window_size,N)-1);
    frames(:,i) = hammingW.*frames(:,i);
    time_stamp(i) = idx;
    idx = idx + hop_size;
end

end