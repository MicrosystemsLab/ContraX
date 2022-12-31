%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tfm_piv.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part of the Streamlined TFM GUI: executes from the main Streamlined TFM
% GUI menu after initialization and measures the beads displacement by PIV
% using the ncorr algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Streamlined TFM GUI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version 2.0, 1 April 2020, by Pardon, G., Lewis, H. and Birnbaum, F.
% Published in Pardon, G. et al., Contra-X: a streamlined and versatile
% pipeline for time-course analysis of the contractile force of single
% hiPSC-cardiomyocytes, 2020, submitted
% Contact: Gaspard Pardon: gaspard@stanford.edu, Henry Lewis:
% henry.mlewis@gmail.com, and Foster Birnbaum: fosb@stanford.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Streamlined TFM GUI was developed based on the Beads GUI version 1.0
% written by O. Schwab initially published in Ribeiro, A. J. et al.
% Multi-Imaging Method to Assay the Contractile Mechanical Output of
% Micropatterned Human iPSC-Derived Cardiac Myocytes. Circ. Res.
% CIRCRESAHA.116.310363?91 (2017). doi:10.1161/CIRCRESAHA.116.310363
% version 1.0 written by O. Schwab: oschwab@stanford.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%main function for the displacement window of beads gui
function tfm_piv(h_main)
fprintf(1,'\n');
fprintf(1,'CXS-TFM: PIV Module\n');

tfm_init_user_strln=getappdata(0,'tfm_init_user_strln');
tfm_gui_call_piv_flag=getappdata(0,'tfm_gui_call_piv_flag');
%userTiming= getappdata(0,'userTiming');
%userTiming.init2piv{2} = toc(userTiming.init2piv{1});

%warning('off','MATLAB:prnRenderer:opengl');

% create new window for displacement
% fig size [height, width]
figsize=[470,800];
% get screen size  [left bottom width height]
screensize = get(0,'ScreenSize');
% position fig on center of screen
xpos = ceil((screensize(3)-figsize(2))/2);
ypos = ceil((screensize(4)-figsize(1))/2);
% create fig; invisible at first
h_piv.fig=figure(...
    'position',[xpos, ypos, figsize(2), figsize(1)],...
    'units','pixels',...
    'renderer','OpenGL',...
    'MenuBar','none',...
    'PaperPositionMode','auto',...
    'Name','ContraX Displacements',...
    'NumberTitle','off',...
    'Resize','off',...
    'Color',[.2,.2,.2],...
    'visible','off');

%color of the background and foreground
pcolor = [.2 .2 .2];
ptcolor = [1 1 1];
bcolor = [.3 .3 .3];
btcolor = [1 1 1];
h_piv.ForegroundColor = ptcolor;
h_piv.BackgroundColor = pcolor;
fontsizeA = 10;

%create uipanel for ncorr
%uipanel:
h_piv.panel_ncorr = uipanel('Parent',h_piv.fig,'Title','Ncorr','units','pixels','Position',[20,140,760,300]);
h_piv.panel_ncorr.ForegroundColor = ptcolor;
h_piv.panel_ncorr.BackgroundColor = pcolor;
%axes:
h_piv.axes_ncorr = axes('Parent',h_piv.panel_ncorr,'Units', 'pixels','Position',[250,5,500,280]);
%uipanel: analysis settings
h_piv.panel_analysis = uipanel('Parent',h_piv.panel_ncorr,'Title','Analysis Settings','units','pixels','Position',[5,170,240,115],'BorderType','none');
h_piv.panel_analysis.ForegroundColor = ptcolor;
h_piv.panel_analysis.BackgroundColor = pcolor;
%analysis settings: text: radius
h_piv.text_analysis_radius = uicontrol('Parent',h_piv.panel_analysis,'style','text','position',[5,80,100,15],'string','subset radius','HorizontalAlignment','left');
h_piv.text_analysis_radius.ForegroundColor = ptcolor;
h_piv.text_analysis_radius.BackgroundColor = pcolor;
%analysis settings: text: spacing
h_piv.text_analysis_spacing = uicontrol('Parent',h_piv.panel_analysis,'style','text','position',[5,55,100,15],'string','spacing coefficient','HorizontalAlignment','left');
h_piv.text_analysis_spacing.ForegroundColor = ptcolor;
h_piv.text_analysis_spacing.BackgroundColor = pcolor;
%analysis settings: text: norm
h_piv.text_analysis_cutnorm = uicontrol('Parent',h_piv.panel_analysis,'style','text','position',[5,30,100,15],'string','cutoff norm','HorizontalAlignment','left');
h_piv.text_analysis_cutnorm.ForegroundColor = ptcolor;
h_piv.text_analysis_cutnorm.BackgroundColor = pcolor;
%analysis settings: text: iter
h_piv.text_analysis_cutiter = uicontrol('Parent',h_piv.panel_analysis,'style','text','position',[5,5,100,15],'string','cutoff iteration','HorizontalAlignment','left');
h_piv.text_analysis_cutiter.ForegroundColor = ptcolor;
h_piv.text_analysis_cutiter.BackgroundColor = pcolor;
%analysis settings: edit: radius
tfm_init_user_subset_rad = getappdata(0,'tfm_init_user_subset_rad');
h_piv.edit_analysis_radius = uicontrol('Parent',h_piv.panel_analysis,'style','edit','position',[120,80,110,15],'string',num2str(tfm_init_user_subset_rad),'HorizontalAlignment','center');
%analysis settings: edit: spacing
tfm_init_user_spacing_coeff = getappdata(0,'tfm_init_user_spacing_coeff');
h_piv.edit_analysis_spacing = uicontrol('Parent',h_piv.panel_analysis,'style','edit','position',[120,55,110,15],'string',num2str(tfm_init_user_spacing_coeff),'HorizontalAlignment','center');
%analysis settings: edit: norm
h_piv.edit_analysis_cutnorm = uicontrol('Parent',h_piv.panel_analysis,'style','edit','position',[120,30,110,15],'string','1e-6','HorizontalAlignment','center');
%analysis settings: edit: iter
h_piv.edit_analysis_cutiter = uicontrol('Parent',h_piv.panel_analysis,'style','edit','position',[120,5,110,15],'string','20','HorizontalAlignment','center');
%checkbox: post processing
h_piv.checkbox = uicontrol('Parent',h_piv.panel_ncorr,'style','checkbox','position',[5,150,100,15],'string','Post-processing','HorizontalAlignment','left');
h_piv.checkbox.ForegroundColor = ptcolor;
h_piv.checkbox.BackgroundColor = pcolor;
%uipanel: post settings
h_piv.panel_post = uipanel('Parent',h_piv.panel_ncorr,'Title','Postprocess Settings','units','pixels','Position',[5,40,240,105]);
h_piv.panel_post.ForegroundColor = ptcolor;
h_piv.panel_post.BackgroundColor = pcolor;
%post settings: text umin
h_piv.text_post_umin = uicontrol('Parent',h_piv.panel_post,'style','text','position',[5,70,30,15],'string','umin','HorizontalAlignment','left');
h_piv.text_post_umin.ForegroundColor = ptcolor;
h_piv.text_post_umin.BackgroundColor = pcolor;
%post settings: text vmin
h_piv.text_post_vmin = uicontrol('Parent',h_piv.panel_post,'style','text','position',[5,55,30,15],'string','vmin','HorizontalAlignment','left');
h_piv.text_post_vmin.ForegroundColor = ptcolor;
h_piv.text_post_vmin.BackgroundColor = pcolor;
%post settings: text umax
h_piv.text_post_umin = uicontrol('Parent',h_piv.panel_post,'style','text','position',[125,70,30,15],'string','umax','HorizontalAlignment','left');
h_piv.text_post_umin.ForegroundColor = ptcolor;
h_piv.text_post_umin.BackgroundColor = pcolor;
%post settings: text vmax
h_piv.text_post_vmin = uicontrol('Parent',h_piv.panel_post,'style','text','position',[125,55,30,15],'string','vmax','HorizontalAlignment','left');
h_piv.text_post_vmin.ForegroundColor = ptcolor;
h_piv.text_post_vmin.BackgroundColor = pcolor;
%post settings: text std
h_piv.text_post_std = uicontrol('Parent',h_piv.panel_post,'style','text','position',[5,35,200,15],'string','std threshold','HorizontalAlignment','left');
h_piv.text_post_std.ForegroundColor = ptcolor;
h_piv.text_post_std.BackgroundColor = pcolor;
%post settings: text median eps
h_piv.text_post_eps = uicontrol('Parent',h_piv.panel_post,'style','text','position',[5,20,200,15],'string','normalized median epsilon','HorizontalAlignment','left');
h_piv.text_post_eps.ForegroundColor = ptcolor;
h_piv.text_post_eps.BackgroundColor = pcolor;
%post settings: text median thresh
h_piv.text_post_thresh = uicontrol('Parent',h_piv.panel_post,'style','text','position',[5,5,200,15],'string','normalized median threshold','HorizontalAlignment','left');
h_piv.text_post_thresh.ForegroundColor = ptcolor;
h_piv.text_post_thresh.BackgroundColor = pcolor;
%post settings: edit: umin
h_piv.edit_post_umin = uicontrol('Parent',h_piv.panel_post,'style','edit','position',[45,70,50,15],'string','-10','HorizontalAlignment','center');
%post settings: edit: vmin
h_piv.edit_post_vmin = uicontrol('Parent',h_piv.panel_post,'style','edit','position',[45,55,50,15],'string','-10','HorizontalAlignment','center');
%post settings: edit: umax
h_piv.edit_post_umax = uicontrol('Parent',h_piv.panel_post,'style','edit','position',[170,70,50,15],'string','10','HorizontalAlignment','center');
%post settings: edit: vmax
h_piv.edit_post_vmax = uicontrol('Parent',h_piv.panel_post,'style','edit','position',[170,55,50,15],'string','10','HorizontalAlignment','center');
%post settings: edit: std
h_piv.edit_post_std = uicontrol('Parent',h_piv.panel_post,'style','edit','position',[170,35,50,15],'string','6','HorizontalAlignment','center');
%post settings: edit: eps
h_piv.edit_post_eps = uicontrol('Parent',h_piv.panel_post,'style','edit','position',[170,20,50,15],'string','0.15','HorizontalAlignment','center');
%post settings: edit: thresh
h_piv.edit_post_thresh = uicontrol('Parent',h_piv.panel_post,'style','edit','position',[170,5,50,15],'string','3','HorizontalAlignment','center');
%button: calculate all
h_piv.button_calcncorr = uicontrol('Parent',h_piv.panel_ncorr,'style','pushbutton','position',[5,5,240,30],'string','Calculate all','FontSize',fontsizeA);
%checkbox: delete extra files after ncorr
h_piv.checkbox_delete = uicontrol('Parent',h_piv.panel_ncorr,'style','checkbox','position',[100,150,150,15],'string','Delete extra files after ncorr','value',0);
h_piv.checkbox_delete.ForegroundColor = ptcolor;
h_piv.checkbox_delete.BackgroundColor = pcolor;

