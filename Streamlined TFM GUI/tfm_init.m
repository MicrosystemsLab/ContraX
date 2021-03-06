%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tfm_init.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part of the Streamlined TFM GUI: executes from the main Streamlined TFM
% GUI menu and is the initialization step that loads the video to analize
% and collects all the necessary parameters and cell outline, automatically
% or manually.
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


function tfm_init(h_main)

%profile on

%main function for the initilization window of beads gui

%create new window for initialization
%figure size
figuresize=[500,1060];
%get screen size
screensize = get(0,'ScreenSize');
%position figure on center of screen
xpos = ceil((screensize(3)-figuresize(2))/2);
ypos = ceil((screensize(4)-figuresize(1))/2);
%create figure; invisible at first
h_init(1).fig=figure(...
    'position',[xpos, ypos, figuresize(2), figuresize(1)],...
    'units','pixels',...
    'renderer','OpenGL',...
    'MenuBar','none',...
    'PaperPositionMode','auto',...
    'Name','Beads Initialization',...
    'NumberTitle','off',...
    'Resize','off',...
    'Color',[.2,.2,.2],...
    'visible','off');

%color of the background and foreground
pcolor = [.2 .2 .2];
ptcolor = [1 1 1];
bcolor = [.3 .3 .3];
btcolor = [1 1 1];
h_init(1).ForegroundColor = ptcolor;
h_init(1).BackgroundColor = pcolor;


%create uipanel for readin & buttons
%uipanel: contains readin button for videos and folders
h_init(1).panel_read = uipanel('Parent',h_init(1).fig,'Title','Open 1 or more video files','units','pixels','Position',[20,350,155,135]);
h_init(1).panel_read.ForegroundColor = ptcolor;
h_init(1).panel_read.BackgroundColor = pcolor;
%button 1: read in videos
h_init(1).button_readvid = uicontrol('Parent',h_init(1).panel_read,'style','pushbutton','position',[5,95,140,25],'string','Add video (tif, czi, avi)');
%button 2: read in folder
h_init(1).button_readfolder = uicontrol('Parent',h_init(1).panel_read,'style','pushbutton','position',[5,65,140,25],'string','Add images folder');
%button 3: read bf videos
h_init(1).button_readbf = uicontrol('Parent',h_init(1).panel_read,'style','pushbutton','position',[5,35,140,25],'string','Add bf videos');
%take read bf out of readvid and add here

% checkbox for remove first frame
h_init(1).checkbox_trim = uicontrol('Parent',h_init(1).panel_read,'style','checkbox','position',[5,5,140,25],'string',{'Trim 1st frames', '(select before loading)'},'visible','on','value',0);
h_init(1).checkbox_trim.ForegroundColor = ptcolor;
h_init(1).checkbox_trim.BackgroundColor = pcolor;

%create uipanel to display and delete loaded videos
%uipanel: list all the loaded videos, invisible
h_init(1).panel_list = uipanel('Parent',h_init(1).fig,'Title','List of loaded videos','units','pixels','Position',[20,45,155,300],'visible','off');
h_init(1).panel_list.ForegroundColor = ptcolor;
h_init(1).panel_list.BackgroundColor = pcolor;
%listbox 1: lists videos
h_init(1).listbox_display = uicontrol('Parent',h_init(1).panel_list,'style','listbox','position',[5,35,140,250]);
%button 3: delete current video
h_init(1).button_delete = uicontrol('Parent',h_init(1).panel_list,'style','pushbutton','position',[5,5,140,25],'string','Delete selected');

%create uipanel to display video information and first frame
%uipanel:
h_init(1).panel_vid = uipanel('Parent',h_init(1).fig,'Title','Video information','units','pixels','Position',[190,45,850,440],'visible','off');
h_init(1).panel_vid.ForegroundColor = ptcolor;
h_init(1).panel_vid.BackgroundColor = pcolor;
%subpanel for masks
h_init(1).subpanel_vid = uipanel('Parent',h_init(1).panel_vid,'Title','Masks information','units','pixels','Position',[550,320,290,110],'visible','off');
h_init(1).subpanel_vid.ForegroundColor = ptcolor;
h_init(1).subpanel_vid.BackgroundColor = pcolor;
%axes: display first frame of current
h_init(1).axes_curr = axes('Parent',h_init(1).panel_vid,'Units', 'pixels','Position',[15,35,400,290]);
%axes: display corresponding bf frame
h_init(1).axes_bf = axes('Parent',h_init(1).panel_vid,'Units','pixels','Position',[430,35,400,290]);
%button 4: forwards
h_init(1).button_forwards = uicontrol('Parent',h_init(1).panel_vid,'style','pushbutton','position',[385,5,25,25],'string','>');
%button 5: backwards
h_init(1).button_backwards = uicontrol('Parent',h_init(1).panel_vid,'style','pushbutton','position',[360,5,25,25],'string','<');
%button 6: load outline
h_init(1).button_load = uicontrol('Parent',h_init(1).panel_vid,'style','pushbutton','position',[460,385,70,15],'string','Load');
%button 6b: draw outline
h_init(1).button_draw = uicontrol('Parent',h_init(1).panel_vid,'style','pushbutton','position',[410,365,120,15],'string','Draw from loaded image');
%button 6c: draw outline from new image
h_init(1).button_draw_new = uicontrol('Parent',h_init(1).panel_vid,'style','pushbutton','position',[410,345,120,15],'string','Draw from new image');
%button 7: update outlines
h_init(1).button_update = uicontrol('Parent',h_init(1).subpanel_vid,'style','pushbutton','position',[5,5,120,15],'string','Update Outlines');
%button 8: auto-draw outline
h_init(1).button_auto_draw = uicontrol('Parent',h_init(1).panel_vid,'style','pushbutton','position',[460,405,70,15],'string','Auto-Draw');

%button 9: crop all vids REMOVE WHEN CHECKBOX WORKS
h_init(1).button_crop_all = uicontrol('Parent',h_init(1).panel_vid,'style','pushbutton','position',[700,345,120,15],'string','Crop all videos','visible','off');

%create ok button
h_init(1).button_ok = uicontrol('Parent',h_init(1).fig,'style','pushbutton','position',[835,20,100,20],'string','OK','visible','off');
%create ok (streamlined) button
h_init(1).button_ok_strln = uicontrol('Parent',h_init(1).fig,'style','pushbutton','position',[940,20,100,20],'string','OK (streamlined)','visible','off');


%text 1: show which video (i/n)
h_init(1).text_whichvid = uicontrol('Parent',h_init(1).panel_vid,'style','text','position',[300,10,50,15],'string','(1/1)','HorizontalAlignment','left');
h_init(1).text_whichvid.ForegroundColor = ptcolor;
h_init(1).text_whichvid.BackgroundColor = pcolor;
%text 2: show fps
h_init(1).text_fps = uicontrol('Parent',h_init(1).panel_vid,'style','text','position',[10,365,150,15],'string','Frames per second','HorizontalAlignment','left');
h_init(1).text_fps.ForegroundColor = ptcolor;
h_init(1).text_fps.BackgroundColor = pcolor;
%text 3: show conversion
h_init(1).text_conversion = uicontrol('Parent',h_init(1).panel_vid,'style','text','position',[10,345,150,15],'string','Conversion (um/px)','HorizontalAlignment','left');
h_init(1).text_conversion.ForegroundColor = ptcolor;
h_init(1).text_conversion.BackgroundColor = pcolor;
%text 4: show number of frames
h_init(1).text_nframes = uicontrol('Parent',h_init(1).panel_vid,'style','text','position',[10,385,150,15],'string','Number of frames','HorizontalAlignment','left');
h_init(1).text_nframes.ForegroundColor = ptcolor;
h_init(1).text_nframes.BackgroundColor = pcolor;
%text 5: show cellname
h_init(1).text_cellname = uicontrol('Parent',h_init(1).panel_vid,'style','text','position',[10,405,150,15],'string','Cell name','HorizontalAlignment','left');
h_init(1).text_cellname.ForegroundColor = ptcolor;
h_init(1).text_cellname.BackgroundColor = pcolor;
%text 6: cell outline
h_init(1).text_cell1 = uicontrol('Parent',h_init(1).panel_vid,'style','text','position',[410,405,40,15],'string','Cell','HorizontalAlignment','left');
h_init(1).text_cell1.ForegroundColor = ptcolor;
h_init(1).text_cell1.BackgroundColor = pcolor;
h_init(1).text_cell2 = uicontrol('Parent',h_init(1).panel_vid,'style','text','position',[410,388,40,15],'string','Outline','HorizontalAlignment','left');
h_init(1).text_cell2.ForegroundColor = ptcolor;
h_init(1).text_cell2.BackgroundColor = pcolor;
%text 7: show which video (name)
h_init(1).text_whichvidname = uicontrol('Parent',h_init(1).panel_vid,'style','text','position',[20,10,240,15],'string','Experiment','HorizontalAlignment','left');
h_init(1).text_whichvidname.ForegroundColor = ptcolor;
h_init(1).text_whichvidname.BackgroundColor = pcolor;
%text 7b: show bf video name
h_init(1).text_bf_whichvidname = uicontrol('Parent',h_init(1).panel_vid,'style','text','position',[450,10,200,15],'string','Experiment','HorizontalAlignment','left');
h_init(1).text_bf_whichvidname.ForegroundColor = ptcolor;
h_init(1).text_bf_whichvidname.BackgroundColor = pcolor;
%text 8: crop mask
h_init(1).text_cropmask = uicontrol('Parent',h_init(1).subpanel_vid,'style','text','position',[150,80,100,15],'string','Crop mask (green)','HorizontalAlignment','left');
h_init(1).text_cropmask.ForegroundColor = ptcolor;
h_init(1).text_cropmask.BackgroundColor = pcolor;
%text 8b: crop mask preview
h_init(1).text_cropmask = uicontrol('Parent',h_init(1).subpanel_vid,'style','text','position',[170,5,100,15],'string','Preview crop mask (green)','HorizontalAlignment','left');
h_init(1).text_cropmask.ForegroundColor = ptcolor;
h_init(1).text_cropmask.BackgroundColor = pcolor;
%text 9: length
h_init(1).text_length = uicontrol('Parent',h_init(1).subpanel_vid,'style','text','position',[150,60,60,15],'string','Length (um)','HorizontalAlignment','left');
h_init(1).text_length.ForegroundColor = ptcolor;
h_init(1).text_length.BackgroundColor = pcolor;
%text 10: width
h_init(1).text_width = uicontrol('Parent',h_init(1).subpanel_vid,'style','text','position',[150,40,60,15],'string','Width (um)','HorizontalAlignment','left');
h_init(1).text_width.ForegroundColor = ptcolor;
h_init(1).text_width.BackgroundColor = pcolor;
%text 11: analysis region
h_init(1).text_anlysreg = uicontrol('Parent',h_init(1).subpanel_vid,'style','text','position',[5,80,120,15],'string','Analysis Region (blue)','HorizontalAlignment','left');
h_init(1).text_anlysreg.ForegroundColor = ptcolor;
h_init(1).text_anlysreg.BackgroundColor = pcolor;
%text 12: youngs
h_init(1).text_youngs = uicontrol('Parent',h_init(1).panel_vid,'style','text','position',[210,405,100,15],'string','Young"s Mod (Pa)','HorizontalAlignment','left');
h_init(1).text_youngs.ForegroundColor = ptcolor;
h_init(1).text_youngs.BackgroundColor = pcolor;
%text 13: poisson
h_init(1).text_poisson = uicontrol('Parent',h_init(1).panel_vid,'style','text','position',[210,385,80,15],'string','Poisson Ratio','HorizontalAlignment','left');
h_init(1).text_poisson.ForegroundColor = ptcolor;
h_init(1).text_poisson.BackgroundColor = pcolor;
%text 14: area factor
h_init(1).text_area_factor = uicontrol('Parent',h_init(1).subpanel_vid,'style','text','position',[5,60,80,15],'string','Area Factor','HorizontalAlignment','left');
h_init(1).text_area_factor.ForegroundColor = ptcolor;
h_init(1).text_area_factor.BackgroundColor = pcolor;
%text 15: scale factor
h_init(1).text_scale_factor = uicontrol('Parent',h_init(1).subpanel_vid,'style','text','position',[5,40,80,15],'string','Scale Factor','HorizontalAlignment','left');
h_init(1).text_scale_factor.ForegroundColor = ptcolor;
h_init(1).text_scale_factor.BackgroundColor = pcolor;

%edit 1: fps
h_init(1).edit_fps = uicontrol('Parent',h_init(1).panel_vid,'style','edit','position',[120,365,70,15],'HorizontalAlignment','center');
%edit 2: conversion
h_init(1).edit_conversion = uicontrol('Parent',h_init(1).panel_vid,'style','edit','position',[120,345,70,15],'HorizontalAlignment','center');
%edit 3: number of frames
h_init(1).edit_nframes = uicontrol('Parent',h_init(1).panel_vid,'style','edit','position',[120,385,70,15],'HorizontalAlignment','center');
%edit 4: cellname
h_init(1).edit_cellname = uicontrol('Parent',h_init(1).panel_vid,'style','edit','position',[120,405,70,15],'HorizontalAlignment','center');
%edit 5: crop length
h_init(1).edit_croplength = uicontrol('Parent',h_init(1).subpanel_vid,'style','edit','position',[220,60,55,15],'HorizontalAlignment','center');
%edit 6: crop width
h_init(1).edit_cropwidth = uicontrol('Parent',h_init(1).subpanel_vid,'style','edit','position',[220,40,55,15],'HorizontalAlignment','center');
%edit 7: youngs
h_init(1).edit_youngs = uicontrol('Parent',h_init(1).panel_vid,'style','edit','position',[310,405,70,15],'HorizontalAlignment','center');
%edit 8: poisson
h_init(1).edit_poisson = uicontrol('Parent',h_init(1).panel_vid,'style','edit','position',[310,385,70,15],'HorizontalAlignment','center');
%edit 9: area factor
h_init(1).edit_area_factor = uicontrol('Parent',h_init(1).subpanel_vid,'style','edit','position',[75,60,50,15],'HorizontalAlignment','center');
%edit 10: scale factor
h_init(1).edit_scale_factor = uicontrol('Parent',h_init(1).subpanel_vid,'style','edit','position',[75,40,50,15],'HorizontalAlignment','center');


%checkbox: crop mask
h_init(1).checkbox_cropmask = uicontrol('Parent',h_init(1).subpanel_vid,'style','checkbox','position',[150,5,15,15],'string','Preview crop mask','visible','on','value',0);
h_init(1).checkbox_cropmask.ForegroundColor = ptcolor;
h_init(1).checkbox_cropmask.BackgroundColor = pcolor;
% checkbox for rotate
h_init(1).checkbox_rotate = uicontrol('Parent',h_init(1).subpanel_vid,'style','checkbox','position',[150,22,120,15],'string','Rotate region','visible','off','value',1);
h_init(1).checkbox_rotate.ForegroundColor = ptcolor;
h_init(1).checkbox_rotate.BackgroundColor = pcolor;
% checkbox for crop
h_init(1).checkbox_crop = uicontrol('Parent',h_init(1).fig,'style','checkbox','position',[440,20,80,20],'string','Crop videos','visible','off','value',0);
h_init(1).checkbox_crop.ForegroundColor = ptcolor;
h_init(1).checkbox_crop.BackgroundColor = pcolor;
% checkbox for binning
h_init(1).checkbox_bin = uicontrol('Parent',h_init(1).fig,'style','checkbox','position',[530,20,80,20],'string','Bin videos','visible','off','value',0);
h_init(1).checkbox_bin.ForegroundColor = ptcolor;
h_init(1).checkbox_bin.BackgroundColor = pcolor;
% menu for bin size
h_init(1).menu_bin = uicontrol('Parent',h_init(1).fig,'style','popup','position',[600,20,60,20],'string',{'2x','4x'},'visible','off');
%checkbox for bleachcorrect
h_init(1).checkbox_bleach = uicontrol('Parent',h_init(1).fig,'style','checkbox','position',[665,20,80,20],'string','Debleach','visible','off','value',0);
h_init(1).checkbox_bleach.ForegroundColor = ptcolor;
h_init(1).checkbox_bleach.BackgroundColor = pcolor;
%checkbox for denoise
h_init(1).checkbox_denoise = uicontrol('Parent',h_init(1).fig,'style','checkbox','position',[750,20,80,20],'string','Denoise','visible','off','value',1);
h_init(1).checkbox_denoise.ForegroundColor = ptcolor;
h_init(1).checkbox_denoise.BackgroundColor = pcolor;

%assign callbacks to buttons
%button 1
set(h_init(1).button_readvid,'callback',{@init_push_readvid,h_init})
%button 2
set(h_init(1).button_readfolder,'callback',{@init_push_readfolder,h_init})
%button 4
set(h_init(1).button_delete,'callback',{@init_push_delete,h_init})
%button 5
set(h_init(1).button_forwards,'callback',{@init_push_forwards,h_init})
%button 6
set(h_init(1).button_backwards,'callback',{@init_push_backwards,h_init})
%button 7
set(h_init(1).button_update,'callback',{@init_push_update,h_init})
%button 8
set(h_init(1).button_load,'callback',{@init_push_load,h_init})
%button 8b
set(h_init(1).button_draw,'callback',{@init_push_draw,h_init})
%button 8c
set(h_init(1).button_draw_new,'callback',{@init_push_draw_new,h_init})
%button 9
set(h_init(1).button_ok,'callback',{@init_push_ok,h_init,h_main})
%button 9b
set(h_init(1).button_ok_strln,'callback',{@init_push_ok_strln,h_init,h_main})
%button 10
set(h_init(1).button_auto_draw,'callback',{@init_push_auto_draw,h_init})
%button 11
set(h_init(1).button_readbf,'callback',{@init_push_readbf,h_init})
%button 12
set(h_init(1).button_crop_all,'callback',{@init_push_crop_all,h_init})

%assign callbacks to edit fields
set(h_init(1).edit_fps,'callback',{@init_update_field,h_init,'fps'})
set(h_init(1).edit_conversion,'callback',{@init_update_field,h_init,'conversion'})
set(h_init(1).edit_nframes,'callback',{@init_update_field,h_init,'nframes'})
set(h_init(1).edit_cellname,'callback',{@init_update_field,h_init,'cellname'})
set(h_init(1).edit_croplength,'callback',{@init_update_field,h_init,'croplength'})
set(h_init(1).edit_cropwidth,'callback',{@init_update_field,h_init,'cropwidth'})
set(h_init(1).edit_youngs,'callback',{@init_update_field,h_init,'youngs'})
set(h_init(1).edit_poisson,'callback',{@init_update_field,h_init,'poisson'})
set(h_init(1).edit_area_factor,'callback',{@init_update_field,h_init,'area_factor'})
set(h_init(1).edit_scale_factor,'callback',{@init_update_field,h_init,'scale_factor'})

%assign callbacks to checkbox fields
set(h_init(1).checkbox_rotate,'callback',{@init_update_field,h_init,'rotate'})
set(h_init(1).checkbox_bin,'callback',{@init_update_bin,h_init});

%if there are already files on the stack, make the other panels visible too
%and show parameters
if ~isempty(getappdata(0,'tfm_init_user_filenamestack'))                          %files on stack
    %load shared parameters
    tfm_init_user_counter=getappdata(0,'tfm_init_user_counter');                %current video number
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');                  %number of videos
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');          %conversion factor: 1px=?micron
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');            %framerate
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');                %number of frames
    tfm_init_user_Nframes_bf=getappdata(0,'tfm_init_user_Nframes_bf');                %number of frames
    tfm_init_user_imsize_m=getappdata(0,'tfm_init_user_imsize_m');
    tfm_init_user_imsize_n=getappdata(0,'tfm_init_user_imsize_n');
    tfm_init_user_cellname=getappdata(0,'tfm_init_user_cellname');              %cellname
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');    %filestack
    tfm_init_user_bf_filenamestack=getappdata(0,'tfm_init_user_bf_filenamestack');
    tfm_init_user_vidext=getappdata(0,'tfm_init_user_vidext');                  %video extension
    tfm_init_user_bf_vidext=getappdata(0,'tfm_init_user_bf_vidext');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');  %preview frame for each video
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_croplength=getappdata(0,'tfm_init_user_croplength');
    tfm_init_user_cropwidth=getappdata(0,'tfm_init_user_cropwidth');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    
    %change display strings and values
    %put video files into listbox
    set(h_init(1).listbox_display,'String',tfm_init_user_filenamestack);
    %select item in listbox
    set(h_init(1).listbox_display,'Value',tfm_init_user_counter);
    
    %display 1st frame of new video
    axes(h_init(1).axes_curr);
    imshow(tfm_init_user_preview_frame1{tfm_init_user_counter});hold on;
    plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
    plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
    plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
    hold off;
    
    %     %display 1st bf frame
    %     axes(h_init(1).axes_bf);
    %     imshow(tfm_init_user_bf_preview_frame1{tfm_init_user_counter});hold on;
    %     plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
    %     plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
    %     plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
    %     hold off;
    
    %check if bf stack is empty
    if isempty(tfm_init_user_bf_filenamestack)
        axes(h_init(1).axes_bf)
        imshow([]);
        set(h_init(1).axes_bf,'visible','off');
    else
        set(h_init(1).axes_bf,'visible','on');
        axes(h_init(1).axes_bf);
        imshow(tfm_init_user_bf_preview_frame1{1});hold on;
        plot(tfm_init_user_outline1x{1},tfm_init_user_outline1y{1},'r','LineWidth',2);
        plot(tfm_init_user_outline2x{1},tfm_init_user_outline2y{1},'b','LineWidth',2);
        plot(tfm_init_user_outline3x{1},tfm_init_user_outline3y{1},'g','LineWidth',2);
        hold off;
        set(h_init(1).text_bf_whichvidname,'String',tfm_init_user_bf_filenamestack{1,1});
    end
    
    %display new settings
    set(h_init(1).edit_fps,'String',num2str(tfm_init_user_framerate{tfm_init_user_counter}));                               %framerate
    set(h_init(1).edit_conversion,'String',num2str(tfm_init_user_conversion{tfm_init_user_counter}));                       %conversion
    set(h_init(1).edit_nframes,'String',num2str(tfm_init_user_Nframes{tfm_init_user_counter}));                             %number of frames
    set(h_init(1).edit_cellname,'String',tfm_init_user_cellname{tfm_init_user_counter});                                    %cellname
    set(h_init(1).text_whichvidname,'String',[tfm_init_user_filenamestack{1,tfm_init_user_counter},' (showing 1st frame)']);%name of video
    %set(h_init(1).text_bf_whichvidname,'String',[tfm_init_user_bf_filenamestack{1,tfm_init_user_counter}]);
    set(h_init(1).text_whichvid,'String',[num2str(tfm_init_user_counter),'/',num2str(tfm_init_user_Nfiles)]);               %which video (i/N)
    set(h_init(1).edit_area_factor,'String',num2str(tfm_init_user_area_factor));                                            %mask parameters
    set(h_init(1).edit_scale_factor,'String',num2str(tfm_init_user_scale_factor{tfm_init_user_counter}));
    set(h_init(1).edit_croplength,'String',num2str(tfm_init_user_croplength));
    set(h_init(1).edit_cropwidth,'String',num2str(tfm_init_user_cropwidth));
    set(h_init(1).edit_youngs,'String',num2str(tfm_init_user_E{tfm_init_user_counter}));
    set(h_init(1).edit_poisson,'String',num2str(tfm_init_user_nu{tfm_init_user_counter}));
    
    
    %set/change properties
    %if tif or avi or folder, user needs to edit edits; disable nframes
    if strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'.tif') || strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'.avi') || strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'none')
        set(h_init(1).edit_fps,'Enable','on');          %enable framerate edit
        set(h_init(1).edit_conversion,'Enable','on');   %enable conversion edit
    else
        set(h_init(1).edit_fps,'Enable','off');         %disable framerate edit
        set(h_init(1).edit_conversion,'Enable','off');  %disable conversion edit
    end
    set(h_init(1).edit_nframes,'Enable','off');         %disable Nframes edit
    %forwards and backwards buttons enable/disable
    if tfm_init_user_counter==tfm_init_user_Nfiles      %if current vid is the last on stack
        set(h_init(1).button_forwards,'Enable','off');  %disable forwards
    else
        set(h_init(1).button_forwards,'Enable','on');   %enable forwards
    end
    if tfm_init_user_counter==1                         %if current vid is the first on stack
        set(h_init(1).button_backwards,'Enable','off'); %disable backwards
    else
        set(h_init(1).button_backwards,'Enable','on');  %enable backwards
    end
    %panels, button, listbox
    set(h_init(1).panel_vid,'Visible','on');        %show video panel
    set(h_init(1).subpanel_vid,'Visible','on');        %show video panel
    set(h_init(1).panel_list,'Visible','on');       %show list panel
    set(h_init(1).button_ok,'Visible','on');        %show button panel
    set(h_init(1).button_ok_strln,'Visible','on');        %show button panel
    set(h_init(1).checkbox_bleach,'Visible','on');        %show bleach checkbox
    set(h_init(1).checkbox_denoise,'Visible','on');        %show noise checkbox
    set(h_init(1).checkbox_trim,'Visible','on');
    set(h_init(1).checkbox_rotate,'Visible','on');
    set(h_init(1).checkbox_cropmask,'Visible','on');
    set(h_init(1).checkbox_crop,'Visible','on');
    set(h_init(1).checkbox_bin,'Visible','on');
    set(h_init(1).menu_bin,'Visible','on');
    set(h_init(1).listbox_display,'Enable','off');  %disable listbox editing
