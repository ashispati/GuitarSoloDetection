%% Code to Extract Features from the Audio Files
close all
clear all
clc

num_folds = 4;
accuracy = zeros(1,num_folds);
confmat = cell(1,num_folds);

for n = 1:num_folds
    % read training data
    fid = fopen(strcat('fold',num2str(n),'_train.txt'));
    tline = fgetl(fid);
    training_filenames = {};
    i = 1;
    while ischar(tline)
        a = strread(tline,'%s');
        training_filenames{i,1} = a{1};
        training_filenames{i,2} = a{2};
        switch a{2}(1:3)
            case 'bea'
                training_filenames{i,3} = 1;
            case 'bus'
                training_filenames{i,3} = 1;
            case 'caf'
                training_filenames{i,3} = 2;
            case 'car'
                training_filenames{i,3} = 1;
            case 'cit'
                training_filenames{i,3} = 1;
            case 'for'
                training_filenames{i,3} = 1;
            case 'gro'
                training_filenames{i,3} = 2;
            case 'hom'
                training_filenames{i,3} = 2;
            case 'lib'
                training_filenames{i,3} = 2;
            case 'met'
                training_filenames{i,3} = 2;
            case 'off'
                training_filenames{i,3} = 2;
            case 'par'
                training_filenames{i,3} = 1;
            case 'res'
                training_filenames{i,3} = 1;
            case 'tra'
                if strcmp(a{2}(1:4), 'trai') == 1
                    training_filenames{i,3} = 1;
                elseif strcmp(a{2}(1:4), 'tram') == 1
                    training_filenames{i,3} = 1;
                end
            otherwise
                training_filenames{i,3} = 0;
        end
        tline = fgetl(fid);
        i = i+1;
    end
    
    %% Read Training Data Files and Extract Features
    % specify parameters
    window_size = 1024;
    hop = 512;
    duration = 1; % texture window length in seconds
    feature_matrix = cell(length(training_filenames),2);
    for i = 1:length(training_filenames)
        filename = training_filenames{i,1}(7:end);
        [x, fs] = audioread(filename);
        if size(x,2) > 1
            x = mean(x, 2);
        end
        feature_matrix{i,1} = ComputerFeaturesForFile(x,window_size,hop,fs);
        len = GetLengthOfTextureWindow(fs, duration, hop);
        feature_matrix{i,1} = AggregateFeatureVector(feature_matrix{i,1},len);
        feature_matrix{i,2} = training_filenames{i,3};
        disp(strcat('Finished file: ',num2str(i)));
    end
    
    data_points_per_file = size(feature_matrix{1,1},2);
    num_features = size(feature_matrix{1,1},1);
    train_feat_mat = zeros(num_features+1, length(feature_matrix)*data_points_per_file);
    
    for i = 1:length(feature_matrix)
        train_feat_mat(1:num_features, (i-1)*data_points_per_file+1:i*data_points_per_file) = feature_matrix{i,1};
        train_feat_mat(end, (i-1)*data_points_per_file+1:i*data_points_per_file) = feature_matrix{i,2};
        
    end
    
    [train_feat_mat(1:num_features,:), feat_mean, feat_std] = ZScore(train_feat_mat(1:num_features,:)); % normalize feature vectors
    
    
    %% Train SVM Model
    train_features = train_feat_mat(1:num_features,:)';
    train_labels = train_feat_mat(end,:)';
    svm = svmtrain(train_labels, train_features, '-s 0 -t 2');
    
    
    %% Read Testing Data
    fid = fopen(strcat('fold',num2str(n),'_evaluate.txt'));
    tline = fgetl(fid);
    testing_filenames = {};
    i = 1;
    while ischar(tline)
        a = strread(tline,'%s');
        testing_filenames{i,1} = a{1};
        testing_filenames{i,2} = a{2};
        switch a{2}(1:3)
            case 'bea'
                testing_filenames{i,3} = 1;
            case 'bus'
                testing_filenames{i,3} = 1;
            case 'caf'
                testing_filenames{i,3} = 2;
            case 'car'
                testing_filenames{i,3} = 1;
            case 'cit'
                testing_filenames{i,3} = 1;
            case 'for'
                testing_filenames{i,3} = 1;
            case 'gro'
                testing_filenames{i,3} = 2;
            case 'hom'
                testing_filenames{i,3} = 2;
            case 'lib'
                testing_filenames{i,3} = 2;
            case 'met'
                testing_filenames{i,3} = 2;
            case 'off'
                testing_filenames{i,3} = 2;
            case 'par'
                testing_filenames{i,3} = 1;
            case 'res'
                testing_filenames{i,3} = 1;
            case 'tra'
                if strcmp(a{2}(1:4), 'trai') == 1
                    testing_filenames{i,3} = 1;
                elseif strcmp(a{2}(1:4), 'tram') == 1
                    testing_filenames{i,3} = 1;
                end
            otherwise
                testing_filenames{i,3} = 0;
        end
        tline = fgetl(fid);
        i = i+1;
    end
    
    %% Read Testing Data Files and Extract Features
    feature_matrix = cell(length(testing_filenames),2);
    for i = 1:length(testing_filenames)
        filename = testing_filenames{i,1}(7:end);
        [x, fs] = audioread(filename);
        if size(x,2) > 1
            x = mean(x, 2);
        end
        feature_matrix{i,1} = ComputerFeaturesForFile(x,window_size,hop,fs);
        len = GetLengthOfTextureWindow(fs, duration, hop);
        feature_matrix{i,1} = AggregateFeatureVector(feature_matrix{i,1},len);
        feature_matrix{i,2} = testing_filenames{i,3};
        disp(strcat('Finished file: ',num2str(i)));
    end
    
    data_points_per_file = size(feature_matrix{1,1},2);
    num_features = size(feature_matrix{1,1},1);
    test_feat_mat = zeros(num_features+1, length(feature_matrix)*data_points_per_file);
    
    for i = 1:length(feature_matrix)
        test_feat_mat(1:num_features, (i-1)*data_points_per_file+1:i*data_points_per_file) = feature_matrix{i,1};
        test_feat_mat(end, (i-1)*data_points_per_file+1:i*data_points_per_file) = feature_matrix{i,2};
        
    end
    
    test_feat_mat(1:num_features,:) = ZScore2(test_feat_mat(1:num_features,:), feat_mean, feat_std); % normalize feature vectors
    
    %% Test SVM Model
    test_features = test_feat_mat(1:num_features,:)';
    test_labels = test_feat_mat(end,:)';
    
    [predicted_labels] = svmpredict(test_labels, test_features, svm);
    accuracy(n) = sum(predicted_labels == test_labels) / length(test_labels);
    confmat{n} = confusionmat(test_labels, predicted_labels);
    
end

overall_accuracy = mean(accuracy);
overall_confmat = zeros(2,2);
for n = 1:num_folds
    overall_confmat = overall_confmat + confmat{n};
end
