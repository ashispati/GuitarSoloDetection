function hps_spectrum = ComputeHps (spectra)

% objective: Computes the harmonic product spectrum of the input magnitude spectrum
%
% INPUTS
% spectra : windowSize x numWindows size matrix consisting of the spectrum of the frames of
% the input audio
%
% OUTPUTS
% hps_spectrum: windowSize x numWindows size harmonic product spectrum

% initialize
iOrder  = 5;
hps_spectrum   = spectra;

% compute the HPS
for j = 2:iOrder
    hps_spectrum   = hps_spectrum .* [spectra(1:j:end,:); zeros(size(spectra,1)-size(spectra(1:j:end,:),1), size(spectra,2))];
end

end