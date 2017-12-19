%% script to generate dataset statistics

% read file names
anno_dir = '../Dataset/Annotations/';
song_dir = '../Dataset/Songs/';
cd(song_dir);
filenames = dir('*.mp3');
cd('../../Code');

cum_solo_lengths = zeros(length(filenames),1);
solo_seg_length_norm = [];
solo_seg_length = [];
cum_song_length = 0;

for i = 1:length(filenames)
    
    filename = strcat(song_dir, filenames(i).name);
    [x, fs] = audioread(filename);
    if size(x,2) > 1
        x = mean(x, 2);
    end
    
    song_length_secs = length(x) / fs;
    
    anno_name = strcat(anno_dir,filenames(i).name(1:end-4),'_segment.txt');
    annotation = dlmread(anno_name);
    solo_len_secs = 0;
    for num_seg = 1:size(annotation,1)
        solo_len_secs = solo_len_secs + annotation(num_seg,3);
        solo_seg_length_norm = [solo_seg_length_norm, ...
            annotation(num_seg,3)/song_length_secs];
        solo_seg_length = [solo_seg_length,...
            annotation(num_seg,3)];
    end
    
    cum_solo_lengths(i) = solo_len_secs / song_length_secs;
    
    cum_song_length = cum_song_length + song_length_secs; 
    
    disp(i);
end
