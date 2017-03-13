
# dssr2017-lhamm
## Image Analysis Linking Project: Moving towards more accurate childhood visual acuity measures in community settings
### Background
As a research group, we are interested how to get accuarate measures of visual function in children. Our interest in this is two-fold. If a child has something wrong with their eyes which can be treated, it is in their best interest to treat it as soon as possible. Early detection and treatment of an ocular anomoly allows the brain to develop an extraordinary capacity to make use of all the rich visual information available in our world. Even short durations of impairment early in life can have lasting impacts for how the visual world is interpreted. In addition to the benefits of vision screening, accurate measure of visual function in children also help the development of ocular treatments. For example, rest retest reliability of visual acuity tasks is quite low; if you ask a child to do an eye test twice, the difference between the two tests is likely to be within 0.3logMAR, or three lines on a standard eye chart. A new treatment, therefore, is often expected to show improvements which are beyond this range. A more accurate visual acuity test may help to understand which treatments are worth pursuing.  

We programmed a simple eye exam to run on a tablet for use in community settings in which we automated many aspects of a test which may be sources of variability, and used symbols which were designed to reduce variability. We also adopted a shorted viewing distance in accordance with recent recommendations. A shorter viewing distance helps in engaging children, and makes testing in diverse environments easier, but it also means that postoral changes (in particular, leanig forward to get a better look) have a more substantial impact on the outcome of the test. Since our testing was done on a tablet with a webcam, we ran a pilot study to look at whether we could track, and therefore account for, viewing distance on a trial by trial basis, and subsequently calculate visual acuity based on a measured visual angle rather than an assumed angle based on the requested viewing distance.   

We placed a bullseye on the covered eye of the child during the acuity test, and wrote image analysis software to locate and measure the width of the bullseye on each frame during testing. We further attempted a bit of software to assess which eye was tested, based on the density of edges to the left and right of the target. In our pilot work, we also collected images every 6th frame, so that we could link the real time analysis of the bullseye width and eye tested and see 1) how accurate it was, and 2) ways that we could improve our real-time analysis for future use. 

This project is focused on the first aim; to assess the accuracy of the system used in the pilot study. To accomplish this, we load the data file for an individual trial at 2 viewing distances, and then loop through the frames for those two trials, comparing the image content to the outcome of the real-time image anaysis during the trial. We categorise whether it was accurate, or if not, the type of error which occured. Since the database is large (40 participants x 2 eyes x 2 types of stimuli x 2 viewing distances x 16 trials - a total of 5120 trials, each with up to 2000 images assosicate with it) we decided on samping the data randomly as a first step to get a sense of the error types in a way that would be informative for improving the system.

### Requirements to run program
This was developed for a specific purpose, uses confidential images from a pilot study, and matlab data stored in a particular structure format. As we move towards improving the tracking software, the target used, size of images, and format of the data which it is linked to are all likely to change, and therefore it is not be useful for externally generated data at this time. We will aim to include example data from the researchers so the program can be tested in it's current state. The second goal is the more universally useful one (to improved real time distance analysis software), which may be added as we get to that stage. 

This project was built and tested on Matlab 2016a on a surface pro4. 

### Contributions
At this stage, the project is internal, questions and suggestions can be forwarded to l.hamm@auckland.ac.nz

### Licencing
This work was part of a course, and uses fuctions from a variety of contributors, please contact the email above if you would like to use anything contained within this repository 

Creative commons non-commercial, share alike 