else %turn off panels
    set(h_init(1).panel_vid,'Visible','off');       %hide video panel
    set(h_init(1).subpanel_vid,'Visible','off');       %hide video panel
    set(h_init(1).panel_list,'Visible','off');      %hide list panel
    set(h_init(1).button_ok,'Visible','off');       %hide ok button
    set(h_init(1).button_ok_strln,'Visible','off');       %hide ok button
    set(h_init(1).checkbox_bleach,'Visible','off');        %hide bleach checkbox
    set(h_init(1).checkbox_denoise,'Visible','off');        %hide noise checkbox
    set(h_init(1).checkbox_rotate,'Visible','off');
    set(h_init(1).checkbox_cropmask,'Visible','off');
    set(h_init(1).checkbox_crop,'Visible','off');
    set(h_init(1).checkbox_bin,'Visible','off');
    set(h_init(1).menu_bin,'Visible','off');
end

tfm_init_user_strln = false;
setappdata(0,'tfm_init_user_strln',tfm_init_user_strln);

%make figure visible
set(h_init(1).fig,'visible','on');

%move main window to the side
movegui(h_main(1).fig,'west')

%profile viewer
%userTiming= getappdata(0,'userTiming');
%userTiming.init{1} = tic;
%setappdata(0,'userTiming',userTiming);

function init_push_readvid(hObject, eventdata, h_init)

%profile on

%reads in a series of videos

%disable figure during calculation
enableDisableFig(h_init(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_init(1).fig,1));

