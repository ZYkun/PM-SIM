% img1(:,:)=double(imread(['C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\sim&sim\','name_success_','200','.','tiff']));%格式化命名 ;
% % figure;
% % imshow(uint8(img1./max(img1(:))*255));
% skadada=zeros(size(img1(:,:)));
% skadada=double(img1);
% skadada=real(skadada).*(real(skadada>0));
% figure;
% imshow(uint8(skadada./max(skadada(:))*255));
% skadada=deconvlucy(skadada,psf_n,3);%3 for pm deconvolution    %4 for other things
% skadada=wiener2(skadada,[2 2]);%[2 2] for pm deconvolution    %[6 6] for other things
% % skadada_edge=edge(skadada,'Canny',0.10);
% % skadada=skadada_edge;
% % skadada=skadada_edge*3+skadada;
% % skadada=auto_adjusting(skadada);
% skadada=uint8(skadada./max(skadada(:))*255);
% figure;
% imshow(skadada);

%%
%import and process afterwards

    %C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\sim&sim
    %  C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\cmb
filepath='D:\20230719_pmsim\20230719_pmsim\15\tallabc\';
filename='name';
filename2='name2';
filestyle='tiff';
skadada=double(imread([filepath,filename,'.',filestyle]));%格式化命名 ;







skadada=real(skadada).*(real(skadada>0));
skadada=wiener2(skadada,[4 4]);
skadada=deconvlucy(skadada,psf_n,4);
% skadada=deconvlucy(skadada,psf_n,4);
% skadada=deconvlucy(skadada,psf_n,4);
% skadada=deconvlucy(skadada,psf_n,4);
% skadada=deconvlucy(skadada,psf_n,4);
% skadada=deconvlucy(skadada,psf_n,4);
% skadada=deconvlucy(skadada,psf_n,4);
% skadada=wiener2(skadada,[6 6]);
%skadada_edge=edge(skadada,'Canny',0.12);
%skadada=skadada_edge*3+skadada;
% skadada=auto_adjusting(skadada);
skadada=uint8(skadada./max(skadada(:))*255);
figure;
imshow(skadada);
title('3');
imwrite(skadada,[filepath,filename2,'.',filestyle],filestyle);

%%
% for ii=1:9
%     
%         noiseimage(:,:,ii)=...
%         double(imread(['C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\0625pmsimsimulation\turblin3\alldir\1_XSIM',num2str(ii),'.','tif']));%格式化命名
%     %noiseimage(:,:,ii,jj)=circshift(noiseimage(:,:,ii,jj),[2,-1]);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%calibration of system
%     
% end
% aa1=fftshift(fft2(squeeze(noiseimage(:,:,1))));
% aa2=fftshift(fft2(squeeze(noiseimage(:,:,2))));
% aa3=fftshift(fft2(squeeze(noiseimage(:,:,3))));
% aa4=fftshift(fft2(squeeze(noiseimage(:,:,4))));
% aa5=fftshift(fft2(squeeze(noiseimage(:,:,5))));
% aa6=fftshift(fft2(squeeze(noiseimage(:,:,6))));
% aa7=fftshift(fft2(squeeze(noiseimage(:,:,7))));
% aa8=fftshift(fft2(squeeze(noiseimage(:,:,8))));
% aa9=fftshift(fft2(squeeze(noiseimage(:,:,9))));
% image=ifft2(ifftshift((aa1+aa2+aa3+aa4+aa5+aa6+aa7+aa8+aa9)/9));
% imgSave = uint8(image./max(image(:))*255) ;
% figure
% imshow(imgSave, []);
% imwrite(imgSave,'C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\0625pmsimsimulation\turblin3\alldir\simpleadd.tiff','tiff');


% imgSave=imgSave+skadada/2;
% imgSave(imgSave<0)=0;
% imgSave=real(imgSave);
% imgSave = uint8(imgSave/max(max(imgSave(:)))*255) ;
% figure
% imshow(imgSave, []);