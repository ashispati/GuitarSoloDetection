
function grouped_activation = groupActivation(activation, time_stamp, thres)

%% Group Activation
% objective: group discontinous regions of a marker vector to form
% continous sections
%
% INPUTS
% activations: N x 1 binary array marker activations, 0 if no target, 1 if target 
% t: n x 1 array corresponding to the time stamps of the activation vector
% thres: minimum length in seconds of continuous region
%
% OUTPUTS
% auto_marking = N x 1 binary array, 0 is not target, 1 if target

non_zero_indices = find(activation);
grouped_activation = zeros(size(time_stamp));
if isempty(non_zero_indices) 
    return;
end
start_index(1) = non_zero_indices(1);
end_index(1) = non_zero_indices(end);
curr_index = non_zero_indices(1);

counter = 1;
for j = 2:length(non_zero_indices)
    if time_stamp(non_zero_indices(j)) - time_stamp(curr_index) < thres
        curr_index = non_zero_indices(j);
    else
        if time_stamp(curr_index) - time_stamp(start_index(counter)) >= thres
            end_index(counter) = curr_index;
            counter = counter+1;
            start_index(counter) = non_zero_indices(j);
            curr_index = non_zero_indices(j);
        else
            start_index(counter) = non_zero_indices(j);
            curr_index = non_zero_indices(j);
        end
    end
end

if (time_stamp(curr_index) - time_stamp(start_index(counter))) >= thres
    end_index(counter) = curr_index;
end

if length(start_index) ~= length(end_index)
    start_index = start_index(1:end-1);
end


if start_index(end) == end_index(end)
    display('No targets found');
    grouped_activation = activation;
else
    for j = 1:length(start_index)
        % Uncomment for debugging
        %{
        start_sec = t(start_index(j));
        m_start = floor(start_sec/60);
        s_start = start_sec - m_start*60;
        end_sec = t(end_index(j));
        m_end = floor(end_sec/60);
        s_end = end_sec - m_end*60;
        start_time = strcat( num2str(m_start),':',num2str(s_start) ); 
        end_time = strcat( num2str(m_end),':',num2str(s_end) );
        %}
        grouped_activation(start_index(j):end_index(j)) = 1;
    end
end

end