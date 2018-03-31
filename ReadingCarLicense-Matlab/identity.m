filename = '/media/Codes/shang/CarLicense/data/6.jpg';
segment(filename);
close;
run(fullfile('/media','Codes','shang','matconvnet-1.0-beta23','matconvnet-1.0-beta23','matlab','vl_setupnn.m'));
addpath /media/Codes/shang/CarLicense/baseline/data/plate-baseline;
datadir='/media/Codes/shang/CarLicense/DataSet';
subdir = dir(datadir);
net = load('net-epoch-300.mat');
net = net.net;

result = zeros(7,2);
for i= 1:7
    filenameseq = [num2str(i) '.jpg'];
    img = imread(filenameseq);
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    img = imresize(img, [net.meta.inputSize(1,1) net.meta.inputSize(1,2)]);
    img = single(img);
    img = img - net.meta.normalization.averageImage;
    opts.batchNormalization = false;
    net.layers{end}.type = 'softmax';
    res = vl_simplenn(net, img);
    scores = squeeze(gather(res(end).x));
    [bestScore, best] = max(scores);
    result(i,:) = [best bestScore];
end
imgfile = imread(filename);
imshow(imgfile);
title(sprintf('%s %s %s %s %s %s',subdir(result(2,1)+2).name,subdir(result(3,1)+2).name,subdir(result(4,1)+2).name,subdir(result(5,1)+2).name,subdir(result(6,1)+2).name,subdir(result(7,1)+2).name));



