coronary3.0是在coronary1.2结果的基础上与coronary2.0相结合，并改进。达到较好效果。<br>
##原始图像<br>
<table ><tr>
<td align="center" valign="middle">正常血管</td>
<td align="center" valign="middle">狭窄血管</td>
<td align="center" valign="middle">带支架血管</td>
</tr><tr>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_cqj_37.bmp" width = "250" height = "250" /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_lm_29.bmp" width = "250" height = "250" /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary1.2/c_gc_40.bmp" width = "250" height = "250" /></td>
</tr></table><br>
##coronary1.2的结果<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/c_result/result9.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/lm_result/result9.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/gc_result/result9.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###1、对图像进行膨胀处理，目的得到血管的图像块<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/c_result/result1.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/lm_result/result1.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/gc_result/result1.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###2、使用血管块图像在原图上作用，取得已去除背景的原始血管图像I1<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/c_result/result2.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/lm_result/result2.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/gc_result/result2.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###3、对原始图像进行平滑滤波，使用血管块作用得到平滑后的背景图像I2<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/c_result/result3.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/lm_result/result3.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/gc_result/result3.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###4、将图像I1，I2进行结合<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/c_result/result4.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/lm_result/result4.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/gc_result/result4.bmp" width = "250" height = "250" /></td>
</tr></table><br>
###5、对得到的图像使用Frangi Filter处理，得到最终结果<br>
<table>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/c_result/result5.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/lm_result/result5.bmp" width = "250" height = "250"  /></td>
<td><img src="https://github.com/taoxic/matlab/raw/master/coronary3.0/gc_result/result5.bmp" width = "250" height = "250" /></td>
</tr></table><br>
