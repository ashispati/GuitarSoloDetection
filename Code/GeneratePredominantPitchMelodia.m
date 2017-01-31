close all
clear all
clc

exec_path = '/Users/Som/GitHub/essentia/build/src/examples/essentia_streaming_predominantpitchmelodia';
arg1 = ' /Users/Som/Desktop/Georgia\ Tech\ Acads/3rd\ Sem/MUSI\ 7100\ AL/Dataset/Songs/New/';
arg2 = ' /Users/Som/Desktop/Georgia\ Tech\ Acads/3rd\ Sem/MUSI\ 7100\ AL/Dataset/Pitch/';

cd('../Dataset/Songs');
filenames = dir('*.mp3');

for i = 1:length(filenames)
    song_filename = filenames(i).name;
    txt_filename = song_filename(1:end-4);
    txt_filename = strcat(txt_filename,'.txt');
    
    song_path = strcat(arg1,song_filename);
    txt_path = strcat(arg2,txt_filename);
    
    command = strcat(exec_path, song_path, txt_path);
    
    system(command,'-echo');
    
end

cd('../../Code');