%error catching loop
try
    %load what shared para we need
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_bf_filenamestack=getappdata(0,'tfm_init_user_bf_filenamestack');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_bf_pathnamestack=getappdata(0,'tfm_init_user_bf_pathnamestack');
    tfm_init_user_vidext=getappdata(0,'tfm_init_user_vidext');
    tfm_init_user_bf_vidext=getappdata(0,'tfm_init_user_bf_vidext');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_Nframes_bf=getappdata(0,'tfm_init_user_Nframes_bf');
    tfm_init_user_imsize_m=getappdata(0,'tfm_init_user_imsize_m');
    tfm_init_user_imsize_n=getappdata(0,'tfm_init_user_imsize_n');
    tfm_init_user_cellname=getappdata(0,'tfm_init_user_cellname');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    tfm_init_user_major=getappdata(0,'tfm_init_user_major');
    tfm_init_user_minor=getappdata(0,'tfm_init_user_minor');
    tfm_init_user_angle=getappdata(0,'tfm_init_user_angle');
    tfm_init_user_ratio=getappdata(0,'tfm_init_user_ratio');
    tfm_init_user_area=getappdata(0,'tfm_init_user_area');
    tfm_init_user_area_ellipse=getappdata(0,'tfm_init_user_area_ellipse');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary3=getappdata(0,'tfm_init_user_binary3');
    tfm_init_user_rotate=getappdata(0,'tfm_init_user_rotate');
    multichannelczi=getappdata(0,'multichannelczi');
    
    
    if isempty(tfm_init_user_pathnamestack)
        tfm_init_user_pathnamestack{1} = cd;
    end
    
    %load video files: filename: 1xN cell w. strings; pathname string
    [filename,pathname] = uigetfile({'*.czi';'*.tif';'*.avi'},'Select Beads videos',tfm_init_user_pathnamestack{1},'MultiSelect','on');
    %really a file or did user press cancel?
    if isequal(filename,0)
        return;
    end
    filename = cellstr(filename);
    
    %look if there already files on the image stack
    Nfiles0=size(tfm_init_user_filenamestack,2);
    %     Nfiles0_bf=size(tfm_init_user_bf_filenamestack,2);
    
    %add new files and paths to stacks
    for i=1:size(filename,2)
        [~,name,ext]=fileparts(strcat(pathname,filename{1,i}));
        tfm_init_user_filenamestack{1,Nfiles0+i}=name;
        tfm_init_user_pathnamestack{1,Nfiles0+i}=pathname;
        tfm_init_user_vidext{1,Nfiles0+i}=ext;
        tfm_init_user_rotate(Nfiles0+i)=true;
    end
    
    %put video files into listbox
    set(h_init(1).listbox_display,'String',tfm_init_user_filenamestack);
    
    %new number of files
    tfm_init_user_Nfiles=size(tfm_init_user_filenamestack,2);
    
    for j=1:size(filename,2)
        %create folder for saving the stuff
        if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,Nfiles0+j}], 'dir'),7)
            rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,Nfiles0+j}],'s')
        end
        mkdir(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,Nfiles0+j}])
    end
    
    % initiate mask counters
    mask_found = zeros(1,tfm_init_user_Nfiles);
    mask_count = 0;
    
    % check for masks
    for ivid = 1:tfm_init_user_Nfiles
        if isequal(exist([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'/Mask/',tfm_init_user_filenamestack{ivid},'_mask.mat'],'file'),2)
            mask_found(ivid) = 1;
            mask_count = mask_count+1;
        end
    end
    
    % prompt user to use masks
    if mask_count >= 1
        % open dialog window
        answer = questdlg([num2str(mask_count),'/',num2str(tfm_init_user_Nfiles),' pre-drawn masks were detected in the image folders. Do you wish to use these masks?'],'Masks Detected','Yes','No','No');
    else
        answer = 'No';
    end
    
    % prompt user to select channels
    if strcmp(tfm_init_user_vidext{1,Nfiles0+1},'.czi')
        %use bioformats for import
        [~,reader]=evalc('bfGetReader([tfm_init_user_pathnamestack{1,Nfiles0+1},tfm_init_user_filenamestack{1,Nfiles0+1},tfm_init_user_vidext{1,Nfiles0+1}]);');
        
        omeMeta = reader.getMetadataStore();
        Nchannels = omeMeta.getChannelCount(0);
        if Nchannels > 1
            multichannelczi = true;
        else
            multichannelczi = false;
        end
        if multichannelczi
            figuresize=[300, 80*Nchannels];
            screensize=get(0,'ScreenSize');
            xpos = ceil((screensize(3)-figuresize(2))/2);
            ypos = ceil((screensize(4)-figuresize(1))/2);
            pcolor = [.2 .2 .2];
            ptcolor = [1 1 1];
            bcolor = [.3 .3 .3];
            btcolor = [1 1 1];
            %create figure
            selectChannel.fig=figure(...
                'position',[xpos, ypos, figuresize(1), figuresize(2)],...
                'units','pixels',...
                'renderer','OpenGL',...
                'MenuBar','none',...
                'PaperPositionMode','auto',...
                'Name','Select Channel',...
                'NumberTitle','off',...
                'Resize','off',...
                'Color',pcolor,...
                'Visible','off');
            selectChannel.ok_button = uicontrol('Parent',selectChannel.fig,'style','pushbutton','Position',[245 5 50 20],'string','OK');
            blockheight = 0.2;
            blocklength = 0.1;
            textheight = 0.05;
            textlength = 0.5;
            labellength = 0.15;
            buttonspace = 60;
            vspace=(1-Nchannels*blockheight)/(Nchannels+1);
            vspace_pixels = (figuresize(2)-Nchannels*buttonspace)/(Nchannels+1);
            TFM_buttons = cell(Nchannels,1);
            BF_buttons = cell(Nchannels,1);
            TFM_bg = uibuttongroup('Visible', 'on','Position',[0.02+blocklength+0.01+textlength+0.01 vspace labellength Nchannels*blockheight+(Nchannels+1)*vspace-0.2],'ForegroundColor',ptcolor,'BackgroundColor',pcolor,'BorderType','none');
            BF_bg = uibuttongroup('Visible', 'on','Position',[0.02+blocklength+0.01+textlength+0.01+labellength+0.01 vspace labellength Nchannels*blockheight+(Nchannels+1)*vspace-0.2],'ForegroundColor',ptcolor,'BackgroundColor',pcolor,'BorderType','none');
            for i = 0:Nchannels-1
                cur_ax = axes('Parent', selectChannel.fig, 'Position', [0.02 i*blockheight+(i+1)*vspace blocklength blockheight]);
                set(cur_ax, 'visible', 'off');
                cNum = int8(i);
                channelColor = omeMeta.getChannelColor(0,cNum);
                channelEmission = omeMeta.getChannelEmissionWavelength(0,cNum);
                channelExcitation = omeMeta.getChannelExcitationWavelength(0,cNum);
                rectangle(cur_ax, 'Position',[0 0 1 1],'FaceColor',[channelColor.getRed()/255 channelColor.getGreen()/255 channelColor.getBlue()/255]);
                str1 = 'Excitation (nm): ' + string(channelEmission.value);
                str2 = 'Emission (nm): ' + string(channelExcitation.value);
                annotation('textbox',[0.02+blocklength+0.01 i*blockheight+(i+1)*vspace+blockheight-textheight textlength textheight], 'String', str1, 'Color',ptcolor, 'FitBoxToText', 'on', 'LineStyle', 'none');
                annotation('textbox',[0.02+blocklength+0.01 i*blockheight+(i+1)*vspace+textheight textlength textheight], 'String', str2, 'Color',ptcolor, 'FitBoxToText', 'on', 'LineStyle', 'none');
                TFM_buttons{i+1,1} = uicontrol(TFM_bg,'Style','radiobutton','Position',[15 i*buttonspace+(i+1)*vspace_pixels-10 20 20],'HandleVisibility','on','BackgroundColor',pcolor);
                BF_buttons{i+1,1} = uicontrol(BF_bg,'Style','radiobutton','Position',[15 i*buttonspace+(i+1)*vspace_pixels-10 20 20],'HandleVisibility','on','BackgroundColor',pcolor);
            end
            TFM_bg.SelectedObject=[];
            BF_bg.SelectedObject=[];
            set(selectChannel.ok_button,'callback',{@closeFig,selectChannel,Nchannels,TFM_buttons, BF_buttons})
            selectChannel.text_tfm = uicontrol('Parent',selectChannel.fig,'style','text','position',[200,80*Nchannels-25,30,20],'string','TFM','HorizontalAlignment','center','ForegroundColor',ptcolor,'BackgroundColor',pcolor);
            selectChannel.text_bf = uicontrol('Parent',selectChannel.fig,'style','text','position',[250,80*Nchannels-25,30,20],'string','BF','HorizontalAlignment','center','ForegroundColor',ptcolor,'BackgroundColor',pcolor);
            
            selectChannel.fig.Visible='on';
            waitfor(selectChannel.fig);
        end
    end
    %loop over vids and extract first frame data
    for j = 1:size(filename,2)
        if strcmp(tfm_init_user_vidext{1,Nfiles0+j},'.czi')
            TFMChannel = getappdata(0,'TFMChannel');
            BFChannel = getappdata(0,'BFChannel');
            
            %use bioformats for import
            [~,reader]=evalc('bfGetReader([tfm_init_user_pathnamestack{1,Nfiles0+j},tfm_init_user_filenamestack{1,Nfiles0+j},tfm_init_user_vidext{1,Nfiles0+j}]);');
            omeMeta = reader.getMetadataStore();
            
            N=omeMeta.getPlaneCount(0)/Nchannels; %number of frames
            m = omeMeta.getPixelsSizeY(0).getValue(); %height in pixels
            n = omeMeta.getPixelsSizeX(0).getValue(); %width in pixels
            %save display image in variable
            display_frame = TFMChannel;
            if get(h_init(1).checkbox_trim, 'value')
                display_frame = display_frame + Nchannels;
            end
            [~,image]=evalc('bfGetPlane(reader, display_frame);');
            %convert to grey
            if ndims(image) == 3
                image=rgb2gray(image);
            end
            image=normalise(image);
            image=im2uint8(image);
            
            %save 1st frame in display
            tfm_init_user_preview_frame1{Nfiles0+j}=normalise(image);
            
            %if BF channel was also included, also load BF first frame and set BF filename info
            if BFChannel <= Nchannels
                tfm_init_user_bf_pathnamestack{1,Nfiles0+j} = tfm_init_user_pathnamestack{1,Nfiles0+j};
                tfm_init_user_bf_filenamestack{1,Nfiles0+j} = tfm_init_user_filenamestack{1,Nfiles0+j};
                tfm_init_user_bf_vidext{1,Nfiles0+j} = tfm_init_user_vidext{1,Nfiles0+j};
                display_frame_bf = BFChannel;
                if get(h_init(1).checkbox_trim, 'value')
                    display_frame_bf = display_frame_bf + Nchannels;
                end
                [~,image]=evalc('bfGetPlane(reader, display_frame_bf);');
                %convert to grey
                if ndims(image) == 3
                    image=rgb2gray(image);
                end
                image=normalise(image);
                image=im2uint8(image);
                
                %save 1st frame in display
                tfm_init_user_bf_preview_frame1{Nfiles0+j}=normalise(image);
                tfm_init_user_Nframes_bf{Nfiles0+j}=N;
                if get(h_init(1).checkbox_trim, 'value')
                    tfm_init_user_Nframes_bf{Nfiles0+j}=N-1;
                end
            end
            
            
        elseif strcmp(tfm_init_user_vidext{1,Nfiles0+j},'.tif')
            if exist('multichannelczi','var') == 0
                multichannelczi = false;
            end
            InfoImage=imfinfo([tfm_init_user_pathnamestack{1,Nfiles0+j},tfm_init_user_filenamestack{1,Nfiles0+j},tfm_init_user_vidext{1,Nfiles0+j}]);
            N=length(InfoImage);
            %bit=InfoImage.BitDepth;
            TifLink = Tiff([tfm_init_user_pathnamestack{1,Nfiles0+j},tfm_init_user_filenamestack{1,Nfiles0+j},tfm_init_user_vidext{1,Nfiles0+j}], 'r');
            
            % initialize image stack
            display_image = 1;
            if get(h_init(1).checkbox_trim, 'value')
                display_image = 2; %read past first frame
            end
            TifLink.setDirectory(display_image);
            image1 = TifLink.read();
            
            m = size(image1,1);
            n = size(image1,2);
            
            %convert to grey
            if ndims(image1) == 3
                image1=rgb2gray(image1);
            end
            image1=normalise(image1);
            image1=im2uint8(image1);
            
            TifLink.close();
            
            %save 1st frame in display
            tfm_init_user_preview_frame1{Nfiles0+j}=normalise(image1);
        elseif strcmp(tfm_init_user_vidext{1,Nfiles0+j},'.avi')
            if exist('multichannelczi','var') == 0
                multichannelczi = false;
            end
            
            videoObj = VideoReader([tfm_init_user_pathnamestack{1,Nfiles0+j},tfm_init_user_filenamestack{1,Nfiles0+j},tfm_init_user_vidext{1,Nfiles0+j}]);
            N = videoObj.NumberOfFrames;
            
            %initialize image stack
            display_frame = 1;
            if get(h_init(1).checkbox_trim, 'value')
                display_frame = 2; %read past first frame
            end
            image1 = read(videoObj,display_frame);
            m = size(image1,1);
            n = size(image1,2);
            
            %convert to grey
            if ndims(image1) == 3
                image1=rgb2gray(image1);
            end
            image1=normalise(image1);
            image1=im2uint8(image1);
            
            %save 1st frame in display
            tfm_init_user_preview_frame1{Nfiles0+j}=normalise(image1);
        end
        if get(h_init(1).checkbox_trim, 'value')
            N = N-1;
        end
        %if czi: read metadata, else put the values to NaN;
        if strcmp(tfm_init_user_vidext{1,Nfiles0+j},'.czi')
            %conversion factor px-> um
            voxelSizeX = double(omeMeta.getPixelsPhysicalSizeX(0).value()); % in ?m %prev: getValue, no double
            
            %for later use:
            tfm_init_user_conversion{Nfiles0+j}=voxelSizeX;
            tfm_init_user_framerate{Nfiles0+j}=0;
            tfm_init_user_Nframes{Nfiles0+j}=N;
            
            tfm_init_user_imsize_m{Nfiles0+j}=m;
            tfm_init_user_imsize_n{Nfiles0+j}=n;
            tfm_init_user_cellname{Nfiles0+j}=['cell_',num2str(Nfiles0+1)];
            tfm_init_user_E{Nfiles0+j}=str2double('10e3');%default stiffness
            tfm_init_user_nu{Nfiles0+j}=0.45;
            tfm_init_user_scale_factor{Nfiles0+j}=0.75;
            
            %if tiff or avi
        elseif strcmp(tfm_init_user_vidext{1,Nfiles0+j},'.tif') || strcmp(tfm_init_user_vidext{1,Nfiles0+j},'.avi')
            tfm_init_user_conversion{Nfiles0+j}=0.27;%default conversion pixel to micron
            tfm_init_user_framerate{Nfiles0+j}=30;%default frame rate
            tfm_init_user_Nframes{Nfiles0+j}=N;
            tfm_init_user_imsize_m{Nfiles0+j}=m;
            tfm_init_user_imsize_n{Nfiles0+j}=n;
            tfm_init_user_cellname{Nfiles0+j}=['cell_',num2str(Nfiles0+1)];
            tfm_init_user_E{Nfiles0+j}=str2double('10e3');%default stiffness
            tfm_init_user_nu{Nfiles0+j}=0.45;%default Poisson coefficient
            tfm_init_user_scale_factor{Nfiles0+j}=0.75;%default cell outline ellipse length-with scaling ratio
        end
        
        %initialize cell dimensions, area
        tfm_init_user_major(Nfiles0+j)=NaN;
        tfm_init_user_minor(Nfiles0+j)=NaN;
        tfm_init_user_angle(Nfiles0+j)=NaN;
        tfm_init_user_ratio(Nfiles0+j)=NaN;
        tfm_init_user_area(Nfiles0+j)=NaN;
        tfm_init_user_area_ellipse(Nfiles0+j)=NaN;
        
        %set initial outlines and binaries to []
        tfm_init_user_outline1x{Nfiles0+j}=[];
        tfm_init_user_outline1y{Nfiles0+j}=[];
        tfm_init_user_outline2x{Nfiles0+j}=[];
        tfm_init_user_outline2y{Nfiles0+j}=[];
        tfm_init_user_outline3x{Nfiles0+j}=[];
        tfm_init_user_outline3y{Nfiles0+j}=[];
        tfm_init_user_binary1{Nfiles0+j}=[];
        tfm_init_user_binary3{Nfiles0+j}=[];
    end
    %set area factor to 3
    if isempty(tfm_init_user_area_factor)
        tfm_init_user_area_factor=3;
    end
    
    %turn on panels
    set(h_init(1).panel_list,'Visible','on');
    set(h_init(1).panel_vid,'Visible','on');
    set(h_init(1).subpanel_vid,'Visible','on');
    set(h_init(1).button_ok,'Visible','on');
    set(h_init(1).button_ok_strln,'Visible','on');
    set(h_init(1).checkbox_bleach,'Visible','on');        %show bleach checkbox
    set(h_init(1).checkbox_denoise,'Visible','on');        %show noise checkbox
    set(h_init(1).checkbox_trim,'Visible','on');
    set(h_init(1).checkbox_rotate,'Visible','on');
    set(h_init(1).checkbox_cropmask,'Visible','on');
    set(h_init(1).checkbox_crop,'Visible','on');
    set(h_init(1).checkbox_bin,'Visible','on');
    set(h_init(1).menu_bin,'Visible','on');
    
    %set para in boxes for 1st video: depending on file extension: enable
    %editing of boxes for fps, conversion
    set(h_init(1).edit_fps,'String',num2str(tfm_init_user_framerate{1}));
    set(h_init(1).edit_conversion,'String',num2str(tfm_init_user_conversion{1}));
    if strcmp(tfm_init_user_vidext{1,1},'.tif') || strcmp(tfm_init_user_vidext{1,1},'.avi') || strcmp(tfm_init_user_vidext{1,1},'none')
        set(h_init(1).edit_fps,'Enable','on');
        set(h_init(1).edit_conversion,'Enable','on');
    else
        set(h_init(1).edit_fps,'Enable','off');
        set(h_init(1).edit_conversion,'Enable','off');
    end
    
    set(h_init(1).edit_nframes,'String',num2str(tfm_init_user_Nframes{1}));
    set(h_init(1).edit_nframes,'Enable','off');
    
    set(h_init(1).edit_cellname,'String',tfm_init_user_cellname{1});
    set(h_init(1).edit_area_factor,'String',num2str(tfm_init_user_area_factor));
    set(h_init(1).edit_scale_factor,'String',num2str(tfm_init_user_scale_factor{1}));
    set(h_init(1).text_whichvidname,'String',[tfm_init_user_filenamestack{1,1},' (showing 1st frame)']);
    
    %set default crop parameters here
    tfm_init_user_croplength=200;
    tfm_init_user_cropwidth=85;
    
    set(h_init(1).edit_croplength,'String',num2str(tfm_init_user_croplength));
    set(h_init(1).edit_cropwidth,'String',num2str(tfm_init_user_cropwidth));
    set(h_init(1).edit_youngs,'String',num2str(tfm_init_user_E{1}));
    set(h_init(1).edit_poisson,'String',num2str(tfm_init_user_nu{1}));
    
    % check for previous mask
    if strcmp(answer,'Yes')
        parfor ivid = 1:tfm_init_user_Nfiles
            % if mask exists
            if mask_found(ivid) == 1
                % load masks and draw outlines
                s = load([tfm_init_user_pathnamestack{1,ivid},'/',tfm_init_user_filenamestack{1,ivid},'/Mask/',tfm_init_user_filenamestack{ivid},'_mask.mat']);
                tfm_init_user_binary1{ivid} = s.mask;
                
                % draw outlines
                BWoutline=bwboundaries(tfm_init_user_binary1{ivid});
                if ~isempty(BWoutline)
                    tfm_init_user_outline1x{ivid}=BWoutline{1}(:,2);
                    tfm_init_user_outline1y{ivid}=BWoutline{1}(:,1);
                else
                    tfm_init_user_outline1x{ivid}=[];
                    tfm_init_user_outline1y{ivid}=[];
                end
                
                s = regionprops(tfm_init_user_binary1{ivid}, 'Orientation', 'MajorAxisLength', ...
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
                
                %calculate new ellipse
                an=tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*a;
                bn=1/tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*b;
                xyn = [an*cosphi; bn*sinphi];
                xyn = R*xyn;
                xn = xyn(1,:) + xbar;
                yn = xyn(2,:) + ybar;
                
                %save dimensions
                tfm_init_user_major(ivid)=2*a;
                tfm_init_user_minor(ivid)=2*b;
                tfm_init_user_ratio(ivid)=a/(b+eps);
                tfm_init_user_angle(ivid)=s(1).Orientation;
                tfm_init_user_area(ivid)=s(1).Area;
                tfm_init_user_area_ellipse(ivid)=an*bn*pi;
                
                %save outlines
                tfm_init_user_outline2x{ivid}=xn;
                tfm_init_user_outline2y{ivid}=yn;
            end
        end
    end
    
    %set frame1 of 1st video
    axes(h_init(1).axes_curr);
    imshow(tfm_init_user_preview_frame1{1});hold on;
    plot(tfm_init_user_outline1x{1},tfm_init_user_outline1y{1},'r','LineWidth',2);
    plot(tfm_init_user_outline2x{1},tfm_init_user_outline2y{1},'b','LineWidth',2);
    plot(tfm_init_user_outline3x{1},tfm_init_user_outline3y{1},'g','LineWidth',2);
    hold off;
    
    %set frame1 of bf video
    %check if bf stack is empty
    if isempty(tfm_init_user_bf_filenamestack)
        axes(h_init(1).axes_bf)
        imshow([]);
        set(h_init(1).axes_bf,'visible','off');
    else
        set(h_init(1).axes_bf,'visible','on');
        axes(h_init(1).axes_bf);
        imshow(tfm_init_user_bf_preview_frame1{1});hold on;
        plot(tfm_init_user_outline1x{1},tfm_init_user_outline1y{1},'r','LineWidth',2);
        plot(tfm_init_user_outline2x{1},tfm_init_user_outline2y{1},'b','LineWidth',2);
        plot(tfm_init_user_outline3x{1},tfm_init_user_outline3y{1},'g','LineWidth',2);
        hold off;
        set(h_init(1).text_bf_whichvidname,'String',tfm_init_user_bf_filenamestack{1,1});
    end
    
    %select item in listbox
    set(h_init(1).listbox_display,'Value',1);
    
    %update text (x/N)
    set(h_init(1).text_whichvid,'String',[num2str(1),'/',num2str(tfm_init_user_Nfiles)]);
    
    
    %forwards and backwards buttons enable/disable
    if 1==tfm_init_user_Nfiles %if current vid is the last on stack
        set(h_init(1).button_forwards,'Enable','off');  %disable forwards
    else
        set(h_init(1).button_forwards,'Enable','on');   %enable forwards
    end                     %if current vid is the first on stack
    set(h_init(1).button_backwards,'Enable','off'); %disable backwards
    
    %disable bf plot if no videos loaded
    if isempty(tfm_init_user_bf_filenamestack)
        set(h_init(1).axes_bf,'Visible','off');
    else
        set(h_init(1).axes_bf,'Visible','on');
    end
    
    %initiate counter for going through all videos
    tfm_init_user_counter=1;
    
    %store everything for shared use
    setappdata(0,'tfm_init_user_filenamestack',tfm_init_user_filenamestack);
    setappdata(0,'tfm_init_user_bf_filenamestack',tfm_init_user_bf_filenamestack);
    setappdata(0,'tfm_init_user_pathnamestack',tfm_init_user_pathnamestack);
    setappdata(0,'tfm_init_user_bf_pathnamestack',tfm_init_user_bf_pathnamestack);
    setappdata(0,'tfm_init_user_vidext',tfm_init_user_vidext);
    setappdata(0,'tfm_init_user_bf_vidext',tfm_init_user_bf_vidext);
    setappdata(0,'tfm_init_user_counter',tfm_init_user_counter);
    setappdata(0,'tfm_init_user_Nfiles',tfm_init_user_Nfiles);
    setappdata(0,'tfm_init_user_cellname',tfm_init_user_cellname);
    setappdata(0,'tfm_init_user_Nframes',tfm_init_user_Nframes);
    setappdata(0,'tfm_init_user_Nframes_bf',tfm_init_user_Nframes_bf);
    setappdata(0,'tfm_init_user_imsize_m',tfm_init_user_imsize_m);
    setappdata(0,'tfm_init_user_imsize_n',tfm_init_user_imsize_n);
    setappdata(0,'tfm_init_user_conversion',tfm_init_user_conversion);
    setappdata(0,'tfm_init_user_framerate',tfm_init_user_framerate);
    setappdata(0,'tfm_init_user_area_factor',tfm_init_user_area_factor);
    setappdata(0,'tfm_init_user_scale_factor',tfm_init_user_scale_factor);
    setappdata(0,'tfm_init_user_croplength',tfm_init_user_croplength);
    setappdata(0,'tfm_init_user_cropwidth',tfm_init_user_cropwidth);
    setappdata(0,'tfm_init_user_E',tfm_init_user_E);
    setappdata(0,'tfm_init_user_nu',tfm_init_user_nu);
    setappdata(0,'tfm_init_user_preview_frame1',tfm_init_user_preview_frame1);
    setappdata(0,'tfm_init_user_bf_preview_frame1',tfm_init_user_bf_preview_frame1);
    setappdata(0,'tfm_init_user_major',tfm_init_user_major);
    setappdata(0,'tfm_init_user_minor',tfm_init_user_minor);
    setappdata(0,'tfm_init_user_angle',tfm_init_user_angle);
    setappdata(0,'tfm_init_user_ratio',tfm_init_user_ratio);
    setappdata(0,'tfm_init_user_area',tfm_init_user_area);
    setappdata(0,'tfm_init_user_area_ellipse',tfm_init_user_area_ellipse);
    setappdata(0,'tfm_init_user_binary1',tfm_init_user_binary1);
    setappdata(0,'tfm_init_user_binary3',tfm_init_user_binary3);
    setappdata(0,'tfm_init_user_outline1x',tfm_init_user_outline1x);
    setappdata(0,'tfm_init_user_outline1y',tfm_init_user_outline1y);
    setappdata(0,'tfm_init_user_outline2x',tfm_init_user_outline2x);
    setappdata(0,'tfm_init_user_outline2y',tfm_init_user_outline2y);
    setappdata(0,'tfm_init_user_outline3x',tfm_init_user_outline3x);
    setappdata(0,'tfm_init_user_outline3y',tfm_init_user_outline3y);
    setappdata(0,'tfm_init_user_rotate',tfm_init_user_rotate);
    setappdata(0,'multichannelczi',multichannelczi);
    
    %update statusbar
    sb=statusbar(h_init(1).fig,'Import - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %grey out back button
    set(h_init(1).button_backwards,'Enable','off');
    
    %grey out listbox
    set(h_init(1).listbox_display,'Enable','off');
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
    
    %if there is an error, and there are no files on the stack, do not
    %display anything
    if isempty(getappdata(0,'tfm_init_user_filenamestack'))
        set(h_init(1).panel_vid,'Visible','off');
        set(h_init(1).subpanel_vid,'Visible','off');
        set(h_init(1).panel_list,'Visible','off');
        set(h_init(1).button_ok,'Visible','off');
        set(h_init(1).button_ok_strln,'Visible','off');
        set(h_init(1).checkbox_bleach,'Visible','off');        %hide bleach checkbox
        set(h_init(1).checkbox_denoise,'Visible','off');        %hide noise checkbox
        set(h_init(1).checkbox_trim,'Visible','off');
        set(h_init(1).checkbox_crop,'Visible','off');
        set(h_init(1).checkbox_bin,'Visible','off');
        set(h_init(1).menu_bin,'Visible','off');
    end
    
    %profile viewer
    
    % send notif
    myMessage='Loading video finished';
    notif = getappdata(0,'notif');
    if notif.on
        for i = size(notif.url)
            webwrite(notif.url{i},'value1',myMessage);
        end
    end
    
end

function closeFig(hObject, eventdata, selectChannel, Nchannels, TFM_buttons, bf_buttons)
%determine which channels have been selected
TFMChannel = 1;
for button = 1:Nchannels
    if(TFM_buttons{button,1}.Value == 1)
        break;
    else
        TFMChannel = TFMChannel + 1;
    end
end
BFChannel = 1;
for button = 1:Nchannels
    if(bf_buttons{button,1}.Value == 1)
        break;
    else
        BFChannel = BFChannel + 1;
    end
end
setappdata(0,'TFMChannel',TFMChannel);
setappdata(0,'BFChannel',BFChannel);
close(selectChannel.fig);

function init_push_readfolder(hObject, eventdata, h_init)
%disable figure during calculation
enableDisableFig(h_init(1).fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_init(1).fig,1));


%%error catching loop
try
    
    %load what shared para we need
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_vidext=getappdata(0,'tfm_init_user_vidext');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_Nframes_bf=getappdata(0,'tfm_init_user_Nframes_bf');
    tfm_init_user_imsize_m=getappdata(0,'tfm_init_user_imsize_m');
    tfm_init_user_imsize_n=getappdata(0,'tfm_init_user_imsize_n');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_init_user_cellname=getappdata(0,'tfm_init_user_cellname');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary3=getappdata(0,'tfm_init_user_binary3');
    tfm_init_user_rotate=getappdata(0,'tfm_init_user_rotate');
    
    %load image folder
    foldername = uigetdir;
    
    %really a folder or did user press cancel?
    if isequal(foldername,0)
        return;
    end
    
    
    %foldername = cellstr(foldername);
    
    %what to call this vid?
    name = inputdlg('How do you want to call this vid?');
    
    %look if there already files on the image stack
    Nfiles0=size(tfm_init_user_filenamestack,2);
    
    %add new files and paths to stacks
    tfm_init_user_filenamestack{1,Nfiles0+1}=name{1};
    tfm_init_user_pathnamestack{1,Nfiles0+1}=foldername;
    tfm_init_user_vidext{1,Nfiles0+1}='none';
    tfm_init_user_rotate(Nfiles0+1)=true;
    
    %put video files into listbox
    set(h_init(1).listbox_display,'String',tfm_init_user_filenamestack);
    
    %new number of files
    tfm_init_user_Nfiles=size(tfm_init_user_filenamestack,2);
    
    %update statusbar
    sb=statusbar(h_init(1).fig,'Importing... ');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    sb=statusbar(h_tfm(1).fig,['Calculating regularization: video ',num2str(current_vid),'/',num2str(tfm_init_user_Nfiles),'... ',num2str(floor(100*(current_vid-1)/tfm_init_user_Nfiles)), '%% done']);
    
    
    %create folder for saving the stuff
    if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,Nfiles0+1}], 'dir'),7)
        rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,Nfiles0+1}],'s')
    end
    mkdir(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,Nfiles0+1}])
    
    %number of files
    files = dir([foldername '/*.png']);
    N=length(files);
    
    % initialize image stack
    filename = [foldername '/' files(1).name];
    imagei = imread(filename);
    m = size(imagei,1);
    n = size(imagei,2);
    image_stack = zeros(m,n,N);
    
    for i = 1:N
        %update statusbar
        %sb=statusbar(h_init(1).fig,'Importing... ');
        sb=statusbar(h_init(1).fig,['Importing... video  ',num2str(i),'/',num2str(N),'... ',num2str(floor(100*(i-1)/h_init)), '%% done']);
        sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
        
        
        filename = [foldername '/' files(i).name];
        imagei=imread(filename);
        %convert to grey
        if ndims(imagei) == 3
            imagei=rgb2gray(imagei);
        end
        imagei=normalise(imagei);
        imagei = im2uint8(imagei);
        image_stack(:,:,i) = imagei;
        
    end
    %save to mat
    save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,Nfiles0+1},'/image_stack.mat'],'image_stack','-v7.3')
    
    %save preview of 1st frame in workspace for display
    s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,Nfiles0+1},'/image_stack.mat'],'image_stack');
    tfm_init_user_preview_frame1{Nfiles0+1}=normalise(s.image_stack(:,:,1));
    
    %save mask: initially all ones:
    %tfm_init_user_mask{Nfiles0+1}=ones(size(s.imagei,1),size(s.imagei,2));
    
    %metadata to NaN
    tfm_init_user_conversion{Nfiles0+1}=NaN;
    tfm_init_user_framerate{Nfiles0+1}=NaN;
    tfm_init_user_Nframes{Nfiles0+1}=N;
    tfm_init_user_imsize_m{Nfiles0+1}=m;
    tfm_init_user_imsize_n{Nfiles0+1}=n;
    tfm_init_user_cellname{Nfiles0+1}='cellname1';
    if isempty(tfm_init_user_area_factor)         tfm_init_user_area_factor=3;     end
    tfm_init_user_outline1x{Nfiles0+1}=NaN;
    tfm_init_user_outline1y{Nfiles0+1}=NaN;
    tfm_init_user_outline2x{Nfiles0+1}=NaN;
    tfm_init_user_outline2y{Nfiles0+1}=NaN;
    tfm_init_user_outline3x{Nfiles0+1}=NaN;
    tfm_init_user_outline3y{Nfiles0+1}=NaN;
    tfm_init_user_binary1{Nfiles0+1}=NaN;
    tfm_init_user_binary3{Nfiles0+1}=NaN;
    
    %update statusbar
    sb=statusbar(h_init(1).fig,'Import - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %turn on panels
    set(h_init(1).panel_list,'Visible','on');
    set(h_init(1).panel_vid,'Visible','on');
    set(h_init(1).subpanel_vid,'Visible','on');
    set(h_init(1).checkbox_bleach,'Visible','on');        %show bleach checkbox
    set(h_init(1).checkbox_denoise,'Visible','on');        %show noise checkbox
    set(h_init(1).checkbox_crop,'Visible','on');        %show noise checkbox
    set(h_init(1).checkbox_bin,'Visible','on');        %show noise checkbox
    set(h_init(1).menu_bin,'Visible','on');
    set(h_init(1).button_ok,'Visible','on');
    set(h_init(1).button_ok_strln,'Visible','on');
    
    %set para in boxes for 1st video
    %set para in boxes for 1st video: depending on file extension: enable
    %editing of boxes for fps, conversion
    set(h_init(1).edit_fps,'String',num2str(tfm_init_user_framerate{1}));
    set(h_init(1).edit_conversion,'String',num2str(tfm_init_user_conversion{1}));
    if strcmp(tfm_init_user_vidext{1,1},'.tif') || strcmp(tfm_init_user_vidext{1,1},'.avi') || strcmp(tfm_init_user_vidext{1,1},'none')
        set(h_init(1).edit_fps,'Enable','on');
        set(h_init(1).edit_conversion,'Enable','on');
    else
        set(h_init(1).edit_fps,'Enable','off');
        set(h_init(1).edit_conversion,'Enable','of');
    end
    set(h_init(1).edit_nframes,'String',num2str(tfm_init_user_Nframes{1}));
    set(h_init(1).edit_nframes,'Enable','off');
    
    set(h_init(1).edit_cellname,'String',tfm_init_user_cellname{1});
    set(h_init(1).edit_area_factor,'String',num2str(tfm_init_user_area_factor));
    set(h_init(1).text_whichvidname,'String',[tfm_init_user_filenamestack{1,1},' (showing 1st frame)']);
    set(h_init(1).text_bf_whichvidname,'String',[tfm_init_user_bf_filenamestack{1,1}]);
    
    %set frame1 of 1st video
    axes(h_init(1).axes_curr);
    imshow(tfm_init_user_preview_frame1{1});hold on;
    plot(tfm_init_user_outline1x{1},tfm_init_user_outline1y{1},'r','LineWidth',2);
    plot(tfm_init_user_outline2x{1},tfm_init_user_outline2y{1},'b','LineWidth',2);
    plot(tfm_init_user_outline3x{1},tfm_init_user_outline3y{1},'g','Linewidth',2);
    hold off;
    
    %update text (x/N)
    set(h_init(1).text_whichvid,'String',[num2str(1),'/',num2str(tfm_init_user_Nfiles)]);
    
    %if only one vid file: grey out forward button
    if tfm_init_user_Nfiles==1
        set(h_init(1).button_forwards,'Enable','off');
        %enable ok button for czi
        set(h_init(1).button_ok,'Enable','on');
        set(h_init(1).button_ok_strln,'Enable','on');
    else
        set(h_init(1).button_forwards,'Enable','on');
    end
    set(h_init(1).button_backwards,'Enable','off'); %disable backwards
    
    
    %initiate counter for going through all videos
    tfm_init_user_counter=1;
    
    %store everything for shared use
    setappdata(0,'tfm_init_user_filenamestack',tfm_init_user_filenamestack);
    setappdata(0,'tfm_init_user_pathnamestack',tfm_init_user_pathnamestack);
    setappdata(0,'tfm_init_user_vidext',tfm_init_user_vidext);
    setappdata(0,'tfm_init_user_counter',tfm_init_user_counter);
    setappdata(0,'tfm_init_user_Nfiles',tfm_init_user_Nfiles);
    setappdata(0,'tfm_init_user_Nframes',tfm_init_user_Nframes);
    setappdata(0,'tfm_init_user_Nframes_bf',tfm_init_user_Nframes_bf);
    setappdata(0,'tfm_init_user_imsize_m',tfm_init_user_imsize_m);
    setappdata(0,'tfm_init_user_imsize_n',tfm_init_user_imsize_n);
    setappdata(0,'tfm_init_user_cellname',tfm_init_user_cellname);
    setappdata(0,'tfm_init_user_conversion',tfm_init_user_conversion);
    setappdata(0,'tfm_init_user_area_factor',tfm_init_user_area_factor);
    setappdata(0,'tfm_init_user_framerate',tfm_init_user_framerate);
    setappdata(0,'tfm_init_user_preview_frame1',tfm_init_user_preview_frame1);
    setappdata(0,'tfm_init_user_binary1',tfm_init_user_binary1);
    setappdata(0,'tfm_init_user_binary3',tfm_init_user_binary3);
    setappdata(0,'tfm_init_user_outline1x',tfm_init_user_outline1x);
    setappdata(0,'tfm_init_user_outline1y',tfm_init_user_outline1y);
    setappdata(0,'tfm_init_user_outline2x',tfm_init_user_outline2x);
    setappdata(0,'tfm_init_user_outline2y',tfm_init_user_outline2y);
    setappdata(0,'tfm_init_user_outline3x',tfm_init_user_outline3x);
    setappdata(0,'tfm_init_user_outline3y',tfm_init_user_outline3y);
    setappdata(0,'tfm_init_user_rotate',tfm_init_user_rotate);
    
    %grey out back button
    set(h_init(1).button_backwards,'Enable','off');
    
    %grey out listbox
    set(h_init(1).listbox_display,'Enable','off');
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
    
    %if there is an error, and there are no files on the stack, do not
    %display anything
    if ~isempty(getappdata(0,'tfm_init_user_filenamestack'))
        %cancel grey out everything
        set(get(h_init(1).uipanel1,'Children'),'Enable','on');
        set(get(h_init(1).panel_list,'Children'),'Enable','on');
        set(h_init(1).text_whichvid,'Enable','on');
        set(h_init(1).text3,'Enable','on');
        set(h_init(1).text4,'Enable','on');
        set(h_init(1).text5,'Enable','on');
        set(h_init(1).text_whichvidname,'Enable','on');
        set(h_init(1).text_bf_whichvidname,'Enable','on');
        set(h_init(1).edit_fps,'Enable','on');
        set(h_init(1).edit_conversion,'Enable','on');
        set(h_init(1).edit_nframes,'Enable','on');
        
        %grey out listbox
        set(h_init(1).listbox_display,'Enable','off');
    else
        set(h_init(1).panel_list,'Visible','off');
        set(h_init(1).panel_vid,'Visible','off');
        set(h_init(1).subpanel_vid,'Visible','off');
        set(h_init(1).button_ok,'Enable','off');
        set(h_init(1).button_ok_strln,'Enable','off');
        set(h_init(1).checkbox_bleach,'Visible','off');        %hide bleach checkbox
        set(h_init(1).checkbox_denoise,'Visible','off');        %hide noise checkbox
        set(h_init(1).checkbox_crop,'Visible','off');        %hide noise checkbox
        set(h_init(1).checkbox_bin,'Visible','off');        %hide noise checkbox
        set(h_init(1).menu_bin,'Visible','off');
    end
end

function init_push_readbf(hObject, eventdata, h_init)

try
    %load what shared para we need
    tfm_init_user_counter=getappdata(0,'tfm_init_user_counter');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_Nframes_bf=getappdata(0,'tfm_init_user_Nframes_bf');
    tfm_init_user_bf_filenamestack=getappdata(0,'tfm_init_user_bf_filenamestack');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_bf_pathnamestack=getappdata(0,'tfm_init_user_bf_pathnamestack');
    tfm_init_user_bf_vidext=getappdata(0,'tfm_init_user_bf_vidext');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_major=getappdata(0,'tfm_init_user_major');
    tfm_init_user_minor=getappdata(0,'tfm_init_user_minor');
    tfm_init_user_angle=getappdata(0,'tfm_init_user_angle');
    tfm_init_user_ratio=getappdata(0,'tfm_init_user_ratio');
    tfm_init_user_area=getappdata(0,'tfm_init_user_area');
    tfm_init_user_area_ellipse=getappdata(0,'tfm_init_user_area_ellipse');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    multichannelczi=getappdata(0,'multichannelczi');
    
    %load in bf images
    [filename_bf,pathname_bf]=uigetfile({'*.tif';'*.czi';'*.avi'},'Select bf videos',tfm_init_user_pathnamestack{1},'MultiSelect','on');
    
    %really a file or did user press cancel?
    if isequal(filename_bf,0)
        return;
    end
    filename_bf = cellstr(filename_bf);
    
    %look if there already files on the image stack
    Nfiles0_bf=size(tfm_init_user_bf_filenamestack,2);
    
    %add new files and paths to stacks
    for i=1:size(filename_bf,2)
        [~,name_bf,ext_bf]=fileparts(strcat(pathname_bf,filename_bf{1,i}));
        tfm_init_user_bf_filenamestack{1,Nfiles0_bf+i}=name_bf;
        tfm_init_user_bf_pathnamestack{1,Nfiles0_bf+i}=pathname_bf;
        tfm_init_user_bf_vidext{1,Nfiles0_bf+i}=ext_bf;
    end
    
    % initiate mask counters
    mask_found = zeros(1,tfm_init_user_Nfiles);
    mask_count = 0;
    
    % check for masks
    for ivid = 1:size(filename_bf,2)
        if isequal(exist([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'/Mask/',tfm_init_user_bf_filenamestack{ivid},'_mask.mat'],'file'),2)
            mask_found(ivid) = 1;
            mask_count = mask_count+1;
        end
    end
    
    % prompt user to use masks
    if mask_count >= 1
        % open dialog window
        answer = questdlg([num2str(mask_count),'/',num2str(tfm_init_user_Nfiles),' pre-drawn masks were detected in the image folders. Do you wish to use these masks?'],'Masks Detected','Yes','No','No');
    else
        answer = 'No';
    end
    
    %Loop over vids and save preview frames
    for j=1:size(filename_bf,2)
        %update statusbar
        if size(filename_bf,2)==1
            sb=statusbar(h_init(1).fig,'Importing... ');
            sb.getComponent(0).setForeground(java.awt.Color.red);
        else
            sb=statusbar(h_init(1).fig,['Importing... ',num2str(floor(100*(j-1)/size(filename_bf,2))), '%% done']);
            sb.getComponent(0).setForeground(java.awt.Color.red);
        end
        
        %create folder for saving the stuff
        if strcmp(tfm_init_user_filenamestack{Nfiles0_bf+j}, tfm_init_user_bf_filenamestack{Nfiles0_bf+j}) == 0
            if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{1,Nfiles0_bf+j}], 'dir'),7)
                rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{1,Nfiles0_bf+j}],'s')
            end
            mkdir(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{1,Nfiles0_bf+j}])
        end
        
        if strcmp(tfm_init_user_bf_vidext{1,Nfiles0_bf+j},'.czi')
            [~,data]=evalc('bfopen([tfm_init_user_bf_pathnamestack{1,Nfiles0_bf+j},tfm_init_user_bf_filenamestack{1,Nfiles0_bf+j},tfm_init_user_bf_vidext{1,Nfiles0_bf+j}])');
            
            %--------
            %USE TO ADAPT TO MULTICHANNEL CZI files
            % check for image  and channel stack
            info = data{1, 1}{1, 2};
            Nchannels = 1;
            channels = extractAfter(info, 'C=');
            channels = extractBefore(channels, ';');
            if ~(channels == "")
                channels = split(channels, '/', 1);
                Nchannels = str2num(channels{2, 1});
            end
            
            images=data{1,1}; %images
            N=size(images,1); %number of frames
            m = size(images{1,1},1);
            n = size(images{1,1},2);
            image_stack = zeros(m,n,N,'uint8');
            TFMChannel = getappdata(0, 'TFMChannel');
            %save images in variable
            start_frame = 0;
            if get(h_init(1).checkbox_trim, 'value')
                start_frame = 1;
            end
            parfor i = start_frame:N-1
                index = TFMChannel + Nchannels*i;
                imagei=images{index,1};
                %convert to grey
                if ndims(imagei) == 3
                    imagei=rgb2gray(imagei);
                end
                imagei=normalise(imagei);
                imagei=im2uint8(imagei);
                image_stack(:,:,i+1) = imagei;
            end
            if start_frame == 1
                image_stack = image_stack(:,:,2:end);
            end
            N = size(image_stack,3);
            %save to mat
            save(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{1,j},'/image_stack_bf.mat'],'image_stack','-v7.3');
            
            image1_raw=image_stack(:,:,1);
            
        elseif strcmp(tfm_init_user_bf_vidext{1,Nfiles0_bf+j},'.tif')
            InfoImage=imfinfo([tfm_init_user_bf_pathnamestack{1,Nfiles0_bf+j},tfm_init_user_bf_filenamestack{1,Nfiles0_bf+j},tfm_init_user_bf_vidext{1,Nfiles0_bf+j}]);
            bit=InfoImage.BitDepth;
            N = numel(InfoImage);
            TifLink=Tiff([tfm_init_user_bf_pathnamestack{1,Nfiles0_bf+j},tfm_init_user_bf_filenamestack{1,Nfiles0_bf+j},tfm_init_user_bf_vidext{1,Nfiles0_bf+j}],'r');
            
            % initialize image stack
            TifLink.setDirectory(1);
            imagei = TifLink.read();
            m = size(imagei,1);
            n = size(imagei,2);
            image_stack = zeros(m,n,N,'uint8');
            end_frame = N;
            if get(h_init(1).checkbox_trim, 'value')
                end_frame = N-1;
                TifLink.read(); %read past first frame
                image_stack = zeros(m,n,N-1,'uint8');
            end
            for i=1:end_frame
                TifLink.setDirectory(i);
                imagei=TifLink.read();
                %convert to grey
                if ndims(imagei) == 3
                    imagei=rgb2gray(imagei);
                end
                imagei=normalise(imagei);
                imagei=im2uint8(imagei);
                image_stack(:,:,i) = imagei;
            end
            TifLink.close();
            %save to mat
            save(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{1,Nfiles0_bf+j},'/image_stack_bf.mat'],'image_stack','-v7.3')
            
            image1_raw=image_stack(:,:,1);
            
        elseif strcmp(tfm_init_user_bf_vidext{1,Nfiles0_bf+j},'.avi')
            videoObj = VideoReader([tfm_init_user_bf_pathnamestack{1,Nfiles0_bf+j},tfm_init_user_bf_filenamestack{1,Nfiles0_bf+j},tfm_init_user_bf_vidext{1,Nfiles0_bf+j}]);
            N = videoObj.NumberOfFrames;
            
            %initialize image stack
            imagei = read(videoObj,1);
            m = size(imagei,1);
            n = size(imagei,2);
            image_stack = zeros(m,n,N,'uint8');
            num_frames = N;
            if get(h_init(1).checkbox_trim, 'value')
                num_frames = N-1;
                image_stack = zeros(m,n,N-1,'uint8');
            end
            parfor i=1:num_frames
                if get(h_init(1).checkbox_trim, 'value')
                    imagei=read(videoObj, i+1);
                else
                    imagei=read(videoObj, i);
                end
                %convert to grey
                if ndims(imagei) == 3
                    imagei=rgb2gray(imagei);
                end
                imagei=normalise(imagei);
                imagei=im2uint8(imagei);
                image_stack(:,:,i) = imagei;
            end
            %save to mat
            save(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{1,Nfiles0_bf+j},'/image_stack_bf.mat'],'image_stack','-v7.3')
            
            image1_raw=image_stack(:,:,1);
        end
        
        %save frames to preview stack
        tfm_init_user_bf_preview_frame1{Nfiles0_bf+j}=image1_raw;
        tfm_init_user_Nframes_bf{Nfiles0_bf+j}=size(image_stack,3);
    end
    
    %update statusbar
    sb=statusbar(h_init(1).fig,'Import - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %set area factor to 3
    if isempty(tfm_init_user_area_factor)
        tfm_init_user_area_factor=3;
    end
    
    % check for previous mask
    if strcmp(answer,'Yes')
        for ivid = 1:tfm_init_user_Nfiles
            % if mask exists
            if mask_found(ivid) == 1
                % load masks and draw outlines
                s = load([tfm_init_user_bf_pathnamestack{1,ivid},'/',tfm_init_user_bf_filenamestack{1,ivid},'/Mask/',tfm_init_user_bf_filenamestack{ivid},'_mask.mat']);
                tfm_init_user_binary1{ivid} = s.mask;
                
                % draw outlines
                BWoutline=bwboundaries(tfm_init_user_binary1{ivid});
                if ~isempty(BWoutline)
                    tfm_init_user_outline1x{ivid}=BWoutline{1}(:,2);
                    tfm_init_user_outline1y{ivid}=BWoutline{1}(:,1);
                else
                    tfm_init_user_outline1x{ivid}=[];
                    tfm_init_user_outline1y{ivid}=[];
                end
                
                s = regionprops(tfm_init_user_binary1{ivid}, 'Orientation', 'MajorAxisLength', ...
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
                
                %calculate new ellipse
                an=tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*a;
                bn=1/tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*b;
                xyn = [an*cosphi; bn*sinphi];
                xyn = R*xyn;
                xn = xyn(1,:) + xbar;
                yn = xyn(2,:) + ybar;
                
                %save dimensions
                tfm_init_user_major(ivid)=2*a;
                tfm_init_user_minor(ivid)=2*b;
                tfm_init_user_ratio(ivid)=a/(b+eps);
                tfm_init_user_angle(ivid)=s(1).Orientation;
                tfm_init_user_area(ivid)=s(1).Area;
                tfm_init_user_area_ellipse(ivid)=an*bn*pi;
                
                %save outlines
                tfm_init_user_outline2x{ivid}=xn;
                tfm_init_user_outline2y{ivid}=yn;
            end
        end
    end
    
    %set preview of 1st video
    axes(h_init(1).axes_curr);
    imshow(tfm_init_user_preview_frame1{tfm_init_user_counter});hold on;
    plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
    plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
    plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
    hold off;
    
    %set preview of bf video
    if isempty(tfm_init_user_bf_filenamestack)
        axes(h_init(1).axes_bf);
        imshow([]);
        set(h_init(1).axes_bf,'visible','off');
        set(h_init(1).text_bf_whichvidname,'string',[]);
    elseif size(tfm_init_user_bf_filenamestack,2) < tfm_init_user_counter
        axes(h_init(1).axes_bf);
        imshow([]);
        set(h_init(1).axes_bf,'visible','off');
        set(h_init(1).text_bf_whichvidname,'string',[]);
    elseif size(tfm_init_user_bf_filenamestack,2) >= tfm_init_user_counter
        set(h_init(1).axes_bf,'Visible','on');
        axes(h_init(1).axes_bf);
        imshow(tfm_init_user_bf_preview_frame1{tfm_init_user_counter});hold on;
        plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
        plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
        plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
        hold off;
        set(h_init(1).text_bf_whichvidname,'string',[tfm_init_user_bf_filenamestack{tfm_init_user_counter}]);
    end
    
    %save
    setappdata(0,'tfm_init_user_bf_pathnamestack',tfm_init_user_bf_pathnamestack)
    setappdata(0,'tfm_init_user_bf_filenamestack',tfm_init_user_bf_filenamestack)
    setappdata(0,'tfm_init_user_bf_vidext',tfm_init_user_bf_vidext)
    setappdata(0,'tfm_init_user_bf_preview_frame1',tfm_init_user_bf_preview_frame1)
    setappdata(0,'tfm_init_user_Nframes_bf',tfm_init_user_Nframes_bf)
    setappdata(0,'tfm_init_user_major',tfm_init_user_major)
    setappdata(0,'tfm_init_user_minor',tfm_init_user_minor)
    setappdata(0,'tfm_init_user_angle',tfm_init_user_angle);
    setappdata(0,'tfm_init_user_ratio',tfm_init_user_ratio)
    setappdata(0,'tfm_init_user_area',tfm_init_user_area)
    setappdata(0,'tfm_init_user_area_ellipse',tfm_init_user_area_ellipse)
    setappdata(0,'tfm_init_user_binary1',tfm_init_user_binary1)
    setappdata(0,'tfm_init_user_outline1x',tfm_init_user_outline1x)
    setappdata(0,'tfm_init_user_outline1y',tfm_init_user_outline1y)
    setappdata(0,'tfm_init_user_outline2x',tfm_init_user_outline2x)
    setappdata(0,'tfm_init_user_outline2y',tfm_init_user_outline2y)
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
    
end

function init_push_delete(hObject, eventdata, h_init)
try
    %load what shared para we need
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_init_user_cellname=getappdata(0,'tfm_init_user_cellname');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_Nframes_bf=getappdata(0,'tfm_init_user_Nframes_bf');
    tfm_init_user_imsize_m=getappdata(0,'tfm_init_user_imsize_m');
    tfm_init_user_imsize_n=getappdata(0,'tfm_init_user_imsize_n');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_bf_filenamestack=getappdata(0,'tfm_init_user_bf_filenamestack');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_bf_pathnamestack=getappdata(0,'tfm_init_user_bf_pathnamestack');
    tfm_init_user_vidext=getappdata(0,'tfm_init_user_vidext');
    tfm_init_user_bf_vidext=getappdata(0,'tfm_init_user_bf_vidext');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    tfm_init_user_major=getappdata(0,'tfm_init_user_major');
    tfm_init_user_minor=getappdata(0,'tfm_init_user_minor');
    tfm_init_user_angle=getappdata(0,'tfm_init_user_angle');
    tfm_init_user_ratio=getappdata(0,'tfm_init_user_ratio');
    tfm_init_user_area=getappdata(0,'tfm_init_user_area');
    tfm_init_user_area_ellipse=getappdata(0,'tfm_init_user_area_ellipse');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary3=getappdata(0,'tfm_init_user_binary3');
    tfm_init_user_rotate=getappdata(0,'tfm_init_user_rotate');
    %get selected item in listbox
    index=get(h_init(1).listbox_display,'Value');
    
    %to which video does it jump next?
    if index==tfm_init_user_Nfiles
        index_next=index-1;
    else index_next=index;
    end
    
    %remove directory of saved imagedata
    if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{index}], 'dir'),7)
        rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{index}],'s')
    end
    
    if size(tfm_init_user_bf_filenamestack,2) >= index
        if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{index}], 'dir'),7)
            rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{index}],'s')
        end
    end
    
    %delete from saved stuff
    tfm_init_user_Nfiles=tfm_init_user_Nfiles-1;
    tfm_init_user_conversion(index)=[];
    tfm_init_user_cellname(index)=[];
    tfm_init_user_framerate(index)=[];
    tfm_init_user_Nframes(index)=[];
    tfm_init_user_imsize_m(index)=[];
    tfm_init_user_imsize_n(index)=[];
    tfm_init_user_filenamestack(index)=[];
    tfm_init_user_pathnamestack(index)=[];
    tfm_init_user_vidext(index)=[];
    tfm_init_user_scale_factor(index)=[];
    tfm_init_user_E(index)=[];
    tfm_init_user_nu(index)=[];
    tfm_init_user_preview_frame1(index)=[];
    tfm_init_user_binary1(index)=[];
    tfm_init_user_binary3(index)=[];
    tfm_init_user_major(index)=[];
    tfm_init_user_minor(index)=[];
    tfm_init_user_angle(index)=[];
    tfm_init_user_ratio(index)=[];
    tfm_init_user_area(index)=[];
    tfm_init_user_area_ellipse(index)=[];
    tfm_init_user_outline1x(index)=[];
    tfm_init_user_outline1y(index)=[];
    tfm_init_user_outline2x(index)=[];
    tfm_init_user_outline2y(index)=[];
    tfm_init_user_outline3x(index)=[];
    tfm_init_user_outline3y(index)=[];
    tfm_init_user_rotate(index)=[];
    
    if isempty(tfm_init_user_bf_filenamestack)
    elseif size(tfm_init_user_bf_filenamestack,2) < index
    elseif size(tfm_init_user_bf_filenamestack,2) >= index
        tfm_init_user_Nframes_bf(index)=[];
        tfm_init_user_bf_filenamestack(index)=[];
        tfm_init_user_bf_pathnamestack(index)=[];
        tfm_init_user_bf_vidext(index)=[];
        tfm_init_user_bf_preview_frame1(index)=[];
    end
    
    %         %Deleted as redundant
    %         if index < size(tfm_init_user_bf_preview_frame1, 2) %ensure video can still be deleted even if no bf
    %             tfm_init_user_Nframes_bf(index)=[];
    %             tfm_init_user_bf_preview_frame1(index)=[];
    %             tfm_init_user_bf_vidext(index)=[];
    %             tfm_init_user_bf_pathnamestack(index)=[];
    %             tfm_init_user_bf_filenamestack(index)=[];
    %         end
    
    
    set(h_init(1).listbox_display,'String',tfm_init_user_filenamestack);
    
    if ~isempty(tfm_init_user_filenamestack)
        %look at vid counter
        tfm_init_user_counter=index_next;
        
        %select item in listbox
        set(h_init(1).listbox_display,'Value',tfm_init_user_counter);
        
        %display 1st frame of new video
        axes(h_init(1).axes_curr);
        imshow(tfm_init_user_preview_frame1{1,tfm_init_user_counter});hold on;
        plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
        plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
        plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
        hold off;
        
        %display new settings
        set(h_init(1).edit_fps,'String',num2str(tfm_init_user_framerate{tfm_init_user_counter}));
        set(h_init(1).edit_conversion,'String',num2str(tfm_init_user_conversion{tfm_init_user_counter}));
        set(h_init(1).edit_nframes,'String',num2str(tfm_init_user_Nframes{tfm_init_user_counter}));
        set(h_init(1).edit_nframes,'Enable','off');
        set(h_init(1).edit_cellname,'String',tfm_init_user_cellname{tfm_init_user_counter});
        set(h_init(1).edit_youngs,'String',num2str(tfm_init_user_E{tfm_init_user_counter}));
        set(h_init(1).edit_poisson,'String',num2str(tfm_init_user_nu{tfm_init_user_counter}));
        set(h_init(1).edit_scale_factor,'String',num2str(tfm_init_user_scale_factor{tfm_init_user_counter}));
        set(h_init(1).text_whichvidname,'String',[tfm_init_user_filenamestack{1,tfm_init_user_counter},' (showing 1st frame)']);
        %set(h_init(1).text_bf_whichvidname,'String',[tfm_init_user_bf_filenamestack{1,tfm_init_user_counter}]);
        set(h_init(1).checkbox_rotate,'value',tfm_init_user_rotate(tfm_init_user_counter));
        if strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'.tif') || strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'.avi') || strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'none')
            set(h_init(1).edit_fps,'Enable','on');
            set(h_init(1).edit_conversion,'Enable','on');
        else
            set(h_init(1).edit_fps,'Enable','off');
            set(h_init(1).edit_conversion,'Enable','of');
        end
        
        %update text (x/N)
        set(h_init(1).text_whichvid,'String',[num2str(tfm_init_user_counter),'/',num2str(tfm_init_user_Nfiles)]);
        
        if tfm_init_user_counter==1
            set(h_init(1).button_backwards,'Enable','off');
        else
            set(h_init(1).button_backwards,'Enable','on');
        end
        if tfm_init_user_counter==tfm_init_user_Nfiles
            set(h_init(1).button_forwards,'Enable','off');
        else
            set(h_init(1).button_forwards,'Enable','on');
        end
        
        %grey out listbox
        set(h_init(1).listbox_display,'Enable','off');
        
        %display bf frame
        if isempty(tfm_init_user_bf_filenamestack)
            axes(h_init(1).axes_bf);
            imshow([]);
            set(h_init(1).axes_bf,'visible','off');
            set(h_init(1).text_bf_whichvidname,'string',[]);
        elseif size(tfm_init_user_bf_filenamestack,2) < tfm_init_user_counter
            axes(h_init(1).axes_bf);
            imshow([]);
            set(h_init(1).axes_bf,'visible','off');
            set(h_init(1).text_bf_whichvidname,'string',[]);
        elseif size(tfm_init_user_bf_filenamestack,2) >= tfm_init_user_counter
            set(h_init(1).axes_bf,'visible','on');
            axes(h_init(1).axes_bf);
            imshow(tfm_init_user_bf_preview_frame1{tfm_init_user_counter});hold on;
            plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
            plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
            plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
            hold off;
            set(h_init(1).text_bf_whichvidname,'string',[tfm_init_user_bf_filenamestack{tfm_init_user_counter}]);
        end
        
    else %hide panels etc
        set(h_init(1).panel_list,'Visible','off');
        set(h_init(1).panel_vid,'Visible','off');
        set(h_init(1).subpanel_vid,'Visible','off');
        set(h_init(1).button_ok,'Visible','off');
        set(h_init(1).button_ok_strln,'Visible','off');
        set(h_init(1).checkbox_denoise,'Visible','off');
        set(h_init(1).checkbox_bleach,'Visible','off');
        set(h_init(1).checkbox_crop,'Visible','off');
        set(h_init(1).checkbox_bin,'Visible','off');
        set(h_init(1).menu_bin,'Visible','off');
        tfm_init_user_counter=1;
    end
    
    
    %store everything for shared use
    setappdata(0,'tfm_init_user_filenamestack',tfm_init_user_filenamestack)
    setappdata(0,'tfm_init_user_bf_filenamestack',tfm_init_user_bf_filenamestack)
    setappdata(0,'tfm_init_user_pathnamestack',tfm_init_user_pathnamestack)
    setappdata(0,'tfm_init_user_bf_pathnamestack',tfm_init_user_bf_pathnamestack)
    setappdata(0,'tfm_init_user_vidext',tfm_init_user_vidext)
    setappdata(0,'tfm_init_user_bf_vidext',tfm_init_user_bf_vidext)
    setappdata(0,'tfm_init_user_preview_frame1',tfm_init_user_preview_frame1)
    setappdata(0,'tfm_init_user_bf_preview_frame1',tfm_init_user_bf_preview_frame1)
    setappdata(0,'tfm_init_user_area_factor',tfm_init_user_area_factor)
    setappdata(0,'tfm_init_user_scale_factor',tfm_init_user_scale_factor)
    setappdata(0,'tfm_init_user_Nfiles',tfm_init_user_Nfiles)
    setappdata(0,'tfm_init_user_Nframes',tfm_init_user_Nframes)
    setappdata(0,'tfm_init_user_Nframes_bf',tfm_init_user_Nframes_bf)
    setappdata(0,'tfm_init_user_imsize_m',tfm_init_user_imsize_m)
    setappdata(0,'tfm_init_user_imsize_n',tfm_init_user_imsize_n)
    setappdata(0,'tfm_init_user_cellname',tfm_init_user_cellname)
    setappdata(0,'tfm_init_user_conversion',tfm_init_user_conversion)
    setappdata(0,'tfm_init_user_framerate',tfm_init_user_framerate)
    setappdata(0,'tfm_init_user_E',tfm_init_user_E)
    setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
    setappdata(0,'tfm_init_user_binary1',tfm_init_user_binary1)
    setappdata(0,'tfm_init_user_binary3',tfm_init_user_binary3)
    setappdata(0,'tfm_init_user_major',tfm_init_user_major)
    setappdata(0,'tfm_init_user_minor',tfm_init_user_minor)
    setappdata(0,'tfm_init_user_angle',tfm_init_user_angle);
    setappdata(0,'tfm_init_user_ratio',tfm_init_user_ratio)
    setappdata(0,'tfm_init_user_area',tfm_init_user_area)
    setappdata(0,'tfm_init_user_area_ellipse',tfm_init_user_area_ellipse)
    setappdata(0,'tfm_init_user_outline1x',tfm_init_user_outline1x)
    setappdata(0,'tfm_init_user_outline1y',tfm_init_user_outline1y)
    setappdata(0,'tfm_init_user_outline2x',tfm_init_user_outline2x)
    setappdata(0,'tfm_init_user_outline2y',tfm_init_user_outline2y)
    setappdata(0,'tfm_init_user_outline3x',tfm_init_user_outline3x)
    setappdata(0,'tfm_init_user_outline3y',tfm_init_user_outline3y)
    setappdata(0,'tfm_init_user_counter',tfm_init_user_counter)
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

