% LeafAI - Tomato Leaf Pest Detection (MATLAB)
% Image Preprocessing
img = imread('tomato_leaf.jpg'); 
img_gray = rgb2gray(img); 
img_bin = imbinarize(img_gray,'adaptive');

% Segmentation
leaf_region = imfill(img_bin,'holes'); 

% Color Analysis - Detect pest-induced discoloration (yellow/brown patches)
yellow_channel = img(:,:,1) - img(:,:,2); 
pest_damage = yellow_channel > 140;

% Texture Analysis using GLCM - Identify roughness caused by pest feeding
glcm = graycomatrix(img_gray);
stats = graycoprops(glcm, 'Contrast');

% Shape Analysis using Edge Detection - Detect irregular bite marks or holes
edges = edge(img_gray, 'Canny');

% Pest Infestation Classification & Recommended Actions
infestation_score = mean(pest_damage(:)) + stats.Contrast;
if infestation_score < 0.03
    condition = 'Healthy'; action = 'No pesticide needed. The plant is in good condition.';
elseif infestation_score < 0.08
    condition = 'Mild Pest Presence'; action = 'Apply mild fungicide or organic treatment like neem oil or insecticidal soap.';
elseif infestation_score < 0.2
    condition = 'Moderate Infestation'; action = 'Use a contact insecticide (e.g., pyrethrin-based spray) and check nearby plants for spread.';
else
    condition = 'Severe Infestation'; action = 'Apply systemic pesticide (e.g., imidacloprid); remove/prune damaged leaves';
end

% Output Results
disp(['Condition: ', condition]);
disp(['Suggested Action: ', action]);
