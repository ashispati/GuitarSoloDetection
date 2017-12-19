%% script to run Cross Validation evaluation test

close all
clear all
clc

addpath('PostProcessing/');
addpath('Utils/');

% load feature data
load('data_60_seg_pitch.mat'); % change this for different feature combination
num_features = size(data(1).feature_matrix,1);
start_feature = 1;
feature_set = start_feature:num_features;
length_optimal_feature_set = length(feature_set);
num_files = length(data);
num_features = size(data(1).feature_matrix,1);

%% split dataset into training and testing songs
num_folds = 10;
%fold_indices = crossvalind('KFold', num_files, num_folds);
fold_indices = zeros(num_files,1);
for j = 1:num_files
    fold_indices(j) = mod(j,num_folds);
end
fold_indices(fold_indices==0) = num_folds;


%% Variables for storing output
cum_conf_mat = zeros(2,2);
num_files_processed = 1;
svm_output  = struct('filename',{},'time_stamp',{},'predicted_label',{},...
    'actual_label',{},'conf_mat',{},'solo_accuracy',{},'nonsolo_accuracy',{},...
    'macro_accuracy',{},'micro_accuracy',{}, 'r1_accuracy',{},...
    'precision',{},'recall',{},'specificity',{});

%% N-Fold Cross Validation

