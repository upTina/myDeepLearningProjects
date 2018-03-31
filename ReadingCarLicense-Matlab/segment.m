function  segment(filename)
img_int=imread(filename);
img_gray=rgb2gray(img_int);
thresh=graythresh(img_int);
img_binary=im2bw(img_gray,thresh);
[r,c]=size(img_binary);
img_binary=bwareaopen(img_binary,30);
% =========================================================================
% ȥ�����±߿�
% =========================================================================
hist_vert=sum(img_binary');
thre_vert=round(1/10*max(hist_vert));
mid=round(r/2);
upper_boundary=find(hist_vert(1:mid)<thre_vert,1,'last');
lower_boundary=find(hist_vert(mid:r)<thre_vert,1,'first')+mid;
if isempty(upper_boundary)
    upper_boundary=1;
end
if isempty(lower_boundary)
    lower_boundary=r;
end
img_binary=img_binary(upper_boundary:lower_boundary,:);
img_gray=img_gray(upper_boundary:lower_boundary,:);
imshow(img_binary);
% =========================================================================
% =========================================================================
hist_hori=sum(img_binary);
[peak,locs,w,p]=findpeaks(-hist_hori,'minpeakheight',-5);
width=max(diff(locs));%�ַ��ŵĿ��
%Ѱ�ҵ�һ���ָ�λ��
first=find(hist_hori<5,1,'first');
if first>1/2*width
    first=1;
end
%Ѱ�����һ���ָ��λ��
last=find(hist_hori<5,1,'last');
if c-last>1/3*width
    last=c;
end
%��֤��һ��Ҫ�ָ�ĺ����Ƿ���ƫ��
if locs(1)-first<1/2*width
    locs=locs(2:end);
    w=w(2:end);
end
if last-locs(end)<1/3*width
    locs=locs(1:end-1);
    w=w(1:end-1);
end
locs=locs+1/6*w
locs=[first locs last];
locs=round(locs)
j=1;
flag=1;
for i=1:length(locs)-1
    if locs(i+1)-locs(i)<1/2*width && max(hist_hori(locs(i):locs(i+1))<1/3*r)
        flag=0;
    end
    if flag==1
        img=img_gray(:,locs(i):locs(i+1));
%       img=img_binary(:,locs(i):locs(i+1))
        subplot(2,4,j)
        imshow(img);
        imwrite(img,[num2str(j) '.jpg']);
        j=j+1;
    end
    flag=1;
end
% first=find(hist_hori<)
% wid=3/4*max(diff(locs));
end

