function I_final = readEye(im_name_abs)
im = imread(im_name_abs);
%% Preprocessing
I_g = im(:,:,2);
I_med = medfilt2(I_g);
I_adapt = I_med;%histeq(I_med);
I_noise = imgaussfilt(I_adapt,'FilterSize',3);
%     kernel = -1*ones(3);
%     kernel(2,2) = 17;
%     I_bg = imfilter(I_noise, kernel);
I_bg = medfilt2(I_adapt,[68,68]);
I_shade = double(I_adapt ./ I_bg);
I_con = 255*double(I_shade ./ std2(I_shade));

se = strel('disk',12);
I_pp =  imtophat(I_shade,se);
I_dilated = imdilate(I_pp,strel('disk',20));
I_final = immultiply(I_g,imbinarize(I_dilated));

I_final = imresize(I_final,[250,250]);
end
