function [aggre_feature_matrix, aggre_time_stamp] = AggregateFeatureVector(feature_matrix, length, overlap_percent, time_stamp)

% objective: Aggregates the feature vector by taking mean and standard
% deviation of features over a specified length
%
% INPUTS
% feature_matrix: n x m matrix of frames, m being the number of
% overlapping windows, n is the length of the feature vector
% length: texture (aggregation) window length in blocks
% overlap_percentage: percentage overlap between individual aggregated
% blocks
% time_stamp: 1 x m vector containin the time stamps of individual features
% vectors in feature_matrix
%
% OUTPUTS
% aggre_feature_matrix: 2n x M feature matrix, M being the number of
% texture windows
% aggre_time_stamp: 1 x M vector containing the timestamps of the aggregated
% feature vectors

[num_features, ~] = size(feature_matrix);
if mod(length,2) == 1
   length = length + 1; 
end

% zeropadding
zeropad_feature_matrix = [zeros(num_features, length/2), feature_matrix,...
    zeros(num_features, length/2)];
N = size(zeropad_feature_matrix,2); %length of feature matrix

% creating texture windows based on length and overlap_percent
idx = 1; % feature_vector index
hop_size = ceil(length * ( 1 - overlap_percent));
num_tex_windows = ceil((N-length)/hop_size);
aggre_feature_matrix = zeros(2*num_features, num_tex_windows);
aggre_time_stamp = zeros(1,num_tex_windows);

for i = 1:num_tex_windows
    % compute features for block within texture window
    dummy = zeropad_feature_matrix(:, idx:min(idx+length,N)-1);
    
    % compute delta features
    %delta_dummy = [dummy(:,1), diff(dummy')'];
    
    % aggregate features
    aggre_feature_matrix(1:num_features,i) = median(dummy,2);
    aggre_feature_matrix(num_features+1:2*num_features, i) = std(dummy')';
    
    % aggregate delta features
    %aggre_feature_matrix(2*num_features+1:3*num_features, i) = median(delta_dummy,2);
    %aggre_feature_matrix(3*num_features+1:4*num_features, i) = std(delta_dummy')';
    %{
    if i == 1
        aggre_feature_matrix(2*num_features+1:3*num_features,i) = ...
            aggre_feature_matrix(1:num_features,i);
        aggre_feature_matrix(3*num_features+1:end,i) = ...
            aggre_feature_matrix(num_features+1:2*num_features,i);
    else
        aggre_feature_matrix(2*num_features+1:3*num_features,i) = ...
            aggre_feature_matrix(1:num_features,i) - ...
            aggre_feature_matrix(1:num_features,i-1);
        aggre_feature_matrix(3*num_features+1:end,i) = ...
            aggre_feature_matrix(num_features+1:2*num_features,i) - ...
            aggre_feature_matrix(num_features+1:2*num_features,i-1);
    end
    %}
    aggre_time_stamp(i) = time_stamp(idx);
    idx = idx + hop_size;
end



end