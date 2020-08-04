% Cell Locator GUI
% Henry Lewis
% Gaspard Pardon
% Foster Birnbaum

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROTOCOL: using Matlab R2018b (and possibly newer)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%When using the Cell-locator for the first time, followin the instruction
%in the next section first.
%1. Run Celoc_GUI_Test.m and start using the software
   %1.1a When working with .tif image, load survey tile images, then add 
        % the corresponding .pos list for the tile, i.e. stage position for each
        % tile
   %1.1b When working with .czi images, simply load the .czi survey and the
        % position of the tiles are automatically extracted from the metadata.
        % If an error occurs with bfmatlab or loci.format... do the
        % following workaround:
            % uddate bfmatlab in the External folder with the latest
            % version that can be download at: https://www.openmicroscopy.org/bio-formats/downloads/
            % copy the bioformat_package.jar into the Matlab root java/jar directory: e.g.: /Applications/MATLAB_R2018b.app/java/jar/ 
        %In Matlab, type
            %>> edit([prefdir'/javaclasspath.txt']); 
            % and add the following lines, adjusting the path if necessary:
            % /Applications/MATLAB_R2018b.app/java/jar/bioformats_package.jar
    %2 Set cell finder criteria
        % Use Update button to refine criteria on single frame
        % Find All Cells and review cell selection
        % Once satisfied with cell selection export .pos position list to 
        % Micro-Mnanager, .czstm stage mark list for Zeiss Zen Blue, or to
        % .csv file for general use.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BEFORE FIST USE:
% 1. Install Micro-manager microscopy software and setup Matlab to interact
%   with Micro-Manager according to instruction found here: https://micro-manager.org/wiki/Matlab
%   In summary, do the following:
%   1.1. Matlab and the Micro-Manager core - Setting up Matlab to control
%   hardware through the Micro-Manager core. (only reall needed if one want
%   to use Matlab to control Micro-manager)
%       a) Install Micro-Manager
%       b) In Matlab command window, type the command 
%           >> edit([prefdir'/javaclasspath.txt']); 
%           to add the location of all the .jar in Micro-manager, adjusting
%           the path if necessary. 
%           Here is a list of what was found on my MacOS machine:
                % /Applications/Micro-Manager1.4/mmautofocus/HardwareFocusExtender.jar
                % /Applications/Micro-Manager1.4/mmautofocus/MMAutofocus.jar
                % /Applications/Micro-Manager1.4/mmautofocus/MMAutofocusDuo.jar
                % /Applications/Micro-Manager1.4/mmautofocus/MMAutofocusTB.jar
                % /Applications/Micro-Manager1.4/mmautofocus/MMNullAutofocus.jar
                % /Applications/Micro-Manager1.4/mmautofocus/MMOughtaFocus.jar
                % 
                % /Applications/Micro-Manager1.4/mmplugins/Big.jar
                % /Applications/Micro-Manager1.4/mmplugins/DataBrowser.jar
                % /Applications/Micro-Manager1.4/mmplugins/PixelCalibrator.jar
                % /Applications/Micro-Manager1.4/mmplugins/Recall.jar
                % 
                % /Applications/Micro-Manager1.4/mmplugins/Acquisition_Tools/AcquireMultipleRegions.jar
                % /Applications/Micro-Manager1.4/mmplugins/Acquisition_Tools/Gaussian.jar
                % /Applications/Micro-Manager1.4/mmplugins/Acquisition_Tools/HCS.jar
                % /Applications/Micro-Manager1.4/mmplugins/Acquisition_Tools/IntelligentAcquisition.jar
                % /Applications/Micro-Manager1.4/mmplugins/Acquisition_Tools/Magellan.jar
                % /Applications/Micro-Manager1.4/mmplugins/Acquisition_Tools/MMTracker.jar
                % /Applications/Micro-Manager1.4/mmplugins/Acquisition_Tools/PatternOverlay.jar
                % /Applications/Micro-Manager1.4/mmplugins/Acquisition_Tools/SlideExplorer.jar
                % 
                % /Applications/Micro-Manager1.4/mmplugins/Beta/CRISPv2.jar
                % /Applications/Micro-Manager1.4/mmplugins/Beta/SlideExplorer2.jar
                % 
                % /Applications/Micro-Manager1.4/mmplugins/Developer_Tools/ClojureEditor.jar
                % /Applications/Micro-Manager1.4/mmplugins/Developer_Tools/SequenceBufferMonitor.jar
                % 
                % /Applications/Micro-Manager1.4/mmplugins/Device_Control/ASIdiSPIM.jar
                % /Applications/Micro-Manager1.4/mmplugins/Device_Control/AutoLase.jar
                % /Applications/Micro-Manager1.4/mmplugins/Device_Control/CRISP.jar
                % /Applications/Micro-Manager1.4/mmplugins/Device_Control/MightexPolygon.jar
                % /Applications/Micro-Manager1.4/mmplugins/Device_Control/MultiCamera.jar
                % /Applications/Micro-Manager1.4/mmplugins/Device_Control/pgFocus.jar
                % /Applications/Micro-Manager1.4/mmplugins/Device_Control/Projector.jar
                % /Applications/Micro-Manager1.4/mmplugins/Device_Control/StageControl.jar
                % /Applications/Micro-Manager1.4/mmplugins/Device_Control/StageMonitor.jar
                % /Applications/Micro-Manager1.4/mmplugins/Device_Control/WhiteBalance.jar
                % 
                % /Applications/Micro-Manager1.4/mmplugins/On-The-Fly_Processors/ImageFlipper.jar
                % /Applications/Micro-Manager1.4/mmplugins/On-The-Fly_Processors/MultiChannelShading.jar
                % /Applications/Micro-Manager1.4/mmplugins/On-The-Fly_Processors/SplitView.jar
                % 
                % /Applications/Micro-Manager1.4/plugins/Volume_Viewer.jar
                % 
                % /Applications/Micro-Manager1.4/ij.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/DT1.2-.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/MMAcqEngine.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/MMCoreJ.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/MMJ_.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/TSFProto-SVN.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/bigdataviewer-core-2.1.0.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/bsh-2.0b4.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/clojure-1.3.0.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/clooj-0.2.7.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/commons-math-2.2.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/commons-math3-3.4.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/core.cache-0.6.2.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/core.memoize-0.5.2.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/data.json-0.1.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/eventbus-1.4.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/formats-api-5.1.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/formats-common-5.1.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/gentyref-1.1.0.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/gson-2.2.4.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/ij-1.48v.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/ij3d-bin-.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/ima3d_-.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/imagej-common-0.17.0.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/imglib2-2.4.0.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/imglib2-algorithm-0.3.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/imglib2-realtransform-2.0.0-beta-29.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/imglib2-roi-0.3.2.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/imglib2-ui-2.0.0-beta-29.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/jama-1.0.3.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/jcommon-1.0.23.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/jdom-2.0.2.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/jdom2-2.0.5.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/jfreechart-1.0.19.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/jhdf5-14.12.0.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/joda-time-2.2.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/jxinput-0.8.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/kryo-2.24.0.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/logback-classic-1.1.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/logback-core-1.1.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/miglayout-core-4.2.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/miglayout-swing-4.2.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/minlog-1.2.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/objenesis-2.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/ome-xml-5.1.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/protobuf-java-2.5.0.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/py4j-0.10.6.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/rsyntaxtextarea-2.5.2.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/scijava-common-2.46.0.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/serializer-2.7.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/slf4j-api-1.7.6.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/spim_data-2.0.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/swingx-0.9.5.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/trove4j-3.0.3.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/udunits-4.3.18.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/xalan-2.7.1.jar
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/xml-apis-1.3.04.jar
                % <before>
                % /Applications/Micro-Manager1.4/plugins/Micro-Manager/guava-17.0.jar
                
        %c) The first time you edit the file, it will have to be created. After restarting MATLAB, you can check that the paths have been included in the MATLAB classpath by typing
            %>> javaclasspath
        %d) In Matlab command prompt
            %>> edit librarypath.txt 
            % Add the location of the dll files, for instance: C:/Micro-Manager-1.4.6/
        %e) Restart Matlab
        
    %1.2. Matlab and the Micro-Manager GUI - Controlling the Micro-Manager 
    %       graphical user interface with Matlab. (required to import .pos 
    %       list from Micro-manager and to export the .pos list direclty to Micro-manager)
        %a) In Matlab, type
            %>> edit([prefdir'/javaclasspath.txt']); 
            % and add the following lines, adjusting the path if necessary:
                % C:/Program Files/Micro-Manager-1.4.11/ij.jar
                % C:/Program Files/Micro-Manager-1.4.11/plugins/Micro-Manager/MMCoreJ.jar
                % C:/Program Files/Micro-Manager-1.4.11/plugins/Micro-Manager/MMJ_.jar
                % C:/Program Files/Micro-Manager-1.4.11/plugins/Micro-Manager/bsh-2.0b4.jar
                % C:/Program Files/Micro-Manager-1.4.11/plugins/Micro-Manager/swingx-0.9.5.jar
                % C:/Program Files/Micro-Manager-1.4.11/plugins/Micro-Manager/swing-layout-1.0.4.jar
            % you will need the additional items below in the classpath.txt to use the multi-image file format:
                % C:/Program Files/Micro-Manager-1.4.11/plugins/Micro-Manager/ome-xml.jar
                % C:/Program Files/Micro-Manager-1.4.11/plugins/Micro-Manager/loci-common.jar
                % C:/Program Files/Micro-Manager-1.4.11/plugins/Micro-Manager/scifio.jar
                % C:/Program Files/Micro-Manager-1.4.11/plugins/Micro-Manager/slf4j-api-1.7.1.jar
        %b) Again in Matlab, type
            % >> edit librarypath.txt
            % and add the line:
                % C:/Program Files/Micro-Manager-1.4
        %c) Restart Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Protocol to acquire image survey in Micro-manager:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lauch Micro-manager to control yout microscope. 
%   Alternatively, to control Micro-manger from Matlab, launch Micro-Manager using Matlab 
%   initialization script.
% Some microscope may require inverting stage direction, if so do that in 
% Device Prop. Browser
    % Set X and Y value to 1
% Set pixel size with Pixel Calibrator plugin
% Acquire tiled images with Acquire Multiple Regions plugin
    % Set directory
    % Set filename
    % Add 4 points minimum in each corner of region
    % Add additional points for better Z-axis interpolation
    % Save region for acquisition
    % Acquire all regions
    % Save pos list file
% Run Celoc_GUI.m to find the cell position and export or save the .pos
% position list
% Import the . pos position list, change magnification to that wnated to
% acquire TFM videos, find the first cell position and adjust the position
% list positions with fixed x-y-z-offset to compensate for difference in
% focus posotion between the objective or for any accidental displacement
% of the cell culture plate on the stage. 
% Start acquistion of TFM vedio with the Automated TFM acquition script for
% Micro-Manager.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


function Celoc_GUI_Test

clc
clear all
close all

% add paths of external functions
% don't need all, maybe cut some out?
addpath('External'); % delete unused functions
addpath('External/bfmatlab'); % cut?
addpath('External/statusbar');
addpath('External/20130227_xlwrite');
javaaddpath('External/bfmatlab/');
javaaddpath('External/20130227_xlwrite/poi_library/poi-3.8-20120326.jar');
javaaddpath('External/20130227_xlwrite/poi_library/poi-ooxml-3.8-20120326.jar');
javaaddpath('External/20130227_xlwrite/poi_library/poi-ooxml-schemas-3.8-20120326.jar');
javaaddpath('External/20130227_xlwrite/poi_library/xmlbeans-2.3.0.jar');
javaaddpath('External/20130227_xlwrite/poi_library/dom4j-1.6.1.jar');
javaaddpath('External/20130227_xlwrite/poi_library/stax-api-1.0.1.jar');

% create gui window
figuresize = [675 1070];
screensize = get(0,'ScreenSize');
xpos = ceil((screensize(3)-figuresize(2))/2);
ypos = ceil((screensize(4)-figuresize(1))/2);
h_celoc(1).fig = figure(...
    'position',[xpos, ypos, figuresize(2), figuresize(1)],...
    'units','pixels',...
    'renderer','OpenGL',...
    'MenuBar','none',...
    'PaperPositionMode','auto',...
    'Name','Cell Location Wizard',...
    'NumberTitle','off',...
    'Resize','off',...
    'Color',[.94,.94,.94],...
    'visible','on');

% images panel
h_celoc(1).panel_images = uipanel('Parent',h_celoc(1).fig,'Title','Overview images','units','pixels','position',[20,360,180,310]);
% load images button
h_celoc(1).button_load_im = uicontrol('Parent',h_celoc(1).panel_images,'style','pushbutton','position',[10,265,140,25],'string','Load overview images');
% load img pos button
h_celoc(1).button_load_im_coords = uicontrol('Parent',h_celoc(1).panel_images,'style','pushbutton','position',[10,240,140,25],'string','Load image positions');
% conversion factor
h_celoc(1).text_conv = uicontrol('Parent',h_celoc(1).panel_images,'style','text','position',[10,225,140,15],'string','Conversion (um/px)','HorizontalAlignment','left');
h_celoc(1).edit_conv = uicontrol('Parent',h_celoc(1).panel_images,'style','edit','position',[10,200,140,20],'string','1.10','HorizontalAlignment','center');
% image list
h_celoc(1).listbox_images = uicontrol('Parent',h_celoc(1).panel_images,'style','listbox','position',[10,60,160,135]);
% next image
h_celoc(1).button_next_im = uicontrol('Parent',h_celoc(1).panel_images,'style','pushbutton','position',[85,30,80,25],'string','Next image');
% previous image
h_celoc(1).button_prev_im = uicontrol('Parent',h_celoc(1).panel_images,'style','pushbutton','position',[5,30,80,25],'string','Previous image');
% delete image
h_celoc(1).button_del_im = uicontrol('Parent',h_celoc(1).panel_images,'style','pushbutton','position',[5,5,80,25],'string','Delete image');
% clear images
h_celoc(1).button_clear_im = uicontrol('Parent',h_celoc(1).panel_images,'style','pushbutton','position',[85,5,80,25],'string','Clear all','Visible','off');

% controls panel
h_celoc(1).panel_control = uipanel('Parent',h_celoc(1).fig,'Title','Locator controls','units','pixels','position',[20,20,180,335]);
% import pos list button
h_celoc(1).button_import_cell_pos = uicontrol('Parent',h_celoc(1).panel_control,'style','pushbutton','position',[10,290,160,25],'string','Import cell position list');
% locate button
h_celoc(1).button_locate = uicontrol('Parent',h_celoc(1).panel_control,'style','pushbutton','position',[10,260,160,25],'string','Find all cell locations');
% location update button
h_celoc(1).button_update = uicontrol('Parent',h_celoc(1).panel_control,'style','pushbutton','position',[10,230,160,25],'string','Update current frame locations');
% threshold control
h_celoc(1).text_thresh = uicontrol('Parent',h_celoc(1).panel_control,'style','text','position',[10,225,180,15],'string','Edge-finder threshold (UNUSED)','HorizontalAlignment','left','visible','off');
h_celoc(1).edit_thresh = uicontrol('Parent',h_celoc(1).panel_control,'style','edit','position',[30,200,60,20],'string','1.2','HorizontalAlignment','center','visible','off');
% orientation range
h_celoc(1).text_angle = uicontrol('Parent',h_celoc(1).panel_control,'style','text','position',[10,210,140,15],'string','Orientation range (-90 - 90)','HorizontalAlignment','left');
h_celoc(1).edit_angle_min = uicontrol('Parent',h_celoc(1).panel_control,'style','edit','position',[10,185,60,20],'string','-90','HorizontalAlignment','center');
h_celoc(1).edit_angle_max = uicontrol('Parent',h_celoc(1).panel_control,'style','edit','position',[100,185,60,20],'string','90','HorizontalAlignment','center');
% minor axis
% major axis
% aspect ratio range
h_celoc(1).text_aspect = uicontrol('Parent',h_celoc(1).panel_control,'style','text','position',[10,165,140,15],'string','Aspect ratio range (_:1)','HorizontalAlignment','left');
h_celoc(1).edit_aspect_min = uicontrol('Parent',h_celoc(1).panel_control,'style','edit','position',[10,140,60,20],'string','3','HorizontalAlignment','center');
h_celoc(1).edit_aspect_max = uicontrol('Parent',h_celoc(1).panel_control,'style','edit','position',[100,140,60,20],'string','9','HorizontalAlignment','center');
% area range
h_celoc(1).text_area = uicontrol('Parent',h_celoc(1).panel_control,'style','text','position',[10,120,140,15],'string','Area range (um^2)','HorizontalAlignment','left');
h_celoc(1).edit_area_min = uicontrol('Parent',h_celoc(1).panel_control,'style','edit','position',[10,95,60,20],'string','500','HorizontalAlignment','center');
h_celoc(1).edit_area_max = uicontrol('Parent',h_celoc(1).panel_control,'style','edit','position',[100,95,60,20],'string','4000','HorizontalAlignment','center');
% contraction detection button
h_celoc(1).button_contract = uicontrol('Parent',h_celoc(1).panel_control,'style','pushbutton','position',[10,65,160,25],'string','Detect contractions','Enable','off');
% fluorescence detection button
h_celoc(1).button_fluor = uicontrol('Parent',h_celoc(1).panel_control,'style','pushbutton','position',[10,40,160,25],'string','Detect fluorescence');
% save cell data button
h_celoc(1).button_save_data = uicontrol('Parent',h_celoc(1).panel_control,'style','pushbutton','position',[10,8,160,25],'string','SAVE CELL SEARCH DATA');

