function pts3d = triangulate(P1, pts1, P2, pts2 )
% triangulate estimate the 3D positions of points from 2d correspondence
%   Args:
%       P1:     projection matrix with shape 3 x 4 for image 1
%       pts1:   coordinates of points with shape N x 2 on image 1
%       P2:     projection matrix with shape 3 x 4 for image 2
%       pts2:   coordinates of points with shape N x 2 on image 2
%
%   Returns:
%       Pts3d:  coordinates of 3D points with shape N x 3
%

% Note: Made P2 argument to pass in all 4 candidate matrices.

% Init data structures
x1_pt = [];
x2_pt = [];
x_hat_pt1 = [];
E = [];
pts3d = [];

% Declare some placeholder structures.
P1_temp = [];
P2_temp = [];

% Start loop to populate the output pts3d points
% Caveat: This assumes pts1 and pts2 have same # of rows
[num_rows, ~] = size(pts1);

% Start TRIANGULATION process
% Main loop for the calculations
for N = 1 :  num_rows
    % Reset args
    num_matches = 0;     % use to count how many matches per matrix
    max_num_matches = 0; % use this for comparison
    P2_temp_matrix = [];
    pts_out = [];

    % Generate the 3D point from pts1
    x1 = pts1(N,1); % just for simplified notation
    y1 = pts1(N,2); % just for simplified notation
    P1_temp = [((x1 * P1(3,:)) - P1(1,:)) ; ((y1 * P1(3,:)) - P1(2,:))];
    [~, ~, v] = svd(P1_temp); % use SVD to get the 3D pt
    [~, y] = find(v == min(min(v)));
    v_vect = v(:,y);
    x_hat_pt1 = [v_vect(1,1)/v_vect(4,1) ; v_vect(2,1)/v_vect(4,1) ; v_vect(3,1)/v_vect(4,1)];

    % Generate the 3D point candidates from pts2
    x2 = pts2(N,1); % just for simplified notation
    y2 = pts2(N,2); % just for simplified notation
    P2_temp = [(x2 * P2(3,:) - P2(1,:)) ; ((y2 * P2(3,:)) - P2(2,:))];
    [~, ~, v] = svd(P2_temp); % use SVD to get the 3D pt
    [~, y] = find(v == min(min(v)));
    v_vect = v(:,y);
    x_hat_pt2 = [v_vect(1,1)/v_vect(4,1) ; v_vect(2,1)/v_vect(4,1) ; v_vect(3,1)/v_vect(4,1)];
        
    pts_out = [x_hat_pt2(1,1) x_hat_pt2(2,1) x_hat_pt2(3,1)];

    % Append point to points list
    pts3d = [pts3d; pts_out];
end

assignin('base', 'num_matches', num_matches);

% End of function
end