%create uipanel for smartguess
%uipanel
h_piv.panel_guess = uipanel('Parent',h_piv.fig,'Title','Determine reference frame','units','pixels','Position',[550,85,150,50]);
h_piv.panel_guess.ForegroundColor = ptcolor;
h_piv.panel_guess.BackgroundColor = pcolor;
%button
h_piv.button_guess = uicontrol('Parent',h_piv.panel_guess,'style','pushbutton','position',[5,5,137,25],'string','Determine all');

%create uipanel for reference shift
%uipanel
h_piv.panel_ref = uipanel('Parent',h_piv.fig,'Title','Reference shift','units','pixels','Position',[20,30,525,105]);
h_piv.panel_ref.ForegroundColor = ptcolor;
h_piv.panel_ref.BackgroundColor = pcolor;
%text: reference
h_piv.text_ref_ref = uicontrol('Parent',h_piv.panel_ref,'style','text','position',[5,65,60,15],'string','Relaxed','HorizontalAlignment','left');
h_piv.text_ref_ref.ForegroundColor = ptcolor;
h_piv.text_ref_ref.BackgroundColor = pcolor;
%text: contracted
h_piv.text_ref_contr = uicontrol('Parent',h_piv.panel_ref,'style','text','position',[5,45,60,15],'string','Contracted','HorizontalAlignment','left');
h_piv.text_ref_contr.ForegroundColor = ptcolor;
h_piv.text_ref_contr.BackgroundColor = pcolor;
%edit: reference
h_piv.edit_ref_ref = uicontrol('Parent',h_piv.panel_ref,'style','edit','position',[75,65,40,15],'HorizontalAlignment','center');
%edit: contracted
h_piv.edit_ref_contr = uicontrol('Parent',h_piv.panel_ref,'style','edit','position',[75,45,40,15],'HorizontalAlignment','center');
%button: pick relaxed
h_piv.button_pickref = uicontrol('Parent',h_piv.panel_ref,'style','pushbutton','position',[120,64,40,18],'string','Pick');
%button: pick contr
h_piv.button_pickcontr = uicontrol('Parent',h_piv.panel_ref,'style','pushbutton','position',[120,43,40,18],'string','Pick');
%button: update
h_piv.button_update = uicontrol('Parent',h_piv.panel_ref,'style','pushbutton','position',[5,5,155,25],'string','Update preview');
%axes:
h_piv.axes_ref = axes('Parent',h_piv.panel_ref,'Units', 'pixels','Position',[165,5,200,85]);
%button: calculate all
h_piv.button_calcref = uicontrol('Parent',h_piv.panel_ref,'style','pushbutton','position',[370,5,147,25],'string','Calc displacements');
%button: forwards
h_piv.button_forwards = uicontrol('Parent',h_piv.panel_ref,'style','pushbutton','position',[395,67,25,25],'string','>');
%button: backwards
h_piv.button_backwards = uicontrol('Parent',h_piv.panel_ref,'style','pushbutton','position',[370,67,25,25],'string','<');
%text: show which video (i/n)
h_piv.text_whichvid = uicontrol('Parent',h_piv.panel_ref,'style','text','position',[425,75,25,15],'string','(1/1)','HorizontalAlignment','left');
h_piv.text_whichvid.ForegroundColor = ptcolor;
h_piv.text_whichvid.BackgroundColor = pcolor;
%text: show which video (name)
h_piv.text_whichvidname = uicontrol('Parent',h_piv.panel_ref,'style','text','position',[370,50,100,15],'string','Experiment','HorizontalAlignment','left');
h_piv.text_whichvidname.ForegroundColor = ptcolor;
h_piv.text_whichvidname.BackgroundColor = pcolor;

%create ok button
h_piv.button_ok = uicontrol('Parent',h_piv.fig,'style','pushbutton','position',[735,30,45,20],'string','OK','visible','on','FontWeight','bold');
%create matrix save checkbox
h_piv.checkbox_matrix = uicontrol('Parent',h_piv.fig,'style','checkbox','position',[550,30,160,15],'string','Save displacement matrices','HorizontalAlignment','left','value',1);
h_piv.checkbox_matrix.ForegroundColor = ptcolor;
h_piv.checkbox_matrix.BackgroundColor = pcolor;
%create heatmaps save checkbox
h_piv.checkbox_heatmaps = uicontrol('Parent',h_piv.fig,'style','checkbox','position',[550,50,160,15],'string','Save heatmaps','HorizontalAlignment','left');
h_piv.checkbox_heatmaps.ForegroundColor = ptcolor;
h_piv.checkbox_heatmaps.BackgroundColor = pcolor;

%callbacks for buttons and checkbox
set(h_piv.button_calcncorr,'callback',{@piv_push_calcncorr,h_piv})  % "Calculate all" button
set(h_piv.button_guess,'callback',{@piv_push_guess,h_piv})  % 
set(h_piv.button_pickref,'callback',{@piv_push_pickref,h_piv})
set(h_piv.button_pickcontr,'callback',{@piv_push_pickcontr,h_piv})
set(h_piv.button_update,'callback',{@piv_push_update,h_piv})
set(h_piv.button_calcref,'callback',{@piv_push_calcref,h_piv})  % "Calc displacements" button
set(h_piv.button_backwards,'callback',{@piv_push_backwards,h_piv})
set(h_piv.button_forwards,'callback',{@piv_push_forwards,h_piv})
set(h_piv.button_ok,'callback',{@piv_push_ok,h_piv,h_main}) % "OK" button
set(h_piv.checkbox,'callback',{@piv_checkbox,h_piv})

%populate figure on launch
%error catch loop (http://www.matlabtips.com/display-errors/)
try
    %turn off panels
    set(h_piv.panel_ncorr,'Visible','on');
    set(h_piv.panel_post,'Visible','off');
    set(h_piv.panel_ref,'Visible','off');
    set(h_piv.panel_guess,'Visible','off');
    set(h_piv.button_ok,'Visible','off');
    set(h_piv.checkbox_matrix,'Visible','off')
    set(h_piv.checkbox_heatmaps,'Visible','off')
    
    %load vars
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    
    %display 1st frame of 1st vid in axes
    reset(h_piv.axes_ncorr)
    axes(h_piv.axes_ncorr)
    imshow(tfm_init_user_preview_frame1{1}); hold on;
    
    %initiate counter (which video)
    tfm_piv_user_counter=1;
    
    if tfm_gui_call_piv_flag %called from ContraX
        %initialize relax/contr/dis
        tfm_piv_user_contr=cell(1,tfm_init_user_Nfiles);
        tfm_piv_user_relax=cell(1,tfm_init_user_Nfiles);
    else %if called form IntraX, use the same contr and relax frame as in the tfm piv step
        tfm_piv_user_contr=getappdata(0,'tfm_piv_user_contr');
        tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    end
    tfm_piv_user_d=cell(1,tfm_init_user_Nfiles);

    %store everything for shared use
    setappdata(0,'tfm_piv_user_counter',tfm_piv_user_counter)
    setappdata(0,'tfm_piv_user_contr',tfm_piv_user_contr);
    setappdata(0,'tfm_piv_user_relax',tfm_piv_user_relax);
    setappdata(0,'tfm_piv_user_d',tfm_piv_user_d);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

%userTiming.piv{1} = tic;
%setappdata(0,'userTiming',userTiming);

%make fig visible
set(h_piv.fig,'visible','on');
%movegui(h_piv.fig,'north');

%move main window to the side
% movegui(h_main.fig,'west')
% MH put the panel to the left of the main window
%  [left bottom width height]
fp = get(h_piv.fig,'Position');
set(h_main.fig,'Units','pixels');
ap = get(h_main.fig,'Position');
set(h_main.fig,'Position',[fp(1)-ap(3) fp(2)+fp(4)-ap(4) ap(3) ap(4)]);

% initialize status bar
sb=statusbar(h_piv.fig,'Ready');
sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));

%Streamlining
if tfm_init_user_strln
    piv_push_calcncorr(h_piv.button_calcncorr, h_piv, h_piv)
end

waitfor(h_piv.fig)


%% piv_push_calcncorr
function piv_push_calcncorr(hObject, eventdata, h_piv)
%disable figure during calculation
enableDisableFig(h_piv.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_piv.fig,1));

%profile on

