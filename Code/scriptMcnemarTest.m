%% script to run McNemar significance test on results

close all 
clear all
clc

load('svm_output_B.mat');

pred_label_B = [];
actual_label = [];
for i = 1:length(svm_output)
    pred_label_B = [pred_label_B; svm_output(i).predicted_label];
    actual_label = [actual_label; svm_output(i).actual_label];
end

clear('svm_output');
load('svm_output_BP.mat');
pred_label_BP = [];
for i = 1:length(svm_output)
    pred_label_BP = [pred_label_BP; svm_output(i).predicted_label];
end

clear('svm_output');
load('svm_output_BS.mat');
pred_label_BS = [];
for i = 1:length(svm_output)
    pred_label_BS = [pred_label_BS; svm_output(i).predicted_label];
end

clear('svm_output');
load('svm_output_BSP.mat');
pred_label_BSP = [];
for i = 1:length(svm_output)
    pred_label_BSP = [pred_label_BSP; svm_output(i).predicted_label];
end

clear('svm_output');
load('svm_output_BSP_PP.mat');
pred_label_BSP_PP = [];
for i = 1:length(svm_output)
    if size(svm_output(i).predicted_label,2) > 1
        svm_output(i).predicted_label  = svm_output(i).predicted_label';
    end
    pred_label_BSP_PP = [pred_label_BSP_PP; svm_output(i).predicted_label];
end


[h, p, e1, e2] = testcholdout(pred_label_BP, pred_label_B, actual_label,...
    'Alternative', 'greater', 'Test', 'asymptotic');

[h, p, e1, e2] = testcholdout(pred_label_BS, pred_label_B, actual_label,...
    'Alternative', 'greater', 'Test', 'asymptotic');

[h, p, e1, e2] = testcholdout(pred_label_BSP, pred_label_B, actual_label,...
    'Alternative', 'greater', 'Test', 'asymptotic');

[h, p, e1, e2] = testcholdout(pred_label_BSP_PP, pred_label_B, actual_label,...
    'Alternative', 'greater', 'Test', 'asymptotic');

[h, p, e1, e2] = testcholdout(pred_label_BSP, pred_label_BS, actual_label,...
    'Alternative', 'greater', 'Test', 'asymptotic');

[h, p, e1, e2] = testcholdout(pred_label_BSP, pred_label_BP, actual_label,...
    'Alternative', 'greater', 'Test', 'asymptotic');

[h, p, e1, e2] = testcholdout(pred_label_BSP_PP, pred_label_BSP, actual_label,...
    'Alternative', 'greater', 'Test', 'asymptotic');
