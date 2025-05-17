clc; clear; close all;

% Load Image
img = imread('leaf7.jpg'); 
img = imresize(img, [256 256]);
figure, imshow(img); title('Input Leaf Image');

% Preprocessing
grayImg = rgb2gray(img);
bw = imbinarize(grayImg, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.55); 
bw = imfill(bw, 'holes');
bw = bwareaopen(bw, 400);
leafMask = bw;

% Segment Leaf
leaf = img;
leaf(repmat(~leafMask, [1, 1, 3])) = 0;

% HSV Color Analysis
hsv = rgb2hsv(leaf);
hue = hsv(:,:,1);
saturation = hsv(:,:,2);
value = hsv(:,:,3);

% Disease Detection Based on HSV Analysis
diseasedMask = (hue > 0.04 & hue < 0.25) & (saturation > 0.15) & (value > 0.15);
diseasePixels = nnz(diseasedMask);
totalPixels = nnz(rgb2gray(leaf) > 0);
diseaseSeverity = diseasePixels / totalPixels;

% Texture and Shape Analysis
glcm = graycomatrix(grayImg, 'Offset', [0 1]);
statsGLCM = graycoprops(glcm, {'Contrast', 'Homogeneity'});
isTextured = statsGLCM.Contrast > 10 || statsGLCM.Homogeneity < 0.6;

edges = edge(grayImg, 'Canny', [0.03 0.15]);
edgeDensity = sum(edges(:)) / numel(edges);
isDamagedShape = edgeDensity > 0.07;

% Infestation Score Calculation
infestationScore = diseaseSeverity * 0.7 + isTextured * 0.2 + isDamagedShape * 0.1;

% Classification into Healthy, Moderate, or Severe
if infestationScore < 0.05
    plantCondition = 'Healthy';
    suggestion = 'No pesticide needed. The plant is in good condition.';
elseif infestationScore < 0.4
    plantCondition = 'Moderate Infestation';
    suggestion = 'Use a contact insecticide and check nearby plants for spread.';
else
    plantCondition = 'Severe Infestation';
    suggestion = 'Apply systemic pesticide and remove heavily damaged leaves.';
end

% Display Result
result = sprintf('Plant Condition: %s', plantCondition);
fprintf('Result: %s\n', result);
fprintf('Suggested Action: %s\n', suggestion);
