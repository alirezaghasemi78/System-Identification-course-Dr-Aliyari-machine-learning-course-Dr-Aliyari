
System Identification - Homework #2 (Fall 1402)
This repository contains solutions and simulations for Homework #2 of the System Identification course taught by Dr. Aliyari, Fall 1402. The assignment is divided into two parts: Analytical and Simulation-Based.

🧠 Part 1: Analytical Questions
Topics covered include:

Recursive ARMAX Algorithm

Step-by-step derivation and explanation based on lecture material.

Impulse Response & State-Space Realization

Investigating identifiability of discrete-time systems given specific impulse responses.

System with Imaginary Poles

Feasibility of identifying systems with complex poles on the imaginary axis using linear methods.

COR-LS Method

Explanation and use of correlation-based least squares.

🧪 Part 2: Simulation Tasks
Task 1: Model Estimation with Synthetic Inputs
Simulate a second-order open-loop system.

Generate various input signals (Gaussian, uniform, binary random pulses).

Fit models using:

ARX

ARMAX

Analyze:

Estimated poles and zeros.

Model accuracy and fit percentage.

Effect of different input types.

Task 2: Black-Box Modeling from Time-Series Data
Identify a dynamic model from given input-output sequences.

Use:

ARX, ARMAX, OE, BJ, ARARX

Evaluate using:

Training vs test accuracy.

Pole-zero plots.

DC gain comparison.

Estimate unknown static gain 
𝐾
K from the open-loop model.

Task 3: Model Identification with Unknown System
Given access only to the system's input-output behavior via an unknown_sys function.

Use classical control techniques (e.g., step response, Bode plots) to guess model order.

Fit the simplest model that achieves ≥85% accuracy on test data using:

Extended Least Squares (ELS)
