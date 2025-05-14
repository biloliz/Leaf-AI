% Focus on Tomato Plant Leaves Version

% Image Preprocessing
img = imread('leaf.jpg'); 
img_gray = rgb2gray(img); 
img_bin = imbinarize(img_gray,'adaptive'); 

% Segmentation
leaf_region = imfill(img_bin,'holes'); 

% Color Analysis
red_channel = img(:,:,1);
yellow_area = red_channel > 150; 

% Texture Analysis using GLCM
glcm = graycomatrix(img_gray);
stats = graycoprops(glcm, 'Contrast');

% Shape Analysis using Edge Detection
edges = edge(img_gray, 'Canny');

% Classification
infestation_score = mean(yellow_area(:)) + stats.Contrast;
if infestation_score < 0.05
    condition = 'Healthy'; action = 'No pesticide needed';
elseif infestation_score < 0.1
    condition = 'Mild Infestation'; action = 'Apply mild fungicide';
elseif infestation_score < 0.25
    condition = 'Moderate Infestation'; action = 'Use contact insecticide';
else
    condition = 'Severe Infestation'; action = 'Use systemic pesticide';
end

% Output Results
disp(['Condition: ', condition]);
disp(['Suggested Action: ', action]);
