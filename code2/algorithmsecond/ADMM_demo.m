clear;
addpath('C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\confocal\Pol-TIRF-master\Pol-TIRF-master\');
addpath('C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\confocal\Pol-TIRF-master\Pol-TIRF-master\Utils');
load 3d_data;
tic
H = mat2gray(H);img = y;
iteration = 20;miu = 0.5;thd = max(img(:))/max(H(:))*0.1;
xsize = size(img,2).^0.5;zsize = size(H,2);
xk = zeros(zsize,xsize^2);
eta = xk;
HH = (H'*H+miu*eye(size(H,1)));%half positive matrix used for linear calculation
xk = HH\(H'*img);%
uk = xk;

ts=(H'*img);
for i = 1:size(H,2)
    temp = reshape(ts(i,:),[xsize,xsize]);
    recon_3d(:,:,i) = mat2gray(temp);
end
for ii=1:20
    figure;
    imshow(recon_3d(:,:,ii));
end
%% ADMM iteration
for k = 1:iteration
    disp(['Iteration ', num2str(k)]);
    
    uk = HH\(H'*img+miu*(xk-eta));%update uk
%%%%%%    alternative tv regulation   %%%%%%%   
%     temp_3d=reshape(uk',[xsize,xsize,zsize]);
%     for ii=1:xsize
%         temp1=squeeze(temp_3d(ii,:,:));
%         [temp2,~,~]=chambolle_prox_TV_stop(temp1);
%         tv_3d(ii,:,:)=temp2;
%     end
%     uk=(reshape(tv_3d,[xsize*xsize,zsize]))';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    xk = max(uk+eta-thd,0);%update xk with l1 regulation  final need
    
    eta = eta+miu*(uk-xk);%update eta
end
%% convert to 3d result
for i = 1:size(H,2)
    temp = reshape(xk(i,:),[xsize,xsize]);
    recon_3d(:,:,i) = mat2gray(temp);
end
%% generate 2d colored depth map
colorimg = zeros(xsize,xsize);
for ii = 1:zsize
    temp = recon_3d(:,:,ii);
    depth = 12.5*ii;
    colorimg = colorimg + depth*(recon_3d(:,:,ii));
end
colorimg = colorimg./sum(recon_3d,3);
colorimg(isnan(colorimg)) = 0;
toc

% 3d slice
for ii=1:20
    figure;
    imshow(recon_3d(:,:,ii));
end


% 3d figure
% figure;
% imshow(colorimg/max(colorimg(:)));
% ys=size(colorimg,1);
% xs=size(colorimg,2);
% [xx,yy]=meshgrid(1:xs,1:ys);
% zz=ones(size(xx));
% surf(xx,yy,zz,recon_3d(:,:,1));
% view 3d
% view(0,90);

%%