% preview panel
h_celoc(1).panel_preview = uipanel('Parent',h_celoc(1).fig,'Title','Overview preview','units','pixels','position',[210,40,580,630]);
% display axes
h_celoc(1).axes_prev = axes('Parent',h_celoc(1).panel_preview,'units','pixels','position',[15,15,550,550]);
% display image counter
h_celoc(1).text_im_count = uicontrol('Parent',h_celoc(1).panel_preview,'style','text','position',[15,595,150,15],'string','Image:','HorizontalAlignment','left');
% display image coordinates
h_celoc(1).text_im_coord = uicontrol('Parent',h_celoc(1).panel_preview,'style','text','position',[15,575,150,15],'string','Stage position:','HorizontalAlignment','left');
% display cell counter
h_celoc(1).text_cell_count = uicontrol('Parent',h_celoc(1).panel_preview,'style','text','position',[200,595,150,15],'string','Cells in image:','HorizontalAlignment','left');
% display average area
h_celoc(1).text_avg_area = uicontrol('Parent',h_celoc(1).panel_preview,'style','text','position',[200,575,150,15],'string','Avg cell area:','HorizontalAlignment','left');
% display average aspect ratio
h_celoc(1).text_avg_aspect = uicontrol('Parent',h_celoc(1).panel_preview,'style','text','position',[385,595,150,15],'string','Avg aspect ratio:','HorizontalAlignment','left');
% display average orientation
h_celoc(1).text_avg_angle = uicontrol('Parent',h_celoc(1).panel_preview,'style','text','position',[385,575,150,15],'string','Avg orientation:','HorizontalAlignment','left');

% cell coordinate panel
h_celoc(1).panel_loc = uipanel('Parent',h_celoc(1).fig,'Title','Cell locations','units','pixels','position',[800,95,250,575]);
% initial position list
h_celoc(1).listbox_cellpos = uicontrol('Parent',h_celoc(1).panel_loc,'style','listbox','position',[15,400,160,150]);
% cell detail axes
h_celoc(1).axes_cell = axes('Parent',h_celoc(1).panel_loc,'units','pixels','position',[15,15,220,220]);
% next cell button
h_celoc(1).button_next_cell = uicontrol('Parent',h_celoc(1).panel_loc,'style','pushbutton','position',[165,250,80,25],'string','Next cell');
% previous cell button
h_celoc(1).button_prev_cell = uicontrol('Parent',h_celoc(1).panel_loc,'style','pushbutton','position',[5,250,80,25],'string','Previous cell');
% remove cell button
h_celoc(1).button_rem_cell = uicontrol('Parent',h_celoc(1).panel_loc,'style','pushbutton','position',[85,250,80,25],'string','Remove cell');
% add button
h_celoc(1).button_add_cells = uicontrol('Parent',h_celoc(1).panel_loc,'style','pushbutton','position',[5,370,80,25],'string','Add cells');
% delete button
h_celoc(1).button_del_cells = uicontrol('Parent',h_celoc(1).panel_loc,'style','pushbutton','position',[85,370,80,25],'string','Delete cells');
% clear button
h_celoc(1).button_clear_cells = uicontrol('Parent',h_celoc(1).panel_loc,'style','pushbutton','position',[165,370,80,25],'string','Clear all');
% cell dimensions
h_celoc(1).text_cell_dim = uicontrol('Parent',h_celoc(1).panel_loc,'style','text','position',[5,350,200,15],'string','Cell dimensions (um):','HorizontalAlignment','left');
% cell area
h_celoc(1).text_cell_area = uicontrol('Parent',h_celoc(1).panel_loc,'style','text','position',[5,330,200,15],'string','Cell area (um^2):','HorizontalAlignment','left');
% cell aspect ratio
h_celoc(1).text_cell_aspect = uicontrol('Parent',h_celoc(1).panel_loc,'style','text','position',[5,310,200,15],'string','Cell aspect ratio:','HorizontalAlignment','left');
% cell orientation
h_celoc(1).text_cell_angle = uicontrol('Parent',h_celoc(1).panel_loc,'style','text','position',[5,290,200,15],'string','Cell orientation:','HorizontalAlignment','left');

% export panel
h_celoc(1).panel_export = uipanel('Parent',h_celoc(1).fig,'Title','Save and Export','units','pixels','position',[800,15,250,75]);
% save cell data button
h_celoc(1).button_save_cellpos = uicontrol('Parent',h_celoc(1).panel_export,'style','pushbutton','position',[10,33,220,25],'string','SAVE CELL POSITION LIST');
% export button
h_celoc(1).button_export = uicontrol('Parent',h_celoc(1).panel_export,'style','pushbutton','position',[10,6,220,25],'string','EXPORT TO MICRO-MANAGER','visible','on');

% assign callbacks
set(h_celoc(1).button_load_im,'callback',{@push_load_im,h_celoc});
set(h_celoc(1).button_load_im_coords,'callback',{@push_load_im_coords,h_celoc});
set(h_celoc(1).button_import_cell_pos,'callback',{@push_imp_cell_pos,h_celoc});
set(h_celoc(1).button_locate,'callback',{@push_locate,h_celoc});
set(h_celoc(1).button_update,'callback',{@push_update,h_celoc});
set(h_celoc(1).button_contract,'callback',{@push_contract,h_celoc});
set(h_celoc(1).button_fluor,'callback',{@push_fluor,h_celoc});
set(h_celoc(1).button_next_im,'callback',{@push_next_im,h_celoc});
set(h_celoc(1).button_prev_im,'callback',{@push_prev_im,h_celoc});
set(h_celoc(1).button_del_im,'callback',{@push_del_im,h_celoc});
set(h_celoc(1).button_clear_im,'callback',{@push_clear_im,h_celoc});
set(h_celoc(1).button_next_cell,'callback',{@push_next_cell,h_celoc});
set(h_celoc(1).button_prev_cell,'callback',{@push_prev_cell,h_celoc});
set(h_celoc(1).button_add_cells,'callback',{@push_add_cells,h_celoc});
set(h_celoc(1).button_del_cells,'callback',{@push_del_cells,h_celoc});
set(h_celoc(1).button_rem_cell,'callback',{@push_rem_cell,h_celoc});
set(h_celoc(1).button_clear_cells,'callback',{@push_clear_cells,h_celoc});
set(h_celoc(1).listbox_images,'callback',{@select_image,h_celoc});
set(h_celoc(1).listbox_cellpos,'callback',{@select_cell,h_celoc});
set(h_celoc(1).button_save_data,'callback',{@push_save_data,h_celoc});
set(h_celoc(1).button_save_cellpos,'callback',{@push_save_cellpos,h_celoc});
set(h_celoc(1).button_export,'callback',{@push_export,h_celoc});

% deactivate panels until images loaded
set(h_celoc(1).panel_control,'Visible','off');
set(h_celoc(1).panel_preview,'Visible','off');
set(h_celoc(1).panel_loc,'Visible','off');
set(h_celoc(1).panel_export,'Visible','off');

try
    
% set image and position checks
setappdata(0,'images_loaded',0);
setappdata(0,'image_pos_loaded',0);

% clear leftover data
setappdata(0,'celoc_filenamestack',[]);
setappdata(0,'celoc_pathnamestack',[]);
setappdata(0,'celoc_imext',[]);
setappdata(0,'celoc_Nimages',[]);
setappdata(0,'celoc_im_preview',[]);
setappdata(0,'celoc_conv',[]);
setappdata(0,'celoc_image_counter',[]);
setappdata(0,'MM_im_pos_list',[]);
setappdata(0,'MM_im_pos_array',[]);
setappdata(0,'celoc_im_pos_list',[]);
setappdata(0,'celoc_BW_mask',[]);
setappdata(0,'celoc_cell_counter',[]);
setappdata(0,'celoc_cell_pos_list',[]);
setappdata(0,'celoc_cell_disp_list',[]);
setappdata(0,'celoc_Ncells',[]);
setappdata(0,'celoc_cell_tot',[]);
setappdata(0,'celoc_conv',[]);
setappdata(0,'celoc_area_min',[]);
setappdata(0,'celoc_area_max',[]);
setappdata(0,'celoc_aspect_min',[]);
setappdata(0,'celoc_aspect_max',[]);
setappdata(0,'celoc_angle_min',[]);
setappdata(0,'celoc_angle_max',[]);
setappdata(0,'celoc_thresh',[]);
setappdata(0,'celoc_area_list',[]);
setappdata(0,'celoc_area_avg',[]);
setappdata(0,'celoc_area_std',[]);
setappdata(0,'celoc_aspect_list',[]);
setappdata(0,'celoc_aspect_avg',[]);
setappdata(0,'celoc_aspect_std',[]);
setappdata(0,'celoc_angle_list',[]);
setappdata(0,'celoc_angle_avg',[]);
setappdata(0,'celoc_angle_std',[]);
setappdata(0,'celoc_majaxis_list',[]);
setappdata(0,'celoc_majaxis_avg',[]);
setappdata(0,'celoc_majaxis_std',[]);
setappdata(0,'celoc_minaxis_list',[]);
setappdata(0,'celoc_minaxis_avg',[]);
setappdata(0,'celoc_minaxis_std',[]);
setappdata(0, 'celoc_im_tye', []);
setappdata(0, 'Ntime_series', []);
setappdata(0, 'Nchannels', []);
setappdata(0, 'celoc_im_data', []); % holds all image data for .czi files

catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_load_im(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% % load MM gui object
% gui = getappdata(0,'gui');

% get image files
[filename,pathname] = uigetfile({'*.czi';'*.tif'},'MultiSelect','on');

% check for cancel
if isequal(filename,0)
    return;
end
filename = cellstr(filename);
[~,name,type] = fileparts(strcat(pathname,filename{1,1}));

celoc_Nimages = size(filename,2);
% if .czi file, need to do a more detailed count of number of images
if strcmp(type, '.czi') == 1
    ims = bfopen([pathname,name,type]);
    celoc_Nimages = size(ims,1);
end

% initialize stacks
celoc_filenamestack = cell(1,celoc_Nimages);
celoc_pathnamestack = cell(1,celoc_Nimages);
celoc_imext = cell(1,celoc_Nimages);
celoc_im_preview = cell(1,celoc_Nimages);
celoc_BW_mask = cell(1,celoc_Nimages);
celoc_cell_pos_list = cell(1,celoc_Nimages);
celoc_cell_disp_list = cell(1,celoc_Nimages);
celoc_Ncells = cell(1,celoc_Nimages);
celoc_area_list = cell(1,celoc_Nimages);
celoc_aspect_list = cell(1,celoc_Nimages);
celoc_angle_list = cell(1,celoc_Nimages);
celoc_majaxis_list = cell(1,celoc_Nimages);
celoc_minaxis_list = cell(1,celoc_Nimages);
celoc_area_avg = cell(1,celoc_Nimages);
celoc_aspect_avg = cell(1,celoc_Nimages);
celoc_angle_avg = cell(1,celoc_Nimages);
celoc_area_std = cell(1,celoc_Nimages);
celoc_aspect_std = cell(1,celoc_Nimages);
celoc_angle_std = cell(1,celoc_Nimages);
celoc_cell_tot = 0;
celoc_contr_sens = 1;
celoc_fluor_sens = 1;
image_pos_loaded = 0;

% decide if .tif or .czi file
if strcmp(type, '.tif') == 1

    % add filenames to stacks
    for i=1:celoc_Nimages
        [~,name,ext] = fileparts(strcat(pathname,filename{1,i}));
        celoc_filenamestack{i} = name;
        celoc_pathnamestack{i} = pathname;
        celoc_imext{i} = ext;
        celoc_Ncells{i} = 0;
    end

    % load in images
    for j=1:celoc_Nimages
        % status bar
        sb = statusbar(h_celoc(1).fig,['Importing... ',num2str(floor(100*(i-1)/celoc_Nimages)),'%% done']);
        sb.getComponent(0).setForeground(java.awt.Color.red);

        % read images and convert to 8-bit
        image = imread([celoc_pathnamestack{j},celoc_filenamestack{j},celoc_imext{j}]);
        image = normalise(image);
        image = im2uint8(image);
        % add image to stack
        celoc_im_preview{j} = image;
    end
    
    % check for image stack
    info = imfinfo([celoc_pathnamestack{1},celoc_filenamestack{1},celoc_imext{1}]);
    N_frames = numel(info);
    if N_frames > 1
        set(h_celoc(1).button_contract,'Enable','on');
    end
   
elseif strcmp(type, '.czi') == 1
    seriesCount = size(ims, 1);
    totalCount = 1;
    % add filenames and load in first image of every series
    for i=1:seriesCount
        series = ims{i, 1};
        sb = statusbar(h_celoc(1).fig,['Importing... ',num2str(floor(100*(i-1)/celoc_Nimages)),'%% done']);
        sb.getComponent(0).setForeground(java.awt.Color.red);

        plane = series{1,1};
        label = series{1,2};
        [~,name,ext] = fileparts(strcat(pathname,label));
        celoc_filenamestack{totalCount} = label;
        celoc_pathnamestack{totalCount} = pathname;
        celoc_imext{totalCount} = '.czi';
        celoc_NCells{totalCount} = 0;

        plane = normalise(plane);
        plane = im2uint8(plane);
        celoc_im_preview{totalCount} = plane;

        totalCount = totalCount + 1;  
    end
    
    % also load position list
    MM_im_pos_list = javaObject('org.micromanager.api.PositionList');
    celoc_pos_list_pathname = pathname;
    posXYZ = getPositions(pathname, filename{1,1}, type);


    sz = size(posXYZ);
    celoc_im_pos_list = cell(1,sz(1));
    for i = 1:sz(1)
        celoc_im_pos_list{i}=[posXYZ(i,1) posXYZ(i,2) posXYZ(i,3)];
        
    end
    image_pos_loaded = 1;
    

    % check for image  and channel stack
    info = ims{1, 1}{1, 2};
    Ntime_series = 1;
    time_series = extractAfter(info, 'T=');
    if ~(time_series == "")
        time_series = split(time_series, '/', 1);
        Ntime_series = str2num(time_series{2, 1});
        if (Ntime_series > 1)
            set(h_celoc(1).button_contract,'Enable','on');
        end
    end
    
    Nchannels = 1;
    channels = extractAfter(info, 'C=');
    channels = extractBefore(channels, ';');
    if ~(channels == "")
        channels = split(channels, '/', 1);
        Nchannels = str2num(channels{2, 1});
    end
    
    % save stuff
    setappdata(0,'MM_im_pos_list',MM_im_pos_list);
    setappdata(0,'celoc_im_pos_list',celoc_im_pos_list);
    setappdata(0,'celoc_pos_list_pathname',celoc_pos_list_pathname);
    setappdata(0,'image_pos_loaded',image_pos_loaded);
    setappdata(0,'Ntime_series', Ntime_series);
    setappdata(0,'Nchannels', Nchannels);
    setappdata(0, 'celoc_im_data', ims);
    
end

%update statusbar
sb=statusbar(h_celoc(1).fig,'Done !');
sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));

% get unit conversion
celoc_conv = str2double(get(h_celoc(1).edit_conv,'string'));

% initialize counters
celoc_image_counter = 1;
celoc_cell_counter = 1; 
celoc_Ncells(:,:) = {0};

% display preview
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});

% display list
set(h_celoc(1).listbox_images,'String',celoc_filenamestack);

% update image info
set(h_celoc(1).text_im_count,'String',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
% set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);

% confirm images loaded
images_loaded = 1;

% if images and positions loaded activate panels
if (images_loaded == 1) && (image_pos_loaded == 1)
    set(h_celoc(1).panel_control,'Visible','on');
    set(h_celoc(1).panel_preview,'Visible','on');
    set(h_celoc(1).panel_loc,'Visible','on');
    set(h_celoc(1).panel_export,'Visible','on');
end

