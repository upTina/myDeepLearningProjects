function imdb = TextorNot_CNN_setup_data(datadir)
subdir = dir(datadir);
imdb.images.data=[];
imdb.images.labels=[];
imdb.images.set = [] ;
imdb.meta.sets = {'train', 'val', 'test'} ;
image_counter = 0;
trainratio = 0.8;
for i=3:length(subdir)
    imgfiles = dir(fullfile(datadir,subdir(i).name));
    imgpercategory_count = length(imgfiles) - 2;
    disp([i-2 imgpercategory_count]);
    image_counter=image_counter+imgpercategory_count;
    for j = 3:length(imgfiles)
        img = imread(fullfile(datadir,subdir(i).name,imgfiles(j).name));
        [height,width,chennel] = size(img);
        if(chennel == 3)
            img = rgb2gray(img);
        end
        if height ~= 24  || width ~= 24
            img = imresize(img,[24 24]);
            imwrite(img,fullfile(datadir,subdir(i).name,imgfiles(j).name),'jpg');
        end
        imdb.images.data(:,:,:,end+1)=single(img);
        imdb.images.labels(end+1)= i-2;
        if j-2<imgpercategory_count*trainratio
                imdb.images.set(end+1)=1;
        else
            imdb.images.set(end+1)=3;
        end
        
    end
end
dataMean = mean(imdb.images.data,4);
imdb.images.data = single(bsxfun(@minus,imdb.images.data, dataMean)) ;
imdb.images.data_mean = dataMean;
end