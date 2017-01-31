close all
clear all
clc

% load feature data
load('data_old.mat');
num_files = length(data);
num_features = size(data(1).feature_matrix,1);

%% split dataset into training and testing songs
num_folds = 4;
%fold_indices = crossvalind('KFold', num_files, num_folds);
fold_indices = zeros(num_files,1);
for j = 1:num_files
    fold_indices(j) = mod(j,num_folds);
end
fold_indices(fold_indices==0) = num_folds;


%% Variables for storing output
cum_conf_mat = zeros(2,2);
num_files_processed = 1;
svm_output  = struct('filename',{},'time_stamp',{},'predicted_label',{},'actual_label',{},'conf_mat',{});

%% N-Fold Cross Validation

for fold_idx = 1:4
    
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
        train_data(:,points2del(i)) = [];
    end
    
    % normalize training data
    [train_data, feat_mean, feat_std] = ZScore(train_data); % normalize feature vectors
    
    % train SVM Model
    svm = svmtrain(train_label', train_data', '-h 0 -t 2');
    
    %% Testing
    
    % collate testing data
    test_files = length(test_indices);   
    for i = 1:test_files
        test_data = data(test_indices(i)).feature_matrix;
        test_label = data(test_indices(i)).class_labels;
        time_stamp = data(test_indices(i)).time_stamp;
        
        % normalize testing data
        [test_data] = ZScore2(test_data, feat_mean, feat_std); % normalize feature vectors
        % test SVM Model
        [predicted_label] = svmpredict(test_label', test_data', svm);
        
        % collate SVM predictions
        %predicted_label = groupActivation(predicted_label, time_stamp, 3);
        
        % assign outputs
        svm_output(num_files_processed).filename = data(test_indices(i)).filename;
        svm_output(num_files_processed).time_stamp = data(test_indices(i)).time_stamp;
        svm_output(num_files_processed).predicted_label = predicted_label;
        svm_output(num_files_processed).actual_label = test_label';
        svm_output(num_files_processed).conf_mat = confusionmat(test_label',predicted_label);
        
        cum_conf_mat = cum_conf_mat + svm_output(num_files_processed).conf_mat;
        num_files_processed = num_files_processed + 1;
    end
    
end

cum_accuracy = sum(diag(cum_conf_mat)) / sum(sum(cum_conf_mat))