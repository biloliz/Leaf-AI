# 🌿 Leafalyze
## Simple Leaf Pest Detection System
LeafAI is a MATLAB-based image processing tool designed to assess plant leaf health using color, texture, and shape analysis. It detects early signs of infestation or damage, classifies the plant condition, and provides treatment suggestions—empowering farmers and researchers with actionable insights.

## 📸 How It Works
Input: Load and resize a leaf image.

Preprocessing: Convert to grayscale and apply adaptive binarization.

Segmentation: Isolate the leaf region and remove noise.

Color Analysis: Detect discolored areas (e.g., yellow/brown regions).

Texture Analysis: Analyze leaf roughness using GLCM.

Shape Analysis: Examine edge damage using Canny edge detection.

Classification: Compute an infestation score and classify the plant condition.

Output: Display segmented regions, condition classification, and suggested action.

## 🧠 Key Features
✅ Detects infestation severity based on color changes.

✅ Identifies texture anomalies from pest damage.

✅ Detects leaf deformities via shape and edge analysis.

✅ Provides automated plant condition classification.

✅ Suggests appropriate treatment actions.

## 🛠️ Technologies Used
MATLAB

Image Processing Toolbox (GLCM, edge detection, color space conversion)

## 📊 Output Categories  
Infestation Score          Condition                Suggested Action
   
   Less than 0.05            Healthy	               No pesticide needed
     
   0.05–0.4	                 Moderate Infestation	   Use contact insecticide; monitor nearby plants
   
   Greater than 0.4	        Severe Infestation	      Use systemic pesticide; remove damaged leaves
 
## 📝 Future Improvements
Add support for batch image analysis.

Integrate real-time drone or satellite image input.

Train a machine learning model for more accurate classification.

## 📌 Disclaimer
This project is a proof of concept and not yet validated for all plant types or infestation patterns. For real-world agricultural use, further data collection and model tuning are recommended.

