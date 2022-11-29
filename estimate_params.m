function [K, R, t] = estimate_params(P)
% estimate_params:
% Purpose: To estimate the camera matrix properties
%   Args:
%       x: 2xN matrix for points on the 2D image
%       X: 3xN matrix for points on the 3D image
%   Returns:
%       K: The intrinsic matrix for the camera
%       R: The rotation matrix for the camera
%       t: The translation matrix for the camera
