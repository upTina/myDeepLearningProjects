function [net, info] = TextorNot_CNN()

run(fullfile('/media','Codes','shang','matconvnet-1.0-beta23','matconvnet-1.0-beta23','matlab','vl_setupnn.m'));
datadir = '/media/Codes/shang/CarLicense/DataSet';
opts.expDir = fullfile('/media','Codes','shang','CarLicense','baseline', 'data', 'plate-baseline') ;
opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');

if exist(opts.imdbPath,'file')
    imdb = load(opts.imdbPath);
else
    imdb =  TextorNot_CNN_setup_data(datadir);
    mkdir(opts.expDir);
    save(opts.imdbPath,'-struct','imdb');
end

net=TextorNot_CNN_init();
net.meta.normalization.averageImage =imdb.images.data_mean ;
opts.train.gpus=2;

[net, info] = cnn_train(net, imdb, getBatch(opts), ...
                        'expDir', opts.expDir, ...
                        net.meta.trainOpts, ...
                        opts.train, ...
                        'val', find(imdb.images.set == 3)) ;
                    
function fn = getBatch(opts)
% --------------------------------------------------------------------
    fn = @(x,y) getSimpleNNBatch(x,y) ;
end

function [images, labels]  = getSimpleNNBatch(imdb, batch)
    images = imdb.images.data(:,:,:,batch) ;
    if size(images,3) == 3
        images = rgb2gray(images);
    end
    labels = imdb.images.labels(1,batch) ;
    if opts.train.gpus > 0
        images = gpuArray(images) ;
    end    
end

end