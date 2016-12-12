Separating touching objects in an image is one of the more difficult image processing operations. The watershed transform is often applied to this problem. The watershed transform finds "catchment basins"(集水盆) and "watershed ridge lines"(山脊线) in an image by treating it as a surface where light pixels are high and dark pixels are low.
如果图像中的目标物体是连接在一起的，则分割起来会更困难，分水岭分割算法经常用于处理这类问题，通常会取得比较好的效果。分水岭分割算法把图像看成一幅“地形图”，其中亮度比较强的区域像素值较大，而比较暗的区域像素值较小，通过寻找“汇水盆地”和“分水岭界限”，对图像进行分割。
Segmentation using the watershed transform works better if you can identify, or "mark," foreground objects and background locations. Marker-controlled watershed segmentation follows this basic procedure:
直接应用分水岭分割算法的效果往往并不好，如果在图像中对前景对象和背景对象进行标注区别，再应用分水岭算法会取得较好的分割效果。基于标记控制的分水岭分割方法有以下基本步骤：
1. Compute a segmentation function. This is an image whose dark regions are the objects you are trying to segment.
1.计算分割函数。图像中较暗的区域是要分割的对象。
2. Compute foreground markers. These are connected blobs of pixels within each of the objects.
2.计算前景标志。这些是每个对象内部连接的斑点像素。
3. Compute background markers. These are pixels that are not part of any object.
3.计算背景标志。这些是不属于任何对象的像素。
4. Modify the segmentation function so that it only has minima at the foreground and background marker locations.
4.修改分割函数，使其仅在前景和后景标记位置有极小值。
5. Compute the watershed transform of the modified segmentation function.
5.对修改后的分割函数做分水岭变换计算。
Use by Matlab Image Processing Toolbox
使用MATLAB图像处理工具箱
注：期间用到了很多图像处理工具箱的函数，例如fspecial、imfilter、watershed、label2rgb、imopen、imclose、imreconstruct、imcomplement、imregionalmax、bwareaopen、graythresh和imimposemin函数等。