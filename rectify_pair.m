function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = ...
                        rectify_pair(K1, K2, R1, R2, t1, t2)
% RECTIFY_PAIR takes left and right camera paramters (K, R, T) and returns left
%   and right rectification matrices (M1, M2) and updated camera parameters. You
%   can test your function using the provided script q4rectify.m

% Start the RECTIFY PAIR process
% ======================================================
% Step 1: Calculate the camera centres
% ======================================================
c1 = -inv(K1 * R1)*(K1 * t1);
c2 = -inv(K2 * R2)*(K2 * t2);

% ======================================================
% Step 2: Compute the new rotation matrices
% ======================================================
% Compute the new x-axes
x1n = (c2 - c1)/abs(c2 - c1);
x2n = (c2 - c1)/abs(c2 - c1);

% Compute the new y-axes
y1n = cross(R1(:,3), x1n);
y2n = cross(R2(:,3). x2n);

% Compute the new z-axes
z1n = cross(y1n, x1n);
z2n = cross(y2n, x2n);

% Combine the elements to construct the rotation matrices
R1n = [x1n y1n z1n];
R2n = [x2n y2n z2n];

% ======================================================
% Step 3: Compute the new intrinsic parameter
% ======================================================
% Not really needed since we reuse the K args

% ======================================================
% Step 4: Compute the new translation matrix
% ======================================================
t1n = -R1n * c1;
t2n = -R2n * c2;

% ======================================================
% Step 5: Compute the rectification matrix
% ======================================================
M1 = (K1 * R1n) * inv(K1 * R1);
M2 = (K2 * R2n) * inv(K2 * R2);

% Take the SVD of R1
[U1, S1, V1] = svd(R1);

% Take the SVD of R2
[U2, S2, v2] = svd(R2);

% End of function
end