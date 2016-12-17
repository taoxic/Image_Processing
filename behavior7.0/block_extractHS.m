function Features = block_extractHS(imageFile)


 patchSize=16;  
 Features = [];
 
 image = imread(imageFile);
 image = rgb2gray(image);
 img = double(image);

[rows, cols] = size(image); 
 numpatch = floor(rows/patchSize);

for i = 1:numpatch-1
    for j = 1:numpatch-1
        descrips = [];
         block = img(i*patchSize+1:(i+1)*patchSize,j*patchSize+1:(j+1)*patchSize);
         block = uint8(block);
        [image, descrips, locs] = siftxt(block);
         if ~isempty(descrips)
             [featureVector,~] = extractHOGFeatures(block);%1*22032
              [n,~] = size(descrips);
              featureVector = repmat(featureVector,n,1);
              Features = [Features;featureVector,descrips];
         end
    end
end 
