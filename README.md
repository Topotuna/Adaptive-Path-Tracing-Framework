# Adaptive-Path-Tracing-Framework

The Adaptive Path Tracing Framework works as a tool for developing and testing adaptive path tracing strategies via MATLAB®.

## Overview

The project runs all of its computations on a pre-computed image sample data file.
This helps to avoid performing path tracing steps by the renderer and makes adaptive path tracing simulation independent from specific renderer implementations.

## Code Structure

The source code is structurised in scripts to avoid passing large data structures between function invocations.
The core script `render.m` takes input parameters from `parameters.m`, then reads sample data file and performs specified adaptive sampling and image reconstruction algorithms.

## Dependencies

The project uses functionality of MATLAB® Image Processing Toolbox.
It also takes [OpenEXR](https://github.com/skycaptain/openexr-matlab) as an external library to enable writing images in HDR compatible format.

## Data File Format

The sample data file contains a list of samples.
Each sample is represented by a tuple of values in binary

`(pixel_X, pixel_Y, offset_X, offset_Y, colour_X, colour_Y, colour_Z, alpha)`

Renderer ["Mitsuba 2"](https://mitsuba2.readthedocs.io) was altered to enable printing out the sample values.
Please refer to project ["Path Sample Extraction"](https://github.com/Topotuna/Path-Sample-Extraction) for generating the sample data files.

## Usage

The code is invoked by calling the `render.m` script from project's root directory:

```
run('core/render.m')
```

All specific parameters have to be passed via `parameters.m` source file.

## Licence

The project is available under MIT licence.