try
    %load what shared para we need
    tfm_init_user_strln = getappdata(0,'tfm_init_user_strln');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_vidext=getappdata(0,'tfm_init_user_vidext');
    %tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    %tfm_init_user_binary3=getappdata(0,'tfm_init_user_binary3');
    tfm_gui_call_piv_flag=getappdata(0,'tfm_gui_call_piv_flag');
    if ~tfm_gui_call_piv_flag
        tfm_conc_user_binary1=getappdata(0,'sarco_conc_user_binarysarc');
    end
    use_parallel = getappdata(0,'use_parallel');
    
    
    %ncorr settings
    num_region = 0; % Assume only 1 region exists in ROI
    radius_rgdic = str2double(get(h_piv.edit_analysis_radius,'String'));
    spacing_rgdic = str2double(get(h_piv.edit_analysis_spacing,'String'));
    cutoff_diffnorm = str2double(get(h_piv.edit_analysis_cutnorm,'String'));
    cutoff_iteration = str2double(get(h_piv.edit_analysis_cutiter,'String'));
    enabled_stepanalysis = false;
    subsettrunc = false;
    
    %filter/post settings
    umin = str2double(get(h_piv.edit_post_umin,'String')); % minimum allowed u velocity
    umax = str2double(get(h_piv.edit_post_umax,'String')); % maximum allowed u velocity
    vmin = str2double(get(h_piv.edit_post_vmin,'String')); % minimum allowed v velocity
    vmax = str2double(get(h_piv.edit_post_vmax,'String')); % maximum allowed v velocity
    stdthresh=str2double(get(h_piv.edit_post_std,'String')); % threshold for standard deviation check
    epsilon=str2double(get(h_piv.edit_post_eps,'String')); % epsilon for normalized median test
    thresh=str2double(get(h_piv.edit_post_thresh,'String')); % threshold for normalized median test
    
    %     %first save images as png for lazy loading...
    %     witer=0;
    %     %loop over videos
    %     for ivid=1:tfm_init_user_Nfiles
    %         %heatmap save folder
    %         if ~isequal(exist([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots'], 'dir'),7)
    %                 mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots'])
    %         end
    %         if ~isequal(exist([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Displacement Heatmaps'], 'dir'),7)
    %                 mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Displacement Heatmaps'])
    %         end
    %
    %         %loop over frames
    %         for ifr=1:tfm_init_user_Nframes{ivid}
    %             %estimate waiting time
    %             witer=witer+1;
    %             sb=statusbar(h_piv.fig,['Tweaking images... ',num2str(floor(100*(witer-1)/sum([tfm_init_user_Nframes{:}]))), '%% done']);
    %             sb.getComponent(0).setForeground(java.awt.Color.red);
    %
    %             s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/image',num2str(ifr),'.mat'],'imagei');
    %             im=im2uint8(normalise(s.imagei));
    %             imwrite(im,['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/image',num2str(ifr),'.png']);
    %         end
    %     end
    %     %statusbar
    %     sb=statusbar(h_piv.fig,'Tweaking - Done !');
    %     sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    %
    
	tstartMH = tic;
	fprintf(1,'CXS-TFM: Start Video Processing Loop\n')
	
    %loop over videos
    %w_i=0;
    for ivid=1:tfm_init_user_Nfiles
        Num=tfm_init_user_Nframes{ivid};
        
        disp([' Analyzing Video ',num2str(ivid),'/',num2str(tfm_init_user_Nfiles),'... '])
        sb=statusbar(h_piv.fig,['Analyzing Video ',num2str(ivid),'/',num2str(tfm_init_user_Nfiles),'... ']);
        sb.getComponent(0).setForeground(java.awt.Color.red);
        
        %create folder to save disp.
        [~,~] = mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots']);  
        [~,~] = mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Displacement Heatmaps']);  
        
        % load image stack
        s = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/image_stack.mat'],'image_stack');
        
        %s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/image',num2str(1),'.mat'],'imagei');
        im_ref=s.image_stack(:,:,1);
        
        %set reference
        ref = ncorr_class_img;
        ref.set_img('load',struct('img',s.image_stack(:,:,1),...
            'name',[tfm_init_user_filenamestack{ivid},tfm_init_user_vidext{ivid}],...
            'path',tfm_init_user_pathnamestack{ivid}));
        % ref.set_img('lazy',struct('name','image1.png','path',['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid}]));
        
        %set current
        cur = ncorr_class_img.empty;
        
		fprintf(1,'CXS-TFM: Start ncorr init at %.02f s\n',toc(tstartMH));
        for ifr=1:Num
            cur(end+1) = ncorr_class_img;
            cur(end).set_img('load',struct('img',s.image_stack(:,:,ifr),...
                'name',[tfm_init_user_filenamestack{ivid},tfm_init_user_vidext{ivid}],...
                'path',tfm_init_user_pathnamestack{ivid}));
            % cur(end).set_img('lazy',struct('name',['image',num2str(ifr),'.png'],'path',['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid}]));
        end
		fprintf(1,'CXS-TFM: End ncorr init at %.02f s\n',toc(tstartMH));

        statusbar(h_piv.fig,sprintf('Analyzing Video %d/%d (%d frames)...',ivid,tfm_init_user_Nfiles,length(cur)));
        fprintf(1,'  Video has %d frames\n',length(cur));
        
        %set roi
        mask = true([ref.height ref.width]);
        
        %COMMENTED BY GASPARD:This somtimes leads to error in ncorr for the
        %sarco_piv step, probably because of holes, single pixels or mask 
        %area touching the edges of the frame.
        
        %for IntraX restrict piv calculation to inside the cell 
        if ~tfm_gui_call_piv_flag
            mask = tfm_conc_user_binary1{ivid};
            mask = imfill(mask,'holes');          
            mask = imerode(mask,strel('disk',10));
            mask = imdilate(mask,strel('disk',10));
            mask = bwconvhull(mask);
        end
        
        %ensure border of 0's
        mask(1,:) = 0;
        mask(end,:) = 0;
        mask(:,1) = 0;
        mask(:,end) = 0;
        %mask = tfm_init_user_binary3{ivid};

        roi = ncorr_class_roi;
        roi.set_roi('load',struct('mask',mask,'cutoff',0));
        
        %center of mass of mask
        props = regionprops( double( mask ), 'Centroid');
        Centroid=props.Centroid;
        xc=Centroid(1,1);
        yc=Centroid(1,2);
        %position seeds at center
        pos_seed=[xc,yc];
        %% DIC analysis
        roi_reduced = roi.reduce(spacing_rgdic);
        threaddiagram = -ones(size(roi_reduced.mask));
        threaddiagram(roi_reduced.mask) = 0; % Assigns thread to seed - used for multithreading but for this example on single thread is used
        
        %create 3D data storage for x, y, u, and v
        %save displ.
        spacing=spacing_rgdic;
        
        rows=size(im_ref,1);
        cols=size(im_ref,2);
        edge_rows_tot = (rows - 1) - floor((rows-1)/(1+spacing))*(1+spacing);
        if edge_rows_tot == 0
            y_vec = 1:1+spacing:rows;
        else
            edge_rows_top = edge_rows_tot - round(edge_rows_tot/2);
            edge_rows_bot = edge_rows_tot - edge_rows_top;
            y_vec=edge_rows_top:1+spacing:rows - edge_rows_bot;
        end
        edge_cols_tot = (cols - 1) - floor((cols-1)/(1+spacing))*(1+spacing);
        if edge_cols_tot == 0
            x_vec = 1:1+spacing:cols;
        else
            edge_cols_left = edge_cols_tot - round(edge_cols_tot/2);
            edge_cols_right = edge_cols_tot - edge_cols_left;
            x_vec=edge_cols_left:1+spacing:cols - edge_cols_right;
        end
        if x_vec(1) == 0
            x_vec(1) = 1;
        end
        if y_vec(1) == 0
            y_vec(1) = 1;
        end
        
        %         y_vec = 1:1+spacing:rows;
        %         x_vec = 1:1+spacing:cols;
        
        %make matrices
        x_matr=zeros(length(y_vec),length(x_vec),length(cur));
        y_matr=zeros(length(y_vec),length(x_vec),length(cur));
        u_matr=zeros(length(y_vec),length(x_vec),length(cur));
        v_matr=zeros(length(y_vec),length(x_vec),length(cur));
        
        %exclude last row, there is always a prob with it.
        final_x=x_matr(1:end-1,:,:);
        final_y=y_matr(1:end-1,:,:);
        final_fu=u_matr(1:end-1,:,:);
        final_fv=v_matr(1:end-1,:,:);
        

		fprintf(1,'CXS-TFM: Start frame processing at %.02f s\n ',toc(tstartMH));
		tstartFRAME = tic;
        %h_pf = h_piv.fig;
		
        parfor (frame = 1:length(cur), use_parallel)
%        for frame = 1:length(cur)
			%timeperframe = toc(tstartFRAME)/frame;
            if rem(frame,20)==0
                %fprintf(1,' #%d/%d, %.02f sec elapsed\n',frame,length(cur),toc(tstartFRAME));
                fprintf(1,'.');
            end
            %disp([' Calculating frame #',num2str(frame)])
            
            [seedinfo(frame), convergeinfo, success_seeds] = ncorr_alg_calcseeds(ref.formatted(), ...
                cur(frame).formatted(), ...
                roi.formatted, ...
                int32(num_region), ...
                int32(pos_seed), ...
                int32(radius_rgdic), ...
                cutoff_diffnorm, ...
                int32(cutoff_iteration), ...
                enabled_stepanalysis, ...
                subsettrunc);
            %         end
            
            %         %% DIC analysis
            %         roi_reduced = roi.reduce(spacing_rgdic);
            %         threaddiagram = -ones(size(roi_reduced.mask));
            %         threaddiagram(roi_reduced.mask) = seedinfo.num_thread; % Assigns thread to seed - used for multithreading but for this example on single thread is used
            
            %         parfor frame = 1:length(cur)
            %disp(frame)
            %w_i=frame;
            %sb=statusbar(h_piv.fig,['Calculating Video ',num2str(ivid),'/',num2str(tfm_init_user_Nfiles),' frame: ',num2str(frame)]);%,'/',num2str(Num),'... ',num2str(floor(100*(w_i-1)/sum([tfm_init_user_Nframes{:}]))), '%% done']);
            %sb.getComponent(0).setForeground(java.awt.Color.red);
            
            % Format seedinfo
            seedinfo(frame).num_region = int32(seedinfo(frame).num_region);
            seedinfo(frame).num_thread = int32(seedinfo(frame).num_thread);
            seedinfo(frame).computepoints = int32(sum(roi_reduced.mask(:))); % Used for waitbar
            
            [dicinfo(frame), success_dic] = ncorr_alg_rgdic(ref.formatted(), ...
                cur(frame).formatted(), ...
                roi.formatted(), ...
                seedinfo(frame), ...
                int32(threaddiagram), ...
                int32(radius_rgdic), ...
                int32(spacing_rgdic), ...
                cutoff_diffnorm, ...
                int32(cutoff_iteration), ...
                subsettrunc, ...
                int32(frame-1), ...
                int32(length(cur)));
            
            %             %s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/image',num2str(1),'.mat'],'imagei');
            %             im_ref=s.image_stack(:,:,1);
            
            
            
            u=dicinfo(frame).plot_u;
            v=dicinfo(frame).plot_v;
            
            %format: filter out everything under correlation coeff
            %threshold
            %             coeff=dicinfo(frame).plot_corrcoef;
            %             coeffmask=double(coeff<2.5);
            %             figure(5), imagesc(double(coeff));
            %             colorbar;
            %             coeffmask(coeffmask==0)=NaN;
            %             u=u.*coeffmask;
            %             v=v.*coeffmask;
            %             u=inpaint_nans(u,4);
            %             v=inpaint_nans(v,4);
            
            %save displaced cell roi
            %dicinfo(frame)
            %(frame).roi_dic;
            %save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/deformed_mask_',num2str(frame),'.mat'],'defmask','-v7.3')
            
            %cal. x, y
            %x_vec=1:1+spacing:cols;
            %y_vec=1:1+spacing:rows;
            
            %make matrices
            x_matr=zeros(length(y_vec),length(x_vec));
            y_matr=zeros(length(y_vec),length(x_vec));
            for i=1:length(y_vec)
                x_matr(i,:)=x_vec;
            end
            for i=1:length(x_vec)
                y_matr(:,i)=y_vec';
            end
            
            %exclude last row, there is always a prob with it.
            x=x_matr(1:end-1,:);
            y=y_matr(1:end-1,:);
            u_filtered=u(1:end-1,:);
            v_filtered=v(1:end-1,:);
            
            %check if user wants filter
            if get(h_piv.checkbox,'Value')
                %vellimit check
                u_filtered(u_filtered<umin)=NaN;
                u_filtered(u_filtered>umax)=NaN;
                v_filtered(v_filtered<vmin)=NaN;
                v_filtered(v_filtered>vmax)=NaN;
                % stddev check
                meanu=mean(u_filtered(:),'omitnan');
                meanv=mean(v_filtered(:),'omitnan');
                std2u=std(reshape(u_filtered,size(u_filtered,1)*size(u_filtered,2),1),'omitnan');
                std2v=std(reshape(v_filtered,size(v_filtered,1)*size(v_filtered,2),1),'omitnan');
                minvalu=meanu-stdthresh*std2u;
                maxvalu=meanu+stdthresh*std2u;
                minvalv=meanv-stdthresh*std2v;
                maxvalv=meanv+stdthresh*std2v;
                u_filtered(u_filtered<minvalu)=NaN;
                u_filtered(u_filtered>maxvalu)=NaN;
                v_filtered(v_filtered<minvalv)=NaN;
                v_filtered(v_filtered>maxvalv)=NaN;
                % normalized median check
                %Westerweel & Scarano (2005): Universal Outlier detection for PIV data
                [J,I]=size(u_filtered);
                normfluct=zeros(J,I,2);
                b=1;
                for c=1:2
                    if c==1; velcomp=u_filtered;else;velcomp=v_filtered;end %#ok<*NOSEM>
                    for i=1+b:I-b
                        for j=1+b:J-b
                            neigh=velcomp(j-b:j+b,i-b:i+b);
                            neighcol=neigh(:);
                            neighcol2=[neighcol(1:(2*b+1)*b+b);neighcol((2*b+1)*b+b+2:end)];
                            med=median(neighcol2);
                            fluct=velcomp(j,i)-med;
                            res=neighcol2-med;
                            medianres=median(abs(res));
                            normfluct(j,i,c)=abs(fluct/(medianres+epsilon));
                        end
                    end
                end
                info1=(sqrt(normfluct(:,:,1).^2+normfluct(:,:,2).^2)>thresh);
                u_filtered(info1==1)=NaN;
                v_filtered(info1==1)=NaN;
                
                %Interpolate missing data
                u_filtered=inpaint_nans(u_filtered,4);
                v_filtered=inpaint_nans(v_filtered,4);
            end
            
            fu=u_filtered;
            fv=v_filtered;
            
            %save to mat
            %save2disk(x,y,fu,fv,tfm_init_user_filenamestack{1,ivid}) %Foster
            
            %%%%%%%%%%%%%%
            %This block can be commented to reduce computing time
            
            %current image
            
            %plot skip factor
            sp=ceil(20/(spacing+1));
            
            %interpolate for display
            [Xqu,Yqu]=meshgrid(x(1):x(end),y(1):y(end));
            V = interp2(x,y,sqrt(fu.^2+fv.^2),Xqu,Yqu,'linear');
            
            p=figure('visible','off');
            imagesc(V);colormap('parula');
            caxis([0,10]);
            hold on
            quiver(x(1:sp:end,1:sp:end),y(1:sp:end,1:sp:end),5*fu(1:sp:end,1:sp:end),5*fv(1:sp:end,1:sp:end),0,'w');
            %gtitle(filenames{i},'interpreter','none')
            set(gca,'xtick',[],'ytick',[])
            set(gca,'linewidth',2);
            axis image;
            saveas(p,[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Displacement Heatmaps/heatmap',int2str(frame),'.png']);
            %export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Displacement Heatmaps/heatmap',int2str(frame)],...
            %    '-png','-painters','-m1.5',p);
            close(p)
			%[lsta,lastb]=lastwarn
            
            %%%%%%%%%%%%%%
            
            %save data in appropriate level of 3D arrays
            final_x(:,:,frame) = x;
            final_y(:,:,frame) = y;
            final_fu(:,:,frame) = fu;
            final_fv(:,:,frame) = fv;
            
        end % end ncorr frame processing
        fprintf(1,'\n done. Elapsed time %.1f seconds.\n',toc(tstartFRAME));
        
        %add boundaries to x, y, fu, and fv arrays
        final_x_new = [];
        final_y_new = [];
        final_fu_new = [];
        final_fv_new = [];
        parfor ifr = 1:size(final_x,3)
            final_x_ifr = final_x(:,:,ifr);
            final_y_ifr = final_y(:,:,ifr);
            final_fu_ifr = final_fu(:,:,ifr);
            final_fv_ifr = final_fv(:,:,ifr);
            
            if final_x_ifr(1,1) ~= 1 %add new first column
                col_x = ones(size(final_x_ifr,1),1);
                final_x_ifr = [col_x final_x_ifr];
                final_y_ifr = padarray(final_y_ifr,[0 1],'replicate','pre');
                final_fu_ifr = padarray(final_fu_ifr,[0 1],0,'pre');
                final_fv_ifr = padarray(final_fv_ifr,[0 1],0,'pre');
            end
            if final_x_ifr(end,end) ~= cols %add new last column
                col_x = ones(size(final_x_ifr,1),1);
                col_x(:,1) = cols;
                final_x_ifr = [final_x_ifr col_x];
                final_y_ifr = padarray(final_y_ifr,[0 1],'replicate','post');
                final_fu_ifr = padarray(final_fu_ifr,[0 1],0,'post');
                final_fv_ifr = padarray(final_fv_ifr,[0 1],0,'post');
            end
            if final_y_ifr(1,1) ~= 1 %add new first row
                row_y = ones(1,size(final_y_ifr,2));
                final_y_ifr = [row_y; final_y_ifr];
                final_x_ifr = padarray(final_x_ifr,[1 0],'replicate','pre');
                final_fu_ifr = padarray(final_fu_ifr,[1 0],0,'pre');
                final_fv_ifr = padarray(final_fv_ifr,[1 0],0,'pre');
            end
            if final_y_ifr(end,end) ~= rows %add new last row
                row_y = ones(1,size(final_y_ifr,2));
                row_y(1,:) = rows;
                final_y_ifr = [final_y_ifr; row_y];
                final_x_ifr = padarray(final_x_ifr,[1 0],'replicate','post');
                final_fu_ifr = padarray(final_fu_ifr,[1 0],0,'post');
                final_fv_ifr = padarray(final_fv_ifr,[1 0],0,'post');
            end
            final_x_new(:,:,ifr) = final_x_ifr;
            final_y_new(:,:,ifr) = final_y_ifr;
            final_fu_new(:,:,ifr) = final_fu_ifr;
            final_fv_new(:,:,ifr) = final_fv_ifr;
        end
        
        %Save 3D arrays
        save2disk(final_x_new,final_y_new,final_fu_new,final_fv_new,tfm_init_user_filenamestack{1,ivid});
        
        % delete extra image files
        if get(h_piv.checkbox_delete,'Value')
            delete(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'/image_stack.mat'])
        end
		fprintf(1,'CXS-TFM: End frame processing at %.02f s\n',toc(tstartMH));
    end
    %statusbar
    sb=statusbar(h_piv.fig,'Calculation - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %enable ok button; cancel grey out
    set(h_piv.panel_guess,'Visible','on');
    
    %profile viewer
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

%trigger guess all
piv_push_guess(hObject, eventdata, h_piv)

%Streamlining
if tfm_init_user_strln
    piv_push_calcref(hObject, eventdata, h_piv)
end


% save2disk
function save2disk(x,y,fu,fv,filename)

%save to mat
save(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_x.mat'],'x','-v7.3')
save(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_y.mat'],'y','-v7.3')
save(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_u.mat'],'fu','-v7.3')
save(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_v.mat'],'fv','-v7.3')


%% piv_push_guess
function piv_push_guess(hObject, eventdata, h_piv)

%profile on

%disable figure during calculation
enableDisableFig(h_piv.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_piv.fig,1));


try
    %load shared needed para
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_piv_user_contr=getappdata(0,'tfm_piv_user_contr');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_piv_user_d=getappdata(0,'tfm_piv_user_d');
    tfm_piv_user_counter=getappdata(0,'tfm_piv_user_counter');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary2=getappdata(0,'tfm_init_user_binary2');
    tfm_gui_call_piv_flag=getappdata(0,'tfm_gui_call_piv_flag');
        
    sb=statusbar(h_piv.fig,['Looking for reference frame...']);
    sb.getComponent(0).setForeground(java.awt.Color.red);
    
    
    parfor current_vid=1:tfm_init_user_Nfiles
        %waitbar
        %         sb=statusbar(h_piv.fig,['Looking for reference frame... ',num2str(floor(100*(current_vid-1)/tfm_init_user_Nfiles)), '%% done']);
        %         sb.getComponent(0).setForeground(java.awt.Color.red);
        disp(['Guessing reference frame for video #',num2str(current_vid)])
        
        %get displacements from calc. before
        Num=tfm_init_user_Nframes{current_vid};
        tfm_piv_user_xs=cell(1,Num);
        tfm_piv_user_ys=cell(1,Num);
        tfm_piv_user_us=cell(1,Num);
        tfm_piv_user_vs=cell(1,Num);
        
        %FOSTER
        s = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_x.mat'],'x');
        tfm_piv_user_xs = num2cell(s.x, [1 2]);
        s = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_y.mat'],'y');
        tfm_piv_user_ys = num2cell(s.y, [1 2]);
        s = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_u.mat'],'fu');
        tfm_piv_user_us = num2cell(s.fu, [1 2]);
        s = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_v.mat'],'fv');
        tfm_piv_user_vs = num2cell(s.fv, [1 2]);
        
        %mask: translate to correct spacing
        dismask=tfm_init_user_binary1{current_vid}(tfm_piv_user_ys{1}(:,1) ,tfm_piv_user_xs{1}(1,:));
        
        if tfm_gui_call_piv_flag %called from ContraX
            %smartguess reference
            [relax,contr] = smartguess_reference(Num,tfm_piv_user_us,tfm_piv_user_vs,dismask);
        else %if called form IntraX, use the same contr and relax frame as in the tfm piv step 
            relax = tfm_piv_user_relax{current_vid};
            contr = tfm_piv_user_contr{current_vid};
        end
        
        %for later use
        tfm_piv_user_contr{current_vid}=contr;
        tfm_piv_user_relax{current_vid}=relax;
        
        %transform mask, st 0s become Nans
        mask1=double(dismask);
        mask1(mask1==0)=NaN;
        mask2=double(~dismask);
        mask2(mask2==0)=NaN;
        
        %calculate preview displacement plots
        u1ref=tfm_piv_user_us{relax};
        v1ref=tfm_piv_user_vs{relax};
        d=zeros(1,Num);
        for ktest=1:Num
            deltaU=mask2.*(tfm_piv_user_us{ktest}-u1ref);
            deltaV=mask2.*(tfm_piv_user_vs{ktest}-v1ref);
            usn=(tfm_piv_user_us{ktest}-u1ref)-mean(deltaU(:),'omitnan').*ones(size(u1ref,1),size(u1ref,2));
            vsn=(tfm_piv_user_vs{ktest}-v1ref)-mean(deltaV(:),'omitnan').*ones(size(v1ref,1),size(v1ref,2));
            dsn=mask1.*sqrt(usn.^2+vsn.^2);
            d(ktest)=mean(dsn(:),'omitnan');
        end
        d(relax)=NaN;
        %for later use
        tfm_piv_user_d{current_vid}=d*tfm_init_user_conversion{current_vid}*1e-6;
    end

    fprintf(1,'CSX-TFM: Ready to calculate displacements\n');
    % statusbar
    sb=statusbar(h_piv.fig,'Calculation - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %set the counter back to 1
    tfm_piv_user_counter=1;
    
    %make second panel visible
    set(h_piv.panel_ref,'Visible','on');
    
    %%now display this info for 1st video.
    set(h_piv.edit_ref_ref,'String',num2str(tfm_piv_user_relax{tfm_piv_user_counter}));
    set(h_piv.edit_ref_contr,'String',num2str(tfm_piv_user_contr{tfm_piv_user_counter}));
    
    %display displacement plot
    reset(h_piv.axes_ref)
    axes(h_piv.axes_ref)
    plot((1:length(tfm_piv_user_d{tfm_piv_user_counter})),tfm_piv_user_d{tfm_piv_user_counter})
    %1e6: otherwise it will not plot in axes, not sure why...
    set(h_piv.axes_ref, 'XTick', []);
    set(h_piv.axes_ref, 'YTick', []);
    
    %display the displacement map for the contracted frame of 1st video
    fr = [tfm_piv_user_relax{1}, tfm_piv_user_contr{1}];
    
    %FOSTER
    s_x = matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,1},'/tfm_piv_x.mat']);
    s_y = matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,1},'/tfm_piv_y.mat']);
    s_fu = matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,1},'/tfm_piv_u.mat']);
    s_fv = matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,1},'/tfm_piv_v.mat']);
    
    for i = 1:size(fr,2)
        tfm_piv_user_xs{i}=s_x.x(:,:,fr(i));
        tfm_piv_user_ys{i}=s_y.y(:,:,fr(i));
        tfm_piv_user_us{i}=s_fu.fu(:,:,fr(i));
        tfm_piv_user_vs{i}=s_fv.fv(:,:,fr(i));
    end
    
    dismask=tfm_init_user_binary2{tfm_piv_user_counter}(tfm_piv_user_ys{1}(:,1) ,tfm_piv_user_xs{1}(1,:));
    mask2=double(~dismask);
    mask2(mask2==0)=NaN;
    
    urel=tfm_piv_user_us{1};
    vrel=tfm_piv_user_vs{1};
    ucontr=tfm_piv_user_us{2};
    vcontr=tfm_piv_user_vs{2};
    deltaU=mask2.*(ucontr-urel);
    deltaV=mask2.*(vcontr-vrel);
    uref=(ucontr-urel)-mean(deltaU(:),'omitnan').*ones(size(urel,1),size(urel,2));
    vref=(vcontr-vrel)-mean(deltaV(:),'omitnan').*ones(size(vrel,1),size(vrel,2));
    V=sqrt(uref.^2+vref.^2);
    
    %plot spacing factor
    sp=1;%ceil(20/(spacing+1));
    %plot in axes
    cla(h_piv.axes_ncorr);
    axes(h_piv.axes_ncorr);
    hold on
    caxis('auto');
    colormap('parula');
    contour(tfm_piv_user_xs{1},tfm_piv_user_ys{1},V,20,'LineColor','flat');
    hold on
    quiver(dismask.*tfm_piv_user_xs{1}(1:sp:end,1:sp:end),dismask.*tfm_piv_user_ys{1}(1:sp:end,1:sp:end),100*dismask.*uref(1:sp:end,1:sp:end),100*dismask.*vref(1:sp:end,1:sp:end),0,'w');
    %gtitle(filenames{i},'interpreter','none')
    set(gca,'xtick',[],'ytick',[])
    set(gca,'linewidth',2);
    axis image;
    
    %buttons
    %set(h_piv.button_ok,'Visible','on');
    if tfm_piv_user_counter>1
        set(h_piv.button_backwards,'Enable','on');
    else
        set(h_piv.button_backwards,'Enable','off');
    end
    if tfm_piv_user_counter==tfm_init_user_Nfiles
        set(h_piv.button_forwards,'Enable','off');
    else
        set(h_piv.button_forwards,'Enable','on');
    end
    
    %set texts to 1st vid
    set(h_piv.text_whichvidname,'String',tfm_init_user_filenamestack{1,tfm_piv_user_counter});
    set(h_piv.text_whichvid,'String',[num2str(tfm_piv_user_counter),'/',num2str(tfm_init_user_Nfiles)]);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

%fix(clock)
%userTiming= getappdata(0,'userTiming');
%userTiming.disp2ref{1} = tic;

%store everything for shared use
%setappdata(0,'userTiming',userTiming)
setappdata(0,'tfm_piv_user_contr',tfm_piv_user_contr);
setappdata(0,'tfm_piv_user_relax',tfm_piv_user_relax);
setappdata(0,'tfm_piv_user_d',tfm_piv_user_d);
setappdata(0,'tfm_piv_user_counter',tfm_piv_user_counter);

%profile viewer

function piv_push_pickref(hObject, eventdata, h_piv)
%disable figure during calculation
enableDisableFig(h_piv.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_piv.fig,1));


try
    %load shared needed para
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_piv_user_d=getappdata(0,'tfm_piv_user_d');
    tfm_piv_user_counter=getappdata(0,'tfm_piv_user_counter');
    
    %open figure
    hf=figure;
    plot((1:length(tfm_piv_user_d{tfm_piv_user_counter})),tfm_piv_user_d{tfm_piv_user_counter})
    hold on;
    title('Pick relaxed')
    [~,x,~] = selectdata('SelectionMode','closest');
    close(hf)
    
    %save as new reference
    tfm_piv_user_relax{tfm_piv_user_counter}=x;
    
    %set in boxes and save
    set(h_piv.edit_ref_ref,'String',num2str(tfm_piv_user_relax{tfm_piv_user_counter}));
    
catch
end


%store everything for shared use
setappdata(0,'tfm_piv_user_relax',tfm_piv_user_relax);


%% piv_push_pickcontr
function piv_push_pickcontr(hObject, eventdata, h_piv)
%disable figure during calculation
enableDisableFig(h_piv.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_piv.fig,1));


try
    %load shared needed para
    tfm_piv_user_contr=getappdata(0,'tfm_piv_user_contr');
    tfm_piv_user_d=getappdata(0,'tfm_piv_user_d');
    tfm_piv_user_counter=getappdata(0,'tfm_piv_user_counter');
    
    %open figure
    hf=figure;
    plot((1:length(tfm_piv_user_d{tfm_piv_user_counter})),tfm_piv_user_d{tfm_piv_user_counter})
    hold on;
    title('Pick contracted')
    [~,x,~] = selectdata('SelectionMode','closest');
    close(hf)
    
    %save as new reference
    tfm_piv_user_contr{tfm_piv_user_counter}=x;
    
    %set in boxes and save
    set(h_piv.edit_ref_contr,'String',num2str(tfm_piv_user_contr{tfm_piv_user_counter}));
    
catch
end

%store everything for shared use
setappdata(0,'tfm_piv_user_contr',tfm_piv_user_contr);

function piv_push_update(hObject, eventdata, h_piv)
%disable figure during calculation
enableDisableFig(h_piv.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_piv.fig,1));

