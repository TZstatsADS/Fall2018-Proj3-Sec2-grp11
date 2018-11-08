# Project: Can you unscramble a blurry image? 
![image](figs/example.png)

### [Full Project Description](doc/project3_desc.md)

Term: Fall 2018

+ Team 11
+ Team members
	+ Feng, Xinwei xf2168@columbia.edu
	+ Han, Tao th2710@columbia.edu
	+ Wang, Nannan nw2387@columbia.edu
	+ Zhang, Rui rz2406@columbia.edu

+ Project summary: In this project, we created a classification engine for enhance the resolution of images. 
Our client is interested in creating an mobile AI program that can enhance the resolution of ow-resolution images and can minimize running cost. Our goal is to enlarge the low resolution image, and produce a predicted high resolution image as output based on the low-resolution input.
We use patch-based method to extract features. The baseline model here is Gradient Boosting Machines, and we use vector to replace loop in our feature extraction part as our improved model with depth equal to 7. The time cost of the improved model to predict 1500 HR images is around 16 mins. The error(MSE) is 0.00257. The PSNR is 25.893.

	
**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 
+ Nannan Wang: Write and run the baseline code 
+ Rui Zhang: Write and run the baseline code
+ Xinwei Feng: Make presentation slides; Assist baseline code and write readme
+ Tao Han: Write and run the improve part
Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