% save stuff
setappdata(0,'celoc_filenamestack',celoc_filenamestack);
setappdata(0,'celoc_pathnamestack',celoc_pathnamestack);
setappdata(0,'celoc_imext',celoc_imext);
setappdata(0,'celoc_Nimages',celoc_Nimages);
setappdata(0,'celoc_im_preview',celoc_im_preview);
setappdata(0,'celoc_BW_mask',celoc_BW_mask);
% setappdata(0,'MM_im_pos_list',MM_im_pos_list);
% setappdata(0,'MM_im_pos_array',MM_im_pos_array);
% setappdata(0,'celoc_im_pos_list',celoc_im_pos_list);
setappdata(0,'celoc_conv',celoc_conv);
setappdata(0,'celoc_image_counter',celoc_image_counter);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_std',celoc_angle_std);
setappdata(0,'images_loaded',images_loaded);
setappdata(0,'celoc_contr_sens',celoc_contr_sens);
setappdata(0,'celoc_fluor_sens',celoc_fluor_sens);
setappdata(0,'celoc_im_type',type);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_load_im_coords(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_image_counter = getappdata(0,'celoc_image_counter');
images_loaded = getappdata(0,'images_loaded');
image_pos_loaded = getappdata(0,'image_pos_loaded');

% get pos list object
MM_im_pos_list = javaObject('org.micromanager.api.PositionList');

% get pos list filepath
[filename,pathname] = uigetfile('*.pos');
grid_pos_filename = [pathname,filename];
celoc_pos_list_pathname = pathname;

% decide if input file is a .pos, a .czi, or a .csv
[filepath,name,ext] = fileparts(filename)
if strcmp(ext, '.pos') == 1
    % load pos list
    MM_im_pos_list.load(grid_pos_filename);

    % get multistage positions
    MM_im_pos_array = MM_im_pos_list.getPositions();

    % initialize im pos list
    celoc_im_pos_list = cell(1,celoc_Nimages);

    % get positions
    for i = 1:celoc_Nimages
        % get XYStage position
        pos_XY = MM_im_pos_array(i).get('XYStage');
        pos_Z = MM_im_pos_array(i).get('FocusDrive')
        % get FocusDrive position
        % pos_Z = MM_im_pos_array(i).get('FocusDrive'); % want to use this? yes
        % load positions into list
        celoc_im_pos_list{i} = [pos_XY.x pos_XY.y pos_Z.z];
        % celoc_im_Zpos_list{i}? = pos_Z.x;
    end
    
elseif strcmp(ext, '.czi') == 1 || strcmp(ext, '.csv') == 1
    posXYZ = getPositions(filename, ext)
    sz = size(posXYZ)
    celoc_im_pos_list = cell(1,sz(1));
    for i = 1:sz(1)
        celoc_im_pos_list{i}=[posXYZ(i,1) posXYZ(i,2) posXYZ(i,3)];
    end
end

% display image coordinates
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);

% confirm images loaded
image_pos_loaded = 1;

% if images and positions loaded activate panels
if (images_loaded == 1) && (image_pos_loaded == 1)
    set(h_celoc(1).panel_control,'Visible','on');
    set(h_celoc(1).panel_preview,'Visible','on');
    set(h_celoc(1).panel_loc,'Visible','on');
    set(h_celoc(1).panel_export,'Visible','on');
end

% save stuff
setappdata(0,'MM_im_pos_list',MM_im_pos_list);
if ext == '.pos'
    setappdata(0,'MM_im_pos_array',MM_im_pos_array);
end
setappdata(0,'celoc_im_pos_list',celoc_im_pos_list);
setappdata(0,'celoc_pos_list_pathname',celoc_pos_list_pathname);
setappdata(0,'image_pos_loaded',image_pos_loaded);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_imp_cell_pos(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');

% get unit conversion
celoc_conv = str2double(get(h_celoc(1).edit_conv,'string'));

% get pos list object
MM_imp_cell_pos_list = javaObject('org.micromanager.api.PositionList');

% get pos list filepath
[filename,pathname] = uigetfile('*.pos');
grid_pos_filename = [pathname,filename];

% re-initialize stacks
celoc_BW_mask = cell(1,celoc_Nimages);
celoc_cell_pos_list = cell(1,celoc_Nimages);
celoc_cell_disp_list = cell(1,celoc_Nimages);
celoc_Ncells = cell(1,celoc_Nimages);
celoc_area_list = cell(1,celoc_Nimages);
celoc_aspect_list = cell(1,celoc_Nimages);
celoc_angle_list = cell(1,celoc_Nimages);
celoc_majaxis_list = cell(1,celoc_Nimages);
celoc_minaxis_list = cell(1,celoc_Nimages);
celoc_area_avg = cell(1,celoc_Nimages);
celoc_aspect_avg = cell(1,celoc_Nimages);
celoc_angle_avg = cell(1,celoc_Nimages);
celoc_area_std = cell(1,celoc_Nimages);
celoc_aspect_std = cell(1,celoc_Nimages);
celoc_angle_std = cell(1,celoc_Nimages);
celoc_cell_tot = 0;

% status bar
sb = statusbar(h_celoc(1).fig,'Importing... ');
sb.getComponent(0).setForeground(java.awt.Color.red);

% load pos list
MM_imp_cell_pos_list.load(grid_pos_filename);

% get multistage positions
MM_imp_cell_pos_array = MM_imp_cell_pos_list.getPositions();
celoc_cell_tot = size(MM_imp_cell_pos_array,1);

% get positions
for i = 1:celoc_cell_tot
    % get XYStage position
    pos_XY = MM_imp_cell_pos_array(i).get('XYStage');
    % get FocusDrive position
    % pos_Z = MM_imp_cell_pos_array(i).get('FocusDrive');
    
    % sort by image
    for j = 1:celoc_Nimages
        % get image dimensions
        [y_dim,x_dim] = size(celoc_im_preview{j});
        
        % get image boundaries
        min_x = celoc_im_pos_list{j}(1) - .5*x_dim*celoc_conv;
        max_x = celoc_im_pos_list{j}(1) + .5*x_dim*celoc_conv;
        min_y = celoc_im_pos_list{j}(2) - .5*y_dim*celoc_conv;
        max_y = celoc_im_pos_list{j}(2) + .5*y_dim*celoc_conv;
        
        % check if cell within boundary
        if (pos_XY.x > min_x && pos_XY.x < max_x) && (pos_XY.y > min_y && pos_XY.y < max_y)
            % add position to pos list
            celoc_cell_pos_list{j}(end+1,:) = [pos_XY.x pos_XY.y];
            
            % convert to image coordinates
            disp_x = -(pos_XY.x - celoc_im_pos_list{j}(1))/celoc_conv + x_dim/2;
            disp_y = -(pos_XY.y - celoc_im_pos_list{j}(2))/celoc_conv + y_dim/2;
            celoc_cell_disp_list{j}(end+1,:) = [disp_x disp_y];
            
            % update celoc_Ncells
            celoc_Ncells{j} = size(celoc_cell_pos_list{j},1);
            
            % update cell stats
            celoc_area_list{j}(end+1) = NaN;
            celoc_majaxis_list{j}(end+1) = NaN;
            celoc_minaxis_list{j}(end+1) = NaN;
            celoc_aspect_list{j}(end+1) = NaN;
            celoc_angle_list{j}(end+1) = NaN;
        end
    end
end

% update cell stats
for j = 1:celoc_Nimages
    celoc_area_avg{j} = NaN;
    celoc_area_std{j} = NaN;
    celoc_aspect_avg{j} = NaN;
    celoc_aspect_std{j} = NaN;
    celoc_angle_avg{j} = NaN;
    celoc_angle_std{j} = NaN;
    celoc_BW_mask{j} = NaN;
end

% display
%update statusbar
sb=statusbar(h_celoc(1).fig,'Done !');
sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));

% reset cell counter
celoc_cell_counter = 1;

% display cell positions on current image
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});hold on;
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight first cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    % display new coordinates
    set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}),'value',celoc_cell_counter);

    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    if ~isempty(celoc_BW_mask{celoc_image_counter})
        BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
        BW_crop = bwselect(BW_crop,75,75,8);
        BW_outline = bwboundaries(BW_crop);
        % check for region
        if ~isempty(BW_outline)
            outlineX = BW_outline{1}(:,2);
            outlineY = BW_outline{1}(:,1);
        else
            outlineX = 0;
            outlineY = 0;
        end
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;

else
    % clear pos list
    set(h_celoc(1).listbox_cellpos,'string',[]);
    % clear cell detail
    cla(h_celoc(1).axes_cell);
end
hold off;

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]); % out of total
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end

% save stuff
setappdata(0,'celoc_image_counter',celoc_image_counter);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);
setappdata(0,'celoc_BW_mask',celoc_BW_mask);
setappdata(0,'celoc_conv',celoc_conv);
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_std',celoc_angle_std);
% 

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_locate(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_std = getappdata(0,'celoc_angle_std');

% get cell selection parameters
celoc_conv = str2double(get(h_celoc(1).edit_conv,'string'));
celoc_area_min = str2double(get(h_celoc(1).edit_area_min,'string'))/(celoc_conv)^2; 
celoc_area_max = str2double(get(h_celoc(1).edit_area_max,'string'))/(celoc_conv)^2;
celoc_aspect_min = str2double(get(h_celoc(1).edit_aspect_min,'string'));
celoc_aspect_max = str2double(get(h_celoc(1).edit_aspect_max,'string'));
celoc_angle_min = str2double(get(h_celoc(1).edit_angle_min,'string'));
celoc_angle_max = str2double(get(h_celoc(1).edit_angle_max,'string'));
celoc_thresh = str2double(get(h_celoc(1).edit_thresh,'string'));
% convert aspect ratio to eccentricity
celoc_eccent_min = sqrt(1-(1/celoc_aspect_min)^2);
celoc_eccent_max = sqrt(1-(1/celoc_aspect_max)^2);
% 

for i = 1:celoc_Nimages
    % status bar
    sb = statusbar(h_celoc(1).fig,['Calculating... ',num2str(floor(100*(i-1)/celoc_Nimages)),'%% done']);
    sb.getComponent(0).setForeground(java.awt.Color.red);
    
    % get image
    I = celoc_im_preview{i};
    % get image size
    im_sizeX = size(I,2);
    im_sizeY = size(I,1);
    % enhance contrast
    I = adapthisteq(I);
    % filter noise
    [~,noise] = wiener2(I,[4 4]);
    I = wiener2(I,[4 4],noise);
    % sharpen
    I = imsharpen(I,'Radius',4,'Amount',1.8,'Threshold',0.05);
    % find outlines
    % [~, threshold] = edge(I, 'Canny');
    % fudge = celoc_thresh;
    BW = edge(I,'Canny',[0.001,.4]);
    % refine blobs
    BW = imdilate(BW,strel('disk',2));
    BW = imfill(BW, 'holes');
    BW = imerode(BW,strel('disk',6));
    BW = imdilate(BW,strel('disk',3));
    % filter objects
    BW = imclearborder(BW);
    BW = bwpropfilt(BW,'area',[celoc_area_min celoc_area_max]);
    BW = bwpropfilt(BW,'orientation',[celoc_angle_min celoc_angle_max]);
    BW = bwpropfilt(BW,'eccentricity',[celoc_eccent_min celoc_eccent_max]);
    % save mask
    celoc_BW_mask{i} = BW;
    % get coordinates
    stats = regionprops(BW,'Centroid','Area','MajorAxisLength','MinorAxisLength','Orientation');
    celoc_cell_disp_list{i} = []; %re-initialize to overwrite leftover values
    celoc_cell_pos_list{i} = [];
    celoc_cell_disp_list{i} = cat(1,stats.Centroid);
    % TRANSFORM TO IMAGE COORDINATES
    % create transformation vector
    transX = (im_sizeX/2);
    transY = (im_sizeY/2);
    trans = [transX transY];
    % check for cells
    if ~isempty(celoc_cell_disp_list{i})
        % transform disp list
        celoc_cell_pos_list{i} = -celoc_cell_disp_list{i}+trans;
        % convert to um
        celoc_cell_pos_list{i} = celoc_cell_pos_list{i}.*celoc_conv;
        % transform to stage coordinates
        %celoc_cell_pos_list{i} = celoc_cell_pos_list{i}+[celoc_im_pos_list{i}(1) celoc_im_pos_list{i}(2)];
        % transform to stage coordinates
        type = getappdata(0, 'celoc_im_type');
        if strcmp(type, '.czi') == 1
            % Because of system dependent stage direction, the last term may
            % ned to be added or subtracted as needed.
            celoc_cell_pos_list{i} = [celoc_im_pos_list{i}(1) celoc_im_pos_list{i}(2)] - celoc_cell_pos_list{i};
        elseif strcmp(type, '.tif') == 1
            celoc_cell_pos_list{i} = [celoc_im_pos_list{i}(1) celoc_im_pos_list{i}(2)] + celoc_cell_pos_list{i};
        end

    else
    end
    
    % check for locations
    if isempty(celoc_cell_pos_list{i})
        celoc_area_list{i} = NaN;
        celoc_majaxis_list{i} = NaN;
        celoc_minaxis_list{i} = NaN;
        celoc_aspect_list{i} = NaN;
        celoc_angle_list{i} = NaN;
        celoc_Ncells{i} = 0;
    else
       celoc_area_list{i} = cat(1,stats.Area).*(celoc_conv)^2;
       celoc_majaxis_list{i} = cat(1,stats.MajorAxisLength).*celoc_conv;
       celoc_minaxis_list{i} = cat(1,stats.MinorAxisLength).*celoc_conv;
       celoc_aspect_list{i} = celoc_majaxis_list{i}./celoc_minaxis_list{i};
       celoc_angle_list{i} = cat(1,stats.Orientation);
       celoc_Ncells{i} = size(celoc_cell_pos_list{i}(:,1),1);
    end
end

%update statusbar
sb=statusbar(h_celoc(1).fig,'Done !');
sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));

% reset cell counter
celoc_cell_counter = 1;

% display cell positions on current image
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});hold on;
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight first cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    % display new coordinates
    set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}),'value',celoc_cell_counter);

    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    if ~isempty(celoc_BW_mask{celoc_image_counter})
        BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
        BW_crop = bwselect(BW_crop,75,75,8);
        BW_outline = bwboundaries(BW_crop);
        % check for region
        if ~isempty(BW_outline)
            outlineX = BW_outline{1}(:,2);
            outlineY = BW_outline{1}(:,1);
        else
            outlineX = 0;
            outlineY = 0;
        end
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;

else
    % clear pos list
    set(h_celoc(1).listbox_cellpos,'string',[]);
    % clear cell detail
    cla(h_celoc(1).axes_cell);
end
hold off;

% calculate cell stats
celoc_cell_tot = 0;
for j = 1:celoc_Nimages
    celoc_area_avg{j} = round(nanmean(celoc_area_list{j}),3,'significant');
    celoc_area_std{j} = round(nanstd(celoc_area_list{j}),2,'significant');
    celoc_aspect_avg{j} = round(nanmean(celoc_aspect_list{j}),2,'significant');
    celoc_aspect_std{j} = round(nanstd(celoc_aspect_list{j}),2,'significant');
    celoc_angle_avg{j} = round(nanmean(celoc_angle_list{j}),2,'significant');
    celoc_angle_std{j} = round(nanstd(celoc_angle_list{j}),2,'significant');
    celoc_cell_tot = celoc_cell_tot+celoc_Ncells{j};
end

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]); % out of total
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end

% save stuff
setappdata(0,'celoc_image_counter',celoc_image_counter);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);
setappdata(0,'celoc_BW_mask',celoc_BW_mask);
setappdata(0,'celoc_conv',celoc_conv);
setappdata(0,'celoc_area_min',celoc_area_min);
setappdata(0,'celoc_area_max',celoc_area_max);
setappdata(0,'celoc_aspect_min',celoc_aspect_min);
setappdata(0,'celoc_aspect_max',celoc_aspect_max);
setappdata(0,'celoc_angle_min',celoc_angle_min);
setappdata(0,'celoc_angle_max',celoc_angle_max);
setappdata(0,'celoc_thresh',celoc_thresh);
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_std',celoc_angle_std);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_update(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_std = getappdata(0,'celoc_angle_std');

% remove old cell count from total
celoc_cell_tot = celoc_cell_tot-celoc_Ncells{celoc_image_counter};

% get cell selection parameters
celoc_conv = str2double(get(h_celoc(1).edit_conv,'string'));
celoc_area_min = str2double(get(h_celoc(1).edit_area_min,'string'))/(celoc_conv)^2;
celoc_area_max = str2double(get(h_celoc(1).edit_area_max,'string'))/(celoc_conv)^2;
celoc_aspect_min = str2double(get(h_celoc(1).edit_aspect_min,'string'));
celoc_aspect_max = str2double(get(h_celoc(1).edit_aspect_max,'string'));
celoc_angle_min = str2double(get(h_celoc(1).edit_angle_min,'string'));
celoc_angle_max = str2double(get(h_celoc(1).edit_angle_max,'string'));
celoc_thresh = str2double(get(h_celoc(1).edit_thresh,'string'));
% convert aspect ratio to eccentricity
celoc_eccent_min = sqrt(1-(1/celoc_aspect_min)^2);
celoc_eccent_max = sqrt(1-(1/celoc_aspect_max)^2);