try
    %load shared needed para
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_piv_user_contr=getappdata(0,'tfm_piv_user_contr');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_piv_user_d=getappdata(0,'tfm_piv_user_d');
    tfm_piv_user_counter=getappdata(0,'tfm_piv_user_counter');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary2=getappdata(0,'tfm_init_user_binary2');
    
    
    current_vid=tfm_piv_user_counter;
    
    %waitbar
    sb=statusbar(h_piv.fig,['Updating...']);
    sb.getComponent(0).setForeground(java.awt.Color.red);
    
    %get displacmenets from calc. before
    Num=tfm_init_user_Nframes{current_vid};
    tfm_piv_user_xs=cell(1,Num);
    tfm_piv_user_ys=cell(1,Num);
    tfm_piv_user_us=cell(1,Num);
    tfm_piv_user_vs=cell(1,Num);
    
    s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_x.mat'],'x');
    tfm_piv_user_xs = num2cell(s.x, [1 2]);
    s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_y.mat'],'y');
    tfm_piv_user_ys = num2cell(s.y, [1 2]);
    s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_u.mat'],'fu');
    tfm_piv_user_us = num2cell(s.fu, [1 2]);
    s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_v.mat'],'fv');
    tfm_piv_user_vs = num2cell(s.fv, [1 2]);
    
    %     for ifr=1:Num
    %         s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_x_',num2str(ifr),'.mat'],'x');
    %         tfm_piv_user_xs{ifr}=s.x;
    %         s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_y_',num2str(ifr),'.mat'],'y');
    %         tfm_piv_user_ys{ifr}=s.y;
    %         s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_u_',num2str(ifr),'.mat'],'fu');
    %         tfm_piv_user_us{ifr}=s.fu;
    %         s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_v_',num2str(ifr),'.mat'],'fv');
    %         tfm_piv_user_vs{ifr}=s.fv;
    %     end
    
    %mask: translate to correct spacing
    dismask=tfm_init_user_binary1{current_vid}(tfm_piv_user_ys{1}(:,1) ,tfm_piv_user_xs{1}(1,:));
    
    %read relaxed contr from editbox
    contr=str2double(get(h_piv.edit_ref_contr,'String'));
    relax=str2double(get(h_piv.edit_ref_ref,'String'));
    
    %for later use
    tfm_piv_user_contr{current_vid}=contr;
    tfm_piv_user_relax{current_vid}=relax;
    
    %transform mask, st 0s become Nans
    mask1=double(dismask);
    mask1(mask1==0)=NaN;
    mask2=double(~dismask);
    mask2(mask2==0)=NaN;
    
    %calculate preview displacement plots
    u1ref=tfm_piv_user_us{relax};
    v1ref=tfm_piv_user_vs{relax};
    d=zeros(1,Num);
    for ktest=1:Num
        deltaU=mask2.*(tfm_piv_user_us{ktest}-u1ref);
        deltaV=mask2.*(tfm_piv_user_vs{ktest}-v1ref);
        usn=(tfm_piv_user_us{ktest}-u1ref)-mean(deltaU(:),'omitnan').*ones(size(u1ref,1),size(u1ref,2));
        vsn=(tfm_piv_user_vs{ktest}-v1ref)-mean(deltaV(:),'omitnan').*ones(size(v1ref,1),size(v1ref,2));
        dsn=mask1.*sqrt(usn.^2+vsn.^2);
        d(ktest)=mean(dsn(:),'omitnan');
    end
    d(relax)=NaN;
    %for later use
    tfm_piv_user_d{current_vid}=d*tfm_init_user_conversion{current_vid}*1e6;
    
    %statusbar
    sb=statusbar(h_piv.fig,'Calculation - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %make second panel visible
    set(h_piv.panel_ref,'Visible','on');
    
    %display displacement plot
    axes(h_piv.axes_ref);
    plot(1:length(tfm_piv_user_d{tfm_piv_user_counter}),tfm_piv_user_d{tfm_piv_user_counter})
    set(h_piv.axes_ref, 'XTick', []);
    set(h_piv.axes_ref, 'YTick', []);
    
    %display the displacement map for the contracted frame of that video
    fr = [tfm_piv_user_relax{tfm_piv_user_counter}, tfm_piv_user_contr{tfm_piv_user_counter}];
    for i = 1:size(fr,2)
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_x.mat']);
        tfm_piv_user_xs{i}=s.x(:,:,i);
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_y.mat']);
        tfm_piv_user_ys{i}=s.y(:,:,i);
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_u.mat']);
        tfm_piv_user_us{i}=s.fu(:,:,i);
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_v.mat']);
        tfm_piv_user_vs{i}=s.fv(:,:,i);
    end
    
    dismask=tfm_init_user_binary2{tfm_piv_user_counter}(tfm_piv_user_ys{1}(:,1) ,tfm_piv_user_xs{1}(1,:));
    mask2=double(~dismask);
    mask2(mask2==0)=NaN;
    
    urel=tfm_piv_user_us{1};
    vrel=tfm_piv_user_vs{1};
    ucontr=tfm_piv_user_us{2};
    vcontr=tfm_piv_user_vs{2};
    deltaU=mask2.*(ucontr-urel);
    deltaV=mask2.*(vcontr-vrel);
    uref=(ucontr-urel)-mean(deltaU(:),'omitnan').*ones(size(urel,1),size(urel,2));
    vref=(vcontr-vrel)-mean(deltaV(:),'omitnan').*ones(size(vrel,1),size(vrel,2));
    V=sqrt(uref.^2+vref.^2);
    
    %plot spacing factor
    sp=1;%ceil(20/(spacing+1));
    %plot in axes
    cla(h_piv.axes_ncorr);
    axes(h_piv.axes_ncorr);
    hold on
    caxis('auto');
    colormap('parula');
    contour(tfm_piv_user_xs{1},tfm_piv_user_ys{1},V,20,'LineColor','flat');
    hold on
    quiver(dismask.*tfm_piv_user_xs{1}(1:sp:end,1:sp:end),dismask.*tfm_piv_user_ys{1}(1:sp:end,1:sp:end),100*dismask.*uref(1:sp:end,1:sp:end),100*dismask.*vref(1:sp:end,1:sp:end),0,'w');
    %gtitle(filenames{i},'interpreter','none')
    set(gca,'xtick',[],'ytick',[])
    set(gca,'linewidth',2);
    axis image;
    
    %buttons
    %set(h_piv.button_ok,'Visible','on');
    if tfm_piv_user_counter>1
        set(h_piv.button_backwards,'Enable','on');
    else
        set(h_piv.button_backwards,'Enable','off');
    end
    if tfm_piv_user_counter==tfm_init_user_Nfiles
        set(h_piv.button_forwards,'Enable','off');
    else
        set(h_piv.button_forwards,'Enable','on');
    end
    
    %set texts to 1st vid
    set(h_piv.text_whichvidname,'String',tfm_init_user_filenamestack{1,tfm_piv_user_counter});
    set(h_piv.text_whichvid,'String',[num2str(tfm_piv_user_counter),'/',num2str(tfm_init_user_Nfiles)]);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


%store everything for shared use
setappdata(0,'tfm_piv_user_contr',tfm_piv_user_contr);
setappdata(0,'tfm_piv_user_relax',tfm_piv_user_relax);
setappdata(0,'tfm_piv_user_d',tfm_piv_user_d);
setappdata(0,'tfm_piv_user_counter',tfm_piv_user_counter);


%% piv_push_calcref
function piv_push_calcref(hObject, eventdata, h_piv)

%profile on
%userTiming= getappdata(0,'userTiming');
%userTiming.disp2ref{2} = toc(userTiming.disp2ref{1});

%disable figure during calculation
enableDisableFig(h_piv.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_piv.fig,1));


