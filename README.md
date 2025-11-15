# Motion-Detection-Estimation-and-Tracking-on-Images
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/2ineddine/Motion-Detection-Estimation-and-Tracking-on-Images)

## Overview

This repository provides a collection of MATLAB functions for motion analysis in image sequences. It covers three core areas of computer vision: motion detection, motion estimation (optical flow), and object tracking. The project serves as a toolkit of various classical and advanced algorithms for analyzing and interpreting movement in video data.

## Features

- **Motion Detection:** Algorithms to identify moving objects by separating foreground from a static or adaptive background.
- **Motion Estimation:** Techniques to compute the displacement of pixels or blocks between consecutive frames (optical flow).
- **Object Tracking:** Methods to follow a specific object or multiple objects through an image sequence.
- **Utilities:** Helper functions for reading image sequences, visualizing motion fields, and generating synthetic test data.

## Repository Structure

The source code is organized into modules based on functionality:

- `src/readSeq.m`: Utility for loading image sequences from a directory.
- `src/detection/`: Contains algorithms for motion detection.
- `src/estimation/`: Contains algorithms for motion estimation (optical flow and block matching).
- `src/suivi/`: Contains algorithms for object tracking, divided into Particle Filter and Kalman-based approaches.

---

## Core Algorithms

### Motion Detection

Located in `src/detection/`, these functions identify regions of movement.

- `bgDiffImg.m`: Implements motion detection through frame differencing.
  - **Type 1:** Difference against a fixed, known reference image.
  - **Type 2:** Difference between successive frames.
  - **Type 3:** Difference against a reference image that is continuously updated.
- `bgElgammal.m`: A non-parametric method that models the background of each pixel using a kernel density estimator. This allows for more robust detection in scenes with non-static backgrounds.
- `bgACP.m`: Utilizes Principal Component Analysis (PCA) to learn a background model ("Eigenbackgrounds"). Moving objects are detected as deviations from this learned background subspace.

### Motion Estimation

Located in `src/estimation/`, these functions calculate motion vectors between frames.

- **Block-Based Methods:**
  - `blockMatching.m`: A full-search block matching algorithm. For each block in the first image, it searches a corresponding window in the second image to find the best match based on Mean Squared Sum of Differences (MSSD).
  - `bm4SS.m`: Implements the Four-Step Search (4SS) algorithm, a more efficient hierarchical block matching method that reduces the number of search points compared to a full search.

- **Optical Flow Methods:**
  - `ofLK.m`: The Lucas-Kanade method, a local differential approach that computes optical flow for small neighborhoods assuming constant velocity in the local region.
  - `ofHS.m`: The Horn-Schunck method, a global differential approach that computes a dense optical flow field by minimizing a global energy function that includes a data term and a smoothness regularizer.
  - `ofBruhn.m`: A combined local-global approach that integrates Gaussian weighting of the data term within an iterative refinement scheme, balancing the strengths of local and global methods.

- **Utilities:**
  - `motionCompensation.m`: Applies calculated motion vectors (`u`, `v`) to an image to warp it, predicting the next frame or stabilizing the video.
  - `flow2Hsv.m`: Visualizes a dense motion field by mapping the direction and magnitude of flow vectors to the hue and saturation of an HSV color image.

### Object Tracking

Located in `src/suivi/`, these functions track objects over time.

- **Particle Filter (`filtreParticulaire/`):** A probabilistic tracking method effective for non-linear, non-Gaussian problems.
  - `particleFiltering.m`: The main implementation, which performs propagation, weight update, and resampling of particles.
  - `getHisto.m`: Computes a color histogram for an image region.
  - `getVraisemblance.m`: Calculates particle likelihood based on the Bhattacharyya distance between a reference histogram and the particle's histogram.

- **Kalman-Based Tracking (`kalman/`):** A set of functions designed for tracking objects that can be modeled as ellipses.
  - `tracking.m`: Updates the position of a set of points based on a pre-computed motion field.
  - `ellipseDirectFit.m`: A non-iterative algorithm to fit an ellipse to a given set of 2D points.
  - `pts2Ellipse.m` & `ellipse2Pts.m`: Convert between a set of contour points and the parametric representation of an ellipse (`xC, yC, rX, rY, theta`).
  - `getDistance.m`: Computes various distance metrics (MAD, MSSD, Hausdorff) between two contours, useful for evaluating tracking accuracy.
