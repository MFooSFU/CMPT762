function P = estimate_pose(x, X)
% estimate_pose:
% Purpose: To estimate the camera matrix using DLT
%   Args:
%       x: 2xN matrix for points on the 2D image
%       X: 3xN matrix for points on the 3D image
%   Returns:
%       P: The estimated camera matrix
%
