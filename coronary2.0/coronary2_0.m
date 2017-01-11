  I=double(imread ('c_lm_29.jpg'));
  options  = struct('FrangiScaleRange', [1 10], 'FrangiScaleRatio', 2, 'FrangiBetaOne', 0.5, 'FrangiBetaTwo', 15, 'verbose',true,'BlackWhite',true);
  
  Ivessel=FrangiFilter2D(I,options);
  figure,
  subplot(1,2,1), imshow(I,[]);
  subplot(1,2,2), imshow(Ivessel,[0 0.25]);