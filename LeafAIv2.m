
% Load Image
img = imread('leaf6.jpeg'); 
img = imresize(img, [256 256]);

figure, imshow(img); title('Input Leaf Image');

% Preprocessing (recolor, gawing gray)
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

% Color Analysis (infestation spread calculation)
hsv = rgb2hsv(leaf);
hue = hsv(:,:,1);
saturation = hsv(:,:,2);
value = hsv(:,:,3);

% Pangdetect abnormal color regions (identify yung brown/yellow areas)
diseasedMask = (hue > 0.07 & hue < 0.25) & (saturation > 0.25) & (value > 0.15);
diseaseSeverity = nnz(diseasedMask) / numel(diseasedMask);

figure, imshow(diseasedMask); title('Infested Areas (Color-based)');

% Texture Analysis (idetect kung may rough regions)
glcm = graycomatrix(grayImg, 'Offset', [0 1]);
statsGLCM = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});

isTextured = statsGLCM.Contrast > 25 || statsGLCM.Homogeneity < 0.4;

% Shape Feature (detect or analyze kung may sira yung edge ng dahon)
edges = edge(grayImg, 'Canny');
edgeDensity = sum(edges(:)) / numel(edges);

isDamagedShape = edgeDensity > 0.10;

% Determine Plant Condition (subject to changes ang mga values, more research pa)
infestationScore = diseaseSeverity * 0.5 + isTextured * 0.3 + isDamagedShape * 0.2;

if infestationScore < 0.05
    plantCondition = 'Healthy';
    suggestion = 'No pesticide needed. The plant is in good condition.';
elseif infestationScore < 0.1
    plantCondition = 'Mild Infestation';
    suggestion = 'Apply mild fungicide or organic treatment.';
elseif infestationScore < 0.25
    plantCondition = 'Moderate Infestation';
    suggestion = 'Use a contact insecticide and check nearby plants for spread.';
else
    plantCondition = 'Severe Infestation';
    suggestion = 'Apply systemic pesticide and remove heavily damaged leaves.';
end

result = sprintf('Plant Condition: %s', plantCondition);

% Display Result
fprintf('Result: %s\n', result);
fprintf('Suggested Action: %s\n', suggestion);
