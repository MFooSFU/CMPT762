function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'


% Start EIGHT-POINT Algorithm
% ======================================================
% Step 0: Normalize points
% ======================================================
% Get the total number of points for the loop
[num_pts, ~] = size(pts1);

for i = 1 : num_pts
    for j = 1 : 2
        pts1(i, j) = pts1(i, j) / M;
        pts2(i, j) = pts2(i, j) / M;
    end
end


% ======================================================
% Step 1: Populate the A matrix (assume that the # of rows are the same)
% ======================================================
[num_rows, ~] = size(pts1);

A_matrix = [];

% Loop to populate the A matrix rows
for i = 1 : num_rows
    % Get the points
    x1 = pts1(i, 1);
    y1 = pts1(i, 2);
    x2 = pts2(i, 1);
    y2 = pts2(i, 2);

    % Calculate the matrix values
    x1x2 = x1 * x2;
    y1x2 = y1 * x2;
    x1y2 = x1 * y2;
    y1y2 = y1 * y2;

    % Generate the matrix row and append to A_matrix
    A_matrix = [A_matrix ; x1x2 y1x2 x2 x1y2 y1y2 y2 x1 y1 1];
end

% ======================================================
% Step 2: Calculate the SVD for the A matrix
% ======================================================
[~, ~, V_0] = svd(A_matrix);
%[~, ~, V_0] = svd(A_matrix' * A_matrix);

% ======================================================
% Step 3: Create the F matrix
% ======================================================
[~, min_value_col] = find(V_0 == min(min(V_0)));
V_in = V_0(:, min_value_col);
F_0 = reshape(V_in,[3,3]); % Not the true F matrix

% ======================================================
% Step 4: Enforce rank constraints
% ======================================================
% Force the matrix F to be rank 2 (rank 3 by default)
% Take the SVD for F
[U, S, V_1] = svd(F_0);

% Containers for brute force way of solving it
S_container = S; % Just a way to get the 2 max values from the S matrix
S_prime = zeros(size(S));

% Loop to get the max 2 values
for k = 1 : 2
    [x, y] = find(S_container == max(max(S_container)));
    S_prime(x, y) = max(max(S_container));
    S_container(x, y) = 0;
end

% Calculate the F matrix using the S' matrix
F_1 = U * S_prime * V_1;
F_1 = refineF(F_1, pts1, pts2);

% ======================================================
% Step 5: Unscale F
% ======================================================
F = M * F_1;

% End of function
end
