function Kalman_Stack_Filter_modified(folder,N,gain,percentvar,bf_flag)
%
% Purpose
% Implements a predictive Kalman-like filter in the time domain of the image
% stack. Algorithm taken from Java code by C.P. Mauer.
% http://rsb.info.nih.gov/ij/plugins/kalman.html
%
% Inputs
% imageStack - a 3d matrix comprising of a noisy image sequence. Time is
%              the 3rd dimension.
% gain - the strength of the filter [0 to 1]. Larger gain values means more
%        aggressive filtering in time so a smoother function with a lower
%        peak. Gain values above 0.5 will weight the predicted value of the
%        pixel higher than the observed value.
% percentvar - the initial estimate for the noise [0 to 1]. Doesn't have
%              much of an effect on the algorithm.
%
% Output
% imageStack - the filtered image stack
%
% Note:
% The time series will look noisy at first then become smoother as the
% filter accumulates evidence.
%
% Rob Campbell, August 2009
%
% modified Nov 2014 Olivier Schwab for lazy loading
% 
% modified Apr 2018 Henry Lewis initialize filter on duplicate first 10 frames to
% avoid losing info
% 
% modified again Jul 2018 Henry Lewis for fast loading


% Process input arguments
if nargin<2, gain=0.5;          end
if nargin<3, percentvar = 0.05; end


if gain>1.0||gain<0.0
    gain = 0.8;
end

if percentvar>1.0 || percentvar<0.0
    percentvar = 0.05;
end


% % NEW CODE % %

% load image stack
if bf_flag
    s = load([folder,'/image_stack_bf.mat'],'image_stack');
else
    s = load([folder,'/image_stack.mat'],'image_stack');
end
image_stack = s.image_stack;

% load 11th image
%s = load([folder,'/image',num2str(11),'.mat'],'imagei');
predicted=double(image_stack(:,:,11));

% Set up variables
width = size(predicted,1);
height = size(predicted,2);

tmp=ones(width,height);

% Set up priors
predictedvar = tmp*percentvar;
noisevar=predictedvar;

% Initialize Kalman filter on first 10 frames
for i = 1:9
    %s = load([folder,'/image',num2str(11-i),'.mat'],'imagei');
    observed = double(image_stack(:,:,11-i));
    
    Kalman = predictedvar ./ (predictedvar+noisevar);
    corrected = gain*predicted + (1.0-gain)*observed + Kalman.*(observed-predicted);
    correctedvar = predictedvar.*(tmp - Kalman);
    
    predictedvar = correctedvar;
    predicted = corrected;
end

% Now conduct filtering on image stack
for i=1:N
    %s=load([folder,'/image',num2str(i),'.mat'],'imagei');
    observed = double(image_stack(:,:,i));
    
    Kalman = predictedvar ./ (predictedvar+noisevar);
    corrected = gain*predicted + (1.0-gain)*observed + Kalman.*(observed-predicted);
    correctedvar = predictedvar.*(tmp - Kalman);
    
    predictedvar = correctedvar;
    predicted = corrected;
    image_stack(:,:,i) = corrected;
    
    %save stack
    %save([folder,'/image',num2str(i),'.mat'],'imagei','-v7.3')
end

% save stack
if ~bf_flag
    save([folder,'/image_stack.mat'],'image_stack','-v7.3')
else
    save([folder,'/image_stack_bf.mat'],'image_stack','-v7.3')
end
% % OLD CODE % %

% %load first images
% s=load([folder,'/image',num2str(1),'.mat'],'imagei');
% predicted=double(s.imagei);
% 
% %Set up variables
% width = size(predicted,1);
% height = size(predicted,2);
% 
% tmp=ones(width,height);
% 
% %Set up priors
% predictedvar = tmp*percentvar;
% noisevar=predictedvar;
% 
% 
% %Now conduct the Kalman-like filtering on the image stack
% for i=2:N
%     s=load([folder,'/image',num2str(i),'.mat'],'imagei');
%     observed=double(s.imagei);
%     
%     Kalman = predictedvar ./ (predictedvar+noisevar);
%     corrected = gain*predicted + (1.0-gain)*observed + Kalman.*(observed-predicted);
%     correctedvar = predictedvar.*(tmp - Kalman);
%     
%     predictedvar = correctedvar;
%     predicted = corrected;
%     imagei=corrected;
%     
%     %save shortened stack
%     if i>10
%         save([folder,'/image',num2str(i-10),'.mat'],'imagei','-v7.3')
%     end
% end
% 
% %delete the old image files (N-10:N)
% for i=N-9:N
%    delete([folder,'/image',num2str(i),'.mat']) 
% end
% 
