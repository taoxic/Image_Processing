function Img_montage
%��ֹ����ʱ�����double������ʾͼ���ʱ����uint8.
%Ϊ�˽�ʡ�洢�ռ䣬matlabΪͼ���ṩ���������������uint8(8λ�޷������������Դ˷�ʽ�洢��ͼ�����8λͼ��
%tifͼ������ά��
mri = uint8(zeros(128,128,1,27));

for frame = 1:27
%map��colormap��Ҳ����X��ֵ��Ӧ����ɫ
    [mri(:,:,:,frame),map] = imread('mri.tif',frame);
end
montage(mri,map);