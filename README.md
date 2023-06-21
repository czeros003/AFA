# AFA Project - Wojciech Czerski s20458 and Kinga Kalbarczyk s20474
**Image Reconstruction Project**
This project aims to perform image reconstruction using the 'mm_atrous_lena' algorithm in MATLAB. The algorithm utilizes the Wavelet Toolbox for image processing.

## Project Overview

The objective of this project is to reconstruct an image using the 'mm_atrous_lena' algorithm, which employs the a trous wavelet transform. The algorithm takes an input image and performs a multiresolution analysis using the wavelet transform to decompose the image into different frequency bands. It then applies a modified version of the a trous wavelet transform to enhance specific details and features of the image. Finally, the algorithm reconstructs the image using the inverse wavelet transform.

## Table of Contents
1. [Requirements](#requirements)
	- [Usage](#usage)
	- [Example](#example)
2. [Results](#results)

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
image_name = 'Lena.bmp';
num_levels = 3;
threshold = [25, 25, 10];

[reconstructed_image, compression_ratio, snr] = recon_mm2(image_name, num_levels, threshold);
```

## Results

If we are using **threshold = [25,25,10]** and **num_levels = 3** we get result such as
![Figure 1](<results/Figure 1.png> "Figure 1") 
Stopień kompresji: 1.28
Stosunek sygnału do szumu (SNR): -45.96 dB