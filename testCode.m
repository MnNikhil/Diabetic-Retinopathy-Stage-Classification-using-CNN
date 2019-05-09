%% Initialisation

clc;
disp('Initialising...')
clearvars;% clear variables
close all;

disp('Loading saved models...')
load('net_vgg16.mat')
load('net_inception.mat')
load('net_alexnet.mat')
load model.mat

[fn,pn] = uigetfile('~/Desktop/test images$.jpeg');

myImage = fullfile(pn,fn);
fprintf('\nInputFile:\n\t%s',myImage)

im1 = readEye1(myImage);
im2 = readEye2(myImage);
im3 = readEye3(myImage);

layer = 'fc8';
feat1 = activations(net1,im1,layer,'OutputAs','rows');

layer = 'fc8';
feat2 = activations(net2,im2,layer,'OutputAs','rows');
   
layer = 'predictions_new';
feat3 = activations(net3,im3,layer,'OutputAs','rows');

feat = [feat1 feat2 feat3];

fprintf('\nPredicting output...')
label = predict(mdl,feat);
my_prediction = string(label);


imshow(myImage)
title(my_prediction)

msgbox(my_prediction,'result');
