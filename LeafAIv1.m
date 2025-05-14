clc; clear; close all;

%% Step 1: Load Image
img = imread('leaf3.jpeg');
img = imresize(img, [256 256]);

figure, imshow(img); title('Input Leaf Image');

%% Step 2: Preprocessing
grayImg = rgb2gray(img);
bw = imbinarize(grayImg, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.35);
bw = imfill(bw, 'holes');

% Remove small objects
bw = bwareaopen(bw, 300);
leafMask = bw;

% Segment leaf region
leaf = img;
leaf(repmat(~leafMask, [1, 1, 3])) = 0;

figure, imshow(leaf); title('Segmented Leaf Region');

%% Step 3: Color Analysis (Detecting abnormal spots)
hsv = rgb2hsv(leaf);
hue = hsv(:,:,1);
saturation = hsv(:,:,2);
value = hsv(:,:,3);

% Detect common infestation colors (brown, yellow)
diseasedMask = (hue > 0.07 & hue < 0.25) & (saturation > 0.25) & (value > 0.15);
diseaseSeverity = nnz(diseasedMask) / numel(diseasedMask);

figure, imshow(diseasedMask); title('Infested Areas (Color-based)');

%% Step 4: Texture Analysis using GLCM (Gray-Level Co-occurrence Matrix)
glcm = graycomatrix(grayImg, 'Offset', [0 1]);
statsGLCM = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});

isTextured = statsGLCM.Contrast > 25 || statsGLCM.Homogeneity < 0.4;

%% Step 5: Shape Feature (Edge Damage)
edges = edge(grayImg, 'Canny');
edgeDensity = sum(edges(:)) / numel(edges);

isDamagedShape = edgeDensity > 0.10;

%% Step 6: Combine Results
hasColorIssues = diseaseSeverity > 0.02;
infestationDetected = hasColorIssues || isTextured || isDamagedShape;

% Suggest pesticide based on infestation severity and type
if infestationDetected
    if hasColorIssues && isTextured
        if diseaseSeverity > 0.1
            suggestion = 'Use systemic insecticide combined with neem-based fungicide.';
        else
            suggestion = 'Apply neem-based organic pesticide for mild fungal or insect issues.';
        end
    elseif isDamagedShape
        suggestion = 'Apply contact insecticide for chewing pests.';
    elseif isTextured
        suggestion = 'Use miticide or broad-spectrum pesticide for microscopic pests.';
    else
        suggestion = 'Apply mild fungicide for early-stage infection.';
    end
    result = 'Pest Infestation Detected';
else
    result = 'No Infestation Detected';
    suggestion = 'Plant is healthy. No pesticide required.';
end

%% Step 7: Display Result
fprintf('Result: %s\n', result);
fprintf('Suggested Action: %s\n', suggestion);
