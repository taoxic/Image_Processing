function [ pos, scale, orient, desc ] = features_detection( im, octaves, intervals, object_mask, contrast_threshold, curvature_threshold, interactive )
% assign default values to the input variables
if ~exist('octaves')
   octaves = 4;
end
if ~exist('intervals')
   intervals = 2;
end
if ~exist('object_mask')
   object_mask = ones(size(im));
end
if size(object_mask) ~= size(im)
   object_mask = ones(size(im));
end
if ~exist('contrast_threshold')
   contrast_threshold = 0.02;
end
if ~exist('curvature_threshold')
   curvature_threshold = 10.0;
end
if ~exist('interactive')
   interactive = 1;
end
tic;
antialias_sigma = 0.5;
if antialias_sigma == 0
   signal = im;
else
   g = gaussian_filter( antialias_sigma );
   if exist('corrsep') == 3
	   signal = corrsep( g, g, im );
   else
      signal = conv2( g, g, im, 'same' );
   end
end
signal = im;
[X Y] = meshgrid( 1:0.5:size(signal,2), 1:0.5:size(signal,1) );
signal = interp2( signal, X, Y, '*linear' );   
subsample = [0.5]; % subsampling rate for doubled image is 1/2
preblur_sigma = sqrt(sqrt(2)^2 - (2*antialias_sigma)^2);
if preblur_sigma == 0
   gauss_pyr{1,1} = signal;
else
   g = gaussian_filter( preblur_sigma );
   if exist('corrsep') == 3
      gauss_pyr{1,1} = corrsep( g, g, signal );
   else
      gauss_pyr{1,1} = conv2( g, g, signal, 'same' );
   end
end
clear signal
pre_time = toc;
initial_sigma = sqrt( (2*antialias_sigma)^2 + preblur_sigma^2 );
absolute_sigma = zeros(octaves,intervals+3);
absolute_sigma(1,1) = initial_sigma * subsample(1);
filter_size = zeros(octaves,intervals+3);
filter_sigma = zeros(octaves,intervals+3);
tic;
for octave = 1:octaves
   sigma = initial_sigma;
   g = gaussian_filter( sigma );
   filter_size( octave, 1 ) = length(g);
   filter_sigma( octave, 1 ) = sigma;
   DOG_pyr{octave} = zeros(size(gauss_pyr{octave,1},1),size(gauss_pyr{octave,1},2),intervals+2);
   for interval = 2:(intervals+3)
      sigma_f = sqrt(2^(2/intervals) - 1)*sigma;
      g = gaussian_filter( sigma_f );
      sigma = (2^(1/intervals))*sigma;
       absolute_sigma(octave,interval) = sigma * subsample(octave);
       filter_size(octave,interval) = length(g);
      filter_sigma(octave,interval) = sigma;
      if exist('corrsep') == 3
         gauss_pyr{octave,interval} = corrsep( g, g, gauss_pyr{octave,interval-1} );
      else
         gauss_pyr{octave,interval} = conv2( g, g, gauss_pyr{octave,interval-1}, 'same' );
      end      
      DOG_pyr{octave}(:,:,interval-1) = gauss_pyr{octave,interval} - gauss_pyr{octave,interval-1};        
   end      
   if octave < octaves
      sz = size(gauss_pyr{octave,intervals+1});
      [X Y] = meshgrid( 1:2:sz(2), 1:2:sz(1) );
      gauss_pyr{octave+1,1} = interp2(gauss_pyr{octave,intervals+1},X,Y,'*nearest'); 
      absolute_sigma(octave+1,1) = absolute_sigma(octave,intervals+1);
      subsample = [subsample subsample(end)*2];
   end      
end
pyr_time = toc;
if interactive >= 2
   sz = zeros(1,2);
   sz(2) = (intervals+3)*size(gauss_pyr{1,1},2);
   for octave = 1:octaves
      sz(1) = sz(1) + size(gauss_pyr{octave,1},1);
   end
   pic = zeros(sz);
   y = 1;
   for octave = 1:octaves
      x = 1;
      sz = size(gauss_pyr{octave,1});
      for interval = 1:(intervals + 3)
			pic(y:(y+sz(1)-1),x:(x+sz(2)-1)) = gauss_pyr{octave,interval};		         
         x = x + sz(2);
      end
      y = y + sz(1);
   end
   
   %clf;
%    figure,imshow(pic);
%     imwrite(pic,'1.bmp');
%    fig = figure;
%    resizeImageFig( fig, size(pic), 0.25 );
   %pause;
   %close(fig)
