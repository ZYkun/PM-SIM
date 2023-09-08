filepath='C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\opsii_data\11\';%replace with your file's path
filepath2='C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\opsii_data\22\';%replace with your file's path
filepath3='C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\opsii_data\33\';%replace with your file's path
filename='SIM';% the names should be 1_X1, 1_X2, ..., 1_X(a_num*p_num) in this case;
fileformat='tif';
origionimage(:,:,1)=...
        double(imread([filepath,filename,'.',fileformat]));%格式化命名,num2str((ii-1)*3+jj-1)
origionimage(:,:,2)=...
        double(imread([filepath2,filename,'.',fileformat]));%格式化命名
origionimage(:,:,3)=...
        double(imread([filepath3,filename,'.',fileformat]));%格式化命名
figure;
imshow(origionimage(:,:,1)/max(max(origionimage(:,:,1))));
mytemp=uint8(origionimage(:,:,1)/max(max(origionimage(:,:,1)))*255);
%circshift(mytemp,[1.5,2.6])
    imwrite(mytemp,hot(256),[filepath,'SIMc.',fileformat],fileformat);
    
    
figure;
imshow(origionimage(:,:,2)/max(max(origionimage(:,:,2))));
mytemp=uint8(origionimage(:,:,2)/max(max(origionimage(:,:,2)))*255);
mytemp=circshift(mytemp,[2,-1]);
    imwrite(mytemp,hot(256),[filepath2,'SIMc.',fileformat],fileformat);
    
    
figure;
imshow(origionimage(:,:,3)/max(max(origionimage(:,:,3))));
mytemp=uint8(origionimage(:,:,3)/max(max(origionimage(:,:,3)))*255);
mytemp=circshift(mytemp,[3,-1]);
    imwrite(mytemp,hot(256),[filepath3,'SIMc.',fileformat],fileformat);