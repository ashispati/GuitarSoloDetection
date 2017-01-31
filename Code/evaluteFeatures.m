close all;
clear all;
clc;

load 'feat_mat.mat';
load 'labels.mat';

num_features = size(feat_mat{1},1);
num_dataperfile = size(feat_mat{1},2);
num_datapoints = size(feat_mat,2)*num_dataperfile;
featMat = zeros(num_features, num_datapoints);
classLabel = zeros(1,num_datapoints);
for i = 1:size(feat_mat,2)
    featMat(:, num_dataperfile*(i-1)+1 : num_dataperfile*i) = feat_mat{i};
    classLabel(1,num_dataperfile*(i-1)+1 : num_dataperfile*i) = labels;
end

% Preallocate memory.
num_folds = 10;
featMat = featMat';
classLabel = classLabel';
num_data = size(classLabel, 1);

% Proportional distributions of classes among folds.
folds = cvpartition(classLabel, 'KFold', num_folds);

acc = zeros(num_folds,1);
for fold = 1:num_folds
    % Grab the test data.
    test_indices = folds.test(fold);
    test_labels = classLabel(test_indices, :);
    test_features = featMat(test_indices, :);
    
    % Get training data.
    train_indices = folds.training(fold);
    train_labels = classLabel(train_indices, :);
    train_features = featMat(train_indices, :);
    
    % Zero-cross whitening.
    [train_features, test_features] = whiten(train_features, test_features);
    
    % Train the classifier and get predictions for the current fold.
    svm = svmtrain(train_features,train_labels);
    cur_predictions = svmclassify(svm, test_features);
    
    acc(fold)=sum(cur_predictions==test_labels)/length(test_labels);
end




