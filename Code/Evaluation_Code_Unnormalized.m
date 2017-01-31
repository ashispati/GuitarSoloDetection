close all
clear all
clc

% load feature data
load('data_old.mat');
num_files = length(data);
num_features = size(data(1).feature_matrix,1);

%% Training

% collate training data
train_files = ceil(0.6*num_files);
train_size = 0;
for i = 1:train_files
    train_size = train_size + length(data(i).class_labels);
end

train_data = zeros(num_features, train_size);
train_label = zeros(1, train_size);
idx = 1;
for i = 1:train_files
    num_col = length(data(i).class_labels);
    train_data(:,idx:idx+num_col-1) = data(i).feature_matrix;
    train_label(1,idx:idx+num_col-1) = data(i).class_labels;
    idx = idx + num_col;
end

% normalize training data
[train_data, feat_mean, feat_std] = ZScore(train_data); % normalize feature vectors

% Train SVM Model
svm = svmtrain(train_label', train_data', '-s 0 -t 2');

%% Testing

% collate testing data
test_files = num_files - train_files;
test_size = 0;
for i = train_files+1 : train_files + test_files
    test_size = test_size + length(data(i).class_labels);
end

test_data = zeros(num_features, test_size);
test_label = zeros(1, test_size);
idx = 1;
for i = train_files+1 : train_files + test_files
    num_col = length(data(i).class_labels);
    test_data(:,idx:idx+num_col-1) = data(i).feature_matrix;
    test_label(1,idx:idx+num_col-1) = data(i).class_labels;
    idx = idx + num_col;
end

% normalize testing data
[test_data] = ZScore2(test_data, feat_mean, feat_std); % normalize feature vectors

% Train SVM Model
[predicted_label] = svmpredict(test_label', test_data', svm);
