
labels = [];
locations = [];

for i = 1:length(data)
    labels = [labels, data(i).class_labels];
    location = data(i).time_stamp / data(i).time_stamp(end);
    locations = [locations, location];
    
end