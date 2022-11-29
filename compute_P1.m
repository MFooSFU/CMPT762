function P1 = compute_P1(E, K1)
% compute_P1 calculates the rotation and transform matrices from E via SVD
%   Args:
%       E: The essential matrix to be decomposed
%       K1: The intrinsic matrix for img1
%
%   Returns:
%       P1: The 3x4 projection matrix for img1
%       P2: The 3x4x4 projection matrices for img2
%

% W matrix taken from lecture 20. Assumed to be universal here.
W = [0 -1 0; 1 0 0; 0 0 1];

% ======================================================
% Step 1: Perform SVD on E to extract U and V matrices
% ======================================================
% Extract values from the SVD of E
[U, ~, V] = svd(E);

% ======================================================
% Step 2: Extract the two potential translations from U matrix
% ======================================================
T1 = U(:,3);  % One possible solution for the transform matrix
T2 = -U(:,3); % Second posible solution for the transform matrix

% ======================================================
% Step 3: Calculate the two potential rotation matrices
% ======================================================
R1 = U * W * transpose(V);  % One possible solution for the rotation matrix
R2 = U * transpose(W) * transpose(V); % Second possible solution for the rotation matrix

% ======================================================
% Step 4: Enforce conditions to choose correct solutions
% ======================================================
R = [];

% Forced to round because it causes the det check to fail.
det_R1 = round(det(R1), 3); % Round to 3 decimal points.
det_R2 = round(det(R2), 3); % Round to 3 decimal points.    
if abs(det_R1) == 1
    R = R1;
elseif abs(det_R2) == 1
    R = R2;
else
    disp("ERROR: No solution for the rotation matrix found.")
end

% ======================================================
% Step 5: Generate the P1 matrix from the chosen solutions
% ======================================================
% Use formula P = K[R|T]
KR = K1 * R;
KT = K1 * T2; % TODO: Figure out which T to use
P1 = [KR(1,:) KT(1,1); KR(2,:) KT(2,1); KR(3,:) KT(3,1)]; %TODO: Figure which T to use

% End function
end