try
    %load shared
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_piv_user_contr=getappdata(0,'tfm_piv_user_contr');
    tfm_init_user_binary2=getappdata(0,'tfm_init_user_binary2');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_gui_call_piv_flag=getappdata(0,'tfm_gui_call_piv_flag');
    
    %loop over vids and frames, calculate displacements inside blobbs and
    %angles
    %initialize
    tfm_piv_user_meand=cell(tfm_init_user_Nfiles,max([tfm_init_user_Nframes{:}]));
    tfm_piv_user_meanalpha=cell(tfm_init_user_Nfiles,max([tfm_init_user_Nframes{:}]));
    tfm_piv_user_stdalpha=cell(tfm_init_user_Nfiles,max([tfm_init_user_Nframes{:}]));
    tfm_piv_user_meandelta=cell(tfm_init_user_Nfiles,max([tfm_init_user_Nframes{:}]));
    tfm_piv_user_stddelta=cell(tfm_init_user_Nfiles,max([tfm_init_user_Nframes{:}]));
    tfm_piv_user_delta=cell(1,tfm_init_user_Nfiles);
    
    %if piv is called from IntraX for sarcomere analysis
    if ~tfm_gui_call_piv_flag
        tfm_conc_user_counter_roi=getappdata(0,'sarco_conc_user_counter_roi');
        tfm_conc_user_number_roi=getappdata(0,'sarco_conc_user_number_roi');
        tfm_conc_user_binary_roi=getappdata(0,'sarco_conc_user_binary_roi');
        tfm_conc_user_binary1=getappdata(0,'sarco_conc_user_binarysarc');
        
        tfm_piv_user_meand_roi=cell(tfm_init_user_Nfiles,max(tfm_conc_user_number_roi),max([tfm_init_user_Nframes{:}]));
        tfm_piv_user_meanalpha_roi=cell(tfm_init_user_Nfiles,max(tfm_conc_user_number_roi),max([tfm_init_user_Nframes{:}]));
        tfm_piv_user_stdalpha_roi=cell(tfm_init_user_Nfiles,max(tfm_conc_user_number_roi),max([tfm_init_user_Nframes{:}]));
        tfm_piv_user_meandelta_roi=cell(tfm_init_user_Nfiles,max(tfm_conc_user_number_roi),max([tfm_init_user_Nframes{:}]));
        tfm_piv_user_stddelta_roi=cell(tfm_init_user_Nfiles,max(tfm_conc_user_number_roi),max([tfm_init_user_Nframes{:}]));
        tfm_piv_user_delta_roi=cell(tfm_init_user_Nfiles,max(tfm_conc_user_number_roi));
    end
    
    sb=statusbar(h_piv.fig,'Calculating referenced displacements...');
    sb.getComponent(0).setForeground(java.awt.Color.red);
    
    %pivs
    for ivid=1:tfm_init_user_Nfiles
        %deleted for parfor
        %sb=statusbar(h_piv.fig,['Calculating... ',num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)), '%% done']);
        %sb.getComponent(0).setForeground(java.awt.Color.red);
        disp(['Referencing displacement for video #',num2str(ivid)])
        
        %loop over frames
        Num=tfm_init_user_Nframes{ivid};
        %FOSTER
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_x.mat']);
        tfm_piv_user_xs=s.x(:,:,1);
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_y.mat']);
        tfm_piv_user_ys=s.y(:,:,1);
        
        %mask
        tfm_piv_user_dismask=tfm_init_user_binary2{ivid}(tfm_piv_user_ys(:,1) ,tfm_piv_user_xs(1,:));
        
        %FOSTER pre-define dis_pts 3D array
        dis_pts = zeros(size(tfm_init_user_binary2{ivid},1), size(tfm_init_user_binary2{ivid},2), Num);
        dis_pts_dwnsamp = zeros(size(tfm_piv_user_dismask,1), size(tfm_piv_user_dismask,2), Num);
        
        
        if ~tfm_gui_call_piv_flag
            parfor frame=1:Num %parfor
                %calculation
                [ displacement,alphamean,alphastd,displacement_roi,alphamean_roi,alphastd_roi,~,dis_pts(:,:,frame), dis_pts_dwnsamp(:,:,frame)]=calc_blobb3(tfm_init_user_filenamestack{1,ivid},tfm_piv_user_relax{ivid},tfm_piv_user_contr{ivid},frame,tfm_piv_user_dismask,tfm_init_user_binary2{ivid},tfm_conc_user_counter_roi(ivid),tfm_conc_user_number_roi(ivid),tfm_conc_user_binary_roi(:,ivid));%[],[],[]);
                tfm_piv_user_meanalpha{ivid,frame}=alphamean;
                tfm_piv_user_stdalpha{ivid,frame}=alphastd;
                if tfm_conc_user_counter_roi(ivid)
                    %loop over rois
                    for roi=1:tfm_conc_user_number_roi(ivid)
                        temp = displacement_roi(roi);
                        tfm_piv_user_meand_roi{ivid,:,frame}=temp*tfm_init_user_conversion{ivid}*1e-6;
                        temp=alphamean_roi(roi);
                        tfm_piv_user_meanalpha_roi{ivid,:,frame}=temp;
                        temp=alphastd_roi(roi);
                        tfm_piv_user_stdalpha_roi{ivid,:,frame}=temp;
                        %test
                        %disp(num2str(tfm_piv_user_meanalpha_roi{ivid,roi,frame}))
                    end
                end
                if frame==tfm_piv_user_relax{ivid}
                    tfm_piv_user_meand{ivid,frame}=NaN;
                else
                    tfm_piv_user_meand{ivid,frame}=displacement*tfm_init_user_conversion{ivid}*1e-6;
                end
             end
        else
            parfor frame=1:Num%parfor
                [ displacement,~,~,~,~,~,~,dis_pts(:,:,frame),~]=calc_blobb3(tfm_init_user_filenamestack{1,ivid},tfm_piv_user_relax{ivid},tfm_piv_user_contr{ivid},frame,tfm_piv_user_dismask,tfm_init_user_binary2{ivid},[],[],[]);
                if frame==tfm_piv_user_relax{ivid}
                    tfm_piv_user_meand{ivid,frame}=NaN;
                else
                    tfm_piv_user_meand{ivid,frame}=displacement*tfm_init_user_conversion{ivid}*1e-6;
                end
                
            end
        end
       
       
        %FOSTER save dis_pts array
        save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_dis_pts.mat'],'dis_pts','-v7.3')
        
        if ~tfm_gui_call_piv_flag
            %%%
            %Used in sarcomere analysis
            %%%%
            
            %calculate delta:
            %reference: av_displacments; pts: dis_pts
            %load displacements for current video for delta calc.
            %dis = num2cell(dis_pts, [1 2]);
            dis = num2cell(dis_pts_dwnsamp, [1 2]);
            
            %find peaks for mean displ. (inside cell)
            [~,locs] = findpeaks([tfm_piv_user_meand{ivid,2:end-1}],'MinPeakHeight',.5*max([tfm_piv_user_meand{ivid,:}]));
            
            %find pts inside blobbs...
            blobb_comb=double(tfm_conc_user_binary1{ivid});
            if tfm_conc_user_counter_roi(ivid)
                %loop over rois
                for roi=1:tfm_conc_user_number_roi(ivid)
                    blobb_comb=blobb_comb+double(tfm_conc_user_binary_roi{roi,ivid});
                end
            end
            blobb_comb=blobb_comb(tfm_piv_user_ys(:,1) ,tfm_piv_user_xs(1,:));
            [xb,yb]=find(blobb_comb>0);
            
            %initi. delta
            delta=zeros(size(dis{1},1),size(dis{1},2));
            d_delta_mean =nan(1,length(xb));
            delta_temp = nan(length(xb),1,3);
       
            parfor kk=1:length(xb)
                di=zeros(1,Num);
                for frame=1:Num
                    if ~isnan(dis{frame}(xb(kk),yb(kk)))
                        di(frame)=dis{frame}(xb(kk),yb(kk));
                    end
                end
                
                
                if max(di)>0 || min(di)<0
                    %compute time lag w.r.t to mean displ. inside cell
                    s1=[tfm_piv_user_meand{ivid,:}];
                    s2=di*tfm_init_user_conversion{ivid}*1e-6;
                    %make second signal smaller... +- 10%, padd with 0s.
                    %s2(1:round(.1*length(s2)))=0;
                    %s2(round(.9*length(s2):end))=0;
                    
                    s1(isnan(s1))=0;
                    [acor,lag] = xcov(s1,s2);
                    
                    [~,I] = max(abs(acor));
                    lagDiff = lag(I);
                    timeDiff = lagDiff;
                    %delta(xb(kk),yb(kk))=-timeDiff;%parfor modification
                    delta_temp(kk,:,:) = [xb(kk),yb(kk),-timeDiff];
                    
                    %now this gives a range for our delta calc.
                    %peaks i
                    [pksi,locsi] = findpeaks(s2(2:end-1),'MinPeakHeight',.5*max(s2));
                    %for each peak of the current curve, look if there is a peak on
                    %the reference curve inside the range
                    ltot=length(pksi);
                    d_delta=nan(1,ltot);
                    for i=1:ltot
                        %range -fps/2+timediff, +fps/2+timediff
                        
                        %find closest in list
                        tmp=locs-locsi(i);
                        [~,idx] = min(abs(tmp)); %index of closest value
                        
                        if locs(idx)>=(locsi(i)-1-timeDiff) && locs(idx)<=(locsi(i)+1-timeDiff)
                            closest = locs(idx); %closest value
                            d_delta(i) = closest-locsi(i);
                        end
                    end
                    d_delta_mean(kk) = mean(d_delta,'omitnan');%parfor modification
                end
            end
            
            for kk=1:length(xb)
                if ~isnan(d_delta_mean(kk))
                    delta_temp(kk,:,3) = d_delta_mean(kk);
                end
                delta(xb(kk),yb(kk)) = delta_temp(kk,:,3);
            end
            
            %apply the different masks: piv
            binary0=double(tfm_conc_user_binary1{ivid});
            binary0(binary0==0)=NaN;
            
            xi=1:size(binary0,2);
            yi=1:size(binary0,1);
            [Xqu,Yqu]=meshgrid(xi,yi);
            delta = interp2(tfm_piv_user_xs,tfm_piv_user_ys,delta,Xqu,Yqu,'linear',0);

            tfm_piv_user_delta{ivid}=delta.*binary0;
            
            delta_vec = subsref((delta.*binary0).', substruct('()', {':'})).';
            delta_vec(isnan(delta_vec))=[];
            tfm_piv_user_meandelta{ivid}=mean(delta_vec);
            tfm_piv_user_stddelta{ivid}=std(delta_vec);
            
            % figure,
            % imshow(delta.*binary0,[])
            % colormap('jet')
            % colorbar;
            
            %rois
            if tfm_conc_user_counter_roi(ivid)
                %loop over rois
                for roi=1:tfm_conc_user_number_roi(ivid)
                    binary0=double(tfm_conc_user_binary_roi{roi,ivid});
                    binary0(binary0==0)=NaN;
                    
                    tfm_piv_user_delta_roi{ivid,roi}=delta.*binary0;
                    
                    delta_vec = subsref((delta.*binary0).', substruct('()', {':'})).';
                    delta_vec(isnan(delta_vec))=[];
                    tfm_piv_user_meandelta_roi{ivid,roi}=mean(delta_vec);
                    tfm_piv_user_stddelta_roi{ivid,roi}=std(delta_vec);
                    
                    %test
                    %disp(num2str(tfm_piv_user_stddelta_roi{ivid,roi}))
                    %         figure,
                    %         imshow(delta.*binary0,[])
                    %         colormap('jet')
                    %         colorbar;
                    
                end
            end
            
            %%%%
            %%%%
        end
    end

    %statusbar
    sb=statusbar(h_piv.fig,'Calculation - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));

    fprintf(1,'CXS-TFM: Displacements calculated.\n');

    %enable ok button & checkbox
    set(h_piv.button_ok,'Visible','on')
    set(h_piv.checkbox_matrix,'Visible','on')
    set(h_piv.checkbox_heatmaps,'Visible','on')
    
    
    %save for shared use
    %setappdata(0,'userTiming',userTiming)
    setappdata(0,'tfm_piv_user_meand',tfm_piv_user_meand)
    
    %profile viewer
    
    % send notif
    myMessage='Ncorr step finished';
    notif = getappdata(0,'notif');
    if notif.on
        for i = size(notif.url)
            webwrite(notif.url{i},'value1',myMessage);
        end
    end
    
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


%save for shared use
setappdata(0,'tfm_piv_user_meand',tfm_piv_user_meand)
setappdata(0,'tfm_piv_user_meanalpha',tfm_piv_user_meanalpha)
setappdata(0,'tfm_piv_user_stdalpha',tfm_piv_user_stdalpha)
setappdata(0,'tfm_piv_user_meandelta',tfm_piv_user_meandelta)
setappdata(0,'tfm_piv_user_stddelta',tfm_piv_user_stddelta)
setappdata(0,'tfm_piv_user_delta',tfm_piv_user_delta)

if ~tfm_gui_call_piv_flag
    setappdata(0,'tfm_piv_user_meand_roi',tfm_piv_user_meand_roi)
    setappdata(0,'tfm_piv_user_meanalpha_roi',tfm_piv_user_meanalpha_roi)
    setappdata(0,'tfm_piv_user_stdalpha_roi',tfm_piv_user_stdalpha_roi)
    setappdata(0,'tfm_piv_user_meandelta_roi',tfm_piv_user_meandelta_roi)
    setappdata(0,'tfm_piv_user_stddelta_roi',tfm_piv_user_stddelta_roi)
    setappdata(0,'tfm_piv_user_delta_roi',tfm_piv_user_delta_roi)
end


%% piv_push_backwards
function piv_push_backwards(hObject, eventdata, h_piv)
%disable figure during calculation
enableDisableFig(h_piv.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_piv.fig,1));


try
    %load shared needed para
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_piv_user_contr=getappdata(0,'tfm_piv_user_contr');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_piv_user_d=getappdata(0,'tfm_piv_user_d');
    tfm_piv_user_counter=getappdata(0,'tfm_piv_user_counter');
    tfm_init_user_binary2=getappdata(0,'tfm_init_user_binary2');
    
    %update counter
    tfm_piv_user_counter=tfm_piv_user_counter-1;
    
    %now display info for current video.
    set(h_piv.edit_ref_ref,'String',num2str(tfm_piv_user_relax{tfm_piv_user_counter}));
    set(h_piv.edit_ref_contr,'String',num2str(tfm_piv_user_contr{tfm_piv_user_counter}));
    
    %display displacement plot
    axes(h_piv.axes_ref);
    plot(1:length(tfm_piv_user_d{tfm_piv_user_counter}),tfm_piv_user_d{tfm_piv_user_counter})
    set(h_piv.axes_ref, 'XTick', []);
    set(h_piv.axes_ref, 'YTick', []);
    
    %display the displacement map for the contracted frame of that video
    fr = [tfm_piv_user_relax{tfm_piv_user_counter}, tfm_piv_user_contr{tfm_piv_user_counter}];
    for i = 1:size(fr,2)
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_x.mat']);
        tfm_piv_user_xs{i}=s.x(:,:,fr(i));
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_y.mat']);
        tfm_piv_user_ys{i}=s.y(:,:,fr(i));
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_u.mat']);
        tfm_piv_user_us{i}=s.fu(:,:,fr(i));
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_v.mat']);
        tfm_piv_user_vs{i}=s.fv(:,:,fr(i));
    end
    
    dismask=tfm_init_user_binary2{tfm_piv_user_counter}(tfm_piv_user_ys{1}(:,1) ,tfm_piv_user_xs{1}(1,:));
    mask2=double(~dismask);
    mask2(mask2==0)=NaN;
    
    urel=tfm_piv_user_us{1};
    vrel=tfm_piv_user_vs{1};
    ucontr=tfm_piv_user_us{2};
    vcontr=tfm_piv_user_vs{2};
    deltaU=mask2.*(ucontr-urel);
    deltaV=mask2.*(vcontr-vrel);
    uref=(ucontr-urel)-mean(deltaU(:),'omitnan').*ones(size(urel,1),size(urel,2));
    vref=(vcontr-vrel)-mean(deltaV(:),'omitnan').*ones(size(vrel,1),size(vrel,2));
    V=sqrt(uref.^2+vref.^2);
    
    %plot spacing factor
    sp=1;%ceil(20/(spacing+1));
    %plot in axes
    cla(h_piv.axes_ncorr);
    axes(h_piv.axes_ncorr);
    hold on
    caxis('auto');
    colormap('parula');
    contour(tfm_piv_user_xs{1},tfm_piv_user_ys{1},V,20,'LineColor','flat');
    hold on
    quiver(dismask.*tfm_piv_user_xs{1}(1:sp:end,1:sp:end),dismask.*tfm_piv_user_ys{1}(1:sp:end,1:sp:end),100*dismask.*uref(1:sp:end,1:sp:end),100*dismask.*vref(1:sp:end,1:sp:end),0,'w');
    %gtitle(filenames{i},'interpreter','none')
    set(gca,'xtick',[],'ytick',[])
    set(gca,'linewidth',2);
    axis image;
    
    %buttons
    %set(h_piv.button_ok,'Visible','on');
    if tfm_piv_user_counter>1
        set(h_piv.button_backwards,'Enable','on');
    else
        set(h_piv.button_backwards,'Enable','off');
    end
    if tfm_piv_user_counter==tfm_init_user_Nfiles
        set(h_piv.button_forwards,'Enable','off');
    else
        set(h_piv.button_forwards,'Enable','on');
    end
    
    %set texts to 1st vid
    set(h_piv.text_whichvidname,'String',tfm_init_user_filenamestack{1,tfm_piv_user_counter});
    set(h_piv.text_whichvid,'String',[num2str(tfm_piv_user_counter),'/',num2str(tfm_init_user_Nfiles)]);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


%store everything for shared use
setappdata(0,'tfm_piv_user_counter',tfm_piv_user_counter);


%% piv_push_forwards
function piv_push_forwards(hObject, eventdata, h_piv)
%disable figure during calculation
enableDisableFig(h_piv.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_piv.fig,1));

try
    %load shared needed para
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_piv_user_contr=getappdata(0,'tfm_piv_user_contr');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_piv_user_d=getappdata(0,'tfm_piv_user_d');
    tfm_piv_user_counter=getappdata(0,'tfm_piv_user_counter');
    tfm_init_user_binary2=getappdata(0,'tfm_init_user_binary2');
    
    %update counter
    tfm_piv_user_counter=tfm_piv_user_counter+1;
    
    %now display info for current video.
    set(h_piv.edit_ref_ref,'String',num2str(tfm_piv_user_relax{tfm_piv_user_counter}));
    set(h_piv.edit_ref_contr,'String',num2str(tfm_piv_user_contr{tfm_piv_user_counter}));
    
    %display displacement plot
    axes(h_piv.axes_ref);
    plot(1:length(tfm_piv_user_d{tfm_piv_user_counter}),tfm_piv_user_d{tfm_piv_user_counter})
    set(h_piv.axes_ref, 'XTick', []);
    set(h_piv.axes_ref, 'YTick', []);
    
    %display the displacement map for the contracted frame of that video
    fr = [tfm_piv_user_relax{tfm_piv_user_counter}, tfm_piv_user_contr{tfm_piv_user_counter}];
    for i = 1:size(fr,2)
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_x.mat']);
        tfm_piv_user_xs{i}=s.x(:,:,fr(i));
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_y.mat']);
        tfm_piv_user_ys{i}=s.y(:,:,fr(i));
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_u.mat']);
        tfm_piv_user_us{i}=s.fu(:,:,fr(i));
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,tfm_piv_user_counter},'/tfm_piv_v.mat']);
        tfm_piv_user_vs{i}=s.fv(:,:,fr(i));
    end
    
    dismask=tfm_init_user_binary2{tfm_piv_user_counter}(tfm_piv_user_ys{1}(:,1) ,tfm_piv_user_xs{1}(1,:));
    mask2=double(~dismask);
    mask2(mask2==0)=NaN;
    
    urel=tfm_piv_user_us{1};
    vrel=tfm_piv_user_vs{1};
    ucontr=tfm_piv_user_us{2};
    vcontr=tfm_piv_user_vs{2};
    deltaU=mask2.*(ucontr-urel);
    deltaV=mask2.*(vcontr-vrel);
    uref=(ucontr-urel)-mean(deltaU(:),'omitnan').*ones(size(urel,1),size(urel,2));
    vref=(vcontr-vrel)-mean(deltaV(:),'omitnan').*ones(size(vrel,1),size(vrel,2));
    V=sqrt(uref.^2+vref.^2);
    
    %plot spacing factor
    sp=1;%ceil(20/(spacing+1));
    %plot in axes
    cla(h_piv.axes_ncorr);
    axes(h_piv.axes_ncorr);
    hold on
    caxis('auto');
    colormap('parula');
    contour(tfm_piv_user_xs{1},tfm_piv_user_ys{1},V,20,'LineColor','flat');
    hold on
    quiver(dismask.*tfm_piv_user_xs{1}(1:sp:end,1:sp:end),dismask.*tfm_piv_user_ys{1}(1:sp:end,1:sp:end),100*dismask.*uref(1:sp:end,1:sp:end),100*dismask.*vref(1:sp:end,1:sp:end),0,'w');
    %gtitle(filenames{i},'interpreter','none')
    set(gca,'xtick',[],'ytick',[])
    set(gca,'linewidth',2);
    axis image;
    
    %buttons
    %set(h_piv.button_ok,'Visible','on');
    if tfm_piv_user_counter>1
        set(h_piv.button_backwards,'Enable','on');
    else
        set(h_piv.button_backwards,'Enable','off');
    end
    if tfm_piv_user_counter==tfm_init_user_Nfiles
        set(h_piv.button_forwards,'Enable','off');
    else
        set(h_piv.button_forwards,'Enable','on');
    end
    
    %set texts to 1st vid
    set(h_piv.text_whichvidname,'String',tfm_init_user_filenamestack{1,tfm_piv_user_counter});
    set(h_piv.text_whichvid,'String',[num2str(tfm_piv_user_counter),'/',num2str(tfm_init_user_Nfiles)]);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


