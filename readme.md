# John Hopkins Data Science Specialization Coursera - Capestone Project

### Author: Avinash Singh Pundhir

## Introduction
* This is an app that can be used as a text prediction application based based on input provided by user.
* We have used language modelling algorithm that uses a corpus of english language as base for predictions.
* The corpus is taken from the following three sources:
 * **Blogs**
 * **News**
 * **Twitter**
* The application location is [Text_Prediction](https://meavinash100.shinyapps.io/predictiveshinyapp/)

## Methodology
* A random sample is taken from the corpus.
* A combination of the following approaches is used in the app to provide suggestions:
 * **Katz Backoff**
 * **Kneser Ney**
 * **Good Turing**
* The mix of the above approaches is used to derive a relavance score.
* Higher relevance score signifies higher accuracy of predictions.

## Functionalities
* In the text input box enter the sentense for which next word should be predicted.
* You can enter one word or multiple words to get the predictions.
* Select the radio box to access top 3/5/10/30 predictions.
* Hit predict to get the list of predictions.