% status bar
sb = statusbar(h_celoc(1).fig,'Calculating... ');
sb.getComponent(0).setForeground(java.awt.Color.red);

% get image
I = celoc_im_preview{celoc_image_counter};
% get image size
im_sizeX = size(I,2);
im_sizeY = size(I,1);
% enhance contrast
I = adapthisteq(I);
% filter noise
[~,noise] = wiener2(I,[4 4]);
I = wiener2(I,[4 4],noise);
% sharpen
I = imsharpen(I,'Radius',4,'Amount',1.8,'Threshold',0.05);
% find outlines
% [~, threshold] = edge(I, 'Canny');
% fudge = celoc_thresh;
BW = edge(I,'Canny',[0.001,.4]);
% refine blobs
BW = imdilate(BW,strel('disk',2));
BW = imfill(BW, 'holes');
BW = imerode(BW,strel('disk',6));
BW = imdilate(BW,strel('disk',3));
% filter objects
BW = imclearborder(BW);
BW = bwpropfilt(BW,'area',[celoc_area_min celoc_area_max]);
BW = bwpropfilt(BW,'orientation',[celoc_angle_min celoc_angle_max]);
BW = bwpropfilt(BW,'eccentricity',[celoc_eccent_min celoc_eccent_max]);
% save mask
celoc_BW_mask{celoc_image_counter} = BW;
% get coordinates
stats = regionprops(BW,'Centroid','Area','MajorAxisLength','MinorAxisLength','Orientation');
celoc_cell_pos_list{celoc_image_counter} = []; %re-initialize to overwrite leftover values
celoc_cell_disp_list{celoc_image_counter} = [];
celoc_cell_disp_list{celoc_image_counter} = cat(1,stats.Centroid);
% TRANSFORM TO IMAGE COORDINATES
% create transformation vector
transX = (im_sizeX/2);
transY = (im_sizeY/2);
trans = [transX transY];
% check for cells
if ~isempty(celoc_cell_disp_list{celoc_image_counter})
    % transform disp list
    celoc_cell_pos_list{celoc_image_counter} = -celoc_cell_disp_list{celoc_image_counter}+trans;
    % convert to um
    celoc_cell_pos_list{celoc_image_counter} = celoc_cell_pos_list{celoc_image_counter}.*celoc_conv;
    % transform to stage coordinates
    %celoc_cell_pos_list{celoc_image_counter} = celoc_cell_pos_list{celoc_image_counter}+[celoc_im_pos_list{celoc_image_counter}(1) celoc_im_pos_list{celoc_image_counter}(2)];
    % transform to stage coordinates
    type = getappdata(0, 'celoc_im_type');
    if strcmp(type, '.czi') == 1
        % Because of system dependent stage direction, the last term may
        % ned to be added or subtracted as needed.
        celoc_cell_pos_list{celoc_image_counter} = [celoc_im_pos_list{celoc_image_counter}(1) celoc_im_pos_list{celoc_image_counter}(2)] - celoc_cell_pos_list{celoc_image_counter};
    elseif strcmp(type, '.tif') == 1
        celoc_cell_pos_list{celoc_image_counter} = [celoc_im_pos_list{celoc_image_counter}(1) celoc_im_pos_list{celoc_image_counter}(2)] + celoc_cell_pos_list{celoc_image_counter};
    end

else
end

% check for locations
if isempty(celoc_cell_pos_list{celoc_image_counter})
    celoc_area_list{celoc_image_counter} = NaN;
    celoc_majaxis_list{celoc_image_counter} = NaN;
    celoc_minaxis_list{celoc_image_counter} = NaN;
    celoc_aspect_list{celoc_image_counter} = NaN;
    celoc_angle_list{celoc_image_counter} = NaN;
    celoc_Ncells{celoc_image_counter} = 0;
else
    celoc_area_list{celoc_image_counter} = cat(1,stats.Area).*(celoc_conv)^2;
    celoc_majaxis_list{celoc_image_counter} = cat(1,stats.MajorAxisLength).*celoc_conv;
    celoc_minaxis_list{celoc_image_counter} = cat(1,stats.MinorAxisLength).*celoc_conv;
    celoc_aspect_list{celoc_image_counter} = celoc_majaxis_list{celoc_image_counter}./celoc_minaxis_list{celoc_image_counter};
    celoc_angle_list{celoc_image_counter} = cat(1,stats.Orientation);
    celoc_Ncells{celoc_image_counter} = size(celoc_cell_pos_list{celoc_image_counter}(:,1),1);
end

%update statusbar
sb=statusbar(h_celoc(1).fig,'Done !');
sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));

% reset cell counter
celoc_cell_counter = 1;

% display cell positions on current image
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});hold on;
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight first cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    % display new coordinates
    set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}),'value',celoc_cell_counter);

    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    if ~isempty(celoc_BW_mask{celoc_image_counter})
        BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
        BW_crop = bwselect(BW_crop,75,75,8);
        BW_outline = bwboundaries(BW_crop);
        % check for region
        if ~isempty(BW_outline)
            outlineX = BW_outline{1}(:,2);
            outlineY = BW_outline{1}(:,1);
        else
            outlineX = 0;
            outlineY = 0;
        end
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;
    % 
    
else
    % clear pos list
    set(h_celoc(1).listbox_cellpos,'string',[],'value',celoc_cell_counter);
    % clear cell detail
    cla(h_celoc(1).axes_cell);
end
hold off;

% calculate cell stats
celoc_area_avg{celoc_image_counter} = round(nanmean(celoc_area_list{celoc_image_counter}),3,'significant');
celoc_area_std{celoc_image_counter} = round(nanstd(celoc_area_list{celoc_image_counter}),2,'significant');
celoc_aspect_avg{celoc_image_counter} = round(nanmean(celoc_aspect_list{celoc_image_counter}),2,'significant');
celoc_aspect_std{celoc_image_counter} = round(nanstd(celoc_aspect_list{celoc_image_counter}),2,'significant');
celoc_angle_avg{celoc_image_counter} = round(nanmean(celoc_angle_list{celoc_image_counter}),2,'significant');
celoc_angle_std{celoc_image_counter} = round(nanstd(celoc_angle_list{celoc_image_counter}),2,'significant');
celoc_cell_tot = celoc_cell_tot+celoc_Ncells{celoc_image_counter};

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]);
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end

% save stuff
setappdata(0,'celoc_image_counter',celoc_image_counter);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);
setappdata(0,'celoc_BW_mask',celoc_BW_mask);
setappdata(0,'celoc_conv',celoc_conv);
setappdata(0,'celoc_area_min',celoc_area_min);
setappdata(0,'celoc_area_max',celoc_area_max);
setappdata(0,'celoc_aspect_min',celoc_aspect_min);
setappdata(0,'celoc_aspect_max',celoc_aspect_max);
setappdata(0,'celoc_angle_min',celoc_angle_min);
setappdata(0,'celoc_angle_max',celoc_angle_max);
setappdata(0,'celoc_thresh',celoc_thresh);
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_std',celoc_angle_std);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_contract(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_pathnamestack = getappdata(0,'celoc_pathnamestack');
celoc_filenamestack = getappdata(0,'celoc_filenamestack');
celoc_imext = getappdata(0,'celoc_imext');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_contr_sens = getappdata(0,'celoc_contr_sens');
type = getappdata(0, 'celoc_im_type');
Nchannels = getappdata(0, 'Nchannels');
Ntime_series = getappdata(0, 'Ntime_series');

% create gui window
figuresize = [675 630];
screensize = get(0,'ScreenSize');
xpos = ceil((screensize(3)-figuresize(2))/2);
ypos = ceil((screensize(4)-figuresize(1))/2);
h_celoc(1).sens_fig = figure(...
    'position',[xpos, ypos, figuresize(2), figuresize(1)],...
    'units','pixels',...
    'renderer','OpenGL',...
    'MenuBar','none',...
    'PaperPositionMode','auto',...
    'Name','Set Contraction Sensitivity',...
    'NumberTitle','off',...
    'Resize','off',...
    'Color',[.94,.94,.94],...
    'visible','on');

% display axes
h_celoc(1).sens_axes = axes('Parent',h_celoc(1).sens_fig,'units','pixels','position',[15,60,600,600]);
% sensitivity slider
h_celoc(1).sens_slider = uicontrol('Parent',h_celoc(1).sens_fig,'style','slider','position',[180,10,330,25],'value',celoc_contr_sens,'min',0,'max',5);
% contraction sensitivity
h_celoc(1).text_contr_sens = uicontrol('Parent',h_celoc(1).sens_fig,'style','text','position',[15,20,140,15],'string','Contr. sensitivity: (0 - 5)','HorizontalAlignment','left');
h_celoc(1).edit_contr_sens = uicontrol('Parent',h_celoc(1).sens_fig,'style','edit','position',[130,17,40,20],'string',num2str(celoc_contr_sens),'HorizontalAlignment','center');
% ok button
h_celoc(1).sens_ok = uicontrol('Parent',h_celoc(1).sens_fig,'style','pushbutton','position',[570,15,50,25],'string','Ok');
% cancel button
h_celoc(1).sens_cancel = uicontrol('Parent',h_celoc(1).sens_fig,'style','pushbutton','position',[520,15,50,25],'string','Cancel');

% load frames

if strcmp(type, '.tif') == 1
    filename = [celoc_pathnamestack{celoc_image_counter},celoc_filenamestack{celoc_image_counter},celoc_imext{celoc_image_counter}];
    info = imfinfo(filename);
    N_frames = numel(info);

    % get frame dimensions
    width = info(1).Width;
    height = info(1).Height;
    
    % initialize stack
    stack = zeros(height,width,N_frames);

    % load stack
    for i = 1:N_frames
        frameN = imread(filename,i);
        frameN = normalise(frameN);
        frameN = im2uint8(frameN);
        stack(:,:,i) = frameN;
    end
    
elseif strcmp(type, '.czi') == 1
    filename = split(celoc_filenamestack{celoc_image_counter}, ';');
    filename = filename(1);
    data = getappdata(0, 'celoc_im_data');
    
    % get frame dimensions
    series = data{celoc_image_counter, 1};
    dims = size(series{1, 1});
    height = dims(1);
    width = dims(2);
    
    % initialize stack
    stack = zeros(height,width,Ntime_series);
    
    % load stack
    stackCounter = 1;
    for i = 1:Nchannels:Nchannels*Ntime_series
        planei = series{i,1};
        planei = normalise(planei);
        planei = im2uint8(planei);
        stack(:,:,stackCounter) = planei;
        stackCounter = stackCounter + 1;
    end
end


% get stdev of stack
stdev = std(stack,0,3);
stdev = imgaussfilt(stdev,3);

% get mean stdev of frame
stdev_vect = stdev(:);
stdev_mean = mean(stdev_vect);
% stdev_median = median(stdev_vect);
stdev_stdev = std(stdev_vect);

% Create mask of regions over threshold
thresh_mask = stdev >= stdev_mean+celoc_contr_sens*stdev_stdev;

% display image
axes(h_celoc(1).sens_axes);
imshow(celoc_im_preview{celoc_image_counter}); hold on;
% display threshold overlay
over = imagesc(thresh_mask);% colormap parula;
over.AlphaData = thresh_mask;

% plan b
% change to solid color
    % green?
% overlay positions

% set callbacks
set(h_celoc(1).sens_slider,'Callback',{@set_contr_slider,h_celoc});
set(h_celoc(1).sens_ok,'Callback',{@push_contr_ok,h_celoc});
set(h_celoc(1).sens_cancel,'Callback',{@push_contr_cancel,h_celoc});

% set contraction sensitivity
set(h_celoc(1).edit_contr_sens,'string',num2str(celoc_contr_sens));

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function set_contr_slider(hObject,eventdata,h_celoc)

% disable slider until finished
set(h_celoc(1).sens_slider,'Enable','off');
try

% load shared parameters
% sens_fig = getappdata(0,'sens_fig');
celoc_pathnamestack = getappdata(0,'celoc_pathnamestack');
celoc_filenamestack = getappdata(0,'celoc_filenamestack');
celoc_imext = getappdata(0,'celoc_imext');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_image_counter = getappdata(0,'celoc_image_counter');
type = getappdata(0, 'celoc_im_type');
Nchannels = getappdata(0, 'Nchannels');
Ntime_series = getappdata(0, 'Ntime_series');

% get contraction sensitivity
celoc_contr_sens = get(h_celoc(1).sens_slider,'value');

% load frames

if strcmp(type, '.tif') == 1
    filename = [celoc_pathnamestack{celoc_image_counter},celoc_filenamestack{celoc_image_counter},celoc_imext{celoc_image_counter}];
    info = imfinfo(filename);
    N_frames = numel(info);

    % get frame dimensions
    width = info(1).Width;
    height = info(1).Height;
    
    % initialize stack
    stack = zeros(height,width,N_frames);

    % load stack
    for i = 1:N_frames
        frameN = imread(filename,i);
        frameN = normalise(frameN);
        frameN = im2uint8(frameN);
        stack(:,:,i) = frameN;
    end
    
elseif strcmp(type, '.czi') == 1
    filename = split(celoc_filenamestack{celoc_image_counter}, ';');
    filename = filename(1);
    data = getappdata(0, 'celoc_im_data');
    
    % get frame dimensions
    series = data{celoc_image_counter, 1};
    dims = size(series{1, 1});
    height = dims(1);
    width = dims(2);
    
    % initialize stack
    stack = zeros(height,width,Ntime_series);
    
    % load stack
    stackCounter = 1;
    for i = 1:Nchannels:Nchannels*Ntime_series
        planei = series{i,1};
        planei = normalise(planei);
        planei = im2uint8(planei);
        stack(:,:,stackCounter) = planei;
        stackCounter = stackCounter + 1;
    end
end

% get stdev of stack
stdev = std(stack,0,3);
stdev = imgaussfilt(stdev,3);

% get mean stdev of frame
stdev_vect = stdev(:);
stdev_mean = mean(stdev_vect);
% stdev_median = median(stdev_vect);
stdev_stdev = std(stdev_vect);

% Create mask of regions over threshold
thresh_mask = stdev >= stdev_mean+celoc_contr_sens*stdev_stdev;

% display image
axes(h_celoc(1).sens_axes);
imshow(celoc_im_preview{celoc_image_counter}); hold on;
% display threshold overlay
imagesc(stdev*255,'AlphaData',thresh_mask);

% set contraction sensitivity
set(h_celoc(1).edit_contr_sens,'string',num2str(celoc_contr_sens));

setappdata(0,'celoc_contr_sens',celoc_contr_sens);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

%enable slider
set(h_celoc(1).sens_slider,'Enable','on');

end

function push_contr_ok(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).sens_fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).sens_fig,1));

try

% load shared parameters
celoc_pathnamestack = getappdata(0,'celoc_pathnamestack');
celoc_filenamestack = getappdata(0,'celoc_filenamestack');
celoc_imext = getappdata(0,'celoc_imext');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_conv = getappdata(0,'celoc_conv');
celoc_area_min = getappdata(0,'celoc_area_min');
celoc_area_max = getappdata(0,'celoc_area_max');
celoc_aspect_min = getappdata(0,'celoc_aspect_min');
celoc_aspect_max = getappdata(0,'celoc_aspect_max');
celoc_angle_min = getappdata(0,'celoc_angle_min');
celoc_angle_max = getappdata(0,'celoc_angle_max');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_std = getappdata(0,'celoc_angle_std');
type = getappdata(0, 'celoc_im_type');
Nchannels = getappdata(0, 'Nchannels');
Ntime_series = getappdata(0, 'Ntime_series');

% initialize beating pos_list
beat_pos_list = cell(1,celoc_Nimages);
beat_count = 0;

% get cell selection parameters
celoc_conv = str2double(get(h_celoc(1).edit_conv,'string'));
celoc_area_min = str2double(get(h_celoc(1).edit_area_min,'string'))/(celoc_conv)^2;
celoc_area_max = str2double(get(h_celoc(1).edit_area_max,'string'))/(celoc_conv)^2;
celoc_aspect_min = str2double(get(h_celoc(1).edit_aspect_min,'string'));
celoc_aspect_max = str2double(get(h_celoc(1).edit_aspect_max,'string'));
celoc_angle_min = str2double(get(h_celoc(1).edit_angle_min,'string'));
celoc_angle_max = str2double(get(h_celoc(1).edit_angle_max,'string'));
% get sensitivity coefficient
celoc_contr_sens = get(h_celoc(1).sens_slider,'Value');

