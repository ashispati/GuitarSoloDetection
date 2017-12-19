function pitch_feature_mat = GetPitchFeaturesForTrack(filepath, aggre_time_stamp)

% objective: compute the predominamt pitch based feature matrix
%
% INPUTS
% filepath: path to the melodia predominant pitch output
% aggre_time_stamp: 1 x M vector containing the timestamps of the aggregated
% feature vectors
%
% OUTPUTS
% pitch_feature_mat = predominamt pitch based feature matrix

hop = 128;
fs = 44100;

pitch_info = dlmread(filepath);
if (size(pitch_info,1) > size(pitch_info,2))
    pitch_info = pitch_info';
end

if size(pitch_info,1) == 1
    if mod(length(pitch_info),2) == 1
        error('Bad Output from Melodia. Check the input text file'); 
    end
    num_blocks = length(pitch_info)/2;
    pred_pitch = pitch_info(1:num_blocks);
    prob_pitch = pitch_info(num_blocks+1:end);
elseif size(pitch_info,1) == 2
    num_blocks = size(pitch_info,2);
    pred_pitch = pitch_info(1,:);
    prob_pitch = pitch_info(2,:);
else
    error('Bad Output from Melodia. Check the input text file');
end

pitch_time_stamp = (0:1:num_blocks-1)*(hop/fs);
%length_aggre_block = aggre_time_stamp(2)*2;
%num_equi_blocks = floor(length_aggre_block * fs / hop);

midi_pitch = GetMidiPitch(pred_pitch);
%midi_pitch = smooth(midi_pitch, num_equi_blocks);
%prob_pitch = smooth(prob_pitch, num_equi_blocks);
% sanity check
if max(prob_pitch) > 1.0
    error('Bad Output from Melodia. Check the input text file');
end

pitch_feature_mat = zeros(4, length(aggre_time_stamp));
for i = 1:length(aggre_time_stamp) 
    % find upper and lower bound time-stamps for blocks within texture
    % window
    tex_window_lower_bound = aggre_time_stamp(max(1,i-1));
    tex_window_upper_bound = aggre_time_stamp(min(i+1,length(aggre_time_stamp)));
    
    % find indices of blocks within texture window
    time_diff = abs(pitch_time_stamp - tex_window_lower_bound);
    [~, lower_idx] = min(time_diff);
    time_diff = abs(pitch_time_stamp - tex_window_upper_bound);
    [~, upper_idx] = min(time_diff);
    
    % compute features for blocks within texture window
    midi_feat = midi_pitch(lower_idx:upper_idx);
    prob_feat = prob_pitch(lower_idx:upper_idx);
    
    % calculate delta features
    %delta_midi_feat = [midi_feat(1), diff(midi_feat)];
    %delta_prob_feat = [prob_feat(1), diff(prob_feat)];    
    
    % aggregate features
    pitch_feature_mat(1,i) = median(midi_feat);
    pitch_feature_mat(2,i) = std(midi_feat);
    pitch_feature_mat(3,i) = median(prob_feat);
    pitch_feature_mat(4,i) = std(prob_feat);
    %pitch_feature_mat(1,i) = median(delta_midi_feat);
    %pitch_feature_mat(2,i) = std(delta_midi_feat);
    %pitch_feature_mat(3,i) = median(delta_prob_feat);
    %pitch_feature_mat(4,i) = std(delta_prob_feat);

    %diff = abs(pitch_time_stamp - aggre_time_stamp(i));
    %[~, min_idx] = min(diff);
    %pitch_feature_mat(1,i) = midi_pitch(min_idx);
    %pitch_feature_mat(2,i) = prob_pitch(min_idx);
end



end

