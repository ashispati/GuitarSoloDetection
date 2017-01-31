function filt_mfcc_feature = GetFiltMFCCFeature(filepath, audio_filename)

pitch_info = dlmread(filepath);
if (size(pitch_info,1) > size(pitch_info,2))
    pitch_info = pitch_info';
end

if size(pitch_info,1) == 1
    if mod(length(pitch_info),2) == 1
        error('Bad Output from Melodia. Check the input text file');
    end
    num_blocks = length(pitch_info)/2;
    pred_freq = pitch_info(1:num_blocks);
elseif size(pitch_info,1) == 2
    num_blocks = size(pitch_info,2);
    pred_freq = pitch_info(1,:);
else
    error('Bad Output from Melodia. Check the input text file');
end
time_stamp_pitch = (0:1:num_blocks-1)*(hop/fs);

% read audio
cd('../Dataset/Songs');
[x,fs] = audioread(filename);
cd('../../Code');

% downmix and normalize
if size(x,2) > 1
    x = mean(x, 2);
end
x = x / max(x);

% initialize 
window_size = 2048;
hop = 1024;
hop_pitch = 128;

% compute and scale fft
[windowed_x, time_stamp] = WindowsFreqDomain(x, window_size, hop);
mag_spectra = abs(fft(windowed_x))*window_size/2;
width = floor(size(mag_spectra,1)/2);
mag_spectra = mag_spectra(1:width,:);
num_bins = size(mag_spectra,1);
freq_bin = (0:num_bins-1)*fs/(num_bins*2);

length_aggre_block = time_stamp(2);
num_equi_blocks = floor(length_aggre_block * fs / hop);
pred_freq = smooth(pred_freq, num_equi_blocks);
freq = zeros(size(time_stamp));
for i = 1:length(time_stamp) 
    diff = abs(time_stamp_pitch - time_stamp(i));
    [~, min_idx] = min(diff);
    freq(i) = pred_freq(min_idx);
end




end