for i = 1:celoc_Nimages
    % check for image stacks
    if strcmp(type, '.tif') == 1
    filename = [celoc_pathnamestack{celoc_image_counter},celoc_filenamestack{celoc_image_counter},celoc_imext{celoc_image_counter}];
    info = imfinfo(filename);
    N_frames = numel(info);

    % get frame dimensions
    width = info(1).Width;
    height = info(1).Height;
    
    % initialize stack
    stack = zeros(height,width,N_frames);

    % load stack
    for i = 1:N_frames
        frameN = imread(filename,i);
        frameN = normalise(frameN);
        frameN = im2uint8(frameN);
        stack(:,:,i) = frameN;
    end
    
elseif strcmp(type, '.czi') == 1
    filename = split(celoc_filenamestack{celoc_image_counter}, ';');
    filename = filename(1);
    data = getappdata(0, 'celoc_im_data');
    
    % get frame dimensions
    series = data{celoc_image_counter, 1};
    dims = size(series{1, 1});
    height = dims(1);
    width = dims(2);
    
    % initialize stack
    stack = zeros(height,width,Ntime_series);
    
    % load stack
    stackCounter = 1;
    for j = 1:Nchannels:Nchannels*Ntime_series
        frameN = series{j,1};
        frameN = normalise(frameN);
        frameN = im2uint8(frameN);
        stack(:,:,stackCounter) = frameN;
        stackCounter = stackCounter + 1;
    end
end
    
    % get stdev of stack
    stdev = std(stack,0,3);
    stdev = imgaussfilt(stdev,3);
    % apply gaussian filter 2-3 pixel
    
    % get mean stdev of frame
    stdev_vect = stdev(:);
    stdev_mean = mean(stdev_vect);
    % stdev_median = median(stdev_vect);
    stdev_stdev = std(stdev_vect);
    
    % check each coordinate for movement
    for k = 1:celoc_Ncells{i}
        % get cell info for crop
        if isnan(celoc_area_list{i}(k))
            avg_area = (celoc_area_min + celoc_area_max)/2;
            avg_aspect = (celoc_aspect_min + celoc_aspect_max)/2;
            crop_angle = ((celoc_angle_min + celoc_angle_max)/2)*(pi/180);
            crop_width = sqrt(avg_area/avg_aspect)/celoc_conv;
            crop_length = avg_aspect*crop_width;
        else
            crop_angle = celoc_angle_list{i}(k)*(pi/180);
            crop_width = celoc_minaxis_list{i}(k)/celoc_conv;
            crop_length = celoc_majaxis_list{i}(k)/celoc_conv;
        end
        
        % calculate cell crop
        x1=celoc_cell_disp_list{i}(k,1)-(crop_length/2)*cos(crop_angle)+(crop_width/2)*sin(crop_angle);
        x2=celoc_cell_disp_list{i}(k,1)-(crop_length/2)*cos(crop_angle)-(crop_width/2)*sin(crop_angle);
        x3=celoc_cell_disp_list{i}(k,1)+(crop_length/2)*cos(crop_angle)-(crop_width/2)*sin(crop_angle);
        x4=celoc_cell_disp_list{i}(k,1)+(crop_length/2)*cos(crop_angle)+(crop_width/2)*sin(crop_angle);
        y1=celoc_cell_disp_list{i}(k,2)+(crop_length/2)*sin(crop_angle)+(crop_width/2)*cos(crop_angle);
        y2=celoc_cell_disp_list{i}(k,2)+(crop_length/2)*sin(crop_angle)-(crop_width/2)*cos(crop_angle);
        y3=celoc_cell_disp_list{i}(k,2)-(crop_length/2)*sin(crop_angle)-(crop_width/2)*cos(crop_angle);
        y4=celoc_cell_disp_list{i}(k,2)-(crop_length/2)*sin(crop_angle)+(crop_width/2)*cos(crop_angle);
        x_mask=[x1 x2 x3 x4 x1];
        y_mask=[y1 y2 y3 y4 y1];
        mask=roipoly(frameN,x_mask,y_mask);
        
        stdev_mask = stdev.*mask;
        stdev_mask(stdev_mask == 0) = NaN;
        
        % get bounding box of cell
        mask_data = regionprops(mask,'BoundingBox');
        cell_box = mask_data.BoundingBox;
        
        % calculate stdev of cell area
        cell_stdev_crop = imcrop(stdev_mask,cell_box);
        cell_stdev_vect = cell_stdev_crop(:);
        cell_stdev_mean(k) = nanmean(cell_stdev_vect);
        
        % check for movement
        if cell_stdev_mean(k) >= stdev_mean+celoc_contr_sens*stdev_stdev
            % get coordinates
            beat_pos_list{i}(k,1) = celoc_cell_disp_list{i}(k,1);
            beat_pos_list{i}(k,2) = celoc_cell_disp_list{i}(k,2);
            
            % add to counter
            beat_count = beat_count+1;
        else
            % add zero coordinate
            beat_pos_list{i}(k,1) = 0;
            beat_pos_list{i}(k,2) = 0;
        end 
    end
end
    
% open dialog window
answer = questdlg(['Cell Location Wizard found ',num2str(beat_count),' beating cells out of ',num2str(celoc_cell_tot),' total. Do you wish to remove non-beating cells from the list?'],'Contraction Detection','Yes','No','No');

switch answer
    case 'Yes'
        % remove data from lists        
        for i = 1:celoc_Nimages
            % find indices of positions to discard
            if ~isempty(beat_pos_list{i})
                ind = find(beat_pos_list{i}(:,1) == 0);
                
                % discard positions and data
                celoc_cell_disp_list{i}(ind,:) = [];
                celoc_cell_pos_list{i}(ind,:) = [];
                celoc_area_list{i}(ind) = [];
                celoc_aspect_list{i}(ind) = [];
                celoc_angle_list{i}(ind) = [];
                celoc_majaxis_list{i}(ind) = [];
                celoc_minaxis_list{i}(ind) = [];
                
                % recalculate cell stats
                celoc_area_avg{i} = round(nanmean(celoc_area_list{i}),3,'significant');
                celoc_area_std{i} = round(nanstd(celoc_area_list{i}),2,'significant');
                celoc_aspect_avg{i} = round(nanmean(celoc_aspect_list{i}),2,'significant');
                celoc_aspect_std{i} = round(nanstd(celoc_aspect_list{i}),2,'significant');
                celoc_angle_avg{i} = round(nanmean(celoc_angle_list{i}),2,'significant');
                celoc_angle_std{i} = round(nanstd(celoc_angle_list{i}),2,'significant');
                celoc_Ncells{i} = celoc_Ncells{i}-length(ind);
            end
        end
        
        celoc_cell_tot = beat_count;
    case 'No'
        % 
end

% reset cell counter
celoc_cell_counter = 1;

% display cell positions on current image
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});hold on;
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight first cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    % display new coordinates
    set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}),'value',celoc_cell_counter);

    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    if ~isempty(celoc_BW_mask{celoc_image_counter})
        BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
        BW_crop = bwselect(BW_crop,75,75,8);
        BW_outline = bwboundaries(BW_crop);
        % check for region
        if ~isempty(BW_outline)
            outlineX = BW_outline{1}(:,2);
            outlineY = BW_outline{1}(:,1);
        else
            outlineX = 0;
            outlineY = 0;
        end
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;
    
else
    % clear pos list
    set(h_celoc(1).listbox_cellpos,'string',[],'value',celoc_cell_counter);
    % clear cell detail
    cla(h_celoc(1).axes_cell);
end
hold off;

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]);
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end

close(h_celoc(1).sens_fig);

% save stuff
setappdata(0,'celoc_image_counter',celoc_image_counter);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);
setappdata(0,'celoc_BW_mask',celoc_BW_mask);
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_std',celoc_angle_std);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_contr_cancel(hObject,eventdata,h_celoc)

try

close(h_celoc(1).sens_fig);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_fluor(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_std = getappdata(0,'celoc_angle_std');

% initialize fluorescent pos_list
fluor_pos_list = cell(1,celoc_Nimages);
fluor_count = 0;

% get cell selection parameters
celoc_conv = str2double(get(h_celoc(1).edit_conv,'string'));
celoc_area_min = str2double(get(h_celoc(1).edit_area_min,'string'))/(celoc_conv)^2;
celoc_area_max = str2double(get(h_celoc(1).edit_area_max,'string'))/(celoc_conv)^2;
celoc_aspect_min = str2double(get(h_celoc(1).edit_aspect_min,'string'));
celoc_aspect_max = str2double(get(h_celoc(1).edit_aspect_max,'string'));
celoc_angle_min = str2double(get(h_celoc(1).edit_angle_min,'string'));
celoc_angle_max = str2double(get(h_celoc(1).edit_angle_max,'string'));
% get sensitivity coefficient
celoc_fluor_sens = .2; %get(h_celoc(1).fluor_slider,'Value');

% load fluorescent images
% if initial file type was a .czi, images were already selected
type = getappdata(0, 'celoc_im_type');
Nimages = getappdata(0, 'celoc_Nimages');
Nchannels = getappdata(0, 'Nchannels');
if strcmp(type, '.tif') == 1
    [filename,pathname] = uigetfile('*.tif','MultiSelect','on');
    filename = cellstr(filename);
    celoc_Nfluorimages = size(filename,2);
    
elseif strcmp(type, '.czi') == 1
    filename = getappdata(0, 'celoc_filenamestack');
    filename = filename{1, 1};
    filename = split(filename, ';', 1);
    filename = cellstr(filename(1));
    pathname = getappdata(0, 'celoc_pathnamestack');
    pathname = pathname{1, 1};
    celoc_Nfluorimages = Nimages*(Nchannels-1);
    data = getappdata(0, 'celoc_im_data');
    
end
% check for cancel
if isequal(filename,0)
    return;
end

% check number of images
% if celoc_Nfluorimages ~= celoc_Nimages
    % error message
    % return
% end

% loop over images
for i=1:celoc_Nfluorimages
    if strcmp(type, '.tif') == 1
        % get filename
        [~,name,ext] = fileparts(strcat(pathname,filename{1,i}));
        fluor_filename = [pathname,name,ext];

        % load image
        imagei = imread(fluor_filename,1);
        imagei = normalise(imagei);
        % imagei = im2uint8(imagei);
    elseif strcmp(type, '.czi') == 1
        i = int16(i/(Nchannels-1));
        %load image
        series = data{i, 1};
        imagei = series{2,1};
        imagei = normalise(imagei);
        % imagei = im2uint8(imagei);
    end
    
    % set crop size
    cropsize = 100/celoc_conv;
    
    % loop over cells
    for j = 1:celoc_Ncells{i}
        % get cell info for crop
        if isnan(celoc_area_list{i}(j))
            avg_area = (celoc_area_min + celoc_area_max)/2;
            avg_aspect = (celoc_aspect_min + celoc_aspect_max)/2;
            crop_angle = ((celoc_angle_min + celoc_angle_max)/2)*(pi/180);
            crop_width = sqrt(avg_area/avg_aspect)/celoc_conv;
            crop_length = avg_aspect*crop_width;
        else
            crop_angle = celoc_angle_list{i}(j)*(pi/180);
            crop_width = celoc_minaxis_list{i}(j)/celoc_conv;
            crop_length = celoc_majaxis_list{i}(j)/celoc_conv;
        end
        
        % calculate cell crop
        x1=celoc_cell_disp_list{i}(j,1)-(crop_length/2)*cos(crop_angle)+(crop_width/2)*sin(crop_angle);
        x2=celoc_cell_disp_list{i}(j,1)-(crop_length/2)*cos(crop_angle)-(crop_width/2)*sin(crop_angle);
        x3=celoc_cell_disp_list{i}(j,1)+(crop_length/2)*cos(crop_angle)-(crop_width/2)*sin(crop_angle);
        x4=celoc_cell_disp_list{i}(j,1)+(crop_length/2)*cos(crop_angle)+(crop_width/2)*sin(crop_angle);
        y1=celoc_cell_disp_list{i}(j,2)+(crop_length/2)*sin(crop_angle)+(crop_width/2)*cos(crop_angle);
        y2=celoc_cell_disp_list{i}(j,2)+(crop_length/2)*sin(crop_angle)-(crop_width/2)*cos(crop_angle);
        y3=celoc_cell_disp_list{i}(j,2)-(crop_length/2)*sin(crop_angle)-(crop_width/2)*cos(crop_angle);
        y4=celoc_cell_disp_list{i}(j,2)-(crop_length/2)*sin(crop_angle)+(crop_width/2)*cos(crop_angle);
        x_mask=[x1 x2 x3 x4 x1];
        y_mask=[y1 y2 y3 y4 y1];
        mask=roipoly(imagei,x_mask,y_mask);
        cell_area = mask.*imagei;
        cell_area(cell_area == 0) = NaN;
        
        % set xmin and ymin for roi
        xmin = celoc_cell_disp_list{i}(j,1) - cropsize/2;
        ymin = celoc_cell_disp_list{i}(j,2) - cropsize/2;
        
        % crop roi
        roi = imcrop(imagei,[xmin,ymin,cropsize,cropsize]);
        roi_vect = roi(:);
        roi_mean = mean(roi_vect);
        roi_stdev = std(roi_vect);
        
        % get bounding box of cell
        mask_data = regionprops(mask,'BoundingBox');
        cell_box = mask_data.BoundingBox;
        
        % calculate mean of cell area 
        cell_crop = imcrop(cell_area,cell_box);
        cell_vect = cell_crop(:);
        cell_mean(j) = nanmean(cell_vect);
        
        % check for fluorescence
        if cell_mean(j) >= roi_mean+celoc_fluor_sens*roi_stdev
            % get coordinates
            fluor_pos_list{i}(j,1) = celoc_cell_disp_list{i}(j,1);
            fluor_pos_list{i}(j,2) = celoc_cell_disp_list{i}(j,2);
            
            % add to counter
            fluor_count = fluor_count+1;
        else
            % add zero coordinate
            fluor_pos_list{i}(j,1) = 0;
            fluor_pos_list{i}(j,2) = 0;
        end 
    end
end

% open dialog window
answer = questdlg(['Cell Location Wizard found ',num2str(fluor_count),' fluorescent cells out of ',num2str(celoc_cell_tot),' total. Do you wish to remove non-fluorescent cells from the list?'],'Fluorescence Detection','Yes','No','No');

switch answer
    case 'Yes'
        % remove data from lists        
        for i = 1:celoc_Nimages
            % ensure there are cells to begin with
            if celoc_Ncells{i} > 0

                % find indices of positions to discard
                ind = find(fluor_pos_list{i}(:,1) == 0);

                % discard positions and data
                celoc_cell_disp_list{i}(ind,:) = [];
                celoc_cell_pos_list{i}(ind,:) = [];
                celoc_area_list{i}(ind) = [];
                celoc_aspect_list{i}(ind) = [];
                celoc_angle_list{i}(ind) = [];
                celoc_majaxis_list{i}(ind) = [];
                celoc_minaxis_list{i}(ind) = [];

                % recalculate cell stats
                celoc_area_avg{i} = round(nanmean(celoc_area_list{i}),3,'significant');
                celoc_area_std{i} = round(nanstd(celoc_area_list{i}),2,'significant');
                celoc_aspect_avg{i} = round(nanmean(celoc_aspect_list{i}),2,'significant');
                celoc_aspect_std{i} = round(nanstd(celoc_aspect_list{i}),2,'significant');
                celoc_angle_avg{i} = round(nanmean(celoc_angle_list{i}),2,'significant');
                celoc_angle_std{i} = round(nanstd(celoc_angle_list{i}),2,'significant');
                celoc_Ncells{i} = celoc_Ncells{i}-length(ind);
            end
        end
        
        celoc_cell_tot = fluor_count;
    case 'No'
        % 
end

% reset cell counter
celoc_cell_counter = 1;

% display cell positions on current image
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});hold on;
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight first cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    % display new coordinates
    set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}),'value',celoc_cell_counter);

    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    if ~isempty(celoc_BW_mask{celoc_image_counter})
        BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
        BW_crop = bwselect(BW_crop,75,75,8);
        BW_outline = bwboundaries(BW_crop);
        % check for region
        if ~isempty(BW_outline)
            outlineX = BW_outline{1}(:,2);
            outlineY = BW_outline{1}(:,1);
        else
            outlineX = 0;
            outlineY = 0;
        end
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;
    
else
    % clear pos list
    set(h_celoc(1).listbox_cellpos,'string',[],'value',celoc_cell_counter);
    % clear cell detail
    cla(h_celoc(1).axes_cell);
end
hold off;

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]);
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end

% save stuff
setappdata(0,'celoc_image_counter',celoc_image_counter);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);
setappdata(0,'celoc_BW_mask',celoc_BW_mask);
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_std',celoc_angle_std);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_fluor_test(hObject,eventdata,h_celoc) % UNUSED

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_fluor_sens = getappdata(0,'celoc_fluor_sens');

% load fluorescent images
[filename,pathname] = uigetfile('*.tif','MultiSelect','on');

% check for cancel
if isequal(filename,0)
    return;
end
filename = cellstr(filename);

celoc_Nfluorimages = size(filename,2);

