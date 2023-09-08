%clear;
clearvars -except psf_n ppsf1 ppsf2
tic
addpath('D:\srccode\code2\algorithmsecond\');
addpath('D:\srccode\code2\algorithmsecond\Utils');
load p_data;
%% parameter initialization
for times_pmsim=1:2
%% deal with the data in program
    clearvars -except psf_n times_pmsim ppsf1 ppsf2
    load p_data;
%% parameter initialization
    lambda1 = 0.05; lambda2 = 20;iteration=200;% constant value adjusted with sample ,usually 150 or 100 is enough for a good system of SIM
    L=10;% initial step  0.13 
    filepath='D:\srccode\DataInArticles\';
    filenum='1\';
    filename=['a','b','c','d','e','f','g','h'];
    fileaft='\';
    fileinp='SIM';
    filestyle='tif';
    if times_pmsim==1
        psf_n=ppsf1;
    elseif times_pmsim==2
        psf_n=ppsf2;
    end
    for il=1:3
%% collect data
       img1(:,:,il)=double(imread([filepath,filenum,filename(il+(times_pmsim-1)*3),fileaft,fileinp,num2str(1),'.',filestyle]));%
       img1(:,:,il+3)=double(imread([filepath,filenum,filename(il+(times_pmsim-1)*3),fileaft,fileinp,num2str(2),'.',filestyle]));%
       img1(:,:,il+6)=double(imread([filepath,filenum,filename(il+(times_pmsim-1)*3),fileaft,fileinp,num2str(3),'.',filestyle]));%
    end
%% initialization
    xsize=size(img1,1);ysize=size(img1,2);angles=size(img1,3);%ten angles
    avg=sum(sum(img1,1),2)/xsize/ysize;
    modulation=squeeze(avg/avg(1));%ratio by img1 of each img
    psizex=size(psf,1);psizey=size(psf,2);% scale of psf
    exsize=xsize+psizex-1;eysize=ysize+psizex-1;%total scale
    xkg=zeros(exsize,eysize,angles);xkb=zeros(xsize,ysize);%xkg: sample; xkb: noise
    average=sum(sum(sum(img1)))/xsize/ysize/angles;%total ten imgs average of each pixel
    xkb(1,1)=average*xsize;
    ykp1g=xkg;ykp1b=xkb;
    tkp1=1;
%% Fista iteration
    for i=1:iteration
       disp(i);
       xkm1g=xkg;xkm1b=xkb;
       ykg=ykp1g;ykb=ykp1b;
       tk=tkp1;
       Forward_proj=forward(ykg,ykb,psf,modulation);%calculate 'miu'
       mlh=maximumlikelihood(Forward_proj,img1);%calculate likelihood
       [gradg,gradb]=gradientt(Forward_proj,img1,psf,modulation);%calculate gradient
       for j=1:1000
           Ltest=L*1.08^(j-1);
           [xgtest,xbtest]=stepp(Ltest,ykg,ykb,gradg,gradb,lambda1,lambda2);
           newForward=forward(xgtest,xbtest,psf,modulation);
           newmlh=maximumlikelihood(newForward,img1);
           quadratic=mlh+quadraticApprox(xgtest,xbtest,ykg,ykb,gradg,gradb,Ltest);%calculate quadratic approximation
           if newmlh<quadratic||newmlh==quadratic  %update with the diretion of grad
               xkg=xgtest;xkb=xbtest;
               L=Ltest;
               mlh=newmlh;
               break;
           end
       end
       tkp1=(1+(1+4*tk^2)^0.5)/2;%update after one iteration
       temp=(tk-1)/tkp1;
       ykp1g=xkg+temp*(xkg-xkm1g);
       ykp1b=xkb+temp*(xkb-xkm1b);
    end
    imgRecon=xkg(psizex/2:psizex/2+xsize-1,psizey/2:psizey/2+ysize-1,:);
%% fft %deconvolution is a choice 
    aa1=fftshift(fft2(squeeze(imgRecon(:,:,1))));
    % aa1=fftshift(fft2(squeeze(deconvlucy(imgRecon(:,:,1),psf_n,4))));
    aa2=fftshift(fft2(squeeze(imgRecon(:,:,2))));
    % aa2=fftshift(fft2(squeeze(deconvlucy(imgRecon(:,:,2),psf_n,4))));
    aa3=fftshift(fft2(squeeze(imgRecon(:,:,3))));
    % aa3=fftshift(fft2(squeeze(deconvlucy(imgRecon(:,:,3),psf_n,4))));
    aa4=fftshift(fft2(squeeze(imgRecon(:,:,4))));
    % aa4=fftshift(fft2(squeeze(deconvlucy(imgRecon(:,:,4),psf_n,4))));
    aa5=fftshift(fft2(squeeze(imgRecon(:,:,5))));
    % aa5=fftshift(fft2(squeeze(deconvlucy(imgRecon(:,:,5),psf_n,4))));
    aa6=fftshift(fft2(squeeze(imgRecon(:,:,6))));
    % aa6=fftshift(fft2(squeeze(deconvlucy(imgRecon(:,:,6),psf_n,4))));
    aa7=fftshift(fft2(squeeze(imgRecon(:,:,7))));
    % aa7=fftshift(fft2(squeeze(deconvlucy(imgRecon(:,:,7),psf_n,4))));
    aa8=fftshift(fft2(squeeze(imgRecon(:,:,8))));
    % aa8=fftshift(fft2(squeeze(deconvlucy(imgRecon(:,:,8),psf_n,4))));
    aa9=fftshift(fft2(squeeze(imgRecon(:,:,9))));
    % aa9=fftshift(fft2(squeeze(deconvlucy(imgRecon(:,:,9),psf_n,4))));
    
%% simple ifft
    % image=(squeeze(imgRecon(:,:,1))+squeeze(imgRecon(:,:,2))+squeeze(imgRecon(:,:,3))+squeeze(imgRecon(:,:,4))+squeeze(imgRecon(:,:,5))+squeeze(imgRecon(:,:,6))+squeeze(imgRecon(:,:,7))+squeeze(imgRecon(:,:,8))+squeeze(imgRecon(:,:,9)))/9;
%% simple combination
    %another combnation considering wiener or other method can apply in
    %this place
    image=ifft2(ifftshift((aa1+aa2+aa3+aa4+aa5+aa6+aa7+aa8+aa9)/3));
    imgSave = uint8(image/max(image(:))*255) ;
    figure
    imshow(imgSave, []);
    toc
    imwrite(imgSave,[filepath,filenum,filename((times_pmsim)+6),fileaft,'Result','.','tiff'],'tiff');
%%
    %simple process conpensating for the pre-processing 
    filestyle='tiff';
    skadada=double(imread([filepath,filenum,filename((times_pmsim)+6),fileaft,'Result','.',filestyle]));%
    skadada=real(skadada).*(real(skadada>0));
    skadada=wiener2(skadada,[4 4]);
    skadada=deconvlucy(skadada,psf_n,4);
    skadada=uint8(skadada./max(skadada(:))*255);
    figure;
    imshow(skadada);
    title('3');
    imwrite(skadada,[filepath,filenum,filename((times_pmsim)+6),fileaft,'Result2','.',filestyle],filestyle);
%%
end