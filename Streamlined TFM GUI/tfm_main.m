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
% tfm_mains.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Instructions:
% To analyse TFM video, execute tfm_main.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function tfm_main
%main function for the main window of lifeact analysis

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

use_parallel=24; % set to positive integer to enable parallel processing with that many workers, or 0 to disable

% disable warning for obsolete java components
%  See: https://www.mathworks.com/products/matlab/app-designer/java-swing-alternatives.html?s_tid=OIT_20611
% This appears to be caused by the use of non-authorized matlab code for
% the statusbar update and window state. These can be replaced. -MH 
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
% easier to suppress this warning than to fix the problem MH
warning('off','MATLAB:MKDIR:DirectoryExists');

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
fprintf(1,'          %s\n\n',buildver);
fprintf(1,'  Start Time: %s \n\n',datestr(now));

fprintf(1,'\n');
fprintf(1,'CXS-TFM: main function\n');


% use this to check timing throughout image processing
%userTiming.mainTiming{1} = tic;
%setappdata(0,'userTiming',userTiming)

%profile on


%add paths of external funcs
if ~isdeployed
    addpath('External');
    addpath('External/bfmatlab');
    addpath('External/statusbar');
    addpath('External/20130227_xlwrite');
    if ispc
	    try
    % 		addpath('External/ncorr_OpenMP'); % this version has OpenMP support
    %		fprintf('CXS-TFM: Using ncorr with OpenMP support.\n');
		    addpath('External/ncorr_v1_2');
		    fprintf('CXS-TFM: OpenMP version of ncorr is not available.\n');
	    catch
		    addpath('External/ncorr_v1_2');
		    fprintf('CXS-TFM: OpenMP version of ncorr is not available.\n');
	    end
    else
	    addpath('External/ncorr_v1_2');
    end
    addpath('External/ojwoodford-export_fig-5735e6d')
    addpath('External/freezeColors');
    addpath('External/regu/regu');

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

% javaclasspath
% fprintf(1,'\n');

%figure size
figuresize=[200,225];
%get screen size
screensize = get(0,'ScreenSize');
xpos = ceil((screensize(3)-figuresize(2))/2);
ypos = ceil((screensize(4)-figuresize(1))/2);
fontsizeA = 10;

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
    'string','Initialization','FontSize',fontsizeA);
%button 2 - displacement; disabled at start
h_main.button_piv = uicontrol('Parent',h_main.fig,'style','pushbutton','position',[figuresize(2)/2-buttonsize(2)/2,3*verticalspace+2*buttonsize(1),buttonsize(2),buttonsize(1)],...
    'string','Displacements','FontSize',fontsizeA,'Enable','off');
%button 3 - sarcomere analysis; disabled at start
h_main.button_tfm = uicontrol('Parent',h_main.fig,'style','pushbutton','position',[figuresize(2)/2-buttonsize(2)/2,2*verticalspace+buttonsize(1),buttonsize(2),buttonsize(1)],...
    'string','Traction Forces','FontSize',fontsizeA,'Enable','off');
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

%JFM
notif.on = false; %set to true if notification are desired
notif.url={}; %input the ifttt trigger url to implement a notification during computing
setappdata(0,'notif',notif);
setappdata(0,'use_parallel',use_parallel);



%profile off

fprintf(1,'CXS-TFM: Ready\n');

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
fprintf(1,'CXS-TFM: Program closed.\n');
