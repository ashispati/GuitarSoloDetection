%% Maximum Envelope
% [me_vector] = myMaxEnv(frames)
% objective: Return the column wise maximum envelope of the input matrix
%
% INPUTS
% frames: windowSize x numWindows size matrix consisting of the frames of
% the input audio
%
% OUTPUTS
% me_vector: 1xnumWindows size matrix consisting of the maximum envelope values

function me_vector = MaxEnv(frames)

absframes = abs(frames);
me_vector = max(absframes);

end