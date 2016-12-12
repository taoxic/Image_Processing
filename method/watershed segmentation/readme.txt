Separating touching objects in an image is one of the more difficult image processing operations. The watershed transform is often applied to this problem. The watershed transform finds "catchment basins"(��ˮ��) and "watershed ridge lines"(ɽ����) in an image by treating it as a surface where light pixels are high and dark pixels are low.
���ͼ���е�Ŀ��������������һ��ģ���ָ�����������ѣ���ˮ��ָ��㷨�������ڴ����������⣬ͨ����ȡ�ñȽϺõ�Ч������ˮ��ָ��㷨��ͼ�񿴳�һ��������ͼ�����������ȱȽ�ǿ����������ֵ�ϴ󣬶��Ƚϰ�����������ֵ��С��ͨ��Ѱ�ҡ���ˮ��ء��͡���ˮ����ޡ�����ͼ����зָ
Segmentation using the watershed transform works better if you can identify, or "mark," foreground objects and background locations. Marker-controlled watershed segmentation follows this basic procedure:
ֱ��Ӧ�÷�ˮ��ָ��㷨��Ч�����������ã������ͼ���ж�ǰ������ͱ���������б�ע������Ӧ�÷�ˮ���㷨��ȡ�ýϺõķָ�Ч�������ڱ�ǿ��Ƶķ�ˮ��ָ�������»������裺
1. Compute a segmentation function. This is an image whose dark regions are the objects you are trying to segment.
1.����ָ����ͼ���нϰ���������Ҫ�ָ�Ķ���
2. Compute foreground markers. These are connected blobs of pixels within each of the objects.
2.����ǰ����־����Щ��ÿ�������ڲ����ӵİߵ����ء�
3. Compute background markers. These are pixels that are not part of any object.
3.���㱳����־����Щ�ǲ������κζ�������ء�
4. Modify the segmentation function so that it only has minima at the foreground and background marker locations.
4.�޸ķָ����ʹ�����ǰ���ͺ󾰱��λ���м�Сֵ��
5. Compute the watershed transform of the modified segmentation function.
5.���޸ĺ�ķָ������ˮ��任���㡣
Use by Matlab Image Processing Toolbox
ʹ��MATLABͼ��������
ע���ڼ��õ��˺ܶ�ͼ��������ĺ���������fspecial��imfilter��watershed��label2rgb��imopen��imclose��imreconstruct��imcomplement��imregionalmax��bwareaopen��graythresh��imimposemin�����ȡ