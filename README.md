[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-ff69b4.svg)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

## GuitarSoloDetection
This repository contains an annotated dataset of guitar solo segments present in 60 popular rock songs and the code used to develop a machine learning model to detect guitar solos automatically. This work titled **A Dataset and Method for Guitar Solo Detection in Rock Music**, was published as a Conference Paper at the [2017 AES (Audio Engineering Society) International Conference on Semactic Audio](http://www.aes.org/conferences/2017/semantic/)

> Pati, Kumar Ashis, and Alexander Lerch. "A Dataset and Method for Guitar Solo Detection in Rock Music." Audio Engineering Society Conference: 2017 AES International Conference on Semantic Audio. Audio Engineering Society, 2017.

```
@inproceedings{pati2017dataset,
  title={A Dataset and Method for Guitar Solo Detection in Rock Music},
  author={Pati, Kumar Ashis and Lerch, Alexander},
  booktitle={Audio Engineering Society Conference: 2017 AES International Conference on Semantic Audio},
  year={2017},
  organization={Audio Engineering Society}
}
```

Please cite the publication if you are using the dataset and/or the code in this repository.

A blog post summarizing the above paper can be found [here](http://www.musicinformatics.gatech.edu/project/guitar-solo-detection/) and the full paper is available [here](http://www.musicinformatics.gatech.edu/wp-content_nondefault/uploads/2017/06/Pati_Lerch_2017_A-Dataset-and-Method-for-Electric-Guitar-Solo-Detection-in-Rock-Music.pdf).

The folder structure is as follows: 
* Dataset: which contains
  - ```song_lists.txt``` which lists the names and discog information of the songs present in the dataset.
  - ```Annotations``` folder which contains the individual ```.txt``` files containing the start-time and durations (in seconds) of guitar solo segments present in those songs.
* Code: which contains the scripts and functions to extract different features and train and evaluate an SVM (Support Vector Machine) based model.