end
if interactive >= 2
   sz = zeros(1,2);
   sz(2) = (intervals+2)*size(DOG_pyr{1}(:,:,1),2);
   for octave = 1:octaves
      sz(1) = sz(1) + size(DOG_pyr{octave}(:,:,1),1);
   end
   pic = zeros(sz);
   y = 1;
   for octave = 1:octaves
      x = 1;
      sz = size(DOG_pyr{octave}(:,:,1));
      for interval = 1:(intervals + 2)
			pic(y:(y+sz(1)-1),x:(x+sz(2)-1)) = DOG_pyr{octave}(:,:,interval);		         
         x = x + sz(2);
      end
      y = y + sz(1);
   end
  
   %clf;
%    figure,imagesc(pic),colormap gray;
%    imwrite(pic,'2.bmp');
% %     fig = figure;
%    resizeImageFig( fig, size(pic), 0.25 );
   %pause;
   %close(fig)
end
curvature_threshold = ((curvature_threshold + 1)^2)/curvature_threshold;
xx = [ 1 -2  1 ];
yy = xx';
xy = [ 1 0 -1; 0 0 0; -1 0 1 ]/4;
raw_keypoints = [];
contrast_keypoints = [];
curve_keypoints = [];
tic;
loc = cell(size(DOG_pyr)); % boolean maps of keypoints
for octave = 1:octaves
   for interval = 2:(intervals+1)
      keypoint_count = 0;
      contrast_mask = abs(DOG_pyr{octave}(:,:,interval)) >= contrast_threshold;
      loc{octave,interval} = zeros(size(DOG_pyr{octave}(:,:,interval)));
      if exist('corrsep') == 3
         edge = 1;
      else         
         edge = ceil(filter_size(octave,interval)/2);
      end      
      for y=(1+edge):(size(DOG_pyr{octave}(:,:,interval),1)-edge)         
         for x=(1+edge):(size(DOG_pyr{octave}(:,:,interval),2)-edge)
            if object_mask(round(y*subsample(octave)),round(x*subsample(octave))) == 1 
               if( (interactive >= 2) | (contrast_mask(y,x) == 1) ) 
                    tmp = DOG_pyr{octave}((y-1):(y+1),(x-1):(x+1),(interval-1):(interval+1));  
                  pt_val = tmp(2,2,2);
                  if( (pt_val == min(tmp(:))) | (pt_val == max(tmp(:))) )
                      raw_keypoints = [raw_keypoints; x*subsample(octave) y*subsample(octave)];
                     if abs(DOG_pyr{octave}(y,x,interval)) >= contrast_threshold
                         contrast_keypoints = [contrast_keypoints; raw_keypoints(end,:)];
                         Dxx = sum(DOG_pyr{octave}(y,x-1:x+1,interval) .* xx);
                        Dyy = sum(DOG_pyr{octave}(y-1:y+1,x,interval) .* yy);
                        Dxy = sum(sum(DOG_pyr{octave}(y-1:y+1,x-1:x+1,interval) .* xy));
                        Tr_H = Dxx + Dyy;
                        Det_H = Dxx*Dyy - Dxy^2;
                        curvature_ratio = (Tr_H^2)/Det_H;
                        if ((Det_H >= 0) & (curvature_ratio < curvature_threshold))
                           curve_keypoints = [curve_keypoints; raw_keypoints(end,:)];
                           loc{octave,interval}(y,x) = 1;
                           keypoint_count = keypoint_count + 1;
                        end
                     end                  
                  end
               end               
            end
         end         
      end
   end
