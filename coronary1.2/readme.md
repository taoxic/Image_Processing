##原始图像<br>
<table ><tr>
<td align="center" valign="middle">正常血管</td>
<td align="center" valign="middle">狭窄血管</td>
<td align="center" valign="middle">带支架血管</td>
</tr><tr>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_cqj_37.bmp" width = "250" height = "250" alt="图片名称"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_lm_29.bmp" width = "250" height = "250" alt="图片名称"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_gc_40.bmp" width = "250" height = "250" alt="图片名称" /></td>
</tr></table><br>
###1、增强对比度<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_result/result1.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/lm_result/result1.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/gc_result/result1.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###2、使用sobel提取边缘<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_result/result2.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/lm_result/result2.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/gc_result/result2.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###3、增强对比度，转为二值图像<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_result/result3.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/lm_result/result3.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/gc_result/result3.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###4、去掉图像中面积小于8的区域<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_result/result4.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/lm_result/result4.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/gc_result/result4.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###5、根据patch块中图像值和的大小去噪<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_result/result5.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/lm_result/result5.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/gc_result/result5.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###6、对图像进行膨胀处理，使所有的血管连为整体<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_result/result6.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/lm_result/result6.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/gc_result/result6.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###7、去除孤立于血管外的块<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_result/result7.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/lm_result/result7.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/gc_result/result7.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###8、两个图像相减取绝对值，得到去除的图像块<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_result/result8.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/lm_result/result8.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/gc_result/result8.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###9、将已经去除的图像块应用到图像上
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_result/result9.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/lm_result/result9.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/gc_result/result9.bmp" width = "250" height = "250" /></td>
</tr></table><br>