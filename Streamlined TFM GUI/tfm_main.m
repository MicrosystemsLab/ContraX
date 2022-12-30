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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tfm_main.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Instructions:
% To analyse TFM video, execute tfm_main.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% entry point for the ContraX analysis
function tfm_main
% Creates a gui window with four buttons representing the major steps of
%  the ContraX workflow

% the code is intended to be run from the Matlab command window,
%  so initialize the environment when we start
if ~isdeployed
    clc
    clear all; %#ok<CLALL>
    close all;
end
% clear out the appdata
% NOTE we will fix this properly later (use the gui's appdata)
oldappdata = get(0,'ApplicationData');
fns = fieldnames(oldappdata);
for ii = 1:numel(fns)
  rmappdata(0,fns{ii});
end

 % set to positive integer to enable parallel processing with that many workers, or 0 to disable
use_parallel=24; % note you will only get as many workers as you have CPU cores available

% disable warning for obsolete java components
%  See: https://www.mathworks.com/products/matlab/app-designer/java-swing-alternatives.html?s_tid=OIT_20611
% This appears to be caused by the use of non-authorized matlab code for
%  the statusbar update and window state. These can be replaced. -MH 
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
% easier to suppress this warning than to fix the problem MH
warning('off','MATLAB:MKDIR:DirectoryExists');

% are template files available?
% Note: If deployed application, these files are in a cache directory
%  If at command line, these files must be in directory with code files:
%   Master_DO_NOT_EDIT.xlsx, Sample_DO_NOT_EDIT.xlsx
path_to_templates = fileparts(which('Master_DO_NOT_EDIT.xlsx'));
if isempty(path_to_templates)
    fprintf(1,'WARNING: Output xlsx template files not found\n');
end


% what build?
if isdeployed
    fid=fopen('buildversion.txt','r');
    buildver=fgetl(fid);
    fclose(fid);
else
    matver = ver('MATLAB');
    buildver=sprintf('[command line]/%s/%s',computer('arch'),matver.Release(2:end-1));
end

fprintf(1,'\nContraX Streamlined TFM: Microscope Image TFM Analysis\n');
fprintf(1,'   %s\n\n',buildver);
fprintf(1,'  Start Time: %s \n\n',datestr(now));

% check this machine
%  https://docs.oracle.com/javase/7/docs/api/java/lang/Runtime.html
fprintf(1,'System Architecture: %s, Number of CPU cores: %d\n',computer('arch'),feature('numCores'));
fprintf(1,'Java Runtime Max. Memory: %d MB\n',java.lang.Runtime.getRuntime.maxMemory/(1024*1024))

fprintf(1,'\n');
fprintf(1,'CXS-TFM: main function\n');


%% MH set a location in the filesystem for a working directory
%  The code stores partial results in a folder called vars_DO_NOT_DELETE
progName = 'ContraX';
if isdeployed
    if isunix % MacOS or Linux [NB: ~ expansion not reliable]
        homeDir = char(java.lang.System.getProperty('user.home'));
        if  isfolder(fullfile(homeDir,'Documents'))
            defaultstartdir = fullfile(homeDir,'Documents',progName);
        else
            defaultstartdir = fullfile(homeDir,progName);
        end
    elseif ispc
        userDoc = winqueryreg('HKEY_CURRENT_USER',...
            ['Software\Microsoft\Windows\CurrentVersion\' ...
             'Explorer\Shell Folders'],'Personal');
        defaultstartdir = fullfile(userDoc,progName);
    else
        fprintf(1,'WARNING: Unable to determine OS\n');
        defaultstartdir = pwd;
    end
else % running at command line
    defaultstartdir = pwd;
end

% make the directory
if ~isfolder(defaultstartdir)
    try
        mkdir(defaultstartdir);
    catch
        fprintf(1,'WARNING: unable to create working directory\n');
        defaultstartdir = char(java.lang.System.getProperty('user.home'));
    end
end

% go to the directory for saving data files, waveforms, etc
try
    cd(defaultstartdir);
catch
    fprintf(1,'WARNING: unable to go to default directory\n    %s\n',defaultstartdir);
    %fprintf(1,'    Use a File Load or Save operation to select a writeable directory\n');
end

fprintf(1,' Working directory: %s\n',pwd);

% make sure that the template files are available
%if isdeployed
    if ~isfile(fullfile(path_to_templates,'Master_DO_NOT_EDIT.xlsx'))
        fprintf(1,'WARNING: Master xlsx file not found\n');
    end
    if ~isfile(fullfile(path_to_templates,'Sample_DO_NOT_EDIT.xlsx'))
        fprintf(1,'WARNING: Sample xlsx file not found\n');
    end
%end

% use this to check timing throughout image processing
%userTiming.mainTiming{1} = tic;
%setappdata(0,'userTiming',userTiming)

%profile on

% start the parallel computing pool % MH: not helpful to start before needed
%if use_parallel > 0, gcp; end

% add paths of external funcs
if ~isdeployed
    addpath('External');
    addpath('External/bfmatlab');
    addpath('External/statusbar');
    addpath('External/20130227_xlwrite');
%     if ispc
% 	    try
%     % 		addpath('External/ncorr_OpenMP'); % this version has OpenMP support
%     %		fprintf('CXS-TFM: Using ncorr with OpenMP support.\n');
% 		    addpath('External/ncorr_v1_2');
% 		    fprintf('CXS-TFM: OpenMP version of ncorr is not available.\n');
% 	    catch
% 		    addpath('External/ncorr_v1_2');
% 		    fprintf('CXS-TFM: OpenMP version of ncorr is not available.\n');
% 	    end
%     else
% 	    addpath('External/ncorr_v1_2');
%     end
    addpath('External/ncorr_2D_matlab');
%     addpath('External/ojwoodford-export_fig-5735e6d')
%     addpath('External/freezeColors');
    addpath('External/regu');

    javaaddpath('External/20130227_xlwrite/poi_library/poi-3.8-20120326.jar');
    javaaddpath('External/20130227_xlwrite/poi_library/poi-ooxml-3.8-20120326.jar');
    javaaddpath('External/20130227_xlwrite/poi_library/poi-ooxml-schemas-3.8-20120326.jar');
    javaaddpath('External/20130227_xlwrite/poi_library/xmlbeans-2.3.0.jar');
    javaaddpath('External/20130227_xlwrite/poi_library/dom4j-1.6.1.jar');
    javaaddpath('External/20130227_xlwrite/poi_library/stax-api-1.0.1.jar');

% else
%     javaaddpath('poi_library/poi-3.8-20120326.jar');
%     javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
%     javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
%     javaaddpath('poi_library/xmlbeans-2.3.0.jar');
%     javaaddpath('poi_library/dom4j-1.6.1.jar');
%     javaaddpath('poi_library/stax-api-1.0.1.jar');    
end

% javaclasspath % print for debugging
% fprintf(1,'\n');
if isempty(which('bioformats_package.jar'))
    fprintf(1,'WARNING: bioformats_package.jar file not found\n');
end

%figure size for main window
figuresize=[200,225];
%get screen size
screensize = get(0,'ScreenSize');
xpos = ceil((screensize(3)-figuresize(2))/2);
ypos = ceil((screensize(4)-figuresize(1))/2);
fontsizeA = 10; if ismac, fontsizeA = fontsizeA+2; end

%create figure
h_main.fig=figure(...
    'position',[xpos, ypos, figuresize(2), figuresize(1)],...
    'units','pixels',...
    'renderer','OpenGL',...
    'MenuBar','none',...
    'PaperPositionMode','auto',...
    'Name','CONTRAX Main',...
    'NumberTitle','off',...
    'Resize','off',...
    'Color',[.2,.2,.2],...
	'DeleteFcn',{@tfmCloseFcn});
movegui(h_main.fig,'center');

%create buttons:
%button size
buttonsize=[30,200];
%vertical space between buttons: 4 buttons along figuresize -> 5 spaces
verticalspace=(figuresize(1)-4*buttonsize(1))/5;
%button 1 - initalization
h_main.button_init = uicontrol('Parent',h_main.fig,'style','pushbutton','position',[figuresize(2)/2-buttonsize(2)/2,4*verticalspace+3*buttonsize(1),buttonsize(2),buttonsize(1)],...
    'string','Initialization (Images)','FontSize',fontsizeA);
%button 2 - displacement; disabled at start
h_main.button_piv = uicontrol('Parent',h_main.fig,'style','pushbutton','position',[figuresize(2)/2-buttonsize(2)/2,3*verticalspace+2*buttonsize(1),buttonsize(2),buttonsize(1)],...
    'string','Displacements (PIV)','FontSize',fontsizeA,'Enable','off');
%button 3 - sarcomere analysis; disabled at start
h_main.button_tfm = uicontrol('Parent',h_main.fig,'style','pushbutton','position',[figuresize(2)/2-buttonsize(2)/2,2*verticalspace+buttonsize(1),buttonsize(2),buttonsize(1)],...
    'string','Traction Forces (TFM)','FontSize',fontsizeA,'Enable','off');
%button 4 - parameter extraction; disabled at start
h_main.button_para = uicontrol('Parent',h_main.fig,'style','pushbutton','position',[figuresize(2)/2-buttonsize(2)/2,verticalspace,buttonsize(2),buttonsize(1)],...
    'string','Results','FontSize',fontsizeA,'Enable','off');

%assign callbacks to buttons
%button 1
set(h_main.button_init,'callback',{@main_push_init,h_main})
%button 2
set(h_main.button_piv,'callback',{@main_push_piv,h_main})
%button 4
set(h_main.button_tfm,'callback',{@main_push_tfm,h_main})
%button 5
set(h_main.button_para,'callback',{@main_push_para,h_main})

% save some mouse clicks
if ~isdeployed, set(h_main.fig,'KeyPressFcn',{@main_push_init,h_main}); end


%JFM
notif.on = false; %set to true if notification are desired
notif.url={}; %input the ifttt trigger url to implement a notification during computing
setappdata(0,'notif',notif);

setappdata(0,'path_to_templates',path_to_templates);

setappdata(0,'use_parallel',use_parallel);
drawnow;


%profile off


fprintf(1,'CXS-TFM: Ready\n');
figure(h_main.fig);



function main_push_init(hObject, eventdata, h_main) %#ok<INUSL>
%launch the initialization window
%profile resume
tfm_init(h_main);

function main_push_piv(hObject, eventdata, h_main) %#ok<INUSL>
%launch the displacement window
%profile resume
tfm_piv(h_main);
set(h_main.button_tfm,'Enable','on');

function main_push_tfm(hObject, eventdata, h_main) %#ok<INUSL>
%launch the sarcomere analysis window
%profile resume
tfm_tfm(h_main);

function main_push_para(hObject, eventdata, h_main) %#ok<INUSL>
%launch the results window
%profile resume
tfm_para(h_main);

function tfmCloseFcn(hObject, eventdata, h_main)
% executed when the main window is closed by the user
close all
fprintf(1,'CXS-TFM: Program closed.\n');
