
function dilated_image = dilate(image, mask)

%% Dilate Image
% objective: dilates the input image with a given mask, connects discontinous
% regions
%
% INPUTS
% image: M x Ninput binary image
% mask:  m x n mask with which the filtering is to be done
%
% OUTPUTS
% dilated_image: M x N binary dilated image

dilated_image = conv2(image, mask, 'same');
dilated_image = dilated_image + .001 >= 1;

end