end
keypoint_time = toc;
% if interactive >= 2
%    %clf;
%    figure,imshow(im44);
% % %     fig = figure;
%    hold on;
%    plot(raw_keypoints(:,1),raw_keypoints(:,2),'y+');
%    resizeImageFig( fig, size(im), 2 );
%    %%pause;
%    %close(fig);
%    %clf;
%    figure,imshow(im44);
% % %     fig = figure;
%    hold on;
%    plot(contrast_keypoints(:,1),contrast_keypoints(:,2),'y+');
% %    resizeImageFig( fig, size(im), 2 );
%    %%pause;
%    %close(fig);
%    %clf;
%    figure,imshow(im44); 
% % %    fig = figure;
%    hold on;
%    plot(curve_keypoints(:,1),curve_keypoints(:,2),'y+');
% %    resizeImageFig( fig, size(im), 2 );
%    %%pause;
%    %close(fig);  
%  end
clear raw_keypoints contrast_keypoints curve_keypoints
g = gaussian_filter( 1.5 * absolute_sigma(1,intervals+3) / subsample(1) );
zero_pad = ceil( length(g) / 2 );
tic;
mag_thresh = zeros(size(gauss_pyr));
mag_pyr = cell(size(gauss_pyr));
grad_pyr = cell(size(gauss_pyr));
for octave = 1:octaves
   for interval = 2:(intervals+1)      
      % Compute x and y derivatives using pixel differences
      diff_x = 0.5*(gauss_pyr{octave,interval}(2:(end-1),3:(end))-gauss_pyr{octave,interval}(2:(end-1),1:(end-2)));
      diff_y = 0.5*(gauss_pyr{octave,interval}(3:(end),2:(end-1))-gauss_pyr{octave,interval}(1:(end-2),2:(end-1)));
      % Compute the magnitude of the gradient
      mag = zeros(size(gauss_pyr{octave,interval}));      
      mag(2:(end-1),2:(end-1)) = sqrt( diff_x .^ 2 + diff_y .^ 2 );
      % Store the magnitude of the gradient in the pyramid with zero padding
      mag_pyr{octave,interval} = zeros(size(mag)+2*zero_pad);
      mag_pyr{octave,interval}((zero_pad+1):(end-zero_pad),(zero_pad+1):(end-zero_pad)) = mag;      
      % Compute the orientation of the gradient
      grad = zeros(size(gauss_pyr{octave,interval}));
      grad(2:(end-1),2:(end-1)) = atan2( diff_y, diff_x );
      grad(find(grad == pi)) = -pi;
      % Store the orientation of the gradient in the pyramid with zero padding
      grad_pyr{octave,interval} = zeros(size(grad)+2*zero_pad);
      grad_pyr{octave,interval}((zero_pad+1):(end-zero_pad),(zero_pad+1):(end-zero_pad)) = grad;
   end
end
clear mag grad
grad_time = toc;
num_bins = 36;
hist_step = 2*pi/num_bins;
hist_orient = [-pi:hist_step:(pi-hist_step)];
pos = [];
orient = [];
scale = [];
tic;
for octave = 1:octaves
   for interval = 2:(intervals + 1)        
      keypoint_count = 0;
      g = gaussian_filter( 1.5 * absolute_sigma(octave,interval)/subsample(octave) );
      hf_sz = floor(length(g)/2);
      g = g'*g;      
      % Zero pad the keypoint location map.
      loc_pad = zeros(size(loc{octave,interval})+2*zero_pad);
      loc_pad((zero_pad+1):(end-zero_pad),(zero_pad+1):(end-zero_pad)) = loc{octave,interval};
      [iy ix]=find(loc_pad==1);
      for k = 1:length(iy)
         x = ix(k);
         y = iy(k);
         wght = g.*mag_pyr{octave,interval}((y-hf_sz):(y+hf_sz),(x-hf_sz):(x+hf_sz));
         grad_window = grad_pyr{octave,interval}((y-hf_sz):(y+hf_sz),(x-hf_sz):(x+hf_sz));
         orient_hist=zeros(length(hist_orient),1);
         for bin=1:length(hist_orient)
            diff = mod( grad_window - hist_orient(bin) + pi, 2*pi ) - pi;
            orient_hist(bin)=orient_hist(bin)+sum(sum(wght.*max(1 - abs(diff)/hist_step,0)));
         end
         peaks = orient_hist;        
         rot_right = [ peaks(end); peaks(1:end-1) ];
         rot_left = [ peaks(2:end); peaks(1) ];         
         peaks( find(peaks < rot_right) ) = 0;
         peaks( find(peaks < rot_left) ) = 0;
         [max_peak_val ipeak] = max(peaks);
         peak_val = max_peak_val;
         while( peak_val > 0.8*max_peak_val )			            
            A = [];
            b = [];
            for j = -1:1
               A = [A; (hist_orient(ipeak)+hist_step*j).^2 (hist_orient(ipeak)+hist_step*j) 1];
	            bin = mod( ipeak + j + num_bins - 1, num_bins ) + 1;
               b = [b; orient_hist(bin)];
            end
            c = pinv(A)*b;
            max_orient = -c(2)/(2*c(1));
            while( max_orient < -pi )
               max_orient = max_orient + 2*pi;
            end
            while( max_orient >= pi )
               max_orient = max_orient - 2*pi;
            end            
            % Store the keypoint position, orientation, and scale information
            pos = [pos; [(x-zero_pad) (y-zero_pad)]*subsample(octave) ];
            orient = [orient; max_orient];
            scale = [scale; octave interval absolute_sigma(octave,interval)];
            keypoint_count = keypoint_count + 1;
            peaks(ipeak) = 0;
            [peak_val ipeak] = max(peaks);
         end         
      end       
   end
