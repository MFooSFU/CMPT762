function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.

% Assume that for im1 & im2 the img read was already completed.
% Turn them into grayscale
img1 = im2gray(im1);
img2 = im2gray(im2);

% Use the disparityMap function to get the disparity map
dispM = disparityBM(img1, img2, "DisparityRange", [0 maxDisp], "BlockSize", windowSize);

% End of function
end