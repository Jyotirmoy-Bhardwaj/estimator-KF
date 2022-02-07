# estimator - kalmanFilter

<p align=justify>
This is an **estimation problem**.Water demand management is one of the fundamental challenges of any urban Water Distribution Network
(WDN). In WDNs, multiple cascaded water tanks (or reservoirs) are the major source of water supply. Hence,
maintaining the satisfactory water level in distribution tanks in an online fashion, as per user demand, is the most important
challenge of any WDN authorities. In addition, it is very important to estimate the water levels of individual tanks as per
the varying local consumer demands. This continuous in-flow and out-flow of water affect the water level in
distribution tanks, where Kalman filter (KF) can be used to estimate the exact water level at the exact moment
of time. This report studies the KF algorithm to predict and estimate the water level of multiple interconnected
tanks. A WDN model is proposed in the report to derive supporting state equations. Two different cases are
considered to test the KF which are as follows:
 
• Estimation of water level in multiple interconnected tanks in proposed WDN?
 
• Estimation of water level in multiple interconnected tanks in proposed WDN, in the scenario of non-availability of observations in one of the tanks?

 
 
# Requirements:
- [`cvxOpt`](http://cvxr.com/cvx/)
- [`matLab`](https://se.mathworks.com/products/matlab.html)

## License
The project is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).

 ## Citing Work

* **Lee, Y. H., and V. P. Singh **. *Tank model using Kalman filter.* Journal of hydrologic engineering 4.4 (1999): 344-349.
