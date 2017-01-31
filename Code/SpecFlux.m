%% Spetral Flux
% [sf_vector] = mySpecFlux(spectra)
% objective: Return the column wise spectral flux of the input matrix
%
% INPUTS
% spectra: windowSize x numWindows size matrix consisting of the spectrum of the frames of
% the input audios
%
% OUTPUTS
% sf_vector: 1xnumWindows size matrix consisting of the spectral flux
% values

function [sf_vector] = SpecFlux(spectra)

width = size(spectra,2);
spectra_shift = circshift(spectra,1,2);
nvtMatrix = zeros(size(spectra));
nvtMatrix(:,1) = spectra(:,1);
nvtMatrix(:,2:end) = spectra(:,2:end) - spectra_shift(:,2:end);
nvtMatrix = nvtMatrix.^2;
sf_vector = sqrt(sum(nvtMatrix))/(width);


end