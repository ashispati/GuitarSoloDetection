function midi_pitch = GetMidiPitch(pred_pitch)
    midi_pitch = 69 + 12*log2(pred_pitch./440);
    midi_pitch(midi_pitch == -inf) = 0;
    
    
    
    %f_log = log2(pred_pitch);
    %f_log(f_log == -inf) = 0;
%    f_log_nonzero = f_log(f_log ~= 0);
    %f_log_mod = mod(f_log, 1/12);
%   f_hist = hist(f_log_mod,100);
%   [~, max_bin] = max(f_hist);
%   f_log_ref = (max_bin - 1)/1200 - 0.5;
%     f_adj = f_log;
%     for i = 1:N
%         if f_log(i) ~= 0;
%             f_adj(i) = mod(f_adj(i) - f_log_ref,1/12);
%         end
%     end
%     
%     f_adj = smooth(f_adj,300);
    %midi_pitch = f_log_mod;
    
%     pitch_fluctuation = zeros(size(pred_pitch));
%     for i = 1:N
%         w = hamming(50);
%         w = w / sum(w);
%         u = 0;
%         for k = 1:50
%             if or(i + k -25 <= 0, i + k - 25 > N)
%                 f = 0;
%             else
%                 f = f_adj(i + k - 25);
%             end
%             u = u + w(k) * f;
%         end
%         
%         for k = 1:50
%             if or(i + k -25 <= 0, i + k - 25 > N)
%                 f = 0;
%             else
%                 f = f_adj(i + k - 25);
%             end
%             pitch_fluctuation(i) = pitch_fluctuation(i) + w(k)*(f-u)*(f-u);
%         end
%         pitch_fluctuation(i) = 12*sqrt(pitch_fluctuation(i)); 
%     end
    
    
end