function init_push_forwards(hObject, eventdata, h_init)
%disable figure during calculation
enableDisableFig(h_init(1).fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_init(1).fig,1));


try
    
    %load what shared para we need
    tfm_init_user_counter=getappdata(0,'tfm_init_user_counter');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_Nframes_bf=getappdata(0,'tfm_init_user_Nframes_bf');
    tfm_init_user_imsize_m=getappdata(0,'tfm_init_user_imsize_m');
    tfm_init_user_imsize_n=getappdata(0,'tfm_init_user_imsize_n');
    tfm_init_user_cellname=getappdata(0,'tfm_init_user_cellname');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_bf_filenamestack=getappdata(0,'tfm_init_user_bf_filenamestack');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_vidext=getappdata(0,'tfm_init_user_vidext');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_rotate=getappdata(0,'tfm_init_user_rotate');
    
    %look at vid counter
    if tfm_init_user_counter<tfm_init_user_Nfiles
        %save settings
        tfm_init_user_framerate{tfm_init_user_counter}=str2double(get(h_init(1).edit_fps,'String'));
        tfm_init_user_conversion{tfm_init_user_counter}=str2double(get(h_init(1).edit_conversion,'String'));
        tfm_init_user_cellname{tfm_init_user_counter}=get(h_init(1).edit_cellname,'String');
        tfm_init_user_area_factor=str2double(get(h_init(1).edit_area_factor,'String'));
        tfm_init_user_scale_factor{tfm_init_user_counter}=str2double(get(h_init(1).edit_scale_factor,'String'));
        tfm_init_user_E{tfm_init_user_counter}=str2double(get(h_init(1).edit_youngs,'String'));
        tfm_init_user_nu{tfm_init_user_counter}=str2double(get(h_init(1).edit_poisson,'String'));
        
        %go to video before
        tfm_init_user_counter=tfm_init_user_counter+1;
        
        %select item in listbox
        set(h_init(1).listbox_display,'Value',tfm_init_user_counter);
        
        %display 1st frame of new video
        axes(h_init(1).axes_curr);
        imshow(tfm_init_user_preview_frame1{tfm_init_user_counter}); hold on;
        plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
        plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
        plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
        hold off;
        
        %display new settings
        set(h_init(1).edit_fps,'String',num2str(tfm_init_user_framerate{tfm_init_user_counter}));
        set(h_init(1).edit_conversion,'String',num2str(tfm_init_user_conversion{tfm_init_user_counter}));
        set(h_init(1).edit_nframes,'String',num2str(tfm_init_user_Nframes{tfm_init_user_counter}));
        set(h_init(1).edit_nframes,'Enable','off');
        %set(h_init(1).edit_area_factor,'String',num2str(tfm_init_user_area_factor));
        set(h_init(1).edit_scale_factor,'String',num2str(tfm_init_user_scale_factor{tfm_init_user_counter}));
        set(h_init(1).edit_cellname,'String',tfm_init_user_cellname{tfm_init_user_counter});
        set(h_init(1).text_whichvidname,'String',[tfm_init_user_filenamestack{1,tfm_init_user_counter},' (showing 1st frame)']);
        %set(h_init(1).text_bf_whichvidname,'String',[tfm_init_user_bf_filenamestack{1,tfm_init_user_counter}]);
        set(h_init(1).edit_youngs,'String',num2str(tfm_init_user_E{tfm_init_user_counter}));
        set(h_init(1).edit_poisson,'String',num2str(tfm_init_user_nu{tfm_init_user_counter}));
        set(h_init(1).checkbox_rotate,'value',tfm_init_user_rotate(tfm_init_user_counter));
        if strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'.tif') || strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'.avi') || strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'none')
            set(h_init(1).edit_fps,'Enable','on');
            set(h_init(1).edit_conversion,'Enable','on');
        else
            set(h_init(1).edit_fps,'Enable','off');
            set(h_init(1).edit_conversion,'Enable','off');
        end
        
        %display bf frame
        if isempty(tfm_init_user_bf_filenamestack)
            axes(h_init(1).axes_bf);
            imshow([]);
            set(h_init(1).axes_bf,'visible','off');
            set(h_init(1).text_bf_whichvidname,'string',[]);
        elseif size(tfm_init_user_bf_filenamestack,2) < tfm_init_user_counter
            axes(h_init(1).axes_bf);
            imshow([]);
            set(h_init(1).axes_bf,'visible','off');
            set(h_init(1).text_bf_whichvidname,'string',[]);
        elseif size(tfm_init_user_bf_filenamestack,2) >= tfm_init_user_counter
            set(h_init(1).axes_bf,'visible','on');
            axes(h_init(1).axes_bf);
            imshow(tfm_init_user_bf_preview_frame1{tfm_init_user_counter});hold on;
            plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
            plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
            plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
            hold off;
            set(h_init(1).text_bf_whichvidname,'string',[tfm_init_user_bf_filenamestack{tfm_init_user_counter}]);
        end
        
        %update text (x/N)
        set(h_init(1).text_whichvid,'String',[num2str(tfm_init_user_counter),'/',num2str(tfm_init_user_Nfiles)]);
    end
    
    if tfm_init_user_counter==tfm_init_user_Nfiles
        %grey out back button
        set(h_init(1).button_forwards,'Enable','off');
        set(h_init(1).button_backwards,'Enable','on');
        %enable ok button
        set(h_init(1).button_ok,'Enable','on');
        set(h_init(1).button_ok_strln,'Enable','on');
    else
        set(h_init(1).button_forwards,'Enable','on');
        set(h_init(1).button_backwards,'Enable','on');
    end
    
    %grey out listbox
    set(h_init(1).listbox_display,'Enable','off');
    
    %store everything for shared use
    setappdata(0,'tfm_init_user_filenamestack',tfm_init_user_filenamestack)
    setappdata(0,'tfm_init_user_pathnamestack',tfm_init_user_pathnamestack)
    setappdata(0,'tfm_init_user_vidext',tfm_init_user_vidext)
    setappdata(0,'tfm_init_user_counter',tfm_init_user_counter)
    setappdata(0,'tfm_init_user_Nfiles',tfm_init_user_Nfiles)
    setappdata(0,'tfm_init_user_cellname',tfm_init_user_cellname)
    setappdata(0,'tfm_init_user_Nframes',tfm_init_user_Nframes)
    setappdata(0,'tfm_init_user_Nframes_bf',tfm_init_user_Nframes_bf)
    setappdata(0,'tfm_init_user_imsize_m',tfm_init_user_imsize_m)
    setappdata(0,'tfm_init_user_imsize_n',tfm_init_user_imsize_n)
    setappdata(0,'tfm_init_user_conversion',tfm_init_user_conversion)
    setappdata(0,'tfm_init_user_framerate',tfm_init_user_framerate)
    setappdata(0,'tfm_init_user_area_factor',tfm_init_user_area_factor)
    setappdata(0,'tfm_init_user_scale_factor',tfm_init_user_scale_factor)
    setappdata(0,'tfm_init_user_E',tfm_init_user_E)
    setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

function init_push_backwards(hObject, eventdata, h_init)
%disable figure during calculation
enableDisableFig(h_init(1).fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_init(1).fig,1));


