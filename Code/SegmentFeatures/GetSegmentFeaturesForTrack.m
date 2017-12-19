function seg_feat = GetSegmentFeaturesForTrack(path_to_seg_file, aggre_time_stamp, time_stamp)

% objective: Get the segment based features corresponding to the time-stamp by
% readig from the segmentation text file.
%
% INPUTS
% path_to_seg_file: path to the segmentation file
% aggre_time_stamp: 1 x M vector containing the timestamps of the aggregated
% feature vectors
% time_stamp: 1xN vector containing the time stamps of the short-time
% windows of the song
%
% OUTPUTS
% segment_features: n x M vector with the segment labels for each timestamp
%  where n is the number of segment based features

% read annotation data from file path
segment_info = dlmread(path_to_seg_file);
segment_id = segment_info(:,3);

% initialize variables
num_segments = size(segment_info,1);
M = length(aggre_time_stamp);
%segment_labels = zeros(1,M);

seg_feat = zeros(2,M);

for i = 1:M
    % find upper and lower bound time-stamps for blocks within texture
    % window
    tex_window_lower_bound = aggre_time_stamp(max(1,i-1));
    tex_window_upper_bound = aggre_time_stamp(min(i+1,length(aggre_time_stamp)));
    
    % find indices of blocks within texture window
    time_diff = abs(time_stamp - tex_window_lower_bound);
    [~, lower_idx] = min(time_diff);
    time_diff = abs(time_stamp - tex_window_upper_bound);
    [~, upper_idx] = min(time_diff);
    %time = aggre_time_stamp(i);
    
    tex_win_idx = lower_idx:upper_idx;
    segment_rep = zeros(size(tex_win_idx));
    segment_length = zeros(size(tex_win_idx));
    for idx = 1:length(tex_win_idx)
        time = time_stamp(tex_win_idx(idx));
        for j = 1:num_segments
            if and(time >= segment_info(j,1), time < segment_info(j,2))
                %segment_label = segment_id(j);
                segment_rep(idx) = length(find(segment_id == segment_id(j)));
                segment_length(idx) = (segment_info(j,2) - segment_info(j,1)) / aggre_time_stamp(end);
                break;
            end
        end
    end
    
    seg_feat(1,i) = median(segment_rep);
    seg_feat(2,i) = std(segment_rep);
    seg_feat(3,i) = median(segment_length);
    seg_feat(4,i) = std(segment_length);
end

%{
for j = 1:num_segments
    if and(time >= segment_info(j,1), time < segment_info(j,2))
        segment_labels(i) = segment_id(j);
        num_repetitions = length(find(segment_id == segment_id(j)));
        segment_weigtage(i) = num_repetitions;
        segment_length(i) = (segment_info(j,2) - segment_info(j,1)) / aggre_time_stamp(end);
        break;
    end
end
end
%segment_features = [segment_weigtage; segment_length];
%}

end

