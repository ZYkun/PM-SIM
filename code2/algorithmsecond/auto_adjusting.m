function [bmpData]=auto_adjusting(bmpData)
% function [bmpData]=auto_adjusting(bmpFilePath)     aaaaaaaa
    MAX_COLOR_VALUE = 255.0;
    PERCENTILE = 0.3;
    bias_size=30;
    % Make intensities spread between 255*.95 and 255 * .25
    % here maxValue < minValue
    minValue = 191;
    maxValue = 64;

    % Read BMP file
%     bmpData = imread(bmpFilePath);              aaaaaaaa

    % Get image dimensions
    height = size(bmpData, 1);
    width = size(bmpData, 2);

    % Convert RGB image to double for calculations
    bmpData = double(bmpData);
    figure;
    imshow(bmpData/max(bmpData(:)));
    title('1');
%     imwrite(uint8(bmpData),'C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\confocal\Pol-TIRF-master\Pol-TIRF-master\testdata.tiff','tiff');
    
    red_min = minValue;
    red_max = maxValue;

%     green_min = minValue;
%     green_max = maxValue;
% 
%     blue_min = minValue;
%     blue_max = maxValue;

    for i = 1:height
        for j = 1:width
            red = bmpData(i, j, 1);
%             green = bmpData(i, j, 2);
%             blue = bmpData(i, j, 3);

%             if red<MAX_COLOR_VALUE*PERCENTILE
%                 red=MAX_COLOR_VALUE*PERCENTILE;
%             end
%             red=red-MAX_COLOR_VALUE*PERCENTILE;
%             
%             if red>MAX_COLOR_VALUE-MAX_COLOR_VALUE*PERCENTILE
%                 red=red-MAX_COLOR_VALUE*PERCENTILE;
%             end
            
            
            if red_min > red
                red_min = red;
            end
            if red_max < red
                red_max = red;
            end

%             if green_min > green
%                 green_min = green;
%             end
%             if green_max < green
%                 green_max = green;
%             end
% 
%             if blue_min > blue
%                 blue_min = blue;
%             end
%             if blue_max < blue
%                 blue_max = blue;
%             end
        end
    end

    % calculate scaling factor (max and min should be different to prevent division by zero)
    red_scale = 1.0;
    green_scale = 1.0;
    blue_scale = 1.0;

    if red_max > red_min
        red_scale = MAX_COLOR_VALUE / (red_max - red_min);
    end
%     if green_max > green_min
%         green_scale = MAX_COLOR_VALUE / (green_max - green_min);
%     end
%     if blue_max > blue_min
%         blue_scale = MAX_COLOR_VALUE / (blue_max - blue_min);
%     end

    % normalize pixels
    for i = 1:height
        for j = 1:width
            bmpData(i, j, 1) = uint8(red_scale * (bmpData(i, j, 1) - red_min));
%             bmpData(i, j, 2) = uint8(green_scale * (bmpData(i, j, 2) - green_min));
%             bmpData(i, j, 3) = uint8(blue_scale * (bmpData(i, j, 3) - blue_min));
        end
    end
    
    %%
    for i = 1:height
        for j = 1:width
            red = bmpData(i, j, 1);    
            if red_min > red
                red_min = red;
            end
            if red_max < red
                red_max = red;
            end
        end
    end
    for i = 1:height
        for j = 1:width
%             bmpData(i, j, 1) = uint8(bias_size+(MAX_COLOR_VALUE-2*bias_size)/(red_max-red_min) * (bmpData(i, j, 1) - red_min));
            bmpData(i, j, 1) = uint8(-bias_size+(MAX_COLOR_VALUE+2*bias_size)/(red_max-red_min) * (bmpData(i, j, 1) - red_min));
            if bmpData(i, j, 1)<1
                bmpData(i, j, 1)=0;
            end
            if bmpData(i, j, 1)>254
                bmpData(i, j, 1)=254;
            end
        end
    end
    %%
    figure;
    imshow(bmpData/max(bmpData(:)));
    title('2');
%     imwrite(uint8(bmpData),'C:\Users\Administrator.DESKTOP-4J8NU6O\Desktop\confocal\Pol-TIRF-master\Pol-TIRF-master\rocessdata.tiff','tiff');
end