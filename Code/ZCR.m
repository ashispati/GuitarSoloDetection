%% Zero Crossing Rate
% [zcr_vector] = myZCR(frames)
% objective: Return the column wise zero crossing rate of the input matrix
%
% INPUTS
% frames: windowSize x numWindows size matrix consisting of the frames of
% the input audio
%
% OUTPUTS
% zcr_vector: 1xnumWindows size matrix consisting of the zero crossing rate
% values

function [zcr_vector] = ZCR(frames)

sign_frames = sign(frames);
sign_frames_shifted = circshift(sign_frames,1,1);
zcr_matrix = zeros(size(frames));
zcr_matrix(1,:) = sign_frames(1,:);
zcr_matrix(2:end,:) = sign_frames(2:end,:) - sign_frames_shifted(2:end,:);
zcr_vector = sum(abs(zcr_matrix))/(2*size(frames,1));

end