try
    
    %load what shared para we need
    tfm_init_user_counter=getappdata(0,'tfm_init_user_counter');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_Nframes_bf=getappdata(0,'tfm_init_user_Nframes_bf');
    tfm_init_user_imsize_m=getappdata(0,'tfm_init_user_imsize_m');
    tfm_init_user_imsize_n=getappdata(0,'tfm_init_user_imsize_n');
    tfm_init_user_cellname=getappdata(0,'tfm_init_user_cellname');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_bf_filenamestack=getappdata(0,'tfm_init_user_bf_filenamestack');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_vidext=getappdata(0,'tfm_init_user_vidext');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_rotate=getappdata(0,'tfm_init_user_rotate');
    
    %look at vid counter
    if tfm_init_user_counter>1
        %save settings
        tfm_init_user_framerate{tfm_init_user_counter}=str2double(get(h_init(1).edit_fps,'String'));
        tfm_init_user_conversion{tfm_init_user_counter}=str2double(get(h_init(1).edit_conversion,'String'));
        tfm_init_user_cellname{tfm_init_user_counter}=get(h_init(1).edit_cellname,'String');
        tfm_init_user_area_factor=str2double(get(h_init(1).edit_area_factor,'String'));
        tfm_init_user_scale_factor{tfm_init_user_counter}=str2double(get(h_init(1).edit_scale_factor,'String'));
        tfm_init_user_E{tfm_init_user_counter}=str2double(get(h_init(1).edit_youngs,'String'));
        tfm_init_user_nu{tfm_init_user_counter}=str2double(get(h_init(1).edit_poisson,'String'));
        
        %go to video before
        tfm_init_user_counter=tfm_init_user_counter-1;
        
        %select item in listbox
        set(h_init(1).listbox_display,'Value',tfm_init_user_counter);
        
        %display 1st frame of new video
        axes(h_init(1).axes_curr);
        imshow(tfm_init_user_preview_frame1{tfm_init_user_counter}); hold on;
        plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
        plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
        plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
        hold off;
        
        %display new settings
        set(h_init(1).edit_fps,'String',num2str(tfm_init_user_framerate{tfm_init_user_counter}));
        set(h_init(1).edit_conversion,'String',num2str(tfm_init_user_conversion{tfm_init_user_counter}));
        set(h_init(1).edit_nframes,'String',num2str(tfm_init_user_Nframes{tfm_init_user_counter}));
        %set(h_init(1).edit_area_factor,'String',num2str(tfm_init_user_area_factor));
        set(h_init(1).edit_scale_factor,'String',num2str(tfm_init_user_scale_factor{tfm_init_user_counter}));
        set(h_init(1).edit_nframes,'Enable','off');
        set(h_init(1).edit_cellname,'String',tfm_init_user_cellname{tfm_init_user_counter});
        set(h_init(1).edit_youngs,'String',num2str(tfm_init_user_E{tfm_init_user_counter}));
        set(h_init(1).edit_poisson,'String',num2str(tfm_init_user_nu{tfm_init_user_counter}));
        set(h_init(1).text_whichvidname,'String',[tfm_init_user_filenamestack{1,tfm_init_user_counter},' (showing 1st frame)']);
        %set(h_init(1).text_bf_whichvidname,'String',[tfm_init_user_bf_filenamestack{1,tfm_init_user_counter}]);
        set(h_init(1).checkbox_rotate,'value',tfm_init_user_rotate(tfm_init_user_counter));
        if strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'.tif') || strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'.avi') || strcmp(tfm_init_user_vidext{1,tfm_init_user_counter},'none')
            set(h_init(1).edit_fps,'Enable','on');
            set(h_init(1).edit_conversion,'Enable','on');
        else
            set(h_init(1).edit_fps,'Enable','off');
            set(h_init(1).edit_conversion,'Enable','of');
        end
        
        %display bf frame
        if isempty(tfm_init_user_bf_filenamestack)
            axes(h_init(1).axes_bf);
            imshow([]);
            set(h_init(1).axes_bf,'visible','off');
            set(h_init(1).text_bf_whichvidname,'string',[]);
        elseif size(tfm_init_user_bf_filenamestack,2) < tfm_init_user_counter
            axes(h_init(1).axes_bf);
            imshow([]);
            set(h_init(1).axes_bf,'visible','off');
            set(h_init(1).text_bf_whichvidname,'string',[]);
        elseif size(tfm_init_user_bf_filenamestack,2) >= tfm_init_user_counter
            set(h_init(1).axes_bf,'visible','on');
            axes(h_init(1).axes_bf);
            imshow(tfm_init_user_bf_preview_frame1{tfm_init_user_counter});hold on;
            plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
            plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
            plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
            hold off;
            set(h_init(1).text_bf_whichvidname,'string',[tfm_init_user_bf_filenamestack{tfm_init_user_counter}]);
        end
        
        %update text (x/N)
        set(h_init(1).text_whichvid,'String',[num2str(tfm_init_user_counter),'/',num2str(tfm_init_user_Nfiles)]);
    end
    
    if tfm_init_user_counter==1
        set(h_init(1).button_backwards,'Enable','off');
        set(h_init(1).button_forwards,'Enable','on');
    else
        set(h_init(1).button_backwards,'Enable','on');
        set(h_init(1).button_forwards,'Enable','on');
    end
    
    %grey out listbox
    set(h_init(1).listbox_display,'Enable','off');
    
    %store everything for shared use
    setappdata(0,'tfm_init_user_filenamestack',tfm_init_user_filenamestack)
    setappdata(0,'tfm_init_user_pathnamestack',tfm_init_user_pathnamestack)
    setappdata(0,'tfm_init_user_area_factor',tfm_init_user_area_factor)
    setappdata(0,'tfm_init_user_scale_factor',tfm_init_user_scale_factor)
    setappdata(0,'tfm_init_user_vidext',tfm_init_user_vidext)
    setappdata(0,'tfm_init_user_counter',tfm_init_user_counter)
    setappdata(0,'tfm_init_user_Nfiles',tfm_init_user_Nfiles)
    setappdata(0,'tfm_init_user_cellname',tfm_init_user_cellname)
    setappdata(0,'tfm_init_user_Nframes',tfm_init_user_Nframes)
    setappdata(0,'tfm_init_user_Nframes_bf',tfm_init_user_Nframes_bf)
    setappdata(0,'tfm_init_user_imsize_m',tfm_init_user_imsize_m)
    setappdata(0,'tfm_init_user_imsize_n',tfm_init_user_imsize_n)
    setappdata(0,'tfm_init_user_conversion',tfm_init_user_conversion)
    setappdata(0,'tfm_init_user_framerate',tfm_init_user_framerate)
    setappdata(0,'tfm_init_user_E',tfm_init_user_E)
    setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

function init_push_load(hObject, eventdata, h_init)

%disable figure during calculation
enableDisableFig(h_init(1).fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_init(1).fig,1));
try
    %load shared
    tfm_init_user_counter=getappdata(0,'tfm_init_user_counter');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_bf_pathnamestack=getappdata(0,'tfm_init_user_bf_pathnamestack');
    tfm_init_user_bf_filenamestack=getappdata(0,'tfm_init_user_bf_filenamestack');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary3=getappdata(0,'tfm_init_user_binary3');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_major=getappdata(0,'tfm_init_user_major');
    tfm_init_user_minor=getappdata(0,'tfm_init_user_minor');
    tfm_init_user_angle=getappdata(0,'tfm_init_user_angle');
    tfm_init_user_ratio=getappdata(0,'tfm_init_user_ratio');
    tfm_init_user_area=getappdata(0,'tfm_init_user_area');
    tfm_init_user_area_ellipse=getappdata(0,'tfm_init_user_area_ellipse');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_croplength=getappdata(0,'tfm_init_user_croplength');
    tfm_init_user_cropwidth=getappdata(0,'tfm_init_user_cropwidth');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    
    %select mask file
    [FileName,PathName] = uigetfile('*.mat','Select *.mat file',tfm_init_user_bf_pathnamestack{1});
    %really a file or did user press cancel?
    if isequal(FileName,0)
        return;
    end
    var=load(fullfile(PathName,FileName));
    
    %save as new mask
    tfm_init_user_binary1{tfm_init_user_counter}=var.mask;
    
    %read new mask parameters
    tfm_init_user_conversion{tfm_init_user_counter}=str2double(get(h_init(1).edit_conversion,'String'));
    tfm_init_user_croplength=str2double(get(h_init(1).edit_croplength,'String'));
    tfm_init_user_cropwidth=str2double(get(h_init(1).edit_cropwidth,'String'));
    tfm_init_user_E{tfm_init_user_counter}=str2double(get(h_init(1).edit_youngs,'String'));
    tfm_init_user_nu{tfm_init_user_counter}=str2double(get(h_init(1).edit_poisson,'String'));
    tfm_init_user_area_factor=str2double(get(h_init(1).edit_area_factor,'String'));
    tfm_init_user_scale_factor{tfm_init_user_counter}=str2double(get(h_init(1).edit_scale_factor,'String'));
    tfm_init_user_cropcheck=get(h_init(1).checkbox_cropmask,'Value');
    
    %corresponding outline
    %calculate initial ellipse
    s = regionprops(tfm_init_user_binary1{tfm_init_user_counter}, 'Orientation', 'MajorAxisLength', ...
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
    
    %calculate new ellipse
    an=tfm_init_user_scale_factor{tfm_init_user_counter}*sqrt(tfm_init_user_area_factor)*a;
    bn=1/tfm_init_user_scale_factor{tfm_init_user_counter}*sqrt(tfm_init_user_area_factor)*b;
    xyn = [an*cosphi; bn*sinphi];
    xyn = R*xyn;
    xn = xyn(1,:) + xbar;
    yn = xyn(2,:) + ybar;
    
    %calculate crop mask
    image=tfm_init_user_binary1{tfm_init_user_counter};
    if tfm_init_user_cropcheck == 1
        am=tfm_init_user_croplength/(2*tfm_init_user_conversion{tfm_init_user_counter});
        bm=tfm_init_user_cropwidth/(2*tfm_init_user_conversion{tfm_init_user_counter});
        x1=xbar-am*cos(theta)+bm*sin(theta);
        x2=xbar-am*cos(theta)-bm*sin(theta);
        x3=xbar+am*cos(theta)-bm*sin(theta);
        x4=xbar+am*cos(theta)+bm*sin(theta);
        y1=ybar+am*sin(theta)+bm*cos(theta);
        y2=ybar+am*sin(theta)-bm*cos(theta);
        y3=ybar-am*sin(theta)-bm*cos(theta);
        y4=ybar-am*sin(theta)+bm*cos(theta);
        x_mask=[x1 x2 x3 x4 x1];
        y_mask=[y1 y2 y3 y4 y1];
        mask=poly2mask(x_mask,y_mask,size(image,1),size(image,2));
        tfm_init_user_binary3{tfm_init_user_counter}=mask;
        tfm_init_user_outline3x{tfm_init_user_counter}=x_mask;
        tfm_init_user_outline3y{tfm_init_user_counter}=y_mask;
    else
        tfm_init_user_binary3{tfm_init_user_counter}=logical(ones(size(image,1),size(image,2)));
        tfm_init_user_outline3x{tfm_init_user_counter}=[];
        tfm_init_user_outline3y{tfm_init_user_counter}=[];
    end
    
    %display preview w. outlines
    cla(h_init(1).axes_curr)
    axes(h_init(1).axes_curr)
    imshow(tfm_init_user_preview_frame1{tfm_init_user_counter});hold on;
    plot(x,y,'r','LineWidth',2);
    plot(xn,yn,'b','LineWidth',2);
    plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
    hold off;
    
    %save dimensions
    tfm_init_user_major(tfm_init_user_counter)=2*a;
    tfm_init_user_minor(tfm_init_user_counter)=2*b;
    tfm_init_user_ratio(tfm_init_user_counter)=a/(b+eps);
    tfm_init_user_angle(tfm_init_user_counter)=s(1).Orientation;
    tfm_init_user_area(tfm_init_user_counter)=s(1).Area;
    tfm_init_user_area_ellipse(tfm_init_user_counter)=an*bn*pi;
    
    %save outlines
    tfm_init_user_outline1x{tfm_init_user_counter}=x;
    tfm_init_user_outline1y{tfm_init_user_counter}=y;
    tfm_init_user_outline2x{tfm_init_user_counter}=xn;
    tfm_init_user_outline2y{tfm_init_user_counter}=yn;
    
    %display bf frame
    if isempty(tfm_init_user_bf_filenamestack)
        axes(h_init(1).axes_bf);
        imshow([]);
        set(h_init(1).axes_bf,'visible','off');
    elseif size(tfm_init_user_bf_filenamestack) < tfm_init_user_counter
        axes(h_init(1).axes_bf);
        imshow([]);
        set(h_init(1).axes_bf,'visible','off');
    elseif size(tfm_init_user_bf_filenamestack) >= tfm_init_user_counter
        set(h_init(1).axes_bf,'visible','on');
        axes(h_init(1).axes_bf);
        imshow(tfm_init_user_bf_preview_frame1{tfm_init_user_counter});hold on;
        plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
        plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
        plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
        hold off;
    end
    
    %save
    setappdata(0,'tfm_init_user_binary1',tfm_init_user_binary1)
    setappdata(0,'tfm_init_user_major',tfm_init_user_major)
    setappdata(0,'tfm_init_user_minor',tfm_init_user_minor)
    setappdata(0,'tfm_init_user_angle',tfm_init_user_angle);
    setappdata(0,'tfm_init_user_ratio',tfm_init_user_ratio)
    setappdata(0,'tfm_init_user_area',tfm_init_user_area)
    setappdata(0,'tfm_init_user_area_ellipse',tfm_init_user_area_ellipse)
    setappdata(0,'tfm_init_user_outline1x',tfm_init_user_outline1x)
    setappdata(0,'tfm_init_user_outline1y',tfm_init_user_outline1y)
    setappdata(0,'tfm_init_user_outline2x',tfm_init_user_outline2x)
    setappdata(0,'tfm_init_user_outline2y',tfm_init_user_outline2y)
    setappdata(0,'tfm_init_user_outline3x',tfm_init_user_outline3x)
    setappdata(0,'tfm_init_user_outline3y',tfm_init_user_outline3y)
    setappdata(0,'tfm_init_user_binary3',tfm_init_user_binary3)
    setappdata(0,'tfm_init_user_croplength',tfm_init_user_croplength)
    setappdata(0,'tfm_init_user_cropwidth',tfm_init_user_cropwidth)
    setappdata(0,'tfm_init_user_E',tfm_init_user_E)
    setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
    setappdata(0,'tfm_init_user_area_factor',tfm_init_user_area_factor)
    setappdata(0,'tfm_init_user_scale_factor',tfm_init_user_scale_factor)
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

function init_push_draw(hObject, eventdata, h_init)

%disable figure during calculation
enableDisableFig(h_init(1).fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_init(1).fig,1));

try
    sb=statusbar(h_init(1).fig,'Please wait... ');
    sb.getComponent(0).setForeground(java.awt.Color.red);
    
    %load shared
    tfm_init_user_counter=getappdata(0,'tfm_init_user_counter');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_bf_pathnamestack=getappdata(0,'tfm_init_user_bf_pathnamestack');
    tfm_init_user_bf_filenamestack=getappdata(0,'tfm_init_user_bf_filenamestack');
    tfm_init_user_bf_vidext=getappdata(0,'tfm_init_user_bf_vidext');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary3=getappdata(0,'tfm_init_user_binary3');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_major=getappdata(0,'tfm_init_user_major');
    tfm_init_user_minor=getappdata(0,'tfm_init_user_minor');
    tfm_init_user_angle=getappdata(0,'tfm_init_user_angle');
    tfm_init_user_ratio=getappdata(0,'tfm_init_user_ratio');
    tfm_init_user_area=getappdata(0,'tfm_init_user_area');
    tfm_init_user_area_ellipse=getappdata(0,'tfm_init_user_area_ellipse');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_croplength=getappdata(0,'tfm_init_user_croplength');
    tfm_init_user_cropwidth=getappdata(0,'tfm_init_user_cropwidth');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    
    %check if bf frame loaded
    if isempty(tfm_init_user_bf_filenamestack)
        sb=statusbar(h_init(1).fig,'No bf image loaded. Use "Draw from new image"');
        sb.getComponent(0).setForeground(java.awt.Color.red);
    elseif size(tfm_init_user_bf_filenamestack,2) < tfm_init_user_counter
        sb=statusbar(h_init(1).fig,'No bf image loaded. Use "Draw from new image"');
        sb.getComponent(0).setForeground(java.awt.Color.red);
    elseif isempty(tfm_init_user_bf_filenamestack{tfm_init_user_counter})
        sb=statusbar(h_init(1).fig,'No bf image loaded. Use "Draw from new image"');
        sb.getComponent(0).setForeground(java.awt.Color.red);
    elseif size(tfm_init_user_bf_filenamestack,2) >= tfm_init_user_counter
        
        %open image in figure, and let user draw
        %show in new fig
        hf=figure;
        cellimage=tfm_init_user_bf_preview_frame1{tfm_init_user_counter};
        cellimage_enh=imadjust(cellimage,stretchlim(cellimage),[]);
        imshow(cellimage_enh);hold on;
        
        %user drawn polynom conc
        hFH=impoly;
        
        %get cell blobb
        bmask = hFH.createMask();
        %close fig
        close(hf);
        
        %save as new mask
        tfm_init_user_binary1{tfm_init_user_counter}=bmask;
        
        %read new mask parameters
        tfm_init_user_conversion{tfm_init_user_counter}=str2double(get(h_init(1).edit_conversion,'String'));
        tfm_init_user_croplength=str2double(get(h_init(1).edit_croplength,'String'));
        tfm_init_user_cropwidth=str2double(get(h_init(1).edit_cropwidth,'String'));
        tfm_init_user_E{tfm_init_user_counter}=str2double(get(h_init(1).edit_youngs,'String'));
        tfm_init_user_nu{tfm_init_user_counter}=str2double(get(h_init(1).edit_poisson,'String'));
        tfm_init_user_area_factor=str2double(get(h_init(1).edit_area_factor,'String'));
        tfm_init_user_scale_factor{tfm_init_user_counter}=str2double(get(h_init(1).edit_scale_factor,'String'));
        tfm_init_user_cropcheck=get(h_init(1).checkbox_cropmask,'Value');
        
        %corresponding outline
        %calculate initial ellipse
        s = regionprops(bmask, 'Orientation', 'MajorAxisLength', ...
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
        
        %calculate new ellipse
        an=tfm_init_user_scale_factor{tfm_init_user_counter}*sqrt(tfm_init_user_area_factor)*a;
        bn=1/tfm_init_user_scale_factor{tfm_init_user_counter}*sqrt(tfm_init_user_area_factor)*b;
        xyn = [an*cosphi; bn*sinphi];
        xyn = R*xyn;
        xn = xyn(1,:) + xbar;
        yn = xyn(2,:) + ybar;
        
        %calculate mask around new ellipse
        image=tfm_init_user_binary1{tfm_init_user_counter};
        if tfm_init_user_cropcheck == 1
            am=tfm_init_user_croplength/(2*tfm_init_user_conversion{tfm_init_user_counter});
            bm=tfm_init_user_cropwidth/(2*tfm_init_user_conversion{tfm_init_user_counter});
            x1=xbar-am*cos(theta)+bm*sin(theta);
            x2=xbar-am*cos(theta)-bm*sin(theta);
            x3=xbar+am*cos(theta)-bm*sin(theta);
            x4=xbar+am*cos(theta)+bm*sin(theta);
            y1=ybar+am*sin(theta)+bm*cos(theta);
            y2=ybar+am*sin(theta)-bm*cos(theta);
            y3=ybar-am*sin(theta)-bm*cos(theta);
            y4=ybar-am*sin(theta)+bm*cos(theta);
            x_mask=[x1 x2 x3 x4 x1];
            y_mask=[y1 y2 y3 y4 y1];
            mask=poly2mask(x_mask,y_mask,size(image,1),size(image,2));
            tfm_init_user_binary3{tfm_init_user_counter}=mask;
            tfm_init_user_outline3x{tfm_init_user_counter}=x_mask;
            tfm_init_user_outline3y{tfm_init_user_counter}=y_mask;
        else
            tfm_init_user_binary3{tfm_init_user_counter}=logical(ones(size(image,1),size(image,2)));
            tfm_init_user_outline3x{tfm_init_user_counter}=[];
            tfm_init_user_outline3y{tfm_init_user_counter}=[];
        end
        
        %save dimensions
        tfm_init_user_major(tfm_init_user_counter)=2*a;
        tfm_init_user_minor(tfm_init_user_counter)=2*b;
        tfm_init_user_angle(tfm_init_user_counter)=s(1).Orientation;
        tfm_init_user_ratio(tfm_init_user_counter)=a/(b+eps);
        tfm_init_user_area(tfm_init_user_counter)=s(1).Area
        tfm_init_user_area_ellipse(tfm_init_user_counter)=an*bn*pi;
        
        %save outlines
        BWoutline=bwboundaries(bmask);
        tfm_init_user_outline1x{tfm_init_user_counter}=BWoutline{1}(:,2);
        tfm_init_user_outline1y{tfm_init_user_counter}=BWoutline{1}(:,1);
        tfm_init_user_outline2x{tfm_init_user_counter}=xn;
        tfm_init_user_outline2y{tfm_init_user_counter}=yn;
        
        %display preview w. outlines
        cla(h_init(1).axes_curr)
        axes(h_init(1).axes_curr)
        imshow(tfm_init_user_preview_frame1{tfm_init_user_counter});hold on;
        plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
        plot(xn,yn,'b','LineWidth',2);
        plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
        hold off;
        
        %display bf preview w/ outlines
        cla(h_init(1).axes_bf)
        axes(h_init(1).axes_bf)
        imshow(cellimage);hold on;
        plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
        plot(xn,yn,'b','Linewidth',2);
        plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
        hold off;
        
    end
    
    %save
    setappdata(0,'tfm_init_user_bf_filenamestack',tfm_init_user_bf_filenamestack)
    setappdata(0,'tfm_init_user_bf_pathnamestack',tfm_init_user_bf_pathnamestack)
    setappdata(0,'tfm_init_user_bf_vidext',tfm_init_user_bf_vidext)
    setappdata(0,'tfm_init_user_bf_preview_frame1',tfm_init_user_bf_preview_frame1)
    setappdata(0,'tfm_init_user_binary1',tfm_init_user_binary1)
    setappdata(0,'tfm_init_user_binary3',tfm_init_user_binary3)
    setappdata(0,'tfm_init_user_major',tfm_init_user_major)
    setappdata(0,'tfm_init_user_minor',tfm_init_user_minor)
    setappdata(0,'tfm_init_user_major',tfm_init_user_angle);
    setappdata(0,'tfm_init_user_ratio',tfm_init_user_ratio)
    setappdata(0,'tfm_init_user_area',tfm_init_user_area)
    setappdata(0,'tfm_init_user_area_ellipse',tfm_init_user_area_ellipse)
    setappdata(0,'tfm_init_user_outline1x',tfm_init_user_outline1x)
    setappdata(0,'tfm_init_user_outline1y',tfm_init_user_outline1y)
    setappdata(0,'tfm_init_user_outline2x',tfm_init_user_outline2x)
    setappdata(0,'tfm_init_user_outline2y',tfm_init_user_outline2y)
    setappdata(0,'tfm_init_user_outline3x',tfm_init_user_outline3x)
    setappdata(0,'tfm_init_user_outline3y',tfm_init_user_outline3y)
    setappdata(0,'tfm_init_user_croplength',tfm_init_user_croplength)
    setappdata(0,'tfm_init_user_cropwidth',tfm_init_user_cropwidth)
    setappdata(0,'tfm_init_user_E',tfm_init_user_E)
    setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
    setappdata(0,'tfm_init_user_area_factor',tfm_init_user_area_factor)
    setappdata(0,'tfm_init_user_scale_factor',tfm_init_user_scale_factor)
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

function init_push_draw_new(hObject, eventdata, h_init)
%disable figure during calculation
enableDisableFig(h_init(1).fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_init(1).fig,1));
try
    sb=statusbar(h_init(1).fig,'Please wait... ');
    sb.getComponent(0).setForeground(java.awt.Color.red);
    
    %load shared
    tfm_init_user_counter=getappdata(0,'tfm_init_user_counter');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_bf_pathnamestack=getappdata(0,'tfm_init_user_bf_pathnamestack');
    tfm_init_user_bf_filenamestack=getappdata(0,'tfm_init_user_bf_filenamestack');
    tfm_init_user_bf_vidext=getappdata(0,'tfm_init_user_bf_vidext');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary3=getappdata(0,'tfm_init_user_binary3');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_major=getappdata(0,'tfm_init_user_major');
    tfm_init_user_minor=getappdata(0,'tfm_init_user_minor');
    tfm_init_user_angle=getappdata(0,'tfm_init_user_angle');
    tfm_init_user_ratio=getappdata(0,'tfm_init_user_ratio');
    tfm_init_user_area=getappdata(0,'tfm_init_user_area');
    tfm_init_user_area_ellipse=getappdata(0,'tfm_init_user_area_ellipse');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_croplength=getappdata(0,'tfm_init_user_croplength');
    tfm_init_user_cropwidth=getappdata(0,'tfm_init_user_cropwidth');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    
    %1. read in image/vid: jpg, png, tif, czi
    [filename,pathname] = uigetfile({'*.tif';'*.czi';'*.png';'*.jpg'},'Select new bf image',tfm_init_user_bf_pathnamestack{1},'MultiSelect','off');
    %really a file or did user press cancel?
    if isequal(filename,0)
        return;
    end
    filename = cellstr(filename);
    
    %extract filename data
    [~,name,ext]=fileparts(strcat(pathname,filename{1,1}));
    
    %save to filename stacks
    tfm_init_user_bf_filenamestack{tfm_init_user_counter}=name;
    tfm_init_user_bf_pathnamestack{tfm_init_user_counter}=pathname;
    tfm_init_user_bf_vidext{tfm_init_user_counter}=ext;
    
    
    %check format and load:
    if strcmp(ext,'.czi')
        %use bioformats for import
        [~,data]=evalc('bfopen([pathname,filename{1,1}]);');
        
        %imagedata
        images=data{1,1}; %images
        cellimage=normalise(images{1,1});
        cellimage=im2uint8(cellimage);
        
    elseif strcmp(ext,'.tif')
        TifLink = Tiff([pathname,filename{1,1}], 'r');
        TifLink.setDirectory(1);
        cellimage=TifLink.read();
        %convert to grey
        if ndims(cellimage) == 3
            cellimage=rgb2gray(cellimage);
        end
        cellimage=normalise(cellimage);
        cellimage=im2uint8(cellimage);
        TifLink.close();
        %
        
    elseif strcmp(ext,'.png') || strcmp(ext,'.jpg')
        cellimage=normalise(imread([pathname,filename{1,1}]));
        cellimage=im2uint8(cellimage);
    else
        return;
    end
    
    %save new preview image
    tfm_init_user_bf_preview_frame1{tfm_init_user_counter}=cellimage;
    
    %2.open image in figure, and let user draw
    %show in new fig
    hf=figure;
    cellimage_enh=imadjust(cellimage,stretchlim(cellimage),[]);
    imshow(cellimage_enh);hold on;
    
    %user drawn polynom conc
    hFH=impoly;
    
    %get cell blobb
    bmask = hFH.createMask();
    %close fig
    close(hf);
    
    %save as new mask
    tfm_init_user_binary1{tfm_init_user_counter}=bmask;
    
    %read new mask parameters
    tfm_init_user_conversion{tfm_init_user_counter}=str2double(get(h_init(1).edit_conversion,'String'));
    tfm_init_user_croplength=str2double(get(h_init(1).edit_croplength,'String'));
    tfm_init_user_cropwidth=str2double(get(h_init(1).edit_cropwidth,'String'));
    tfm_init_user_E{tfm_init_user_counter}=str2double(get(h_init(1).edit_youngs,'String'));
    tfm_init_user_nu{tfm_init_user_counter}=str2double(get(h_init(1).edit_poisson,'String'));
    tfm_init_user_area_factor=str2double(get(h_init(1).edit_area_factor,'String'));
    tfm_init_user_scale_factor{tfm_init_user_counter}=str2double(get(h_init(1).edit_scale_factor,'String'));
    tfm_init_user_cropcheck=get(h_init(1).checkbox_cropmask,'Value');
    
    %corresponding outline
    %calculate initial ellipse
    s = regionprops(bmask, 'Orientation', 'MajorAxisLength', ...
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
    
    %calculate new ellipse
    an=tfm_init_user_scale_factor{tfm_init_user_counter}*sqrt(tfm_init_user_area_factor)*a;
    bn=1/tfm_init_user_scale_factor{tfm_init_user_counter}*sqrt(tfm_init_user_area_factor)*b;
    xyn = [an*cosphi; bn*sinphi];
    xyn = R*xyn;
    xn = xyn(1,:) + xbar;
    yn = xyn(2,:) + ybar;
    
    %calculate mask around new ellipse
    image=tfm_init_user_binary1{tfm_init_user_counter};
    if tfm_init_user_cropcheck == 1
        am=tfm_init_user_croplength/(2*tfm_init_user_conversion{tfm_init_user_counter});
        bm=tfm_init_user_cropwidth/(2*tfm_init_user_conversion{tfm_init_user_counter});
        x1=xbar-am*cos(theta)+bm*sin(theta);
        x2=xbar-am*cos(theta)-bm*sin(theta);
        x3=xbar+am*cos(theta)-bm*sin(theta);
        x4=xbar+am*cos(theta)+bm*sin(theta);
        y1=ybar+am*sin(theta)+bm*cos(theta);
        y2=ybar+am*sin(theta)-bm*cos(theta);
        y3=ybar-am*sin(theta)-bm*cos(theta);
        y4=ybar-am*sin(theta)+bm*cos(theta);
        x_mask=[x1 x2 x3 x4 x1];
        y_mask=[y1 y2 y3 y4 y1];
        mask=poly2mask(x_mask,y_mask,size(image,1),size(image,2));
        tfm_init_user_binary3{tfm_init_user_counter}=mask;
        tfm_init_user_outline3x{tfm_init_user_counter}=x_mask;
        tfm_init_user_outline3y{tfm_init_user_counter}=y_mask;
    else
        tfm_init_user_binary3{tfm_init_user_counter}=logical(ones(size(image,1),size(image,2)));
        tfm_init_user_outline3x{tfm_init_user_counter}=[];
        tfm_init_user_outline3y{tfm_init_user_counter}=[];
    end
    
    %save dimensions
    tfm_init_user_major(tfm_init_user_counter)=2*a;
    tfm_init_user_minor(tfm_init_user_counter)=2*b;
    tfm_init_user_bf(tfm_init_user_counter)=s(1).Orientation;
    tfm_init_user_ratio(tfm_init_user_counter)=a/(b+eps);
    tfm_init_user_area(tfm_init_user_counter)=s(1).Area;
    tfm_init_user_area_ellipse(tfm_init_user_counter)=an*bn*pi;
    
    %save outlines
    BWoutline=bwboundaries(bmask);
    tfm_init_user_outline1x{tfm_init_user_counter}=BWoutline{1}(:,2);
    tfm_init_user_outline1y{tfm_init_user_counter}=BWoutline{1}(:,1);
    tfm_init_user_outline2x{tfm_init_user_counter}=xn;
    tfm_init_user_outline2y{tfm_init_user_counter}=yn;
    
    %display preview w. outlines
    cla(h_init(1).axes_curr)
    axes(h_init(1).axes_curr)
    imshow(tfm_init_user_preview_frame1{tfm_init_user_counter});hold on;
    plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
    plot(xn,yn,'b','LineWidth',2);
    plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
    hold off;
    
    %display bf preview w/ outlines
    cla(h_init(1).axes_bf)
    axes(h_init(1).axes_bf)
    imshow(cellimage);hold on;
    plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
    plot(xn,yn,'b','Linewidth',2);
    plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
    hold off;
    
    %save
    setappdata(0,'tfm_init_user_bf_filenamestack',tfm_init_user_bf_filenamestack)
    setappdata(0,'tfm_init_user_bf_pathnamestack',tfm_init_user_bf_pathnamestack)
    setappdata(0,'tfm_init_user_bf_vidext',tfm_init_user_bf_vidext)
    setappdata(0,'tfm_init_user_bf_preview_frame1',tfm_init_user_bf_preview_frame1)
    setappdata(0,'tfm_init_user_binary1',tfm_init_user_binary1)
    setappdata(0,'tfm_init_user_binary3',tfm_init_user_binary3)
    setappdata(0,'tfm_init_user_major',tfm_init_user_major)
    setappdata(0,'tfm_init_user_minor',tfm_init_user_minor)
    setappdata(0,'tfm_init_user_angle',tfm_init_user_angle);
    setappdata(0,'tfm_init_user_ratio',tfm_init_user_ratio)
    setappdata(0,'tfm_init_user_area',tfm_init_user_area)
    setappdata(0,'tfm_init_user_area_ellipse',tfm_init_user_area_ellipse)
    setappdata(0,'tfm_init_user_outline1x',tfm_init_user_outline1x)
    setappdata(0,'tfm_init_user_outline1y',tfm_init_user_outline1y)
    setappdata(0,'tfm_init_user_outline2x',tfm_init_user_outline2x)
    setappdata(0,'tfm_init_user_outline2y',tfm_init_user_outline2y)
    setappdata(0,'tfm_init_user_outline3x',tfm_init_user_outline3x)
    setappdata(0,'tfm_init_user_outline3y',tfm_init_user_outline3y)
    setappdata(0,'tfm_init_user_croplength',tfm_init_user_croplength)
    setappdata(0,'tfm_init_user_cropwidth',tfm_init_user_cropwidth)
    setappdata(0,'tfm_init_user_E',tfm_init_user_E)
    setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
    setappdata(0,'tfm_init_user_area_factor',tfm_init_user_area_factor)
    setappdata(0,'tfm_init_user_scale_factor',tfm_init_user_scale_factor)
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

function init_push_auto_draw(hObject, eventdata, h_init)

%profile on

%disable figure during calculation
enableDisableFig(h_init(1).fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_init(1).fig,1));