end
clear loc loc_pad 
orient_time = toc;
% Display the keypoints with scale and orientation in interactive mode.
% if interactive >= 2
%   
%    %clf;
%    figure,imshow(im); 
% %   fig = figure;
%    hold on;
%    display_keypoints( pos, scale(:,3), orient, 'y' );
% %   resizeImageFig( fig, size(im), 2 );
%    %close(fig);
%  end
orient_bin_spacing = pi/4;
orient_angles = [-pi:orient_bin_spacing:(pi-orient_bin_spacing)];
grid_spacing = 4;
[x_coords y_coords] = meshgrid( [-6:grid_spacing:6] );
feat_grid = [x_coords(:) y_coords(:)]';
[x_coords y_coords] = meshgrid( [-(2*grid_spacing-0.5):(2*grid_spacing-0.5)] );
feat_samples = [x_coords(:) y_coords(:)]';
feat_window = 2*grid_spacing;
desc = [];
for k = 1:size(pos,1)
   x = pos(k,1)/subsample(scale(k,1));
   y = pos(k,2)/subsample(scale(k,1));   
   M = [cos(orient(k)) -sin(orient(k)); sin(orient(k)) cos(orient(k))];
   feat_rot_grid = M*feat_grid + repmat([x; y],1,size(feat_grid,2));
   feat_rot_samples = M*feat_samples + repmat([x; y],1,size(feat_samples,2));
   feat_desc = zeros(1,128);
   for s = 1:size(feat_rot_samples,2)
      x_sample = feat_rot_samples(1,s);
      y_sample = feat_rot_samples(2,s);
      [X Y] = meshgrid( (x_sample-1):(x_sample+1), (y_sample-1):(y_sample+1) );
      G = interp2( gauss_pyr{scale(k,1),scale(k,2)}, X, Y, '*linear' );
      G(find(isnan(G))) = 0;
      diff_x = 0.5*(G(2,3) - G(2,1));
      diff_y = 0.5*(G(3,2) - G(1,2));
      mag_sample = sqrt( diff_x^2 + diff_y^2 );
      grad_sample = atan2( diff_y, diff_x );
      if grad_sample == pi
         grad_sample = -pi;
      end      
      x_wght = max(1 - (abs(feat_rot_grid(1,:) - x_sample)/grid_spacing), 0);
      y_wght = max(1 - (abs(feat_rot_grid(2,:) - y_sample)/grid_spacing), 0); 
      pos_wght = reshape(repmat(x_wght.*y_wght,8,1),1,128);
      diff = mod( grad_sample - orient(k) - orient_angles + pi, 2*pi ) - pi;
      orient_wght = max(1 - abs(diff)/orient_bin_spacing,0);
      orient_wght = repmat(orient_wght,1,16);         
      g = exp(-((x_sample-x)^2+(y_sample-y)^2)/(2*feat_window^2))/(2*pi*feat_window^2);
      feat_desc = feat_desc + pos_wght.*orient_wght*g*mag_sample;
   end
   feat_desc = feat_desc / norm(feat_desc);
   feat_desc( find(feat_desc > 0.2) ) = 0.2;
   feat_desc = feat_desc / norm(feat_desc);
   desc = [desc; feat_desc];
end
desc_time = toc;
sample_offset = -(subsample - 1);
for k = 1:size(pos,1)
   pos(k,:) = pos(k,:) + sample_offset(scale(k,1));
end
if size(pos,1) > 0
	scale = scale(:,3);
end
end
%%
function [g,x] = gaussian_filter( sigma, sample )

sample = 3.5;
if ~exist('sample')
   sample = 7.0/2.0;
end
% Determine the number of filter taps.
n = 2*round(sample * sigma)+1;
% Generate the x values.
x=1:n;
x=x-ceil(n/2);
% Sample the gaussian function to generate the filter taps.
g = exp(-(x.^2)/(2*sigma^2))/(sigma*sqrt(2*pi));
end