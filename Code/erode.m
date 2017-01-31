
function eroded_image = erode(image, mask)

%% Erode Image
% objective: erode the input image with a given mask, splits weakly connnected
% regions
%
% INPUTS
% image: M x Ninput binary image
% mask:  m x n mask with which the filtering is to be done
%
% OUTPUTS
% dilated_image: M x N binary eroded image 

num_elements = sum(mask(:));
mask = mask / num_elements;
eroded_image = conv2(image, mask, 'same');
eroded_image = fix(eroded_image+0.001) == 1;

end