%store everything for shared use
setappdata(0,'tfm_piv_user_counter',tfm_piv_user_counter);


%% piv_push_ok
function piv_push_ok(hObject, eventdata, h_piv, h_main)
%disable figure during calculation
enableDisableFig(h_piv.fig,0);

%turn back on in the end
%clean1=onCleanup(@()enableDisableFig(h_piv.fig,1));

try
    %load what shared para we need
    tfm_init_user_strln = getappdata(0,'tfm_init_user_strln');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_piv_user_contr=getappdata(0,'tfm_piv_user_contr');
    tfm_gui_call_piv_flag=getappdata(0,'tfm_gui_call_piv_flag');
    
    %add relaxed/contracted to excel file
    for ivid=1:tfm_init_user_Nfiles
        sb=statusbar(h_piv.fig,['Saving to Excel... ',num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)), '%% done']);
        sb.getComponent(0).setForeground(java.awt.Color.red);
        
        newfile=[tfm_init_user_pathnamestack{1,ivid},'/',tfm_init_user_filenamestack{1,ivid},'/Results/',tfm_init_user_filenamestack{1,ivid},'.xlsx'];
        A = {tfm_piv_user_relax{ivid},tfm_piv_user_contr{ivid}};
        sheet = 'General';
        xlRange = 'F3';
        xlwrite(newfile,A,sheet,xlRange);
    end
    %statusbar
    sb=statusbar(h_piv.fig,'Saving - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %check if user wants to save
    value = get(h_piv.checkbox_matrix, 'Value');
    
    if value
        w_i=0;
        % loop over videos
        for ivid=1:tfm_init_user_Nfiles
            % make output folder for displacements
            if ~isequal(exist([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Displacements'], 'dir'),7)
                [~,~] = mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Displacements']);  
            end
            
            %loop over frames
            %for ifr=1:tfm_init_user_Nframes{ivid} FOSTER: no longer need
            %to wait because all displacements are in one file
            %waitbar
            w_i=w_i+1;
            sb=statusbar(h_piv.fig,['Saving full fields... ',num2str(floor(100*(w_i-1)/sum([tfm_init_user_Nframes{:}]))), '%% done']);
            sb.getComponent(0).setForeground(java.awt.Color.red);
            %copy displacements
            copyfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_x.mat'],[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Displacements/tfm_piv_x.mat']);
            copyfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_y.mat'],[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Displacements/tfm_piv_y.mat']);
            copyfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_u.mat'],[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Displacements/tfm_piv_u.mat']);
            copyfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_v.mat'],[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Displacements/tfm_piv_v.mat']);
            %end
        end
        %statusbar
        sb=statusbar(h_piv.fig,'Saving - Done !');
        sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    end
    
    %check if user wants to save heatmaps
    value = get(h_piv.checkbox_heatmaps, 'Value');
    
    if ~value
        for ivid=1:tfm_init_user_Nfiles
            rmdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Displacement Heatmaps'],'s');
        end
    end
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

%userTiming= getappdata(0,'userTiming');
%userTiming.piv{2} = toc(userTiming.piv{1});
%userTiming.piv2tfm{1} = tic;

%save for shared use
%setappdata(0,'userTiming',userTiming)

fprintf(1,'CXS-TFM: PIV calculations complete.\n');

%enable fig
enableDisableFig(h_piv.fig,1);

%change main windows 3. button status
set(h_main.button_piv,'ForegroundColor',[0 .5 0]);

%close window
close(h_piv.fig);

%move main window to the side
movegui(h_main.fig,'center')

%Streamlining
if tfm_init_user_strln
    if tfm_gui_call_piv_flag %only for ContraX, not for IntraX
        tfm_tfm(h_main);
    end
end


function piv_checkbox(hObject, eventdata, h_piv)
if get(h_piv.checkbox,'Value')
    set(h_piv.panel_post,'Visible','on')
else
    set(h_piv.panel_post,'Visible','off')
end
