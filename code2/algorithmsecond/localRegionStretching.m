function enhancedImage = localRegionStretching(bmpFilePath, windowSize)
    % Read BMP file
    image = imread(bmpFilePath);
    [height, width] = size(image);
    halfWindowSize = floor(windowSize / 2);
    enhancedImage = zeros(height, width);

    for i = 1:height
        for j = 1:width
            % get oral district area
            rowStart = max(i - halfWindowSize, 1);
            rowEnd = min(i + halfWindowSize, height);
            colStart = max(j - halfWindowSize, 1);
            colEnd = min(j + halfWindowSize, width);

            % district stratching
            localRegion = image(rowStart:rowEnd, colStart:colEnd);

            % oral district histgram
            localEnhancedRegion = histeq(localRegion);

            % result fit
            enhancedImage(i, j) = localEnhancedRegion(halfWindowSize + 1, halfWindowSize + 1);
        end
    end
    enhancedImage = uint8(enhancedImage);
    figure;
    imshow(enhancedImage/max(enhancedImage(:)));


