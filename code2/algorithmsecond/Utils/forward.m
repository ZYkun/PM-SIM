function forward_proj=forward(img,noise,psf,modulation)
angles=size(img,3);
a=size(psf,1)/2;
b=size(noise,1);
forward_proj=zeros(size(noise,1),size(noise,2),angles);
for i=1:angles
%     temp1=fftconv(img(:,:,i),psf);
    temp1=conv2(img(:,:,i),psf,'same');
    temp2=modulation(i)*(temp1(a:a+b-1,a:a+b-1)+idct(idct(noise')'));
    forward_proj(:,:,i)=max(temp2,10^-6);
end

% function forward_proj = forward(img, noise, psf, modulation)
%     
%     psf_gpu = gpuArray(psf);
%     noise_gpu = gpuArray(noise);
%     img_gpu = gpuArray(img);
%     modulation_gpu = gpuArray(modulation);
%     
%     angles = size(img_gpu, 3);
%     a = size(psf_gpu, 1) / 2;
%     b = size(noise_gpu, 1);
%     
%     % 封装每个角度的计算
%     calculate_angle = @(i) calculate_single_angle(img_gpu(:,:,i), psf_gpu, noise_gpu, a, b, modulation_gpu(i));
%     % 使用数组化同时计算所有角度
%     forward_proj = arrayfun(calculate_angle, 1:angles, 'UniformOutput', false);
%     forward_proj = cat(3, forward_proj{:});
%     % 将GPU数组转换为CPU数组
%     forward_proj = gather(forward_proj);
% 
% 
% function proj = calculate_single_angle(img, psf, noise, a, b, modulation)
%     temp1 = imfilter((img), psf, 'conv');
%     tempadd = (idct(idct(((noise))')'));%gpuArray
%     temp2 = modulation * (temp1(a:a+b-1,a:a+b-1) + tempadd);
%     proj = max(temp2, 10^-6);
    
%     
%     
%     
% function result=fftconv(a,b) %noise fill and blend psf with noise
% s=abs(size(a,1)-size(b,1));
% bfix=padarray(b,[s/2 s/2]);
% fa=ft(a);
% fb=ft(bfix);
% fresult=fa.*fb;
% result=ift(fresult);

function f=ft(a)
f = fftshift(fft2(fftshift(a)));

function f=ift(a)
f = ifftshift(ifft2(ifftshift(a)));