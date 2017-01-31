close all;
clear all;
clc;

%% read file names
cd('../Dataset/Songs');
filenames = dir('*.mp3');
cd('../../Code');

%% initialize parameters
num_files = length(filenames);
song_folder = '../Dataset/Songs/';
output_folder = '../Dataset/Segments/';

inputfile = strcat(song_folder, filenames(1).name);
out_name = strcat(filenames(1).name(1:end-4), '.txt');
outputfile = strcat(output_folder,out_name);

% TODO : find a way to resolve the environment issue