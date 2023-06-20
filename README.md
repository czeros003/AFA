# AFA Project - Wojciech Czerski s20458 and Kinga Kalbarczyk s20474
**Image Reconstruction Project**
This project aims to perform image reconstruction using the 'mm_atrous_lena' algorithm in MATLAB. The algorithm utilizes the Wavelet Toolbox for image processing.

## Project Overview

The objective of this project is to reconstruct an image using the 'mm_atrous_lena' algorithm, which employs the a trous wavelet transform. The algorithm takes an input image and performs a multiresolution analysis using the wavelet transform to decompose the image into different frequency bands. It then applies a modified version of the a trous wavelet transform to enhance specific details and features of the image. Finally, the algorithm reconstructs the image using the inverse wavelet transform.

## Table of Contents
1. [Requirements](#requirements)
	- [Usage](#usage)
2. [Example](#example)
3. [Results](#results)
4. [Documentation](#documentation)
	- [mm_atrous_lena](#mm_atrous_lena)
	- [dyadup](#dyadup)
	- [limitations](#limitations)

## Requirements
To run this project, you will need the following:

- MATLAB with access to the Wavelet Toolbox.
- An input image for reconstruction.

### Usage

1. Open MATLAB and ensure that you have access to the Wavelet Toolbox.

2. Set the working directory to the location of the project files.

3. Load the input image into MATLAB. You can use the `imread` function to read the image from a file.

4. Run the 'mm_atrous_lena' script in MATLAB. This script implements the image reconstruction algorithm using the 'dyadup' function from the Wavelet Toolbox.

5. If you encounter an error related to the Wavelet Toolbox, ensure that you have the necessary license or try alternative image reconstruction techniques available in MATLAB.

6. Review the output image. The reconstructed image will be displayed in a MATLAB figure window.

7. Experiment with different parameters and input images to achieve desired results.

### Example
Below is an example usage of the project.

In the MATLAB command window, run the following command:
```matlab
mm_atrous_lena(lvl, Threshold);
```
Replace **lvl** and **Threshold** with the desired values for the reconstruction level and threshold. For example:
```matlab
mm_atrous_lena(4, 0.1);
```

## Results
Tak dodaje sie plik, opisz rezultaty wnioski (z plikow w folderze results)

![Figure 1](<results/Figure 1.png> "Figure 1") 

## Documentation
This documentation provides an overview of the modified MATLAB files in the project.

### mm_atrous_lena
This script implements the image reconstruction algorithm using the 'dyadup' function from the Wavelet Toolbox.

#### Usage

```matlab
% Load input image
inputImage = imread('lena.jpg');

% Run the image reconstruction algorithm
reconstructedImage = mm_atrous_lena(inputImage);

% Display the reconstructed image
imshow(reconstructedImage);
```

### dyadup
This file is a modified version of the 'dyadup' function from the Wavelet Toolbox. The modification was made to handle compatibility issues in the MATLAB Online environment.

#### Modifications
- The modified 'dyadup' function includes additional error handling and compatibility checks for MATLAB Online.
- Certain functions or operations that are not supported in MATLAB Online have been replaced or modified to ensure compatibility.

### limitations
This script outlines the limitations of the project and provides suggestions for alternative approaches if the Wavelet Toolbox is not available.
#### Usage
```matlab
% Run the limitations script
limitations;
```