try
    %load shared data
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_bf_filenamestack=getappdata(0,'tfm_init_user_bf_filenamestack');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_counter=getappdata(0,'tfm_init_user_counter');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary3=getappdata(0,'tfm_init_user_binary3');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_major=getappdata(0,'tfm_init_user_major');
    tfm_init_user_minor=getappdata(0,'tfm_init_user_minor');
    tfm_init_user_angle=getappdata(0,'tfm_init_user_angle');
    tfm_init_user_ratio=getappdata(0,'tfm_init_user_ratio');
    tfm_init_user_area=getappdata(0,'tfm_init_user_area');
    tfm_init_user_area_ellipse=getappdata(0,'tfm_init_user_area_ellipse');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_croplength=getappdata(0,'tfm_init_user_croplength');
    tfm_init_user_cropwidth=getappdata(0,'tfm_init_user_cropwidth');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    
    %read new mask parameters
    tfm_init_user_conversion{tfm_init_user_counter}=str2double(get(h_init(1).edit_conversion,'String'));
    tfm_init_user_croplength=str2double(get(h_init(1).edit_croplength,'String'));
    tfm_init_user_cropwidth=str2double(get(h_init(1).edit_cropwidth,'String'));
    tfm_init_user_E{tfm_init_user_counter}=str2double(get(h_init(1).edit_youngs,'String'));
    tfm_init_user_nu{tfm_init_user_counter}=str2double(get(h_init(1).edit_poisson,'String'));
    tfm_init_user_area_factor=str2double(get(h_init(1).edit_area_factor,'String'));
    tfm_init_user_scale_factor{tfm_init_user_counter}=str2double(get(h_init(1).edit_scale_factor,'String'));
    tfm_init_user_cropcheck=get(h_init(1).checkbox_cropmask,'value');
    
    
    %check if bf images loaded
    if isempty(tfm_init_user_bf_filenamestack)
        sb = statusbar(h_init(1).fig,'No bf images loaded');
        sb.getComponent(0).setForeground(java.awt.Color.red);
    else
        
        axes(h_init(1).axes_curr)
        
        %auto-draw cell outlines
        for ivid=1:tfm_init_user_Nfiles
            
            %status bar
            sb = statusbar(h_init(1).fig,['Calculating outlines... ',num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)),'%% done']);
            sb.getComponent(0).setForeground(java.awt.Color.red);
            
            %check for bf image
            if size(tfm_init_user_bf_filenamestack,2) < ivid
            elseif isempty(tfm_init_user_bf_filenamestack{ivid})
            elseif ~isempty(tfm_init_user_bf_filenamestack{ivid})
                
                %show next images
                cla(h_init(1).axes_bf)
                axes(h_init(1).axes_bf)
                imshow(tfm_init_user_bf_preview_frame1{ivid});hold on;
                
                cla(h_init(1).axes_curr)
                axes(h_init(1).axes_curr)
                
                pxscaling = 1.8;%1.8 was initial default value || adapt for image quality
                %enhance contrast
                %se = strel('disk',floor(1*pxscaling/tfm_init_user_conversion{ivid}));
                %I_th = imtophat(tfm_init_user_bf_preview_frame1{ivid},se);
                %imshow(I_th)
                I_eq=adapthisteq(tfm_init_user_bf_preview_frame1{ivid});%I_th);
                imshow(I_eq)
                %filter noise
                DoS = 6*std2(imcrop(I_eq,[0, 0, 50 50]))^2;
                I_filt = imbilatfilt(I_eq,DoS,floor(pxscaling/tfm_init_user_conversion{ivid}));%Requires Matlab 2018
                %[~,noise]=wiener2(I_eq,[floor(pxscaling/tfm_init_user_conversion{ivid}) floor(pxscaling/tfm_init_user_conversion{ivid})]);
                %I_filt=wiener2(I_eq,[floor(pxscaling/tfm_init_user_conversion{ivid}) floor(pxscaling/tfm_init_user_conversion{ivid})],noise*2);
                %I_filt=imgaussfilt(I_filt);
                imshow(I_filt)
                
                %find edges
                [~,threshold] = edge(I_filt,'canny')
                BW = edge(I_filt,'canny',[0.001 0.5]);%[.02,.3]);
                imshow(BW)
                
                %dilate and fill holes
                BW2=imdilate(BW,strel('disk',floor(1.5/tfm_init_user_conversion{ivid})));
                imshow(BW2)
                BW3=imfill(BW2,'holes');
                imshow(BW3)
                
                %smoothen
                seD = strel('diamond',ceil(0.5/tfm_init_user_conversion{ivid}));
                BW4 = imerode(BW3,seD);
                BW4 = imerode(BW4,seD);
                %BW4=imerode(BW3,strel('disk',ceil(1.4/tfm_init_user_conversion{ivid})));
                imshow(BW4)
                
                %filter regions by area keeping only large objects
                BW4=bwareaopen(BW4,1000);
                imshow(BW4)
                
                %Filling the convex shape to capture running edge in  low
                %contract area
                BW4=bwconvhull(BW4,'objects');
                imshow(BW4)
                
                %define centerline to automate cell selection in the center of
                %the image
                %c=ones(1,51);
                %c=(size(tfm_init_user_bf_preview_frame1{ivid},2)/2)*c;
                %r=(size(tfm_init_user_bf_preview_frame1{ivid},1)/2-25):(size(tfm_init_user_bf_preview_frame1{ivid},1)/2+25);
                %select center cell
                %BW=bwselect(BW,c,r,8);
                
                %Select cell to outline manually
                axes(h_init(1).axes_curr)
                enableDisableFig(h_init(1).axes_curr,1);
                BW5=bwselect(BW4,8);
                enableDisableFig(h_init(1).axes_curr,0);
                
                
                
                %refine edges again using Chan-Vese method
                BW6=activecontour(I_eq,BW5,100,'Chan-Vese','SmoothFactor',3);%,'ContractionBias',-.3);
                %BW8=activecontour(I_filt,BW7,10,'edge','SmoothFactor',3,'ContractionBias',-.1);
                imshow(BW6)
                
                %smooth edges
                BW7=imerode(BW6,strel('disk',floor(2.0/tfm_init_user_conversion{ivid})));
                imshow(BW7)
                BW8=imdilate(BW7,strel('disk',floor(1.8/tfm_init_user_conversion{ivid})));
                imshow(BW8)
                
                BWCC = bwconncomp(BW8);
                if BWCC.NumObjects >1
                    BW8=bwconvhull(BW8);
                    imshow(BW8)
                end
                if BWCC.NumObjects == 0
                    BW8(ceil(end/2),ceil(end/2))=1;
                    imshow(BW8)
                end
                
                %save mask + outline
                tfm_init_user_binary1{ivid}=BW8;
                BWoutline=bwboundaries(BW8);
                
                if ~isempty(BWoutline)
                    tfm_init_user_outline1x{ivid}=BWoutline{1}(:,2);
                    tfm_init_user_outline1y{ivid}=BWoutline{1}(:,1);
                else
                    tfm_init_user_outline1x{ivid}=[];
                    tfm_init_user_outline1y{ivid}=[];
                end
                
                axes(h_init(1).axes_bf)
                plot(tfm_init_user_outline1x{ivid},tfm_init_user_outline1y{ivid},'r','LineWidth',2);
                hold off;
                
            end
        end
        
        
        sb=statusbar(h_init(1).fig,'Done !');
        sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
        
        %calculate cell dimensions
        for ivid=1:tfm_init_user_Nfiles
            
            sb = statusbar(h_init(1).fig,['Calculating cell dimensions... ',num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)),'%% done']);
            sb.getComponent(0).setForeground(java.awt.Color.red);
            
            %check if outline exists
            if ~isempty(tfm_init_user_outline1x{ivid})
                s = regionprops(tfm_init_user_binary1{ivid}, 'Orientation', 'MajorAxisLength', ...
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
                
                %calculate new ellipse
                an=tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*a;
                bn=1/tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*b;
                xyn = [an*cosphi; bn*sinphi];
                xyn = R*xyn;
                xn = xyn(1,:) + xbar;
                yn = xyn(2,:) + ybar;
                
                %calculate crop mask
                image=tfm_init_user_binary1{ivid};
                if tfm_init_user_cropcheck == 1
                    am=tfm_init_user_croplength/(2*tfm_init_user_conversion{ivid});
                    bm=tfm_init_user_cropwidth/(2*tfm_init_user_conversion{ivid});
                    x1=xbar-am*cos(theta)+bm*sin(theta);
                    x2=xbar-am*cos(theta)-bm*sin(theta);
                    x3=xbar+am*cos(theta)-bm*sin(theta);
                    x4=xbar+am*cos(theta)+bm*sin(theta);
                    y1=ybar+am*sin(theta)+bm*cos(theta);
                    y2=ybar+am*sin(theta)-bm*cos(theta);
                    y3=ybar-am*sin(theta)-bm*cos(theta);
                    y4=ybar-am*sin(theta)+bm*cos(theta);
                    x_mask=[x1 x2 x3 x4 x1];
                    y_mask=[y1 y2 y3 y4 y1];
                    mask=poly2mask(x_mask,y_mask,size(image,1),size(image,2));
                    tfm_init_user_binary3{ivid}=mask;
                    tfm_init_user_outline3x{ivid}=x_mask;
                    tfm_init_user_outline3y{ivid}=y_mask;
                else
                    tfm_init_user_binary3{ivid}=logical(ones(size(image,1),size(image,2)));
                    tfm_init_user_outline3x{ivid}=[];
                    tfm_init_user_outline3y{ivid}=[];
                end
                
                %save dimensions
                tfm_init_user_major(ivid)=2*a;
                tfm_init_user_minor(ivid)=2*b;
                tfm_init_user_angle(ivid)=s(1).Orientation;
                tfm_init_user_ratio(ivid)=a/(b+eps);
                tfm_init_user_area(ivid)=s(1).Area;
                tfm_init_user_area_ellipse(ivid)=an*bn*pi;
                
                %save outlines
                tfm_init_user_outline2x{ivid}=xn;
                tfm_init_user_outline2y{ivid}=yn;
                
            else
            end
            
        end
        
        sb=statusbar(h_init(1).fig,'Done !');
        sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
        
        %display tfm preview w/ outlines
        cla(h_init(1).axes_curr)
        axes(h_init(1).axes_curr)
        imshow(tfm_init_user_preview_frame1{tfm_init_user_counter});hold on;
        plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
        plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
        plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
        hold off;
        
        %display bf preview w/ outlines
        cla(h_init(1).axes_bf)
        axes(h_init(1).axes_bf)
        imshow(tfm_init_user_bf_preview_frame1{tfm_init_user_counter});hold on;
        plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
        plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
        plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
        hold off;
        
    end
    
    %save things
    setappdata(0,'tfm_init_user_binary1',tfm_init_user_binary1)
    setappdata(0,'tfm_init_user_binary3',tfm_init_user_binary3)
    setappdata(0,'tfm_init_user_outline1x',tfm_init_user_outline1x)
    setappdata(0,'tfm_init_user_outline1y',tfm_init_user_outline1y)
    setappdata(0,'tfm_init_user_outline2x',tfm_init_user_outline2x)
    setappdata(0,'tfm_init_user_outline2y',tfm_init_user_outline2y)
    setappdata(0,'tfm_init_user_outline3x',tfm_init_user_outline3x)
    setappdata(0,'tfm_init_user_outline3y',tfm_init_user_outline3y)
    setappdata(0,'tfm_init_user_major',tfm_init_user_major)
    setappdata(0,'tfm_init_user_minor',tfm_init_user_minor)
    setappdata(0,'tfm_init_user_minor',tfm_init_user_minor);
    setappdata(0,'tfm_init_user_ratio',tfm_init_user_ratio)
    setappdata(0,'tfm_init_user_area',tfm_init_user_area)
    setappdata(0,'tfm_init_user_area_ellipse',tfm_init_user_area_ellipse)
    setappdata(0,'tfm_init_user_croplength',tfm_init_user_croplength)
    setappdata(0,'tfm_init_user_cropwidth',tfm_init_user_cropwidth)
    setappdata(0,'tfm_init_user_E',tfm_init_user_E)
    setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
    setappdata(0,'tfm_init_user_area_factor',tfm_init_user_area_factor)
    setappdata(0,'tfm_init_user_scale_factor',tfm_init_user_scale_factor)
    
catch
    %     % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','on'));
    
end

%profile viewer

function init_push_update(hObject, eventdata, h_init)
%disable figure during calculation
enableDisableFig(h_init(1).fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_init(1).fig,1));
try
    %load shared
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_counter=getappdata(0,'tfm_init_user_counter');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary3=getappdata(0,'tfm_init_user_binary3');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_major=getappdata(0,'tfm_init_user_major');
    tfm_init_user_minor=getappdata(0,'tfm_init_user_minor');
    tfm_init_user_ratio=getappdata(0,'tfm_init_user_ratio');
    tfm_init_user_area=getappdata(0,'tfm_init_user_area');
    tfm_init_user_area_ellipse=getappdata(0,'tfm_init_user_area_ellipse');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    tfm_init_user_cropcheck=get(h_init(1).checkbox_cropmask,'Value');
    %read mask parameters
    tfm_init_user_conversion{tfm_init_user_counter}=str2double(get(h_init(1).edit_conversion,'String'));
    tfm_init_user_croplength=str2double(get(h_init(1).edit_croplength,'String'));
    tfm_init_user_cropwidth=str2double(get(h_init(1).edit_cropwidth,'String'));
    tfm_init_user_E{tfm_init_user_counter}=str2double(get(h_init(1).edit_youngs,'String'));
    tfm_init_user_nu{tfm_init_user_counter}=str2double(get(h_init(1).edit_poisson,'String'));
    tfm_init_user_area_factor=str2double(get(h_init(1).edit_area_factor,'String'));
    tfm_init_user_scale_factor{tfm_init_user_counter}=str2double(get(h_init(1).edit_scale_factor,'String'));
    tfm_init_user_rotate=getappdata(0,'tfm_init_user_rotate');
    
    %loop over all videos
    for ivid=1:tfm_init_user_Nfiles
        
        %check for outline
        if ~isempty(tfm_init_user_outline1x{ivid})
            
            %calculate initial ellipse
            s = regionprops(tfm_init_user_binary1{ivid}, 'Orientation', 'MajorAxisLength', ...
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
            an=tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*a;
            bn=1/tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*b;
            xyn = [an*cosphi; bn*sinphi];
            xyn = R*xyn;
            xn = xyn(1,:) + xbar;
            yn = xyn(2,:) + ybar;
            
            %calculate cropmask
            image=tfm_init_user_binary1{ivid};
            
            if tfm_init_user_cropcheck == 1
                am=tfm_init_user_croplength/(2*tfm_init_user_conversion{ivid});
                bm=tfm_init_user_cropwidth/(2*tfm_init_user_conversion{ivid});
                x1=xbar-am*cos(theta)+bm*sin(theta);
                x2=xbar-am*cos(theta)-bm*sin(theta);
                x3=xbar+am*cos(theta)-bm*sin(theta);
                x4=xbar+am*cos(theta)+bm*sin(theta);
                y1=ybar+am*sin(theta)+bm*cos(theta);
                y2=ybar+am*sin(theta)-bm*cos(theta);
                y3=ybar-am*sin(theta)-bm*cos(theta);
                y4=ybar-am*sin(theta)+bm*cos(theta);
                x_mask=[x1 x2 x3 x4 x1];
                y_mask=[y1 y2 y3 y4 y1];
                mask=poly2mask(x_mask,y_mask,size(image,1),size(image,2));
                if ~tfm_init_user_rotate(ivid)
                    mask_info = regionprops(mask,'BoundingBox');
                    x_mask = [mask_info.BoundingBox(1,1) mask_info.BoundingBox(1,1)+mask_info.BoundingBox(1,3) mask_info.BoundingBox(1,1)+mask_info.BoundingBox(1,3) mask_info.BoundingBox(1,1) mask_info.BoundingBox(1,1)];
                    y_mask = [mask_info.BoundingBox(1,2) mask_info.BoundingBox(1,2) mask_info.BoundingBox(1,2)+mask_info.BoundingBox(1,4) mask_info.BoundingBox(1,2)+mask_info.BoundingBox(1,4) mask_info.BoundingBox(1,2)];
                    mask = poly2mask(x_mask,y_mask,size(image,1),size(image,2));
                end
                tfm_init_user_binary3{ivid}=mask;
                tfm_init_user_outline3x{ivid}=x_mask;
                tfm_init_user_outline3y{ivid}=y_mask;
            else
                tfm_init_user_binary3{ivid}=logical(ones(size(image,1),size(image,2)));
                tfm_init_user_outline3x{ivid}=[];
                tfm_init_user_outline3y{ivid}=[];
            end
            %save new outlines
            tfm_init_user_outline2x{ivid}=xn;
            tfm_init_user_outline2y{ivid}=yn;
        else
        end
    end
    
    %display preview w. outlines
    cla(h_init(1).axes_curr)
    axes(h_init(1).axes_curr)
    imshow(tfm_init_user_preview_frame1{tfm_init_user_counter});hold on;
    plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
    plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
    plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
    hold off;
    
    %display bf preview w/ outlines
    cla(h_init(1).axes_bf)
    axes(h_init(1).axes_bf)
    imshow(tfm_init_user_bf_preview_frame1{tfm_init_user_counter});hold on;
    plot(tfm_init_user_outline1x{tfm_init_user_counter},tfm_init_user_outline1y{tfm_init_user_counter},'r','LineWidth',2);
    plot(tfm_init_user_outline2x{tfm_init_user_counter},tfm_init_user_outline2y{tfm_init_user_counter},'b','LineWidth',2);
    plot(tfm_init_user_outline3x{tfm_init_user_counter},tfm_init_user_outline3y{tfm_init_user_counter},'g','LineWidth',2);
    hold off;
    
    %save
    setappdata(0,'tfm_init_user_area_factor',tfm_init_user_area_factor)
    setappdata(0,'tfm_init_user_scale_factor',tfm_init_user_scale_factor)
    setappdata(0,'tfm_init_user_binary3',tfm_init_user_binary3)
    setappdata(0,'tfm_init_user_major',tfm_init_user_major)
    setappdata(0,'tfm_init_user_minor',tfm_init_user_minor)
    setappdata(0,'tfm_init_user_ratio',tfm_init_user_ratio)
    setappdata(0,'tfm_init_user_area',tfm_init_user_area)
    setappdata(0,'tfm_init_user_area_ellipse',tfm_init_user_area_ellipse)
    setappdata(0,'tfm_init_user_outline1x',tfm_init_user_outline1x)
    setappdata(0,'tfm_init_user_outline1y',tfm_init_user_outline1y)
    setappdata(0,'tfm_init_user_outline2x',tfm_init_user_outline2x)
    setappdata(0,'tfm_init_user_outline2y',tfm_init_user_outline2y)
    setappdata(0,'tfm_init_user_outline3x',tfm_init_user_outline3x)
    setappdata(0,'tfm_init_user_outline3y',tfm_init_user_outline3y)
    setappdata(0,'tfm_init_user_croplength',tfm_init_user_croplength)
    setappdata(0,'tfm_init_user_cropwidth',tfm_init_user_cropwidth)
    setappdata(0,'tfm_init_user_E',tfm_init_user_E)
    setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

function init_update_field(hObject, eventdata, h_init, field)
%disable fig
enableDisableFig(h_init(1).fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_init(1).fig,1));
try
    
    %load, update, and save shared para
    tfm_init_user_counter=getappdata(0,'tfm_init_user_counter');
    if strcmp(field, 'fps')
        tfm_init_user_framerate=getappdata(0, 'tfm_init_user_framerate');
        tfm_init_user_framerate{tfm_init_user_counter} = str2double(get(h_init(1).edit_fps,'String'));
        setappdata(0, 'tfm_init_user_framerate', tfm_init_user_framerate);
    elseif strcmp(field, 'conversion')
        tfm_init_user_conversion=getappdata(0, 'tfm_init_user_conversion');
        tfm_init_user_conversion{tfm_init_user_counter} = str2double(get(h_init(1).edit_conversion,'String'));
        setappdata(0, 'tfm_init_user_conversion', tfm_init_user_conversion)
    elseif strcmp(field, 'nframes')
        tfm_init_user_Nframes=getappdata(0, 'tfm_init_user_Nframes');
        tfm_init_user_Nframes{tfm_init_user_counter} = str2double(get(h_init(1).edit_nframes,'String'));
        setappdata(0, 'tfm_init_user_Nframes', tfm_init_user_Nframes)
    elseif strcmp(field, 'cellname')
        tfm_init_user_cellname=getappdata(0, 'tfm_init_user_cellname');
        tfm_init_user_cellname{tfm_init_user_counter} = get(h_init(1).edit_cellname,'String');
        setappdata(0, 'tfm_init_user_cellname', tfm_init_user_cellname)
    elseif strcmp(field, 'croplength')
        tfm_init_user_croplength = str2double(get(h_init(1).edit_croplength,'String'));
        setappdata(0, 'tfm_init_user_croplength', tfm_init_user_croplength)
    elseif strcmp(field, 'cropwidth')
        tfm_init_user_cropwidth = str2double(get(h_init(1).edit_cropwidth,'String'));
        setappdata(0, 'tfm_init_user_cropwidth', tfm_init_user_cropwidth)
    elseif strcmp(field, 'youngs')
        tfm_init_user_E=getappdata(0, 'tfm_init_user_E');
        tfm_init_user_E{tfm_init_user_counter} = get(h_init(1).edit_youngs,'String');
        setappdata(0, 'tfm_init_user_E', tfm_init_user_E)
    elseif strcmp(field, 'poisson')
        tfm_init_user_nu=getappdata(0, 'tfm_init_user_nu');
        tfm_init_user_nu{tfm_init_user_counter} = get(h_init(1).edit_poisson,'String');
        setappdata(0, 'tfm_init_user_nu', tfm_init_user_nu)
    elseif strcmp(field, 'area_factor')
        tfm_init_user_area_factor = get(h_init(1).edit_area_factor,'String');
        setappdata(0, 'tfm_init_user_area_factor', tfm_init_user_area_factor)
    elseif strcmp(field, 'scale_factor')
        tfm_init_user_scale_factor=getappdata(0, 'tfm_init_user_scale_factor');
        tfm_init_user_scale_factor{tfm_init_user_counter} = get(h_init(1).edit_scale_factor,'String');
        setappdata(0, 'tfm_init_user_scale_factor', tfm_init_user_scale_factor)
    elseif strcmp(field, 'rotate')
        tfm_init_user_rotate=getappdata(0, 'tfm_init_user_rotate');
        tfm_init_user_rotate(tfm_init_user_counter) = get(h_init(1).checkbox_rotate,'value');
        setappdata(0, 'tfm_init_user_rotate', tfm_init_user_rotate)
    end
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

