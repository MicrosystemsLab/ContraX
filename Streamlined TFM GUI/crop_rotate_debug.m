% debug script for cropping tool
% clc
% clear all
% close all

% bugs:
    % FIXED!!!

try
    
%load what shared para we need
tfm_init_user_Nfiles = getappdata(0,'tfm_init_user_Nfiles');
tfm_init_user_filenamestack = getappdata(0,'tfm_init_user_filenamestack');
tfm_init_user_pathnamestack = getappdata(0,'tfm_init_user_pathnamestack');
tfm_init_user_vidext = getappdata(0,'tfm_init_user_vidext');
tfm_init_user_bf_filenamestack = getappdata(0,'tfm_init_user_bf_filenamestack');
tfm_init_user_bf_pathnamestack = getappdata(0,'tfm_init_user_bf_pathnamestack');
tfm_init_user_bf_vidext = getappdata(0,'tfm_init_user_bf_vidext');
tfm_init_user_binary1 = getappdata(0,'tfm_init_user_binary1');
% tfm_init_user_binary2 = getappdata(0,'tfm_init_user_binary2');
    % move binary 2 to draw functions?
tfm_init_user_binary3 = getappdata(0,'tfm_init_user_binary3');
    % might get rid of binary 3
tfm_init_user_outline1x = getappdata(0,'tfm_init_user_outline1x');
tfm_init_user_outline1y = getappdata(0,'tfm_init_user_outline1y');
tfm_init_user_outline2x = getappdata(0,'tfm_init_user_outline2x');
tfm_init_user_outline2y = getappdata(0,'tfm_init_user_outline2y');
tfm_init_user_outline3x = getappdata(0,'tfm_init_user_outline3x');
tfm_init_user_outline3y = getappdata(0,'tfm_init_user_outline3y');
tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
tfm_init_user_croplength = getappdata(0,'tfm_init_user_croplength');
tfm_init_user_cropwidth = getappdata(0,'tfm_init_user_cropwidth');
    % reget length width?
tfm_init_user_scale_factor = getappdata(0,'tfm_init_user_scale_factor');
tfm_init_user_area_factor = getappdata(0,'tfm_init_user_area_factor');
% things for display
tfm_init_user_preview_frame1 = getappdata(0,'tfm_init_user_preview_frame1');
tfm_init_user_bf_preview_frame1 = getappdata(0,'tfm_init_user_bf_preview_frame1');
tfm_init_user_counter = getappdata(0,'tfm_init_user_counter');

%read mask parameters
% tfm_init_user_croplength=str2double(get(h_init(1).edit_croplength,'String'));
% tfm_init_user_cropwidth=str2double(get(h_init(1).edit_cropwidth,'String'));
% tfm_init_user_area_factor=str2double(get(h_init(1).edit_area_factor,'String'));

% for loop over videos
for ivid = 1:tfm_init_user_Nfiles
    tic
    % status bar
%     sb = statusbar(h_init(1).fig,['Cropping videos... ',num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)),'%% done']);
%     sb.getComponent(0).setForeground(java.awt.Color.red);
    
%     % read mask parameters
%     tfm_init_user_conversion{ivid}=str2double(get(h_init(1).edit_conversion,'String'));
%     tfm_init_user_scale_factor{ivid}=str2double(get(h_init(1).edit_scale_factor,'String'));
    
    % get stack info
    info = imfinfo([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'.tif']);
    width = info(1).Width;
    height = info(1).Height;
    N_frames = numel(info);
    
    % initialize movie stacks bead and bf
    bead_vid = zeros(height,width,N_frames);
    bead_vid = im2uint8(bead_vid);
    bf_vid = bead_vid;
    
    % load frames
    for i = 1:N_frames
        bead_frameN = imread([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'.tif'],'tif',i);
        bead_vid(:,:,i) = bead_frameN;
        bf_frameN = imread([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'.tif'],'tif',i);
        bf_vid(:,:,i) = bf_frameN;
    end
    
    % get orientation
    init_stats = regionprops(tfm_init_user_binary1{ivid},'Orientation');
    angle = -init_stats.Orientation;
    
    % rotate bead/bf frames and mask
    bead_vid_rot = imrotate(bead_vid,angle);
    bf_vid_rot = imrotate(bf_vid,angle);
    mask_rot = imrotate(tfm_init_user_binary1{ivid},angle);
    
    % get new regionprops
    rot_stats = regionprops(mask_rot,'Centroid');
    rot_centroid = rot_stats.Centroid;
    
    % calculate crop dimensions
    crop_length = uint16(tfm_init_user_croplength/tfm_init_user_conversion{ivid});
    crop_width = uint16(tfm_init_user_cropwidth/tfm_init_user_conversion{ivid});
    xmin = rot_centroid(1)-crop_length/2;
    ymin = rot_centroid(2)-crop_width/2;
    
    % initialize cropped video stacks
    bead_vid_rot_crop = zeros(crop_width+1,crop_length+1,N_frames);
    bead_vid_rot_crop = im2uint8(bead_vid_rot_crop);
    bf_vid_rot_crop = bead_vid_rot_crop;
    
    % crop bead/bf frames and mask
    for i = 1:N_frames
        bead_vid_rot_crop(:,:,i) = imcrop(bead_vid_rot(:,:,i),[xmin ymin crop_length crop_width]);
        bf_vid_rot_crop(:,:,i) = imcrop(bf_vid_rot(:,:,i),[xmin ymin crop_length crop_width]);
    end
    mask_rot_crop = imcrop(mask_rot,[xmin ymin crop_length crop_width]);
    
    % save new videos
    % overwrite preview frames
    tfm_init_user_preview_frame1{ivid} = [];
    tfm_init_user_preview_frame1{ivid} = normalise(bead_vid_rot_crop(:,:,1));
    tfm_init_user_bf_preview_frame1{ivid} = [];
    tfm_init_user_bf_preview_frame1{ivid} = normalise(bf_vid_rot_crop(:,:,1));
    
    % check for old cropped files and delete
    if exist([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'_cropped.tif'],'file') == 2
        delete([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'_cropped.tif'])
    end
    if exist([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'_cropped.tif'],'file') == 2
        delete([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'_cropped.tif'])
    end
    
    % save new bead .tif files
    for i = 1:N_frames
        % imwrite(bead_vid_rot_crop(:,:,i),[tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'_cropped.tif'],'writemode','append');
        imwrite(bf_vid_rot_crop(:,:,i),[tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'_cropped.tif'],'writemode','append');
        % bf file path not working?
        % writing double frames?
    end
    
