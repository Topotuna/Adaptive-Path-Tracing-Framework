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

## Usage

The code is invoked by calling the `render.m` script from project's root directory:

```
run('core/render.m')
```

All specific parameters have to be passed via `parameters.m` source file.

## Licence

The project is available under MIT licence.