function init_update_bin(~, ~, h_init)

%if checkbox is true, warn that no sarcomere analysis is possible
if get(h_init(1).checkbox_bin,'Value')
    tfm_gui_call_piv_flag = getappdata(0,'tfm_gui_call_piv_flag');
    if ~tfm_gui_call_piv_flag
        
        figuresize=[40,450];
        screensize=get(0,'ScreenSize');
        xpos = ceil((screensize(3)-figuresize(2))/2);
        ypos = ceil((screensize(4)-figuresize(1))/2);
        %create figure
        disablesarcoWarning.fig=figure(...
            'position',[xpos, ypos, figuresize(2), figuresize(1)],...
            'units','pixels',...
            'renderer','OpenGL',...
            'MenuBar','none',...
            'PaperPositionMode','auto',...
            'Name','Warning',...
            'NumberTitle','off',...
            'Resize','off',...
            'Color','w',...
            'Visible','off');
        annotation('textbox',[0.1 0.1 0.8 0.8], 'String', 'If binning is performed, sarcomere analysis is not possible', 'FitBoxToText', 'on', 'LineStyle', 'none');
        disablesarcoWarning.fig.Visible='on';
        waitfor(disablesarcoWarning.fig);
    end
    %set app data
    setappdata(0, 'IntraX_sarco_possible',false);
else
    setappdata(0, 'IntraX_sarco_possible',true);
end

function init_push_ok_strln(hObject, eventdata, h_init,h_main)

figuresize=[80,350];
screensize=get(0,'ScreenSize');
xpos = ceil((screensize(3)-figuresize(2))/2);
ypos = ceil((screensize(4)-figuresize(1))/2);
%create figure
disablesarcoWarning.fig=figure(...
    'position',[xpos, ypos, figuresize(2), figuresize(1)],...
    'units','pixels',...
    'renderer','OpenGL',...
    'MenuBar','none',...
    'PaperPositionMode','auto',...
    'Name','Warning',...
    'NumberTitle','off',...
    'Resize','off',...
    'Color','w',...
    'Visible','off');
annotation('textbox',[0.1 0.1 0.8 0.8], 'String', {'Warning: The analysis will proceed with default parameters', '(unless changed in the code) and only stop once at the end', 'of the beads displacement step, and then at the results panel.'}, 'FitBoxToText', 'on', 'LineStyle', 'none');
disablesarcoWarning.fig.Visible='on';
waitfor(disablesarcoWarning.fig);

tfm_init_user_strln = true;
setappdata(0,'tfm_init_user_strln',tfm_init_user_strln);
init_push_ok(hObject, eventdata, h_init,h_main);

function init_push_ok(hObject, eventdata, h_init,h_main)

%profile on
%userTiming= getappdata(0,'userTiming');
%userTiming.init{2} = toc(userTiming.init{1});
%userTiming.init2piv{1} = tic;

%disable figure during calculation
enableDisableFig(h_init(1).fig,0);

%turn back on in the end
%clean1=onCleanup(@()enableDisableFig(h_init(1).fig,1));

