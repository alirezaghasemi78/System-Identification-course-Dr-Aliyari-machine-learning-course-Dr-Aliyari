
System Identification - Homework #1 (Fall 1402)
This repository contains the implementation and analysis for Homework #1 of the System Identification course (Fall 1402), instructed by Dr. Aliyari. The assignment is divided into two main sections: Analytical and Simulation-based problems.

📁 Contents
analytical_solutions/: Written solutions and derivations for the analytical questions.

simulation/: Code scripts for system identification tasks using linear regression, RLS, and other techniques.

report.pdf: Final report including plots, analysis, and explanations.

README.md: Project description and instructions.

data/: Generated synthetic data for training/testing.

🧠 Section 1: Analytical Questions
Topics covered:

Bias and variance analysis under regularized vs. unregularized estimation.

Role of the Hessian matrix in parameter identifiability and sensitivity.

Identifiability issues in underdetermined systems.

Analysis of a second-order differential equation.

Discussion on QR-based Recursive Least Squares (RLS) method.

🧪 Section 2: Simulation Tasks
Main tasks:

Polynomial System Identification

Model output as a linear combination of nonlinear input terms.

Analyze the effect of Gaussian noise with three different variances.

Use 10-fold LS estimation and compare results using different observation lengths.

Plot estimation error and error bars.

Model Selection and Feature Importance

Evaluate regression performance with varying numbers of regressors.

Apply Forward Selection (F.S.) and Backward Elimination (B.E.) to identify key features.

Sliding Window Estimation & Weighted LS

Explore the effect of using a moving window.

Apply Weighted LS and compare with ordinary LS.

RLS Parameter Tracking

Estimate time-varying parameters using RLS and analyze convergence.

Compare different forgetting factors and interpret covariance matrix behavior.

Kalman Filter Implementation (Optional)

Use Kalman filtering to track the state-space parameters.

Compare model output with real data to validate accuracy.