%     % save new bf .tif files
%     for i = 1:N_frames
%         imwrite(bf_vid_rot_crop(:,:,i),[tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'_cropped.tif'],'writemode','append');
%     end
    
    % overwrite .mat files
    for i = 1:N_frames
        imagei = normalise(bead_vid_rot_crop(:,:,i));
        save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'/image',num2str(i),'.mat'],'imagei','-v7.3')
    end
    
    % overwrite mask
    tfm_init_user_binary1{ivid} = mask_rot_crop;
    % tfm_binary2?
    tfm_init_user_binary3{ivid} = [];
    
    % convert outlines
    BWoutline=bwboundaries(mask_rot_crop);
    tfm_init_user_outline1x{ivid}=BWoutline{1}(:,2);
    tfm_init_user_outline1y{ivid}=BWoutline{1}(:,1);
    
    %calculate initial ellipse
    s = regionprops(mask_rot_crop, 'Orientation', 'MajorAxisLength', ...
        'MinorAxisLength', 'Eccentricity', 'Centroid','Area');
    phi = linspace(0,2*pi,50);
    cosphi = cos(phi);
    sinphi = sin(phi);
    xbar = s(1).Centroid(1);
    ybar = s(1).Centroid(2);
    a = s(1).MajorAxisLength/2;
    b = s(1).MinorAxisLength/2;
    theta = pi*s(1).Orientation/180;
    R = [ cos(theta)   sin(theta)
        -sin(theta)   cos(theta)];
    xy = [a*cosphi; b*sinphi];
    xy = R*xy;
    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;
    
    %calculate analysis mask
%     F=tfm_init_user_force{ivid};
%     v=tfm_init_user_nu{ivid};
%     u=tfm_init_user_res{ivid};
%     E=tfm_init_user_E{ivid};
%     d=F*(1+v)/(u*E*pi)*10^6/tfm_init_user_conversion{ivid};
    %an=a+d;%tfm_init_user_area_factor*b;
    an=tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*a;
    %bn=(tfm_init_user_area_factor*a*b)/an;%tfm_init_user_area_factor*b;
    bn=1/tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*b;
    xyn = [an*cosphi; bn*sinphi];
    xyn = R*xyn;
    xn = xyn(1,:) + xbar;
    yn = xyn(2,:) + ybar;
    tfm_init_user_outline2x{ivid} = xn;
    tfm_init_user_outline2y{ivid} = yn;
    
    tfm_init_user_outline3x{ivid} = [];
    tfm_init_user_outline3y{ivid} = [];
    
    toc
end

% sb=statusbar(h_init(1).fig,'Done !');
% sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));

% %display preview w. outlines
% cla(h_init(1).axes_curr)
% axes(h_init(1).axes_curr)
figure
imshow(tfm_init_user_preview_frame1{tfm_init_user_counter});hold on;
plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
hold off;
% 
% %display bf preview w/ outlines
% cla(h_init(1).axes_bf)
% axes(h_init(1).axes_bf)
figure
imshow(tfm_init_user_bf_preview_frame1{tfm_init_user_counter});hold on;
plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
hold off;

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end