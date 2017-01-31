%% Get Length of Texture Window
% length = GetLengthOfTextureWindow(fs, duration_in_sec, hop)
% objective: returns the legnth of the texture window in number of blocks
% given the sampling rate, duration in seconds and the hop size
%
% INPUTS
% fs: sampling rate
% duration_in_sec: duration of the texture window in second
% hop: hop size
% 
% OUTPUTS
% length: texture (aggregation) window length in number of blocks

function length = GetLengthOfTextureWindow(fs, duration_in_sec, hop)

duration_per_hop = hop / fs;
length = ceil(duration_in_sec / duration_per_hop);

end