try
    
    %load what shared para we need
    tfm_init_user_strln = getappdata(0,'tfm_init_user_strln');
    tfm_gui_call_piv_flag = getappdata(0,'tfm_gui_call_piv_flag');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_Nframes_bf=getappdata(0,'tfm_init_user_Nframes_bf');
    tfm_init_user_imsize_m=getappdata(0,'tfm_init_user_imsize_m');
    tfm_init_user_imsize_n=getappdata(0,'tfm_init_user_imsize_n');
    tfm_init_user_cellname=getappdata(0,'tfm_init_user_cellname');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_vidext=getappdata(0,'tfm_init_user_vidext');
    tfm_init_user_bf_filenamestack=getappdata(0,'tfm_init_user_bf_filenamestack');
    tfm_init_user_bf_pathnamestack=getappdata(0,'tfm_init_user_bf_pathnamestack');
    tfm_init_user_bf_vidext=getappdata(0,'tfm_init_user_bf_vidext');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_major=getappdata(0,'tfm_init_user_major');
    tfm_init_user_minor=getappdata(0,'tfm_init_user_minor');
    tfm_init_user_angle=getappdata(0,'tfm_init_user_angle');
    tfm_init_user_ratio=getappdata(0,'tfm_init_user_ratio');
    tfm_init_user_area=getappdata(0,'tfm_init_user_area');
    tfm_init_user_area_ellipse=getappdata(0,'tfm_init_user_area_ellipse');
    tfm_init_user_counter=getappdata(0,'tfm_init_user_counter');
    tfm_init_user_area_factor=getappdata(0,'tfm_init_user_area_factor');
    tfm_init_user_scale_factor=getappdata(0,'tfm_init_user_scale_factor');
    tfm_init_user_preview_frame1=getappdata(0,'tfm_init_user_preview_frame1');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_outline1x=getappdata(0,'tfm_init_user_outline1x');
    tfm_init_user_outline1y=getappdata(0,'tfm_init_user_outline1y');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_init_user_outline3x=getappdata(0,'tfm_init_user_outline3x');
    tfm_init_user_outline3y=getappdata(0,'tfm_init_user_outline3y');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary2=getappdata(0,'tfm_init_user_binary2');
    tfm_init_user_binary3=getappdata(0,'tfm_init_user_binary3');
    tfm_init_user_rotate=getappdata(0,'tfm_init_user_rotate');
    multichannelczi = getappdata(0,'multichannelczi');
    
    %compatibility with sarcomere analysis
    if isempty(tfm_gui_call_piv_flag)
        tfm_gui_call_piv_flag = true;
    end
    
    %fix conversion scaling on major axis, minor axis, roi area, and ellipse area
    for ivid = 1:tfm_init_user_Nfiles
        tfm_init_user_major(ivid) = tfm_init_user_major(ivid)*tfm_init_user_conversion{ivid};
        tfm_init_user_minor(ivid) = tfm_init_user_minor(ivid)*tfm_init_user_conversion{ivid};
        tfm_init_user_area(ivid) = tfm_init_user_area(ivid)*(tfm_init_user_conversion{ivid})^2;
        tfm_init_user_area_ellipse(ivid) = tfm_init_user_area_ellipse(ivid)*(tfm_init_user_conversion{ivid})^2;
    end
    %loop over vids, and extract data
    for j=1:tfm_init_user_Nfiles
        %update statusbar
        if tfm_init_user_Nfiles==1
            sb=statusbar(h_init(1).fig,'Importing... ');
            sb.getComponent(0).setForeground(java.awt.Color.red);
        else
            sb=statusbar(h_init(1).fig,['Importing... ',num2str(floor(100*(j-1)/tfm_init_user_Nfiles)), '%% done']);
            sb.getComponent(0).setForeground(java.awt.Color.red);
        end
        
        %check format, load and save:
        if strcmp(tfm_init_user_vidext{1,j},'.czi')
            %use bioformats for import
            [~,data]=evalc('bfopen([tfm_init_user_pathnamestack{1,j},tfm_init_user_filenamestack{1,j},tfm_init_user_vidext{1,j}]);');
            metadata = data{1, 2};
            tincrement=str2double(metadata.get('Global Information|Image|T|Interval|Increment #1'));
            tfm_init_user_framerate{j}=1/tincrement;
            set(h_init(1).edit_fps,'String',num2str(tfm_init_user_framerate{j}));
            % check for image stack
            info = data{1, 1}{1, 2};
            Nchannels = 1;
            channels = extractAfter(info, 'C=');
            if ~(channels == "")
                channels = split(channels, '/', 1);
                Nchannels = str2num(channels{2, 1}(1));
            end
            
            N = 1;
            time_series = extractAfter(info, 'T=');
            if ~(time_series == "")
                time_series = split(time_series, '/', 1);
                N = str2num(time_series{2, 1});
            end
            images=data{1,1}; %images
            m = size(images{1,1},1);
            n = size(images{1,1},2);
            
            % initialize image stack
            image_stack = zeros(m,n,N,'uint8');
            TFMChannel = getappdata(0, 'TFMChannel');
            %save images in variable
            start_frame = 0;
            if get(h_init(1).checkbox_trim, 'value')
                start_frame = 1;
            end
            parfor i = start_frame:N-1
                index = TFMChannel + Nchannels*i;
                imagei=images{index,1};
                %convert to grey
                if ndims(imagei) == 3
                    imagei=rgb2gray(imagei);
                end
                imagei=normalise(imagei);
                imagei=im2uint8(imagei);
                image_stack(:,:,i+1) = imagei;
                %save to mat
                %save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,j},'/image',num2str(i),'.mat'],'imagei','-v7.3')
            end
            if start_frame == 1
                image_stack = image_stack(:,:,2:end);
            end
            %save to mat
            save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,j},'/image_stack.mat'],'image_stack','-v7.3')
            
            BFChannel = getappdata(0, 'BFChannel');
            if multichannelczi && BFChannel <= Nchannels %also load bf frames
                [~,data]=evalc('bfopen([tfm_init_user_bf_pathnamestack{1,j},tfm_init_user_bf_filenamestack{1,j},tfm_init_user_bf_vidext{1,j}]);');
                images=data{1,1}; %images
                image_stack = zeros(m,n,N,'uint8');
                parfor ifr = start_frame:N-1
                    index = BFChannel + Nchannels*ifr;
                    imagei=images{index,1}; %i+1*Nchannels no longer needed as long as nuclear stain goes first
                    %convert to grey
                    if ndims(imagei) == 3
                        imagei=rgb2gray(imagei);
                    end
                    imagei=normalise(imagei);
                    imagei=im2uint8(imagei);
                    image_stack(:,:,ifr+1) = imagei;
                end
                if start_frame == 1
                    image_stack = image_stack(:,:,2:end);
                end
                %save to mat
                save(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{1,j},'/image_stack_bf.mat'],'image_stack','-v7.3');
                tfm_init_user_Nframes_bf{j} = size(image_stack,3);
            end
            
        elseif strcmp(tfm_init_user_vidext{1,j},'.tif')
            InfoImage=imfinfo([tfm_init_user_pathnamestack{1,j},tfm_init_user_filenamestack{1,j},tfm_init_user_vidext{1,j}]);
            N=length(InfoImage);
            %bit=InfoImage.BitDepth;
            TifLink = Tiff([tfm_init_user_pathnamestack{1,j},tfm_init_user_filenamestack{1,j},tfm_init_user_vidext{1,j}], 'r');
            
            % initialize image stack
            TifLink.setDirectory(1);
            imagei = TifLink.read();
            m = size(imagei,1);
            n = size(imagei,2);
            image_stack = zeros(m,n,N,'uint8');
            end_frame = N;
            if get(h_init(1).checkbox_trim, 'value')
                end_frame = N-1;
                TifLink.read(); %read past first frame
                image_stack = zeros(m,n,N-1,'uint8');
            end
            for i=1:end_frame
                TifLink.setDirectory(i);
                imagei=TifLink.read();
                %convert to grey
                if ndims(imagei) == 3
                    imagei=rgb2gray(imagei);
                end
                imagei=normalise(imagei);
                imagei=im2uint8(imagei);
                image_stack(:,:,i) = imagei;
                %save to mat
                %save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,j},'/image',num2str(i),'.mat'],'imagei','-v7.3')
            end
            TifLink.close();
            %save to mat
            save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,j},'/image_stack.mat'],'image_stack','-v7.3');
            
        elseif strcmp(tfm_init_user_vidext{1,j},'.avi')
            videoObj = VideoReader([tfm_init_user_pathnamestack{1,j},tfm_init_user_filenamestack{1,j},tfm_init_user_vidext{1,j}]);
            N = videoObj.NumberOfFrames;
            
            %initialize image stack
            imagei = read(videoObj,1);
            m = size(imagei,1);
            n = size(imagei,2);
            image_stack = zeros(m,n,N,'uint8');
            num_frames = N;
            if get(h_init(1).checkbox_trim, 'value')
                num_frames = N-1;
                image_stack = zeros(m,n,N-1,'uint8');
            end
            parfor i=1:num_frames
                if get(h_init(1).checkbox_trim, 'value')
                    imagei=read(videoObj, i+1);
                else
                    imagei=read(videoObj, i);
                end
                %convert to grey
                if ndims(imagei) == 3
                    imagei=rgb2gray(imagei);
                end
                imagei=normalise(imagei);
                imagei=im2uint8(imagei);
                image_stack(:,:,i) = imagei;
            end
            %save to mat
            save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,j},'/image_stack.mat'],'image_stack','-v7.3')
        end
        tfm_init_user_Nframes{j} = N;
        if get(h_init(1).checkbox_trim, 'value')
            tfm_init_user_Nframes{j} = N - 1;
        end
    end
    
    %save settings for current frame
    tfm_init_user_framerate{tfm_init_user_counter}=str2double(get(h_init(1).edit_fps,'String'));
    tfm_init_user_conversion{tfm_init_user_counter}=str2double(get(h_init(1).edit_conversion,'String'));
    tfm_init_user_cellname{tfm_init_user_counter}=get(h_init(1).edit_cellname,'String');
    tfm_init_user_area_factor=str2double(get(h_init(1).edit_area_factor,'String'));
    
    % set ncorr parameters
    tfm_init_user_subset_rad = 30;
    tfm_init_user_spacing_coeff = 10;%default for TFM with 40x obj
    if ~tfm_gui_call_piv_flag
        tfm_init_user_spacing_coeff = 5;%default for IntraX
        tfm_gui_call_piv_flag = true;
    end
    
    %first check: has user entered all the necessary info: fps,
    %conversion
    for ivid=1:tfm_init_user_Nfiles
        if ~isempty(find(isnan([tfm_init_user_framerate{:}]))) || ~isempty(find(isnan([tfm_init_user_conversion{:}])))
            errordlg('Please enter all the necessary values: frames per second and Conversion.','Error');
            enableDisableFig(h_init(1).fig,1)
            return;
        end
        
        %Save mask
        if ~isequal(exist([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Mask'], 'dir'),7)
            mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Mask'])
        end
        mask=tfm_init_user_binary1{ivid};
        save([tfm_init_user_pathnamestack{1,ivid},'/',tfm_init_user_filenamestack{1,ivid},'/Mask/',tfm_init_user_filenamestack{ivid},'_mask.mat'],'mask','-v7.3');%num2str(ivid) change to filename
        
    end
    
    % crop videos
    if get(h_init(1).checkbox_crop,'Value')
        %read crop parameters
        tfm_init_user_croplength=str2double(get(h_init(1).edit_croplength,'String'));
        tfm_init_user_cropwidth=str2double(get(h_init(1).edit_cropwidth,'String'));
        tfm_init_user_area_factor=str2double(get(h_init(1).edit_area_factor,'String'));
        
        % initialize rot_crop stacks
        bead_vid_crop = cell(tfm_init_user_Nfiles,1);
        bf_vid_crop = cell(tfm_init_user_Nfiles,1);
        mask_rot_crop = cell(tfm_init_user_Nfiles,1);
        
        % for loop over videos
        for ivid = 1:tfm_init_user_Nfiles
            
            % status bar
            sb = statusbar(h_init(1).fig,['Cropping videos... ',num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)),'%% done']);
            sb.getComponent(0).setForeground(java.awt.Color.red);
            
            % read mask parameters
            tfm_init_user_conversion{ivid}=str2double(get(h_init(1).edit_conversion,'String'));
            tfm_init_user_scale_factor{ivid}=str2double(get(h_init(1).edit_scale_factor,'String'));
            
            % get stack info
            %info = imfinfo([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'.tif']);
            height = tfm_init_user_imsize_m{ivid};%info(1).Width;
            width = tfm_init_user_imsize_n{ivid};%info(1).Height;
            N_frames = tfm_init_user_Nframes{ivid};%numel(info);
            %info = imfinfo([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'.tif']);
            bf_N_frames = tfm_init_user_Nframes_bf{ivid};%numel(info);
            
            % initialize movie stacks bead and bf
            bead_vid = zeros(height,width,N_frames);
            bead_vid = im2uint8(bead_vid);
            bf_vid = zeros(height,width,bf_N_frames);
            bf_vid = im2uint8(bf_vid);
            
            % load frames
            bead_frameN = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/image_stack.mat'],'image_stack');
            %            for i = 1:N_frames
            %bead_frameN = imread([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'.tif'],'tif',i);
            %if isa(bead_frameN,'uint8')
            %else
            %    bead_frameN = normalise(bead_frameN);
            %    bead_frameN = im2uint8(bead_frameN);
            %end
            %bead_vid(:,:,i) = bead_frameN;
            %           end
            bf_frameN = load(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{1,ivid},'/image_stack_bf.mat'],'image_stack');
            %          for i = 1:bf_N_frames
            %                 bf_frameN = imread([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'.tif'],'tif',i);
            %                 if isa(bf_frameN,'uint8')
            %                 else
            %                     bf_frameN = normalise(bf_frameN);
            %                     bf_frameN = im2uint8(bf_frameN);
            %                 end
            %bf_vid(:,:,i) = bf_frameN;
            %            end
            
            % get orientation
            init_stats = regionprops(tfm_init_user_binary1{ivid},'Orientation');
            angle = -init_stats(1).Orientation;
            
            % rotate bead/bf frames and mask
            if tfm_init_user_rotate(ivid)
                bead_vid = imrotate(bead_frameN.image_stack,angle,'bilinear');
                bf_vid = imrotate(bf_frameN.image_stack,angle,'bilinear');
                mask = imrotate(tfm_init_user_binary1{ivid},angle,'bilinear');
            else
                bead_vid = bead_frameN.image_stack;
                bf_vid = bf_frameN.image_stack;
                mask = tfm_init_user_binary1{ivid};
            end
            
            % get new regionprops
            rot_stats = regionprops(mask,'Centroid', 'Orientation');
            rot_centroid = uint16(rot_stats(1).Centroid);
            
            % calculate crop dimensions
            if tfm_init_user_rotate(ivid)
                crop_length = uint16(tfm_init_user_croplength/tfm_init_user_conversion{ivid});
                crop_width = uint16(tfm_init_user_cropwidth/tfm_init_user_conversion{ivid});
                xmin = rot_centroid(1)-crop_length/2;
                ymin = rot_centroid(2)-crop_width/2;
            else
                theta = pi*rot_stats.Orientation/180;
                am=tfm_init_user_croplength/(2*tfm_init_user_conversion{ivid});
                bm=tfm_init_user_cropwidth/(2*tfm_init_user_conversion{ivid});
                x1=rot_centroid(1)-am*cos(theta)+bm*sin(theta);
                x2=rot_centroid(1)-am*cos(theta)-bm*sin(theta);
                x3=rot_centroid(1)+am*cos(theta)-bm*sin(theta);
                x4=rot_centroid(1)+am*cos(theta)+bm*sin(theta);
                y1=rot_centroid(2)+am*sin(theta)+bm*cos(theta);
                y2=rot_centroid(2)+am*sin(theta)-bm*cos(theta);
                y3=rot_centroid(2)-am*sin(theta)-bm*cos(theta);
                y4=rot_centroid(2)-am*sin(theta)+bm*cos(theta);
                x_mask=double([x1 x2 x3 x4 x1]);
                y_mask=double([y1 y2 y3 y4 y1]);
                test_mask=poly2mask(x_mask,y_mask,size(mask,1),size(mask,2));
                mask_info = regionprops(test_mask,'BoundingBox');
                xmin = mask_info.BoundingBox(1,1);
                ymin = mask_info.BoundingBox(1,2);
                crop_length = mask_info.BoundingBox(1,3);
                crop_width = mask_info.BoundingBox(1,4);
            end
            % crop bead/bf frames and mask
            crop_out_w = size(imcrop(bead_vid(:,:,1),[xmin ymin crop_length crop_width]),2);
            crop_out_h = size(imcrop(bead_vid(:,:,1),[xmin ymin crop_length crop_width]),1);
            crop_vid = zeros(crop_out_h,crop_out_w,N_frames);
            crop_vid = im2uint8(crop_vid);
            for i = 1:N_frames
                crop_vid(:,:,i) = imcrop(bead_vid(:,:,i),[xmin ymin crop_length crop_width]);
            end
            bead_vid_crop{ivid} = crop_vid;
            
            crop_out_w = size(imcrop(bf_vid(:,:,1),[xmin ymin crop_length crop_width]),2);
            crop_out_h = size(imcrop(bf_vid(:,:,1),[xmin ymin crop_length crop_width]),1);
            crop_vid = zeros(crop_out_h,crop_out_w,N_frames);
            crop_vid = im2uint8(crop_vid);
            parfor i = 1:bf_N_frames
                crop_vid(:,:,i) = imcrop(bf_vid(:,:,i),[xmin ymin crop_length crop_width]);
            end
            bf_vid_crop{ivid} = crop_vid;
            
            mask_rot_crop{ivid} = imcrop(mask,[xmin ymin crop_length crop_width]);
            
            % create new directory
            if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_cropped'], 'dir'),7)
                rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_cropped'],'s')
            end
            mkdir(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_cropped'])
            % create new directory
            if strcmp(tfm_init_user_filenamestack{ivid}, tfm_init_user_bf_filenamestack{ivid}) == 0
                if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid},'_cropped'], 'dir'),7)
                    rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid},'_cropped'],'s')
                end
                mkdir(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid},'_cropped'])
            end
            
            % check for old cropped files and delete
            if exist([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'_cropped.tif'],'file') == 2
                delete([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'_cropped.tif'])
            end
            if exist([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'_cropped_bf.tif'],'file') == 2
                delete([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'_cropped_bf.tif'])
            end
            
            % save new .tif files
            for i = 1:N_frames
                imwrite(bead_vid_crop{ivid}(:,:,i),[tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'_cropped.tif'],'writemode','append');
            end
            for i = 1:bf_N_frames
                imwrite(bf_vid_crop{ivid}(:,:,i),[tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'_cropped_bf.tif'],'writemode','append');
            end
            
            % save new .mat files
            image_stack = zeros(size(bead_vid_crop{ivid}));
            parfor i = 1:N_frames
                imagei = normalise(bead_vid_crop{ivid}(:,:,i));
                image_stack(:,:,i) = imagei;
                % save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_cropped','/image',num2str(i),'.mat'],'imagei','-v7.3')
            end
            save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_cropped','/image_stack.mat'],'image_stack','-v7.3')
            % save new bf .mat files
            image_stack = zeros(size(bf_vid_crop{ivid}));
            parfor i = 1:bf_N_frames
                imagei = normalise(bf_vid_crop{ivid}(:,:,i));
                image_stack(:,:,i) = imagei;
                % save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_cropped','/image',num2str(i),'.mat'],'imagei','-v7.3')
            end
            save(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid},'_cropped','/image_stack_bf.mat'],'image_stack','-v7.3')
            
            % clear temp vids
            bead_frameN.image_stack = [];
            bf_frameN.image_stack = [];
            bead_vid = [];
            bf_vid = [];
            image_stack = [];
            % bead_vid_crop{ivid} = [];
            % bf_vid_crop{ivid} = [];
        end
        
        %update statusbar
        sb=statusbar(h_init(1).fig,'Saving cropped videos...');
        sb.getComponent(0).setForeground(java.awt.Color.red);
        
        % for loop for saving/overwriting
        for ivid = 1:tfm_init_user_Nfiles
            
            % remove old vars directory
            if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid}], 'dir'),7)
                rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid}],'s')
            end
            if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid}], 'dir'),7)
                rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid}],'s')
            end
            
            % overwrite filenames
            tfm_init_user_filenamestack{ivid} = [tfm_init_user_filenamestack{ivid},'_cropped'];
            
            % overwrite preview frames
            tfm_init_user_preview_frame1{ivid} = [];
            tfm_init_user_preview_frame1{ivid} = normalise(bead_vid_crop{ivid}(:,:,1));
            
            % do same forall bf videos (ensure no indexing errors)
            tfm_init_user_bf_filenamestack{ivid} = [tfm_init_user_bf_filenamestack{ivid},'_cropped'];
            if ivid <= size(tfm_init_user_bf_filenamestack)
                tfm_init_user_bf_preview_frame1{ivid} = [];
                tfm_init_user_bf_preview_frame1{ivid} = normalise(bf_vid_crop{ivid}(:,:,1));
            end
            % overwrite mask
            tfm_init_user_binary1{ivid} = mask_rot_crop{ivid};
            % tfm_binary2?
            tfm_init_user_binary3{ivid} = [];
            
            % convert outlines
            BWoutline=bwboundaries(mask_rot_crop{ivid});
            tfm_init_user_outline1x{ivid}=BWoutline{1}(:,2);
            tfm_init_user_outline1y{ivid}=BWoutline{1}(:,1);
            
            %calculate initial ellipse
            s = regionprops(mask_rot_crop{ivid}, 'Orientation', 'MajorAxisLength', ...
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
            an=tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*a;
            bn=1/tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*b;
            xyn = [an*cosphi; bn*sinphi];
            xyn = R*xyn;
            xn = xyn(1,:) + xbar;
            yn = xyn(2,:) + ybar;
            tfm_init_user_outline2x{ivid} = xn;
            tfm_init_user_outline2y{ivid} = yn;
            
            tfm_init_user_outline3x{ivid} = [];
            tfm_init_user_outline3y{ivid} = [];
        end
    end
    
    % bin videos
    if get(h_init(1).checkbox_bin,'Value')
        
        % get bin parameters
        if get(h_init(1).menu_bin,'Value') == 1
            bin_scale = .5;
        else
            bin_scale = .25;
        end
        
        % initialize new stacks
        bead_vid_bin = cell(tfm_init_user_Nfiles,1);
        bf_vid_bin = cell(tfm_init_user_Nfiles,1);
        mask_bin = cell(tfm_init_user_Nfiles,1);
        
        % for loop over videos
        for ivid = 1:tfm_init_user_Nfiles
            
            % status bar
            sb = statusbar(h_init(1).fig,['Binning videos... ',num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)),'%% done']);
            sb.getComponent(0).setForeground(java.awt.Color.red);
            
            % get stack info
            %             info = imfinfo([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'.tif']);
            %             width = info(1).Width;
            %             height = info(1).Height;
            %             N_frames = numel(info);
            %             info = imfinfo([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'.tif']);
            %             bf_N_frames = numel(info);
            height = tfm_init_user_imsize_m{ivid};%info(1).Width;
            width = tfm_init_user_imsize_n{ivid};%info(1).Height;
            N_frames = tfm_init_user_Nframes{ivid};%numel(info);
            %info = imfinfo([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'.tif']);
            bf_N_frames = tfm_init_user_Nframes_bf{ivid};%numel(info);
            
            % initialize movie stacks bead and bf
            init_frame = zeros(height,width);
            new_frame = imresize(init_frame,bin_scale);
            [height, width] = size(new_frame);
            %             bead_vid = zeros(height,width,N_frames);
            %             bead_vid = im2uint8(bead_vid);
            %             bf_vid = zeros(height,width,bf_N_frames);
            %             bf_vid = im2uint8(bf_vid);
            bead_vid = zeros(height,width,N_frames);
            bead_vid = im2uint8(bead_vid);
            bf_vid = zeros(height,width,bf_N_frames);
            bf_vid = im2uint8(bf_vid);
            
            
            % load frames and resize
            bead_frameN = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/image_stack.mat'],'image_stack');
            %for i = 1:N_frames
            %                 bead_frameN = imread([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'.tif'],'tif',i);
            %                 if isa(bead_frameN,'uint8')
            %                 else
            %                     bead_frameN = normalise(bead_frameN);
            %                     bead_frameN = im2uint8(bead_frameN);
            %                 end
            bead_vid = imresize(bead_frameN.image_stack,bin_scale,'bilinear');
            %end
            bf_frameN = load(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{1,ivid},'/image_stack_bf.mat'],'image_stack');
            %for i = 1:bf_N_frames
            %                 bf_frameN = imread([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'.tif'],'tif',i);
            %                 if isa(bf_frameN,'uint8')
            %                 else
            %                     bf_frameN = normalise(bf_frameN);
            %                     bf_frameN = im2uint8(bf_frameN);
            %                 end
            bf_vid = imresize(bf_frameN.image_stack,bin_scale,'bilinear');
            %end
            
            % save binned stacks
            bead_vid_bin{ivid} = bead_vid;
            bf_vid_bin{ivid} = bf_vid;
            mask_bin{ivid} = imresize(tfm_init_user_binary1{ivid},bin_scale,'bilinear');
            
            % create new directory
            if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_binned'], 'dir'),7)
                rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_binned'],'s')
            end
            mkdir(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_binned'])
            % create new directory
            if strcmp(tfm_init_user_filenamestack{ivid}, tfm_init_user_bf_filenamestack{ivid}) == 0
                if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid},'_binned'], 'dir'),7)
                    rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid},'_binned'],'s')
                end
                mkdir(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid},'_binned'])
            end
            % check for old binned files and delete
            if exist([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'_binned',tfm_init_user_vidext{ivid}],'file') == 2
                delete([tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'_binned',tfm_init_user_vidext{ivid}])
            end
            if exist([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'_binned',tfm_init_user_bf_vidext{ivid}],'file') == 2
                delete([tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'_binned',tfm_init_user_bf_vidext{ivid}])
            end
            
            % save new .tif files
            for i = 1:N_frames
                imwrite(bead_vid_bin{ivid}(:,:,i),[tfm_init_user_pathnamestack{ivid},tfm_init_user_filenamestack{ivid},'_binned.tif'],'writemode','append');
            end
            for i = 1:bf_N_frames
                imwrite(bf_vid_bin{ivid}(:,:,i),[tfm_init_user_bf_pathnamestack{ivid},tfm_init_user_bf_filenamestack{ivid},'_binned_bf.tif'],'writemode','append');
            end
            
            % save new .mat files
            image_stack = zeros(size(bead_vid_bin{ivid}));
            parfor i = 1:N_frames
                imagei = normalise(bead_vid_bin{ivid}(:,:,i));
                image_stack(:,:,i) = imagei;
                % save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_cropped','/image',num2str(i),'.mat'],'imagei','-v7.3')
            end
            save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_binned','/image_stack.mat'],'image_stack','-v7.3')
            % save new bf .mat files
            image_stack = zeros(size(bf_vid_bin{ivid}));
            parfor i = 1:bf_N_frames
                imagei = normalise(bf_vid_bin{ivid}(:,:,i));
                image_stack(:,:,i) = imagei;
                % save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid},'_cropped','/image',num2str(i),'.mat'],'imagei','-v7.3')
            end
            save(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid},'_binned','/image_stack_bf.mat'],'image_stack','-v7.3')
            
            % clear temp vids
            bead_vid = [];
            bf_vid = [];
            image_stack = [];
        end
        
        %update statusbar
        sb=statusbar(h_init(1).fig,'Saving binned videos...');
        sb.getComponent(0).setForeground(java.awt.Color.red);
        
        % for loop for saving/overwriting
        for ivid = 1:tfm_init_user_Nfiles
            
            % remove old vars directory
            if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid}], 'dir'),7)
                rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{ivid}],'s')
            end
            if isequal(exist(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid}], 'dir'),7)
                rmdir(['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{ivid}],'s')
            end
            
            % overwrite filenames
            tfm_init_user_filenamestack{ivid} = [tfm_init_user_filenamestack{ivid},'_binned'];
            
            % overwrite preview frames
            tfm_init_user_preview_frame1{ivid} = [];
            tfm_init_user_preview_frame1{ivid} = normalise(bead_vid_bin{ivid}(:,:,1));
            
            tfm_init_user_bf_filenamestack{ivid} = [tfm_init_user_bf_filenamestack{ivid},'_binned'];
            if ivid <= size(tfm_init_user_bf_filenamestack)
                tfm_init_user_bf_preview_frame1{ivid} = [];
                tfm_init_user_bf_preview_frame1{ivid} = normalise(bf_vid_bin{ivid}(:,:,1));
            end
            
            
            % overwrite mask
            tfm_init_user_binary1{ivid} = mask_bin{ivid};
            % tfm_binary2?
            tfm_init_user_binary3{ivid} = [];
            
            % convert outlines
            BWoutline=bwboundaries(mask_bin{ivid});
            tfm_init_user_outline1x{ivid}=BWoutline{1}(:,2);
            tfm_init_user_outline1y{ivid}=BWoutline{1}(:,1);
            
            %calculate initial ellipse
            s = regionprops(mask_bin{ivid}, 'Orientation', 'MajorAxisLength', ...
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
            an=tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*a;
            bn=1/tfm_init_user_scale_factor{ivid}*sqrt(tfm_init_user_area_factor)*b;
            xyn = [an*cosphi; bn*sinphi];
            xyn = R*xyn;
            xn = xyn(1,:) + xbar;
            yn = xyn(2,:) + ybar;
            tfm_init_user_outline2x{ivid} = xn;
            tfm_init_user_outline2y{ivid} = yn;
            
            tfm_init_user_outline3x{ivid} = [];
            tfm_init_user_outline3y{ivid} = [];
        end
        
        % reset conversion and ncorr parameters
        for ivid = 1:tfm_init_user_Nfiles
            tfm_init_user_conversion{ivid} = tfm_init_user_conversion{ivid}/bin_scale;
        end
        tfm_init_user_subset_rad = tfm_init_user_subset_rad*bin_scale;
        tfm_init_user_spacing_coeff = ceil(tfm_init_user_spacing_coeff*bin_scale);
    end
    
    %bleaching correction
    if get(h_init(1).checkbox_bleach, 'Value')
        for ivid=1:tfm_init_user_Nfiles
            sb=statusbar(h_init(1).fig,['Bleaching correction... ',num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)), '%% done']);
            sb.getComponent(0).setForeground(java.awt.Color.red);
            
            % load image stack
            s = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/image_stack.mat'],'image_stack');
            
            %put video on 3d stack
            parfor ifr=1:tfm_init_user_Nframes{ivid}
                %current image
                %s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/image',num2str(ifr),'.mat'],'imagei');
                im_curr=s.image_stack(:,:,ifr);
                
                %piv
                ThreeD(:,:,ifr)=im_curr;
            end
            
            %start miji
            path=cd;
            %start fiji
            addpath('/Applications/Fiji.app/scripts/');
            evalc('Miji(false);');
            %import ij.*;
            cd(path)
            
            %bleach ncorrection histogram
            MIJ.createImage('title',ThreeD,1);
            %IJ.selectWindow('title');
            MIJ.run('Bleach Correction', 'correction=[Histogram Matching]');
            
            %get new stack & save as new
            ThreeD=MIJ.getImage('DUP_title');
            %             for ifr=1:tfm_init_user_Nframes{ivid}
            %                 imagei=ThreeD(:,:,ifr);
            %                 save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/image',num2str(ifr),'.mat'],'imagei','-v7.3')
            %             end
            image_stack = ThreeD;
            save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/image_stack.mat'],'image_stack','-v7.3')
            
            MIJ.run('Close All');
            %IJ.selectWindow('title');
            %MIJ.run('Close');
            %IJ.selectWindow('DUP_title');
            %MIJ.run('Close');
            
            %clear 3d stack
            clear ThreeD;
            image_stack = [];
            
            %quit fiji
            evalc('MIJ.exit;');
            
            %clear java stuff; memory issue on OSX ! java garbage collector
            java.lang.System.gc();
        end
    end
    
    %kalman denoising
    if get(h_init(1).checkbox_denoise, 'Value')
        gain=0.8;
        percentvar=.05;
        parfor ivid=1:tfm_init_user_Nfiles %parfor
            %deleted for parfor
            %sb=statusbar(h_init(1).fig,['Denoising... ',num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)), '%% done']);
            %sb.getComponent(0).setForeground(java.awt.Color.red);
            disp(['Denoizing video #',num2str(ivid)])
            if tfm_init_user_Nframes{ivid} > 11
                folder=['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid}];
                N=tfm_init_user_Nframes{ivid};
                Kalman_Stack_Filter_modified(folder,N,gain,percentvar,0);
                % tfm_init_user_Nframes{ivid}=tfm_init_user_Nframes{ivid}-10; % New filter does not delete frames
            end
            if tfm_init_user_Nframes_bf{ivid} > 11
                folder=['vars_DO_NOT_DELETE/',tfm_init_user_bf_filenamestack{1,ivid}];
                N=tfm_init_user_Nframes_bf{ivid};
                Kalman_Stack_Filter_modified(folder,N,gain,percentvar,1)
                % tfm_init_user_Nframes_bf{ivid}=tfm_init_user_Nframes_bf{ivid}-10; % New filter does not delete frames
            end
        end
    end
    
    %copy master excel file
    masterfile = [tfm_init_user_pathnamestack{1},'/Batch_Results.xlsx'];
    copyfile('Master_DO_NOT_EDIT.xlsx',masterfile);
    
    %save micro data & save mask
    for ivid=1:tfm_init_user_Nfiles
        sb=statusbar(h_init(1).fig,['Saving... ',num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)), '%% done']);
        sb.getComponent(0).setForeground(java.awt.Color.red);
        %create folder with same name as vid. & mask folder
        if ~isequal(exist([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},filesep,'Results'], 'dir'),7)
            mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},filesep,'Results'])
        end
        
        if ~isequal(exist([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Mask'], 'dir'),7)
            mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Mask'])
        end
        
        %copy excel file to new result file
        newfile=[tfm_init_user_pathnamestack{1,ivid},'/',tfm_init_user_filenamestack{1,ivid},'/Results/',tfm_init_user_filenamestack{1,ivid},'.xlsx'];
        copyfile(['Sample_DO_NOT_EDIT.xlsx'],newfile);
        
        %write microscope data to excel file
        A = {tfm_init_user_framerate{ivid},tfm_init_user_conversion{ivid},tfm_init_user_Nframes{ivid},tfm_init_user_cellname{ivid}};
        sheet = 'General';
        xlRange = 'A3';
        xlwrite(newfile,A,sheet,xlRange);
        
        %write cell data to excel file
        A = {tfm_init_user_major(ivid),tfm_init_user_minor(ivid),tfm_init_user_ratio(ivid),tfm_init_user_area(ivid),tfm_init_user_area_ellipse(ivid)};
        sheet = 'General';
        xlRange = 'I3';
        xlwrite(newfile,A,sheet,xlRange);
        
        %write to master excel file
        A = {tfm_init_user_filenamestack{ivid},tfm_init_user_framerate{ivid},tfm_init_user_conversion{ivid},...
            tfm_init_user_major(ivid),tfm_init_user_minor(ivid),tfm_init_user_ratio(ivid),...
            tfm_init_user_area(ivid),tfm_init_user_area_ellipse(ivid)};
        sheet = 'Curves Parameters Batch Summary';
        xlrange = ['A',num2str(ivid+2)];
        xlwrite(masterfile,A,sheet,xlrange);
        sheet = 'Peak Parameters Batch Summary';
        xlrange = ['A',num2str(ivid+2)];
        xlwrite(masterfile,A,sheet,xlrange);
        
        %save mask
        mask=tfm_init_user_binary1{ivid};
        save([tfm_init_user_pathnamestack{1,ivid},'/',tfm_init_user_filenamestack{1,ivid},'/Mask/',tfm_init_user_filenamestack{ivid},'_mask.mat'],'mask','-v7.3');%num2str(ivid) change to filename
    end
    %update statusbar
    sb=statusbar(h_init(1).fig,'Saving - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %generate masks for further analysis based on outline 2
    tfm_init_user_binary2=cell(1,tfm_init_user_Nfiles);
    sb=statusbar(h_init(1).fig,['Calculating ellipse areas... ']);%,num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)), '%% done']);
    sb.getComponent(0).setForeground(java.awt.Color.red);
    parfor ivid=1:tfm_init_user_Nfiles
        %             sb=statusbar(h_init(1).fig,['Calculating ellipse areas... ',num2str(floor(100*(ivid-1)/tfm_init_user_Nfiles)), '%% done']);
        %             sb.getComponent(0).setForeground(java.awt.Color.red);
        image=tfm_init_user_preview_frame1{ivid};
        if isempty(tfm_init_user_binary1{ivid})
            tfm_init_user_binary1{ivid}=logical(ones(size(image,1),size(image,2)));
            tfm_init_user_binary2{ivid}=true(size(image,1),size(image,2));
            tfm_init_user_binary3{ivid}=logical(ones(size(image,1),size(image,2)));
        else
            mask=poly2mask(tfm_init_user_outline2x{ivid},tfm_init_user_outline2y{ivid},size(image,1),size(image,2));
            tfm_init_user_binary2{ivid}=mask;
        end
    end
    
    
    %update statusbar
    sb=statusbar(h_init(1).fig,'Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    
    
    %setappdata(0,'userTiming',userTiming)
    setappdata(0,'tfm_init_user_Nframes',tfm_init_user_Nframes);
    setappdata(0,'tfm_init_user_Nframes_bf',tfm_init_user_Nframes_bf);
    setappdata(0,'tfm_init_user_imsize_m',tfm_init_user_imsize_m);
    setappdata(0,'tfm_init_user_imsize_n',tfm_init_user_imsize_n);
    setappdata(0,'tfm_init_user_cellname',tfm_init_user_cellname);
    setappdata(0,'tfm_init_user_conversion',tfm_init_user_conversion);
    setappdata(0,'tfm_init_user_framerate',tfm_init_user_framerate);
    setappdata(0,'tfm_init_user_area_factor',tfm_init_user_area_factor);
    setappdata(0,'tfm_init_user_binary3',tfm_init_user_binary3);
    setappdata(0,'tfm_init_user_binary2',tfm_init_user_binary2);
    setappdata(0,'tfm_init_user_binary1',tfm_init_user_binary1);
    setappdata(0,'tfm_init_user_preview_frame1',tfm_init_user_preview_frame1);
    setappdata(0,'tfm_init_user_bf_preview_frame1',tfm_init_user_bf_preview_frame1);
    setappdata(0,'tfm_init_user_filenamestack',tfm_init_user_filenamestack);
    setappdata(0,'tfm_init_user_bf_filenamestack',tfm_init_user_bf_filenamestack);
    setappdata(0,'tfm_init_user_outline1x',tfm_init_user_outline1x);
    setappdata(0,'tfm_init_user_outline1y',tfm_init_user_outline1y);
    setappdata(0,'tfm_init_user_outline2x',tfm_init_user_outline2x);
    setappdata(0,'tfm_init_user_outline2y',tfm_init_user_outline2y);
    setappdata(0,'tfm_init_user_outline3x',tfm_init_user_outline3x);
    setappdata(0,'tfm_init_user_outline3y',tfm_init_user_outline3y);
    setappdata(0,'tfm_init_user_subset_rad',tfm_init_user_subset_rad);
    setappdata(0,'tfm_init_user_spacing_coeff',tfm_init_user_spacing_coeff);
    setappdata(0,'tfm_init_user_major',tfm_init_user_major);
    setappdata(0,'tfm_init_user_minor',tfm_init_user_minor);
    setappdata(0,'tfm_init_user_angle',tfm_init_user_angle);
    setappdata(0,'tfm_init_user_area',tfm_init_user_area);
    setappdata(0,'tfm_init_user_area_ellipse',tfm_init_user_area_ellipse);
    setappdata(0,'tfm_gui_call_piv_flag',tfm_gui_call_piv_flag);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
    
end

%enable
enableDisableFig(h_init(1).fig,1);

%close window
close(h_init(1).fig);

% % send notif
% myMessage='Initialization finished';
% notif = getappdata(0,'notif');
% if notif.on
%     for i = size(notif.url)
%         webwrite(notif.url{i},'value1',myMessage);
%     end
% end


%change main windows 2. button status
set(h_main(1).button_piv,'Enable','on');
set(h_main(1).button_init,'ForegroundColor',[0 .5 0]);

%move main window to center
movegui(h_main(1).fig,'center')

%Streamlining
if tfm_init_user_strln
    tfm_piv(h_main);
end


