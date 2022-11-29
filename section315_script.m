% Section 3.1.5 script
% Tidy things up
clear all

% Load in data and variables we need to use
im1 = imread("../data/im1.png");
im2 = imread("../data/im2.png");
I1 = im1;  % Just a simple rename
I2 = im2;  % Just a simple rename
load("../data/someCorresp.mat") % Data for Part 3.1.1
load("../data/intrinsics.mat")  % Data for Part 3.1.3

% Part 3.1.1
%F = eightpoint(pts1, pts2, M); % Saves the fundamental matrix.
F = estimateFundamentalMatrix(pts1,pts2); % For debug

% Part 3.1.2
clear pts1 pts2 % Make way for the new points
load("../data/templeCoords.mat")
[pts2] = epipolarCorrespondence(im1, im2, F, pts1); % Saves list of pts2

% Part 3.1.3
E = essentialMatrix(F, K1, K2);

% Part 3.1.4
% 3.1.4.1 (informal): Compute P1
P1 = compute_P1(E, K1); 
P1 = K1 * P1;

% 3.1.4.2 (informal): Generate the 4 candidate P2 matrices and test
candidate_P2 = camera2(E); % Get list of candidate matrices


load("../data/intrinsics.mat")
trianglulate_num_matches = [];
all_pts3d = [];
for i = 1 : 4
    P2 = K2*candidate_P2(:,:,i);
    pts3d = triangulate(P1, pts1, P2, pts2);
    trianglulate_num_matches = [trianglulate_num_matches num_matches];
    all_pts3d = [all_pts3d pts3d];
end

candidate_P2_mat_1 = all_pts3d(:,1:3);
candidate_P2_mat_2 = all_pts3d(:,4:6);
candidate_P2_mat_3 = all_pts3d(:,7:9);
candidate_P2_mat_4 = all_pts3d(:,10:12);

% Run a depth check