%% Spetral Crest
% [scr_vector] = mySpecCrest(spectra)
% objective: Return the column wise spectral crest of the input matrix
%
% INPUTS
% spectra: windowSize x numWindows size matrix consisting of the spectrum of the frames of
% the input audios
%
% OUTPUTS
% scr_vector: 1xnumWindows size matrix consisting of the spectral crest
% values

function [scr_vector] = SpecCrest(spectra)

num = max(spectra);
den = sum(spectra);
scr_vector = num./den;
scr_vector(isnan(scr_vector)) = 0; % check for zero denominator

end