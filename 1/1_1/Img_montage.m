function Img_montage
%防止计算时溢出用double，而显示图像的时候用uint8.
%为了节省存储空间，matlab为图像提供了特殊的数据类型uint8(8位无符号整数），以此方式存储的图像称作8位图像。
%tif图像是四维的
mri = uint8(zeros(128,128,1,27));

for frame = 1:27
%map是colormap，也就是X中值对应的颜色
    [mri(:,:,:,frame),map] = imread('mri.tif',frame);
end
montage(mri,map);