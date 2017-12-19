%% Spectral Centroid
% [sc_vector] = mySpecCentroid(spectra)
% objective: Return the column wise spectral centriod of the input matrix
%
% INPUTS
% spectra: windowSize x numWindows size matrix consisting of the spectrum of the frames of
% the input audio
%
% OUTPUTS
% sc_vector: 1xnumWindows size matrix consisting of the spectral centroid values

function sc_vector = SpecCentroid(spectra)

width = size(spectra,1);
length = size(spectra,2);
sqSpec = spectra.^2;
index = (1:width)'*ones(1,length);
num = sum(index.*sqSpec);
den = sum(sqSpec);
sc_vector = num./den;
sc_vector(isnan(sc_vector)) = 0; % check for zero denominator

end