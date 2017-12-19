function class_labels = GetClassLabelsFromAnnotations(filepath, aggre_time_stamp)

% objective: Get the class labels by reading the ground truth from the annotations
%
% INPUTS
% filepath: path to the annotation file
% aggre_time_stamp: 1 x M vector containing the timestamps of the aggregated
% feature vectors
%
% OUTPUTS
% class_labels: 1 x M vector with 0's where solos are present and 1's where
% solos are absent

% read annotation data from file path
annotations = dlmread(filepath);

% initialize variables
num_solo_sections = size(annotations,1);
M = length(aggre_time_stamp);
class_labels = zeros(1,M);

for i = 1:M
   time = aggre_time_stamp(i);
   for j = 1:num_solo_sections
       if and(time > annotations(j,1), time <= annotations(j,1) + annotations(j,2))
           class_labels(i) = 1;
           break;
       end
   end 
end

end