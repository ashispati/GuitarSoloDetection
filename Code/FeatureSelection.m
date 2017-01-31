close all
clear all
clc

% load feature data
load('data.mat');
num_files = length(data);
num_features = size(data(1).feature_matrix,1);
num_class = 2;

%% split dataset into training and testing songs
num_folds = 4;
%fold_indices = crossvalind('KFold', num_files, num_folds);
fold_indices = zeros(num_files,1);
for j = 1:num_files
    fold_indices(j) = mod(j,num_folds);
end
fold_indices(fold_indices == 0) = num_folds;

%% feature selection
feature_set = [];
best_confmat_array = {};
accuracy_array =[];
feature_array = (1:num_features)';

for feed_for_idx = 1:num_features 
    next_best_accuracy = 0;
    next_best_feature = 0;
    next_best_conf_mat = [];
    
    for feat_idx = 1:num_features - feed_for_idx + 1
        % variables for storing output
        cum_conf_mat = zeros(num_class);
        num_files_processed = 1;
        svm_output  = struct('filename',{},'time_stamp',{},'predicted_label',{},'actual_label',{},'conf_mat',{});
        
        % n-fold cross validation
        for fold_idx = 1:4
            test_fold = fold_idx;
            test_indices = find(fold_indices == test_fold);
            train_indices = find(fold_indices ~= test_fold);
            
            %% training
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
            pruned_train_data = zeros(length(feature_set)+1, size(train_data,2));
            if ~isempty(feature_set)
                for i = 1:length(feature_set)
                    pruned_train_data(i,:) = train_data(feature_set(i),:);
                end
                pruned_train_data(end,:) = train_data(feature_array(feat_idx),:);
            else
                pruned_train_data = train_data(feat_idx,:);
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
                pruned_train_data(:,points2del(i)) = [];
            end
            % normalize training data
            [pruned_train_data, feat_mean, feat_std] = ZScore(pruned_train_data); % normalize feature vectors
            % train SVM Model
            svm = svmtrain(train_label', pruned_train_data', '-h 0 -t 2');
            
            
            %% testing
            test_files = length(test_indices);
            for i = 1:test_files
                test_data = data(test_indices(i)).feature_matrix;
                test_label = data(test_indices(i)).class_labels;
                time_stamp = data(test_indices(i)).time_stamp;
                % prune test data to contain only select features
                pruned_test_data = zeros(length(feature_set)+1, size(test_data,2));
                if ~isempty(feature_set)
                    for j = 1:length(feature_set)
                        pruned_test_data(j,:) = test_data(feature_set(j),:);
                    end
                    pruned_test_data(end,:) = test_data(feature_array(feat_idx),:);
                else
                    pruned_test_data = test_data(feat_idx,:);
                end
                
                % normalize testing data
                [pruned_test_data] = ZScore2(pruned_test_data, feat_mean, feat_std); % normalize feature vectors
                % test SVM Model
                [predicted_label] = svmpredict(test_label', pruned_test_data', svm);
                
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
        cum_accuracy = sum(diag(cum_conf_mat)) / sum(sum(cum_conf_mat));
        if cum_accuracy > next_best_accuracy
            next_best_accuracy = cum_accuracy;
            next_best_feature = feature_array(feat_idx);
            next_best_conf_mat = cum_conf_mat;
        end
        
    end
    if isempty(accuracy_array)
        check_accuracy = 0;
    else
        check_accuracy = accuracy_array(end);
    end
    best_con_mat_array{feed_for_idx} = next_best_conf_mat;
    accuracy_array = [accuracy_array, next_best_accuracy];
    feature_set = [feature_set, next_best_feature];
    feature_array(feature_array == next_best_feature) = [];
end

best_feature_set = feature_set;
save('selected_feature_set.mat', 'best_feature_set');
save('accuracy_curve.mat', 'accuracy_array');
figure; plot(accuracy_array);

