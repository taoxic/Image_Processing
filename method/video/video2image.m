xyloObj = VideoReader('video/Chen Qing Jun(453842)_00000012.AVI');

nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;
FrameRate = xyloObj.FrameRate; % 15Ö¡²¥·ÅµÄ

mov(1:nFrames) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'), 'colormap', []);

for k = 1 : nFrames
    
    mov(k).cdata = read(xyloObj, k);
    str=strcat('pictures/',int2str(k),'.jpg');
    imwrite(mov(k).cdata(:,:,:),str);
end