% check number of images
% if celoc_Nfluorimages ~= celoc_Nimages
    % error message
    % return
% end

% 

% initialize stacks
celoc_fluor_filenamestack = cell(1,celoc_Nfluorimages);
celoc_fluor_pathnamestack = cell(1,celoc_Nfluorimages);
celoc_fluor_imext = cell(1,celoc_Nfluorimages);

% add filenames to stacks
for i=1:celoc_Nfluorimages
    [~,name,ext] = fileparts(strcat(pathname,filename{1,i}));
    celoc_fluor_filenamestack{i} = name;
    celoc_fluor_pathnamestack{i} = pathname;
    celoc_fluor_imext{i} = ext;
end

% create gui window
figuresize = [675 630];
screensize = get(0,'ScreenSize');
xpos = ceil((screensize(3)-figuresize(2))/2);
ypos = ceil((screensize(4)-figuresize(1))/2);
h_celoc(1).fluor_fig = figure(...
    'position',[xpos, ypos, figuresize(2), figuresize(1)],...
    'units','pixels',...
    'renderer','OpenGL',...
    'MenuBar','none',...
    'PaperPositionMode','auto',...
    'Name','Set Fluorescence Sensitivity',...
    'NumberTitle','off',...
    'Resize','off',...
    'Color',[.94,.94,.94],...
    'visible','on');

% display axes
h_celoc(1).fluor_axes = axes('Parent',h_celoc(1).fluor_fig,'units','pixels','position',[15,60,600,600]);
% sensitivity slider
h_celoc(1).fluor_slider = uicontrol('Parent',h_celoc(1).fluor_fig,'style','slider','position',[180,10,330,25],'value',celoc_fluor_sens,'min',0,'max',5);
% contraction sensitivity
h_celoc(1).text_fluor_sens = uicontrol('Parent',h_celoc(1).fluor_fig,'style','text','position',[15,20,140,15],'string','Fluor. sensitivity: (0 - 5)','HorizontalAlignment','left');
h_celoc(1).edit_fluor_sens = uicontrol('Parent',h_celoc(1).fluor_fig,'style','edit','position',[130,17,40,20],'string',num2str(celoc_fluor_sens),'HorizontalAlignment','center');
% ok button
h_celoc(1).fluor_ok = uicontrol('Parent',h_celoc(1).fluor_fig,'style','pushbutton','position',[570,15,50,25],'string','Ok');
% cancel button
h_celoc(1).fluor_cancel = uicontrol('Parent',h_celoc(1).fluor_fig,'style','pushbutton','position',[520,15,50,25],'string','Cancel');

% load image
filename = [celoc_fluor_pathnamestack{celoc_image_counter},celoc_fluor_filenamestack{celoc_image_counter},celoc_fluor_imext{celoc_image_counter}];
fluorimage = imread(filename);
fluorimage = normalise(fluorimage);

% calculate average
fluor_vect = fluorimage(:);
fluor_mean = mean(fluor_vect);
fluor_stdev = std(fluor_vect);

% create threshold mask
thresh_mask = fluorimage >= fluor_mean + celoc_fluor_sens*fluor_stdev;

% display image
axes(h_celoc(1).fluor_axes);
imshow(celoc_im_preview{celoc_image_counter}); hold on;
% display threshold overlay
over = imagesc(thresh_mask);% colormap parula;
over.AlphaData = thresh_mask;

% set callbacks
set(h_celoc(1).fluor_slider,'Callback',{@set_fluor_slider,h_celoc});
set(h_celoc(1).fluor_ok,'Callback',{@push_fluor_ok,h_celoc});
set(h_celoc(1).fluor_cancel,'Callback',{@push_fluor_cancel,h_celoc});

% set contraction sensitivity
set(h_celoc(1).edit_fluor_sens,'string',num2str(celoc_fluor_sens));

% save filenames
setappdata(0,'celoc_fluor_pathnamestack',celoc_fluor_pathnamestack);
setappdata(0,'celoc_fluor_filenamestack',celoc_fluor_filenamestack);
setappdata(0,'celoc_fluor_imext',celoc_fluor_imext);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function set_fluor_slider(hObject,eventdata,h_celoc) % UNUSED

% disable slider until finished
set(h_celoc(1).fluor_slider,'Enable','off');
try

% load shared parameters
celoc_fluor_pathnamestack = getappdata(0,'celoc_fluor_pathnamestack');
celoc_fluor_filenamestack = getappdata(0,'celoc_fluor_filenamestack');
celoc_fluor_imext = getappdata(0,'celoc_fluor_imext');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_image_counter = getappdata(0,'celoc_image_counter');

% get contraction sensitivity
celoc_fluor_sens = get(h_celoc(1).fluor_slider,'value');

% load frames
filename = [celoc_fluor_pathnamestack{celoc_image_counter},celoc_fluor_filenamestack{celoc_image_counter},celoc_fluor_imext{celoc_image_counter}];

fluorimage = imread(filename);
fluorimage = normalise(fluorimage);

% calculate average
fluor_vect = fluorimage(:);
fluor_mean = mean(fluor_vect);
fluor_stdev = std(fluor_vect);

% create threshold mask
thresh_mask = fluorimage >= fluor_mean + celoc_fluor_sens*fluor_stdev;

% display image
axes(h_celoc(1).fluor_axes);
imshow(celoc_im_preview{celoc_image_counter}); hold on;
% display threshold overlay
over = imagesc(thresh_mask);% colormap parula;
over.AlphaData = thresh_mask;

% set contraction sensitivity
set(h_celoc(1).edit_fluor_sens,'string',num2str(celoc_fluor_sens));

setappdata(0,'celoc_fluor_sens',celoc_fluor_sens);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

%enable slider
set(h_celoc(1).fluor_slider,'Enable','on');

end

function push_fluor_ok(hObject,eventdata,h_celoc) % UNUSED

%disable figure during calculation
enableDisableFig(h_celoc(1).fluor_fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).sens_fig,1));

try

% load shared parameters

% 

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_fluor_cancel(hObject,eventdata,h_celoc) % UNUSED

try

close(h_celoc(1).fluor_fig);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_next_im(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_std = getappdata(0,'celoc_angle_std');

if celoc_image_counter < celoc_Nimages
    
    % advance counter
    celoc_image_counter = celoc_image_counter+1;
    
    % reset cell counter
    celoc_cell_counter = 1;
    
    % select new image
    set(h_celoc(1).listbox_images,'value',celoc_image_counter);
    
    % display new image
    axes(h_celoc(1).axes_prev);
    imshow(celoc_im_preview{celoc_image_counter});hold on;
    if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight first cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    % display new coordinates
    set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}),'value',celoc_cell_counter);
    
    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    if ~isempty(celoc_BW_mask{celoc_image_counter})
        BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
        BW_crop = bwselect(BW_crop,75,75,8);
        BW_outline = bwboundaries(BW_crop);
        % check for region
        if ~isempty(BW_outline)
            outlineX = BW_outline{1}(:,2);
            outlineY = BW_outline{1}(:,1);
        else
            outlineX = 0;
            outlineY = 0;
        end
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;
    % 

    else
    % clear pos list
    set(h_celoc(1).listbox_cellpos,'string',[],'value',celoc_cell_counter);
    % clear cell detail
    cla(h_celoc(1).axes_cell);
    end
    hold off;
        
else
end

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]);
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end
% 

% save
setappdata(0,'celoc_image_counter',celoc_image_counter);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_prev_im(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_std = getappdata(0,'celoc_angle_std');

if celoc_image_counter > 1
    
    % advance counter
    celoc_image_counter = celoc_image_counter-1;
    
    % reset cell counter
    celoc_cell_counter = 1;
    
    % select new image
    set(h_celoc(1).listbox_images,'value',celoc_image_counter);
    
    % display new image
    axes(h_celoc(1).axes_prev);
    imshow(celoc_im_preview{celoc_image_counter});hold on;
    if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight first cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    % display new coordinates
    set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}),'value',celoc_cell_counter);
    
    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    if ~isempty(celoc_BW_mask{celoc_image_counter})
        BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
        BW_crop = bwselect(BW_crop,75,75,8);
        BW_outline = bwboundaries(BW_crop);
        % check for region
        if ~isempty(BW_outline)
            outlineX = BW_outline{1}(:,2);
            outlineY = BW_outline{1}(:,1);
        else
            outlineX = 0;
            outlineY = 0;
        end
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;
    % 
    else
    % clear pos list
    set(h_celoc(1).listbox_cellpos,'string',[],'value',celoc_cell_counter);
    % clear cell detail
    cla(h_celoc(1).axes_cell);
    end
    hold off;
        
else
end

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]);
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end
% 

% save
setappdata(0,'celoc_image_counter',celoc_image_counter);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_del_im(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_filenamestack = getappdata(0,'celoc_filenamestack');
celoc_pathnamestack = getappdata(0,'celoc_pathnamestack');
celoc_imext = getappdata(0,'celoc_imext');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_angle_std = getappdata(0,'celoc_angle_std');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');

% check for images
if ~isempty(celoc_im_preview)
    % clear image data
    celoc_filenamestack(celoc_image_counter) = [];
    celoc_pathnamestack(celoc_image_counter) = [];
    celoc_imext(celoc_image_counter) = [];
    celoc_im_preview(celoc_image_counter) = [];
    celoc_BW_mask(celoc_image_counter) = [];
    celoc_im_pos_list(celoc_image_counter) = [];
    celoc_cell_pos_list(celoc_image_counter) = [];
    celoc_cell_disp_list(celoc_image_counter) = [];
    celoc_area_list(celoc_image_counter) = [];
    celoc_area_avg(celoc_image_counter) = [];
    celoc_area_std(celoc_image_counter) = [];
    celoc_aspect_list(celoc_image_counter) = [];
    celoc_aspect_avg(celoc_image_counter) = [];
    celoc_aspect_std(celoc_image_counter) = [];
    celoc_angle_list(celoc_image_counter) = [];
    celoc_angle_avg(celoc_image_counter) = [];
    celoc_angle_std(celoc_image_counter) = [];
    celoc_majaxis_list(celoc_image_counter) = [];
    celoc_minaxis_list(celoc_image_counter) = [];
else
end

% update counters
celoc_cell_tot = celoc_cell_tot - celoc_Ncells{celoc_image_counter};
celoc_Ncells(celoc_image_counter) = [];
celoc_cell_counter = 1;

% check and update image counter
if celoc_Nimages > 1
    if celoc_image_counter == celoc_Nimages
        celoc_image_counter = celoc_image_counter-1;
    else
    end
else
end

% update Nimages
celoc_Nimages = size(celoc_im_preview,2);

% update displays
% check for images
if ~isempty(celoc_im_preview)
    axes(h_celoc(1).axes_prev);
    imshow(celoc_im_preview{celoc_image_counter}); hold on;
    % check for cells
    if ~isempty(celoc_cell_pos_list{celoc_image_counter})
        plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
        % highlight first cell
        plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
        % display new coordinates
        set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}),'value',celoc_cell_counter);
        
        % calculate cell detail crop
        width = 150;
        height = 150;
        xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
        ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
        im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
        
        % get cell outline
        if ~isempty(celoc_BW_mask{celoc_image_counter})
            BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
            BW_crop = bwselect(BW_crop,75,75,8);
            BW_outline = bwboundaries(BW_crop);
            % check for region
            if ~isempty(BW_outline)
                outlineX = BW_outline{1}(:,2);
                outlineY = BW_outline{1}(:,1);
            else
                outlineX = 0;
                outlineY = 0;
            end
        else
            outlineX = 0;
            outlineY = 0;
        end
        
        % display cell detail image
        axes(h_celoc(1).axes_cell);
        imshow(im_crop); hold on;
        plot(outlineX,outlineY,'r');
        hold off;
        % 
    else
        % clear cell detail
        cla(h_celoc(1).axes_cell);
        % clear pos list
        set(h_celoc(1).listbox_cellpos,'string',[],'value',celoc_cell_counter);
    end
    hold off;
    
% update image list
set(h_celoc(1).listbox_images,'string',celoc_filenamestack,'value',celoc_image_counter);

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]);
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end
% 

else
    % clear image/cell lists
    set(h_celoc(1).listbox_images,'string',[]);
    set(h_celoc(1).listbox_cellpos,'string',[]);
    % clear axes
    cla(h_celoc(1).axes_prev);
    cla(h_celoc(1).axes_cell);
    % clear image stats
    set(h_celoc(1).text_im_count,'string','Image: ');
    % image coords
    set(h_celoc(1).text_cell_count,'string','Cells in image: ');
    set(h_celoc(1).text_avg_area,'string','Avg cell area: ');
    set(h_celoc(1).text_avg_aspect,'string','Avg aspect ratio: ');
    set(h_celoc(1).text_avg_angle,'string','Avg orientation: ');
    % 
end

% save new parameters
setappdata(0,'celoc_filenamestack',celoc_filenamestack);
setappdata(0,'celoc_pathnamestack',celoc_pathnamestack);
setappdata(0,'celoc_imext',celoc_imext);
setappdata(0,'celoc_Nimages',celoc_Nimages);
setappdata(0,'celoc_im_preview',celoc_im_preview);
setappdata(0,'celoc_BW_mask',celoc_BW_mask);
setappdata(0,'celoc_im_pos_list',celoc_im_pos_list);
setappdata(0,'celoc_image_counter',celoc_image_counter);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_angle_std',celoc_angle_std);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_clear_im(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_filenamestack = getappdata(0,'celoc_filenamestack');
celoc_pathnamestack = getappdata(0,'celoc_pathnamestack');
celoc_imext = getappdata(0,'celoc_imext');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_angle_std = getappdata(0,'celoc_angle_std');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');

% clear all data
celoc_filenamestack = [];
celoc_pathnamestack = [];
celoc_imext = [];
celoc_Nimages = [];
celoc_im_preview = [];
celoc_BW_mask = [];
celoc_im_pos_list = [];
celoc_image_counter = [];
celoc_cell_counter = [];
celoc_cell_pos_list = [];
celoc_cell_disp_list = [];
celoc_Ncells = [];
celoc_cell_tot = [];
celoc_area_list = [];
celoc_area_avg = [];
celoc_area_std = [];
celoc_aspect_list = [];
celoc_aspect_avg = [];
celoc_aspect_std = [];
celoc_angle_list = [];
celoc_angle_avg = [];
celoc_angle_std = [];
celoc_majaxis_list = [];
celoc_minaxis_list = [];

% clear displays
cla(h_celoc(1).axes_prev);
cla(h_celoc(1).axes_cell);
set(h_celoc(1).listbox_images,'string',[],'value',1);
set(h_celoc(1).listbox_cellpos,'string',[],'value',1);
set(h_celoc(1).text_im_count,'string','Image: ');
set(h_celoc(1).text_im_coord,'string','Stage Position: ');
set(h_celoc(1).text_cell_count,'string','Cells in image: ');
set(h_celoc(1).text_avg_area,'string','Avg cell area: ');
set(h_celoc(1).text_avg_aspect,'string','Avg aspect ratio: ');
set(h_celoc(1).text_avg_angle,'string','Avg orientation: ');
set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');

% save new parameters
setappdata(0,'celoc_filenamestack',celoc_filenamestack);
setappdata(0,'celoc_pathnamestack',celoc_pathnamestack);
setappdata(0,'celoc_imext',celoc_imext);
setappdata(0,'celoc_Nimages',celoc_Nimages);
setappdata(0,'celoc_im_preview',celoc_im_preview);
setappdata(0,'celoc_BW_mask',celoc_BW_mask);
setappdata(0,'celoc_im_pos_list',celoc_im_pos_list);
setappdata(0,'celoc_image_counter',celoc_image_counter);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_angle_std',celoc_angle_std);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_next_cell(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');

if celoc_cell_counter < celoc_Ncells{celoc_image_counter}
    
    % advance counter
    celoc_cell_counter = celoc_cell_counter+1;
        
    % update preview display
    axes(h_celoc(1).axes_prev);
    imshow(celoc_im_preview{celoc_image_counter});hold on;
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    
    % highlight new cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    hold off;
    
    % select new cell
    set(h_celoc(1).listbox_cellpos,'value',celoc_cell_counter);
    
    % update cell info
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    
    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    if ~isempty(celoc_BW_mask{celoc_image_counter})
        BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
        BW_crop = bwselect(BW_crop,75,75,8);
        BW_outline = bwboundaries(BW_crop);
        % check for region
        if ~isempty(BW_outline)
            outlineX = BW_outline{1}(:,2);
            outlineY = BW_outline{1}(:,1);
        else
            outlineX = 0;
            outlineY = 0;
        end
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;
    % 
    
else
end

% save stuff
setappdata(0,'celoc_cell_counter',celoc_cell_counter);

catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_prev_cell(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');

if celoc_cell_counter > 1
    
    % advance counter
    celoc_cell_counter = celoc_cell_counter-1;
        
    % update preview display
    axes(h_celoc(1).axes_prev);
    imshow(celoc_im_preview{celoc_image_counter});hold on;
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight new cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    hold off;
    
    % select new cell
    set(h_celoc(1).listbox_cellpos,'value',celoc_cell_counter);
    
    % update cell info
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    
    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    if ~isempty(celoc_BW_mask{celoc_image_counter})
        BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
        BW_crop = bwselect(BW_crop,75,75,8);
        BW_outline = bwboundaries(BW_crop);
        % check for region
        if ~isempty(BW_outline)
            outlineX = BW_outline{1}(:,2);
            outlineY = BW_outline{1}(:,1);
        else
            outlineX = 0;
            outlineY = 0;
        end
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;
    % 
    
else
end

% save stuff
setappdata(0,'celoc_cell_counter',celoc_cell_counter);

catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_del_cells(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_std = getappdata(0,'celoc_angle_std');

% remove old cell count from total
celoc_cell_tot = celoc_cell_tot-celoc_Ncells{celoc_image_counter};

% open figure
hf = figure;

% display image and points
imshow(celoc_im_preview{celoc_image_counter}),title('select positions to delete then press enter'); hold on;
plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
hold off;

% get points to delete
[del_x,del_y] = getpts(hf);
close(hf);

% check if too many points were chosen
if size(del_x,1) >= celoc_Ncells{celoc_image_counter}
    % clear cell positions
    celoc_cell_pos_list{celoc_image_counter} = [];
    celoc_cell_disp_list{celoc_image_counter} = [];
    celoc_area_list{celoc_image_counter} = [];
    celoc_aspect_list{celoc_image_counter} = [];
    celoc_angle_list{celoc_image_counter} = [];
    celoc_majaxis_list{celoc_image_counter} = [];
    celoc_minaxis_list{celoc_image_counter} = [];
    celoc_Ncells{celoc_image_counter} = 0;
else

% loop over each point and find closest match
for i = 1:size(del_x,1)
    
    % calculate distance
    d = ones(celoc_Ncells{celoc_image_counter},1);
    for j = 1:celoc_Ncells{celoc_image_counter}
        % calculate dx, dy
        dx = del_x(i)-celoc_cell_disp_list{celoc_image_counter}(j,1);
        dy = del_y(i)-celoc_cell_disp_list{celoc_image_counter}(j,2);
        % calculate distance
        d(j) = sqrt(dx^2+dy^2);
    end
    
    % find index of min(d)
    [~,index] = min(d);
    
    % remove match from lists
    celoc_cell_pos_list{celoc_image_counter}(index,:) = [];
    celoc_cell_disp_list{celoc_image_counter}(index,:) = [];
    celoc_area_list{celoc_image_counter}(index) = [];
    celoc_aspect_list{celoc_image_counter}(index) = [];
    celoc_angle_list{celoc_image_counter}(index) = [];
    celoc_majaxis_list{celoc_image_counter}(index) = [];
    celoc_minaxis_list{celoc_image_counter}(index) = [];
    
    % update Ncells
    celoc_Ncells{celoc_image_counter} = size(celoc_cell_pos_list{celoc_image_counter}(:,1),1);
end

end

% update cell counter
celoc_cell_counter = 1;

% update cell total
celoc_cell_tot = celoc_cell_tot+celoc_Ncells{celoc_image_counter};

% update preview display
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});hold on;
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight first cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    
    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    if ~isempty(celoc_BW_mask{celoc_image_counter})
        BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
        BW_crop = bwselect(BW_crop,75,75,8);
        BW_outline = bwboundaries(BW_crop);
        % check for region
        if ~isempty(BW_outline)
            outlineX = BW_outline{1}(:,2);
            outlineY = BW_outline{1}(:,1);
        else
            outlineX = 0;
            outlineY = 0;
        end
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;
    % 
else
    % clear cell detail
    cla(h_celoc(1).axes_cell);
end
hold off;

% update cell list
set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}),'value',celoc_cell_counter);

% recalculate cell stats
celoc_area_avg{celoc_image_counter} = round(nanmean(celoc_area_list{celoc_image_counter}),3,'significant');
celoc_area_std{celoc_image_counter} = round(nanstd(celoc_area_list{celoc_image_counter}),2,'significant');
celoc_aspect_avg{celoc_image_counter} = round(nanmean(celoc_aspect_list{celoc_image_counter}),2,'significant');
celoc_aspect_std{celoc_image_counter} = round(nanstd(celoc_aspect_list{celoc_image_counter}),2,'significant');
celoc_angle_avg{celoc_image_counter} = round(nanmean(celoc_angle_list{celoc_image_counter}),2,'significant');
celoc_angle_std{celoc_image_counter} = round(nanstd(celoc_angle_list{celoc_image_counter}),2,'significant');

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]);
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end
% 

% save stuff
setappdata(0,'celoc_cell_counter',celoc_cell_counter);
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_std',celoc_angle_std);

catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_add_cells(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_std = getappdata(0,'celoc_angle_std');
celoc_conv = getappdata(0,'celoc_conv');

% remove old cell count from total
celoc_cell_tot = celoc_cell_tot-celoc_Ncells{celoc_image_counter};

if isempty(celoc_cell_counter)
    celoc_cell_counter = 1;
    celoc_Ncells{celoc_image_counter,1} = 0;
else
end

% open figure
hf = figure;

% display image + locations
imshow(celoc_im_preview{celoc_image_counter}), title('select new positions then press enter');hold on;
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
else
end

% select new locations
[new_x,new_y] = getpts(hf);
close(hf);

N_new = size(new_x,1);
% add selections to pos list
for i = 1:N_new
    celoc_cell_disp_list{celoc_image_counter}(celoc_Ncells{celoc_image_counter}+i,1) = new_x(i);
    celoc_cell_disp_list{celoc_image_counter}(celoc_Ncells{celoc_image_counter}+i,2) = new_y(i);
    celoc_area_list{celoc_image_counter}(celoc_Ncells{celoc_image_counter}+i,1) = NaN;
    celoc_aspect_list{celoc_image_counter}(celoc_Ncells{celoc_image_counter}+i,1) = NaN;
    celoc_angle_list{celoc_image_counter}(celoc_Ncells{celoc_image_counter}+i,1) = NaN;
    celoc_majaxis_list{celoc_image_counter}(celoc_Ncells{celoc_image_counter}+i,1) = NaN;
    celoc_minaxis_list{celoc_image_counter}(celoc_Ncells{celoc_image_counter}+i,1) = NaN;
end

% ADD STAGE POSITIONS TO CELL_POS_LIST
% get image
I = celoc_im_preview{celoc_image_counter};
% get image size
im_sizeX = size(I,2);
im_sizeY = size(I,1);
% create transformation vector
transX = (im_sizeX/2);
transY = (im_sizeY/2);
trans = [transX transY];
% check for cells
if ~isempty(celoc_cell_disp_list{celoc_image_counter})
    % transform disp list
    celoc_cell_pos_list{celoc_image_counter} = -celoc_cell_disp_list{celoc_image_counter}+trans;
    % convert to um
    celoc_cell_pos_list{celoc_image_counter} = celoc_cell_pos_list{celoc_image_counter}.*celoc_conv;
    % transform to stage coordinates
     type = getappdata(0, 'celoc_im_type');
    if strcmp(type, '.czi') == 1
        % Because of system dependent stage direction, the last term may
        % ned to be added or subtracted as needed.
        celoc_cell_pos_list{celoc_image_counter} = [celoc_im_pos_list{celoc_image_counter}(1) celoc_im_pos_list{celoc_image_counter}(2)] - celoc_cell_pos_list{celoc_image_counter};
    elseif strcmp(type, '.tif') == 1
        celoc_cell_pos_list{celoc_image_counter} = [celoc_im_pos_list{celoc_image_counter}(1) celoc_im_pos_list{celoc_image_counter}(2)] + celoc_cell_pos_list{celoc_image_counter};
    end
else
end

% update Ncells
celoc_Ncells{celoc_image_counter} = size(celoc_cell_pos_list{celoc_image_counter}(:,1),1);
% update cell total
celoc_cell_tot = celoc_cell_tot+celoc_Ncells{celoc_image_counter};

% update preview display
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});hold on;
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight first cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    
    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    if ~isempty(celoc_BW_mask{celoc_image_counter})
        BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
        BW_crop = bwselect(BW_crop,75,75,8);
        BW_outline = bwboundaries(BW_crop);
        % check for region
        if ~isempty(BW_outline)
            outlineX = BW_outline{1}(:,2);
            outlineY = BW_outline{1}(:,1);
        else
            outlineX = 0;
            outlineY = 0;
        end
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;
    % 
else
end
hold off;

% update cell list
set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}));

% recalculate cell stats
celoc_area_avg{celoc_image_counter} = round(nanmean(celoc_area_list{celoc_image_counter}),3,'significant');
celoc_area_std{celoc_image_counter} = round(nanstd(celoc_area_list{celoc_image_counter}),2,'significant');
celoc_aspect_avg{celoc_image_counter} = round(nanmean(celoc_aspect_list{celoc_image_counter}),2,'significant');
celoc_aspect_std{celoc_image_counter} = round(nanstd(celoc_aspect_list{celoc_image_counter}),2,'significant');
celoc_angle_avg{celoc_image_counter} = round(nanmean(celoc_angle_list{celoc_image_counter}),2,'significant');
celoc_angle_std{celoc_image_counter} = round(nanstd(celoc_angle_list{celoc_image_counter}),2,'significant');

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]);
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end
% 

% save stuff
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_std',celoc_angle_std);

catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_rem_cell(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_std = getappdata(0,'celoc_angle_std');

% check for positions
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    % clear selected cell position
    celoc_cell_pos_list{celoc_image_counter}(celoc_cell_counter,:) = [];
    celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,:) = [];
    celoc_area_list{celoc_image_counter}(celoc_cell_counter) = [];
    celoc_aspect_list{celoc_image_counter}(celoc_cell_counter) = [];
    celoc_angle_list{celoc_image_counter}(celoc_cell_counter) = [];
    celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter) = [];
    celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter) = [];
else
end

% check cell count
if celoc_Ncells{celoc_image_counter} > 1
    if celoc_cell_counter == celoc_Ncells{celoc_image_counter}
        celoc_cell_counter = celoc_cell_counter-1;
    else
    end
else
end

% update cell counts
if celoc_Ncells{celoc_image_counter} >= 1
    celoc_Ncells{celoc_image_counter} = celoc_Ncells{celoc_image_counter}-1;
    celoc_cell_tot = celoc_cell_tot-1;
else
end

% update preview display
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});hold on;
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight first cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    
    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
    BW_crop = bwselect(BW_crop,75,75,8);
    BW_outline = bwboundaries(BW_crop);
    % check for region
    if ~isempty(BW_outline)
        outlineX = BW_outline{1}(:,2);
        outlineY = BW_outline{1}(:,1);
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;
    % 
else
    % clear cell detail
    cla(h_celoc(1).axes_cell);
end
hold off;

% update cell list
set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}),'value',celoc_cell_counter);

% recalculate cell stats
celoc_area_avg{celoc_image_counter} = round(nanmean(celoc_area_list{celoc_image_counter}),3,'significant');
celoc_area_std{celoc_image_counter} = round(nanstd(celoc_area_list{celoc_image_counter}),2,'significant');
celoc_aspect_avg{celoc_image_counter} = round(nanmean(celoc_aspect_list{celoc_image_counter}),2,'significant');
celoc_aspect_std{celoc_image_counter} = round(nanstd(celoc_aspect_list{celoc_image_counter}),2,'significant');
celoc_angle_avg{celoc_image_counter} = round(nanmean(celoc_angle_list{celoc_image_counter}),2,'significant');
celoc_angle_std{celoc_image_counter} = round(nanstd(celoc_angle_list{celoc_image_counter}),2,'significant');

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]);
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end
% 

% save new parameters
setappdata(0,'celoc_cell_counter',celoc_cell_counter);
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_std',celoc_angle_std);

catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_clear_cells(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_std = getappdata(0,'celoc_angle_std');
 
% clear all cell data
celoc_cell_pos_list{celoc_image_counter} = [];
celoc_cell_disp_list{celoc_image_counter} = [];
celoc_cell_counter = 1;
celoc_cell_tot = celoc_cell_tot-celoc_Ncells{celoc_image_counter};
celoc_Ncells{celoc_image_counter} = 0;
celoc_area_list{celoc_image_counter} = [];
celoc_aspect_list{celoc_image_counter} = [];
celoc_angle_list{celoc_image_counter} = [];
celoc_majaxis_list{celoc_image_counter} = [];
celoc_minaxis_list{celoc_image_counter} = [];

% update preview display
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});

% clear cell detail
cla(h_celoc(1).axes_cell);

% display new coordinates
set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}));

% recalculate cell stats
celoc_area_avg{celoc_image_counter} = round(nanmean(celoc_area_list{celoc_image_counter}),3,'significant');
celoc_area_std{celoc_image_counter} = round(nanstd(celoc_area_list{celoc_image_counter}),2,'significant');
celoc_aspect_avg{celoc_image_counter} = round(nanmean(celoc_aspect_list{celoc_image_counter}),2,'significant');
celoc_aspect_std{celoc_image_counter} = round(nanstd(celoc_aspect_list{celoc_image_counter}),2,'significant');
celoc_angle_avg{celoc_image_counter} = round(nanmean(celoc_angle_list{celoc_image_counter}),2,'significant');
celoc_angle_std{celoc_image_counter} = round(nanstd(celoc_angle_list{celoc_image_counter}),2,'significant');

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]);
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end
% 

% save new parameters
setappdata(0,'celoc_cell_pos_list',celoc_cell_pos_list);
setappdata(0,'celoc_cell_disp_list',celoc_cell_disp_list);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);
setappdata(0,'celoc_cell_tot',celoc_cell_tot);
setappdata(0,'celoc_Ncells',celoc_Ncells);
setappdata(0,'celoc_area_list',celoc_area_list);
setappdata(0,'celoc_aspect_list',celoc_aspect_list);
setappdata(0,'celoc_angle_list',celoc_angle_list);
setappdata(0,'celoc_majaxis_list',celoc_majaxis_list);
setappdata(0,'celoc_minaxis_list',celoc_minaxis_list);
setappdata(0,'celoc_area_avg',celoc_area_avg);
setappdata(0,'celoc_aspect_avg',celoc_aspect_avg);
setappdata(0,'celoc_angle_avg',celoc_angle_avg);
setappdata(0,'celoc_area_std',celoc_area_std);
setappdata(0,'celoc_aspect_std',celoc_aspect_std);
setappdata(0,'celoc_angle_std',celoc_angle_std);

catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function select_image(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');
celoc_area_avg = getappdata(0,'celoc_area_avg');
celoc_aspect_avg = getappdata(0,'celoc_aspect_avg');
celoc_angle_avg = getappdata(0,'celoc_angle_avg');
celoc_area_std = getappdata(0,'celoc_area_std');
celoc_aspect_std = getappdata(0,'celoc_aspect_std');
celoc_angle_std = getappdata(0,'celoc_angle_std');

% check for images
if ~isempty(celoc_im_preview)

% get image index
celoc_image_counter = get(hObject,'Value');

% reset cell counter
celoc_cell_counter = 1;

% display new image
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});hold on;
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
    % highlight first cell
    plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
    % display new coordinates
    set(h_celoc(1).listbox_cellpos,'string',num2str(celoc_cell_pos_list{celoc_image_counter}),'value',celoc_cell_counter);
    
    % calculate cell detail crop
    width = 150;
    height = 150;
    xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
    ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
    im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);
    
    % get cell outline
    BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
    BW_crop = bwselect(BW_crop,75,75,8);
    BW_outline = bwboundaries(BW_crop);
    % check for region
    if ~isempty(BW_outline)
        outlineX = BW_outline{1}(:,2);
        outlineY = BW_outline{1}(:,1);
    else
        outlineX = 0;
        outlineY = 0;
    end
    
    % display cell detail image
    axes(h_celoc(1).axes_cell);
    imshow(im_crop); hold on;
    plot(outlineX,outlineY,'r');
    hold off;
    % 
else
    % clear pos list
    set(h_celoc(1).listbox_cellpos,'string',[],'value',celoc_cell_counter);
    % clear cell detail
    cla(h_celoc(1).axes_cell);
end
hold off;

