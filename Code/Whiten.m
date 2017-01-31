%% Whiten
% [white_train, white_test] = Whiten(train, test)
% objective: Whiten data by subtracting the mean and dividing by the 
%            standard deviation. Mean and standard deviation are computed 
%            from the training data but whitening is applied to both the 
%            training and the test data.
%
% train: NxM float array, training data where N -> number training data, 
%        M -> number features.
% test: LxM float array, test data, L -> number test data, 
%       M -> number features.
% white_train: NxM float array, whitened training data, 
%              N -> number training data, M -> number features.
% white_test: LxM float array, whitened test data, L -> number test data, 
%             M -> number features.

function [white_train, white_test] = Whiten(train, test)

% Preallocate memory.
num_features = size(train, 2);
num_train_data = size(train,1);
num_test_data = size(test,1);
white_train = zeros(num_train_data, num_features);
white_test = zeros(num_test_data, num_features);

% One feature at at time.
for (feature_idx = 1:num_features)
  cur_data = train(:, feature_idx);
  
  % If you run into any nan values, ignore them while calculating mean and
  % standard deviation and warn. 
  bad_data = cur_data(isnan(cur_data));
  if(~isempty(bad_data))
    warning(['Some nans exist in your data at feature ' ...
             num2str(feature_idx)]);
  end
  clean_data = cur_data(~isnan(cur_data));
  
  % Calculate mean and standard deviation.
  feature_mean = mean(clean_data);
  feature_sdv = std(clean_data);

  % In this case, all feature values are the same. 
  if(feature_sdv == 0) 
    warning(['Standard deviation of feature ' num2str(feature_idx) ...
             ' is zero.']);
    feature_sdv = 1;
  end
  
  % Whiten data.
  white_train(:,feature_idx) = (train(:, feature_idx) - feature_mean) / ...
                               feature_sdv;
  white_test(:,feature_idx) = (test(:, feature_idx) - feature_mean) / ...
                               feature_sdv;
end

end

