# How to Use
### Setup:

Ensure all files (including the templates folder) are in your MATLAB working directory.

Load or prepare the image containing characters you want to match.

### Run the Script:

template_matching

### Output:

The script will take a snapshot from the input image.

It will segment each character.

Each character will be matched against the templates.

The script will display the predicted character and a confidence score for each match.

# How It Works
### Input Image Acquisition:

A snapshot or static image is loaded for processing.

### Character Segmentation:

The image is processed to extract individual character regions (segmentation logic should be implemented in segmentCharacters.m or equivalent).

### Template Matching:

Each character image is compared with all available templates using correlation-based comparison or norm-based similarity.

The character with the best matching score is selected as the prediction.

### Output Display:

For each detected character, the best match and its score are printed to the MATLAB console or optionally displayed on the image.
