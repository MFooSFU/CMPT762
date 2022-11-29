function depthM = get_depth(dispM, K1, K2, R1, R2, t1, t2)
% GET_DEPTH creates a depth map from a disparity map (DISPM).

% Start the GET DEPTH process
% ======================================================
% Step 1: Calculate the c1 and c2
% ======================================================
c1 = -inv(K1 * R1)*(K1 * t1);
c2 = -inv(K2 * R2)*(K2 * t2);

% ======================================================
% Step 2: Calculate b
% ======================================================
b = norm(c1 - c2);

% ======================================================
% Step 3: Generate the depth map
% ======================================================
% Get the total number of values to be used in the calculation
[num_elements_y, num_elements_x] = size(dispM); % using the first value since it's dispM(y, x)

% Begin populating the depth map
for y = 1 : num_elements_y
    for x = 1 : num_elements_x
        % Check if dispM(y,x) = 0 to avoid dividing by 0
        if dispM(y, x) == 0
            depthM(y, x) = 0;
        else
            depthM(y, x) = cross(b, K1(1,1)) / dispM(y, x);
        end
    end
end

% End of function
end