for fold_idx = 1:num_folds
    
    test_fold = fold_idx;
    test_indices = find(fold_indices == test_fold);
    train_indices = find(fold_indices ~= test_fold);
    
    %% Training
    % collate training data
    train_files = length(train_indices);
    train_size = 0;
    for i = 1:train_files
        train_size = train_size + length(data(train_indices(i)).class_labels);
    end
    
    train_data = zeros(num_features, train_size);
    train_label = zeros(1, train_size);
    idx = 1;
    for i = 1:train_files
        num_col = length(data(train_indices(i)).class_labels);
        train_data(:,idx:idx+num_col-1) = data(train_indices(i)).feature_matrix;
        train_label(1,idx:idx+num_col-1) = data(train_indices(i)).class_labels;
        idx = idx + num_col;
    end
    
    % prune train data to contain only selected features
    pruned_train_data = zeros(length_optimal_feature_set, size(train_data,2));
    for i = 1:size(pruned_train_data,1)
        pruned_train_data(i,:) = train_data(feature_set(i),:);
    end
    %pruned_train_data = [pruned_train_data; train_data(37,:)];
    % adjust training data to ensure equal class distribution
    num_non_solos = sum(train_label(:) == 0);
    num_solos = sum(train_label(:) == 1);
    % sanity check
    if num_solos + num_non_solos ~= train_size
        err ('ERROR in train class labels');
    end
    if num_solos < num_non_solos
        num2del = num_non_solos - num_solos;
        non_solo_ind = find(train_label == 0);
        points2del = datasample(non_solo_ind, num2del, 'Replace',false);
    elseif num_solos > num_non_solos
        num2del = num_solos - num_non_solos;
        solo_ind = find(train_label == 1);
        points2del = datasample(solo_ind, num2del, 'Replace',false);
    end
    points2del = sort(points2del,2,'descend');
    for i = 1:length(points2del)
        train_label(points2del(i)) = [];
        pruned_train_data(:,points2del(i)) = [];
    end
    
    % normalize training data
    [pruned_train_data, feat_mean, feat_std] = ZScore(pruned_train_data); % normalize feature vectors
    
    % train SVM Model
    svm = svmtrain(train_label', pruned_train_data', '-h 0 -t 2');
    
    %% Testing
    
    % collate testing data
    test_files = length(test_indices);   
    for i = 1:test_files
        test_data = data(test_indices(i)).feature_matrix;
        test_label = data(test_indices(i)).class_labels;
        time_stamp = data(test_indices(i)).time_stamp;
        
        % prune train data to contain only selected features
        pruned_test_data = zeros(length_optimal_feature_set, size(test_data,2));
        for j = 1:size(pruned_test_data,1)
            pruned_test_data(j,:) = test_data(feature_set(j),:);
        end
        %pruned_test_data = [pruned_test_data; test_data(37,:)];
        % normalize testing data
        [pruned_test_data] = ZScore2(pruned_test_data, feat_mean, feat_std); % normalize feature vectors
        % test SVM Model
        [predicted_label] = svmpredict(test_label', pruned_test_data', svm);
        
        % collate SVM predictions
        
        
        mask = ones(3,1);
        predicted_label = +Dilate(predicted_label, mask);
        mask = ones(3,1);
        predicted_label = +Erode(predicted_label, mask);
        
        predicted_label = GroupActivation(predicted_label, time_stamp, 4);
        
        
        % assign outputs
        svm_output(num_files_processed).filename = data(test_indices(i)).filename;
        svm_output(num_files_processed).time_stamp = data(test_indices(i)).time_stamp;
        svm_output(num_files_processed).predicted_label = predicted_label;
        svm_output(num_files_processed).actual_label = test_label';
        svm_output(num_files_processed).conf_mat = confusionmat(test_label',predicted_label);
        conf_mat = svm_output(num_files_processed).conf_mat;
        sum_conf_mat = sum(conf_mat,2);
        svm_output(num_files_processed).nonsolo_accuracy = conf_mat(1,1) / sum_conf_mat(1);
        svm_output(num_files_processed).solo_accuracy = conf_mat(2,2) / sum_conf_mat(2);
        svm_output(num_files_processed).macro_accuracy = (svm_output(num_files_processed).solo_accuracy + svm_output(num_files_processed).nonsolo_accuracy) / 2;
        svm_output(num_files_processed).micro_accuracy = sum(diag(conf_mat)) / sum(sum(conf_mat));
        svm_output(num_files_processed).precision = conf_mat(2,2) / (conf_mat(2,2) + conf_mat(1,2));
        svm_output(num_files_processed).recall = conf_mat(2,2) / (conf_mat(2,2) + conf_mat(2,1));
        svm_output(num_files_processed).specificity = conf_mat(1,1) / (conf_mat(1,1) + conf_mat(1,2));
        
        r1_conf_mat = confusionmat(test_label',zeros(size(predicted_label)));
        sum_r1_conf_mat = sum(r1_conf_mat,2);
        svm_output(num_files_processed).r1_micro_accuracy = sum(diag(r1_conf_mat)) / sum(sum(r1_conf_mat));
        svm_output(num_files_processed).r1_macro_accuracy = (r1_conf_mat(1,1) / sum_r1_conf_mat(1) + r1_conf_mat(2,2) / sum_r1_conf_mat(2))/2;
        svm_output(num_files_processed).r1_precision = r1_conf_mat(2,2) / (r1_conf_mat(2,2) + r1_conf_mat(1,2));
        svm_output(num_files_processed).r1_recall = r1_conf_mat(2,2) / (r1_conf_mat(2,2) + r1_conf_mat(2,1));
        svm_output(num_files_processed).r1_specificity = r1_conf_mat(1,1) / (r1_conf_mat(1,1) + r1_conf_mat(1,2));
        
        cum_conf_mat = cum_conf_mat + svm_output(num_files_processed).conf_mat;
        num_files_processed = num_files_processed + 1;
    end
    
end

avg_macro_accuracy = 0;
avg_micro_accuracy = 0;
avg_solo_accuracy = 0;
precision = 0;
recall = 0;
specificity = 0;
avg_nonsolo_accuracy = 0;
avg_r1_micro_accuracy = 0;
avg_r1_macro_accuracy = 0;
r1_precision = 0;
r1_recall = 0;
r1_specificity = 0;
for i = 1:length(svm_output)
    avg_solo_accuracy = avg_solo_accuracy + svm_output(i).solo_accuracy;
    avg_nonsolo_accuracy = avg_nonsolo_accuracy + svm_output(i).nonsolo_accuracy;
    avg_macro_accuracy = avg_macro_accuracy + svm_output(i).macro_accuracy;
    avg_micro_accuracy = avg_micro_accuracy + svm_output(i).micro_accuracy;
    if ~isnan(svm_output(i).precision)
        precision = precision + svm_output(i).precision;
    end
    recall = recall + svm_output(i).recall;
    specificity = specificity + svm_output(i).specificity;
    
    avg_r1_micro_accuracy = avg_r1_micro_accuracy + svm_output(i).r1_micro_accuracy;
    avg_r1_macro_accuracy = avg_r1_macro_accuracy + svm_output(i).r1_macro_accuracy;
    if ~isnan(svm_output(i).r1_precision)
        r1_precision = r1_precision + svm_output(i).r1_precision;
    end
    r1_recall = r1_recall + svm_output(i).r1_recall;
    r1_specificity = r1_specificity + svm_output(i).r1_specificity;
    
end
%avg_solo_accuracy = avg_solo_accuracy / length(svm_output)
%avg_nonsolo_accuracy = avg_nonsolo_accuracy / length(svm_output)
avg_micro_accuracy = avg_micro_accuracy / length(svm_output)
avg_macro_accuracy = avg_macro_accuracy / length(svm_output)
precision = precision / length(svm_output)
recall = recall / length(svm_output)
specificity = specificity / length(svm_output)
%avg_r1_micro_accuracy = avg_r1_micro_accuracy / length(svm_output)
%avg_r1_macro_accuracy = avg_r1_macro_accuracy / length(svm_output)
%r1_precision = r1_precision / length(svm_output)
%r1_recall = r1_recall / length(svm_output)
%r1_specificity = r1_specificity / length(svm_output)

cum_macro_accuracy = [];
cum_micro_accuracy = [];
cum_precision = [];
cum_recall = [];
cum_specificity = [];
for i = 1:length(svm_output) 
    cum_macro_accuracy = [cum_macro_accuracy; svm_output(i).macro_accuracy];
    cum_micro_accuracy = [cum_micro_accuracy; svm_output(i).micro_accuracy];
    cum_precision = [cum_precision; svm_output(i).precision];
    cum_recall = [cum_recall; svm_output(i).recall];
    cum_specificity = [cum_specificity; svm_output(i).specificity];
end
cum_precision(isnan(cum_precision)) = 0;
cum_macro_accuracy = reshape(cum_macro_accuracy, 6, 10);
cum_micro_accuracy = reshape(cum_micro_accuracy, 6, 10);
cum_precision = reshape(cum_precision, 6, 10);
cum_recall = reshape(cum_recall, 6, 10);
cum_specificity = reshape(cum_specificity, 6, 10);

fold_m = mean(cum_micro_accuracy);
fold_M = mean(cum_macro_accuracy);
fold_p = mean(cum_precision);
fold_r = mean(cum_recall);
fold_S = mean(cum_specificity);

std_m = std(fold_m);
std_M = std(fold_M);
std_p = std(fold_p);
std_r = std(fold_r);
std_S = std(fold_S);

rmpath('PostProcessing/');
rmpath('Utils/');
