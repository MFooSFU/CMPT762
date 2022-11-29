function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%

% Start GETTING EPIPOLAR CORRESPONDENCE process
% Transform pts2
[num_pts, ~] = size(pts1);
epipoloar_line = [];
pts2 = [];


% Loop to populate the number of points on pts2
for i = 1 : num_pts
    dims = 10;  % The dimensions for the windows (10 x 10)

    % For each point in pts1, take 5 sample points and compute simliarity
    r_out = [];
    x_stats = [];
    x_prime = 0;
    y_prime = 0;

    % Loop to generate candidate points
    for j = 1 : 5
        % Define loop variables
        distance = 0;
        x1_val = pts1(i,1);
        y1_val = pts1(i,2);
        x1_min = pts1(i,1) - dims;
        x1_max = pts1(i,1) + dims;
        a = x1_min;
        b = x1_max;
        
        % Calculate the range of values for x
        x2_val = (b-a).*randi(1,1) + a; % Take a random X-coordinate

        % Calculate [a b c] for epipolar line. Formula is ax + by + c = 0
        % Restructure the formula to  y = -(a/b) * x - (c/b)
        epipolar_line = F * [pts1(i, 1); pts1(i, 2); 1];

        a = epipolar_line(1,1);
        b = epipolar_line(2,1);
        c = epipolar_line(3,1);
        
        % Define the epipolar line equation
        y2_val = -(a/b) * x2_val - (c/b);

        % Take the Euclidean distance from calculated pt and test pt
        img1_pt = [x1_val y1_val];
        img2_pt = [x2_val y2_val];
        distance = dist(img1_pt, img2_pt');

 
        % Use use first iteration to init distance. 
        % If conditions are for init and check if its a smaller distance
        if j == 1 || distance < max_distance
            max_distance  = distance;
            x_prime = x2_val;
            y_prime = y2_val;
        end
    end

    % Append points to the list
    pts2 = [pts2; x_prime y_prime];
end

% End of function
end