% update image info
set(h_celoc(1).text_im_count,'string',['Image: ',num2str(celoc_image_counter),'/',num2str(celoc_Nimages)]);
set(h_celoc(1).text_im_coord,'string',['Stage Position: ',num2str(round(celoc_im_pos_list{celoc_image_counter},4,'significant'))]);
set(h_celoc(1).text_cell_count,'string',['Cells in image: ',num2str(celoc_Ncells{celoc_image_counter}),'/',num2str(celoc_cell_tot)]);
set(h_celoc(1).text_avg_area,'string',['Avg cell area: ',num2str(celoc_area_avg{celoc_image_counter}),' +- ',num2str(celoc_area_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_aspect,'string',['Avg aspect ratio: ',num2str(celoc_aspect_avg{celoc_image_counter}),' +- ',num2str(celoc_aspect_std{celoc_image_counter})]);
set(h_celoc(1).text_avg_angle,'string',['Avg orientation: ',num2str(celoc_angle_avg{celoc_image_counter}),' +- ',num2str(celoc_angle_std{celoc_image_counter})]);

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end
% 

setappdata(0,'celoc_image_counter',celoc_image_counter);
setappdata(0,'celoc_cell_counter',celoc_cell_counter);

else
end

catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function select_cell(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_image_counter = getappdata(0,'celoc_image_counter');
celoc_cell_counter = getappdata(0,'celoc_cell_counter');
celoc_im_preview = getappdata(0,'celoc_im_preview');
celoc_BW_mask = getappdata(0,'celoc_BW_mask');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_cell_disp_list = getappdata(0,'celoc_cell_disp_list');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');
celoc_angle_list = getappdata(0,'celoc_angle_list');

% check for cells
if ~isempty(celoc_cell_pos_list{celoc_image_counter})

% get cell index
celoc_cell_counter = get(hObject,'Value');

% update preview display
axes(h_celoc(1).axes_prev);
imshow(celoc_im_preview{celoc_image_counter});hold on;
plot(celoc_cell_disp_list{celoc_image_counter}(:,1),celoc_cell_disp_list{celoc_image_counter}(:,2), 'r*');
% highlight new cell
plot(celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1),celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2),'go','MarkerSize',20);
hold off;

% calculate cell detail crop
width = 150;
height = 150;
xmin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,1)-75;
ymin = celoc_cell_disp_list{celoc_image_counter}(celoc_cell_counter,2)-75;
im_crop = imcrop(celoc_im_preview{celoc_image_counter},[xmin ymin width height]);

% get cell outline
if ~isempty(celoc_BW_mask{celoc_image_counter})
    BW_crop = imcrop(celoc_BW_mask{celoc_image_counter},[xmin ymin width height]);
    BW_crop = bwselect(BW_crop,75,75,8);
    BW_outline = bwboundaries(BW_crop);
    % check for region
    if ~isempty(BW_outline)
        outlineX = BW_outline{1}(:,2);
        outlineY = BW_outline{1}(:,1);
    else
        outlineX = 0;
        outlineY = 0;
    end
else
    outlineX = 0;
    outlineY = 0;
end

% display cell detail image
axes(h_celoc(1).axes_cell);
imshow(im_crop); hold on;
plot(outlineX,outlineY,'r');
hold off;
% 

% update cell info
if ~isempty(celoc_cell_pos_list{celoc_image_counter})
    set(h_celoc(1).text_cell_dim,'string',['Cell dimensions (um): ', num2str(round(celoc_majaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant')), ' x ', num2str(round(celoc_minaxis_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_area,'string',['Cell area (um^2): ', num2str(round(celoc_area_list{celoc_image_counter}(celoc_cell_counter),4,'significant'))]);
    set(h_celoc(1).text_cell_aspect,'string',['Cell aspect ratio: ', num2str(round(celoc_aspect_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
    set(h_celoc(1).text_cell_angle,'string',['Cell orientation: ', num2str(round(celoc_angle_list{celoc_image_counter}(celoc_cell_counter),3,'significant'))]);
else
    set(h_celoc(1).text_cell_dim,'string','Cell dimensions (um): ');
    set(h_celoc(1).text_cell_area,'string','Cell area (um^2): ');
    set(h_celoc(1).text_cell_aspect,'string','Cell aspect ratio: ');
    set(h_celoc(1).text_cell_angle,'string','Cell orientation: ');
end
% 

% save stuff
setappdata(0,'celoc_cell_counter',celoc_cell_counter);

% close if
else
end

catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_save_data(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_pos_list_pathname = getappdata(0,'celoc_pos_list_pathname');
celoc_conv = getappdata(0,'celoc_conv');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
celoc_area_min = getappdata(0,'celoc_area_min');
celoc_area_max = getappdata(0,'celoc_area_max');
celoc_aspect_min = getappdata(0,'celoc_aspect_min');
celoc_aspect_max = getappdata(0,'celoc_aspect_max');
celoc_angle_min = getappdata(0,'celoc_angle_min');
celoc_angle_max = getappdata(0,'celoc_angle_max');
celoc_majaxis_list = getappdata(0,'celoc_majaxis_list');
celoc_minaxis_list = getappdata(0,'celoc_minaxis_list');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_aspect_list = getappdata(0,'celoc_aspect_list');

% specify save path for excel file
[filename,pathname] = uiputfile([celoc_pos_list_pathname,'*.xlsx']);
cell_data_filepath = [pathname,filename];

% create excel file
copyfile('Template_DO_NOT_EDIT.xlsx',cell_data_filepath);

% write imaging data
im_data = {celoc_conv};
xlwrite(cell_data_filepath,im_data,'General','B2');

% write search criteria
search_data = {celoc_area_min,celoc_area_max,[];...
    celoc_aspect_min,celoc_aspect_max,[];...
    celoc_angle_min,celoc_angle_max,[];...
    celoc_cell_tot,[],[]};
xlwrite(cell_data_filepath,search_data,'General','B6');

% remove empty cells from lists
for i = 1:celoc_Nimages
    if isempty(celoc_cell_pos_list{i})
        celoc_majaxis_list{i} = [];
        celoc_minaxis_list{i} = [];
        celoc_area_list{i} = [];
        celoc_aspect_list{i} = [];
    end
end

% concatenate cell data
cell_lengths = cat(1,celoc_majaxis_list{:});
cell_widths = cat(1,celoc_minaxis_list{:});
cell_areas = cat(1,celoc_area_list{:});
cell_aspects = cat(1,celoc_aspect_list{:});
cell_coords = cat(1,celoc_cell_pos_list{:});

% write cell data lists to excel
xlwrite(cell_data_filepath,cell_lengths,'Cell Data','B2');
xlwrite(cell_data_filepath,cell_widths,'Cell Data','C2');
xlwrite(cell_data_filepath,cell_areas,'Cell Data','D2');
xlwrite(cell_data_filepath,cell_aspects,'Cell Data','E2');
xlwrite(cell_data_filepath,cell_coords,'Cell Data','F2');

catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_save_cellpos(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% load shared parameters
celoc_pos_list_pathname = getappdata(0,'celoc_pos_list_pathname');
celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');

% specify save path for pos list
filter = {'*.czstm';'*.pos';'*.csv'};
[filename,pathname] = uiputfile(filter);
cell_pos_filepath = [pathname,filename];

% get file type and decide format
[path,name, ext] = fileparts(cell_pos_filepath);

if strcmp(ext,'.pos') == 1
    % initialize pos list
    MM_cell_pos_list = javaObject('org.micromanager.api.PositionList');

    % initialize cell counter
    prev_cell_count = 0;

    % loop over images
    for i = 1:celoc_Nimages

        % loop over cells in image
        for j = 1:celoc_Ncells{i}

            % create XY stagePosition
            stage_pos_XY = javaObject('org.micromanager.api.StagePosition');
            % set stage info
            stage_pos_XY.numAxes = 2;
            stage_pos_XY.stageName = 'XYStage';
            % set XY positions
            stage_pos_XY.x = celoc_cell_pos_list{i}(j,1);
            stage_pos_XY.y = celoc_cell_pos_list{i}(j,2);

            % create focus StagePosition?

            % create MultiStagePosition
            multi_stage_pos = javaObject('org.micromanager.api.MultiStagePosition');
            % set label
            multi_stage_pos.setLabel(['Cell',num2str(prev_cell_count+j)]);
            % add stage positions
            multi_stage_pos.add(stage_pos_XY);
            % add focus stage?

            % add MSP to PositionList
            MM_cell_pos_list.addPosition(multi_stage_pos);

        end

        % add previous cells to count
        prev_cell_count = prev_cell_count+celoc_Ncells{i};

    end

    % save pos list
    MM_cell_pos_list.save(cell_pos_filepath);

elseif strcmp(ext,'.czstm') == 1
    % initialize pos list
    output_name = sprintf('%s%s',[path '\' name], ext);
    MM_cell_pos_list = fopen(output_name, 'wt');
    fprintf(MM_cell_pos_list, '<?xml version="1.0" encoding="utf-8"?>\n<StageMarks>\n', 'char');
    % initialize cell counter
    prev_cell_count = 1;
    
    %+++++++
    %Fit a 2D polinomial to the tiles
    im_pos = cell2mat(celoc_im_pos_list');
%     if celoc_Nimages >10
%         model = 'poly33';
    if celoc_Nimages >5
        model = 'poly22';
    elseif celoc_Nimages >2
        model = 'poly11';
    else
        model = 'poly00';
    end
    fitsurface=fit(im_pos(:,1:2),im_pos(:,3), model,'Robust','Bisquare');
    cell_pos = cell2mat(celoc_cell_pos_list');
    cell_pos(:,3) = fitsurface(cell_pos(:,1),cell_pos(:,2));

%     %Interpolate the cell z-position from a linear interpolation of the
%     %support point z-position
%    av_gel_z = mean(im_pos(:,3));
%     %pad the array CHANGE TO IMAGE SIZE/2
%     max_tile_x = max(im_pos(:,1))+2000;
%     min_tile_x = min(im_pos(:,1))-2000;
%     max_tile_y = max(im_pos(:,2))+2000;
%     min_tile_y = min(im_pos(:,2))-2000;
%     im_pos = [im_pos;[min_tile_x, min_tile_y av_gel_z];[max_tile_x min_tile_y av_gel_z];[min_tile_x max_tile_y av_gel_z];[max_tile_x max_tile_y av_gel_z]];
%     %Define interpolation grid
%     x=linspace(min_tile_x,max_tile_x,50);
%     y=linspace(min_tile_y,max_tile_y,50);
%     [X, Y] = meshgrid(x,y);
%     %Interpolate the tile z-position on the grid
%     itrp_surf = griddata(im_pos(:,1),im_pos(:,2),im_pos(:,3),X,Y,'cubic');
%     %Interpolate the cell z-position on the interpolated hydrogel surface
%     cell_pos = cell2mat(celoc_cell_pos_list');
%     cell_pos(:,3) = griddata(X,Y,itrp_surf,cell_pos(:,1),cell_pos(:,2),'cubic')
    %Comment if not usefull to see
    figure(11)
    plot3(im_pos(:,1),im_pos(:,2),im_pos(:,3),'ro')
    hold on
    plot(fitsurface)
    hold on
    plot3(cell_pos(:,1),cell_pos(:,2),cell_pos(:,3),'go')

    % write to output file
    for i = 1:size(cell_pos,1)
        fprintf(MM_cell_pos_list, strcat('\t<StageMark ItemIndex="',int2str(i),'" X="',num2str(cell_pos(i,1)),'" Y="',num2str(cell_pos(i,2)),'" Z="', num2str(cell_pos(i,3)),'" />\n'), 'char');
    end
    %-----------------------------
%%OLD BEFORE THE ABOVE INTERPOLATION:
%     loop over images
%     for i = 1:celoc_Nimages
%         %OLD BEFORE THE ABOVE INTERPOLATION: zPos = celoc_im_pos_list{i}(3);
%         % loop over cells in image
%         for j = 1:celoc_Ncells{i}
%            
%             % get XY positions
%             xPos = celoc_cell_pos_list{i}(j,1);
%             yPos = celoc_cell_pos_list{i}(j,2);
%             
%             % write to output file
%             fprintf(MM_cell_pos_list, strcat('\t<StageMark ItemIndex="',int2str(prev_cell_count),'" X="',num2str(xPos),'" Y="',num2str(yPos),'" Z="', num2str(OLDzPos),'" />\n'), 'char');
%             
%             prev_cell_count = prev_cell_count + 1;
%         end
%     end
    fprintf(MM_cell_pos_list, '</StageMarks>', 'char');
    MM_cell_pos_list = fclose(MM_cell_pos_list);

elseif strcmp(ext, '.csv') == 1
    % find total number of cells
    cell_count = 0
    for i = 1:celoc_Nimages
        cell_count = cell_count + celoc_Ncells{i}
    end
    
    % initialize pos list
    output_name = sprintf('%s%s',[path '\' name], ext);
    MM_cell_pos_list = fopen(output_name, 'wt');
    cell_pos_array = cell(cell_count + 1, 4);
    cell_pos_array{1,1} = 'Cell';
    cell_pos_array{1,2} = 'X Pos';
    cell_pos_array{1,3} = 'Y Pos';
    cell_pos_array{1,4} = 'Z Pos';
    prev_cell_count = 1;
    for i = 1:celoc_Nimages
        OLDzPos = celoc_im_pos_list{i}(3);
        for j = 1:celoc_Ncells{i}
            % get XY positions
            xPos = celoc_cell_pos_list{i}(j,1);
            yPos = celoc_cell_pos_list{i}(j,2);
            cell_pos_array{prev_cell_count + 1,1} = prev_cell_count;
            cell_pos_array{prev_cell_count + 1,2} = xPos;
            cell_pos_array{prev_cell_count + 1,3} = yPos;
            cell_pos_array{prev_cell_count + 1,4} = OLDzPos;
            prev_cell_count = prev_cell_count + 1;
        end
    end
    % write to output file
    fprintf(MM_cell_pos_list, '%s,%s,%s,%s\n', cell_pos_array{1,1}, cell_pos_array{1,2}, cell_pos_array{1,3}, cell_pos_array{1,4});
    temp = cell_pos_array(2:end, :).';      %transpose is important
    fprintf(MM_cell_pos_list, '%f,%f,%f,%f\n', temp{:});
    MM_cell_pos_list = fclose(MM_cell_pos_list);
end

%update statusbar
sb=statusbar(h_celoc(1).fig,'Position list successfully saved !');
sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));

% save stuff
setappdata(0,'MM_cell_pos_list',MM_cell_pos_list);

catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

function push_export(hObject,eventdata,h_celoc)

%disable figure during calculation
enableDisableFig(h_celoc(1).fig,0);
%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_celoc(1).fig,1));

try

% open dialog window
answer = questdlg('Exporting the pos list will overwrite the current pos list in Micro Manager. Are you sure you want to continue?','Export Cell Coordinates','Yes','No','No');

% read answer and execute code
switch answer
    case 'Yes'
        % load shared parameters
        celoc_Nimages = getappdata(0,'celoc_Nimages');
        celoc_Ncells = getappdata(0,'celoc_Ncells');
        celoc_im_pos_list = getappdata(0,'celoc_im_pos_list');
        celoc_cell_pos_list = getappdata(0,'celoc_cell_pos_list');
        gui = getappdata(0,'gui');
        
        % initialize pos list
        MM_cell_pos_list = javaObject('org.micromanager.api.PositionList');
        
        % initialize cell counter
        prev_cell_count = 0;

        % loop over images
        for i = 1:celoc_Nimages
            
            % create focus StagePosition
            stage_pos_Z = javaObject('org.micromanager.api.StagePosition');
            % set stage info
            stage_pos_Z.numAxes = 1;
            stage_pos_Z.stageName = 'FocusDrive';
            % set Z position
            stage_pos_Z.x = celoc_im_pos_list{i}(3);
        
            % loop over cells in image
            for j = 1:celoc_Ncells{i}
        
                % create XY stagePosition
                stage_pos_XY = javaObject('org.micromanager.api.StagePosition');
                % set stage info
                stage_pos_XY.numAxes = 2;
                stage_pos_XY.stageName = 'XYStage';
                % set XY positions
                stage_pos_XY.x = celoc_cell_pos_list{i}(j,1);
                stage_pos_XY.y = celoc_cell_pos_list{i}(j,2);
                
                % create MultiStagePosition
                multi_stage_pos = javaObject('org.micromanager.api.MultiStagePosition');
                % set label
                multi_stage_pos.setLabel(['Cell',num2str(prev_cell_count+j)]);
                % add XY stage position
                multi_stage_pos.add(stage_pos_XY);
                % add focus stage position
                multi_stage_pos.add(stage_pos_Z);
        
                % add MSP to PositionList
                MM_cell_pos_list.addPosition(multi_stage_pos);
        
            end
    
            % add previous cells to count
            prev_cell_count = prev_cell_count+celoc_Ncells{i};
    
        end
        
        % save pos list
        % MM_cell_pos_list.save('insert file path here')
        
        % load into MM gui
        gui.setPositionList(MM_cell_pos_list);
        
        %update statusbar
        sb=statusbar(h_celoc(1).fig,'Position list successfully exported !');
        sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));

        % save stuff
        setappdata(0,'MM_cell_pos_list',MM_cell_pos_list);
        
    case 'No'
end


catch errorObj
    % If there is a problem display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
end

end

% 
