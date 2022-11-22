%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tfm_para.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part of the Streamlined TFM GUI: executes from the main Streamlined TFM 
% GUI menu after the Traction Force step and computes the contractile
% parameters from the traction stress and displacement. It ouputs an excel
% file per video and per btach with all contractile paramter and time
% traces. It implements both manual and automated peak analysis, using an
% algorithm for peak identification, alignment, averagin and analysis.
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

%main function for the parameter window of lifeact gui
function tfm_para(h_main)
fprintf(1,'\n');
fprintf(1,'CXS-TFM: Results Module\n');


%userTiming= getappdata(0,'userTiming');
%userTiming.tfm2para{2} = toc(userTiming.tfm2para{1});

%create new window for parameter
%fig size
figsize=[680,955];
%get screen size
screensize = get(0,'ScreenSize');
%position fig on center of screen
xpos = ceil((screensize(3)-figsize(2))/2);
ypos = ceil((screensize(4)-figsize(1))/2);
%create fig; invisible at first
h_para.fig=figure(...
    'position',[xpos, ypos, figsize(2), figsize(1)],...
    'units','pixels',...
    'renderer','OpenGL',...
    'MenuBar','none',...
    'PaperPositionMode','auto',...
    'Name','ContraX Results',...
    'NumberTitle','off',...
    'Resize','off',...
    'Color',[.2,.2,.2],...
    'visible','off');

pcolor = [.2 .2 .2];
ptcolor = [1 1 1];
bcolor = [.3 .3 .3];
btcolor = [1 1 1];
h_para.ForegroundColor = ptcolor;
h_para.BackgroundColor = pcolor;
fontsizeA = 10;

%create uipanel for guess
h_para.panel_guess = uipanel('Parent',h_para.fig,'Title','Determine parameters','units','pixels','Position',[20,590,145,50],'visible','off');
h_para.panel_guess.ForegroundColor = ptcolor;
h_para.panel_guess.BackgroundColor = pcolor;
%button
h_para.button_guess = uicontrol('Parent',h_para.panel_guess,'style','pushbutton','position',[5,5,132,25],'string','Guess all');

% %uipanel for pattern ratio
h_para.panel_ratio = uipanel('Parent',h_para.fig,'Title','Ratio of the patterns','units','pixels','Position',[175,590,145,50],'visible','off');
h_para.panel_ratio.ForegroundColor = ptcolor;
h_para.panel_ratio.BackgroundColor = pcolor;
% %edit
h_para.edit_ratio = uicontrol('Parent',h_para.panel_ratio,'style','edit','position',[5,5,132,25]);

%uipanel for displacements
h_para.panel_disp = uipanel('Parent',h_para.fig,'Title','Displacements','units','pixels','Position',[20,485,300,180],'BorderType','none');
h_para.panel_disp.ForegroundColor = ptcolor;
h_para.panel_disp.BackgroundColor = pcolor;
%axes
h_para.axes_disp = axes('Parent',h_para.panel_disp,'Units', 'pixels','Position',[5,50,287,115],'box','on');
%button: addmax
h_para.button_disp_addmax = uicontrol('Parent',h_para.panel_disp,'style','pushbutton','position',[5,25,70,20],'string','Add max');
%button: removemax
h_para.button_disp_removemax = uicontrol('Parent',h_para.panel_disp,'style','pushbutton','position',[5,5,70,20],'string','Remove max');
%button: addmin
h_para.button_disp_addmin = uicontrol('Parent',h_para.panel_disp,'style','pushbutton','position',[75,25,70,20],'string','Add min');
%button: removemin
h_para.button_disp_removemin = uicontrol('Parent',h_para.panel_disp,'style','pushbutton','position',[75,5,70,20],'string','Remove min');
%button: clearall
h_para.button_disp_clearall = uicontrol('Parent',h_para.panel_disp,'style','pushbutton','position',[145,5,35,40],'string','Clear');
%text: deltad
h_para.text_disp = uicontrol('Parent',h_para.panel_disp,'style','text','position',[185,30,110,15],'HorizontalAlignment','left','string','dcontr= ');
h_para.text_disp.ForegroundColor = ptcolor;
h_para.text_disp.BackgroundColor = pcolor;
%button: double peaks
h_para.button_double = uicontrol('Parent',h_para.panel_disp,'style','pushbutton','position',[185,3,100,25],'string','Double Peaks');

%uipanel for velocities and contraction time
h_para.panel_vel = uipanel('Parent',h_para.fig,'Title','Velocities and Contraction Time','units','pixels','Position',[20,270,300,210],'BorderType','none');
h_para.panel_vel.ForegroundColor = ptcolor;
h_para.panel_vel.BackgroundColor = pcolor;
%axes
h_para.axes_vel = axes('Parent',h_para.panel_vel,'Units', 'pixels','Position',[5,80,287,115],'box','on');
%button: addmax
h_para.button_vel_addmax = uicontrol('Parent',h_para.panel_vel,'style','pushbutton','position',[5,55,70,20],'string','Add max');
%button: removemax
h_para.button_vel_removemax = uicontrol('Parent',h_para.panel_vel,'style','pushbutton','position',[5,35,70,20],'string','Remove max');
%button: addmin
h_para.button_vel_addmin = uicontrol('Parent',h_para.panel_vel,'style','pushbutton','position',[75,55,70,20],'string','Add min');
%button: removemin
h_para.button_vel_removemin = uicontrol('Parent',h_para.panel_vel,'style','pushbutton','position',[75,35,70,20],'string','Remove min');
%button: clearall
h_para.button_vel_clearall = uicontrol('Parent',h_para.panel_vel,'style','pushbutton','position',[145,35,35,40],'string','Clear');
%button: calculate contraction times
h_para.button_contr_calc = uicontrol('Parent',h_para.panel_vel,'style','pushbutton','position',[5,5,140,25],'string','Calculate contraction times');
%text: vcontr
h_para.text_vel1 = uicontrol('Parent',h_para.panel_vel,'style','text','position',[185,55,110,15],'HorizontalAlignment','left','string','vcontr = ');
h_para.text_vel1.ForegroundColor = ptcolor;
h_para.text_vel1.BackgroundColor = pcolor;
%text: vrelax
h_para.text_vel2 = uicontrol('Parent',h_para.panel_vel,'style','text','position',[185,35,110,15],'HorizontalAlignment','left','string','vrelax = ');
h_para.text_vel2.ForegroundColor = ptcolor;
h_para.text_vel2.BackgroundColor = pcolor;
%text: tcontr
h_para.text_contr = uicontrol('Parent',h_para.panel_vel,'style','text','position',[185,15,110,15],'HorizontalAlignment','left','string','tcontr = ');
h_para.text_contr.ForegroundColor = ptcolor;
h_para.text_contr.BackgroundColor = pcolor;


%uipanel for autocorrelation
h_para.panel_autocor = uipanel('Parent',h_para.fig,'Title','Auto Peak Averaging','units','pixels','Position',[20,85,300,180],'BorderType','none');
h_para.panel_autocor.ForegroundColor = ptcolor;
h_para.panel_autocor.BackgroundColor = pcolor;
%displacement axes
h_para.axes_disp_autocor = axes('Parent',h_para.panel_autocor,'Units','pixels','Position',[5,50,143,115],'box','on');
%force axes
h_para.axes_force_autocor = axes('Parent',h_para.panel_autocor,'Units','pixels','Position',[150,50,143,115],'box','on');
%text: displacement
h_para.text_disp_autocor = uicontrol('Parent',h_para.panel_autocor,'style','text','position',[5,30,130,15],'HorizontalAlignment','left','string','dcontr= ');
h_para.text_disp_autocor.ForegroundColor = ptcolor;
h_para.text_disp_autocor.BackgroundColor = pcolor;
%text: velocity contraction
h_para.text_vcontr_autocor = uicontrol('Parent',h_para.panel_autocor,'style','text','position',[5,16,130,15],'HorizontalAlignment','left','string','vcontr= ');
h_para.text_vcontr_autocor.ForegroundColor = ptcolor;
h_para.text_vcontr_autocor.BackgroundColor = pcolor;
%text: velocity relax
h_para.text_vrelax_autocor = uicontrol('Parent',h_para.panel_autocor,'style','text','position',[150,16,130,15],'HorizontalAlignment','left','string','vrelax= ');
h_para.text_vrelax_autocor.ForegroundColor = ptcolor;
h_para.text_vrelax_autocor.BackgroundColor = pcolor;
%text: force
h_para.text_force_autocor = uicontrol('Parent',h_para.panel_autocor,'style','text','position',[150,30,130,15],'HorizontalAlignment','left','string','F= ');
h_para.text_force_autocor.ForegroundColor = ptcolor;
h_para.text_force_autocor.BackgroundColor = pcolor;
%text: Comment
h_para.text_note_autocor = uicontrol('Parent',h_para.panel_autocor,'style','text','position',[5,2,260,15],'HorizontalAlignment','left','string','Note: ');
h_para.text_note_autocor.ForegroundColor = ptcolor;
h_para.text_note_autocor.BackgroundColor = pcolor;
%checkbox

%uipanel for forces
h_para.panel_forces = uipanel('Parent',h_para.fig,'Title','Forces','units','pixels','Position',[330,485,300,180],'BorderType','none');
h_para.panel_forces.ForegroundColor = ptcolor;
h_para.panel_forces.BackgroundColor = pcolor;
%axes
h_para.axes_forces = axes('Parent',h_para.panel_forces,'Units', 'pixels','Position',[5,50,287,115],'box','on');
%button: addmax
h_para.button_forces_addmax = uicontrol('Parent',h_para.panel_forces,'style','pushbutton','position',[50,25,70,20],'string','Add max');
%button: removemax
h_para.button_forces_removemax = uicontrol('Parent',h_para.panel_forces,'style','pushbutton','position',[50,5,70,20],'string','Remove max');
%button: addmin
h_para.button_forces_addmin = uicontrol('Parent',h_para.panel_forces,'style','pushbutton','position',[120,25,70,20],'string','Add min');
%button: removemin
h_para.button_forces_removemin = uicontrol('Parent',h_para.panel_forces,'style','pushbutton','position',[120,5,70,20],'string','Remove min');
%button: clearall
h_para.button_forces_clearall = uicontrol('Parent',h_para.panel_forces,'style','pushbutton','position',[190,25,35,20],'string','Clear');
%text: deltaf
h_para.text_forces = uicontrol('Parent',h_para.panel_forces,'style','text','position',[195,5,100,15],'HorizontalAlignment','left','string','F = ');
h_para.text_forces.ForegroundColor = ptcolor;
h_para.text_forces.BackgroundColor = pcolor;
%radiobutton group for user eval
h_para.buttongroup_forces = uibuttongroup('Parent',h_para.panel_forces,'Units', 'pixels','Position',[5,5,43,40]);
h_para.buttongroup_forces.ForegroundColor = ptcolor;
h_para.buttongroup_forces.BackgroundColor = pcolor;
%radiobutton 1: tot
h_para.radiobutton_forcetot = uicontrol('Parent',h_para.buttongroup_forces,'style','radiobutton','position',[1,26,35,10],'string','|F|','tag','radiobutton_ftot');
h_para.radiobutton_forcetot.ForegroundColor = ptcolor;
h_para.radiobutton_forcetot.BackgroundColor = pcolor;
%radiobutton 2: x
h_para.radiobutton_forcex = uicontrol('Parent',h_para.buttongroup_forces,'style','radiobutton','position',[1,14,37,10],'string','|Fx|','tag','radiobutton_fx');
h_para.radiobutton_forcex.ForegroundColor = ptcolor;
h_para.radiobutton_forcex.BackgroundColor = pcolor;
%radiobutton 2: x
h_para.radiobutton_forcey = uicontrol('Parent',h_para.buttongroup_forces,'style','radiobutton','position',[1,2,37,10],'string','|Fy|','tag','radiobutton_fy');
h_para.radiobutton_forcey.ForegroundColor = ptcolor;
h_para.radiobutton_forcey.BackgroundColor = pcolor;

%uipanel for power
h_para.panel_power = uipanel('Parent',h_para.fig,'Title','Power','units','pixels','Position',[330,300,300,180],'BorderType','none');
h_para.panel_power.ForegroundColor = ptcolor;
h_para.panel_power.BackgroundColor = pcolor;
%axes
h_para.axes_power = axes('Parent',h_para.panel_power,'Units', 'pixels','Position',[5,50,287,115],'box','on');
%button: addmax
h_para.button_power_addmax = uicontrol('Parent',h_para.panel_power,'style','pushbutton','position',[5,25,70,20],'string','Add max');
%button: removemax
h_para.button_power_removemax = uicontrol('Parent',h_para.panel_power,'style','pushbutton','position',[5,5,70,20],'string','Remove max');
%button: addmin
h_para.button_power_addmin = uicontrol('Parent',h_para.panel_power,'style','pushbutton','position',[75,25,70,20],'string','Add min');
%button: removemin
h_para.button_power_removemin = uicontrol('Parent',h_para.panel_power,'style','pushbutton','position',[75,5,70,20],'string','Remove min');
%button: clearall
h_para.button_power_clearall = uicontrol('Parent',h_para.panel_power,'style','pushbutton','position',[145,5,35,40],'string','Clear');
%text: Pcontr
h_para.text_power1 = uicontrol('Parent',h_para.panel_power,'style','text','position',[185,25,110,15],'HorizontalAlignment','left','string','Pcontr = ');
h_para.text_power1.ForegroundColor = ptcolor;
h_para.text_power1.BackgroundColor = pcolor;
%text: Prelax
h_para.text_power2 = uicontrol('Parent',h_para.panel_power,'style','text','position',[185,5,110,15],'HorizontalAlignment','left','string','Prelax = ');
h_para.text_power2.ForegroundColor = ptcolor;
h_para.text_power2.BackgroundColor = pcolor;

%uipanel for contraction time
h_para.panel_contr = uipanel('Parent',h_para.fig,'Title','Contraction time equivalent','units','pixels','Position',[330,30,300,180]);
h_para.panel_contr.ForegroundColor = ptcolor;
h_para.panel_contr.BackgroundColor = pcolor;
%axes
h_para.axes_contr = axes('Parent',h_para.panel_contr,'Units', 'pixels','Position',[5,50,287,115],'box','on');
%button: get
h_para.button_contr_get = uicontrol('Parent',h_para.panel_contr,'style','pushbutton','position',[5,5,35,40],'string','Get');
%button: add
h_para.button_contr_add = uicontrol('Parent',h_para.panel_contr,'style','pushbutton','position',[40,25,70,20],'string','Add');
%button: remove
h_para.button_contr_remove = uicontrol('Parent',h_para.panel_contr,'style','pushbutton','position',[40,5,70,20],'string','Remove');
%button: clearall
h_para.button_contr_clearall = uicontrol('Parent',h_para.panel_contr,'style','pushbutton','position',[110,5,35,40],'string','Clear');
%text: tcontr
%h_para.text_contr = uicontrol('Parent',h_para.panel_contr,'style','text','position',[150,25,110,15],'HorizontalAlignment','left','string','t = ');

%uipanel for strain energy
h_para.panel_strain = uipanel('Parent',h_para.fig,'Title','Strain Energy','units','pixels','position',[640,485,300,180],'BorderType','none');
h_para.panel_strain.ForegroundColor = ptcolor;
h_para.panel_strain.BackgroundColor = pcolor;
%axes
h_para.axes_strain = axes('Parent',h_para.panel_strain,'units','pixels','position',[5,50,287,115],'box','on');
%button: addmax
h_para.button_strain_addmax = uicontrol('Parent',h_para.panel_strain,'style','pushbutton','position',[5,25,70,20],'string','Add max');
%button: removemax
h_para.button_strain_removemax = uicontrol('Parent',h_para.panel_strain,'style','pushbutton','position',[5,5,70,20],'string','Remove max');
%button: addmin
h_para.button_strain_addmin = uicontrol('Parent',h_para.panel_strain,'style','pushbutton','position',[75,25,70,20],'string','Add min');
%button: removemin
h_para.button_strain_removemin = uicontrol('Parent',h_para.panel_strain,'style','pushbutton','position',[75,5,70,20],'string','Remove min');
%button: clearall
h_para.button_strain_clearall = uicontrol('Parent',h_para.panel_strain,'style','pushbutton','position',[145,5,35,40],'string','Clear');
%text: strain
h_para.text_strain = uicontrol('Parent',h_para.panel_strain,'style','text','position',[185,25,110,15],'HorizontalAlignment','left','string','U = ');
h_para.text_strain.ForegroundColor = ptcolor;
h_para.text_strain.BackgroundColor = pcolor;

%uipanel for contractile moment
h_para.panel_moment = uipanel('Parent',h_para.fig,'Title','Contractile Moment','units','pixels','position',[640,300,300,180],'BorderType','none');
h_para.panel_moment.ForegroundColor = ptcolor;
h_para.panel_moment.BackgroundColor = pcolor;
%axes
h_para.axes_moment = axes('Parent',h_para.panel_moment,'units','pixels','position',[5,50,287,115],'box','on');
%button: addmax
h_para.button_moment_addmax = uicontrol('Parent',h_para.panel_moment,'style','pushbutton','position',[50,25,70,20],'string','Add max');
%button: removemax
h_para.button_moment_removemax = uicontrol('Parent',h_para.panel_moment,'style','pushbutton','position',[50,5,70,20],'string','Remove max');
%button: addmin
h_para.button_moment_addmin = uicontrol('Parent',h_para.panel_moment,'style','pushbutton','position',[120,25,70,20],'string','Add min');
%button: removemin
h_para.button_moment_removemin = uicontrol('Parent',h_para.panel_moment,'style','pushbutton','position',[120,5,70,20],'string','Remove min');
%button: clearall
h_para.button_moment_clearall = uicontrol('Parent',h_para.panel_moment,'style','pushbutton','position',[190,25,35,20],'string','Clear');
%text: moment
h_para.text_moment = uicontrol('Parent',h_para.panel_moment,'style','text','position',[195,5,100,15],'HorizontalAlignment','left','string','mu=');
h_para.text_moment.ForegroundColor = ptcolor;
h_para.text_moment.BackgroundColor = pcolor;
%radiobutton group for user eval
h_para.buttongroup_moments = uibuttongroup('Parent',h_para.panel_moment,'Units', 'pixels','Position',[5,5,43,40]);
h_para.buttongroup_moments.ForegroundColor = ptcolor;
h_para.buttongroup_moments.BackgroundColor = pcolor;
%radiobutton 1: Mxx
h_para.radiobutton_Mxx = uicontrol('Parent',h_para.buttongroup_moments,'style','radiobutton','position',[1,26,40,10],'string','Mxx','tag','radiobutton_Mxx');
h_para.radiobutton_Mxx.ForegroundColor = ptcolor;
h_para.radiobutton_Mxx.BackgroundColor = pcolor;
%radiobutton 2: Myy
h_para.radiobutton_Myy = uicontrol('Parent',h_para.buttongroup_moments,'style','radiobutton','position',[1,14,40,10],'string','Myy','tag','radiobutton_Myy');
h_para.radiobutton_Myy.ForegroundColor = ptcolor;
h_para.radiobutton_Myy.BackgroundColor = pcolor;
%radiobutton 3: mu
h_para.radiobutton_mu = uicontrol('Parent',h_para.buttongroup_moments,'style','radiobutton','position',[1,2,40,10],'string','mu','tag','radiobutton_mu','Value',1);
h_para.radiobutton_mu.ForegroundColor = ptcolor;
h_para.radiobutton_mu.BackgroundColor = pcolor;


%uipanel for frequency / traction orientation
h_para.panel_freq_orient = uipanel('Parent',h_para.fig,'Title','Frequency and Traction Orientation','units','pixels','position',[640,85,300,210],'BorderType','none');
h_para.panel_freq_orient.ForegroundColor = ptcolor;
h_para.panel_freq_orient.BackgroundColor = pcolor;
%axes orientation
h_para.axes_orient = polaraxes('Parent',h_para.panel_freq_orient,'units','pixels','position',[178,40,115,155],'box','on');
%axes center
h_para.axes_freq = axes('Parent',h_para.panel_freq_orient,'units','pixels','position',[5,80,168,115],'box','on');
%text: colorbar
h_para.text_colorbar = uicontrol('Parent',h_para.panel_freq_orient,'style','text','position',[180,50,200,15],'string','Relaxed        Contracted','HorizontalAlignment','left');
h_para.text_colorbar.ForegroundColor = ptcolor;
h_para.text_colorbar.BackgroundColor = pcolor;
%radiobutton group for user eval
h_para.buttongroup_freq = uibuttongroup('Parent',h_para.panel_freq_orient,'Units', 'pixels','Position',[5,20,70,55]);
h_para.buttongroup_freq.ForegroundColor = ptcolor;
h_para.buttongroup_freq.BackgroundColor = pcolor;
%radiobutton 1: fft
h_para.radiobutton_fft = uicontrol('Parent',h_para.buttongroup_freq,'style','radiobutton','position',[0,35,60,15],'string','FFT','tag','radiobutton_fft');
h_para.radiobutton_fft.ForegroundColor = ptcolor;
h_para.radiobutton_fft.BackgroundColor = pcolor;
%radiobutton 1: pick
h_para.radiobutton_pick = uicontrol('Parent',h_para.buttongroup_freq,'style','radiobutton','position',[0,20,60,15],'string','Pick','tag','radiobutton_pick');
h_para.radiobutton_pick.ForegroundColor = ptcolor;
h_para.radiobutton_pick.BackgroundColor = pcolor;
%radiobutton 1: autocorr
h_para.radiobutton_autocorr = uicontrol('Parent',h_para.buttongroup_freq,'style','radiobutton','position',[0,5,60,15],'string','Autocorr','tag','radiobutton_autocorr');
h_para.radiobutton_autocorr.ForegroundColor = ptcolor;
h_para.radiobutton_autocorr.BackgroundColor = pcolor;
%radiobutton group for center / orientation
h_para.buttongroup_orient = uibuttongroup('Parent',h_para.panel_freq_orient,'units','pixels','position',[190,5,100,40]);
h_para.buttongroup_orient.ForegroundColor = ptcolor;
h_para.buttongroup_orient.BackgroundColor = pcolor;
%radiobutton 2: center
h_para.radiobutton_center = uicontrol('Parent',h_para.buttongroup_orient,'style','radiobutton','position',[5,20,80,15],'string','Center','tag','radiobutton_center');
h_para.radiobutton_center.ForegroundColor = ptcolor;
h_para.radiobutton_center.BackgroundColor = pcolor;
%radiobutton 2: orient
h_para.radiobutton_orient = uicontrol('Parent',h_para.buttongroup_orient,'style','radiobutton','position',[5,5,80,15],'string','Orientation','tag','radiobutton_orient');
h_para.radiobutton_orient.ForegroundColor = ptcolor;
h_para.radiobutton_orient.BackgroundColor = pcolor;
%button: add
h_para.button_freq_add = uicontrol('Parent',h_para.panel_freq_orient,'style','pushbutton','position',[75,55,60,20],'string','Add');
%button: add fft
h_para.button_freq_addfft = uicontrol('Parent',h_para.panel_freq_orient,'style','pushbutton','position',[75,55,60,20],'string','Pick');
%button: remove
h_para.button_freq_remove = uicontrol('Parent',h_para.panel_freq_orient,'style','pushbutton','position',[75,35,60,20],'string','Remove');
%button: clearall
h_para.button_freq_clearall = uicontrol('Parent',h_para.panel_freq_orient,'style','pushbutton','position',[135,35,40,40],'string','Clear');
%text: f
h_para.text_freq1 = uicontrol('Parent',h_para.panel_freq_orient,'style','text','position',[75,20,80,15],'HorizontalAlignment','left','string','f = ');
h_para.text_freq1.ForegroundColor = ptcolor;
h_para.text_freq1.BackgroundColor = pcolor;
%text: T
h_para.text_freq2 = uicontrol('Parent',h_para.panel_freq_orient,'style','text','position',[75,5,80,15],'HorizontalAlignment','left','string','T = ');
h_para.text_freq2.ForegroundColor = ptcolor;
h_para.text_freq2.BackgroundColor = pcolor;

%uipanel for preview
h_para.panel_preview = uipanel('Parent',h_para.fig,'Title','Preview of traction','units','pixels','Position',[330,115,300,180],'BorderType','none');
h_para.panel_preview.ForegroundColor = ptcolor;
h_para.panel_preview.BackgroundColor = pcolor;
% button for traction gif
h_para.button_traction_anim = uicontrol('Parent',h_para.panel_preview,'style','pushbutton','position',[5,5,287,160]);

%uipanel for tags
h_para.panel_tag = uipanel('Parent',h_para.fig,'Title','Tags','units','pixels','Position',[20,30,700,50]);
h_para.panel_tag.ForegroundColor = ptcolor;
h_para.panel_tag.BackgroundColor = pcolor;
%arrhythmia
h_para.checkbox_disc = uicontrol('Parent',h_para.panel_tag,'style','checkbox','position',[5,8,80,25],'string','Discard','HorizontalAlignment','left');
h_para.checkbox_disc.ForegroundColor = ptcolor;
h_para.checkbox_disc.BackgroundColor = pcolor;
% double cells
h_para.checkbox_dbl = uicontrol('Parent',h_para.panel_tag,'style','checkbox','position',[85,8,90,25],'string','2+ cells','HorizontalAlignment','left');
h_para.checkbox_dbl.ForegroundColor = ptcolor;
h_para.checkbox_dbl.BackgroundColor = pcolor;
% drifting particles
h_para.checkbox_drift = uicontrol('Parent',h_para.panel_tag,'style','checkbox','position',[175,8,100,25],'string','Image artifact','HorizontalAlignment','left');
h_para.checkbox_drift.ForegroundColor = ptcolor;
h_para.checkbox_drift.BackgroundColor = pcolor;
% other
h_para.checkbox_other = uicontrol('Parent',h_para.panel_tag,'style','checkbox','position',[270,8,60,25],'string','Other -> Notes:','HorizontalAlignment','left');
h_para.checkbox_other.ForegroundColor = ptcolor;
h_para.checkbox_other.BackgroundColor = pcolor;
h_para.edit_other = uicontrol('Parent',h_para.panel_tag,'style','edit','position',[360,10,330,20],'HorizontalAlignment','left');

%button: forwards
h_para.button_forwards = uicontrol('Parent',h_para.fig,'style','pushbutton','position',[605,85,25,25],'string','>');
%button: backwards
h_para.button_backwards = uicontrol('Parent',h_para.fig,'style','pushbutton','position',[580,85,25,25],'string','<');
%text: show which video (i/n)
h_para.text_whichvid = uicontrol('Parent',h_para.fig,'style','text','position',[530,90,50,15],'string','(1/1)','HorizontalAlignment','left');
h_para.text_whichvid.ForegroundColor = ptcolor;
h_para.text_whichvid.BackgroundColor = pcolor;
%text: show which video (name)
h_para.text_whichvidname = uicontrol('Parent',h_para.fig,'style','text','position',[330,90,150,15],'string','Experiment','HorizontalAlignment','left');
h_para.text_whichvidname.ForegroundColor = ptcolor;
h_para.text_whichvidname.BackgroundColor = pcolor;

%create ok button
h_para.button_ok = uicontrol('Parent',h_para.fig,'style','pushbutton','position',[870,37,70,30],'string','OK','visible','on');
%create save checkbox
h_para.checkbox_save = uicontrol('Parent',h_para.fig,'style','checkbox','position',[740,60,120,15],'string','Save plots {.fig,.png}','HorizontalAlignment','left');
h_para.checkbox_save.ForegroundColor = ptcolor;
h_para.checkbox_save.BackgroundColor = pcolor;
%create save traction checkbox
h_para.checkbox_save_traction = uicontrol('Parent',h_para.fig,'style','checkbox','position',[740,30,120,15],'string','Save traction data','HorizontalAlignment','left');
h_para.checkbox_save_traction.ForegroundColor = ptcolor;
h_para.checkbox_save_traction.BackgroundColor = pcolor;


%callbacks for buttons and buttongroup
set(h_para.button_guess,'callback',{@para_push_guess,h_para})
set(h_para.button_disp_addmax,'callback',{@para_push_disp_addmax,h_para})
set(h_para.button_disp_addmin,'callback',{@para_push_disp_addmin,h_para})
set(h_para.button_disp_removemax,'callback',{@para_push_disp_removemax,h_para})
set(h_para.button_disp_removemin,'callback',{@para_push_disp_removemin,h_para})
set(h_para.button_disp_clearall,'callback',{@para_push_disp_clearall,h_para})
set(h_para.button_vel_addmax,'callback',{@para_push_vel_addmax,h_para})
set(h_para.button_vel_addmin,'callback',{@para_push_vel_addmin,h_para})
set(h_para.button_vel_removemax,'callback',{@para_push_vel_removemax,h_para})
set(h_para.button_vel_removemin,'callback',{@para_push_vel_removemin,h_para})
set(h_para.button_vel_clearall,'callback',{@para_push_vel_clearall,h_para})
set(h_para.button_contr_calc,'callback',{@para_push_contr_calc,h_para})
set(h_para.button_freq_add,'callback',{@para_push_freq_add,h_para})
set(h_para.button_freq_addfft,'callback',{@para_push_freq_addfft,h_para})
set(h_para.button_freq_remove,'callback',{@para_push_freq_remove,h_para})
set(h_para.button_freq_clearall,'callback',{@para_push_freq_clearall,h_para})
set(h_para.button_forces_addmax,'callback',{@para_push_forces_addmax,h_para})
set(h_para.button_forces_addmin,'callback',{@para_push_forces_addmin,h_para})
set(h_para.button_forces_removemax,'callback',{@para_push_forces_removemax,h_para})
set(h_para.button_forces_removemin,'callback',{@para_push_forces_removemin,h_para})
set(h_para.button_forces_clearall,'callback',{@para_push_forces_clearall,h_para})
set(h_para.button_power_addmax,'callback',{@para_push_power_addmax,h_para})
set(h_para.button_power_addmin,'callback',{@para_push_power_addmin,h_para})
set(h_para.button_power_removemax,'callback',{@para_push_power_removemax,h_para})
set(h_para.button_power_removemin,'callback',{@para_push_power_removemin,h_para})
set(h_para.button_power_clearall,'callback',{@para_push_power_clearall,h_para})
set(h_para.button_contr_get,'callback',{@para_push_contr_get,h_para})
set(h_para.button_contr_add,'callback',{@para_push_contr_add,h_para})
set(h_para.button_contr_remove,'callback',{@para_push_contr_remove,h_para})
set(h_para.button_contr_clearall,'callback',{@para_push_contr_clearall,h_para})
set(h_para.button_strain_addmax,'callback',{@para_push_strain_addmax,h_para})
set(h_para.button_strain_addmin,'callback',{@para_push_strain_addmin,h_para})
set(h_para.button_strain_removemax,'callback',{@para_push_strain_removemax,h_para})
set(h_para.button_strain_removemin,'callback',{@para_push_strain_removemin,h_para})
set(h_para.button_strain_clearall,'callback',{@para_push_strain_clearall,h_para})
set(h_para.button_moment_addmax,'callback',{@para_push_moment_addmax,h_para})
set(h_para.button_moment_addmin,'callback',{@para_push_moment_addmin,h_para})
set(h_para.button_moment_removemax,'callback',{@para_push_moment_removemax,h_para})
set(h_para.button_moment_removemin,'callback',{@para_push_moment_removemin,h_para})
set(h_para.button_moment_clearall,'callback',{@para_push_moment_clearall,h_para})
set(h_para.button_double,'callback',{@para_push_double,h_para})
% set(h_para.button_dp2_add,'callback',{@para_push_dp2_add,h_para})
% set(h_para.button_dp2_remove,'callback',{@para_push_dp2_remove,h_para})
% set(h_para.button_dp2_clearall,'callback',{@para_push_dp2_clearall,h_para})
set(h_para.button_forwards,'callback',{@para_push_forwards,h_para})
set(h_para.button_backwards,'callback',{@para_push_backwards,h_para})
set(h_para.button_ok,'callback',{@para_push_ok,h_para,h_main})
set(h_para.buttongroup_freq,'SelectionChangeFcn',{@para_buttongroup_freq,h_para})
set(h_para.buttongroup_forces,'SelectionChangeFcn',{@para_buttongroup_forces,h_para})
set(h_para.buttongroup_moments,'SelectionChangeFcn',{@para_buttongroup_moments,h_para})
set(h_para.buttongroup_orient,'SelectionChangeFcn',{@para_buttongroup_orient,h_para})
% set(h_para.checkbox_dpyes,'callback',{@para_checkbox_dpyes,h_para})
% set(h_para.checkbox_dpno,'callback',{@para_checkbox_dpno,h_para})
set(h_para.checkbox_disc,'callback',{@para_checkbox_disc,h_para})
set(h_para.checkbox_dbl,'callback',{@para_checkbox_dbl,h_para})
set(h_para.checkbox_drift,'callback',{@para_checkbox_drift,h_para})
set(h_para.checkbox_other,'callback',{@para_checkbox_other,h_para})
%

%prelimiary stuff
%hide and disable buttons and panels
set(h_para.panel_disp,'Visible','off');
set(h_para.panel_ratio,'Visible','off');
set(h_para.panel_vel,'Visible','off');
set(h_para.panel_autocor,'Visible','off');
set(h_para.panel_forces,'Visible','off');
set(h_para.panel_power,'Visible','off');
set(h_para.panel_contr,'Visible','off');
set(h_para.panel_strain,'Visible','off');
set(h_para.panel_moment,'Visible','off');
set(h_para.panel_freq_orient,'Visible','off');
% set(h_para.panel_dp,'Visible','off');
set(h_para.panel_tag,'Visible','off');
set(h_para.text_whichvidname,'Visible','off');
set(h_para.text_whichvid,'Visible','off');
set(h_para.button_ok,'Visible','off');
set(h_para.button_backwards,'Visible','off');
set(h_para.button_forwards,'Visible','off');
set(h_para.button_double,'Visible','off');
set(h_para.panel_preview,'Visible','off');
set(h_para.checkbox_save,'Visible','off');
set(h_para.checkbox_save_traction,'Visible','off');


%initiate counter
tfm_para_user_counter=1;

%Timing for tfm
%userTiming.para{1} = tic;

%store everything for shared use
%setappdata(0,'userTiming',userTiming);
setappdata(0,'tfm_para_user_counter',tfm_para_user_counter)

%make fig visible
set(h_para.fig,'visible','on');
%movegui(h_para.fig,'north');

%move main window to the side
% movegui(h_main.fig,'west')
% MH put the panel to the left of the main window
%  [left bottom width height]
fp = get(h_para.fig,'Position');
set(h_main.fig,'Units','pixels');
ap = get(h_main.fig,'Position');
set(h_main.fig,'Position',[fp(1)-ap(3) fp(2)+fp(4)-ap(4) ap(3) ap(4)]);

drawnow;

%trigger guess all
para_push_guess(h_para.button_guess, h_para, h_para)



function para_push_guess(~, ~, h_para)
%profile on

%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));

try
    sb=statusbar(h_para.fig,'Calculating... ');
    sb.getComponent(0).setForeground(java.awt.Color.red);
    
    %grey out button, do not turn it back on
    set(h_para.button_guess,'Enable','off')
    
    %load shared needed para
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_piv_user_meand=getappdata(0,'tfm_piv_user_meand');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_init_user_binary2=getappdata(0,'tfm_init_user_binary2');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_para_user_disp_l = 5e-9;%getappdata(0,'tfm_para_user_disp_l')
    
    %initialize
    F_tot=cell(1,tfm_init_user_Nfiles);%(1,max([tfm_init_user_Nframes{:}]));
    Fx_tot=cell(1,tfm_init_user_Nfiles);%(1,max([tfm_init_user_Nframes{:}]));
    Fy_tot=cell(1,tfm_init_user_Nfiles);%(1,max([tfm_init_user_Nframes{:}]));
    Velocity=cell(1,tfm_init_user_Nfiles);
    Power=cell(1,tfm_init_user_Nfiles);
    dmax=cell(1,tfm_init_user_Nfiles);
    dmin=cell(1,tfm_init_user_Nfiles);
    dt=cell(1,tfm_init_user_Nfiles);
    vmax=cell(1,tfm_init_user_Nfiles);
    vmin=cell(1,tfm_init_user_Nfiles);
    Fxmax=cell(1,tfm_init_user_Nfiles);
    Fymax=cell(1,tfm_init_user_Nfiles);
    Fxmin=cell(1,tfm_init_user_Nfiles);
    Fymin=cell(1,tfm_init_user_Nfiles);
    Fmax=cell(1,tfm_init_user_Nfiles);
    Fmin=cell(1,tfm_init_user_Nfiles);
    Pmax=cell(1,tfm_init_user_Nfiles);
    Pmin=cell(1,tfm_init_user_Nfiles);
    y_fft=cell(1,tfm_init_user_Nfiles);
    freq=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_d=cell(1,tfm_init_user_Nfiles);
    theta=cell(1,tfm_init_user_Nfiles);
    Mxx=cell(1,tfm_init_user_Nfiles);
    Mxy=cell(1,tfm_init_user_Nfiles);
    Myx=cell(1,tfm_init_user_Nfiles);
    Myy=cell(1,tfm_init_user_Nfiles);
    Mxx_max=cell(1,tfm_init_user_Nfiles);
    Mxx_min=cell(1,tfm_init_user_Nfiles);
    Mxy_max=cell(1,tfm_init_user_Nfiles);
    Mxy_min=cell(1,tfm_init_user_Nfiles);
    Myy_max=cell(1,tfm_init_user_Nfiles);
    Myy_min=cell(1,tfm_init_user_Nfiles);
    mu=cell(1,tfm_init_user_Nfiles);
    mu_max=cell(1,tfm_init_user_Nfiles);
    mu_min=cell(1,tfm_init_user_Nfiles);
    U=cell(1,tfm_init_user_Nfiles);
    Umax=cell(1,tfm_init_user_Nfiles);
    Umin=cell(1,tfm_init_user_Nfiles);
    center=cell(1,tfm_init_user_Nfiles);
    d_s=cell(1,tfm_init_user_Nfiles);
    d_pav=cell(1,tfm_init_user_Nfiles);
    F_s=cell(1,tfm_init_user_Nfiles);
    F_pav=cell(1,tfm_init_user_Nfiles);
    Fx_s=cell(1,tfm_init_user_Nfiles);
    Fx_pav=cell(1,tfm_init_user_Nfiles);
    Fy_s=cell(1,tfm_init_user_Nfiles);
    Fy_pav=cell(1,tfm_init_user_Nfiles);
    %     V_s=cell(1,tfm_init_user_Nfiles);
    %     V_pav=cell(1,tfm_init_user_Nfiles);
    P_s=cell(1,tfm_init_user_Nfiles);
    P_pav=cell(1,tfm_init_user_Nfiles);
    U_s=cell(1,tfm_init_user_Nfiles);
    U_pav=cell(1,tfm_init_user_Nfiles);
    %     Mxx_s=cell(1,tfm_init_user_Nfiles);
    %     Mxx_pav=cell(1,tfm_init_user_Nfiles);
    %     Myy_s=cell(1,tfm_init_user_Nfiles);
    %     Myy_pav=cell(1,tfm_init_user_Nfiles);
    mu_s=cell(1,tfm_init_user_Nfiles);
    mu_pav=cell(1,tfm_init_user_Nfiles);
    
    tfm_para_user_para_tcontr=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_tcontr=cell(1,tfm_init_user_Nfiles);

    tfm_para_user_para_freq=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_freqy=cell(1,tfm_init_user_Nfiles);

    %format diplacements
    for current_vid=1:tfm_init_user_Nfiles % parfor
        disp(['Calculating results for video #',num2str(current_vid)])
        
        tfm_para_user_d{current_vid}=[tfm_piv_user_meand{current_vid,:}];
        %Exclude 4 datapoints on each side of the relaxed frame, assigning the
        %mean value of either ends as bridge signal to avoid accounting for
        %the dip below the noise level
        rel_win = [max(1,tfm_piv_user_relax{current_vid}-4) min(size(tfm_para_user_d{current_vid},2),tfm_piv_user_relax{current_vid}+4)];
        tfm_para_user_d{current_vid}(rel_win(1):rel_win(2))= mean([tfm_para_user_d{current_vid}(rel_win(1)) tfm_para_user_d{current_vid}(rel_win(2))]);
        
        dt{current_vid}=(1:length(tfm_para_user_d{current_vid}))/tfm_init_user_framerate{current_vid};
        
        %find average peaks
        [d_s{current_vid},d_pav{current_vid}] = peak_averaging(dt{current_vid},tfm_para_user_d{current_vid},tfm_init_user_framerate{current_vid},1);
    %end
    
    %calc. forces
    %for current_vid=1:tfm_init_user_Nfiles
        %
        %transform mask, st 0s become Nans
        mask=double(tfm_init_user_binary2{current_vid});
        mask(mask==0)=NaN;
        
        %FOSTER pre-load files
        s_x = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_x.mat'],'x');
        s_y = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_y.mat'],'y');
        s_fu = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_u.mat'],'fu');
        s_fv = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_v.mat'],'fv');
        s_Fx = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_Fx.mat'],'Fx');
        s_Fy = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_Fy.mat'],'Fy');
        s_F = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_F.mat'],'F');
        for frame=1:tfm_init_user_Nframes{current_vid}
            %load spacing
            x=s_x.x(:,:,frame);
            y=s_y.y(:,:,frame);
            %load tfm data
            Fx=s_Fx.Fx(:,:,frame).*mask(y(:,1) ,x(1,:));
            Fy=s_Fy.Fy(:,:,frame).*mask(y(:,1) ,x(1,:));
            F=s_F.F(:,:,frame).*mask(y(:,1) ,x(1,:));
            
            %total force: make vector, sum over vector.
            F_vec = subsref((F).', substruct('()', {':'})).';
            Fx_vec = subsref((Fx).', substruct('()', {':'})).';
            Fy_vec = subsref((Fy).', substruct('()', {':'})).';
            F_tot{current_vid}(frame)=sum(F_vec(~isnan(F_vec)));
            Fx_tot{current_vid}(frame)=sum(abs(Fx_vec(~isnan(Fx_vec))));
            Fy_tot{current_vid}(frame)=sum(abs(Fy_vec(~isnan(Fy_vec))));
        end
        
        %Exclude 4 datapoints on each side of the relaxed frame, assigning the
        %mean value of either ends as bridge signal
        rel_win = [max(1,tfm_piv_user_relax{current_vid}-4) min(size(F_tot{current_vid},2),tfm_piv_user_relax{current_vid}+4)];
        
        F_tot{current_vid}(rel_win(1):rel_win(2))= mean([F_tot{current_vid}(rel_win(1)) F_tot{current_vid}(rel_win(2))]);
        Fx_tot{current_vid}(rel_win(1):rel_win(2))=mean([Fx_tot{current_vid}(rel_win(1)) Fx_tot{current_vid}(rel_win(2))]);
        Fy_tot{current_vid}(rel_win(1):rel_win(2))=mean([Fy_tot{current_vid}(rel_win(1)) Fy_tot{current_vid}(rel_win(2))]);
        
        %find average peaks
        [F_s{current_vid},F_pav{current_vid}] = peak_averaging(dt{current_vid},F_tot{current_vid},tfm_init_user_framerate{current_vid},1);
        [Fx_s{current_vid},Fx_pav{current_vid}] = peak_averaging(dt{current_vid},Fx_tot{current_vid},tfm_init_user_framerate{current_vid},0);
        [Fy_s{current_vid},Fy_pav{current_vid}] = peak_averaging(dt{current_vid},Fy_tot{current_vid},tfm_init_user_framerate{current_vid},0);
    %end
    
    
    %calculate velocity
    %for current_vid=1:tfm_init_user_Nfiles
        %
        Velocity{current_vid}=zeros(1,tfm_init_user_Nframes{current_vid})*NaN;
        for frame=2:tfm_init_user_Nframes{current_vid}-1
            %velocities
            D1=tfm_para_user_d{current_vid}(frame-1);
            D2=tfm_para_user_d{current_vid}(frame+1);
            Velocity{current_vid}(frame)=(D2-D1)/2*tfm_init_user_framerate{current_vid};        %-1 so that it starts at 1
        end
        
        %%denoise
        %Velocity{current_vid}=inpaint_nans(Velocity{current_vid});
        %[Velocity{current_vid}, ~, ~] = wdemeandn(Velocity{current_vid}, 'minimaxi', 's', 'sln', 2, 'db5');
        
        %find average peaks
        %         [V_s{current_vid},V_pav{current_vid}] = peak_averaging(dt{current_vid},Velocity{current_vid},tfm_init_user_framerate{current_vid},0);
        %might need to adjust dt size
    %end
    
    
    %calculate power
    %for current_vid=1:tfm_init_user_Nfiles
        %
        mask=double(tfm_init_user_binary2{current_vid});
        %CHECK HERE
        %mask(mask==0) = NaN
        
        
        
        Power{current_vid}=zeros(1,tfm_init_user_Nframes{current_vid})*NaN;
        for frame=2:tfm_init_user_Nframes{current_vid}-1
            %load spacing
            x=s_x.x(:,:,frame);
            y=s_y.y(:,:,frame);
            %load displacements
            u1=s_fu.fu(:,:,(frame-1)).*mask(y(:,1) ,x(1,:));
            u2=s_fu.fu(:,:,(frame+1)).*mask(y(:,1) ,x(1,:));
            v1=s_fv.fv(:,:,(frame-1)).*mask(y(:,1) ,x(1,:));
            v2=s_fv.fv(:,:,(frame+1)).*mask(y(:,1) ,x(1,:));
            %load tfm data
            Fx=s_Fx.Fx(:,:,frame).*mask(y(:,1) ,x(1,:));
            Fy=s_Fy.Fy(:,:,frame).*mask(y(:,1) ,x(1,:));
            
            du=(u2-u1)/(2*tfm_init_user_framerate{current_vid});
            dv=(v2-v1)/(2*tfm_init_user_framerate{current_vid});
            
            
            %total force: make vector, sum over vector.
            Fx_vec = Fx(:);%subsref((Fx).', substruct('()', {':'}));
            Fy_vec = Fy(:);%subsref((Fy).', substruct('()', {':'}));
            
            du_vec = du(:);
            dv_vec = dv(:);
            
            %power
            P_x = Fx_vec.*du_vec;
            P_y = Fy_vec.*dv_vec;
            
            Power{current_vid}(frame)= .5*sum(P_x+P_y);
            
            %Power{current_vid}(frame)=F_tot{current_vid}(frame)*Velocity{current_vid}(frame);
        end
        %denoise
        %Power{current_vid}=inpaint_nans(Power{current_vid});
        %%[Power{current_vid}, ~, ~] = wden(Power{current_vid}, 'minimaxi', 's', 'sln', 2, 'db5');
        
        %find average peaks
        [P_s{current_vid},P_pav{current_vid}] = peak_averaging(dt{current_vid},Power{current_vid},tfm_init_user_framerate{current_vid},0);
    %end
    
    %get dipole orientations
    %for current_vid=1:tfm_init_user_Nfiles
        % load theta
        s_theta = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_dtheta.mat'],'theta2');
        for frame=1:tfm_init_user_Nframes{current_vid}
            theta{current_vid}(frame)=s_theta.theta2(:,frame);
        end
    %end
    
    %calculate strain energy
    %for current_vid=1:tfm_init_user_Nfiles
        
        %get mask
        mask=double(tfm_init_user_binary2{current_vid});
        %mask(mask==0)=NaN;
        
        s_Trx = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_Trx.mat'],'Trx');
        s_Try = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_Try.mat'],'Try');
        for frame=1:tfm_init_user_Nframes{current_vid}
            %load spacing
            x=s_x.x(:,:,frame);
            y=s_y.y(:,:,frame);
            %load displacements
            u=s_fu.fu(:,:,frame).*mask(y(:,1) ,x(1,:));
            v=s_fv.fv(:,:,frame).*mask(y(:,1) ,x(1,:));
            %load tractions
            Trx=s_Trx.Trx(:,:,frame).*mask(y(:,1) ,x(1,:));
            Try=s_Try.Try(:,:,frame).*mask(y(:,1) ,x(1,:));
            
            Trx_vec = Trx(:);
            Try_vec = Try(:);
            u_vec = u(:)*tfm_init_user_conversion{current_vid}*1e-6;
            v_vec = v(:)*tfm_init_user_conversion{current_vid}*1e-6;
            
            %Tr = sqrt(Trx_vec.^2+Try_vec.^2);
            %ur = sqrt(u_vec.^2+v_vec.^2);
            
            dx = (x(1,3)-x(1,2))*tfm_init_user_conversion{current_vid}*1e-6;
            dy = (y(3,1)-y(2,1))*tfm_init_user_conversion{current_vid}*1e-6;
            
            %U{current_vid}(frame) = .5*sum(Tr.*ur.*(dx*dy));
            U{current_vid}(frame) = .5*sum((Trx_vec.*u_vec+Try_vec.*v_vec)*dx*dy);
            
        end
        %find average peaks
        [U_s{current_vid},U_pav{current_vid}] = peak_averaging(dt{current_vid},U{current_vid},tfm_init_user_framerate{current_vid},0);
    %end
    
    
    %get contractile moments
    %for current_vid=1:tfm_init_user_Nfiles
        %get mask
        mask=double(tfm_init_user_binary2{current_vid});
        
        s_M = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_M.mat'],'M');
        for frame=1:tfm_init_user_Nframes{current_vid}
            Mxx{current_vid}(frame)=s_M.M(1,1,frame);
            Mxy{current_vid}(frame)=s_M.M(1,2,frame);
            Myx{current_vid}(frame)=s_M.M(2,1,frame);
            Myy{current_vid}(frame)=s_M.M(2,2,frame);
            mu{current_vid}(frame)=s_M.M(1,1,frame)+s_M.M(2,2,frame);
            
            %             s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_x_',num2str(frame),'.mat'],'x');
            %             x=s.x;
            %             s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_y_',num2str(frame),'.mat'],'y');
            %             y=s.y;
            %             s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_Fx_',num2str(frame),'.mat'],'Fx');
            %             Fx=s.Fx.*mask(y(:,1) ,x(1,:));
            %             s=load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_Fy_',num2str(frame),'.mat'],'Fy');
            %             Fy=s.Fy.*mask(y(:,1) ,x(1,:));
            %
            %             x = x*tfm_init_user_conversion{current_vid};
            %             y = y*tfm_init_user_conversion{current_vid};
            %             % have to rotate x y to align with Fx Fy
            %             %
            %
            %             % recenter coordinates to contractions
            %             x_cent = (x-center{current_vid}(frame,1))*1e-6;
            %             y_cent = (y-center{current_vid}(frame,2))*1e-6;
            %
            %             %calculate moment arrays
            %             xFx = x_cent.*Fx;
            %             xFy = x_cent.*Fy;
            %             yFx = y_cent.*Fx;
            %             yFy = y_cent.*Fy;
            %
            %             %vectorize
            %             xFx_vec = xFx(:);
            %             xFy_vec = xFy(:);
            %             yFx_vec = yFx(:);
            %             yFy_vec = yFy(:);
            %
            %             M(1,1) = .5*sum(xFx_vec+xFx_vec);
            %             M(1,2) = .5*sum(xFy_vec+yFx_vec);
            %             M(2,1) = .5*sum(yFx_vec+xFy_vec);
            %             M(2,2) = .5*sum(yFy_vec+yFy_vec);
            %             % rotate?
            %
            %             Mxx{current_vid}(frame)=M(1,1);
            %             Mxy{current_vid}(frame)=M(1,2);
            %             Myx{current_vid}(frame)=M(2,1);
            %             Myy{current_vid}(frame)=M(2,2);
            %             mu{current_vid}(frame)=M(1,1)+M(2,2);
            %
        end
        
        %find average peaks
        %[Mxx_s{current_vid},Mxx_pav{current_vid}] = peak_averaging(dt{current_vid},Mxx{current_vid},tfm_init_user_framerate{current_vid},0);
        %[Myy_s{current_vid},Myy_pav{current_vid}] = peak_averaging(dt{current_vid},Myy{current_vid},tfm_init_user_framerate{current_vid},0);
        
        [mu_s{current_vid},mu_pav{current_vid}] = peak_averaging(dt{current_vid},-mu{current_vid},tfm_init_user_framerate{current_vid},0);
    %end
    
    % calculate center of contraction
    %for current_vid=1:tfm_init_user_Nfiles
        
        %get mask
        mask=double(tfm_init_user_binary2{current_vid});
        mask_props=regionprops(tfm_init_user_binary2{current_vid},'centroid');
        centroid=mask_props.Centroid;
        
        for frame=1:tfm_init_user_Nframes{current_vid}
            
            %load positions
            x=s_x.x(:,:,frame);
            y=s_y.y(:,:,frame);
            %load F
            F=s_F.F(:,:,frame).*mask(y(:,1) ,x(1,:));
            
            %vectorize
            x_vec=x(:);
            y_vec=y(:);
            F_vec=F(:);
            
            %calculate center of forces
            x_mean=sum(F_vec.*x_vec)/sum(F_vec);
            y_mean=sum(F_vec.*y_vec)/sum(F_vec);
            
            %subtract centroid
            center{current_vid}(frame,1)=(x_mean-centroid(1))*tfm_init_user_conversion{current_vid}*1e-6;
            center{current_vid}(frame,2)=(-1)*(y_mean-centroid(2))*tfm_init_user_conversion{current_vid}*1e-6;
        end
        
        if ~isnan(mu_pav{current_vid}.n_peaks)
            %Calculate the peak curves for the center of force based on the
            %position of the peaks for mu
            mu_pav{current_vid}.cent_peaks = nan(mu_s{current_vid}.ref_peak_l,mu_pav{current_vid}.n_peaks,2);
            %Calculate the peak curves for the angle of contraction based on the
            %position of the peaks for mu
            mu_pav{current_vid}.theta_peaks = nan(mu_s{current_vid}.ref_peak_l,mu_pav{current_vid}.n_peaks,1);
            %Calculate the mu_pav real peaks in ref_peak_l instead of peak_win_l to
            %avoid overlap
            mu_pav{current_vid}.rpeaks = nan(size(mu_pav{current_vid}.cent_peaks));

            for i = 1:mu_pav{current_vid}.n_peaks
                start_i = max(1,mu_s{current_vid}.pd_xcorr_peaks_lags(i)-floor(mu_s{current_vid}.ref_peak_l/2)+1-floor(mu_s{current_vid}.peak_win_l));
                end_i = min(size(center{current_vid},1),mu_s{current_vid}.pd_xcorr_peaks_lags(i)+ceil(mu_s{current_vid}.ref_peak_l/2)-floor(mu_s{current_vid}.peak_win_l));
                mu_pav{current_vid}.cent_peaks(1:end_i-start_i+1,i,1) = center{current_vid}(start_i:end_i,1);
                mu_pav{current_vid}.cent_peaks(1:end_i-start_i+1,i,2) = center{current_vid}(start_i:end_i,2);
                mu_pav{current_vid}.theta_peaks(1:end_i-start_i+1,i,1) = theta{current_vid}(1,start_i:end_i)';
                mu_pav{current_vid}.rpeaks(1:end_i-start_i+1,i) = mu_s{current_vid}.fsignal(start_i:end_i);
            end

            %calculate the average curve for the center of force
            mu_pav{current_vid}.av_cent(:,1) = mean(mu_pav{current_vid}.cent_peaks(:,:,1),2,'omitnan');
            mu_pav{current_vid}.av_cent_std(:,1) = std(mu_pav{current_vid}.cent_peaks(:,:,1),0,2,'omitnan');
            mu_pav{current_vid}.av_cent(:,2) = mean(mu_pav{current_vid}.cent_peaks(:,:,2),2,'omitnan');
            mu_pav{current_vid}.av_cent_std(:,2) = std(mu_pav{current_vid}.cent_peaks(:,:,2),0,2,'omitnan');

            %calculate the average position of center of force as the averagae
            %of the average for each peak
            mu_pav{current_vid}.av_loc_cent(1) = mean(mean(mu_pav{current_vid}.cent_peaks(:,:,1),1,'omitnan'),'omitnan');
            mu_pav{current_vid}.av_loc_cent_std(1) = sqrt(sum(std(mu_pav{current_vid}.cent_peaks(:,:,1),'omitnan').^2));
            mu_pav{current_vid}.av_loc_cent(2) = mean(mean(mu_pav{current_vid}.cent_peaks(:,:,2),1,'omitnan'),'omitnan');
            mu_pav{current_vid}.av_loc_cent_std(2) = sqrt(sum(std(mu_pav{current_vid}.cent_peaks(:,:,2),'omitnan').^2));

            %calculate the curve when 25% above average mu contraction
            cent_peaks_75 = nan(size(mu_pav{current_vid}.cent_peaks));
            mu_peaks_75 = mu_pav{current_vid}.rpeaks >= 0.25 * mu_pav{current_vid}.peak_amp;
            mu_peaks_75(:,:,2) = mu_peaks_75(:,:,1);
            cent_peaks_75(mu_peaks_75) = mu_pav{current_vid}.cent_peaks(mu_peaks_75);

            %calculate the average position of center of force as the averagae
            %of the average for each peak when 25% above average mu contraction
            mu_pav{current_vid}.av_loc_cent_75(1) = mean(mean(cent_peaks_75(:,:,1),1,'omitnan'),'omitnan');
            mu_pav{current_vid}.av_loc_cent_75_std(1) = sqrt(sum(std(cent_peaks_75(:,:,1),0,1,'omitnan').^2));
            mu_pav{current_vid}.av_loc_cent_75(2) = mean(mean(cent_peaks_75(:,:,1),2,'omitnan'),'omitnan');
            mu_pav{current_vid}.av_loc_cent_75_std(2) = sqrt(sum(std(cent_peaks_75(:,:,2),0,1,'omitnan').^2));

            %calculate the average curve for the contraction angle
            mu_pav{current_vid}.av_theta(:,1) = mean(mu_pav{current_vid}.theta_peaks(:,:,1),2,'omitnan');
            mu_pav{current_vid}.av_theta_std(:,1) = std(mu_pav{current_vid}.theta_peaks(:,:,1),0,2,'omitnan');

            %calculate the average position of contraction angle as the averagae
            %of the average for each peak
            mu_pav{current_vid}.av_loc_theta(1) = mean(mean(mu_pav{current_vid}.theta_peaks(:,:,1),1,'omitnan'),'omitnan');
            mu_pav{current_vid}.av_loc_theta_std(1) = sqrt(sum(std(mu_pav{current_vid}.theta_peaks(:,:,1),'omitnan').^2));

            %calculate the contraction angle curve when 25% above average mu contraction
            theta_peaks_75 = nan(size(mu_pav{current_vid}.theta_peaks));
            mu_peaks_75 = mu_pav{current_vid}.rpeaks >= 0.25 * mu_pav{current_vid}.peak_amp;
            theta_peaks_75(mu_peaks_75) = mu_pav{current_vid}.theta_peaks(mu_peaks_75);

            %calculate the average position of contraction angle as the averagae
            %of the average for each peak when 25% above average mu contraction
            mu_pav{current_vid}.av_loc_theta_75(1) = mean(mean(theta_peaks_75(:,:,1),1,'omitnan'),'omitnan');
            mu_pav{current_vid}.av_loc_theta_75_std(1) = sqrt(sum(std(theta_peaks_75(:,:,1),0,1,'omitnan').^2));
        
        else
            mu_pav{current_vid}.av_cent = [NaN NaN];
            mu_pav{current_vid}.av_cent_std = [NaN NaN];
            mu_pav{current_vid}.av_theta(:,1)= NaN;
            mu_pav{current_vid}.av_theta_std(:,1) = NaN;
            mu_pav{current_vid}.av_loc_theta = NaN;
            mu_pav{current_vid}.av_loc_theta_std = NaN;
            mu_pav{current_vid}.av_loc_theta_75 = NaN;
            mu_pav{current_vid}.av_loc_theta_75_std = NaN;
            mu_pav{current_vid}.av_loc_cent = [NaN NaN];
            mu_pav{current_vid}.av_loc_cent_std = [NaN NaN];
            mu_pav{current_vid}.av_loc_cent_75 = [NaN NaN];
            mu_pav{current_vid}.av_loc_cent_75_std = [NaN NaN];
        end
    %end
    
    
    %guess peaks
    %for current_vid=1:tfm_init_user_Nfiles
        %guess max/min. displ.
        [dmax{current_vid}, dmin{current_vid}] = peakdet(tfm_para_user_d{current_vid}, 0.5*(max(tfm_para_user_d{current_vid})-min(tfm_para_user_d{current_vid})));
        dt{current_vid}=(1:length(tfm_para_user_d{current_vid}))/tfm_init_user_framerate{current_vid};
        %veloc.
        [vmax{current_vid}, vmin{current_vid}] = peakdet(Velocity{current_vid}, 0.5*(max(Velocity{current_vid})-min(Velocity{current_vid})));
        if isempty(dmax{current_vid})
            dmax{current_vid}(:,1)=NaN; dmax{current_vid}(:,2)=NaN;
        end
        if isempty(dmin{current_vid})
            dmin{current_vid}(:,1)=NaN; dmin{current_vid}(:,2)=NaN;
        end
        if isempty(vmax{current_vid})
            vmax{current_vid}(:,1)=NaN; vmax{current_vid}(:,2)=NaN;
        end
        if isempty(vmin{current_vid})
            vmin{current_vid}(:,1)=NaN; vmin{current_vid}(:,2)=NaN;
        end
        
        %         % use disp and vel points for force and power
        %         Fxmax{current_vid}(:,1) = dmax{current_vid}(:,1);
        %         Fxmax{current_vid}(:,2) = Fx_tot{current_vid}(dmax{current_vid}(:,1));
        %         Fxmin{current_vid}(:,1) = dmin{current_vid}(:,1);
        %         Fxmin{current_vid}(:,2) = Fx_tot{current_vid}(dmin{current_vid}(:,1));
        %
        %         Fymax{current_vid}(:,1) = dmax{current_vid}(:,1);
        %         Fymax{current_vid}(:,2) = Fy_tot{current_vid}(dmax{current_vid}(:,1));
        %         Fymin{current_vid}(:,1) = dmin{current_vid}(:,1);
        %         Fymin{current_vid}(:,2) = Fy_tot{current_vid}(dmin{current_vid}(:,1));
        %
        %         Fmax{current_vid}(:,1) = dmax{current_vid}(:,1);
        %         Fmax{current_vid}(:,2) = F_tot{current_vid}(dmax{current_vid}(:,1));
        %         Fmin{current_vid}(:,1) = dmin{current_vid}(:,1);
        %         Fmin{current_vid}(:,2) = F_tot{current_vid}(dmin{current_vid}(:,1));
        
        
        % old peakdet method
        %F.
        [Fmax{current_vid}, Fmin{current_vid}] = peakdet(F_tot{current_vid}, 0.5*(max(F_tot{current_vid})-min(F_tot{current_vid})));
        
        %check for max peaks
        if ~isempty(Fmax{current_vid})
            Fxmax{current_vid}(:,1) = Fmax{current_vid}(:,1);
            Fxmax{current_vid}(:,2) = Fx_tot{current_vid}(Fmax{current_vid}(:,1));
            Fymax{current_vid}(:,1) = Fmax{current_vid}(:,1);
            Fymax{current_vid}(:,2) = Fy_tot{current_vid}(Fmax{current_vid}(:,1));
        else
            Fxmax{current_vid}(:,1) = NaN;
            Fxmax{current_vid}(:,2) = NaN;
            Fymax{current_vid}(:,1) = NaN;
            Fymax{current_vid}(:,2) = NaN;
        end
        %check for min peaks
        if ~isempty(Fmin{current_vid})
            Fxmin{current_vid}(:,1) = Fmin{current_vid}(:,1);
            Fxmin{current_vid}(:,2) = Fx_tot{current_vid}(Fmin{current_vid}(:,1));
            Fymin{current_vid}(:,1) = Fmin{current_vid}(:,1);
            Fymin{current_vid}(:,2) = Fy_tot{current_vid}(Fmin{current_vid}(:,1));
        else
            Fxmin{current_vid}(:,1) = NaN;
            Fxmin{current_vid}(:,2) = NaN;
            Fymin{current_vid}(:,1) = NaN;
            Fymin{current_vid}(:,2) = NaN;
        end
        
        %Fx.
        %[Fxmax{current_vid}, Fxmin{current_vid}] = peakdet(Fx_tot{current_vid}, 0.5*(max(Fx_tot{current_vid})-min(Fx_tot{current_vid})));
        %Fy.
        %[Fymax{current_vid}, Fymin{current_vid}] = peakdet(Fy_tot{current_vid}, 0.5*(max(Fy_tot{current_vid})-min(Fy_tot{current_vid})));
        %P.
        [Pmax{current_vid}, Pmin{current_vid}] = peakdet(Power{current_vid}, 0.5*(max(Power{current_vid})-min(Power{current_vid})));
        
        if isempty(Fxmax{current_vid})
            Fxmax{current_vid}(:,1)=NaN; Fxmax{current_vid}(:,2)=NaN;
        end
        if isempty(Fxmin{current_vid})
            Fxmin{current_vid}(:,1)=NaN; Fxmin{current_vid}(:,2)=NaN;
        end
        if isempty(Fymax{current_vid})
            Fymax{current_vid}(:,1)=NaN; Fymax{current_vid}(:,2)=NaN;
        end
        if isempty(Fymin{current_vid})
            Fymin{current_vid}(:,1)=NaN; Fymin{current_vid}(:,2)=NaN;
        end
        if isempty(Fmax{current_vid})
            Fmax{current_vid}(:,1)=NaN; Fmax{current_vid}(:,2)=NaN;
        end
        if isempty(Fmin{current_vid})
            Fmin{current_vid}(:,1)=NaN; Fmin{current_vid}(:,2)=NaN;
        end
        if isempty(Pmax{current_vid})
            Pmax{current_vid}(:,1)=NaN; Pmax{current_vid}(:,2)=NaN;
        end
        if isempty(Pmin{current_vid})
            Pmin{current_vid}(:,1)=NaN; Pmin{current_vid}(:,2)=NaN;
        end
        
        %strain peaks
        [Umax{current_vid},Umin{current_vid}]=peakdet(U{current_vid},0.5*(max(U{current_vid})-min(U{current_vid})));
        if isempty(Umax{current_vid})
            Umax{current_vid}(:,1)=NaN; Umax{current_vid}(:,2)=NaN;
        end
        if isempty(Umin{current_vid})
            Umin{current_vid}(:,1)=NaN; Umin{current_vid}(:,2)=NaN;
        end
        
        %moment peaks
        [Mxx_max{current_vid},Mxx_min{current_vid}]=peakdet(Mxx{current_vid},abs(0.5*(max(Mxx{current_vid})-min(Mxx{current_vid}))));
        
        if ~isempty(Mxx_max{current_vid})
            Myy_max{current_vid}(:,1) = Mxx_max{current_vid}(:,1);
            Myy_max{current_vid}(:,2) = Myy{current_vid}(Mxx_max{current_vid}(:,1));
            Mxy_max{current_vid}(:,1) = Mxx_max{current_vid}(:,1);
            Mxy_max{current_vid}(:,2) = Mxy{current_vid}(Mxx_max{current_vid}(:,1));
            mu_max{current_vid}(:,1) = Mxx_max{current_vid}(:,1);
            mu_max{current_vid}(:,2) = mu{current_vid}(Mxx_max{current_vid}(:,1));
        else
            Mxx_max{current_vid}(:,1)=NaN;
            Mxx_max{current_vid}(:,2)=NaN;
            Myy_max{current_vid}(:,1) = NaN;
            Myy_max{current_vid}(:,2) = NaN;
            Mxy_max{current_vid}(:,1) = NaN;
            Mxy_max{current_vid}(:,2) = NaN;
            mu_max{current_vid}(:,1) = NaN;
            mu_max{current_vid}(:,2) = NaN;
        end
        if ~isempty(Mxx_min{current_vid})
            Myy_min{current_vid}(:,1) = Mxx_min{current_vid}(:,1);
            Myy_min{current_vid}(:,2) = Myy{current_vid}(Mxx_min{current_vid}(:,1));
            Mxy_min{current_vid}(:,1) = Mxx_min{current_vid}(:,1);
            Mxy_min{current_vid}(:,2) = Mxy{current_vid}(Mxx_min{current_vid}(:,1));
            mu_min{current_vid}(:,1) = Mxx_min{current_vid}(:,1);
            mu_min{current_vid}(:,2) = mu{current_vid}(Mxx_min{current_vid}(:,1));
        else
            Mxx_min{current_vid}(:,1)=NaN;
            Mxx_min{current_vid}(:,2)=NaN;
            Myy_min{current_vid}(:,1) = NaN;
            Myy_min{current_vid}(:,2) = NaN;
            Mxy_min{current_vid}(:,1) = NaN;
            Mxy_min{current_vid}(:,2) = NaN;
            mu_min{current_vid}(:,1) = NaN;
            mu_min{current_vid}(:,2) = NaN;
        end
        
    %end
    
    
  
    %frequency
    
    %for current_vid=1:tfm_init_user_Nfiles
        %dt, tfm_para_user_d{current_vid}
        Nsamps = length(dt{current_vid});
        n = 2^nextpow2(Nsamps);
        Fs=tfm_init_user_framerate{current_vid};
        %t = (1/Fs)*(1:Nsamps);
        %Do Fourier Transform
        y=tfm_para_user_d{current_vid};
        y(isnan(y))=0;
        y_fft0 = fft(y,n);            %Retain Magnitude
        y_fft{current_vid} = abs(y_fft0(1:n/2))/n;      %Discard Half of Points
        freq{current_vid} = Fs*(0:n/2-1)/n;   %Prepare freq data for plot
        %find primary frequency peak
        %[freq_pk{current_vid},loc{current_vid}]=max(y_fft{current_vid}(2:min([15,size(y_fft{current_vid},2)])));
        %tfm_para_user_para_freq{current_vid}=freq{current_vid}(loc{current_vid}+1);
        %tfm_para_user_para_freqy{current_vid}=freq_pk{current_vid};
        [freq_pk{current_vid},loc{current_vid},~,p]=findpeaks(y_fft{current_vid},'SortStr','descend','NPeaks',1);
        mp_peak_num = find(p==max(p));
        tfm_para_user_para_freq{current_vid}=freq{current_vid}(loc{current_vid}(mp_peak_num));
        tfm_para_user_para_freqy{current_vid}=freq_pk{current_vid}(mp_peak_num);
    
    end
    
    % calculate contraction times
    for current_vid = 1:tfm_init_user_Nfiles
        %init
        [t_max,I]=sort(vmax{current_vid}(:,1));
        [t_min,J]=sort(vmin{current_vid}(:,1));
        
        %index corresponding v peaks
        tlength = min(size(t_max,1), size(t_min,1));
        for i=1:tlength
            v_max(i,1)=t_max(i);
            v_max(i,2)=vmax{current_vid}(I(i),2);
            v_min(i,1)=t_min(i);
            v_min(i,2)=vmin{current_vid}(J(i),2);
        end
        dtcontr=zeros(1,size(t_max,1));
        tcontr=zeros(size(t_max,1),4);
        
        %get contraction times
        for i=1:tlength
            %calculate dt for every min/max pair
            ti=t_max(i)/tfm_init_user_framerate{current_vid};
            tf=t_min(i)/tfm_init_user_framerate{current_vid};
            d_t=tf-ti;
            %save peaks
            tcontr(i,1)=ti;
            tcontr(i,2)=tf;
            tcontr(i,3)=v_max(i,2);
            tcontr(i,4)=v_min(i,2);
            %save dt
            dtcontr(i)=d_t;
            
        end
        
        %save new pt vector
        tfm_para_user_tcontr{current_vid}=tcontr;
        tfm_para_user_para_tcontr{current_vid}=mean(dtcontr,'omitnan');
        
    end
    
    
    %plot 1st displ. in axes
    reset(h_para.axes_disp)
    axes(h_para.axes_disp)
    plot(dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    plot(dt{tfm_para_user_counter},tfm_para_user_disp_l*ones(size(dt{tfm_para_user_counter},2),1)',':m'), hold on;
    text(dt{tfm_para_user_counter}(1),tfm_para_user_disp_l,[num2str(tfm_para_user_disp_l) '[m]'],'FontSize',10);
    plot(dmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},dmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(dmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},dmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    %JFM
    %set(gca, 'YTick', []);
    ylim([0 5e-8]);
    
    %     %displ. in double peak
    %     reset(h_para.axes_dp2)
    %     axes(h_para.axes_dp2)
    %     plot(dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    %     set(gca, 'XTick', []);
    %     set(gca, 'YTick', []);
    
    %plot 1st velocity and contraction times in axes
    reset(h_para.axes_vel)
    axes(h_para.axes_vel)
    plot(dt{tfm_para_user_counter},zeros(1,length(dt{tfm_para_user_counter})),'--k'), hold on;
    plot(dt{tfm_para_user_counter},Velocity{tfm_para_user_counter},'-b'), hold on;
    plot(vmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},vmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(vmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},vmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    for i = 1:length(tfm_para_user_tcontr{tfm_para_user_counter}(:,1))
        plot(linspace(tfm_para_user_tcontr{tfm_para_user_counter}(i,1),tfm_para_user_tcontr{tfm_para_user_counter}(i,2),2),linspace(0,0,2),'r','LineWidth',5);
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    if get(h_para.radiobutton_forcex,'Value')
        %plot 1st forcex. in axes
        reset(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(dt{tfm_para_user_counter},Fx_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(Fxmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fxmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        plot(Fxmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fxmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_forcey,'Value')
        %plot 1st forcey. in axes
        reset(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(dt{tfm_para_user_counter},Fy_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(Fymin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fymin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        plot(Fymax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fymax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_forcetot,'Value')
        %plot 1st force. in axes
        reset(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(dt{tfm_para_user_counter},F_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(Fmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        plot(Fmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    %plot 1st power. in axes
    reset(h_para.axes_power)
    axes(h_para.axes_power)
    plot(dt{tfm_para_user_counter},zeros(1,length(dt{tfm_para_user_counter})),'--k'), hold on;
    plot(dt{tfm_para_user_counter},Power{tfm_para_user_counter}*1e12,'-b'), hold on;
    plot(Pmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Pmin{tfm_para_user_counter}(:,2)*1e12,'.r','MarkerSize',10), hold on;
    plot(Pmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Pmax{tfm_para_user_counter}(:,2)*1e12,'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %     %plot contraction times in axes
    %     reset(h_para.axes_contr)
    %     axes(h_para.axes_contr)
    %     plot(dt{tfm_para_user_counter},Velocity{tfm_para_user_counter},'-b'), hold on;
    %     for i = 1:length(tfm_para_user_tcontr{tfm_para_user_counter}(:,1))
    %         plot(linspace(tfm_para_user_tcontr{tfm_para_user_counter}(i,1),tfm_para_user_tcontr{tfm_para_user_counter}(i,2),2),linspace(0,0,2),'r','LineWidth',5);
    %     end
    %     set(gca, 'XTick', []);
    %     set(gca, 'YTick', []);
    
    %freq.
    if get(h_para.radiobutton_fft,'Value')
        %make unwanted buttons invisible
        set(h_para.button_freq_add,'Visible','off');
        set(h_para.button_freq_remove,'Visible','off');
        set(h_para.button_freq_clearall,'Visible','off');
        %enable wanted button
        set(h_para.button_freq_addfft,'Visible','on');
        %plot frequency. in axes
        reset(h_para.axes_freq)
        axes(h_para.axes_freq)
        plot(freq{tfm_para_user_counter},y_fft{tfm_para_user_counter},'-b'), hold on;
        plot(freq{tfm_para_user_counter}(loc{tfm_para_user_counter}),freq_pk{tfm_para_user_counter},'.g','MarkerSize',10);
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'XLim', [0 5]);% freq{tfm_para_user_counter}(end)]);
        %set(gca, 'YLim', [0 max(y_fft{tfm_para_user_counter})]);
    elseif get(h_para.radiobutton_pick,'Value')
        %make  buttons visible
        set(h_para.button_freq_add,'Visible','on');
        set(h_para.button_freq_remove,'Visible','on');
        set(h_para.button_freq_clearall,'Visible','on');
        %disable unwanted button
        set(h_para.button_freq_addfft,'Visible','off');
        %plot displ. in axes
        reset(h_para.axes_freq)
        axes(h_para.axes_freq)
        plot(dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_autocorr,'Value')
        %make unwanted buttons invisible
        set(h_para.button_freq_add,'Visible','off');
        set(h_para.button_freq_remove,'Visible','off');
        set(h_para.button_freq_clearall,'Visible','off');
        %disable unwanted button
        set(h_para.button_freq_addfft,'Visible','off');
        %plot displ. in axes
        reset(h_para.axes_freq)
        axes(h_para.axes_freq)
        plot(d_s{tfm_para_user_counter}.signal_t,d_s{tfm_para_user_counter}.autocorr_signal,'-m'), hold on;
        plot(tfm_para_user_d_s{tfm_para_user_counter}.autocorr_peaks_lags/tfm_para_user_d_s{tfm_para_user_counter}.framerate,tfm_para_user_d_s{tfm_para_user_counter}.autocorr_peaks,'ob','MarkerSize',3); hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    %plot strain energy
    reset(h_para.axes_strain)
    axes(h_para.axes_strain)
    plot(dt{tfm_para_user_counter},U{tfm_para_user_counter},'-b'); hold on;
    plot(Umin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Umin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(Umax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Umax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %plot contractile moment
    if get(h_para.radiobutton_Mxx,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(dt{tfm_para_user_counter},zeros(1,length(dt{tfm_para_user_counter})),'--k'), hold on;
        plot(dt{tfm_para_user_counter},Mxx{tfm_para_user_counter},'-b')
        plot(Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_Myy,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(dt{tfm_para_user_counter},zeros(1,length(dt{tfm_para_user_counter})),'--k'), hold on;
        plot(dt{tfm_para_user_counter},Myy{tfm_para_user_counter},'-b')
        plot(Myy_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Myy_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(Myy_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Myy_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_mu,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(dt{tfm_para_user_counter},zeros(1,length(dt{tfm_para_user_counter})),'--k'), hold on;
        plot(dt{tfm_para_user_counter},mu{tfm_para_user_counter},'-b')
        plot(mu_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},mu_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(mu_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},mu_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    % sort center, orient by displacement
    [d_sort,di] = sort(tfm_para_user_d{tfm_para_user_counter});
    center_sort = center{tfm_para_user_counter}(di,:);
    center_sort(isnan(center_sort))=0;
    theta_sort = theta{tfm_para_user_counter}(di);
    Mxx_sort = Mxx{tfm_para_user_counter}(di);
    
    if get(h_para.radiobutton_center,'Value')
        %plot center of contraction
        reset(h_para.axes_orient)
        axes(h_para.axes_orient)
        [theta_center,r_center] = cart2pol(center_sort(:,1),center_sort(:,2));
        polarscatter(theta_center,r_center,10,d_sort,'filled');
        %set(gca, 'RTickLabel', []);
        set(gca, 'ThetaTickLabel', []);
        colorbar('southoutside','TickLabels',[])
        rlim([0 5e-6]);
        rticks([2.5e-6 5e-6]);
        rticklabels({'r = 2.5e-6 [m]',''});
        
        % %         hold on
        %         [xi,yi] = meshgrid(linspace(min(center_sort(:,1)),max(center_sort(:,1)),100), linspace(min(center_sort(:,2)),max(center_sort(:,2)),100));
        %         zi = griddata(center_sort(:,1),center_sort(:,2),d_sort,xi,yi);
        %         contour(xi,yi,zi,[.2*max(d_sort) 0.5*max(d_sort) .8*max(d_sort)]);
        %         hold on
        %         scatter(center_sort(:,1),center_sort(:,2),18,d_sort)
        %         set(gca, 'XTickLabel', []);
        %         set(gca, 'YTickLabel', []);
        
    elseif get(h_para.radiobutton_orient,'Value')
        %plot traction orientation
        reset(h_para.axes_orient)
        axes(h_para.axes_orient)
        polarscatter(theta_sort.*(pi/180),Mxx_sort,10,d_sort,'filled');
        set(gca, 'RTickLabel', []);
        set(gca, 'ThetaTickLabel', []);
        colorbar('southoutside','TickLabels',[])
    end
    
    %plot peak averaging results
    %displacement
    reset(h_para.axes_disp_autocor)
    axes(h_para.axes_disp_autocor)
    if ~isnan(d_pav{tfm_para_user_counter}.n_peaks)
        plot(d_pav{tfm_para_user_counter}.peak_wins_t,d_pav{tfm_para_user_counter}.av_peak), hold on;
        area(d_pav{tfm_para_user_counter}.t_peak,d_pav{tfm_para_user_counter}.av_peak+d_pav{tfm_para_user_counter}.av_peak_std,min(d_pav{tfm_para_user_counter}.av_peak-d_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[0.8 0.8 0.8],'FaceAlpha',0.5,'EdgeColor','none');
        area(d_pav{tfm_para_user_counter}.t_peak,d_pav{tfm_para_user_counter}.av_peak-d_pav{tfm_para_user_counter}.av_peak_std,min(d_pav{tfm_para_user_counter}.av_peak-d_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[1 1 1],'FaceAlpha',1,'EdgeColor','none');
        %     area(d_pav{tfm_para_user_counter}.peak_wins_t(min(d_pav{tfm_para_user_counter}.peak_min_t):d_pav{tfm_para_user_counter}.peak_max_t)',d_pav{tfm_para_user_counter}.av_peak(min(d_pav{tfm_para_user_counter}.peak_min_t):d_pav{tfm_para_user_counter}.peak_max_t),d_pav{tfm_para_user_counter}.peak_basel,'FaceColor',[255,74,0]/255,'FaceAlpha',0.5,'EdgeColor','none');
        %     area(d_pav{tfm_para_user_counter}.peak_wins_t(d_pav{tfm_para_user_counter}.peak_max_t:max(d_pav{tfm_para_user_counter}.peak_min_t))',d_pav{tfm_para_user_counter}.av_peak(d_pav{tfm_para_user_counter}.peak_max_t:max(d_pav{tfm_para_user_counter}.peak_min_t)),d_pav{tfm_para_user_counter}.peak_basel,'FaceColor',[64,166,41]/256,'FaceAlpha',0.5,'EdgeColor','none');
        plot([d_pav{tfm_para_user_counter}.peak_max_t-floor(floor(d_s{tfm_para_user_counter}.peak_win_l/4)):d_pav{tfm_para_user_counter}.peak_max_t+floor(d_s{tfm_para_user_counter}.peak_win_l/4)]/tfm_init_user_framerate{tfm_para_user_counter},d_pav{tfm_para_user_counter}.peak_max*ones(1,(d_pav{tfm_para_user_counter}.peak_max_t+floor(d_s{tfm_para_user_counter}.peak_win_l/4))-(d_pav{tfm_para_user_counter}.peak_max_t-floor(floor(d_s{tfm_para_user_counter}.peak_win_l/4)))+1),':k');
        plot(d_pav{tfm_para_user_counter}.peak_wins_t,d_pav{tfm_para_user_counter}.peak_basel*ones(1,d_s{tfm_para_user_counter}.peak_win_l),':k');
        plot(d_pav{tfm_para_user_counter}.d_peak_max_t/tfm_init_user_framerate{tfm_para_user_counter},d_pav{tfm_para_user_counter}.av_peak(d_pav{tfm_para_user_counter}.d_peak_max_t),'^k','MarkerSize',5);
        plot(d_pav{tfm_para_user_counter}.d_peak_min_t/tfm_init_user_framerate{tfm_para_user_counter},d_pav{tfm_para_user_counter}.av_peak(d_pav{tfm_para_user_counter}.d_peak_min_t),'vk','MarkerSize',5);
        plot([d_pav{tfm_para_user_counter}.d_peak_max_t-floor(d_s{tfm_para_user_counter}.peak_win_l/6):d_pav{tfm_para_user_counter}.d_peak_max_t+floor(d_s{tfm_para_user_counter}.peak_win_l/6)]/tfm_init_user_framerate{tfm_para_user_counter},d_pav{tfm_para_user_counter}.d_peak_max*d_pav{tfm_para_user_counter}.d_t_peak(1)*[-floor(d_s{tfm_para_user_counter}.peak_win_l/6):+floor(d_s{tfm_para_user_counter}.peak_win_l/6)]+d_pav{tfm_para_user_counter}.av_peak(d_pav{tfm_para_user_counter}.d_peak_max_t),':k');
        plot([d_pav{tfm_para_user_counter}.d_peak_min_t-floor(d_s{tfm_para_user_counter}.peak_win_l/6):d_pav{tfm_para_user_counter}.d_peak_min_t+floor(d_s{tfm_para_user_counter}.peak_win_l/6)]/tfm_init_user_framerate{tfm_para_user_counter},d_pav{tfm_para_user_counter}.d_peak_min*d_pav{tfm_para_user_counter}.d_t_peak(1)*[-floor(d_s{tfm_para_user_counter}.peak_win_l/6):+floor(d_s{tfm_para_user_counter}.peak_win_l/6)]+d_pav{tfm_para_user_counter}.av_peak(d_pav{tfm_para_user_counter}.d_peak_min_t),':k');
        set(gca,'XLim',[0 d_pav{tfm_para_user_counter}.peak_wins_t(end)]);
        if ~isnan(d_pav{tfm_para_user_counter}.peak_max)
            set(gca,'YLim',[-1.1*d_pav{tfm_para_user_counter}.peak_max 1.1*d_pav{tfm_para_user_counter}.peak_max]);
        end
        yyaxis right
        plot(d_pav{tfm_para_user_counter}.peak_wins_t(1:end-1),d_pav{tfm_para_user_counter}.d_av_peak ,'--');
        absmax = max(abs([d_pav{tfm_para_user_counter}.d_peak_max, d_pav{tfm_para_user_counter}.d_peak_min]));
        if ~isnan(absmax)
            set(gca,'YLim',[-1.1*absmax 1.1*absmax]);
        end
    else
        plot(d_pav{tfm_para_user_counter}.peak_wins_t,d_pav{tfm_para_user_counter}.av_peak), hold on;
    end
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    
    
    %force
    reset(h_para.axes_force_autocor)
    axes(h_para.axes_force_autocor)
    if ~isnan(F_pav{tfm_para_user_counter}.n_peaks)
        plot(F_pav{tfm_para_user_counter}.peak_wins_t,F_pav{tfm_para_user_counter}.av_peak), hold on;
        area(F_pav{tfm_para_user_counter}.t_peak,F_pav{tfm_para_user_counter}.av_peak+F_pav{tfm_para_user_counter}.av_peak_std,min(F_pav{tfm_para_user_counter}.av_peak-F_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[0.8 0.8 0.8],'FaceAlpha',0.5,'EdgeColor','none');
        area(F_pav{tfm_para_user_counter}.t_peak,F_pav{tfm_para_user_counter}.av_peak-F_pav{tfm_para_user_counter}.av_peak_std,min(F_pav{tfm_para_user_counter}.av_peak-F_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[1 1 1],'FaceAlpha',1,'EdgeColor','none');
        %     plot(F_pav{tfm_para_user_counter}.peak_wins_t(1:end-1),F_pav{tfm_para_user_counter}.d_av_peak ,'--');
        area(F_pav{tfm_para_user_counter}.peak_wins_t(min(F_pav{tfm_para_user_counter}.peak_min_t):F_pav{tfm_para_user_counter}.peak_max_t)',F_pav{tfm_para_user_counter}.av_peak(min(F_pav{tfm_para_user_counter}.peak_min_t):F_pav{tfm_para_user_counter}.peak_max_t),F_pav{tfm_para_user_counter}.peak_basel,'FaceColor',[.9892 .8136 .1885],'FaceAlpha',0.5,'EdgeColor','none');
        area(F_pav{tfm_para_user_counter}.peak_wins_t(F_pav{tfm_para_user_counter}.peak_max_t:max(F_pav{tfm_para_user_counter}.peak_min_t))',F_pav{tfm_para_user_counter}.av_peak(F_pav{tfm_para_user_counter}.peak_max_t:max(F_pav{tfm_para_user_counter}.peak_min_t)),F_pav{tfm_para_user_counter}.peak_basel,'FaceColor',[.244 .4358 .9988],'FaceAlpha',0.5,'EdgeColor','none');
        %     plot(F_pav{tfm_para_user_counter}.d_peak_max_t/tfm_init_user_framerate{tfm_para_user_counter},F_pav{tfm_para_user_counter}.av_peak(F_pav{tfm_para_user_counter}.d_peak_max_t),'^k','MarkerSize',5);
        %     plot(F_pav{tfm_para_user_counter}.d_peak_min_t/tfm_init_user_framerate{tfm_para_user_counter},F_pav{tfm_para_user_counter}.av_peak(F_pav{tfm_para_user_counter}.d_peak_min_t),'vk','MarkerSize',5);
        %     plot([F_pav{tfm_para_user_counter}.peak_max_t-floor(floor(F_s{tfm_para_user_counter}.peak_win_l/4)):F_pav{tfm_para_user_counter}.peak_max_t+floor(F_s{tfm_para_user_counter}.peak_win_l/4)]/tfm_init_user_framerate{tfm_para_user_counter},F_pav{tfm_para_user_counter}.peak_max*ones(1,(F_pav{tfm_para_user_counter}.peak_max_t+floor(F_s{tfm_para_user_counter}.peak_win_l/4))-(F_pav{tfm_para_user_counter}.peak_max_t-floor(floor(F_s{tfm_para_user_counter}.peak_win_l/4)))+1),':k');
        %     plot(F_pav{tfm_para_user_counter}.peak_wins_t,F_pav{tfm_para_user_counter}.peak_basel*ones(1,F_s{tfm_para_user_counter}.peak_win_l),':k');
        %     plot([F_pav{tfm_para_user_counter}.d_peak_max_t-floor(F_s{tfm_para_user_counter}.peak_win_l/4):F_pav{tfm_para_user_counter}.d_peak_max_t+floor(F_s{tfm_para_user_counter}.peak_win_l/4)]/tfm_init_user_framerate{tfm_para_user_counter},F_pav{tfm_para_user_counter}.d_peak_max*[-floor(F_s{tfm_para_user_counter}.peak_win_l/4):+floor(F_s{tfm_para_user_counter}.peak_win_l/4)]+F_pav{tfm_para_user_counter}.av_peak(F_pav{tfm_para_user_counter}.d_peak_max_t),':k');
        %     plot([F_pav{tfm_para_user_counter}.d_peak_min_t-floor(F_s{tfm_para_user_counter}.peak_win_l/4):F_pav{tfm_para_user_counter}.d_peak_min_t+floor(F_s{tfm_para_user_counter}.peak_win_l/4)]/tfm_init_user_framerate{tfm_para_user_counter},F_pav{tfm_para_user_counter}.d_peak_min*[-floor(F_s{tfm_para_user_counter}.peak_win_l/4):+floor(F_s{tfm_para_user_counter}.peak_win_l/4)]+F_pav{tfm_para_user_counter}.av_peak(F_pav{tfm_para_user_counter}.d_peak_min_t),':k');
        
        set(gca,'XLim',[0 F_pav{tfm_para_user_counter}.peak_wins_t(end)]);
        set(gca,'YLim',[-.1*F_pav{tfm_para_user_counter}.peak_max 1.1*F_pav{tfm_para_user_counter}.peak_max]);
    else
        plot(F_pav{tfm_para_user_counter}.peak_wins_t,F_pav{tfm_para_user_counter}.av_peak), hold on;
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    
    
    %preview traction animation
    set(h_para.button_traction_anim,'string',['<html><img src="file:',tfm_init_user_pathnamestack{1,tfm_para_user_counter},tfm_init_user_filenamestack{1,tfm_para_user_counter},filesep,'heatmap_anim.gif"/></html>']);
    
    
    %calculate para and display them.
    
    %initial val. for contaction time
    t_init(:,1)=NaN;
    t_init(:,2)=NaN;
    t_init(:,3)=NaN;
    t_init(:,4)=NaN;
    
    %initial val. for dp time
    t_dp(:,1)=NaN;
    t_dp(:,2)=NaN;
    t_dp(:,3)=NaN;
    t_dp(:,4)=NaN;
    
    %initialize
    tfm_para_user_para_Deltad=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_DeltaFx=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_DeltaFy=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_DeltaF=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_vcontr=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_vrelax=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_Pcontr=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_Prelax=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_U=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_Mxx=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_Myy=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_Mxy=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_mu=cell(1,tfm_init_user_Nfiles);
    %     tfm_para_user_para_tcontr=cell(1,tfm_init_user_Nfiles);
    %     tfm_para_user_tcontr=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_tdp=cell(1,tfm_init_user_Nfiles);
    %     tfm_para_user_para_freq=cell(1,tfm_init_user_Nfiles);
    %     tfm_para_user_para_freqy=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_tdp=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_ratiop=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_ratiodp=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_freq2=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_freq2=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_para_tagdp=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_discard_tag=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_dbl_tag=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_drift_tag=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_other_tag=cell(1,tfm_init_user_Nfiles);
    tfm_para_user_other_comments=cell(1,tfm_init_user_Nfiles);
    
    %para
    for current_vid=1:tfm_init_user_Nfiles
        tfm_para_user_para_Deltad{current_vid}=mean(dmax{current_vid}(:,2),'omitnan')-mean(dmin{current_vid}(:,2),'omitnan');
        tfm_para_user_para_DeltaFx{current_vid}=mean(Fxmax{current_vid}(:,2),'omitnan')-mean(Fxmin{current_vid}(:,2),'omitnan');
        tfm_para_user_para_DeltaFy{current_vid}=mean(Fymax{current_vid}(:,2),'omitnan')-mean(Fymin{current_vid}(:,2),'omitnan');
        tfm_para_user_para_DeltaF{current_vid}=mean(Fmax{current_vid}(:,2),'omitnan')-mean(Fmin{current_vid}(:,2),'omitnan');
        tfm_para_user_para_vcontr{current_vid}=mean(vmax{current_vid}(:,2),'omitnan');
        tfm_para_user_para_vrelax{current_vid}=mean(vmin{current_vid}(:,2),'omitnan');
        tfm_para_user_para_Pcontr{current_vid}=mean(Pmax{current_vid}(:,2),'omitnan');
        tfm_para_user_para_Prelax{current_vid}=mean(Pmin{current_vid}(:,2),'omitnan');
        tfm_para_user_para_U{current_vid}=mean(Umax{current_vid}(:,2),'omitnan')-mean(Umin{current_vid}(:,2),'omitnan');
        sign_Mxx_para = sign(abs(mean(Mxx_max{current_vid}(:,2),'omitnan'))-abs(mean(Mxx_min{current_vid}(:,2),'omitnan')));
        tfm_para_user_para_Mxx{current_vid}=(mean(Mxx_max{current_vid}(:,2),'omitnan')-mean(Mxx_min{current_vid}(:,2),'omitnan'))*sign_Mxx_para;
        sign_Myy_para = sign(abs(mean(Myy_max{current_vid}(:,2),'omitnan'))-abs(mean(Myy_min{current_vid}(:,2),'omitnan')));
        tfm_para_user_para_Myy{current_vid}=(mean(Myy_max{current_vid}(:,2),'omitnan')-mean(Myy_min{current_vid}(:,2)))*sign_Myy_para;
        sign_Mxy_para = sign(abs(mean(Mxy_max{current_vid}(:,2),'omitnan'))-abs(mean(Mxy_min{current_vid}(:,2),'omitnan')));
        tfm_para_user_para_Mxy{current_vid}=(mean(Mxy_max{current_vid}(:,2),'omitnan')-mean(Mxy_min{current_vid}(:,2),'omitnan'))*sign_Mxy_para;
        sign_mu_para = sign(abs(mean(mu_max{current_vid}(:,2),'omitnan'))-abs(mean(mu_min{current_vid}(:,2),'omitnan')));
        tfm_para_user_para_mu{current_vid}=(mean(mu_max{current_vid}(:,2),'omitnan')-mean(mu_min{current_vid}(:,2),'omitnan'))*sign_mu_para;
        %         tfm_para_user_para_tcontr{current_vid}=NaN;
        %         tfm_para_user_tcontr{current_vid}=t_init;
        tfm_para_user_para_tdp{current_vid}=NaN;
        %         tfm_para_user_para_freq{current_vid}=NaN;
        %         tfm_para_user_para_freqy{current_vid}=NaN;
        tfm_para_user_tdp{current_vid}=t_dp;
        tfm_para_user_para_ratiop{current_vid}=NaN;
        tfm_para_user_para_ratiodp{current_vid}=NaN;
        tfm_para_user_para_freq2{current_vid}=NaN;
        tfm_para_user_freq2{current_vid}=t_init;
        tfm_para_user_para_tagdp{current_vid}=0;
        tfm_para_user_discard_tag{current_vid}=0;
        tfm_para_user_dbl_tag{current_vid}=0;
        tfm_para_user_drift_tag{current_vid}=0;
        tfm_para_user_other_tag{current_vid}=0;
    end
    
    
    %display
    set(h_para.text_disp,'String',['dcontr=',num2str(tfm_para_user_para_Deltad{tfm_para_user_counter},'%.2e'),'[m]']);
    set(h_para.text_vel1,'String',['vcontr=',num2str(tfm_para_user_para_vcontr{tfm_para_user_counter},'%.2e'),'[m/s]']);
    set(h_para.text_vel2,'String',['vrelax=',num2str(tfm_para_user_para_vrelax{tfm_para_user_counter},'%.2e'),'[m/s]']);
    set(h_para.text_forces,'String',['F=',num2str(tfm_para_user_para_DeltaF{tfm_para_user_counter},'%.2e'),'[N]']);
    set(h_para.text_power1,'String',['Pcontr=',num2str(tfm_para_user_para_Pcontr{tfm_para_user_counter},'%.2e'),'[W]']);
    set(h_para.text_power2,'String',['Prelax=',num2str(tfm_para_user_para_Prelax{tfm_para_user_counter},'%.2e'),'[W]']);
    %     set(h_para.text_dp2_2,'String',['t=',num2str(NaN,'%.2e'),'[s]']);
    set(h_para.text_contr,'String',['tcontr=',num2str(tfm_para_user_para_tcontr{tfm_para_user_counter},'%.2e'),'[s]']);
    set(h_para.text_freq1,'String',['f=',num2str(tfm_para_user_para_freq{tfm_para_user_counter},'%.2e'),'[Hz]']);
    set(h_para.text_freq2,'String',['T=',num2str(1./tfm_para_user_para_freq{tfm_para_user_counter},'%.2e'),'[s]']);
    set(h_para.edit_ratio,'String',[num2str(NaN,'%.2e')]);
    %     set(h_para.edit_dp2,'String',[num2str(NaN,'%.2e')]);
    set(h_para.text_strain,'String',['U=',num2str(tfm_para_user_para_U{tfm_para_user_counter},'%.2e'),'[J]']);
    set(h_para.text_moment,'String',['mu=',num2str(tfm_para_user_para_mu{tfm_para_user_counter},'%.2e'),'[Nm]']);
    set(h_para.text_disp_autocor,'String',['dcontr=',num2str(d_pav{tfm_para_user_counter}.peak_amp,'%.2e'),'[m]',',n=',num2str(d_pav{tfm_para_user_counter}.n_peaks)]);
    set(h_para.text_force_autocor,'String',['F=',num2str(F_pav{tfm_para_user_counter}.peak_amp,'%.2e'),'[N]',',n=',num2str(F_pav{tfm_para_user_counter}.n_peaks)]);
    set(h_para.text_vcontr_autocor,'String',['vcontr=',num2str(d_pav{tfm_para_user_counter}.d_peak_max,'%.2e'),'[m/s]']);
    set(h_para.text_vrelax_autocor,'String',['vrelax=',num2str(d_pav{tfm_para_user_counter}.d_peak_min,'%.2e'),'[m/s]']);
    set(h_para.text_note_autocor,'String',['Comment: ',d_s{tfm_para_user_counter}.comment]);
    
    %set texts to 1st vid
    set(h_para.text_whichvidname,'String',tfm_init_user_filenamestack{1,1});
    set(h_para.text_whichvid,'String',[num2str(1),'/',num2str(tfm_init_user_Nfiles)]);
    
    %display and enable/disable buttons and panels
    set(h_para.panel_ratio,'Visible','off');
    set(h_para.panel_disp,'Visible','on');
    set(h_para.panel_vel,'Visible','on');
    set(h_para.panel_autocor,'Visible','on');
    set(h_para.panel_forces,'Visible','on');
    set(h_para.panel_power,'Visible','on');
    set(h_para.panel_contr,'Visible','off');
    set(h_para.panel_strain,'Visible','on');
    set(h_para.panel_moment,'Visible','on');
    set(h_para.panel_freq_orient,'Visible','on');
    %     set(h_para.panel_dp,'Visible','off');
    %     set(h_para.panel_dp2,'Visible','off');
    set(h_para.panel_tag,'Visible','on');
    set(h_para.button_backwards,'Visible','on');
    set(h_para.button_forwards,'Visible','on');
    set(h_para.button_double,'Visible','on');
    set(h_para.button_ok,'Visible','on');
    set(h_para.panel_preview,'Visible','on');
    set(h_para.text_whichvidname,'Visible','on');
    set(h_para.text_whichvid,'Visible','on');
    set(h_para.checkbox_save,'Visible','on');
    set(h_para.checkbox_save_traction,'Visible','on');
    
    %forward /backbutton
    if tfm_para_user_counter==1
        set(h_para.button_backwards,'Enable','off');
    else
        set(h_para.button_backwards,'Enable','on');
    end
    if tfm_para_user_counter==tfm_init_user_Nfiles
        set(h_para.button_forwards,'Enable','off');
    else
        set(h_para.button_forwards,'Enable','on');
    end
    
    
    %save for shared use
    setappdata(0,'tfm_para_user_d',tfm_para_user_d);
    setappdata(0,'tfm_para_user_dmax',dmax);
    setappdata(0,'tfm_para_user_dmin',dmin);
    setappdata(0,'tfm_para_user_vmax',vmax);
    setappdata(0,'tfm_para_user_vmin',vmin);
    setappdata(0,'tfm_para_user_Fxmax',Fxmax);
    setappdata(0,'tfm_para_user_Fxmin',Fxmin);
    setappdata(0,'tfm_para_user_Fymax',Fymax);
    setappdata(0,'tfm_para_user_Fymin',Fymin);
    setappdata(0,'tfm_para_user_Fmax',Fmax);
    setappdata(0,'tfm_para_user_Fmin',Fmin);
    setappdata(0,'tfm_para_user_Pmax',Pmax);
    setappdata(0,'tfm_para_user_Pmin',Pmin);
    setappdata(0,'tfm_para_user_dt',dt);
    setappdata(0,'tfm_para_user_velocity',Velocity);
    setappdata(0,'tfm_para_user_power',Power);
    setappdata(0,'tfm_para_user_F_tot',F_tot);
    setappdata(0,'tfm_para_user_Fx_tot',Fx_tot);
    setappdata(0,'tfm_para_user_Fy_tot',Fy_tot);
    setappdata(0,'tfm_para_user_dtheta',theta);
    setappdata(0,'tfm_para_user_Mxx',Mxx);
    setappdata(0,'tfm_para_user_Mxy',Mxy);
    setappdata(0,'tfm_para_user_Myx',Myx);
    setappdata(0,'tfm_para_user_Myy',Myy);
    setappdata(0,'tfm_para_user_mu',mu);
    setappdata(0,'tfm_para_user_Mxx_max',Mxx_max);
    setappdata(0,'tfm_para_user_Mxx_min',Mxx_min);
    setappdata(0,'tfm_para_user_Mxy_max',Mxy_max);
    setappdata(0,'tfm_para_user_Mxy_min',Mxy_min);
    setappdata(0,'tfm_para_user_Myy_max',Myy_max);
    setappdata(0,'tfm_para_user_Myy_min',Myy_min);
    setappdata(0,'tfm_para_user_mu_max',mu_max);
    setappdata(0,'tfm_para_user_mu_min',mu_min);
    setappdata(0,'tfm_para_user_para_Mxx',tfm_para_user_para_Mxx);
    setappdata(0,'tfm_para_user_para_Mxy',tfm_para_user_para_Mxy);
    setappdata(0,'tfm_para_user_para_Myy',tfm_para_user_para_Myy);
    setappdata(0,'tfm_para_user_para_mu',tfm_para_user_para_mu);
    setappdata(0,'tfm_para_user_U',U);
    setappdata(0,'tfm_para_user_Umax',Umax);
    setappdata(0,'tfm_para_user_Umin',Umin);
    setappdata(0,'tfm_para_user_para_U',tfm_para_user_para_U);
    setappdata(0,'tfm_para_user_center',center);
    setappdata(0,'tfm_para_user_para_Deltad',tfm_para_user_para_Deltad);
    setappdata(0,'tfm_para_user_para_DeltaFx',tfm_para_user_para_DeltaFx);
    setappdata(0,'tfm_para_user_para_DeltaFy',tfm_para_user_para_DeltaFy);
    setappdata(0,'tfm_para_user_para_DeltaF',tfm_para_user_para_DeltaF);
    setappdata(0,'tfm_para_user_para_vcontr',tfm_para_user_para_vcontr);
    setappdata(0,'tfm_para_user_para_vrelax',tfm_para_user_para_vrelax);
    setappdata(0,'tfm_para_user_para_Pcontr',tfm_para_user_para_Pcontr);
    setappdata(0,'tfm_para_user_para_Prelax',tfm_para_user_para_Prelax);
    setappdata(0,'tfm_para_user_tcontr',tfm_para_user_tcontr);
    setappdata(0,'tfm_para_user_para_tcontr',tfm_para_user_para_tcontr);
    setappdata(0,'tfm_para_user_tdp',tfm_para_user_tdp);
    setappdata(0,'tfm_para_user_para_tdp',tfm_para_user_para_tdp);
    setappdata(0,'tfm_para_user_freq2',tfm_para_user_freq2);
    setappdata(0,'tfm_para_user_para_freq2',tfm_para_user_para_freq2);
    setappdata(0,'tfm_para_user_para_freq',tfm_para_user_para_freq);
    setappdata(0,'tfm_para_user_para_freqy',tfm_para_user_para_freqy);
    setappdata(0,'tfm_para_user_freq',freq);
    setappdata(0,'tfm_para_user_y_fft',y_fft);
    setappdata(0,'tfm_para_user_para_ratiop',tfm_para_user_para_ratiop);
    setappdata(0,'tfm_para_user_para_ratiodp',tfm_para_user_para_ratiodp);
    setappdata(0,'tfm_para_user_para_tagdp',tfm_para_user_para_tagdp);
    setappdata(0,'tfm_para_user_discard_tag',tfm_para_user_discard_tag);
    setappdata(0,'tfm_para_user_dbl_tag',tfm_para_user_dbl_tag);
    setappdata(0,'tfm_para_user_drift_tag',tfm_para_user_drift_tag);
    setappdata(0,'tfm_para_user_other_tag',tfm_para_user_other_tag);
    setappdata(0,'tfm_para_user_other_comments',tfm_para_user_other_comments);
    setappdata(0,'tfm_para_user_d_s',d_s);
    setappdata(0,'tfm_para_user_d_pav',d_pav);
    setappdata(0,'tfm_para_user_F_s',F_s);
    setappdata(0,'tfm_para_user_Fx_s',Fx_s);
    setappdata(0,'tfm_para_user_Fy_s',Fy_s);
    setappdata(0,'tfm_para_user_F_pav',F_pav);
    setappdata(0,'tfm_para_user_Fx_pav',Fx_pav);
    setappdata(0,'tfm_para_user_Fy_pav',Fy_pav);
    %     setappdata(0,'tfm_para_user_V_s',V_s);
    %     setappdata(0,'tfm_para_user_V_pav',V_pav);
    setappdata(0,'tfm_para_user_P_s',P_s);
    setappdata(0,'tfm_para_user_P_pav',P_pav);
    setappdata(0,'tfm_para_user_U_s',U_s);
    setappdata(0,'tfm_para_user_U_pav',U_pav);
    setappdata(0,'tfm_para_user_mu_s',mu_s);
    setappdata(0,'tfm_para_user_mu_pav',mu_pav);
    %     setappdata(0,'tfm_para_user_Mxx_s',Mxx_s);
    %     setappdata(0,'tfm_para_user_Myy_s',Myy_s);
    %     setappdata(0,'tfm_para_user_Mxx_pav',Mxx_pav);
    %     setappdata(0,'tfm_para_user_Myy_pav',Myy_pav);
    setappdata(0,'tfm_para_user_disp_l',tfm_para_user_disp_l);
    
    %statusbar
    sb=statusbar(h_para.fig,'Calculation - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    
    %profile viewer
    
    % send notif
    myMessage='Results calculation finished';
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


function para_push_disp_addmax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_dmax=getappdata(0,'tfm_para_user_dmax');
    tfm_para_user_dmin=getappdata(0,'tfm_para_user_dmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Deltad=getappdata(0,'tfm_para_user_para_Deltad');
    
    d_init=tfm_para_user_dmax{tfm_para_user_counter};
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    i1=plot(tfm_para_user_dmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_dmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Add new maximum pts. Press "Enter" when done.')
    %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    d_add = zeros(size(new_x,1),2);
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_d{tfm_para_user_counter},2)
            
            % calculate dx, dy
            dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
            dy = (new_y(i)-tfm_para_user_d{tfm_para_user_counter}(j))*1e9;
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        % add new points
        d_add(i,:) = [index,tfm_para_user_d{tfm_para_user_counter}(index)];
    end
    
    %     d_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
    %     d_add(:,2)=y;
    d_new(:,1)=[d_init(:,1);d_add(:,1)];
    d_new(:,2)=[d_init(:,2);d_add(:,2)];
    %plot new in axes
    cla(h_para.axes_disp)
    axes(h_para.axes_disp)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_dmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(d_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},d_new(:,2),'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    %JFM
    %set(gca, 'YTick', []);
    ylim([0 5e-8]);
    %
    tfm_para_user_dmax{tfm_para_user_counter}=d_new;
    
    %update para
    tfm_para_user_para_Deltad{tfm_para_user_counter}=mean(tfm_para_user_dmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_dmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_disp,'String',['dcontr=',num2str(tfm_para_user_para_Deltad{tfm_para_user_counter},'%.2e'),'[m]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_dmax',tfm_para_user_dmax);
    setappdata(0,'tfm_para_user_para_Deltad',tfm_para_user_para_Deltad);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_disp_addmin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_dmax=getappdata(0,'tfm_para_user_dmax');
    tfm_para_user_dmin=getappdata(0,'tfm_para_user_dmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Deltad=getappdata(0,'tfm_para_user_para_Deltad');
    
    d_init=tfm_para_user_dmin{tfm_para_user_counter};
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    i1=plot(tfm_para_user_dmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_dmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Add new minimum pts. Press "Enter" when done.')
    %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    d_add = zeros(size(new_x,1),2);
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_d{tfm_para_user_counter},2)
            
            % calculate dx, dy
            dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
            dy = (new_y(i)-tfm_para_user_d{tfm_para_user_counter}(j))*1e9;
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        % add new points
        d_add(i,:) = [index,tfm_para_user_d{tfm_para_user_counter}(index)];
    end
    
    %     d_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
    %     d_add(:,2)=y;
    d_new(:,1)=[d_init(:,1);d_add(:,1)];
    d_new(:,2)=[d_init(:,2);d_add(:,2)];
    %plot new in axes
    cla(h_para.axes_disp)
    axes(h_para.axes_disp)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_dmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    plot(d_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},d_new(:,2),'.r','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    %JFM
    %set(gca, 'YTick', []);
    ylim([0 5e-8]);
    
    tfm_para_user_dmin{tfm_para_user_counter}=d_new;
    
    %update para
    tfm_para_user_para_Deltad{tfm_para_user_counter}=mean(tfm_para_user_dmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_dmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_disp,'String',['dcontr=',num2str(tfm_para_user_para_Deltad{tfm_para_user_counter},'%.2e'),'[m]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_dmin',tfm_para_user_dmin);
    setappdata(0,'tfm_para_user_para_Deltad',tfm_para_user_para_Deltad);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
    
end



function para_push_disp_removemax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_dmax=getappdata(0,'tfm_para_user_dmax');
    tfm_para_user_dmin=getappdata(0,'tfm_para_user_dmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Deltad=getappdata(0,'tfm_para_user_para_Deltad');
    
    d_init=tfm_para_user_dmax{tfm_para_user_counter};
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'); hold on;
    i2=plot(tfm_para_user_dmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    plot(tfm_para_user_dmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    title('Delete maximum pts. Press "Enter" when done.')
    %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    p = zeros(1,size(new_x,1));
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_dmax{tfm_para_user_counter},1)
            
            % calculate dx, dy
            dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_dmax{tfm_para_user_counter}(j,1);
            dy = new_y(i)-tfm_para_user_dmax{tfm_para_user_counter}(j,2);
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        p(i) = index;
    end
    
    d_new(:,1)=d_init(:,1);
    d_new(:,2)=d_init(:,2);
    d_new(p,:)=[];
    
    
    %plot new in axes
    cla(h_para.axes_disp)
    axes(h_para.axes_disp)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_dmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(d_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},d_new(:,2),'.g','MarkerSize',10), hold on;
    
    set(gca, 'XTick', []);
    %JFM
    %set(gca, 'YTick', []);
    ylim([0 5e-8]);
    
    tfm_para_user_dmax{tfm_para_user_counter}=d_new;
    
    %update para
    tfm_para_user_para_Deltad{tfm_para_user_counter}=mean(tfm_para_user_dmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_dmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_disp,'String',['dcontr=',num2str(tfm_para_user_para_Deltad{tfm_para_user_counter},'%.2e'),'[m]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_dmax',tfm_para_user_dmax);
    setappdata(0,'tfm_para_user_para_Deltad',tfm_para_user_para_Deltad);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_disp_removemin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_dmax=getappdata(0,'tfm_para_user_dmax');
    tfm_para_user_dmin=getappdata(0,'tfm_para_user_dmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Deltad=getappdata(0,'tfm_para_user_para_Deltad');
    
    d_init=tfm_para_user_dmin{tfm_para_user_counter};
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'); hold on;
    plot(tfm_para_user_dmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_dmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Delete minimum pts. Press "Enter" when done.')
    %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    p = zeros(1,size(new_x,1));
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_dmin{tfm_para_user_counter},1)
            
            % calculate dx, dy
            dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_dmin{tfm_para_user_counter}(j,1);
            dy = new_y(i)-tfm_para_user_dmin{tfm_para_user_counter}(j,2);
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        p(i) = index;
    end
    
    d_new(:,1)=d_init(:,1);
    d_new(:,2)=d_init(:,2);
    d_new(p,:)=[];
    
    
    %plot new in axes
    cla(h_para.axes_disp)
    axes(h_para.axes_disp)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_dmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_dmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    plot(d_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},d_new(:,2),'.r','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    %JFM
    %set(gca, 'YTick', []);
    ylim([0 5e-8]);
    
    tfm_para_user_dmin{tfm_para_user_counter}=d_new;
    
    %update para
    tfm_para_user_para_Deltad{tfm_para_user_counter}=mean(tfm_para_user_dmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_dmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_disp,'String',['dcontr=',num2str(tfm_para_user_para_Deltad{tfm_para_user_counter},'%.2e'),'[m]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_dmin',tfm_para_user_dmin);
    setappdata(0,'tfm_para_user_para_Deltad',tfm_para_user_para_Deltad);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_disp_clearall(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_dmax=getappdata(0,'tfm_para_user_dmax');
    tfm_para_user_dmin=getappdata(0,'tfm_para_user_dmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_para_Deltad=getappdata(0,'tfm_para_user_para_Deltad');
    
    %plot new in axes
    cla(h_para.axes_disp)
    axes(h_para.axes_disp)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    set(gca, 'XTick', []);
    %JFM
    %set(gca, 'YTick', []);
    ylim([0 5e-8]);
    
    %delte dmin and dmax
    tfm_para_user_dmin{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_dmin{tfm_para_user_counter}(:,2)=NaN;
    tfm_para_user_dmax{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_dmax{tfm_para_user_counter}(:,2)=NaN;
    
    %update para
    tfm_para_user_para_Deltad{tfm_para_user_counter}=mean(tfm_para_user_dmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_dmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_disp,'String',['dcontr=',num2str(tfm_para_user_para_Deltad{tfm_para_user_counter},'%.2e'),'[m]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_dmin',tfm_para_user_dmin);
    setappdata(0,'tfm_para_user_dmax',tfm_para_user_dmax);
    setappdata(0,'tfm_para_user_para_Deltad',tfm_para_user_para_Deltad);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_vel_addmax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_vmax=getappdata(0,'tfm_para_user_vmax');
    tfm_para_user_vmin=getappdata(0,'tfm_para_user_vmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_vcontr=getappdata(0,'tfm_para_user_para_vcontr');
    tfm_para_user_para_vrelax=getappdata(0,'tfm_para_user_para_vrelax');
    
    v_init=tfm_para_user_vmax{tfm_para_user_counter};
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    i1=plot(tfm_para_user_vmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_vmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Add new maximum pts. Press "Enter" when done.')
    %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    v_add = zeros(size(new_x,1),2);
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_velocity{tfm_para_user_counter},2)
            
            % calculate dx, dy
            dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
            dy = (new_y(i)-tfm_para_user_velocity{tfm_para_user_counter}(j))*1e8;
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        % add new points
        v_add(i,:) = [index,tfm_para_user_velocity{tfm_para_user_counter}(index)];
    end
    
    %     v_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
    %     v_add(:,2)=y;
    v_new(:,1)=[v_init(:,1);v_add(:,1)];
    v_new(:,2)=[v_init(:,2);v_add(:,2)];
    %plot new in axes
    cla(h_para.axes_vel)
    axes(h_para.axes_vel)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_vmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(v_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},v_new(:,2),'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    tfm_para_user_vmax{tfm_para_user_counter}=v_new;
    
    %upate para
    tfm_para_user_para_vcontr{tfm_para_user_counter}=mean(tfm_para_user_vmax{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_vrelax{tfm_para_user_counter}=mean(tfm_para_user_vmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_vel1,'String',['vcontr=',num2str(tfm_para_user_para_vcontr{tfm_para_user_counter},'%.2e'),'[m/s]']);
    set(h_para.text_vel2,'String',['vrelax=',num2str(tfm_para_user_para_vrelax{tfm_para_user_counter},'%.2e'),'[m/s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_vmax',tfm_para_user_vmax);
    setappdata(0,'tfm_para_user_para_vcontr',tfm_para_user_para_vcontr);
    setappdata(0,'tfm_para_user_para_vrelax',tfm_para_user_para_vrelax);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_vel_addmin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_vmax=getappdata(0,'tfm_para_user_vmax');
    tfm_para_user_vmin=getappdata(0,'tfm_para_user_vmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_vcontr=getappdata(0,'tfm_para_user_para_vcontr');
    tfm_para_user_para_vrelax=getappdata(0,'tfm_para_user_para_vrelax');
    
    v_init=tfm_para_user_vmin{tfm_para_user_counter};
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    i1=plot(tfm_para_user_vmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_vmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Add new minimum pts. Press "Enter" when done.')
    %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    v_add = zeros(size(new_x,1),2);
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_velocity{tfm_para_user_counter},2)
            
            % calculate dx, dy
            dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
            dy = (new_y(i)-tfm_para_user_velocity{tfm_para_user_counter}(j))*1e7;
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        % add new points
        v_add(i,:) = [index,tfm_para_user_velocity{tfm_para_user_counter}(index)];
    end
    
    %     v_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
    %     v_add(:,2)=y;
    v_new(:,1)=[v_init(:,1);v_add(:,1)];
    v_new(:,2)=[v_init(:,2);v_add(:,2)];
    %plot new in axes
    cla(h_para.axes_vel)
    axes(h_para.axes_vel)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_vmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    plot(v_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},v_new(:,2),'.r','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    tfm_para_user_vmin{tfm_para_user_counter}=v_new;
    
    %upate para
    tfm_para_user_para_vcontr{tfm_para_user_counter}=mean(tfm_para_user_vmax{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_vrelax{tfm_para_user_counter}=mean(tfm_para_user_vmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_vel1,'String',['vcontr=',num2str(tfm_para_user_para_vcontr{tfm_para_user_counter},'%.2e'),'[m/s]']);
    set(h_para.text_vel2,'String',['vrelax=',num2str(tfm_para_user_para_vrelax{tfm_para_user_counter},'%.2e'),'[m/s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_vmin',tfm_para_user_vmin);
    setappdata(0,'tfm_para_user_para_vcontr',tfm_para_user_para_vcontr);
    setappdata(0,'tfm_para_user_para_vrelax',tfm_para_user_para_vrelax);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_vel_removemax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_vmax=getappdata(0,'tfm_para_user_vmax');
    tfm_para_user_vmin=getappdata(0,'tfm_para_user_vmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_vcontr=getappdata(0,'tfm_para_user_para_vcontr');
    tfm_para_user_para_vrelax=getappdata(0,'tfm_para_user_para_vrelax');
    
    v_init=tfm_para_user_vmax{tfm_para_user_counter};
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'); hold on;
    i2=plot(tfm_para_user_vmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    plot(tfm_para_user_vmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    title('Delete maximum pts. Press "Enter" when done.')
    %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    p = zeros(1,size(new_x,1));
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_vmax{tfm_para_user_counter},1)
            
            % calculate dx, dy
            dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_vmax{tfm_para_user_counter}(j,1);
            dy = new_y(i)-tfm_para_user_vmax{tfm_para_user_counter}(j,2);
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        p(i) = index;
    end
    
    v_new(:,1)=v_init(:,1);
    v_new(:,2)=v_init(:,2);
    v_new(p,:)=[];
    
    
    %plot new in axes
    cla(h_para.axes_vel)
    axes(h_para.axes_vel)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_vmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(v_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},v_new(:,2),'.g','MarkerSize',10), hold on;
    
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    tfm_para_user_vmax{tfm_para_user_counter}=v_new;
    
    %upate para
    tfm_para_user_para_vcontr{tfm_para_user_counter}=mean(tfm_para_user_vmax{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_vrelax{tfm_para_user_counter}=mean(tfm_para_user_vmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_vel1,'String',['vcontr=',num2str(tfm_para_user_para_vcontr{tfm_para_user_counter},'%.2e'),'[m/s]']);
    set(h_para.text_vel2,'String',['vrelax=',num2str(tfm_para_user_para_vrelax{tfm_para_user_counter},'%.2e'),'[m/s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_vmax',tfm_para_user_vmax);
    setappdata(0,'tfm_para_user_para_vcontr',tfm_para_user_para_vcontr);
    setappdata(0,'tfm_para_user_para_vrelax',tfm_para_user_para_vrelax);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_vel_removemin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_vmax=getappdata(0,'tfm_para_user_vmax');
    tfm_para_user_vmin=getappdata(0,'tfm_para_user_vmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_vcontr=getappdata(0,'tfm_para_user_para_vcontr');
    tfm_para_user_para_vrelax=getappdata(0,'tfm_para_user_para_vrelax');
    
    v_init=tfm_para_user_vmin{tfm_para_user_counter};
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'); hold on;
    plot(tfm_para_user_vmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_vmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Delete minimum pts. Press "Enter" when done.')
    %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    p = zeros(1,size(new_x,1));
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_vmin{tfm_para_user_counter},1)
            
            % calculate dx, dy
            dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_vmin{tfm_para_user_counter}(j,1);
            dy = new_y(i)-tfm_para_user_vmin{tfm_para_user_counter}(j,2);
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        p(i) = index;
    end
    
    v_new(:,1)=v_init(:,1);
    v_new(:,2)=v_init(:,2);
    v_new(p,:)=[];
    
    
    %plot new in axes
    cla(h_para.axes_vel)
    axes(h_para.axes_vel)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_vmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_vmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    plot(v_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},v_new(:,2),'.r','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    tfm_para_user_vmin{tfm_para_user_counter}=v_new;
    
    %upate para
    tfm_para_user_para_vcontr{tfm_para_user_counter}=mean(tfm_para_user_vmax{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_vrelax{tfm_para_user_counter}=mean(tfm_para_user_vmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_vel1,'String',['vcontr=',num2str(tfm_para_user_para_vcontr{tfm_para_user_counter},'%.2e'),'[m/s]']);
    set(h_para.text_vel2,'String',['vrelax=',num2str(tfm_para_user_para_vrelax{tfm_para_user_counter},'%.2e'),'[m/s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_vmin',tfm_para_user_vmin);
    setappdata(0,'tfm_para_user_para_vcontr',tfm_para_user_para_vcontr);
    setappdata(0,'tfm_para_user_para_vrelax',tfm_para_user_para_vrelax);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_vel_clearall(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_vmax=getappdata(0,'tfm_para_user_vmax');
    tfm_para_user_vmin=getappdata(0,'tfm_para_user_vmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_para_vcontr=getappdata(0,'tfm_para_user_para_vcontr');
    tfm_para_user_para_vrelax=getappdata(0,'tfm_para_user_para_vrelax');
    
    %plot new in axes
    cla(h_para.axes_vel)
    axes(h_para.axes_vel)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %delte dmin and dmax
    tfm_para_user_vmin{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_vmin{tfm_para_user_counter}(:,2)=NaN;
    tfm_para_user_vmax{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_vmax{tfm_para_user_counter}(:,2)=NaN;
    
    %upate para
    tfm_para_user_para_vcontr{tfm_para_user_counter}=mean(tfm_para_user_vmax{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_vrelax{tfm_para_user_counter}=mean(tfm_para_user_vmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_vel1,'String',['vcontr=',num2str(tfm_para_user_para_vcontr{tfm_para_user_counter},'%.2e'),'[m/s]']);
    set(h_para.text_vel2,'String',['vrelax=',num2str(tfm_para_user_para_vrelax{tfm_para_user_counter},'%.2e'),'[m/s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_vmin',tfm_para_user_vmin);
    setappdata(0,'tfm_para_user_vmax',tfm_para_user_vmax);
    setappdata(0,'tfm_para_user_para_vcontr',tfm_para_user_para_vcontr);
    setappdata(0,'tfm_para_user_para_vrelax',tfm_para_user_para_vrelax);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_contr_calc(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));

try
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_tcontr=getappdata(0,'tfm_para_user_tcontr');
    tfm_para_user_para_tcontr=getappdata(0,'tfm_para_user_para_tcontr');
    tfm_para_user_vmax=getappdata(0,'tfm_para_user_vmax');
    tfm_para_user_vmin=getappdata(0,'tfm_para_user_vmin');
    
    %init
    [tmax,I]=sort(tfm_para_user_vmax{tfm_para_user_counter}(:,1));
    [tmin,J]=sort(tfm_para_user_vmin{tfm_para_user_counter}(:,1));
    
    %index corresponding v peaks
    tlength = min(size(tmax,1), size(tmin,1));
    for i=1:tlength
        vmax(i,1)=tmax(i);
        vmax(i,2)=tfm_para_user_vmax{tfm_para_user_counter}(I(i),2);
        vmin(i,1)=tmin(i);
        vmin(i,2)=tfm_para_user_vmin{tfm_para_user_counter}(J(i),2);
    end
    dtcontr=zeros(1,size(tmax,1));
    tcontr=zeros(size(tmax,1),4);
    
    %plot min/max points
    cla(h_para.axes_vel)
    axes(h_para.axes_vel)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    plot(vmax(:,1)/tfm_init_user_framerate{tfm_para_user_counter},vmax(:,2),'.g','MarkerSize',10);
    plot(vmin(:,1)/tfm_init_user_framerate{tfm_para_user_counter},vmin(:,2),'.r','MarkerSize',10);
    
    %loop over v peaks
    for i=1:tlength
        %calculate dt for every min/max pair
        ti=tmax(i)/tfm_init_user_framerate{tfm_para_user_counter};
        tf=tmin(i)/tfm_init_user_framerate{tfm_para_user_counter};
        dt=tf-ti;
        %plot contraction times
        hold on;
        plot(linspace(ti,tf,2),linspace(0,0,2),'r','LineWidth',5);
        %save peaks
        tcontr(i,1)=ti;
        tcontr(i,2)=tf;
        tcontr(i,3)=vmax(i,2);
        tcontr(i,4)=vmin(i,2);
        %save dt
        dtcontr(i)=dt;
        
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %save new pt vector
    tfm_para_user_tcontr{tfm_para_user_counter}=tcontr;
    tfm_para_user_para_tcontr{tfm_para_user_counter}=mean(dtcontr,'omitnan');
    set(h_para.text_contr,'String',['tcontr=',num2str(tfm_para_user_para_tcontr{tfm_para_user_counter},'%.2e'),'[s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_tcontr',tfm_para_user_tcontr);
    setappdata(0,'tfm_para_user_para_tcontr',tfm_para_user_para_tcontr);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_freq_add(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %add  pair
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_freq2=getappdata(0,'tfm_para_user_freq2');
    tfm_para_user_para_freq2=getappdata(0,'tfm_para_user_para_freq2');
    
    t_init=tfm_para_user_freq2{tfm_para_user_counter};
    
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    i1=plot(t_init(:,1),t_init(:,3),'.r','MarkerSize',10);
    i2=plot(t_init(:,2),t_init(:,4),'.r','MarkerSize',10);
    title('Add new left side')
    [~,x1,y1] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    cla;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    i1=plot(t_init(:,1),t_init(:,3),'.r','MarkerSize',10);
    i2=plot(t_init(:,2),t_init(:,4),'.r','MarkerSize',10);
    i3=plot(x1,y1,'.g','MarkerSize',10); hold on;
    title('Add new right side')
    [~,x2,y2] = selectdata('SelectionMode','closest','Ignore',[i1,i2,i3]);
    close(hf);
    
    t_add(:,1)=x1;
    t_add(:,2)=x2;
    t_add(:,3)=y1;
    t_add(:,4)=y2;
    t_new(:,1)=[t_init(:,1);t_add(:,1)];
    t_new(:,2)=[t_init(:,2);t_add(:,2)];
    t_new(:,3)=[t_init(:,3);t_add(:,3)];
    t_new(:,4)=[t_init(:,4);t_add(:,4)];
    
    %displ. in double peak
    cla(h_para.axes_freq)
    axes(h_para.axes_freq)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    %plot delta t
    dtcontr=zeros(1,size(t_new,1));
    cmap = hsv(size(t_new,1));
    for i=1:size(t_new,1)
        plot(t_new(i,1),t_new(i,3),'.','Color',cmap(i,:),'MarkerSize',10)
        plot(t_new(i,2),t_new(i,4),'.','Color',cmap(i,:),'MarkerSize',10)
        dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
        plot(linspace(t_new(i,1),t_new(i,2),100),linspace(0,0,100),'Color',cmap(i,:),'LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %save new pt vector
    tfm_para_user_freq2{tfm_para_user_counter}=t_new;
    x=mean(dtcontr,'omitnan');
    
    %display
    set(h_para.text_freq1,'String',['f=',num2str(1/(x+eps),'%.2e'),'[Hz]']);
    set(h_para.text_freq2,'String',['T=',num2str(x,'%.2e'),'[s]']);
    
    tfm_para_user_para_freq2{tfm_para_user_counter}=1/(x+eps);
    
    %save for shared use
    setappdata(0,'tfm_para_user_freq2',tfm_para_user_freq2);
    setappdata(0,'tfm_para_user_para_freq2',tfm_para_user_para_freq2);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_freq_addfft(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_freq=getappdata(0,'tfm_para_user_freq');
    tfm_para_user_para_freq=getappdata(0,'tfm_para_user_para_freq');
    tfm_para_user_para_freqy=getappdata(0,'tfm_para_user_para_freqy');
    tfm_para_user_y_fft=getappdata(0,'tfm_para_user_y_fft');
    
    %
    freq=tfm_para_user_freq;
    y_fft=tfm_para_user_y_fft;
    
    hf=figure;
    plot(freq{tfm_para_user_counter},y_fft{tfm_para_user_counter},'-b'), hold on;
    title('Pick peak')
    [~,x,y] = selectdata('SelectionMode','closest');
    close(hf);
    
    %plot
    cla(h_para.axes_freq)
    axes(h_para.axes_freq)
    plot(freq{tfm_para_user_counter},y_fft{tfm_para_user_counter},'-b'), hold on;
    plot(x,y,'.g','MarkerSize',10)
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %display
    set(h_para.text_freq1,'String',['f=',num2str(x,'%.2e'),'[Hz]']);
    set(h_para.text_freq2,'String',['T=',num2str(1/x,'%.2e'),'[s]']);
    
    tfm_para_user_para_freq{tfm_para_user_counter}=x;
    tfm_para_user_para_freqy{tfm_para_user_counter}=y;
    
    %save for shared use
    setappdata(0,'tfm_para_user_para_freq',tfm_para_user_para_freq);
    setappdata(0,'tfm_para_user_para_freqy',tfm_para_user_para_freqy);
    %setappdata(0,'tfm_para_user_para_vcontr',tfm_para_user_para_vcontr);
    %setappdata(0,'tfm_para_user_para_vrelax',tfm_para_user_para_vrelax);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_freq_remove(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_freq2=getappdata(0,'tfm_para_user_freq2');
    tfm_para_user_para_freq2=getappdata(0,'tfm_para_user_para_freq2');
    
    t_init=tfm_para_user_freq2{tfm_para_user_counter};
    
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'); hold on;
    plot(t_init(:,1),t_init(:,3),'.r','MarkerSize',10);
    i2=plot(t_init(:,2),t_init(:,4),'.r','MarkerSize',10);
    title('Delte left pt.')
    [p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    close(hf);
    
    t_new(:,1)=t_init(:,1);
    t_new(:,2)=t_init(:,2);
    t_new(:,3)=t_init(:,3);
    t_new(:,4)=t_init(:,4);
    t_new(p,:)=[];
    
    %displ. in double peak
    cla(h_para.axes_freq)
    axes(h_para.axes_freq)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    %plot delta t
    dtcontr=zeros(1,size(t_new,1));
    cmap = hsv(size(t_new,1));
    for i=1:size(t_new,1)
        plot(t_new(i,1),t_new(i,3),'.','Color',cmap(i,:),'MarkerSize',10)
        plot(t_new(i,2),t_new(i,4),'.','Color',cmap(i,:),'MarkerSize',10)
        dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
        plot(linspace(t_new(i,1),t_new(i,2),100),linspace(0,0,100),'Color',cmap(i,:),'LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %save new pt vector
    tfm_para_user_freq2{tfm_para_user_counter}=t_new;
    x=mean(dtcontr,'omitnan');
    
    %display
    set(h_para.text_freq1,'String',['f=',num2str(1/(x+eps),'%.2e'),'[Hz]']);
    set(h_para.text_freq2,'String',['T=',num2str(x,'%.2e'),'[s]']);
    
    tfm_para_user_para_freq2{tfm_para_user_counter}=1/(x+eps);
    
    %save for shared use
    setappdata(0,'tfm_para_user_freq2',tfm_para_user_freq2);
    setappdata(0,'tfm_para_user_para_freq2',tfm_para_user_para_freq2);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_freq_clearall(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %remove all
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_freq2=getappdata(0,'tfm_para_user_freq2');
    tfm_para_user_para_freq2=getappdata(0,'tfm_para_user_para_freq2');
    
    t_new(:,1)=NaN;
    t_new(:,2)=NaN;
    t_new(:,3)=NaN;
    t_new(:,4)=NaN;
    
    cla(h_para.axes_freq)
    axes(h_para.axes_freq)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    %plot delta t
    dtcontr=zeros(1,size(t_new,1));
    cmap = hsv(size(t_new,1));
    for i=1:size(t_new,1)
        plot(t_new(i,1),t_new(i,3),'.','Color',cmap(i,:),'MarkerSize',10)
        plot(t_new(i,2),t_new(i,4),'.','Color',cmap(i,:),'MarkerSize',10)
        dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
        plot(linspace(t_new(i,1),t_new(i,2),100),linspace(0,0,100),'Color',cmap(i,:),'LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %save new pt vector
    tfm_para_user_freq2{tfm_para_user_counter}=t_new;
    tfm_para_user_para_freq2{tfm_para_user_counter}=mean(dtcontr,'omitnan');
    x=tfm_para_user_para_freq2{tfm_para_user_counter};
    
    %display
    set(h_para.text_freq1,'String',['f=',num2str(1/(x+eps),'%.2e'),'[Hz]']);
    set(h_para.text_freq2,'String',['T=',num2str(x,'%.2e'),'[s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_freq2',tfm_para_user_freq2);
    setappdata(0,'tfm_para_user_para_freq2',tfm_para_user_para_freq2);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_forces_addmax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load para here
    % load for all forces
    tfm_para_user_Fmax=getappdata(0,'tfm_para_user_Fmax');
    tfm_para_user_Fmin=getappdata(0,'tfm_para_user_Fmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_F_tot=getappdata(0,'tfm_para_user_F_tot');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_DeltaF=getappdata(0,'tfm_para_user_para_DeltaF');
    tfm_para_user_Fxmax=getappdata(0,'tfm_para_user_Fxmax');
    tfm_para_user_Fxmin=getappdata(0,'tfm_para_user_Fxmin');
    tfm_para_user_Fx_tot=getappdata(0,'tfm_para_user_Fx_tot');
    tfm_para_user_para_DeltaFx=getappdata(0,'tfm_para_user_para_DeltaFx');
    tfm_para_user_Fymax=getappdata(0,'tfm_para_user_Fymax');
    tfm_para_user_Fymin=getappdata(0,'tfm_para_user_Fymin');
    tfm_para_user_Fy_tot=getappdata(0,'tfm_para_user_Fy_tot');
    tfm_para_user_para_DeltaFy=getappdata(0,'tfm_para_user_para_DeltaFy');
    
    %check ftot, fx, or fy
    if get(h_para.radiobutton_forcetot,'Value') %ftot
        
        F_init=tfm_para_user_Fmax{tfm_para_user_counter};
        Fx_init=tfm_para_user_Fxmax{tfm_para_user_counter};
        Fy_init=tfm_para_user_Fymax{tfm_para_user_counter};
        
        hf=figure;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter},'-b'), hold on;
        i1=plot(tfm_para_user_Fmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        i2=plot(tfm_para_user_Fmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Add new maximum pts. Press "Enter" when done.')
        %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        F_add = zeros(size(new_x,1),2);
        Fx_add = zeros(size(new_x,1),2);
        Fy_add = zeros(size(new_x,1),2);
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_F_tot{tfm_para_user_counter},2)
                
                % calculate dx, dy
                dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
                dy = (new_y(i)-tfm_para_user_F_tot{tfm_para_user_counter}(j))*1e8;
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            % add new points
            F_add(i,:) = [index,tfm_para_user_F_tot{tfm_para_user_counter}(index)];
            Fx_add(i,:) = [index,tfm_para_user_Fx_tot{tfm_para_user_counter}(index)];
            Fy_add(i,:) = [index,tfm_para_user_Fy_tot{tfm_para_user_counter}(index)];
        end
        
        %         F_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
        %         F_add(:,2)=y;
        F_new(:,1)=[F_init(:,1);F_add(:,1)];
        F_new(:,2)=[F_init(:,2);F_add(:,2)];
        Fx_new(:,1)=[Fx_init(:,1);Fx_add(:,1)];
        Fx_new(:,2)=[Fx_init(:,2);Fx_add(:,2)];
        Fy_new(:,1)=[Fy_init(:,1);Fy_add(:,1)];
        Fy_new(:,2)=[Fy_init(:,2);Fy_add(:,2)];
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        plot(F_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},F_new(:,2)*1e9,'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fmax{tfm_para_user_counter}=F_new;
        tfm_para_user_Fxmax{tfm_para_user_counter}=Fx_new;
        tfm_para_user_Fymax{tfm_para_user_counter}=Fy_new;
        
        %update para
        tfm_para_user_para_DeltaF{tfm_para_user_counter}=mean(tfm_para_user_Fmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fmin{tfm_para_user_counter}(:,2),'omitnan');
        tfm_para_user_para_DeltaFx{tfm_para_user_counter}=mean(tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'omitnan');
        tfm_para_user_para_DeltaFy{tfm_para_user_counter}=mean(tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['F=',num2str(tfm_para_user_para_DeltaF{tfm_para_user_counter},'%.2e'),'[N]']);
        
    elseif get(h_para.radiobutton_forcex,'Value') %fx
        
        F_init=tfm_para_user_Fxmax{tfm_para_user_counter};
        hf=figure;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter},'-b'), hold on;
        i1=plot(tfm_para_user_Fxmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        i2=plot(tfm_para_user_Fxmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Add new maximum pts. Press "Enter" when done.')
        %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        F_add = zeros(size(new_x,1),2);
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_Fx_tot{tfm_para_user_counter},2)
                
                % calculate dx, dy
                dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
                dy = (new_y(i)-tfm_para_user_Fx_tot{tfm_para_user_counter}(j))*1e8;
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            % add new points
            F_add(i,:) = [index,tfm_para_user_Fx_tot{tfm_para_user_counter}(index)];
        end
        
        %         F_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
        %         F_add(:,2)=y;
        F_new(:,1)=[F_init(:,1);F_add(:,1)];
        F_new(:,2)=[F_init(:,2);F_add(:,2)];
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fxmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        plot(F_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},F_new(:,2)*1e9,'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fxmax{tfm_para_user_counter}=F_new;
        
        %update para
        tfm_para_user_para_DeltaFx{tfm_para_user_counter}=mean(tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['Fx=',num2str(tfm_para_user_para_DeltaFx{tfm_para_user_counter},'%.2e'),'[N]']);
        
    elseif get(h_para.radiobutton_forcey,'Value') %fy
        
        F_init=tfm_para_user_Fymax{tfm_para_user_counter};
        hf=figure;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter},'-b'), hold on;
        i1=plot(tfm_para_user_Fymin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        i2=plot(tfm_para_user_Fymax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Add new maximum pts. Press "Enter" when done.')
        %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        F_add = zeros(size(new_x,1),2);
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_Fy_tot{tfm_para_user_counter},2)
                
                % calculate dx, dy
                dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
                dy = (new_y(i)-tfm_para_user_Fy_tot{tfm_para_user_counter}(j))*1e8;
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            % add new points
            F_add(i,:) = [index,tfm_para_user_Fy_tot{tfm_para_user_counter}(index)];
        end
        
        %         F_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
        %         F_add(:,2)=y;
        F_new(:,1)=[F_init(:,1);F_add(:,1)];
        F_new(:,2)=[F_init(:,2);F_add(:,2)];
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fymin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        plot(F_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},F_new(:,2)*1e9,'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fymax{tfm_para_user_counter}=F_new;
        
        %update para
        tfm_para_user_para_DeltaFy{tfm_para_user_counter}=mean(tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['Fy=',num2str(tfm_para_user_para_DeltaFy{tfm_para_user_counter},'%.2e'),'[N]']);
        
    end
    
    %save for shared use
    setappdata(0,'tfm_para_user_Fmax',tfm_para_user_Fmax);
    setappdata(0,'tfm_para_user_para_DeltaF',tfm_para_user_para_DeltaF);
    setappdata(0,'tfm_para_user_Fxmax',tfm_para_user_Fxmax);
    setappdata(0,'tfm_para_user_para_DeltaFx',tfm_para_user_para_DeltaFx);
    setappdata(0,'tfm_para_user_Fymax',tfm_para_user_Fymax);
    setappdata(0,'tfm_para_user_para_DeltaFy',tfm_para_user_para_DeltaFy);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_forces_addmin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));

try
    %load shared needed para
    tfm_para_user_Fxmax=getappdata(0,'tfm_para_user_Fxmax');
    tfm_para_user_Fxmin=getappdata(0,'tfm_para_user_Fxmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Fx_tot=getappdata(0,'tfm_para_user_Fx_tot');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_DeltaFx=getappdata(0,'tfm_para_user_para_DeltaFx');
    tfm_para_user_Fymax=getappdata(0,'tfm_para_user_Fymax');
    tfm_para_user_Fymin=getappdata(0,'tfm_para_user_Fymin');
    tfm_para_user_Fy_tot=getappdata(0,'tfm_para_user_Fy_tot');
    tfm_para_user_para_DeltaFy=getappdata(0,'tfm_para_user_para_DeltaFy');
    tfm_para_user_Fmax=getappdata(0,'tfm_para_user_Fmax');
    tfm_para_user_Fmin=getappdata(0,'tfm_para_user_Fmin');
    tfm_para_user_F_tot=getappdata(0,'tfm_para_user_F_tot');
    tfm_para_user_para_DeltaF=getappdata(0,'tfm_para_user_para_DeltaF');
    
    if get(h_para.radiobutton_forcex,'Value') %Fx
        
        Fx_init=tfm_para_user_Fxmin{tfm_para_user_counter};
        hf=figure;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter},'-b'), hold on;
        i1=plot(tfm_para_user_Fxmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        i2=plot(tfm_para_user_Fxmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Add new minimum pts. Press "Enter" when done.')
        %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        Fx_add = zeros(size(new_x,1),2);
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_Fx_tot{tfm_para_user_counter},2)
                
                % calculate dx, dy
                dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
                dy = (new_y(i)-tfm_para_user_Fx_tot{tfm_para_user_counter}(j))*1e8;
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            % add new points
            Fx_add(i,:) = [index,tfm_para_user_Fx_tot{tfm_para_user_counter}(index)];
        end
        
        %         Fx_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
        %         Fx_add(:,2)=y;
        Fx_new(:,1)=[Fx_init(:,1);Fx_add(:,1)];
        Fx_new(:,2)=[Fx_init(:,2);Fx_add(:,2)];
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fxmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(Fx_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fx_new(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fxmin{tfm_para_user_counter}=Fx_new;
        
        %update para
        tfm_para_user_para_DeltaFx{tfm_para_user_counter}=mean(tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['Fx=',num2str(tfm_para_user_para_DeltaFx{tfm_para_user_counter},'%.2e'),'[N]']);
        
    elseif get(h_para.radiobutton_forcey,'Value') %Fy
        
        Fy_init=tfm_para_user_Fymin{tfm_para_user_counter};
        hf=figure;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter},'-b'), hold on;
        i1=plot(tfm_para_user_Fymin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        i2=plot(tfm_para_user_Fymax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Add new minimum pts. Press "Enter" when done.')
        %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        Fy_add = zeros(size(new_x,1),2);
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_Fy_tot{tfm_para_user_counter},2)
                
                % calculate dx, dy
                dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
                dy = (new_y(i)-tfm_para_user_Fy_tot{tfm_para_user_counter}(j))*1e8;
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            % add new points
            Fy_add(i,:) = [index,tfm_para_user_Fy_tot{tfm_para_user_counter}(index)];
        end
        
        %         Fy_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
        %         Fy_add(:,2)=y;
        Fy_new(:,1)=[Fy_init(:,1);Fy_add(:,1)];
        Fy_new(:,2)=[Fy_init(:,2);Fy_add(:,2)];
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fymax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(Fy_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fy_new(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fymin{tfm_para_user_counter}=Fy_new;
        
        %update para
        tfm_para_user_para_DeltaFy{tfm_para_user_counter}=mean(tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['Fy=',num2str(tfm_para_user_para_DeltaFy{tfm_para_user_counter},'%.2e'),'[N]']);
        
    elseif get(h_para.radiobutton_forcetot,'Value') %F
        
        F_init=tfm_para_user_Fmin{tfm_para_user_counter};
        Fx_init=tfm_para_user_Fxmin{tfm_para_user_counter};
        Fy_init=tfm_para_user_Fymin{tfm_para_user_counter};
        
        hf=figure;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter},'-b'), hold on;
        i1=plot(tfm_para_user_Fmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        i2=plot(tfm_para_user_Fmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Add new minimum pts. Press "Enter" when done.')
        %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        F_add = zeros(size(new_x,1),2);
        Fx_add = zeros(size(new_x,1),2);
        Fy_add = zeros(size(new_x,1),2);
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_F_tot{tfm_para_user_counter},2)
                
                % calculate dx, dy
                dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
                dy = (new_y(i)-tfm_para_user_F_tot{tfm_para_user_counter}(j))*1e8;
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            % add new points
            F_add(i,:) = [index,tfm_para_user_F_tot{tfm_para_user_counter}(index)];
            Fx_add(i,:) = [index,tfm_para_user_Fx_tot{tfm_para_user_counter}(index)];
            Fy_add(i,:) = [index,tfm_para_user_Fy_tot{tfm_para_user_counter}(index)];
        end
        
        %        F_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
        %        F_add(:,2)=y;
        F_new(:,1)=[F_init(:,1);F_add(:,1)];
        F_new(:,2)=[F_init(:,2);F_add(:,2)];
        Fx_new(:,1)=[Fx_init(:,1);Fx_add(:,1)];
        Fx_new(:,2)=[Fx_init(:,2);Fx_add(:,2)];
        Fy_new(:,1)=[Fy_init(:,1);Fy_add(:,1)];
        Fy_new(:,2)=[Fy_init(:,2);Fy_add(:,2)];
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(F_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},F_new(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fmin{tfm_para_user_counter}=F_new;
        tfm_para_user_Fxmin{tfm_para_user_counter}=Fx_new;
        tfm_para_user_Fymin{tfm_para_user_counter}=Fy_new;
        
        %update para
        tfm_para_user_para_DeltaF{tfm_para_user_counter}=mean(tfm_para_user_Fmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fmin{tfm_para_user_counter}(:,2),'omitnan');
        tfm_para_user_para_DeltaFx{tfm_para_user_counter}=mean(tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'omitnan');
        tfm_para_user_para_DeltaFy{tfm_para_user_counter}=mean(tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['F=',num2str(tfm_para_user_para_DeltaF{tfm_para_user_counter},'%.2e'),'[N]']);
        
    end
    
    %save for shared use
    setappdata(0,'tfm_para_user_Fmin',tfm_para_user_Fmin);
    setappdata(0,'tfm_para_user_para_DeltaF',tfm_para_user_para_DeltaF);
    setappdata(0,'tfm_para_user_Fymin',tfm_para_user_Fymin);
    setappdata(0,'tfm_para_user_para_DeltaFy',tfm_para_user_para_DeltaFy);
    setappdata(0,'tfm_para_user_Fxmin',tfm_para_user_Fxmin);
    setappdata(0,'tfm_para_user_para_DeltaFx',tfm_para_user_para_DeltaFx);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
    
end


function para_push_forces_removemax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));

try
    
    %load shared needed para
    tfm_para_user_Fxmax=getappdata(0,'tfm_para_user_Fxmax');
    tfm_para_user_Fxmin=getappdata(0,'tfm_para_user_Fxmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Fx_tot=getappdata(0,'tfm_para_user_Fx_tot');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_DeltaFx=getappdata(0,'tfm_para_user_para_DeltaFx');
    tfm_para_user_Fymax=getappdata(0,'tfm_para_user_Fymax');
    tfm_para_user_Fymin=getappdata(0,'tfm_para_user_Fymin');
    tfm_para_user_Fy_tot=getappdata(0,'tfm_para_user_Fy_tot');
    tfm_para_user_para_DeltaFy=getappdata(0,'tfm_para_user_para_DeltaFy');
    tfm_para_user_Fmax=getappdata(0,'tfm_para_user_Fmax');
    tfm_para_user_Fmin=getappdata(0,'tfm_para_user_Fmin');
    tfm_para_user_F_tot=getappdata(0,'tfm_para_user_F_tot');
    tfm_para_user_para_DeltaF=getappdata(0,'tfm_para_user_para_DeltaF');
    
    %remove Fimax pts
    if get(h_para.radiobutton_forcex,'Value') %Fx
        
        Fx_init=tfm_para_user_Fxmax{tfm_para_user_counter};
        hf=figure;
        i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter},'-b'); hold on;
        i2=plot(tfm_para_user_Fxmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        plot(tfm_para_user_Fxmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Delete maximum pts. Press "Enter" when done.')
        %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        p = zeros(1,size(new_x,1));
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_Fxmax{tfm_para_user_counter},1)
                
                % calculate dx, dy
                dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Fxmax{tfm_para_user_counter}(j,1);
                dy = new_y(i)-tfm_para_user_Fxmax{tfm_para_user_counter}(j,2);
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            p(i) = index;
        end
        
        Fx_new=Fx_init;
        Fx_new(p,:)=[];
        
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fxmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        plot(Fx_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fx_new(:,2)*1e9,'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fxmax{tfm_para_user_counter}=Fx_new;
        
        %update para
        tfm_para_user_para_DeltaFx{tfm_para_user_counter}=mean(tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['Fx=',num2str(tfm_para_user_para_DeltaFx{tfm_para_user_counter},'%.2e'),'[N]']);
        
    elseif get(h_para.radiobutton_forcey,'Value') %Fy
        
        Fy_init=tfm_para_user_Fymax{tfm_para_user_counter};
        hf=figure;
        i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter},'-b'); hold on;
        i2=plot(tfm_para_user_Fymin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        plot(tfm_para_user_Fymax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Delete maximum pts. Press "Enter" when done.')
        %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        p = zeros(1,size(new_x,1));
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_Fymax{tfm_para_user_counter},1)
                
                % calculate dx, dy
                dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Fymax{tfm_para_user_counter}(j,1);
                dy = new_y(i)-tfm_para_user_Fymax{tfm_para_user_counter}(j,2);
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            p(i) = index;
        end
        
        Fy_new=Fy_init;
        Fy_new(p,:)=[];
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fymin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        plot(Fy_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fy_new(:,2)*1e9,'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fymax{tfm_para_user_counter}=Fy_new;
        
        %update para
        tfm_para_user_para_DeltaFy{tfm_para_user_counter}=mean(tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['Fy=',num2str(tfm_para_user_para_DeltaFy{tfm_para_user_counter},'%.2e'),'[N]']);
        
    elseif get(h_para.radiobutton_forcetot,'Value') %F
        
        F_init=tfm_para_user_Fmax{tfm_para_user_counter};
        Fx_init=tfm_para_user_Fxmax{tfm_para_user_counter};
        Fy_init=tfm_para_user_Fymax{tfm_para_user_counter};
        
        hf=figure;
        i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter},'-b'); hold on;
        i2=plot(tfm_para_user_Fmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        plot(tfm_para_user_Fmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Delete maximum pts. Press "Enter" when done.')
        %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        p = zeros(1,size(new_x,1));
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_Fmax{tfm_para_user_counter},1)
                
                % calculate dx, dy
                dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Fmax{tfm_para_user_counter}(j,1);
                dy = new_y(i)-tfm_para_user_Fmax{tfm_para_user_counter}(j,2);
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            p(i) = index;
        end
        
        F_new=F_init;
        F_new(p,:)=[];
        Fx_new=Fx_init;
        Fx_new(p,:)=[];
        Fy_new=Fy_init;
        Fy_new(p,:)=[];
        
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        plot(F_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},F_new(:,2)*1e9,'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fmax{tfm_para_user_counter}=F_new;
        tfm_para_user_Fxmax{tfm_para_user_counter}=Fx_new;
        tfm_para_user_Fymax{tfm_para_user_counter}=Fy_new;
        
        %update para
        tfm_para_user_para_DeltaF{tfm_para_user_counter}=mean(tfm_para_user_Fmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fmin{tfm_para_user_counter}(:,2),'omitnan');
        tfm_para_user_para_DeltaFx{tfm_para_user_counter}=mean(tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'omitnan');
        tfm_para_user_para_DeltaFy{tfm_para_user_counter}=mean(tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['F=',num2str(tfm_para_user_para_DeltaF{tfm_para_user_counter},'%.2e'),'[N]']);
        
    end
    
    %save for shared use
    setappdata(0,'tfm_para_user_Fmax',tfm_para_user_Fmax);
    setappdata(0,'tfm_para_user_para_DeltaF',tfm_para_user_para_DeltaF);
    setappdata(0,'tfm_para_user_Fymax',tfm_para_user_Fymax);
    setappdata(0,'tfm_para_user_para_DeltaFy',tfm_para_user_para_DeltaFy);
    setappdata(0,'tfm_para_user_Fxmax',tfm_para_user_Fxmax);
    setappdata(0,'tfm_para_user_para_DeltaFx',tfm_para_user_para_DeltaFx);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_forces_removemin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));

try
    
    %load shared needed para
    tfm_para_user_Fxmax=getappdata(0,'tfm_para_user_Fxmax');
    tfm_para_user_Fxmin=getappdata(0,'tfm_para_user_Fxmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Fx_tot=getappdata(0,'tfm_para_user_Fx_tot');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_DeltaFx=getappdata(0,'tfm_para_user_para_DeltaFx');
    tfm_para_user_Fymax=getappdata(0,'tfm_para_user_Fymax');
    tfm_para_user_Fymin=getappdata(0,'tfm_para_user_Fymin');
    tfm_para_user_Fy_tot=getappdata(0,'tfm_para_user_Fy_tot');
    tfm_para_user_para_DeltaFy=getappdata(0,'tfm_para_user_para_DeltaFy');
    tfm_para_user_Fmax=getappdata(0,'tfm_para_user_Fmax');
    tfm_para_user_Fmin=getappdata(0,'tfm_para_user_Fmin');
    tfm_para_user_F_tot=getappdata(0,'tfm_para_user_F_tot');
    tfm_para_user_para_DeltaF=getappdata(0,'tfm_para_user_para_DeltaF');
    
    if get(h_para.radiobutton_forcex,'Value') %Fx
        
        Fx_init=tfm_para_user_Fxmin{tfm_para_user_counter};
        hf=figure;
        i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter},'-b'); hold on;
        plot(tfm_para_user_Fxmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        i2=plot(tfm_para_user_Fxmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Delete minimum pts. Press "Enter" when done.')
        %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        p = zeros(1,size(new_x,1));
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_Fxmin{tfm_para_user_counter},1)
                
                % calculate dx, dy
                dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Fxmin{tfm_para_user_counter}(j,1);
                dy = new_y(i)-tfm_para_user_Fxmin{tfm_para_user_counter}(j,2);
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            p(i) = index;
        end
        
        Fx_new(:,1)=Fx_init(:,1);
        Fx_new(:,2)=Fx_init(:,2);
        Fx_new(p,:)=[];
        
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fxmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(Fx_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fx_new(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fxmin{tfm_para_user_counter}=Fx_new;
        
        %update para
        tfm_para_user_para_DeltaFx{tfm_para_user_counter}=mean(tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['Fx=',num2str(tfm_para_user_para_DeltaFx{tfm_para_user_counter},'%.2e'),'[N]']);
        
    elseif get(h_para.radiobutton_forcey,'Value') %Fy
        
        Fy_init=tfm_para_user_Fymin{tfm_para_user_counter};
        hf=figure;
        i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter},'-b'); hold on;
        plot(tfm_para_user_Fymin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        i2=plot(tfm_para_user_Fymax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Delete minimum pts. Press "Enter" when done.')
        %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        p = zeros(1,size(new_x,1));
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_Fymin{tfm_para_user_counter},1)
                
                % calculate dx, dy
                dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Fymin{tfm_para_user_counter}(j,1);
                dy = new_y(i)-tfm_para_user_Fymin{tfm_para_user_counter}(j,2);
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            p(i) = index;
        end
        
        Fy_new(:,1)=Fy_init(:,1);
        Fy_new(:,2)=Fy_init(:,2);
        Fy_new(p,:)=[];
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fymax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(Fy_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},Fy_new(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fymin{tfm_para_user_counter}=Fy_new;
        
        %update para
        tfm_para_user_para_DeltaFy{tfm_para_user_counter}=mean(tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['Fy=',num2str(tfm_para_user_para_DeltaFy{tfm_para_user_counter},'%.2e'),'[N]']);
        
    elseif get(h_para.radiobutton_forcetot,'Value') %F
        
        F_init=tfm_para_user_Fmin{tfm_para_user_counter};
        Fx_init=tfm_para_user_Fxmin{tfm_para_user_counter};
        Fy_init=tfm_para_user_Fymin{tfm_para_user_counter};
        
        hf=figure;
        i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter},'-b'); hold on;
        plot(tfm_para_user_Fmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
        i2=plot(tfm_para_user_Fmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
        title('Delete minimum pts. Press "Enter" when done.')
        %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
        [new_x,new_y] = getpts;
        close(hf);
        
        p = zeros(1,size(new_x,1));
        
        %find closest points
        for i = 1:size(new_x,1)
            
            for j = 1:size(tfm_para_user_Fmin{tfm_para_user_counter},1)
                
                % calculate dx, dy
                dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Fmin{tfm_para_user_counter}(j,1);
                dy = new_y(i)-tfm_para_user_Fmin{tfm_para_user_counter}(j,2);
                
                % calculate distance
                d(j) = sqrt(dx^2+dy^2);
            end
            % find index of min(d)
            [~,index] = min(d);
            p(i) = index;
        end
        
        F_new=F_init;
        F_new(p,:)=[];
        Fx_new=Fx_init;
        Fx_new(p,:)=[];
        Fy_new=Fy_init;
        Fy_new(p,:)=[];
        
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(F_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},F_new(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %
        tfm_para_user_Fmin{tfm_para_user_counter}=F_new;
        tfm_para_user_Fxmin{tfm_para_user_counter}=Fx_new;
        tfm_para_user_Fymin{tfm_para_user_counter}=Fy_new;
        
        %update para
        tfm_para_user_para_DeltaF{tfm_para_user_counter}=mean(tfm_para_user_Fmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fmin{tfm_para_user_counter}(:,2),'omitnan');
        tfm_para_user_para_DeltaFx{tfm_para_user_counter}=mean(tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'omitnan');
        tfm_para_user_para_DeltaFy{tfm_para_user_counter}=mean(tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['F=',num2str(tfm_para_user_para_DeltaF{tfm_para_user_counter},'%.2e'),'[N]']);
        
    end
    
    %save for shared use
    setappdata(0,'tfm_para_user_Fmin',tfm_para_user_Fmin);
    setappdata(0,'tfm_para_user_para_DeltaF',tfm_para_user_para_DeltaF);
    setappdata(0,'tfm_para_user_Fymin',tfm_para_user_Fymin);
    setappdata(0,'tfm_para_user_para_DeltaFy',tfm_para_user_para_DeltaFy);
    setappdata(0,'tfm_para_user_Fxmin',tfm_para_user_Fxmin);
    setappdata(0,'tfm_para_user_para_DeltaFx',tfm_para_user_para_DeltaFx);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
    
end


function para_push_forces_clearall(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));

try
    
    %load shared needed para
    tfm_para_user_Fxmax=getappdata(0,'tfm_para_user_Fxmax');
    tfm_para_user_Fxmin=getappdata(0,'tfm_para_user_Fxmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Fx_tot=getappdata(0,'tfm_para_user_Fx_tot');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_para_DeltaFx=getappdata(0,'tfm_para_user_para_DeltaFx');
    tfm_para_user_Fymax=getappdata(0,'tfm_para_user_Fymax');
    tfm_para_user_Fymin=getappdata(0,'tfm_para_user_Fymin');
    tfm_para_user_Fy_tot=getappdata(0,'tfm_para_user_Fy_tot');
    tfm_para_user_para_DeltaFy=getappdata(0,'tfm_para_user_para_DeltaFy');
    tfm_para_user_Fmax=getappdata(0,'tfm_para_user_Fmax');
    tfm_para_user_Fmin=getappdata(0,'tfm_para_user_Fmin');
    tfm_para_user_F_tot=getappdata(0,'tfm_para_user_F_tot');
    tfm_para_user_para_DeltaF=getappdata(0,'tfm_para_user_para_DeltaF');
    
    if get(h_para.radiobutton_forcex,'Value') %Fx
        
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        
        %delete Fimin and Fimax
        tfm_para_user_Fxmin{tfm_para_user_counter}(:,1)=NaN;
        tfm_para_user_Fxmin{tfm_para_user_counter}(:,2)=NaN;
        tfm_para_user_Fxmax{tfm_para_user_counter}(:,1)=NaN;
        tfm_para_user_Fxmax{tfm_para_user_counter}(:,2)=NaN;
        
        %update para
        tfm_para_user_para_DeltaFx{tfm_para_user_counter}=mean(tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['Fx=',num2str(tfm_para_user_para_DeltaFx{tfm_para_user_counter},'%.2e'),'[N]']);
        
    elseif get(h_para.radiobutton_forcey,'Value') %Fy
        
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        
        %delete Fimin and Fimax
        tfm_para_user_Fymin{tfm_para_user_counter}(:,1)=NaN;
        tfm_para_user_Fymin{tfm_para_user_counter}(:,2)=NaN;
        tfm_para_user_Fymax{tfm_para_user_counter}(:,1)=NaN;
        tfm_para_user_Fymax{tfm_para_user_counter}(:,2)=NaN;
        
        %update para
        tfm_para_user_para_DeltaFy{tfm_para_user_counter}=mean(tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['Fy=',num2str(tfm_para_user_para_DeltaFy{tfm_para_user_counter},'%.2e'),'[N]']);
        
    elseif get(h_para.radiobutton_forcetot,'Value') %F
        
        %plot new in axes
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        
        %delete Fimin and Fimax
        tfm_para_user_Fmin{tfm_para_user_counter}(:,1)=NaN;
        tfm_para_user_Fmin{tfm_para_user_counter}(:,2)=NaN;
        tfm_para_user_Fmax{tfm_para_user_counter}(:,1)=NaN;
        tfm_para_user_Fmax{tfm_para_user_counter}(:,2)=NaN;
        tfm_para_user_Fxmin{tfm_para_user_counter}(:,1)=NaN;
        tfm_para_user_Fxmin{tfm_para_user_counter}(:,2)=NaN;
        tfm_para_user_Fxmax{tfm_para_user_counter}(:,1)=NaN;
        tfm_para_user_Fxmax{tfm_para_user_counter}(:,2)=NaN;
        tfm_para_user_Fymin{tfm_para_user_counter}(:,1)=NaN;
        tfm_para_user_Fymin{tfm_para_user_counter}(:,2)=NaN;
        tfm_para_user_Fymax{tfm_para_user_counter}(:,1)=NaN;
        tfm_para_user_Fymax{tfm_para_user_counter}(:,2)=NaN;
        
        %update para
        tfm_para_user_para_DeltaF{tfm_para_user_counter}=mean(tfm_para_user_Fmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fmin{tfm_para_user_counter}(:,2),'omitnan');
        tfm_para_user_para_DeltaFx{tfm_para_user_counter}=mean(tfm_para_user_Fxmax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fxmin{tfm_para_user_counter}(:,2),'omitnan');
        tfm_para_user_para_DeltaFy{tfm_para_user_counter}=mean(tfm_para_user_Fymax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Fymin{tfm_para_user_counter}(:,2),'omitnan');
        set(h_para.text_forces,'String',['Fx=',num2str(tfm_para_user_para_DeltaF{tfm_para_user_counter},'%.2e'),'[N]']);
        
    end
    
    %save for shared use
    setappdata(0,'tfm_para_user_Fxmin',tfm_para_user_Fxmin);
    setappdata(0,'tfm_para_user_Fxmax',tfm_para_user_Fxmax);
    setappdata(0,'tfm_para_user_para_DeltaFx',tfm_para_user_para_DeltaFx);
    setappdata(0,'tfm_para_user_Fmin',tfm_para_user_Fmin);
    setappdata(0,'tfm_para_user_Fmax',tfm_para_user_Fmax);
    setappdata(0,'tfm_para_user_para_DeltaF',tfm_para_user_para_DeltaF);
    setappdata(0,'tfm_para_user_Fymin',tfm_para_user_Fymin);
    setappdata(0,'tfm_para_user_Fymax',tfm_para_user_Fymax);
    setappdata(0,'tfm_para_user_para_DeltaFy',tfm_para_user_para_DeltaFy);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_power_addmax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Pmax=getappdata(0,'tfm_para_user_Pmax');
    tfm_para_user_Pmin=getappdata(0,'tfm_para_user_Pmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_power=getappdata(0,'tfm_para_user_power');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Pcontr=getappdata(0,'tfm_para_user_para_Pcontr');
    tfm_para_user_para_Prelax=getappdata(0,'tfm_para_user_para_Prelax');
    
    P_init=tfm_para_user_Pmax{tfm_para_user_counter};
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_power{tfm_para_user_counter},'-b'), hold on;
    i1=plot(tfm_para_user_Pmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_Pmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Add new maximum pts. Press "Enter" when done.')
    %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    P_add = zeros(size(new_x,1),2);
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_power{tfm_para_user_counter},2)
            
            % calculate dx, dy
            dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
            dy = (new_y(i)-tfm_para_user_power{tfm_para_user_counter}(j))*1e12;
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        % add new points
        P_add(i,:) = [index,tfm_para_user_power{tfm_para_user_counter}(index)];
    end
    
    %     P_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
    %     P_add(:,2)=y;
    P_new(:,1)=[P_init(:,1);P_add(:,1)];
    P_new(:,2)=[P_init(:,2);P_add(:,2)];
    %plot new in axes
    cla(h_para.axes_power)
    axes(h_para.axes_power)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_power{tfm_para_user_counter}*1e12,'-b'), hold on;
    plot(tfm_para_user_Pmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmin{tfm_para_user_counter}(:,2)*1e12,'.r','MarkerSize',10), hold on;
    plot(P_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},P_new(:,2)*1e12,'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    tfm_para_user_Pmax{tfm_para_user_counter}=P_new;
    
    %upate para
    tfm_para_user_para_Pcontr{tfm_para_user_counter}=mean(tfm_para_user_Pmax{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Prelax{tfm_para_user_counter}=mean(tfm_para_user_Pmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_power1,'String',['Pcontr=',num2str(tfm_para_user_para_Pcontr{tfm_para_user_counter},'%.2e'),'[W]']);
    set(h_para.text_power2,'String',['Prelax=',num2str(tfm_para_user_para_Prelax{tfm_para_user_counter},'%.2e'),'[W]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_Pmax',tfm_para_user_Pmax);
    setappdata(0,'tfm_para_user_para_Pcontr',tfm_para_user_para_Pcontr);
    setappdata(0,'tfm_para_user_para_Prelax',tfm_para_user_para_Prelax);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
    
end



function para_push_power_addmin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Pmax=getappdata(0,'tfm_para_user_Pmax');
    tfm_para_user_Pmin=getappdata(0,'tfm_para_user_Pmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_power=getappdata(0,'tfm_para_user_power');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Pcontr=getappdata(0,'tfm_para_user_para_Pcontr');
    tfm_para_user_para_Prelax=getappdata(0,'tfm_para_user_para_Prelax');
    
    P_init=tfm_para_user_Pmin{tfm_para_user_counter};
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_power{tfm_para_user_counter},'-b'), hold on;
    i1=plot(tfm_para_user_Pmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_Pmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Add new minimum pts. Press "Enter" when done.')
    %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    P_add = zeros(size(new_x,1),2);
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_power{tfm_para_user_counter},2)
            
            % calculate dx, dy
            dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
            dy = (new_y(i)-tfm_para_user_power{tfm_para_user_counter}(j))*1e12;
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        % add new points
        P_add(i,:) = [index,tfm_para_user_power{tfm_para_user_counter}(index)];
    end
    
    %     P_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
    %     P_add(:,2)=y;
    P_new(:,1)=[P_init(:,1);P_add(:,1)];
    P_new(:,2)=[P_init(:,2);P_add(:,2)];
    %plot new in axes
    cla(h_para.axes_power)
    axes(h_para.axes_power)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_power{tfm_para_user_counter}*1e12,'-b'), hold on;
    plot(tfm_para_user_Pmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmax{tfm_para_user_counter}(:,2)*1e12,'.g','MarkerSize',10), hold on;
    plot(P_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},P_new(:,2)*1e12,'.r','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    tfm_para_user_Pmin{tfm_para_user_counter}=P_new;
    
    %upate para
    tfm_para_user_para_Pcontr{tfm_para_user_counter}=mean(tfm_para_user_Pmax{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Prelax{tfm_para_user_counter}=mean(tfm_para_user_Pmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_power1,'String',['Pcontr=',num2str(tfm_para_user_para_Pcontr{tfm_para_user_counter},'%.2e'),'[W]']);
    set(h_para.text_power2,'String',['Prelax=',num2str(tfm_para_user_para_Prelax{tfm_para_user_counter},'%.2e'),'[W]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_Pmin',tfm_para_user_Pmin);
    setappdata(0,'tfm_para_user_para_Pcontr',tfm_para_user_para_Pcontr);
    setappdata(0,'tfm_para_user_para_Prelax',tfm_para_user_para_Prelax);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_power_removemax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Pmax=getappdata(0,'tfm_para_user_Pmax');
    tfm_para_user_Pmin=getappdata(0,'tfm_para_user_Pmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_power=getappdata(0,'tfm_para_user_power');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Pcontr=getappdata(0,'tfm_para_user_para_Pcontr');
    tfm_para_user_para_Prelax=getappdata(0,'tfm_para_user_para_Prelax');
    
    P_init=tfm_para_user_Pmax{tfm_para_user_counter};
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_power{tfm_para_user_counter},'-b'); hold on;
    i2=plot(tfm_para_user_Pmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    plot(tfm_para_user_Pmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    title('Delete maximum pts. Press "Enter" when done.')
    %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    p = zeros(1,size(new_x,1));
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_Pmax{tfm_para_user_counter},1)
            
            % calculate dx, dy
            dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Pmax{tfm_para_user_counter}(j,1);
            dy = new_y(i)-tfm_para_user_Pmax{tfm_para_user_counter}(j,2);
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        p(i) = index;
    end
    
    P_new(:,1)=P_init(:,1);
    P_new(:,2)=P_init(:,2);
    P_new(p,:)=[];
    
    
    %plot new in axes
    cla(h_para.axes_power)
    axes(h_para.axes_power)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_power{tfm_para_user_counter}*1e12,'-b'), hold on;
    plot(tfm_para_user_Pmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmin{tfm_para_user_counter}(:,2)*1e12,'.r','MarkerSize',10), hold on;
    plot(P_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},P_new(:,2)*1e12,'.g','MarkerSize',10), hold on;
    
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    tfm_para_user_Pmax{tfm_para_user_counter}=P_new;
    
    %upate para
    tfm_para_user_para_Pcontr{tfm_para_user_counter}=mean(tfm_para_user_Pmax{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Prelax{tfm_para_user_counter}=mean(tfm_para_user_Pmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_power1,'String',['Pcontr=',num2str(tfm_para_user_para_Pcontr{tfm_para_user_counter},'%.2e'),'[W]']);
    set(h_para.text_power2,'String',['Prelax=',num2str(tfm_para_user_para_Prelax{tfm_para_user_counter},'%.2e'),'[W]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_Pmax',tfm_para_user_Pmax);
    setappdata(0,'tfm_para_user_para_Pcontr',tfm_para_user_para_Pcontr);
    setappdata(0,'tfm_para_user_para_Prelax',tfm_para_user_para_Prelax);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end



function para_push_power_removemin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Pmax=getappdata(0,'tfm_para_user_Pmax');
    tfm_para_user_Pmin=getappdata(0,'tfm_para_user_Pmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_power=getappdata(0,'tfm_para_user_power');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Pcontr=getappdata(0,'tfm_para_user_para_Pcontr');
    tfm_para_user_para_Prelax=getappdata(0,'tfm_para_user_para_Prelax');
    
    P_init=tfm_para_user_Pmin{tfm_para_user_counter};
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_power{tfm_para_user_counter},'-b'); hold on;
    plot(tfm_para_user_Pmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_Pmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Delete minimum pts. Press "Enter" when done.')
    %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    p = zeros(1,size(new_x,1));
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_Pmin{tfm_para_user_counter},1)
            
            % calculate dx, dy
            dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Pmin{tfm_para_user_counter}(j,1);
            dy = new_y(i)-tfm_para_user_Pmin{tfm_para_user_counter}(j,2);
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        p(i) = index;
    end
    
    P_new(:,1)=P_init(:,1);
    P_new(:,2)=P_init(:,2);
    P_new(p,:)=[];
    
    
    %plot new in axes
    cla(h_para.axes_power)
    axes(h_para.axes_power)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_power{tfm_para_user_counter}*1e12,'-b'), hold on;
    plot(tfm_para_user_Pmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmax{tfm_para_user_counter}(:,2)*1e12,'.g','MarkerSize',10), hold on;
    plot(P_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},P_new(:,2)*1e12,'.r','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    tfm_para_user_Pmin{tfm_para_user_counter}=P_new;
    
    %upate para
    tfm_para_user_para_Pcontr{tfm_para_user_counter}=mean(tfm_para_user_Pmax{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Prelax{tfm_para_user_counter}=mean(tfm_para_user_Pmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_power1,'String',['Pcontr=',num2str(tfm_para_user_para_Pcontr{tfm_para_user_counter},'%.2e'),'[W]']);
    set(h_para.text_power2,'String',['Prelax=',num2str(tfm_para_user_para_Prelax{tfm_para_user_counter},'%.2e'),'[W]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_Pmin',tfm_para_user_Pmin);
    setappdata(0,'tfm_para_user_para_Pcontr',tfm_para_user_para_Pcontr);
    setappdata(0,'tfm_para_user_para_Prelax',tfm_para_user_para_Prelax);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end



function para_push_power_clearall(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Pmax=getappdata(0,'tfm_para_user_Pmax');
    tfm_para_user_Pmin=getappdata(0,'tfm_para_user_Pmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_power=getappdata(0,'tfm_para_user_power');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_para_Pcontr=getappdata(0,'tfm_para_user_para_Pcontr');
    tfm_para_user_para_Prelax=getappdata(0,'tfm_para_user_para_Prelax');
    
    %plot new in axes
    cla(h_para.axes_power)
    axes(h_para.axes_power)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_power{tfm_para_user_counter}*1e12,'-b'), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %delte pmin and pmax
    tfm_para_user_Pmin{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_Pmin{tfm_para_user_counter}(:,2)=NaN;
    tfm_para_user_Pmax{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_Pmax{tfm_para_user_counter}(:,2)=NaN;
    
    %upate para
    tfm_para_user_para_Pcontr{tfm_para_user_counter}=mean(tfm_para_user_Pmax{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Prelax{tfm_para_user_counter}=mean(tfm_para_user_Pmin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_power1,'String',['Pcontr=',num2str(tfm_para_user_para_Pcontr{tfm_para_user_counter},'%.2e'),'[W]']);
    set(h_para.text_power2,'String',['Prelax=',num2str(tfm_para_user_para_Prelax{tfm_para_user_counter},'%.2e'),'[W]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_Pmin',tfm_para_user_Pmin);
    setappdata(0,'tfm_para_user_Pmax',tfm_para_user_Pmax);
    setappdata(0,'tfm_para_user_para_Pcontr',tfm_para_user_para_Pcontr);
    setappdata(0,'tfm_para_user_para_Prelax',tfm_para_user_para_Prelax);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_contr_get(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));

try
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_tcontr=getappdata(0,'tfm_para_user_tcontr');
    tfm_para_user_para_tcontr=getappdata(0,'tfm_para_user_para_tcontr');
    tfm_para_user_vmax=getappdata(0,'tfm_para_user_vmax');
    tfm_para_user_vmin=getappdata(0,'tfm_para_user_vmin');
    
    %init
    [tmax,I]=sort(tfm_para_user_vmax{tfm_para_user_counter}(:,1));
    [tmin,J]=sort(tfm_para_user_vmin{tfm_para_user_counter}(:,1));
    
    %index corresponding v peaks
    tlength = min(size(tmax,1), size(tmin,1));
    for i=1:tlength
        vmax(i,1)=tmax(i);
        vmax(i,2)=tfm_para_user_vmax{tfm_para_user_counter}(I(i),2);
        vmin(i,1)=tmin(i);
        vmin(i,2)=tfm_para_user_vmin{tfm_para_user_counter}(J(i),2);
    end
    dtcontr=zeros(1,size(tmax,1));
    tcontr=zeros(size(tmax,1),4);
    
    %plot min/max points
    cla(h_para.axes_contr)
    axes(h_para.axes_contr)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    plot(vmax(:,1)/tfm_init_user_framerate{tfm_para_user_counter},vmax(:,2),'.r','MarkerSize',10);
    plot(vmin(:,1)/tfm_init_user_framerate{tfm_para_user_counter},vmin(:,2),'.r','MarkerSize',10);
    
    %loop over v peaks
    for i=1:tlength
        %calculate dt for every min/max pair
        ti=tmax(i)/tfm_init_user_framerate{tfm_para_user_counter};
        tf=tmin(i)/tfm_init_user_framerate{tfm_para_user_counter};
        dt=tf-ti;
        %plot contraction times
        hold on;
        plot(linspace(ti,tf,2),linspace(0,0,2),'r','LineWidth',5);
        %save peaks
        tcontr(i,1)=ti;
        tcontr(i,2)=tf;
        tcontr(i,3)=vmax(i,2);
        tcontr(i,4)=vmin(i,2);
        %save dt
        dtcontr(i)=dt;
        
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %save new pt vector
    tfm_para_user_tcontr{tfm_para_user_counter}=tcontr;
    tfm_para_user_para_tcontr{tfm_para_user_counter}=mean(dtcontr,'omitnan');
    set(h_para.text_contr,'String',['tcontr=',num2str(tfm_para_user_para_tcontr{tfm_para_user_counter},'%.2e'),'[s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_tcontr',tfm_para_user_tcontr);
    setappdata(0,'tfm_para_user_para_tcontr',tfm_para_user_para_tcontr);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_contr_add(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_tcontr=getappdata(0,'tfm_para_user_tcontr');
    tfm_para_user_para_tcontr=getappdata(0,'tfm_para_user_para_tcontr');
    
    t_init=tfm_para_user_tcontr{tfm_para_user_counter};
    
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    i1=plot(t_init(:,1),t_init(:,3),'.r','MarkerSize',10);
    i2=plot(t_init(:,2),t_init(:,4),'.r','MarkerSize',10);
    title('Add new maximum pt.')
    [~,x1,y1] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    cla;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    i1=plot(t_init(:,1),t_init(:,3),'.r','MarkerSize',10);
    i2=plot(t_init(:,2),t_init(:,4),'.r','MarkerSize',10);
    i3=plot(x1,y1,'.g','MarkerSize',10); hold on;
    title('Add new minimum pt.')
    [~,x2,y2] = selectdata('SelectionMode','closest','Ignore',[i1,i2,i3]);
    close(hf);
    
    t_add(:,1)=x1;
    t_add(:,2)=x2;
    t_add(:,3)=y1;
    t_add(:,4)=y2;
    t_new(:,1)=[t_init(:,1);t_add(:,1)];
    t_new(:,2)=[t_init(:,2);t_add(:,2)];
    t_new(:,3)=[t_init(:,3);t_add(:,3)];
    t_new(:,4)=[t_init(:,4);t_add(:,4)];
    
    %plot new in axes
    cla(h_para.axes_contr)
    axes(h_para.axes_contr)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    plot(t_new(:,1),t_new(:,3),'.r','MarkerSize',10)
    plot(t_new(:,2),t_new(:,4),'.r','MarkerSize',10)
    %plot delta t
    dtcontr=zeros(1,size(t_new,1));
    for i=1:size(t_new,1)
        dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
        plot(linspace(t_new(i,1),t_new(i,2),2),linspace(0,0,2),'r','LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %save new pt vector
    tfm_para_user_tcontr{tfm_para_user_counter}=t_new;
    tfm_para_user_para_tcontr{tfm_para_user_counter}=mean(dtcontr,'omitnan');
    set(h_para.text_contr,'String',['tcontr=',num2str(tfm_para_user_para_tcontr{tfm_para_user_counter},'%.2e'),'[s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_tcontr',tfm_para_user_tcontr);
    setappdata(0,'tfm_para_user_para_tcontr',tfm_para_user_para_tcontr);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_contr_remove(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_tcontr=getappdata(0,'tfm_para_user_tcontr');
    tfm_para_user_para_tcontr=getappdata(0,'tfm_para_user_para_tcontr');
    
    t_init=tfm_para_user_tcontr{tfm_para_user_counter};
    
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'); hold on;
    plot(t_init(:,1),t_init(:,3),'.r','MarkerSize',10);
    i2=plot(t_init(:,2),t_init(:,4),'.r','MarkerSize',10);
    title('Delte maximum pt.')
    [p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    close(hf);
    
    t_new(:,1)=t_init(:,1);
    t_new(:,2)=t_init(:,2);
    t_new(:,3)=t_init(:,3);
    t_new(:,4)=t_init(:,4);
    t_new(p,:)=[];
    
    %plot new in axes
    cla(h_para.axes_contr)
    axes(h_para.axes_contr)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    plot(t_new(:,1),t_new(:,3),'.r','MarkerSize',10)
    plot(t_new(:,2),t_new(:,4),'.r','MarkerSize',10)
    %plot delta t
    dtcontr=zeros(1,size(t_new,1));
    for i=1:size(t_new,1)
        dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
        plot(linspace(t_new(i,1),t_new(i,2),2),linspace(0,0,2),'r','LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %save new pt vector
    tfm_para_user_tcontr{tfm_para_user_counter}=t_new;
    tfm_para_user_para_tcontr{tfm_para_user_counter}=mean(dtcontr,'omitnan');
    set(h_para.text_contr,'String',['tcontr=',num2str(tfm_para_user_para_tcontr{tfm_para_user_counter},'%.2e'),'[s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_tcontr',tfm_para_user_tcontr);
    setappdata(0,'tfm_para_user_para_tcontr',tfm_para_user_para_tcontr);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_contr_clearall(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_tcontr=getappdata(0,'tfm_para_user_tcontr');
    tfm_para_user_para_tcontr=getappdata(0,'tfm_para_user_para_tcontr');
    
    t_init=tfm_para_user_tcontr{tfm_para_user_counter};
    
    t_new(:,1)=NaN;
    t_new(:,2)=NaN;
    t_new(:,3)=NaN;
    t_new(:,4)=NaN;
    
    %plot new in axes
    cla(h_para.axes_contr)
    axes(h_para.axes_contr)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_velocity{tfm_para_user_counter},'-b'), hold on;
    
    dtcontr=zeros(1,size(t_new,1));
    for i=1:size(t_new,1)
        dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
        plot(linspace(t_new(i,1),t_new(i,2),2),linspace(0,0,2),'r','LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %save new pt vector
    tfm_para_user_tcontr{tfm_para_user_counter}=t_new;
    tfm_para_user_para_tcontr{tfm_para_user_counter}=mean(dtcontr,'omitnan');
    set(h_para.text_contr,'String',['tcontr=',num2str(tfm_para_user_para_tcontr{tfm_para_user_counter},'%.2e'),'[s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_tcontr',tfm_para_user_tcontr);
    setappdata(0,'tfm_para_user_para_tcontr',tfm_para_user_para_tcontr);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_strain_addmax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Umax=getappdata(0,'tfm_para_user_Umax');
    tfm_para_user_Umin=getappdata(0,'tfm_para_user_Umin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_U=getappdata(0,'tfm_para_user_U');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_U=getappdata(0,'tfm_para_user_para_U');
    
    U_init=tfm_para_user_Umax{tfm_para_user_counter};
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_U{tfm_para_user_counter},'-b'), hold on;
    i1=plot(tfm_para_user_Umin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_Umax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Add new maximum pts. Press "Enter" when done.')
    %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    U_add = zeros(size(new_x,1),2);
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_U{tfm_para_user_counter},2)
            
            % calculate dx, dy
            dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
            dy = (new_y(i)-tfm_para_user_U{tfm_para_user_counter}(j))*1e16;
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        % add new points
        U_add(i,:) = [index,tfm_para_user_U{tfm_para_user_counter}(index)];
    end
    
    %     U_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
    %     U_add(:,2)=y;
    U_new(:,1)=[U_init(:,1);U_add(:,1)];
    U_new(:,2)=[U_init(:,2);U_add(:,2)];
    %plot new in axes
    cla(h_para.axes_strain)
    axes(h_para.axes_strain)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_U{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_Umin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(U_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},U_new(:,2),'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %
    tfm_para_user_Umax{tfm_para_user_counter}=U_new;
    
    %update para
    tfm_para_user_para_U{tfm_para_user_counter}=mean(tfm_para_user_Umax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Umin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_strain,'String',['U=',num2str(tfm_para_user_para_U{tfm_para_user_counter},'%.2e'),'[J]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_Umax',tfm_para_user_Umax);
    setappdata(0,'tfm_para_user_para_U',tfm_para_user_para_U);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_strain_addmin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Umax=getappdata(0,'tfm_para_user_Umax');
    tfm_para_user_Umin=getappdata(0,'tfm_para_user_Umin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_U=getappdata(0,'tfm_para_user_U');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_U=getappdata(0,'tfm_para_user_para_U');
    
    U_init=tfm_para_user_Umin{tfm_para_user_counter};
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_U{tfm_para_user_counter},'-b'), hold on;
    i1=plot(tfm_para_user_Umin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_Umax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Add new minimum pts. Press "Enter" when done.')
    %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    U_add = zeros(size(new_x,1),2);
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_U{tfm_para_user_counter},2)
            
            % calculate dx, dy
            dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
            dy = (new_y(i)-tfm_para_user_U{tfm_para_user_counter}(j))*1e16;
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        % add new points
        U_add(i,:) = [index,tfm_para_user_U{tfm_para_user_counter}(index)];
    end
    
    %     U_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
    %     U_add(:,2)=y;
    U_new(:,1)=[U_init(:,1);U_add(:,1)];
    U_new(:,2)=[U_init(:,2);U_add(:,2)];
    %plot new in axes
    cla(h_para.axes_strain)
    axes(h_para.axes_strain)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_U{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_Umax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    plot(U_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},U_new(:,2),'.r','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    tfm_para_user_Umin{tfm_para_user_counter}=U_new;
    
    %update para
    tfm_para_user_para_U{tfm_para_user_counter}=mean(tfm_para_user_Umax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Umin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_strain,'String',['U=',num2str(tfm_para_user_para_U{tfm_para_user_counter},'%.2e'),'[J]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_Umin',tfm_para_user_Umin);
    setappdata(0,'tfm_para_user_para_U',tfm_para_user_para_U);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_strain_removemax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Umax=getappdata(0,'tfm_para_user_Umax');
    tfm_para_user_Umin=getappdata(0,'tfm_para_user_Umin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_U=getappdata(0,'tfm_para_user_U');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_U=getappdata(0,'tfm_para_user_para_U');
    
    U_init=tfm_para_user_Umax{tfm_para_user_counter};
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_U{tfm_para_user_counter},'-b'); hold on;
    i2=plot(tfm_para_user_Umin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    plot(tfm_para_user_Umax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    title('Delete maximum pts. Press "Enter" when done.')
    %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    p = zeros(1,size(new_x,1));
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_Umax{tfm_para_user_counter},1)
            
            % calculate dx, dy
            dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Umax{tfm_para_user_counter}(j,1);
            dy = new_y(i)-tfm_para_user_Umax{tfm_para_user_counter}(j,2);
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        p(i) = index;
    end
    
    U_new(:,1)=U_init(:,1);
    U_new(:,2)=U_init(:,2);
    U_new(p,:)=[];
    
    %plot new in axes
    cla(h_para.axes_strain)
    axes(h_para.axes_strain)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_U{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_Umin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(U_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},U_new(:,2),'.g','MarkerSize',10), hold on;
    
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    tfm_para_user_Umax{tfm_para_user_counter}=U_new;
    
    %update para
    tfm_para_user_para_U{tfm_para_user_counter}=mean(tfm_para_user_Umax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Umin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_strain,'String',['U=',num2str(tfm_para_user_para_U{tfm_para_user_counter},'%.2e'),'[J]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_Umax',tfm_para_user_Umax);
    setappdata(0,'tfm_para_user_para_U',tfm_para_user_para_U);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_strain_removemin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Umax=getappdata(0,'tfm_para_user_Umax');
    tfm_para_user_Umin=getappdata(0,'tfm_para_user_Umin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_U=getappdata(0,'tfm_para_user_U');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_U=getappdata(0,'tfm_para_user_para_U');
    
    U_init=tfm_para_user_Umin{tfm_para_user_counter};
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_U{tfm_para_user_counter},'-b'); hold on;
    plot(tfm_para_user_Umin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_Umax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    title('Delete minimum pts. Press "Enter" when done.')
    %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    p = zeros(1,size(new_x,1));
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_Umin{tfm_para_user_counter},1)
            
            % calculate dx, dy
            dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Umin{tfm_para_user_counter}(j,1);
            dy = new_y(i)-tfm_para_user_Umin{tfm_para_user_counter}(j,2);
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        p(i) = index;
    end
    
    U_new(:,1)=U_init(:,1);
    U_new(:,2)=U_init(:,2);
    U_new(p,:)=[];
    
    %plot new in axes
    cla(h_para.axes_strain)
    axes(h_para.axes_strain)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_U{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_Umax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    plot(U_new(:,1)/tfm_init_user_framerate{tfm_para_user_counter},U_new(:,2),'.r','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    tfm_para_user_Umin{tfm_para_user_counter}=U_new;
    
    %update para
    tfm_para_user_para_U{tfm_para_user_counter}=mean(tfm_para_user_Umax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Umin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_strain,'String',['U=',num2str(tfm_para_user_para_U{tfm_para_user_counter},'%.2e'),'[J]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_Umin',tfm_para_user_Umin);
    setappdata(0,'tfm_para_user_para_U',tfm_para_user_para_U);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_strain_clearall(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Umax=getappdata(0,'tfm_para_user_Umax');
    tfm_para_user_Umin=getappdata(0,'tfm_para_user_Umin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_U=getappdata(0,'tfm_para_user_U');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_para_U=getappdata(0,'tfm_para_user_para_U');
    
    %plot new in axes
    cla(h_para.axes_strain)
    axes(h_para.axes_strain)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_U{tfm_para_user_counter},'-b'), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %delte dmin and dmax
    tfm_para_user_Umin{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_Umin{tfm_para_user_counter}(:,2)=NaN;
    tfm_para_user_Umax{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_Umax{tfm_para_user_counter}(:,2)=NaN;
    
    %update para
    tfm_para_user_para_U{tfm_para_user_counter}=mean(tfm_para_user_Umax{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Umin{tfm_para_user_counter}(:,2),'omitnan');
    set(h_para.text_strain,'String',['U=',num2str(tfm_para_user_para_U{tfm_para_user_counter},'%.2e'),'[J]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_Umin',tfm_para_user_Umin);
    setappdata(0,'tfm_para_user_Umax',tfm_para_user_Umax);
    setappdata(0,'tfm_para_user_para_U',tfm_para_user_para_U);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_moment_addmax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Mxx_max=getappdata(0,'tfm_para_user_Mxx_max');
    tfm_para_user_Mxx_min=getappdata(0,'tfm_para_user_Mxx_min');
    tfm_para_user_Mxy_max=getappdata(0,'tfm_para_user_Mxy_max');
    tfm_para_user_Mxy_min=getappdata(0,'tfm_para_user_Mxy_min');
    tfm_para_user_Myy_max=getappdata(0,'tfm_para_user_Myy_max');
    tfm_para_user_Myy_min=getappdata(0,'tfm_para_user_Myy_min');
    tfm_para_user_mu_max=getappdata(0,'tfm_para_user_mu_max');
    tfm_para_user_mu_min=getappdata(0,'tfm_para_user_mu_min');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Mxx=getappdata(0,'tfm_para_user_Mxx');
    tfm_para_user_Mxy=getappdata(0,'tfm_para_user_Mxy');
    tfm_para_user_Myy=getappdata(0,'tfm_para_user_Myy');
    tfm_para_user_mu=getappdata(0,'tfm_para_user_mu');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Mxx=getappdata(0,'tfm_para_user_para_Mxx');
    tfm_para_user_para_Mxy=getappdata(0,'tfm_para_user_para_Mxy');
    tfm_para_user_para_Myy=getappdata(0,'tfm_para_user_para_Myy');
    tfm_para_user_para_mu=getappdata(0,'tfm_para_user_para_mu');
    
    Mxx_init=tfm_para_user_Mxx_max{tfm_para_user_counter};
    Mxy_init=tfm_para_user_Mxy_max{tfm_para_user_counter};
    Myy_init=tfm_para_user_Myy_max{tfm_para_user_counter};
    mu_init=tfm_para_user_mu_max{tfm_para_user_counter};
    
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b'), hold on;
    i1=plot(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    i3=plot(tfm_para_user_dt{tfm_para_user_counter},0,'--k'); hold on;
    title('Add new maximum pts. Press "Enter" when done.')
    %[p,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    Mxx_add = zeros(size(new_x,1),2);
    Mxy_add = zeros(size(new_x,1),2);
    Myy_add = zeros(size(new_x,1),2);
    mu_add = zeros(size(new_x,1),2);
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_Mxx{tfm_para_user_counter},2)
            
            % calculate dx, dy
            dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
            dy = (new_y(i)-tfm_para_user_Mxx{tfm_para_user_counter}(j))*1e13;
            % scale up y values?
            %
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        % add new points
        Mxx_add(i,:) = [index,tfm_para_user_Mxx{tfm_para_user_counter}(index)];
        Mxy_add(i,:) = [index,tfm_para_user_Mxy{tfm_para_user_counter}(index)];
        Myy_add(i,:) = [index,tfm_para_user_Myy{tfm_para_user_counter}(index)];
        mu_add(i,:) = [index,tfm_para_user_mu{tfm_para_user_counter}(index)];
    end
    
    %add new points
    %     Mxx_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
    %     Mxx_add(:,2)=y;
    Mxx_new(:,1)=[Mxx_init(:,1);Mxx_add(:,1)];
    Mxx_new(:,2)=[Mxx_init(:,2);Mxx_add(:,2)];
    Mxy_new(:,1)=[Mxy_init(:,1);Mxy_add(:,1)];
    Mxy_new(:,2)=[Mxy_init(:,2);Mxy_add(:,2)];
    Myy_new(:,1)=[Myy_init(:,1);Myy_add(:,1)];
    Myy_new(:,2)=[Myy_init(:,2);Myy_add(:,2)];
    mu_new(:,1)=[mu_init(:,1);mu_add(:,1)];
    mu_new(:,2)=[mu_init(:,2);mu_add(:,2)];
    
    tfm_para_user_Mxx_max{tfm_para_user_counter}=Mxx_new;
    tfm_para_user_Mxy_max{tfm_para_user_counter}=Mxy_new;
    tfm_para_user_Myy_max{tfm_para_user_counter}=Myy_new;
    tfm_para_user_mu_max{tfm_para_user_counter}=mu_new;
    
    %plot contractile moment
    if get(h_para.radiobutton_Mxx,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_Myy,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Myy{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Myy_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Myy_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_mu,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_mu{tfm_para_user_counter},'-b')
        plot(tfm_para_user_mu_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_mu_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    %update para
    tfm_para_user_para_Mxx{tfm_para_user_counter}=mean(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Mxy{tfm_para_user_counter}=mean(tfm_para_user_Mxy_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Mxy_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Myy{tfm_para_user_counter}=mean(tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_mu{tfm_para_user_counter}=mean(tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'omitnan');
    
    if get(h_para.radiobutton_Mxx,'Value')
        set(h_para.text_moment,'String',['Mxx=',num2str(tfm_para_user_para_Mxx{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_Myy,'Value')
        set(h_para.text_moment,'String',['Myy=',num2str(tfm_para_user_para_Myy{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_mu,'Value')
        set(h_para.text_moment,'String',['mu=',num2str(tfm_para_user_para_mu{tfm_para_user_counter},'%.2e'),'[Nm]']);
    end
    
    %save for shared use
    setappdata(0,'tfm_para_user_Mxx_max',tfm_para_user_Mxx_max);
    setappdata(0,'tfm_para_user_Mxy_max',tfm_para_user_Mxy_max);
    setappdata(0,'tfm_para_user_Myy_max',tfm_para_user_Myy_max);
    setappdata(0,'tfm_para_user_mu_max',tfm_para_user_mu_max);
    setappdata(0,'tfm_para_user_para_Mxx',tfm_para_user_para_Mxx);
    setappdata(0,'tfm_para_user_para_Mxy',tfm_para_user_para_Mxy);
    setappdata(0,'tfm_para_user_para_Myy',tfm_para_user_para_Myy);
    setappdata(0,'tfm_para_user_para_mu',tfm_para_user_para_mu);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_moment_addmin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Mxx_max=getappdata(0,'tfm_para_user_Mxx_max');
    tfm_para_user_Mxx_min=getappdata(0,'tfm_para_user_Mxx_min');
    tfm_para_user_Mxy_max=getappdata(0,'tfm_para_user_Mxy_max');
    tfm_para_user_Mxy_min=getappdata(0,'tfm_para_user_Mxy_min');
    tfm_para_user_Myy_max=getappdata(0,'tfm_para_user_Myy_max');
    tfm_para_user_Myy_min=getappdata(0,'tfm_para_user_Myy_min');
    tfm_para_user_mu_max=getappdata(0,'tfm_para_user_mu_max');
    tfm_para_user_mu_min=getappdata(0,'tfm_para_user_mu_min');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Mxx=getappdata(0,'tfm_para_user_Mxx');
    tfm_para_user_Mxy=getappdata(0,'tfm_para_user_Mxy');
    tfm_para_user_Myy=getappdata(0,'tfm_para_user_Myy');
    tfm_para_user_mu=getappdata(0,'tfm_para_user_mu');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Mxx=getappdata(0,'tfm_para_user_para_Mxx');
    tfm_para_user_para_Mxy=getappdata(0,'tfm_para_user_para_Mxy');
    tfm_para_user_para_Myy=getappdata(0,'tfm_para_user_para_Myy');
    tfm_para_user_para_mu=getappdata(0,'tfm_para_user_para_mu');
    
    Mxx_init=tfm_para_user_Mxx_min{tfm_para_user_counter};
    Mxy_init=tfm_para_user_Mxy_min{tfm_para_user_counter};
    Myy_init=tfm_para_user_Myy_min{tfm_para_user_counter};
    mu_init=tfm_para_user_mu_min{tfm_para_user_counter};
    
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b'), hold on;
    i1=plot(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    i2=plot(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    i3=plot(tfm_para_user_dt{tfm_para_user_counter},0,'--k');
    title('Add new minimum pts. Press "Enter" when done.')
    %[~,x,y] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    Mxx_add = zeros(size(new_x,1),2);
    Mxy_add = zeros(size(new_x,1),2);
    Myy_add = zeros(size(new_x,1),2);
    mu_add = zeros(size(new_x,1),2);
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_Mxx{tfm_para_user_counter},2)
            
            % calculate dx, dy
            dx = new_x(i)-tfm_para_user_dt{tfm_para_user_counter}(j);
            dy = (new_y(i)-tfm_para_user_Mxx{tfm_para_user_counter}(j))*1e13;
            % scale up y values?
            %
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        % add new points
        Mxx_add(i,:) = [index,tfm_para_user_Mxx{tfm_para_user_counter}(index)];
        Mxy_add(i,:) = [index,tfm_para_user_Mxy{tfm_para_user_counter}(index)];
        Myy_add(i,:) = [index,tfm_para_user_Myy{tfm_para_user_counter}(index)];
        mu_add(i,:) = [index,tfm_para_user_mu{tfm_para_user_counter}(index)];
    end
    
    %add new points
    %     Mxx_add(:,1)=x*tfm_init_user_framerate{tfm_para_user_counter};
    %     Mxx_add(:,2)=y;
    Mxx_new(:,1)=[Mxx_init(:,1);Mxx_add(:,1)];
    Mxx_new(:,2)=[Mxx_init(:,2);Mxx_add(:,2)];
    Mxy_new(:,1)=[Mxy_init(:,1);Mxy_add(:,1)];
    Mxy_new(:,2)=[Mxy_init(:,2);Mxy_add(:,2)];
    Myy_new(:,1)=[Myy_init(:,1);Myy_add(:,1)];
    Myy_new(:,2)=[Myy_init(:,2);Myy_add(:,2)];
    mu_new(:,1)=[mu_init(:,1);mu_add(:,1)];
    mu_new(:,2)=[mu_init(:,2);mu_add(:,2)];
    
    tfm_para_user_Mxx_min{tfm_para_user_counter}=Mxx_new;
    tfm_para_user_Mxy_min{tfm_para_user_counter}=Mxy_new;
    tfm_para_user_Myy_min{tfm_para_user_counter}=Myy_new;
    tfm_para_user_mu_min{tfm_para_user_counter}=mu_new;
    
    %plot contractile moment
    if get(h_para.radiobutton_Mxx,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_Myy,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Myy{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Myy_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Myy_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_mu,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_mu{tfm_para_user_counter},'-b')
        plot(tfm_para_user_mu_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_mu_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    %update para
    tfm_para_user_para_Mxx{tfm_para_user_counter}=mean(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Mxy{tfm_para_user_counter}=mean(tfm_para_user_Mxy_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Mxy_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Myy{tfm_para_user_counter}=mean(tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_mu{tfm_para_user_counter}=mean(tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'omitnan');
    
    if get(h_para.radiobutton_Mxx,'Value')
        set(h_para.text_moment,'String',['Mxx=',num2str(tfm_para_user_para_Mxx{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_Myy,'Value')
        set(h_para.text_moment,'String',['Myy=',num2str(tfm_para_user_para_Myy{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_mu,'Value')
        set(h_para.text_moment,'String',['mu=',num2str(tfm_para_user_para_mu{tfm_para_user_counter},'%.2e'),'[Nm]']);
    end
    
    %save for shared use
    setappdata(0,'tfm_para_user_Mxx_min',tfm_para_user_Mxx_min);
    setappdata(0,'tfm_para_user_Mxy_min',tfm_para_user_Mxy_min);
    setappdata(0,'tfm_para_user_Myy_min',tfm_para_user_Myy_min);
    setappdata(0,'tfm_para_user_mu_min',tfm_para_user_mu_min);
    setappdata(0,'tfm_para_user_para_Mxx',tfm_para_user_para_Mxx);
    setappdata(0,'tfm_para_user_para_Mxy',tfm_para_user_para_Mxy);
    setappdata(0,'tfm_para_user_para_Myy',tfm_para_user_para_Myy);
    setappdata(0,'tfm_para_user_para_mu',tfm_para_user_para_mu);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_moment_removemax(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Mxx_max=getappdata(0,'tfm_para_user_Mxx_max');
    tfm_para_user_Mxx_min=getappdata(0,'tfm_para_user_Mxx_min');
    tfm_para_user_Mxy_max=getappdata(0,'tfm_para_user_Mxy_max');
    tfm_para_user_Mxy_min=getappdata(0,'tfm_para_user_Mxy_min');
    tfm_para_user_Myy_max=getappdata(0,'tfm_para_user_Myy_max');
    tfm_para_user_Myy_min=getappdata(0,'tfm_para_user_Myy_min');
    tfm_para_user_mu_max=getappdata(0,'tfm_para_user_mu_max');
    tfm_para_user_mu_min=getappdata(0,'tfm_para_user_mu_min');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Mxx=getappdata(0,'tfm_para_user_Mxx');
    tfm_para_user_Mxy=getappdata(0,'tfm_para_user_Mxy');
    tfm_para_user_Myy=getappdata(0,'tfm_para_user_Myy');
    tfm_para_user_mu=getappdata(0,'tfm_para_user_mu');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Mxx=getappdata(0,'tfm_para_user_para_Mxx');
    tfm_para_user_para_Mxy=getappdata(0,'tfm_para_user_para_Mxy');
    tfm_para_user_para_Myy=getappdata(0,'tfm_para_user_para_Myy');
    tfm_para_user_para_mu=getappdata(0,'tfm_para_user_para_mu');
    
    Mxx_init=tfm_para_user_Mxx_max{tfm_para_user_counter};
    Mxy_init=tfm_para_user_Mxy_max{tfm_para_user_counter};
    Myy_init=tfm_para_user_Myy_max{tfm_para_user_counter};
    mu_init=tfm_para_user_mu_max{tfm_para_user_counter};
    
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b'); hold on;
    i2=plot(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10); hold on;
    plot(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    i3=plot(tfm_para_user_dt{tfm_para_user_counter},0,'--k');
    title('Delete maximum pts. Press "Enter" when done.')
    %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    p = zeros(1,size(new_x,1));
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_Mxx_max{tfm_para_user_counter},1)
            
            % calculate dx, dy
            dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Mxx_max{tfm_para_user_counter}(j,1);
            dy = new_y(i)-tfm_para_user_Mxx_max{tfm_para_user_counter}(j,2);
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        p(i) = index;
    end
    
    Mxx_new(:,1)=Mxx_init(:,1);
    Mxx_new(:,2)=Mxx_init(:,2);
    Mxx_new(p,:)=[];
    Mxy_new(:,1)=Mxy_init(:,1);
    Mxy_new(:,2)=Mxy_init(:,2);
    Mxy_new(p,:)=[];
    Myy_new(:,1)=Myy_init(:,1);
    Myy_new(:,2)=Myy_init(:,2);
    Myy_new(p,:)=[];
    mu_new(:,1)=mu_init(:,1);
    mu_new(:,2)=mu_init(:,2);
    mu_new(p,:)=[];
    
    tfm_para_user_Mxx_max{tfm_para_user_counter}=Mxx_new;
    tfm_para_user_Mxy_max{tfm_para_user_counter}=Mxy_new;
    tfm_para_user_Myy_max{tfm_para_user_counter}=Myy_new;
    tfm_para_user_mu_max{tfm_para_user_counter}=mu_new;
    
    %plot contractile moment
    if get(h_para.radiobutton_Mxx,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_Myy,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Myy{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Myy_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Myy_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_mu,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_mu{tfm_para_user_counter},'-b')
        plot(tfm_para_user_mu_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_mu_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    %update para
    tfm_para_user_para_Mxx{tfm_para_user_counter}=mean(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Mxy{tfm_para_user_counter}=mean(tfm_para_user_Mxy_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Mxy_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Myy{tfm_para_user_counter}=mean(tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_mu{tfm_para_user_counter}=mean(tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'omitnan');
    
    if get(h_para.radiobutton_Mxx,'Value')
        set(h_para.text_moment,'String',['Mxx=',num2str(tfm_para_user_para_Mxx{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_Myy,'Value')
        set(h_para.text_moment,'String',['Myy=',num2str(tfm_para_user_para_Myy{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_mu,'Value')
        set(h_para.text_moment,'String',['mu=',num2str(tfm_para_user_para_mu{tfm_para_user_counter},'%.2e'),'[Nm]']);
    end
    
    %save for shared use
    setappdata(0,'tfm_para_user_Mxx_max',tfm_para_user_Mxx_max);
    setappdata(0,'tfm_para_user_Mxy_max',tfm_para_user_Mxy_max);
    setappdata(0,'tfm_para_user_Myy_max',tfm_para_user_Myy_max);
    setappdata(0,'tfm_para_user_mu_max',tfm_para_user_mu_max);
    setappdata(0,'tfm_para_user_para_Mxx',tfm_para_user_para_Mxx);
    setappdata(0,'tfm_para_user_para_Mxy',tfm_para_user_para_Mxy);
    setappdata(0,'tfm_para_user_para_Myy',tfm_para_user_para_Myy);
    setappdata(0,'tfm_para_user_para_mu',tfm_para_user_para_mu);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_moment_removemin(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Mxx_max=getappdata(0,'tfm_para_user_Mxx_max');
    tfm_para_user_Mxx_min=getappdata(0,'tfm_para_user_Mxx_min');
    tfm_para_user_Mxy_max=getappdata(0,'tfm_para_user_Mxy_max');
    tfm_para_user_Mxy_min=getappdata(0,'tfm_para_user_Mxy_min');
    tfm_para_user_Myy_max=getappdata(0,'tfm_para_user_Myy_max');
    tfm_para_user_Myy_min=getappdata(0,'tfm_para_user_Myy_min');
    tfm_para_user_mu_max=getappdata(0,'tfm_para_user_mu_max');
    tfm_para_user_mu_min=getappdata(0,'tfm_para_user_mu_min');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Mxx=getappdata(0,'tfm_para_user_Mxx');
    tfm_para_user_Mxy=getappdata(0,'tfm_para_user_Mxy');
    tfm_para_user_Myy=getappdata(0,'tfm_para_user_Myy');
    tfm_para_user_mu=getappdata(0,'tfm_para_user_mu');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Mxx=getappdata(0,'tfm_para_user_para_Mxx');
    tfm_para_user_para_Mxy=getappdata(0,'tfm_para_user_para_Mxy');
    tfm_para_user_para_Myy=getappdata(0,'tfm_para_user_para_Myy');
    tfm_para_user_para_mu=getappdata(0,'tfm_para_user_para_mu');
    
    Mxx_init=tfm_para_user_Mxx_min{tfm_para_user_counter};
    Mxy_init=tfm_para_user_Mxy_min{tfm_para_user_counter};
    Myy_init=tfm_para_user_Myy_min{tfm_para_user_counter};
    mu_init=tfm_para_user_mu_min{tfm_para_user_counter};
    
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b'); hold on;
    plot(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    i2=plot(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10); hold on;
    i3=plot(tfm_para_user_dt{tfm_para_user_counter},0,'--k');
    title('Delete minimum pts. Press "Enter" when done.')
    %[p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    [new_x,new_y] = getpts;
    close(hf);
    
    p = zeros(1,size(new_x,1));
    
    %find closest points
    for i = 1:size(new_x,1)
        
        for j = 1:size(tfm_para_user_Mxx_min{tfm_para_user_counter},1)
            
            % calculate dx, dy
            dx = new_x(i)*tfm_init_user_framerate{tfm_para_user_counter}-tfm_para_user_Mxx_min{tfm_para_user_counter}(j,1);
            dy = new_y(i)-tfm_para_user_Mxx_min{tfm_para_user_counter}(j,2);
            
            % calculate distance
            d(j) = sqrt(dx^2+dy^2);
        end
        % find index of min(d)
        [~,index] = min(d);
        p(i) = index;
    end
    
    Mxx_new(:,1)=Mxx_init(:,1);
    Mxx_new(:,2)=Mxx_init(:,2);
    Mxx_new(p,:)=[];
    Mxy_new(:,1)=Mxy_init(:,1);
    Mxy_new(:,2)=Mxy_init(:,2);
    Mxy_new(p,:)=[];
    Myy_new(:,1)=Myy_init(:,1);
    Myy_new(:,2)=Myy_init(:,2);
    Myy_new(p,:)=[];
    mu_new(:,1)=mu_init(:,1);
    mu_new(:,2)=mu_init(:,2);
    mu_new(p,:)=[];
    
    tfm_para_user_Mxx_min{tfm_para_user_counter}=Mxx_new;
    tfm_para_user_Mxy_min{tfm_para_user_counter}=Mxy_new;
    tfm_para_user_Myy_min{tfm_para_user_counter}=Myy_new;
    tfm_para_user_mu_min{tfm_para_user_counter}=mu_new;
    
    %plot contractile moment
    if get(h_para.radiobutton_Mxx,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_Myy,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Myy{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Myy_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Myy_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_mu,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_mu{tfm_para_user_counter},'-b')
        plot(tfm_para_user_mu_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_mu_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    %update para
    tfm_para_user_para_Mxx{tfm_para_user_counter}=mean(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Mxy{tfm_para_user_counter}=mean(tfm_para_user_Mxy_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Mxy_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Myy{tfm_para_user_counter}=mean(tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_mu{tfm_para_user_counter}=mean(tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'omitnan');
    
    if get(h_para.radiobutton_Mxx,'Value')
        set(h_para.text_moment,'String',['Mxx=',num2str(tfm_para_user_para_Mxx{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_Myy,'Value')
        set(h_para.text_moment,'String',['Myy=',num2str(tfm_para_user_para_Myy{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_mu,'Value')
        set(h_para.text_moment,'String',['mu=',num2str(tfm_para_user_para_mu{tfm_para_user_counter},'%.2e'),'[Nm]']);
    end
    
    %save for shared use
    setappdata(0,'tfm_para_user_Mxx_min',tfm_para_user_Mxx_min);
    setappdata(0,'tfm_para_user_Mxy_min',tfm_para_user_Mxy_min);
    setappdata(0,'tfm_para_user_Myy_min',tfm_para_user_Myy_min);
    setappdata(0,'tfm_para_user_mu_min',tfm_para_user_mu_min);
    setappdata(0,'tfm_para_user_para_Mxx',tfm_para_user_para_Mxx);
    setappdata(0,'tfm_para_user_para_Mxy',tfm_para_user_para_Mxy);
    setappdata(0,'tfm_para_user_para_Myy',tfm_para_user_para_Myy);
    setappdata(0,'tfm_para_user_para_mu',tfm_para_user_para_mu);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_moment_clearall(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load shared needed para
    tfm_para_user_Mxx_max=getappdata(0,'tfm_para_user_Mxx_max');
    tfm_para_user_Mxx_min=getappdata(0,'tfm_para_user_Mxx_min');
    tfm_para_user_Mxy_max=getappdata(0,'tfm_para_user_Mxy_max');
    tfm_para_user_Mxy_min=getappdata(0,'tfm_para_user_Mxy_min');
    tfm_para_user_Myy_max=getappdata(0,'tfm_para_user_Myy_max');
    tfm_para_user_Myy_min=getappdata(0,'tfm_para_user_Myy_min');
    tfm_para_user_mu_max=getappdata(0,'tfm_para_user_mu_max');
    tfm_para_user_mu_min=getappdata(0,'tfm_para_user_mu_min');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Mxx=getappdata(0,'tfm_para_user_Mxx');
    tfm_para_user_Mxy=getappdata(0,'tfm_para_user_Mxy');
    tfm_para_user_Myy=getappdata(0,'tfm_para_user_Myy');
    tfm_para_user_mu=getappdata(0,'tfm_para_user_mu');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Mxx=getappdata(0,'tfm_para_user_para_Mxx');
    tfm_para_user_para_Mxy=getappdata(0,'tfm_para_user_para_Mxy');
    tfm_para_user_para_Myy=getappdata(0,'tfm_para_user_para_Myy');
    tfm_para_user_para_mu=getappdata(0,'tfm_para_user_para_mu');
    
    %plot contractile moment
    if get(h_para.radiobutton_Mxx,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b')
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_Myy,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Myy{tfm_para_user_counter},'-b')
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_mu,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_mu{tfm_para_user_counter},'-b')
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    %delete min and max
    tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2)=NaN;
    tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2)=NaN;
    tfm_para_user_Mxy_min{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_Mxy_min{tfm_para_user_counter}(:,2)=NaN;
    tfm_para_user_Mxy_max{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_Mxy_max{tfm_para_user_counter}(:,2)=NaN;
    tfm_para_user_Myy_min{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_Myy_min{tfm_para_user_counter}(:,2)=NaN;
    tfm_para_user_Myy_max{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_Myy_max{tfm_para_user_counter}(:,2)=NaN;
    tfm_para_user_mu_min{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_mu_min{tfm_para_user_counter}(:,2)=NaN;
    tfm_para_user_mu_max{tfm_para_user_counter}(:,1)=NaN;
    tfm_para_user_mu_max{tfm_para_user_counter}(:,2)=NaN;
    
    %update para
    tfm_para_user_para_Mxx{tfm_para_user_counter}=mean(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Mxy{tfm_para_user_counter}=mean(tfm_para_user_Mxy_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Mxy_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_Myy{tfm_para_user_counter}=mean(tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'omitnan');
    tfm_para_user_para_mu{tfm_para_user_counter}=mean(tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'omitnan')-mean(tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'omitnan');
    
    if get(h_para.radiobutton_Mxx,'Value')
        set(h_para.text_moment,'String',['Mxx=',num2str(tfm_para_user_para_Mxx{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_Myy,'Value')
        set(h_para.text_moment,'String',['Myy=',num2str(tfm_para_user_para_Myy{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_mu,'Value')
        set(h_para.text_moment,'String',['mu=',num2str(tfm_para_user_para_mu{tfm_para_user_counter},'%.2e'),'[Nm]']);
    end
    
    %save for shared use
    setappdata(0,'tfm_para_user_Mxx_min',tfm_para_user_Mxx_min);
    setappdata(0,'tfm_para_user_Mxx_max',tfm_para_user_Mxx_max);
    setappdata(0,'tfm_para_user_Mxy_min',tfm_para_user_Mxy_min);
    setappdata(0,'tfm_para_user_Mxy_max',tfm_para_user_Mxy_max);
    setappdata(0,'tfm_para_user_Myy_min',tfm_para_user_Myy_min);
    setappdata(0,'tfm_para_user_Myy_max',tfm_para_user_Myy_max);
    setappdata(0,'tfm_para_user_mu_min',tfm_para_user_mu_min);
    setappdata(0,'tfm_para_user_mu_max',tfm_para_user_mu_max);
    setappdata(0,'tfm_para_user_para_Mxx',tfm_para_user_para_Mxx);
    setappdata(0,'tfm_para_user_para_Mxy',tfm_para_user_para_Mxy);
    setappdata(0,'tfm_para_user_para_Myy',tfm_para_user_para_Myy);
    setappdata(0,'tfm_para_user_para_mu',tfm_para_user_para_mu);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_double(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));
% or after ok?

try
    % load data
    tfm_para_user_para_tagdp=getappdata(0,'tfm_para_user_para_tagdp');
    dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_tdp=getappdata(0,'tfm_para_user_tdp');
    tfm_para_user_para_tdp=getappdata(0,'tfm_para_user_para_tdp');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_disp_l=getappdata(0,'tfm_para_user_disp_l')
    
    % open fig
    figsize=[308,270];
    %get screen size
    screensize = get(0,'ScreenSize');
    %position fig on center of screen
    xpos = ceil((screensize(3)-figsize(2))/2);
    ypos = ceil((screensize(4)-figsize(1))/2);
    dp_fig(1).fig=figure('position',[xpos,ypos,figsize(1),figsize(2)],...
        'NumberTitle','off',...
        'Name','Double Peaks',...
        'MenuBar','none',...
        'units','pixels',...
        'renderer','OpenGL',...
        'PaperPositionMode','auto',...
        'Resize','off',...
        'Color',[.2,.2,.2],...
        'visible','off');

    pcolor = [.2 .2 .2];
    ptcolor = [1 1 1];
    bcolor = [.3 .3 .3];
    btcolor = [1 1 1];
    dp_fig(1).ForegroundColor = ptcolor;
    dp_fig(1).BackgroundColor = pcolor;
    
    %uipanel for double peaks
    dp_fig(1).panel_dp = uipanel('Parent',dp_fig(1).fig,'units','pixels','Position',[5,5,300,260],'BorderType','none');
    dp_fig(1).panel_dp.ForegroundColor = ptcolor;
    dp_fig(1).panel_dp.BackgroundColor = pcolor;
    %text: dp?
    dp_fig(1).text_dp = uicontrol('Parent',dp_fig(1).panel_dp,'style','text','position',[5,230,150,15],'HorizontalAlignment','left','string','Are there double peaks?');
    dp_fig(1).text_dp.ForegroundColor = ptcolor;
    dp_fig(1).text_dp.BackgroundColor = pcolor;
    %checkbox: yes
    dp_fig(1).checkbox_dpyes = uicontrol('Parent',dp_fig(1).panel_dp,'style','checkbox','position',[160,225,50,25],'string','Yes','HorizontalAlignment','left');
    dp_fig(1).checkbox_dpyes.ForegroundColor = ptcolor;
    dp_fig(1).checkbox_dpyes.BackgroundColor = pcolor;
    %checkbox: no
    dp_fig(1).checkbox_dpno = uicontrol('Parent',dp_fig(1).panel_dp,'style','checkbox','position',[220,225,50,25],'string','No','HorizontalAlignment','left');
    dp_fig(1).checkbox_dpno.ForegroundColor = ptcolor;
    dp_fig(1).checkbox_dpno.BackgroundColor = pcolor;
    %uipanel for dp para
    dp_fig(1).panel_dp2 = uipanel('Parent',dp_fig(1).panel_dp,'units','pixels','Position',[5,35,290,190],'BorderType','none');
    dp_fig(1).panel_dp2.ForegroundColor = ptcolor;
    dp_fig(1).panel_dp2.BackgroundColor = pcolor;
    %axes
    dp_fig(1).axes_dp2 = axes('Parent',dp_fig(1).panel_dp2,'Units', 'pixels','Position',[5,65,277,115],'box','on');
    %text: time betw main&sec
    dp_fig(1).text_dp2_1 = uicontrol('Parent',dp_fig(1).panel_dp2,'style','text','position',[5,45,200,15],'HorizontalAlignment','left','string','Time main-sec. peak');
    dp_fig(1).text_dp2_1.ForegroundColor = ptcolor;
    dp_fig(1).text_dp2_1.BackgroundColor = pcolor;
    %button: add
    dp_fig(1).button_dp2_add = uicontrol('Parent',dp_fig(1).panel_dp2,'style','pushbutton','position',[5,25,70,20],'string','Add');
    %button: remove
    dp_fig(1).button_dp2_remove = uicontrol('Parent',dp_fig(1).panel_dp2,'style','pushbutton','position',[5,5,70,20],'string','Remove');
    %button: clearall
    dp_fig(1).button_dp2_clearall = uicontrol('Parent',dp_fig(1).panel_dp2,'style','pushbutton','position',[75,5,35,40],'string','Clear');
    %text: t
    dp_fig(1).text_dp2_2 = uicontrol('Parent',dp_fig(1).panel_dp2,'style','text','position',[160,45,110,15],'HorizontalAlignment','left','string','t = ');
    dp_fig(1).text_dp2_2.ForegroundColor = ptcolor;
    dp_fig(1).text_dp2_2.BackgroundColor = pcolor;
    %text: ratio peaks
    dp_fig(1).text_dp2_3 = uicontrol('Parent',dp_fig(1).panel_dp2,'style','text','position',[160,25,120,15],'HorizontalAlignment','left','string','Ratio normal/double');
    dp_fig(1).text_dp2_3.ForegroundColor = ptcolor;
    dp_fig(1).text_dp2_3.BackgroundColor = pcolor;
    %edit: ratio peaks
    dp_fig(1).edit_dp2 = uicontrol('Parent',dp_fig(1).panel_dp2,'style','edit','position',[160,5,120,20]);
    %button: ok
    dp_fig(1).button_dp_ok = uicontrol('Parent',dp_fig(1).panel_dp,'style','pushbutton','position',[210,5,80,25],'string','OK');
    %
    
    if tfm_para_user_para_tagdp{tfm_para_user_counter} == 1
        set(dp_fig(1).checkbox_dpyes,'value',1)
    else
        set(dp_fig(1).checkbox_dpno,'value',1)
    end
    
    set(dp_fig(1).text_dp2_2,'String',['t=',num2str(tfm_para_user_para_tdp{tfm_para_user_counter},'%.2e'),'[s]']);
    
    %plot displacements
    %displ. in double peak
    cla(dp_fig(1).axes_dp2)
    axes(dp_fig(1).axes_dp2)
    plot(dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    plot(dt{tfm_para_user_counter},tfm_para_user_disp_l*ones(size(dt{tfm_para_user_counter},2),1)',':m'), hold on;
    text(dt{tfm_para_user_counter}(1),tfm_para_user_disp_l*1e6,[num2str(tfm_para_user_disp_l) '[m]'],'FontSize',10);
    plot(tfm_para_user_tdp{tfm_para_user_counter}(:,1),tfm_para_user_tdp{tfm_para_user_counter}(:,3),'.r','MarkerSize',10)
    plot(tfm_para_user_tdp{tfm_para_user_counter}(:,2),tfm_para_user_tdp{tfm_para_user_counter}(:,4),'.r','MarkerSize',10)
    %plot delta t
    dtcontr=zeros(1,size(tfm_para_user_tdp{tfm_para_user_counter},1));
    for i=1:size(tfm_para_user_tdp{tfm_para_user_counter},1)
        dtcontr(1,i)=abs(tfm_para_user_tdp{tfm_para_user_counter}(i,2)-tfm_para_user_tdp{tfm_para_user_counter}(i,1));
        plot(linspace(tfm_para_user_tdp{tfm_para_user_counter}(i,1),tfm_para_user_tdp{tfm_para_user_counter}(i,2),100),linspace(0,0,100),'r','LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %set callbacks
    set(dp_fig(1).checkbox_dpyes,'callback',{@para_checkbox_dpyes,dp_fig})
    set(dp_fig(1).checkbox_dpno,'callback',{@para_checkbox_dpno,dp_fig})
    set(dp_fig(1).button_dp2_add,'callback',{@para_push_dp2_add,dp_fig})
    set(dp_fig(1).button_dp2_remove,'callback',{@para_push_dp2_remove,dp_fig})
    set(dp_fig(1).button_dp2_clearall,'callback',{@para_push_dp2_clearall,dp_fig})
    set(dp_fig(1).button_dp_ok,'callback',{@para_push_dpok,dp_fig})
    %
    
    setappdata(0,'dp_fig',dp_fig)
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_dp2_add(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_tdp=getappdata(0,'tfm_para_user_tdp');
    tfm_para_user_para_tdp=getappdata(0,'tfm_para_user_para_tdp');
    
    t_init=tfm_para_user_tdp{tfm_para_user_counter};
    
    hf=figure;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    i1=plot(t_init(:,1),t_init(:,3),'.r','MarkerSize',10);
    i2=plot(t_init(:,2),t_init(:,4),'.r','MarkerSize',10);
    title('Add new primary peak')
    [~,x1,y1] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    cla;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    i1=plot(t_init(:,1),t_init(:,3),'.r','MarkerSize',10);
    i2=plot(t_init(:,2),t_init(:,4),'.r','MarkerSize',10);
    i3=plot(x1,y1,'.g','MarkerSize',10); hold on;
    title('Add corresponding secondary peak')
    [~,x2,y2] = selectdata('SelectionMode','closest','Ignore',[i1,i2,i3]);
    close(hf);
    
    t_add(:,1)=x1;
    t_add(:,2)=x2;
    t_add(:,3)=y1;
    t_add(:,4)=y2;
    t_new(:,1)=[t_init(:,1);t_add(:,1)];
    t_new(:,2)=[t_init(:,2);t_add(:,2)];
    t_new(:,3)=[t_init(:,3);t_add(:,3)];
    t_new(:,4)=[t_init(:,4);t_add(:,4)];
    
    %displ. in double peak
    cla(h_para.axes_dp2)
    axes(h_para.axes_dp2)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    plot(t_new(:,1),t_new(:,3),'.r','MarkerSize',10)
    plot(t_new(:,2),t_new(:,4),'.r','MarkerSize',10)
    %plot delta t
    dtcontr=zeros(1,size(t_new,1));
    for i=1:size(t_new,1)
        dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
        plot(linspace(t_new(i,1),t_new(i,2),100),linspace(0,0,100),'r','LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %save new pt vector
    tfm_para_user_tdp{tfm_para_user_counter}=t_new;
    tfm_para_user_para_tdp{tfm_para_user_counter}=mean(dtcontr,'omitnan');
    set(h_para.text_dp2_2,'String',['t=',num2str(tfm_para_user_para_tdp{tfm_para_user_counter},'%.2e'),'[s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_tdp',tfm_para_user_tdp);
    setappdata(0,'tfm_para_user_para_tdp',tfm_para_user_para_tdp);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_dp2_remove(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_tdp=getappdata(0,'tfm_para_user_tdp');
    tfm_para_user_para_tdp=getappdata(0,'tfm_para_user_para_tdp');
    
    t_init=tfm_para_user_tdp{tfm_para_user_counter};
    
    hf=figure;
    i1=plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'); hold on;
    plot(t_init(:,1),t_init(:,3),'.r','MarkerSize',10);
    i2=plot(t_init(:,2),t_init(:,4),'.r','MarkerSize',10);
    title('Delte maximum pt.')
    [p,~,~] = selectdata('SelectionMode','closest','Ignore',[i1,i2]);
    close(hf);
    
    t_new(:,1)=t_init(:,1);
    t_new(:,2)=t_init(:,2);
    t_new(:,3)=t_init(:,3);
    t_new(:,4)=t_init(:,4);
    t_new(p,:)=[];
    
    %displ. in double peak
    cla(h_para.axes_dp2)
    axes(h_para.axes_dp2)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    plot(t_new(:,1),t_new(:,3),'.r','MarkerSize',10)
    plot(t_new(:,2),t_new(:,4),'.r','MarkerSize',10)
    %plot delta t
    dtcontr=zeros(1,size(t_new,1));
    for i=1:size(t_new,1)
        dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
        plot(linspace(t_new(i,1),t_new(i,2),100),linspace(0,0,100),'r','LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %save new pt vector
    tfm_para_user_tdp{tfm_para_user_counter}=t_new;
    tfm_para_user_para_tdp{tfm_para_user_counter}=mean(dtcontr,'omitnan');
    set(h_para.text_dp2_2,'String',['t=',num2str(tfm_para_user_para_tdp{tfm_para_user_counter},'%.2e'),'[s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_tdp',tfm_para_user_tdp);
    setappdata(0,'tfm_para_user_para_tdp',tfm_para_user_para_tdp);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_dp2_clearall(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_tdp=getappdata(0,'tfm_para_user_tdp');
    tfm_para_user_para_tdp=getappdata(0,'tfm_para_user_para_tdp');
    
    t_new(:,1)=NaN;
    t_new(:,2)=NaN;
    t_new(:,3)=NaN;
    t_new(:,4)=NaN;
    
    cla(h_para.axes_dp2)
    axes(h_para.axes_dp2)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    
    dtcontr=zeros(1,size(t_new,1));
    for i=1:size(t_new,1)
        dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
        plot(linspace(t_new(i,1),t_new(i,2),100),linspace(0,0,100),'r','LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %save new pt vector
    tfm_para_user_tdp{tfm_para_user_counter}=t_new;
    tfm_para_user_para_tdp{tfm_para_user_counter}=mean(dtcontr,'omitnan');
    set(h_para.text_dp2_2,'String',['t=',num2str(tfm_para_user_para_tdp{tfm_para_user_counter},'%.2e'),'[s]']);
    
    %save for shared use
    setappdata(0,'tfm_para_user_tdp',tfm_para_user_tdp);
    setappdata(0,'tfm_para_user_para_tdp',tfm_para_user_para_tdp);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_dpok(hObject, eventdata, h_para)

dp_fig=getappdata(0,'dp_fig');
close(dp_fig)



function para_push_forwards(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load what shared para we need
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    dmax=getappdata(0,'tfm_para_user_dmax');
    dmin=getappdata(0,'tfm_para_user_dmin');
    vmax=getappdata(0,'tfm_para_user_vmax');
    vmin=getappdata(0,'tfm_para_user_vmin');
    dt=getappdata(0,'tfm_para_user_dt');
    Velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_para_Deltad=getappdata(0,'tfm_para_user_para_Deltad');
    tfm_para_user_para_vcontr=getappdata(0,'tfm_para_user_para_vcontr');
    tfm_para_user_para_vrelax=getappdata(0,'tfm_para_user_para_vrelax');
    tfm_para_user_tcontr=getappdata(0,'tfm_para_user_tcontr');
    tfm_para_user_para_tcontr=getappdata(0,'tfm_para_user_para_tcontr');
    tfm_para_user_tdp=getappdata(0,'tfm_para_user_tdp');
    tfm_para_user_para_tdp=getappdata(0,'tfm_para_user_para_tdp');
    tfm_para_user_freq2=getappdata(0,'tfm_para_user_freq2');
    tfm_para_user_para_freq2=getappdata(0,'tfm_para_user_para_freq2');
    tfm_para_user_para_freq=getappdata(0,'tfm_para_user_para_freq');
    tfm_para_user_para_freqy=getappdata(0,'tfm_para_user_para_freqy');
    freq=getappdata(0,'tfm_para_user_freq');
    y_fft=getappdata(0,'tfm_para_user_y_fft');
    tfm_para_user_para_ratiop=getappdata(0,'tfm_para_user_para_ratiop');
    tfm_para_user_para_ratiodp=getappdata(0,'tfm_para_user_para_ratiodp');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_para_user_para_tagdp=getappdata(0,'tfm_para_user_para_tagdp');
    tfm_para_user_discard_tag=getappdata(0,'tfm_para_user_discard_tag');
    tfm_para_user_dbl_tag=getappdata(0,'tfm_para_user_dbl_tag');
    tfm_para_user_drift_tag=getappdata(0,'tfm_para_user_drift_tag');
    tfm_para_user_other_tag=getappdata(0,'tfm_para_user_other_tag');
    tfm_para_user_other_comments=getappdata(0,'tfm_para_user_other_comments');
    tfm_para_user_Fmax=getappdata(0,'tfm_para_user_Fmax');
    tfm_para_user_Fmin=getappdata(0,'tfm_para_user_Fmin');
    tfm_para_user_F_tot=getappdata(0,'tfm_para_user_F_tot');
    tfm_para_user_para_DeltaF=getappdata(0,'tfm_para_user_para_DeltaF');
    tfm_para_user_Fxmax=getappdata(0,'tfm_para_user_Fxmax');
    tfm_para_user_Fxmin=getappdata(0,'tfm_para_user_Fxmin');
    tfm_para_user_Fx_tot=getappdata(0,'tfm_para_user_Fx_tot');
    tfm_para_user_para_DeltaFx=getappdata(0,'tfm_para_user_para_DeltaFx');
    tfm_para_user_Fymax=getappdata(0,'tfm_para_user_Fymax');
    tfm_para_user_Fymin=getappdata(0,'tfm_para_user_Fymin');
    tfm_para_user_Fy_tot=getappdata(0,'tfm_para_user_Fy_tot');
    tfm_para_user_para_DeltaFy=getappdata(0,'tfm_para_user_para_DeltaFy');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_Pmax=getappdata(0,'tfm_para_user_Pmax');
    tfm_para_user_Pmin=getappdata(0,'tfm_para_user_Pmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_power=getappdata(0,'tfm_para_user_power');
    tfm_para_user_para_Pcontr=getappdata(0,'tfm_para_user_para_Pcontr');
    tfm_para_user_para_Prelax=getappdata(0,'tfm_para_user_para_Prelax');
    tfm_para_user_U=getappdata(0,'tfm_para_user_U');
    tfm_para_user_Umax=getappdata(0,'tfm_para_user_Umax');
    tfm_para_user_Umin=getappdata(0,'tfm_para_user_Umin');
    tfm_para_user_para_U=getappdata(0,'tfm_para_user_para_U');
    tfm_para_user_Mxx=getappdata(0,'tfm_para_user_Mxx');
    tfm_para_user_Mxy=getappdata(0,'tfm_para_user_Mxy');
    tfm_para_user_Myx=getappdata(0,'tfm_para_user_Myx');
    tfm_para_user_Myy=getappdata(0,'tfm_para_user_Myy');
    tfm_para_user_mu=getappdata(0,'tfm_para_user_mu');
    tfm_para_user_Mxx_max=getappdata(0,'tfm_para_user_Mxx_max');
    tfm_para_user_Mxx_min=getappdata(0,'tfm_para_user_Mxx_min');
    tfm_para_user_Mxy_max=getappdata(0,'tfm_para_user_Mxy_max');
    tfm_para_user_Mxy_min=getappdata(0,'tfm_para_user_Mxy_min');
    tfm_para_user_Myy_max=getappdata(0,'tfm_para_user_Myy_max');
    tfm_para_user_Myy_min=getappdata(0,'tfm_para_user_Myy_min');
    tfm_para_user_mu_max=getappdata(0,'tfm_para_user_mu_max');
    tfm_para_user_mu_min=getappdata(0,'tfm_para_user_mu_min');
    tfm_para_user_para_Mxx=getappdata(0,'tfm_para_user_para_Mxx');
    tfm_para_user_para_Mxy=getappdata(0,'tfm_para_user_para_Mxy');
    tfm_para_user_para_Myy=getappdata(0,'tfm_para_user_para_Myy');
    tfm_para_user_para_mu=getappdata(0,'tfm_para_user_para_mu');
    tfm_para_user_dtheta=getappdata(0,'tfm_para_user_dtheta');
    tfm_para_user_center=getappdata(0,'tfm_para_user_center');
    tfm_para_user_d_s=getappdata(0,'tfm_para_user_d_s');
    tfm_para_user_d_pav=getappdata(0,'tfm_para_user_d_pav');
    tfm_para_user_F_s=getappdata(0,'tfm_para_user_F_s');
    tfm_para_user_F_pav=getappdata(0,'tfm_para_user_F_pav');
    tfm_para_user_disp_l = getappdata(0,'tfm_para_user_disp_l');
    
    %save current stuff
    tfm_para_user_other_comments{tfm_para_user_counter}=get(h_para.edit_other,'String');
    tfm_para_user_para_ratiop{tfm_para_user_counter}=str2double(get(h_para.edit_ratio,'String'));
    %     if tfm_para_user_para_tagdp{tfm_para_user_counter}
    %         tfm_para_user_para_ratiodp{tfm_para_user_counter}=str2double(get(h_para.edit_dp2,'String'));
    %     end
    
    %go to video before
    tfm_para_user_counter=tfm_para_user_counter+1;
    
    %set tags
    set(h_para.edit_ratio,'String',num2str(tfm_para_user_para_ratiop{tfm_para_user_counter}));
    %     if tfm_para_user_para_tagdp{tfm_para_user_counter}
    %         set(h_para.edit_dp2,'String',num2str(tfm_para_user_para_ratiodp{tfm_para_user_counter}));
    %     end
    %checkboxes
    if tfm_para_user_discard_tag{tfm_para_user_counter}
        set(h_para.checkbox_disc,'Value',1)
    else
        set(h_para.checkbox_disc,'Value',0)
    end
    if tfm_para_user_dbl_tag{tfm_para_user_counter}
        set(h_para.checkbox_dbl,'Value',1)
    else
        set(h_para.checkbox_dbl,'Value',0)
    end
    if tfm_para_user_drift_tag{tfm_para_user_counter}
        set(h_para.checkbox_drift,'Value',1)
    else
        set(h_para.checkbox_drift,'Value',0)
    end
    if tfm_para_user_other_tag{tfm_para_user_counter}
        set(h_para.checkbox_other,'Value',1)
    else
        set(h_para.checkbox_other,'Value',0)
    end
    set(h_para.edit_other,'String',tfm_para_user_other_comments{tfm_para_user_counter})
    %     if tfm_para_user_para_tagdp{tfm_para_user_counter}
    %         set(h_para.panel_dp2,'Visible','on')
    %         set(h_para.checkbox_dpyes,'Value',1)
    %         set(h_para.checkbox_dpno,'Value',0)
    %     else
    %         set(h_para.checkbox_dpyes,'Value',0)
    %         set(h_para.checkbox_dpno,'Value',1)
    %         set(h_para.panel_dp2,'Visible','off')
    %     end
    
    %display plots
    %plot 1st displ. in axes
    cla(h_para.axes_disp)
    axes(h_para.axes_disp)
    plot(dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    plot(dt{tfm_para_user_counter},tfm_para_user_disp_l*ones(size(dt{tfm_para_user_counter},2),1)',':m'), hold on;
    text(dt{tfm_para_user_counter}(1),tfm_para_user_disp_l*1e6,[num2str(tfm_para_user_disp_l) '[m]'],'FontSize',10);
    plot(dmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},dmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(dmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},dmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    %JFM
    %set(gca, 'YTick', []);
    ylim([0 5e-8]);
    
    %     %displ. in double peak
    %     cla(h_para.axes_dp2)
    %     axes(h_para.axes_dp2)
    %     plot(dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    %     plot(tfm_para_user_tdp{tfm_para_user_counter}(:,1),tfm_para_user_tdp{tfm_para_user_counter}(:,3),'.r','MarkerSize',10)
    %     plot(tfm_para_user_tdp{tfm_para_user_counter}(:,2),tfm_para_user_tdp{tfm_para_user_counter}(:,4),'.r','MarkerSize',10)
    %     %plot delta t
    %     dtcontr=zeros(1,size(tfm_para_user_tdp{tfm_para_user_counter},1));
    %     for i=1:size(tfm_para_user_tdp{tfm_para_user_counter},1)
    %         dtcontr(1,i)=abs(tfm_para_user_tdp{tfm_para_user_counter}(i,2)-tfm_para_user_tdp{tfm_para_user_counter}(i,1));
    %         plot(linspace(tfm_para_user_tdp{tfm_para_user_counter}(i,1),tfm_para_user_tdp{tfm_para_user_counter}(i,2),100),linspace(0,0,100),'r','LineWidth',5)
    %     end
    %     set(gca, 'XTick', []);
    %     set(gca, 'YTick', []);
    
    %plot 1st velocity. in axes
    cla(h_para.axes_vel)
    axes(h_para.axes_vel)
    plot(dt{tfm_para_user_counter},zeros(1,length(dt{tfm_para_user_counter})),'--k'), hold on;
    plot(dt{tfm_para_user_counter},Velocity{tfm_para_user_counter},'-b'), hold on;
    plot(vmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},vmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(vmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},vmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    for i = 1:length(tfm_para_user_tcontr{tfm_para_user_counter}(:,1))
        plot(linspace(tfm_para_user_tcontr{tfm_para_user_counter}(i,1),tfm_para_user_tcontr{tfm_para_user_counter}(i,2),2),linspace(0,0,2),'r','LineWidth',5);
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %%plot 1st velocity. in axes
    cla(h_para.axes_contr)
    axes(h_para.axes_contr)
    plot(dt{tfm_para_user_counter},Velocity{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_tcontr{tfm_para_user_counter}(:,1),tfm_para_user_tcontr{tfm_para_user_counter}(:,3),'.r','MarkerSize',10)
    plot(tfm_para_user_tcontr{tfm_para_user_counter}(:,2),tfm_para_user_tcontr{tfm_para_user_counter}(:,4),'.r','MarkerSize',10)
    %plot delta t
    dtcontr=zeros(1,size(tfm_para_user_tcontr{tfm_para_user_counter},1));
    for i=1:size(tfm_para_user_tcontr{tfm_para_user_counter},1)
        dtcontr(1,i)=abs(tfm_para_user_tcontr{tfm_para_user_counter}(i,2)-tfm_para_user_tcontr{tfm_para_user_counter}(i,1));
        plot(linspace(tfm_para_user_tcontr{tfm_para_user_counter}(i,1),tfm_para_user_tcontr{tfm_para_user_counter}(i,2),2),linspace(0,0,2),'r','LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %plot strain energy
    reset(h_para.axes_strain)
    axes(h_para.axes_strain)
    plot(dt{tfm_para_user_counter},tfm_para_user_U{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_Umin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(tfm_para_user_Umax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %plot contractile moment
    if get(h_para.radiobutton_Mxx,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_Myy,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Myy{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Myy_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Myy_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_mu,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_mu{tfm_para_user_counter},'-b')
        plot(tfm_para_user_mu_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_mu_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    % sort center, orient by displacement
    [d_sort,di] = sort(tfm_para_user_d{tfm_para_user_counter});
    center_sort = tfm_para_user_center{tfm_para_user_counter}(di,:);
    theta_sort = tfm_para_user_dtheta{tfm_para_user_counter}(di);
    Mxx_sort = tfm_para_user_Mxx{tfm_para_user_counter}(di);
    
    if get(h_para.radiobutton_center,'Value')
        %plot center of contraction
        reset(h_para.axes_orient)
        axes(h_para.axes_orient)
        [theta_center,r_center] = cart2pol(center_sort(:,1),center_sort(:,2));
        polarscatter(theta_center,r_center,10,d_sort,'filled');
        %set(gca, 'RTickLabel', []);
        set(gca, 'ThetaTickLabel', []);
        colorbar('southoutside','TickLabels',[])
        rlim([0 5e-6]);
        rticks([2.5e-6 5e-6]);
        rticklabels({'r = 2.5e-6 [m]',''});
    elseif get(h_para.radiobutton_orient,'Value')
        %plot traction orientation
        reset(h_para.axes_orient)
        axes(h_para.axes_orient)
        polarscatter(theta_sort.*(pi/180),Mxx_sort,10,d_sort,'filled');
        set(gca, 'RTickLabel', []);
        set(gca, 'ThetaTickLabel', []);
        colorbar('southoutside','TickLabels',[]);
    end
    
    %plot peak averaging results
    %displacement
    reset(h_para.axes_disp_autocor)
    axes(h_para.axes_disp_autocor)
    if ~isnan(tfm_para_user_d_pav{tfm_para_user_counter}.n_peaks)
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.peak_wins_t,tfm_para_user_d_pav{tfm_para_user_counter}.av_peak), hold on;
        area(tfm_para_user_d_pav{tfm_para_user_counter}.t_peak,tfm_para_user_d_pav{tfm_para_user_counter}.av_peak+tfm_para_user_d_pav{tfm_para_user_counter}.av_peak_std,min(tfm_para_user_d_pav{tfm_para_user_counter}.av_peak-tfm_para_user_d_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[0.8 0.8 0.8],'FaceAlpha',0.5,'EdgeColor','none');
        area(tfm_para_user_d_pav{tfm_para_user_counter}.t_peak,tfm_para_user_d_pav{tfm_para_user_counter}.av_peak-tfm_para_user_d_pav{tfm_para_user_counter}.av_peak_std,min(tfm_para_user_d_pav{tfm_para_user_counter}.av_peak-tfm_para_user_d_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[1 1 1],'FaceAlpha',1,'EdgeColor','none');
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max_t/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_d_pav{tfm_para_user_counter}.av_peak(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max_t),'^k','MarkerSize',5);
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min_t/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_d_pav{tfm_para_user_counter}.av_peak(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min_t),'vk','MarkerSize',5);
        plot([tfm_para_user_d_pav{tfm_para_user_counter}.peak_max_t-floor(floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/4)):tfm_para_user_d_pav{tfm_para_user_counter}.peak_max_t+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/4)]/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_d_pav{tfm_para_user_counter}.peak_max*ones(1,(tfm_para_user_d_pav{tfm_para_user_counter}.peak_max_t+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/4))-(tfm_para_user_d_pav{tfm_para_user_counter}.peak_max_t-floor(floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/4)))+1),':k');
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.peak_wins_t,tfm_para_user_d_pav{tfm_para_user_counter}.peak_basel*ones(1,tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l),':k');
        plot([tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max_t-floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6):tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max_t+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6)]/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max*tfm_para_user_d_pav{tfm_para_user_counter}.d_t_peak(1)*[-floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6):+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6)]+tfm_para_user_d_pav{tfm_para_user_counter}.av_peak(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max_t),':k');
        plot([tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min_t-floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6):tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min_t+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6)]/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min*tfm_para_user_d_pav{tfm_para_user_counter}.d_t_peak(1)*[-floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6):+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6)]+tfm_para_user_d_pav{tfm_para_user_counter}.av_peak(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min_t),':k');
        set(gca,'XLim',[0 tfm_para_user_d_pav{tfm_para_user_counter}.peak_wins_t(end)]);
        if ~isnan(tfm_para_user_d_pav{tfm_para_user_counter}.peak_max)
            set(gca,'YLim',[-1.1*tfm_para_user_d_pav{tfm_para_user_counter}.peak_max 1.1*tfm_para_user_d_pav{tfm_para_user_counter}.peak_max]);
        end
        yyaxis right
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.peak_wins_t(1:end-1),tfm_para_user_d_pav{tfm_para_user_counter}.d_av_peak ,'--');
        absmax = max(abs([tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max, tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min]));
        if ~isnan(absmax)
            set(gca,'YLim',[-1.1*absmax 1.1*absmax]);
        end
    else
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.peak_wins_t,tfm_para_user_d_pav{tfm_para_user_counter}.av_peak), hold on;
    end
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    
    %force
    reset(h_para.axes_force_autocor)
    axes(h_para.axes_force_autocor)
    if ~isnan(tfm_para_user_F_pav{tfm_para_user_counter}.n_peaks)
        plot(tfm_para_user_F_pav{tfm_para_user_counter}.peak_wins_t,tfm_para_user_F_pav{tfm_para_user_counter}.av_peak), hold on;
        area(tfm_para_user_F_pav{tfm_para_user_counter}.t_peak,tfm_para_user_F_pav{tfm_para_user_counter}.av_peak+tfm_para_user_F_pav{tfm_para_user_counter}.av_peak_std,min(tfm_para_user_F_pav{tfm_para_user_counter}.av_peak-tfm_para_user_F_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[0.8 0.8 0.8],'FaceAlpha',0.5,'EdgeColor','none');
        area(tfm_para_user_F_pav{tfm_para_user_counter}.t_peak,tfm_para_user_F_pav{tfm_para_user_counter}.av_peak-tfm_para_user_F_pav{tfm_para_user_counter}.av_peak_std,min(tfm_para_user_F_pav{tfm_para_user_counter}.av_peak-tfm_para_user_F_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[1 1 1],'FaceAlpha',1,'EdgeColor','none');
        area(tfm_para_user_F_pav{tfm_para_user_counter}.peak_wins_t(min(tfm_para_user_F_pav{tfm_para_user_counter}.peak_min_t):tfm_para_user_F_pav{tfm_para_user_counter}.peak_max_t)',tfm_para_user_F_pav{tfm_para_user_counter}.av_peak(min(tfm_para_user_F_pav{tfm_para_user_counter}.peak_min_t):tfm_para_user_F_pav{tfm_para_user_counter}.peak_max_t),tfm_para_user_F_pav{tfm_para_user_counter}.peak_basel,'FaceColor',[.9892 .8136 .1885],'FaceAlpha',0.5,'EdgeColor','none');
        area(tfm_para_user_F_pav{tfm_para_user_counter}.peak_wins_t(tfm_para_user_F_pav{tfm_para_user_counter}.peak_max_t:max(tfm_para_user_F_pav{tfm_para_user_counter}.peak_min_t))',tfm_para_user_F_pav{tfm_para_user_counter}.av_peak(tfm_para_user_F_pav{tfm_para_user_counter}.peak_max_t:max(tfm_para_user_F_pav{tfm_para_user_counter}.peak_min_t)),tfm_para_user_F_pav{tfm_para_user_counter}.peak_basel,'FaceColor',[.244 .4358 .9988],'FaceAlpha',0.5,'EdgeColor','none');
        set(gca,'XLim',[0 tfm_para_user_F_pav{tfm_para_user_counter}.peak_wins_t(end)]);
        if ~isnan(tfm_para_user_F_pav{tfm_para_user_counter}.peak_max)
            set(gca,'YLim',[-.1*tfm_para_user_F_pav{tfm_para_user_counter}.peak_max 1.1*tfm_para_user_F_pav{tfm_para_user_counter}.peak_max]);
        end
    else
        plot(tfm_para_user_F_pav{tfm_para_user_counter}.peak_wins_t,tfm_para_user_F_pav{tfm_para_user_counter}.av_peak), hold on;
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %preview traction animation
    set(h_para.button_traction_anim,'string',['<html><img src="file:',tfm_init_user_pathnamestack{1,tfm_para_user_counter},tfm_init_user_filenamestack{1,tfm_para_user_counter},filesep,'heatmap_anim.gif"/></html>']);
    
    %forces
    if get(h_para.radiobutton_forcetot,'Value') %ftot
        %set correct plot
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(tfm_para_user_Fmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %set correct text
        set(h_para.text_forces,'String',['F=',num2str(tfm_para_user_para_DeltaF{tfm_para_user_counter},'%.2e'),'[N]']);
    elseif get(h_para.radiobutton_forcex,'Value') %fx
        %set correct plot
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fxmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(tfm_para_user_Fxmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %set correct text
        set(h_para.text_forces,'String',['Fx=',num2str(tfm_para_user_para_DeltaFx{tfm_para_user_counter},'%.2e'),'[N]']);
    elseif get(h_para.radiobutton_forcey,'Value') %fy
        %set correct plot
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fymax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(tfm_para_user_Fymin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %set correct text
        set(h_para.text_forces,'String',['Fy=',num2str(tfm_para_user_para_DeltaFy{tfm_para_user_counter},'%.2e'),'[N]']);
    end
    
    %power
    cla(h_para.axes_power)
    axes(h_para.axes_power)
    plot(dt{tfm_para_user_counter},zeros(1,length(dt{tfm_para_user_counter})),'--k'), hold on;
    plot(dt{tfm_para_user_counter},tfm_para_user_power{tfm_para_user_counter}*1e12,'-b'), hold on;
    plot(tfm_para_user_Pmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmin{tfm_para_user_counter}(:,2)*1e12,'.r','MarkerSize',10), hold on;
    plot(tfm_para_user_Pmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmax{tfm_para_user_counter}(:,2)*1e12,'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %freq.
    if get(h_para.radiobutton_fft,'Value')
        %make unwanted buttons invisible
        set(h_para.button_freq_add,'Visible','off');
        set(h_para.button_freq_remove,'Visible','off');
        set(h_para.button_freq_clearall,'Visible','off');
        %enable wanted button
        set(h_para.button_freq_addfft,'Visible','on');
        %plot frequency. in axes
        x=tfm_para_user_para_freq{tfm_para_user_counter};
        y=tfm_para_user_para_freqy{tfm_para_user_counter};
        cla(h_para.axes_freq)
        axes(h_para.axes_freq)
        plot(freq{tfm_para_user_counter},y_fft{tfm_para_user_counter},'-b'), hold on;
        plot(x,y,'.g','MarkerSize',10)
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'XLim', [0 5]);% freq{tfm_para_user_counter}(end)]);
        %set(gca, 'YLim', [0 max(y_fft{tfm_para_user_counter})]);
        %para
        set(h_para.text_freq1,'String',['f=',num2str(x,'%.2e'),'[Hz]']);
        set(h_para.text_freq2,'String',['T=',num2str(1/(x+eps),'%.2e'),'[s]']);
    elseif get(h_para.radiobutton_pick,'Value')
        %make  buttons visible
        set(h_para.button_freq_add,'Visible','on');
        set(h_para.button_freq_remove,'Visible','on');
        set(h_para.button_freq_clearall,'Visible','on');
        %disable unwanted button
        set(h_para.button_freq_addfft,'Visible','off');
        %plot displ. in axes
        t_new=tfm_para_user_freq2{tfm_para_user_counter};
        x=1/(tfm_para_user_para_freq2{tfm_para_user_counter}+eps);
        cla(h_para.axes_freq)
        axes(h_para.axes_freq)
        plot(dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
        %plot delta t
        dtcontr=zeros(1,size(t_new,1));
        cmap = hsv(size(t_new,1));
        for i=1:size(t_new,1)
            plot(t_new(i,1),t_new(i,3),'.','Color',cmap(i,:),'MarkerSize',10)
            plot(t_new(i,2),t_new(i,4),'.','Color',cmap(i,:),'MarkerSize',10)
            dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
            plot(linspace(t_new(i,1),t_new(i,2),100),linspace(0,0,100),'Color',cmap(i,:),'LineWidth',5)
        end
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %para
        set(h_para.text_freq1,'String',['f=',num2str(1/(x+eps),'%.2e'),'[Hz]']);
        set(h_para.text_freq2,'String',['T=',num2str(x,'%.2e'),'[s]']);
        
    elseif get(h_para.radiobutton_autocorr,'Value')
        %make unwanted buttons invisible
        set(h_para.button_freq_add,'Visible','off');
        set(h_para.button_freq_remove,'Visible','off');
        set(h_para.button_freq_clearall,'Visible','off');
        %disable unwanted button
        set(h_para.button_freq_addfft,'Visible','off');
        
        cla(h_para.axes_freq)
        axes(h_para.axes_freq)
        plot(tfm_para_user_d_s{tfm_para_user_counter}.signal_t,tfm_para_user_d_s{tfm_para_user_counter}.autocorr_signal,'-m'), hold on;
        plot(tfm_para_user_d_s{tfm_para_user_counter}.autocorr_peaks_lags/tfm_para_user_d_s{tfm_para_user_counter}.framerate,tfm_para_user_d_s{tfm_para_user_counter}.autocorr_peaks,'ob','MarkerSize',3); hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %para
        set(h_para.text_freq1,'String',['f= XX [Hz]']);
        set(h_para.text_freq2,'String',['T= XX [s]']);
    end
    
    %display para
    %diplay
    set(h_para.text_disp,'String',['dcontr=',num2str(tfm_para_user_para_Deltad{tfm_para_user_counter},'%.2e'),'[m]']);
    set(h_para.text_vel1,'String',['vcontr=',num2str(tfm_para_user_para_vcontr{tfm_para_user_counter},'%.2e'),'[m/s]']);
    set(h_para.text_vel2,'String',['vrelax=',num2str(tfm_para_user_para_vrelax{tfm_para_user_counter},'%.2e'),'[m/s]']);
    %     set(h_para.text_dp2_2,'String',['t=',num2str(tfm_para_user_para_tdp{tfm_para_user_counter},'%.2e'),'[s]']);
    set(h_para.text_contr,'String',['tcontr=',num2str(tfm_para_user_para_tcontr{tfm_para_user_counter},'%.2e'),'[s]']);
    set(h_para.text_power1,'String',['Pcontr=',num2str(tfm_para_user_para_Pcontr{tfm_para_user_counter},'%.2e'),'[W]']);
    set(h_para.text_power2,'String',['Prelax=',num2str(tfm_para_user_para_Prelax{tfm_para_user_counter},'%.2e'),'[W]']);
    set(h_para.text_strain,'String',['U=',num2str(tfm_para_user_para_U{tfm_para_user_counter},'%.2e'),'[J]']);
    if get(h_para.radiobutton_Mxx,'Value')
        set(h_para.text_moment,'String',['Mxx=',num2str(tfm_para_user_para_Mxx{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_Myy,'Value')
        set(h_para.text_moment,'String',['Myy=',num2str(tfm_para_user_para_Myy{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_mu,'Value')
        set(h_para.text_moment,'String',['mu=',num2str(tfm_para_user_para_mu{tfm_para_user_counter},'%.2e'),'[Nm]']);
    end
    set(h_para.text_disp_autocor,'String',['dcontr=',num2str(tfm_para_user_d_pav{tfm_para_user_counter}.peak_amp,'%.2e'),'[m]',',n=',num2str(tfm_para_user_d_pav{tfm_para_user_counter}.n_peaks)]);
    set(h_para.text_force_autocor,'String',['F=',num2str(tfm_para_user_F_pav{tfm_para_user_counter}.peak_amp,'%.2e'),'[N]',',n=',num2str(tfm_para_user_F_pav{tfm_para_user_counter}.n_peaks)]);
    set(h_para.text_vcontr_autocor,'String',['vcontr=',num2str(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max,'%.2e'),'[m/s]']);
    set(h_para.text_vrelax_autocor,'String',['vrelax=',num2str(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min,'%.2e'),'[m/s]']);
    set(h_para.text_note_autocor,'String',['Comment: ',tfm_para_user_d_s{tfm_para_user_counter}.comment]);
    
    %set texts to 1st vid
    set(h_para.text_whichvidname,'String',tfm_init_user_filenamestack{1,tfm_para_user_counter});
    set(h_para.text_whichvid,'String',[num2str(tfm_para_user_counter),'/',num2str(tfm_init_user_Nfiles)]);
    
    
    %forward /backbutton
    if tfm_para_user_counter==1
        set(h_para.button_backwards,'Enable','off');
    else
        set(h_para.button_backwards,'Enable','on');
    end
    if tfm_para_user_counter==tfm_init_user_Nfiles
        set(h_para.button_forwards,'Enable','off');
    else
        set(h_para.button_forwards,'Enable','on');
    end
    
    %Export result panel image
    %export_fig([tfm_init_user_pathnamestack{1,tfm_para_user_counter},tfm_init_user_filenamestack{1,tfm_para_user_counter},'/Plots/Curve Plots/results_panel'],'-png','-m1.5',h_para.fig);

    %shared data
    setappdata(0,'tfm_para_user_other_comments',tfm_para_user_other_comments);
    setappdata(0,'tfm_para_user_para_ratiop',tfm_para_user_para_ratiop);
    setappdata(0,'tfm_para_user_para_ratiodp',tfm_para_user_para_ratiodp);
    setappdata(0,'tfm_para_user_counter',tfm_para_user_counter);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_backwards(hObject, eventdata, h_para)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_para.fig,1));


try
    %load what shared para we need
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    dmax=getappdata(0,'tfm_para_user_dmax');
    dmin=getappdata(0,'tfm_para_user_dmin');
    vmax=getappdata(0,'tfm_para_user_vmax');
    vmin=getappdata(0,'tfm_para_user_vmin');
    dt=getappdata(0,'tfm_para_user_dt');
    Velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_para_Deltad=getappdata(0,'tfm_para_user_para_Deltad');
    tfm_para_user_para_vcontr=getappdata(0,'tfm_para_user_para_vcontr');
    tfm_para_user_para_vrelax=getappdata(0,'tfm_para_user_para_vrelax');
    tfm_para_user_tcontr=getappdata(0,'tfm_para_user_tcontr');
    tfm_para_user_para_tcontr=getappdata(0,'tfm_para_user_para_tcontr');
    tfm_para_user_tdp=getappdata(0,'tfm_para_user_tdp');
    tfm_para_user_para_tdp=getappdata(0,'tfm_para_user_para_tdp');
    tfm_para_user_freq2=getappdata(0,'tfm_para_user_freq2');
    tfm_para_user_para_freq2=getappdata(0,'tfm_para_user_para_freq2');
    tfm_para_user_para_freq=getappdata(0,'tfm_para_user_para_freq');
    tfm_para_user_para_freqy=getappdata(0,'tfm_para_user_para_freqy');
    freq=getappdata(0,'tfm_para_user_freq');
    y_fft=getappdata(0,'tfm_para_user_y_fft');
    tfm_para_user_para_ratiop=getappdata(0,'tfm_para_user_para_ratiop');
    tfm_para_user_para_ratiodp=getappdata(0,'tfm_para_user_para_ratiodp');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_para_user_para_tagdp=getappdata(0,'tfm_para_user_para_tagdp');
    tfm_para_user_discard_tag=getappdata(0,'tfm_para_user_discard_tag');
    tfm_para_user_dbl_tag=getappdata(0,'tfm_para_user_dbl_tag');
    tfm_para_user_drift_tag=getappdata(0,'tfm_para_user_drift_tag');
    tfm_para_user_other_tag=getappdata(0,'tfm_para_user_other_tag');
    tfm_para_user_other_comments=getappdata(0,'tfm_para_user_other_comments');
    tfm_para_user_Fmax=getappdata(0,'tfm_para_user_Fmax');
    tfm_para_user_Fmin=getappdata(0,'tfm_para_user_Fmin');
    tfm_para_user_F_tot=getappdata(0,'tfm_para_user_F_tot');
    tfm_para_user_para_DeltaF=getappdata(0,'tfm_para_user_para_DeltaF');
    tfm_para_user_Fxmax=getappdata(0,'tfm_para_user_Fxmax');
    tfm_para_user_Fxmin=getappdata(0,'tfm_para_user_Fxmin');
    tfm_para_user_Fx_tot=getappdata(0,'tfm_para_user_Fx_tot');
    tfm_para_user_para_DeltaFx=getappdata(0,'tfm_para_user_para_DeltaFx');
    tfm_para_user_Fymax=getappdata(0,'tfm_para_user_Fymax');
    tfm_para_user_Fymin=getappdata(0,'tfm_para_user_Fymin');
    tfm_para_user_Fy_tot=getappdata(0,'tfm_para_user_Fy_tot');
    tfm_para_user_para_DeltaFy=getappdata(0,'tfm_para_user_para_DeltaFy');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_Pmax=getappdata(0,'tfm_para_user_Pmax');
    tfm_para_user_Pmin=getappdata(0,'tfm_para_user_Pmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_power=getappdata(0,'tfm_para_user_power');
    tfm_para_user_para_Pcontr=getappdata(0,'tfm_para_user_para_Pcontr');
    tfm_para_user_para_Prelax=getappdata(0,'tfm_para_user_para_Prelax');
    tfm_para_user_U=getappdata(0,'tfm_para_user_U');
    tfm_para_user_Umax=getappdata(0,'tfm_para_user_Umax');
    tfm_para_user_Umin=getappdata(0,'tfm_para_user_Umin');
    tfm_para_user_para_U=getappdata(0,'tfm_para_user_para_U');
    tfm_para_user_Mxx=getappdata(0,'tfm_para_user_Mxx');
    tfm_para_user_Mxy=getappdata(0,'tfm_para_user_Mxy');
    tfm_para_user_Myx=getappdata(0,'tfm_para_user_Myx');
    tfm_para_user_Myy=getappdata(0,'tfm_para_user_Myy');
    tfm_para_user_mu=getappdata(0,'tfm_para_user_mu');
    tfm_para_user_Mxx_max=getappdata(0,'tfm_para_user_Mxx_max');
    tfm_para_user_Mxx_min=getappdata(0,'tfm_para_user_Mxx_min');
    tfm_para_user_Mxy_max=getappdata(0,'tfm_para_user_Mxy_max');
    tfm_para_user_Mxy_min=getappdata(0,'tfm_para_user_Mxy_min');
    tfm_para_user_Myy_max=getappdata(0,'tfm_para_user_Myy_max');
    tfm_para_user_Myy_min=getappdata(0,'tfm_para_user_Myy_min');
    tfm_para_user_mu_max=getappdata(0,'tfm_para_user_mu_max');
    tfm_para_user_mu_min=getappdata(0,'tfm_para_user_mu_min');
    tfm_para_user_para_Mxx=getappdata(0,'tfm_para_user_para_Mxx');
    tfm_para_user_para_Mxy=getappdata(0,'tfm_para_user_para_Mxy');
    tfm_para_user_para_Myy=getappdata(0,'tfm_para_user_para_Myy');
    tfm_para_user_para_mu=getappdata(0,'tfm_para_user_para_mu');
    tfm_para_user_dtheta=getappdata(0,'tfm_para_user_dtheta');
    tfm_para_user_center=getappdata(0,'tfm_para_user_center');
    tfm_para_user_d_s=getappdata(0,'tfm_para_user_d_s');
    tfm_para_user_d_pav=getappdata(0,'tfm_para_user_d_pav');
    tfm_para_user_F_s=getappdata(0,'tfm_para_user_F_s');
    tfm_para_user_F_pav=getappdata(0,'tfm_para_user_F_pav');
    tfm_para_user_disp_l = getappdata(0,'tfm_para_user_disp_l');
    
    %save current stuff
    tfm_para_user_other_comments{tfm_para_user_counter}=get(h_para.edit_other,'String');
    tfm_para_user_para_ratiop{tfm_para_user_counter}=str2double(get(h_para.edit_ratio,'String'));
    %     if tfm_para_user_para_tagdp{tfm_para_user_counter}
    %         tfm_para_user_para_ratiodp{tfm_para_user_counter}=str2double(get(h_para.edit_dp2,'String'));
    %     end
    
    %go to video before
    tfm_para_user_counter=tfm_para_user_counter-1;
    
    %set tags
    set(h_para.edit_ratio,'String',num2str(tfm_para_user_para_ratiop{tfm_para_user_counter}));
    %     if tfm_para_user_para_tagdp{tfm_para_user_counter}
    %         set(h_para.edit_dp2,'String',num2str(tfm_para_user_para_ratiodp{tfm_para_user_counter}));
    %     end
    %checkboxes
    if tfm_para_user_discard_tag{tfm_para_user_counter}
        set(h_para.checkbox_disc,'Value',1)
    else
        set(h_para.checkbox_disc,'Value',0)
    end
    if tfm_para_user_dbl_tag{tfm_para_user_counter}
        set(h_para.checkbox_dbl,'Value',1)
    else
        set(h_para.checkbox_dbl,'Value',0)
    end
    if tfm_para_user_drift_tag{tfm_para_user_counter}
        set(h_para.checkbox_drift,'Value',1)
    else
        set(h_para.checkbox_drift,'Value',0)
    end
    if tfm_para_user_other_tag{tfm_para_user_counter}
        set(h_para.checkbox_other,'Value',1)
    else
        set(h_para.checkbox_other,'Value',0)
    end
    set(h_para.edit_other,'String',tfm_para_user_other_comments{tfm_para_user_counter})
    %     if tfm_para_user_para_tagdp{tfm_para_user_counter}
    %         set(h_para.panel_dp2,'Visible','on')
    %         set(h_para.checkbox_dpyes,'Value',1)
    %         set(h_para.checkbox_dpno,'Value',0)
    %     else
    %         set(h_para.checkbox_dpyes,'Value',0)
    %         set(h_para.checkbox_dpno,'Value',1)
    %         set(h_para.panel_dp2,'Visible','off')
    %     end
    
    %display plots
    %plot 1st displ. in axes
    cla(h_para.axes_disp)
    axes(h_para.axes_disp)
    plot(dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    plot(dt{tfm_para_user_counter},tfm_para_user_disp_l*ones(size(dt{tfm_para_user_counter},2),1)',':m'), hold on;
    text(dt{tfm_para_user_counter}(1),tfm_para_user_disp_l*1e6,[num2str(tfm_para_user_disp_l) '[m]'],'FontSize',10);
    plot(dmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},dmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(dmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},dmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    %JFM
    %set(gca, 'YTick', []);
    ylim([0 5e-8]);
    
    %     %displ. in double peak
    %     cla(h_para.axes_dp2)
    %     axes(h_para.axes_dp2)
    %     plot(dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    %     plot(tfm_para_user_tdp{tfm_para_user_counter}(:,1),tfm_para_user_tdp{tfm_para_user_counter}(:,3),'.r','MarkerSize',10)
    %     plot(tfm_para_user_tdp{tfm_para_user_counter}(:,2),tfm_para_user_tdp{tfm_para_user_counter}(:,4),'.r','MarkerSize',10)
    %     %plot delta t
    %     dtcontr=zeros(1,size(tfm_para_user_tdp{tfm_para_user_counter},1));
    %     for i=1:size(tfm_para_user_tdp{tfm_para_user_counter},1)
    %         dtcontr(1,i)=abs(tfm_para_user_tdp{tfm_para_user_counter}(i,2)-tfm_para_user_tdp{tfm_para_user_counter}(i,1));
    %         plot(linspace(tfm_para_user_tdp{tfm_para_user_counter}(i,1),tfm_para_user_tdp{tfm_para_user_counter}(i,2),100),linspace(0,0,100),'r','LineWidth',5)
    %     end
    %     set(gca, 'XTick', []);
    %     set(gca, 'YTick', []);
    
    %plot 1st velocity. in axes
    cla(h_para.axes_vel)
    axes(h_para.axes_vel)
    plot(dt{tfm_para_user_counter},zeros(1,length(dt{tfm_para_user_counter})),'--k'), hold on;
    plot(dt{tfm_para_user_counter},Velocity{tfm_para_user_counter},'-b'), hold on;
    plot(vmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},vmin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(vmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},vmax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    for i = 1:length(tfm_para_user_tcontr{tfm_para_user_counter}(:,1))
        plot(linspace(tfm_para_user_tcontr{tfm_para_user_counter}(i,1),tfm_para_user_tcontr{tfm_para_user_counter}(i,2),2),linspace(0,0,2),'r','LineWidth',5);
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %%plot 1st velocity. in axes
    cla(h_para.axes_contr)
    axes(h_para.axes_contr)
    plot(dt{tfm_para_user_counter},Velocity{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_tcontr{tfm_para_user_counter}(:,1),tfm_para_user_tcontr{tfm_para_user_counter}(:,3),'.r','MarkerSize',10)
    plot(tfm_para_user_tcontr{tfm_para_user_counter}(:,2),tfm_para_user_tcontr{tfm_para_user_counter}(:,4),'.r','MarkerSize',10)
    %plot delta t
    dtcontr=zeros(1,size(tfm_para_user_tcontr{tfm_para_user_counter},1));
    for i=1:size(tfm_para_user_tcontr{tfm_para_user_counter},1)
        dtcontr(1,i)=abs(tfm_para_user_tcontr{tfm_para_user_counter}(i,2)-tfm_para_user_tcontr{tfm_para_user_counter}(i,1));
        plot(linspace(tfm_para_user_tcontr{tfm_para_user_counter}(i,1),tfm_para_user_tcontr{tfm_para_user_counter}(i,2),2),linspace(0,0,2),'r','LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %plot strain energy
    reset(h_para.axes_strain)
    axes(h_para.axes_strain)
    plot(dt{tfm_para_user_counter},tfm_para_user_U{tfm_para_user_counter},'-b'), hold on;
    plot(tfm_para_user_Umin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umin{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
    plot(tfm_para_user_Umax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Umax{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %plot contractile moment
    if get(h_para.radiobutton_Mxx,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_Myy,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Myy{tfm_para_user_counter},'-b')
        plot(tfm_para_user_Myy_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_Myy_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    elseif get(h_para.radiobutton_mu,'Value')
        reset(h_para.axes_moment)
        axes(h_para.axes_moment)
        plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_mu{tfm_para_user_counter},'-b')
        plot(tfm_para_user_mu_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10), hold on;
        plot(tfm_para_user_mu_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    % sort center, orient by displacement
    [d_sort,di] = sort(tfm_para_user_d{tfm_para_user_counter});
    center_sort = tfm_para_user_center{tfm_para_user_counter}(di,:);
    theta_sort = tfm_para_user_dtheta{tfm_para_user_counter}(di);
    Mxx_sort = tfm_para_user_Mxx{tfm_para_user_counter}(di);
    
    if get(h_para.radiobutton_center,'Value')
        %plot center of contraction
        reset(h_para.axes_orient)
        axes(h_para.axes_orient)
        [theta_center,r_center] = cart2pol(center_sort(:,1),center_sort(:,2));
        polarscatter(theta_center,r_center,10,d_sort,'filled');
        %set(gca, 'RTickLabel', []);
        set(gca, 'ThetaTickLabel', []);
        colorbar('southoutside','TickLabels',[])
        rlim([0 5e-6]);
        rticks([2.5e-6 5e-6]);
        rticklabels({'r = 2.5e-6 [m]',''});
    elseif get(h_para.radiobutton_orient,'Value')
        %plot traction orientation
        reset(h_para.axes_orient)
        axes(h_para.axes_orient)
        polarscatter(theta_sort.*(pi/180),Mxx_sort,10,d_sort,'filled');
        set(gca, 'RTickLabel', []);
        set(gca, 'ThetaTickLabel', []);
        colorbar('southoutside','TickLabels',[]);
    end
    
    %plot peak averaging results
    %displacement
    reset(h_para.axes_disp_autocor)
    axes(h_para.axes_disp_autocor)
    if ~isnan(tfm_para_user_d_pav{tfm_para_user_counter}.n_peaks)
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.peak_wins_t,tfm_para_user_d_pav{tfm_para_user_counter}.av_peak), hold on;
        area(tfm_para_user_d_pav{tfm_para_user_counter}.t_peak,tfm_para_user_d_pav{tfm_para_user_counter}.av_peak+tfm_para_user_d_pav{tfm_para_user_counter}.av_peak_std,min(tfm_para_user_d_pav{tfm_para_user_counter}.av_peak-tfm_para_user_d_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[0.8 0.8 0.8],'FaceAlpha',0.5,'EdgeColor','none');
        area(tfm_para_user_d_pav{tfm_para_user_counter}.t_peak,tfm_para_user_d_pav{tfm_para_user_counter}.av_peak-tfm_para_user_d_pav{tfm_para_user_counter}.av_peak_std,min(tfm_para_user_d_pav{tfm_para_user_counter}.av_peak-tfm_para_user_d_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[1 1 1],'FaceAlpha',1,'EdgeColor','none');
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max_t/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_d_pav{tfm_para_user_counter}.av_peak(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max_t),'^k','MarkerSize',5);
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min_t/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_d_pav{tfm_para_user_counter}.av_peak(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min_t),'vk','MarkerSize',5);
        plot([tfm_para_user_d_pav{tfm_para_user_counter}.peak_max_t-floor(floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/4)):tfm_para_user_d_pav{tfm_para_user_counter}.peak_max_t+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/4)]/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_d_pav{tfm_para_user_counter}.peak_max*ones(1,(tfm_para_user_d_pav{tfm_para_user_counter}.peak_max_t+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/4))-(tfm_para_user_d_pav{tfm_para_user_counter}.peak_max_t-floor(floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/4)))+1),':k');
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.peak_wins_t,tfm_para_user_d_pav{tfm_para_user_counter}.peak_basel*ones(1,tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l),':k');
        plot([tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max_t-floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6):tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max_t+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6)]/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max*tfm_para_user_d_pav{tfm_para_user_counter}.d_t_peak(1)*[-floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6):+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6)]+tfm_para_user_d_pav{tfm_para_user_counter}.av_peak(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max_t),':k');
        plot([tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min_t-floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6):tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min_t+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6)]/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min*tfm_para_user_d_pav{tfm_para_user_counter}.d_t_peak(1)*[-floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6):+floor(tfm_para_user_d_s{tfm_para_user_counter}.peak_win_l/6)]+tfm_para_user_d_pav{tfm_para_user_counter}.av_peak(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min_t),':k');
        set(gca,'XLim',[0 tfm_para_user_d_pav{tfm_para_user_counter}.peak_wins_t(end)]);
        if ~isnan(tfm_para_user_d_pav{tfm_para_user_counter}.peak_max)
            set(gca,'YLim',[-1.1*tfm_para_user_d_pav{tfm_para_user_counter}.peak_max 1.1*tfm_para_user_d_pav{tfm_para_user_counter}.peak_max]);
        end
         yyaxis right
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.peak_wins_t(1:end-1),tfm_para_user_d_pav{tfm_para_user_counter}.d_av_peak ,'--');
        absmax = max(abs([tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max, tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min]));
        if ~isnan(absmax)
            set(gca,'YLim',[-1.1*absmax 1.1*absmax]);
        end
    else
        plot(tfm_para_user_d_pav{tfm_para_user_counter}.peak_wins_t,tfm_para_user_d_pav{tfm_para_user_counter}.av_peak), hold on;
    end
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    
    
    %force
    reset(h_para.axes_force_autocor)
    axes(h_para.axes_force_autocor)
    if ~isnan(tfm_para_user_F_pav{tfm_para_user_counter}.n_peaks)
        plot(tfm_para_user_F_pav{tfm_para_user_counter}.peak_wins_t,tfm_para_user_F_pav{tfm_para_user_counter}.av_peak), hold on;
        area(tfm_para_user_F_pav{tfm_para_user_counter}.t_peak,tfm_para_user_F_pav{tfm_para_user_counter}.av_peak+tfm_para_user_F_pav{tfm_para_user_counter}.av_peak_std,min(tfm_para_user_F_pav{tfm_para_user_counter}.av_peak-tfm_para_user_F_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[0.8 0.8 0.8],'FaceAlpha',0.5,'EdgeColor','none');
        area(tfm_para_user_F_pav{tfm_para_user_counter}.t_peak,tfm_para_user_F_pav{tfm_para_user_counter}.av_peak-tfm_para_user_F_pav{tfm_para_user_counter}.av_peak_std,min(tfm_para_user_F_pav{tfm_para_user_counter}.av_peak-tfm_para_user_F_pav{tfm_para_user_counter}.av_peak_std),'FaceColor',[1 1 1],'FaceAlpha',1,'EdgeColor','none');
        area(tfm_para_user_F_pav{tfm_para_user_counter}.peak_wins_t(min(tfm_para_user_F_pav{tfm_para_user_counter}.peak_min_t):tfm_para_user_F_pav{tfm_para_user_counter}.peak_max_t)',tfm_para_user_F_pav{tfm_para_user_counter}.av_peak(min(tfm_para_user_F_pav{tfm_para_user_counter}.peak_min_t):tfm_para_user_F_pav{tfm_para_user_counter}.peak_max_t),tfm_para_user_F_pav{tfm_para_user_counter}.peak_basel,'FaceColor',[.9892 .8136 .1885],'FaceAlpha',0.5,'EdgeColor','none');
        area(tfm_para_user_F_pav{tfm_para_user_counter}.peak_wins_t(tfm_para_user_F_pav{tfm_para_user_counter}.peak_max_t:max(tfm_para_user_F_pav{tfm_para_user_counter}.peak_min_t))',tfm_para_user_F_pav{tfm_para_user_counter}.av_peak(tfm_para_user_F_pav{tfm_para_user_counter}.peak_max_t:max(tfm_para_user_F_pav{tfm_para_user_counter}.peak_min_t)),tfm_para_user_F_pav{tfm_para_user_counter}.peak_basel,'FaceColor',[.244 .4358 .9988],'FaceAlpha',0.5,'EdgeColor','none');
        set(gca,'XLim',[0 tfm_para_user_F_pav{tfm_para_user_counter}.peak_wins_t(end)]);
        if ~isnan(tfm_para_user_F_pav{tfm_para_user_counter}.peak_max)
            set(gca,'YLim',[-.1*tfm_para_user_F_pav{tfm_para_user_counter}.peak_max 1.1*tfm_para_user_F_pav{tfm_para_user_counter}.peak_max]);
        end
    else
        plot(tfm_para_user_F_pav{tfm_para_user_counter}.peak_wins_t,tfm_para_user_F_pav{tfm_para_user_counter}.av_peak), hold on;
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    
    %preview traction animation
    set(h_para.button_traction_anim,'string',['<html><img src="file:',tfm_init_user_pathnamestack{1,tfm_para_user_counter},tfm_init_user_filenamestack{1,tfm_para_user_counter},filesep,'heatmap_anim.gif"/></html>']);
    
    %forces
    if get(h_para.radiobutton_forcetot,'Value') %ftot
        %set correct plot
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(tfm_para_user_Fmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %set correct text
        set(h_para.text_forces,'String',['F=',num2str(tfm_para_user_para_DeltaF{tfm_para_user_counter},'%.2e'),'[N]']);
    elseif get(h_para.radiobutton_forcex,'Value') %fx
        %set correct plot
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fxmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(tfm_para_user_Fxmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %set correct text
        set(h_para.text_forces,'String',['Fx=',num2str(tfm_para_user_para_DeltaFx{tfm_para_user_counter},'%.2e'),'[N]']);
    elseif get(h_para.radiobutton_forcey,'Value') %fy
        %set correct plot
        cla(h_para.axes_forces)
        axes(h_para.axes_forces)
        plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
        plot(tfm_para_user_Fymax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
        plot(tfm_para_user_Fymin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %set correct text
        set(h_para.text_forces,'String',['Fy=',num2str(tfm_para_user_para_DeltaFy{tfm_para_user_counter},'%.2e'),'[N]']);
    end
    
    %power
    cla(h_para.axes_power)
    axes(h_para.axes_power)
    plot(dt{tfm_para_user_counter},zeros(1,length(dt{tfm_para_user_counter})),'--k'), hold on;
    plot(dt{tfm_para_user_counter},tfm_para_user_power{tfm_para_user_counter}*1e12,'-b'), hold on;
    plot(tfm_para_user_Pmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmin{tfm_para_user_counter}(:,2)*1e12,'.r','MarkerSize',10), hold on;
    plot(tfm_para_user_Pmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Pmax{tfm_para_user_counter}(:,2)*1e12,'.g','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    %freq.
    if get(h_para.radiobutton_fft,'Value')
        %make unwanted buttons invisible
        set(h_para.button_freq_add,'Visible','off');
        set(h_para.button_freq_remove,'Visible','off');
        set(h_para.button_freq_clearall,'Visible','off');
        %enable wanted button
        set(h_para.button_freq_addfft,'Visible','on');
        %plot frequency. in axes
        x=tfm_para_user_para_freq{tfm_para_user_counter};
        y=tfm_para_user_para_freqy{tfm_para_user_counter};
        cla(h_para.axes_freq)
        axes(h_para.axes_freq)
        plot(freq{tfm_para_user_counter},y_fft{tfm_para_user_counter},'-b'), hold on;
        plot(x,y,'.g','MarkerSize',10)
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        set(gca, 'XLim', [0 5]);% freq{tfm_para_user_counter}(end)]);
        %set(gca, 'YLim', [0 max(y_fft{tfm_para_user_counter})]);
        %para
        set(h_para.text_freq1,'String',['f=',num2str(x,'%.2e'),'[Hz]']);
        set(h_para.text_freq2,'String',['T=',num2str(1/(x+eps),'%.2e'),'[s]']);
    elseif get(h_para.radiobutton_pick,'Value')
        %make  buttons visible
        set(h_para.button_freq_add,'Visible','on');
        set(h_para.button_freq_remove,'Visible','on');
        set(h_para.button_freq_clearall,'Visible','on');
        %disable unwanted button
        set(h_para.button_freq_addfft,'Visible','off');
        %plot displ. in axes
        t_new=tfm_para_user_freq2{tfm_para_user_counter};
        x=1/(tfm_para_user_para_freq2{tfm_para_user_counter}+eps);
        cla(h_para.axes_freq)
        axes(h_para.axes_freq)
        plot(dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
        %plot delta t
        dtcontr=zeros(1,size(t_new,1));
        cmap = hsv(size(t_new,1));
        for i=1:size(t_new,1)
            plot(t_new(i,1),t_new(i,3),'.','Color',cmap(i,:),'MarkerSize',10)
            plot(t_new(i,2),t_new(i,4),'.','Color',cmap(i,:),'MarkerSize',10)
            dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
            plot(linspace(t_new(i,1),t_new(i,2),100),linspace(0,0,100),'Color',cmap(i,:),'LineWidth',5)
        end
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %para
        set(h_para.text_freq1,'String',['f=',num2str(1/(x+eps),'%.2e'),'[Hz]']);
        set(h_para.text_freq2,'String',['T=',num2str(x,'%.2e'),'[s]']);
        
    elseif get(h_para.radiobutton_autocorr,'Value')
        %make unwanted buttons invisible
        set(h_para.button_freq_add,'Visible','off');
        set(h_para.button_freq_remove,'Visible','off');
        set(h_para.button_freq_clearall,'Visible','off');
        %disable unwanted button
        set(h_para.button_freq_addfft,'Visible','off');
        
        cla(h_para.axes_freq)
        axes(h_para.axes_freq)
        plot(tfm_para_user_d_s{tfm_para_user_counter}.signal_t,tfm_para_user_d_s{tfm_para_user_counter}.autocorr_signal,'-m'), hold on;
        plot(tfm_para_user_d_s{tfm_para_user_counter}.autocorr_peaks_lags/tfm_para_user_d_s{tfm_para_user_counter}.framerate,tfm_para_user_d_s{tfm_para_user_counter}.autocorr_peaks,'ob','MarkerSize',3); hold on;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        %para
        set(h_para.text_freq1,'String',['f= XX [Hz]']);
        set(h_para.text_freq2,'String',['T= XX [s]']);
    end
    
    %display para
    %diplay
    set(h_para.text_disp,'String',['dcontr=',num2str(tfm_para_user_para_Deltad{tfm_para_user_counter},'%.2e'),'[m]']);
    set(h_para.text_vel1,'String',['vcontr=',num2str(tfm_para_user_para_vcontr{tfm_para_user_counter},'%.2e'),'[m/s]']);
    set(h_para.text_vel2,'String',['vrelax=',num2str(tfm_para_user_para_vrelax{tfm_para_user_counter},'%.2e'),'[m/s]']);
    %     set(h_para.text_dp2_2,'String',['t=',num2str(tfm_para_user_para_tdp{tfm_para_user_counter},'%.2e'),'[s]']);
    set(h_para.text_contr,'String',['tcontr=',num2str(tfm_para_user_para_tcontr{tfm_para_user_counter},'%.2e'),'[s]']);
    set(h_para.text_power1,'String',['Pcontr=',num2str(tfm_para_user_para_Pcontr{tfm_para_user_counter},'%.2e'),'[W]']);
    set(h_para.text_power2,'String',['Prelax=',num2str(tfm_para_user_para_Prelax{tfm_para_user_counter},'%.2e'),'[W]']);
    set(h_para.text_strain,'String',['U=',num2str(tfm_para_user_para_U{tfm_para_user_counter},'%.2e'),'[J]']);
    if get(h_para.radiobutton_Mxx,'Value')
        set(h_para.text_moment,'String',['Mxx=',num2str(tfm_para_user_para_Mxx{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_Myy,'Value')
        set(h_para.text_moment,'String',['Myy=',num2str(tfm_para_user_para_Myy{tfm_para_user_counter},'%.2e'),'[Nm]']);
    elseif get(h_para.radiobutton_mu,'Value')
        set(h_para.text_moment,'String',['mu=',num2str(tfm_para_user_para_mu{tfm_para_user_counter},'%.2e'),'[Nm]']);
    end
    set(h_para.text_disp_autocor,'String',['dcontr=',num2str(tfm_para_user_d_pav{tfm_para_user_counter}.peak_amp,'%.2e'),'[m]',',n=',num2str(tfm_para_user_d_pav{tfm_para_user_counter}.n_peaks)]);
    set(h_para.text_force_autocor,'String',['F=',num2str(tfm_para_user_F_pav{tfm_para_user_counter}.peak_amp,'%.2e'),'[N]',',n=',num2str(tfm_para_user_F_pav{tfm_para_user_counter}.n_peaks)]);
    set(h_para.text_vcontr_autocor,'String',['vcontr=',num2str(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_max,'%.2e'),'[m/s]']);
    set(h_para.text_vrelax_autocor,'String',['vrelax=',num2str(tfm_para_user_d_pav{tfm_para_user_counter}.d_peak_min,'%.2e'),'[m/s]']);
    set(h_para.text_note_autocor,'String',['Comment: ',tfm_para_user_d_s{tfm_para_user_counter}.comment]);
    
    %set texts to 1st vid
    set(h_para.text_whichvidname,'String',tfm_init_user_filenamestack{1,tfm_para_user_counter});
    set(h_para.text_whichvid,'String',[num2str(tfm_para_user_counter),'/',num2str(tfm_init_user_Nfiles)]);
    
    
    %forward /backbutton
    if tfm_para_user_counter==1
        set(h_para.button_backwards,'Enable','off');
    else
        set(h_para.button_backwards,'Enable','on');
    end
    if tfm_para_user_counter==tfm_init_user_Nfiles
        set(h_para.button_forwards,'Enable','off');
    else
        set(h_para.button_forwards,'Enable','on');
    end
    
    %Export result panel image
    %export_fig([tfm_init_user_pathnamestack{1,tfm_para_user_counter},tfm_init_user_filenamestack{1,tfm_para_user_counter},'/Plots/Curve Plots/results_panel'],'-png','-m1.5',h_para.fig);
    
    %shared data
    setappdata(0,'tfm_para_user_other_comments',tfm_para_user_other_comments);
    setappdata(0,'tfm_para_user_para_ratiop',tfm_para_user_para_ratiop);
    setappdata(0,'tfm_para_user_para_ratiodp',tfm_para_user_para_ratiodp);
    setappdata(0,'tfm_para_user_counter',tfm_para_user_counter);
    
    
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


function para_push_ok(hObject, eventdata, h_para, h_main)
%disable figure during calculation
enableDisableFig(h_para.fig,0);

%turn back on in the end
%clean1=onCleanup(@()enableDisableFig(h_para.fig,1));

%userTiming= getappdata(0,'userTiming');
%userTiming.para{2} = toc(userTiming.para{1});
%save for shared use
%setappdata(0,'userTiming',userTiming)

try
    %save stuff
    %load what shared para we need
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_para_user_para_ratiop=getappdata(0,'tfm_para_user_para_ratiop');
    tfm_para_user_para_Deltad=getappdata(0,'tfm_para_user_para_Deltad');
    tfm_para_user_para_vrelax=getappdata(0,'tfm_para_user_para_vrelax');
    tfm_para_user_para_vcontr=getappdata(0,'tfm_para_user_para_vcontr');
    tfm_para_user_para_tcontr=getappdata(0,'tfm_para_user_para_tcontr');
    tfm_para_user_para_freq=getappdata(0,'tfm_para_user_para_freq');
    tfm_para_user_para_freq2=getappdata(0,'tfm_para_user_para_freq2');
    tfm_para_user_discard_tag=getappdata(0,'tfm_para_user_discard_tag');
    tfm_para_user_dbl_tag=getappdata(0,'tfm_para_user_dbl_tag');
    tfm_para_user_drift_tag=getappdata(0,'tfm_para_user_drift_tag');
    tfm_para_user_other_tag=getappdata(0,'tfm_para_user_other_tag');
    tfm_para_user_other_comments=getappdata(0,'tfm_para_user_other_comments');
    tfm_para_user_para_tagdp=getappdata(0,'tfm_para_user_para_tagdp');
    tfm_para_user_para_ratiodp=getappdata(0,'tfm_para_user_para_ratiodp');
    tfm_para_user_para_tdp=getappdata(0,'tfm_para_user_para_tdp');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_d=getappdata(0,'tfm_para_user_d');
    tfm_para_user_velocity=getappdata(0,'tfm_para_user_velocity');
    tfm_para_user_para_DeltaFx=getappdata(0,'tfm_para_user_para_DeltaFx');
    tfm_para_user_para_DeltaFy=getappdata(0,'tfm_para_user_para_DeltaFy');
    tfm_para_user_para_DeltaF=getappdata(0,'tfm_para_user_para_DeltaF');
    tfm_para_user_para_Prelax=getappdata(0,'tfm_para_user_para_Prelax');
    tfm_para_user_para_Pcontr=getappdata(0,'tfm_para_user_para_Pcontr');
    tfm_para_user_para_U=getappdata(0,'tfm_para_user_para_U');
    tfm_para_user_para_Mxx=getappdata(0,'tfm_para_user_para_Mxx');
    tfm_para_user_para_Mxy=getappdata(0,'tfm_para_user_para_Mxy');
    tfm_para_user_para_Myy=getappdata(0,'tfm_para_user_para_Myy');
    tfm_para_user_para_mu=getappdata(0,'tfm_para_user_para_mu');
    tfm_para_user_dtheta=getappdata(0,'tfm_para_user_dtheta');
    tfm_para_user_power=getappdata(0,'tfm_para_user_power');
    tfm_para_user_F_tot=getappdata(0,'tfm_para_user_F_tot');
    tfm_para_user_Fx_tot=getappdata(0,'tfm_para_user_Fx_tot');
    tfm_para_user_Fy_tot=getappdata(0,'tfm_para_user_Fy_tot');
    tfm_para_user_U=getappdata(0,'tfm_para_user_U');
    tfm_para_user_Mxx=getappdata(0,'tfm_para_user_Mxx');
    tfm_para_user_Mxy=getappdata(0,'tfm_para_user_Mxy');
    tfm_para_user_Myy=getappdata(0,'tfm_para_user_Myy');
    tfm_para_user_mu=getappdata(0,'tfm_para_user_mu');
    tfm_para_user_center=getappdata(0,'tfm_para_user_center');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    tfm_para_user_disp_l = getappdata(0,'tfm_para_user_disp_l');
    
    tfm_para_user_d_s = getappdata(0,'tfm_para_user_d_s');
    tfm_para_user_d_pav = getappdata(0,'tfm_para_user_d_pav');
    tfm_para_user_F_s = getappdata(0,'tfm_para_user_F_s');
    tfm_para_user_F_pav = getappdata(0,'tfm_para_user_F_pav');
    tfm_para_user_Fx_s = getappdata(0,'tfm_para_user_Fx_s');
    tfm_para_user_Fx_pav = getappdata(0,'tfm_para_user_Fx_pav');
    tfm_para_user_Fy_s = getappdata(0,'tfm_para_user_Fy_s');
    tfm_para_user_Fy_pav = getappdata(0,'tfm_para_user_Fy_pav');
    % tfm_para_user_V_s = getappdata(0,'tfm_para_user_V_s');
    % tfm_para_user_V_pav = getappdata(0,'tfm_para_user_V_pav');
    tfm_para_user_P_s = getappdata(0,'tfm_para_user_P_s');
    tfm_para_user_P_pav = getappdata(0,'tfm_para_user_P_pav');
    tfm_para_user_U_s = getappdata(0,'tfm_para_user_U_s');
    tfm_para_user_U_pav = getappdata(0,'tfm_para_user_U_pav');
    tfm_para_user_mu_s = getappdata(0,'tfm_para_user_mu_s');
    tfm_para_user_mu_pav = getappdata(0,'tfm_para_user_mu_pav');
    tfm_init_user_binary2 = getappdata(0,'tfm_init_user_binary2');
    % tfm_para_user_Mxx_s = getappdata(0,'tfm_para_user_Mxx_s');
    % tfm_para_user_Mxx_pav = getappdata(0,'tfm_para_user_Mxx_pav');
    % tfm_para_user_Myy_s = getappdata(0,'tfm_para_user_Myy_s');
    % tfm_para_user_Myy_pav = getappdata(0,'tfm_para_user_Myy_pav');
    
    
    %save current stuff
    tfm_para_user_other_comments{tfm_para_user_counter}=get(h_para.edit_other,'String');
    tfm_para_user_para_ratiop{tfm_para_user_counter}=str2double(get(h_para.edit_ratio,'String'));
    if tfm_para_user_para_tagdp{tfm_para_user_counter}
        tfm_para_user_para_ratiodp{tfm_para_user_counter}=str2double(get(h_para.edit_dp2,'String'));
    end
    
    %save para to excel
    masterfile = [tfm_init_user_pathnamestack{1},'/Batch_Results.xlsx'];
    
    %loop over videos
    for ivid=1:tfm_init_user_Nfiles
        %waitbar
        sb=statusbar(h_para.fig,['Saving parameters... ',num2str(floor(100*(ivid-1)/sum(tfm_init_user_Nfiles))), '%% done']);
        sb.getComponent(0).setForeground(java.awt.Color.red);
        %
        newfile=[tfm_init_user_pathnamestack{1,ivid},'/',tfm_init_user_filenamestack{1,ivid},'/Results/',tfm_init_user_filenamestack{1,ivid},'.xlsx'];
        A(ivid,:) = {tfm_para_user_para_ratiop{ivid},...
            tfm_para_user_para_Deltad{ivid},...
            tfm_para_user_para_vcontr{ivid},...
            tfm_para_user_para_vrelax{ivid},...
            tfm_para_user_para_tcontr{ivid},...
            tfm_para_user_para_freq{ivid},...
            tfm_para_user_para_freq2{ivid},...
            tfm_para_user_para_DeltaFx{ivid},...
            tfm_para_user_para_DeltaFy{ivid},...
            tfm_para_user_para_DeltaF{ivid},...
            tfm_para_user_para_Pcontr{ivid},...
            tfm_para_user_para_Prelax{ivid},...
            tfm_para_user_para_U{ivid},...
            tfm_para_user_para_Mxx{ivid},...
            tfm_para_user_para_Mxy{ivid},...
            tfm_para_user_para_Myy{ivid},...
            tfm_para_user_para_mu{ivid},...
            tfm_para_user_para_tagdp{ivid},...
            tfm_para_user_para_ratiodp{ivid},...
            tfm_para_user_para_tdp{ivid},...
            tfm_para_user_discard_tag{ivid},...
            tfm_para_user_dbl_tag{ivid},...
            tfm_para_user_drift_tag{ivid},...
            tfm_para_user_other_tag{ivid},...
            any([tfm_para_user_discard_tag{ivid},tfm_para_user_dbl_tag{ivid},tfm_para_user_drift_tag{ivid},tfm_para_user_other_tag{ivid}]),...
            tfm_para_user_other_comments{ivid}...
            };
        
        sheet = 'Curves Parameters';
        xlRange = 'A3';
        status1 = xlwrite(newfile,A(ivid,:),sheet,xlRange);
        
        %peak average
        B1(ivid,:) = {{},...%Aspect ratio
            tfm_para_user_d_pav{ivid}.peak_amp,...%Average contraction displacement
            tfm_para_user_d_pav{ivid}.d_peak_max,...%Contraction velocity
            tfm_para_user_d_pav{ivid}.d_peak_min,...%Relaxation velocity
            tfm_para_user_d_pav{ivid}.av_peak_width,...%Contraction half prominance average width %(tfm_para_user_d_pav{ivid}.d_peak_max_t-tfm_para_user_d_pav{ivid}.d_peak_min_t)/tfm_para_user_d_s{ivid}.framerate,...%Contraction time
            tfm_para_user_d_s{ivid}.f_main_peak,...%Frequency
            tfm_para_user_Fx_pav{ivid}.peak_amp,...%Total force x
            tfm_para_user_Fy_pav{ivid}.peak_amp,...%Total force y
            tfm_para_user_F_pav{ivid}.peak_amp,...%Total force tot
            tfm_para_user_F_pav{ivid}.peak_area_contr,...%Contraction impulse
            tfm_para_user_F_pav{ivid}.peak_area_rel,...%Relaxation impulse
            tfm_para_user_F_pav{ivid}.peak_area_tot,...%Total impulse
            tfm_para_user_P_pav{ivid}.peak_max+tfm_para_user_P_pav{ivid}.filtyoffs,...%Contraction Power
            tfm_para_user_P_pav{ivid}.peak_basel+tfm_para_user_P_pav{ivid}.filtyoffs,...%Relaxation Power%
            tfm_para_user_U_pav{ivid}.peak_amp,...%Strain Energy %tfm_para_user_Mxx_pav{ivid}.peak_amp,...%Contractile moment in x%         tfm_para_user_Myy_pav{ivid}.peak_amp,...%Contractile moment in y
            tfm_para_user_mu_pav{ivid}.peak_amp,...%Total contractile moment
            tfm_para_user_mu_pav{ivid}.av_loc_theta,...%Angle of contraction
            tfm_para_user_mu_pav{ivid}.av_loc_theta_75,...%Angle of contraction above 75% mu peak amplitude
            tfm_para_user_mu_pav{ivid}.av_loc_cent(1),...%Center of force position
            tfm_para_user_mu_pav{ivid}.av_loc_cent(2),...%Center of force position
            tfm_para_user_mu_pav{ivid}.av_loc_cent_75(1),...%Center of force position above 75% mu peak amplitude
            tfm_para_user_mu_pav{ivid}.av_loc_cent_75(2),...%Center of force position above 75% mu peak amplitudetfm_para_user_discard_tag{ivid},...%Tag
            tfm_para_user_discard_tag{ivid},...%tag
            tfm_para_user_dbl_tag{ivid},...
            tfm_para_user_drift_tag{ivid},...
            tfm_para_user_other_tag{ivid},...
            any([tfm_para_user_discard_tag{ivid},tfm_para_user_dbl_tag{ivid},tfm_para_user_drift_tag{ivid},tfm_para_user_other_tag{ivid}]),...
            tfm_para_user_other_comments{ivid}...
            };
        %standard deviation of average
        B2(ivid,:) = {{},...%Aspect ratio
            tfm_para_user_d_pav{ivid}.peak_amp_std,...%Average contraction displacement
            tfm_para_user_d_pav{ivid}.d_peak_max_std,...%Contraction velocity
            tfm_para_user_d_pav{ivid}.d_peak_min_std,...%Relaxation velocity
            tfm_para_user_d_pav{ivid}.av_peak_width_std,...%Contraction half prominsnce average width standard deviation
            tfm_para_user_d_s{ivid}.f_main_peak_std,...%Frequency
            tfm_para_user_Fx_pav{ivid}.peak_amp_std,...%Total force x
            tfm_para_user_Fy_pav{ivid}.peak_amp_std,...%Total force y
            tfm_para_user_F_pav{ivid}.peak_amp_std,...%Total force tot
            tfm_para_user_F_pav{ivid}.peak_area_contr_std,...%Contraction impulse
            tfm_para_user_F_pav{ivid}.peak_area_rel_std,...%Relaxation impulse
            tfm_para_user_F_pav{ivid}.peak_area_tot_std,...%Total impulse
            tfm_para_user_P_pav{ivid}.peak_max_std,...%Contraction Power
            tfm_para_user_P_pav{ivid}.peak_basel_std,...%Relaxation Power%
            tfm_para_user_U_pav{ivid}.peak_amp_std,...%Strain Energy %tfm_para_user_Mxx_pav{ivid}.peak_amp_std,...%         tfm_para_user_Myy_pav{ivid}.peak_amp_std,...
            tfm_para_user_mu_pav{ivid}.peak_amp_std,...%Total contractile moment
            tfm_para_user_mu_pav{ivid}.av_loc_theta_std,...%Angle of contraction
            tfm_para_user_mu_pav{ivid}.av_loc_theta_75_std,...%Angle of contraction above 75% mu peak amplitude
            tfm_para_user_mu_pav{ivid}.av_loc_cent_std(1),...%Center of force position
            tfm_para_user_mu_pav{ivid}.av_loc_cent_std(2),...%Center of force position
            tfm_para_user_mu_pav{ivid}.av_loc_cent_75_std(1),...%Center of force position above 75% mu peak amplitude
            tfm_para_user_mu_pav{ivid}.av_loc_cent_75_std(2),...%Center of force position above 75% mu peak amplitude
            {},...%Tag
            {},...
            {},...
            {},...
            {},...
            {}...
            };
        %number of peaks used in averaging
        B3(ivid,:) = {{},...%Aspect ratio
            tfm_para_user_d_pav{ivid}.n_peaks,...%Average contraction displacement
            tfm_para_user_d_pav{ivid}.n_peaks,...%Contraction velocity
            tfm_para_user_d_pav{ivid}.n_peaks,...%Relaxation velocity
            tfm_para_user_d_pav{ivid}.n_peaks,...%Contraction half prominsnce average width
            size(tfm_para_user_d_s{ivid}.autocorr_peaks,1)+1,...%Frequency
            tfm_para_user_Fx_pav{ivid}.n_peaks,...%Total force x
            tfm_para_user_Fy_pav{ivid}.n_peaks,...%Total force y
            tfm_para_user_F_pav{ivid}.n_peaks,...%Total force tot
            tfm_para_user_F_pav{ivid}.n_peaks,...%Contraction impulse
            tfm_para_user_F_pav{ivid}.n_peaks,...%Relaxation impulse
            tfm_para_user_F_pav{ivid}.n_peaks,...%Total impulse
            tfm_para_user_P_pav{ivid}.n_peaks,...Contraction Power
            tfm_para_user_P_pav{ivid}.n_peaks,...%Relaxation Power%
            tfm_para_user_U_pav{ivid}.n_peaks,...% Strain Energy %tfm_para_user_Mxx_pav{ivid}.n_peaks,...%         tfm_para_user_Myy_pav{ivid}.n_peaks,...
            tfm_para_user_mu_pav{ivid}.n_peaks,...%Total contractile moment
            tfm_para_user_mu_pav{ivid}.n_peaks,...%Angle of contraction
            tfm_para_user_mu_pav{ivid}.n_peaks,...%Angle of contraction above 75% mu peak amplitude
            tfm_para_user_mu_pav{ivid}.n_peaks,...%Center of force position
            {},...
            tfm_para_user_mu_pav{ivid}.n_peaks,...%Center of force position above 75% mu peak amplitude
            {},...
            {},...
            {},...
            {},...
            {},...
            {},...
            {}...
            };
        
        B = [B1(ivid,:);B2(ivid,:);B3(ivid,:)];
        sheet = 'Averaged Peak Curves Parameters';
        xlRange = 'B3';
        status2 = xlwrite(newfile,B,sheet,xlRange);
        
    end
    
    %write to master file
    sheet = 'Curves Parameters Batch Summary';
    xlrange = 'L3';
    status3 = xlwrite(masterfile,A,sheet,xlrange);
    
    sheet = 'Peak Parameters Batch Summary';
    xlrange = 'L3';
    B = [B1;cell(1,size(B1,2));B2];
    B(size(B1,1)+1,1) = {'Standard deviations'};
    status4 = xlwrite(masterfile,B,sheet,xlrange);
    
    %statusbar
    sb=statusbar(h_para.fig,'Saving - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %save curve data
    %loop over videos
    
    for ivid=1:tfm_init_user_Nfiles
        clear A A1 A2 A3 A4 A5 A6
        %waitbar
        sb=statusbar(h_para.fig,['Saving curve data... ',num2str(floor(100*(ivid-1)/sum(tfm_init_user_Nfiles))), '%% done']);
        sb.getComponent(0).setForeground(java.awt.Color.red);
        
        %file and sheet
        newfile=[tfm_init_user_pathnamestack{1,ivid},'/',tfm_init_user_filenamestack{1,ivid},'/Results/',tfm_init_user_filenamestack{1,ivid},'.xlsx'];
        sheet = 'Curves';
        %loop over time pts
        %displ.
        A1 = {tfm_para_user_dt{ivid}',tfm_para_user_d{ivid}'};
        %         xlRange = ['A',3];
        %         xlwrite(newfile,A1,sheet,xlRange)
        %veloc
        A2 = {tfm_para_user_dt{ivid}',tfm_para_user_velocity{ivid}'};
        %         xlRange = ['D',3];
        %         xlwrite(newfile,A2,sheet,xlRange)
        %forces
        A3 = {tfm_para_user_dt{ivid}',tfm_para_user_Fx_tot{ivid}',tfm_para_user_Fy_tot{ivid}',tfm_para_user_F_tot{ivid}'};
        %         xlRange = ['G',3];
        %         xlwrite(newfile,3,sheet,xlRange)
        %power
        A4 = {tfm_para_user_dt{ivid}',tfm_para_user_power{ivid}'};
        %         xlRange = ['L',3];
        %         xlwrite(newfile,A4,sheet,xlRange)
        %strain
        A5 = {tfm_para_user_dt{ivid}',tfm_para_user_U{ivid}'};
        %         xlRange = ['O',3];
        %         xlwrite(newfile,A5,sheet,xlRange)
        %moment
        A6 = {tfm_para_user_dt{ivid}',...
            tfm_para_user_Mxx{ivid}',...
            tfm_para_user_Mxy{ivid}',...
            tfm_para_user_Myy{ivid}',...
            tfm_para_user_mu{ivid}',...
            tfm_para_user_dtheta{ivid}',...
            tfm_para_user_center{ivid}(:,1:2)};
        %         xlRange = ['R',3];
        %         xlwrite(newfile,A6,sheet,xlRange)
        
        
        clear A 
        A = {A1{1,:},NaN(size(tfm_para_user_dt{ivid},2),1),A2{1,:},NaN(size(tfm_para_user_dt{ivid},2),1),A3{1,:},NaN(size(tfm_para_user_dt{ivid},2),1),A4{1,:},NaN(size(tfm_para_user_dt{ivid},2),1),A5{1,:},NaN(size(tfm_para_user_dt{ivid},2),1),A6{1,:}};
        xlRange = 'A3';
        status5 = xlwrite(newfile,[A{:,:}],sheet,xlRange);
        
        %Save average peak curves
        %file and sheet
        sheet = 'Averaged Peak Curves';
        %loop over time pts
        %displ.
        clear A1 A2 A3 A4 A5 A6
        A1 = {tfm_para_user_d_pav{ivid}.t_peak,...
            tfm_para_user_d_pav{ivid}.av_peak,...
            tfm_para_user_d_pav{ivid}.av_peak_std};
        %         xlRange = ['A',3];
        %         xlwrite(newfile,A1,sheet,xlRange)
        %veloc
        A2 = {tfm_para_user_d_pav{ivid}.d_t_peak,...
            tfm_para_user_d_pav{ivid}.d_av_peak,...
            tfm_para_user_d_pav{ivid}.d_av_peak_std};
        %         xlRange = ['D',3];
        %         xlwrite(newfile,A2,sheet,xlRange)
        %forces
        A3 = {tfm_para_user_F_pav{ivid}.t_peak,...
            tfm_para_user_Fx_pav{ivid}.av_peak,...
            tfm_para_user_Fy_pav{ivid}.av_peak,...
            tfm_para_user_F_pav{ivid}.av_peak,...
            tfm_para_user_F_pav{ivid}.av_peak_std};
        %         xlRange = ['G',3];
        %         xlwrite(newfile,3,sheet,xlRange)
        %power
        A4 = {tfm_para_user_P_pav{ivid}.t_peak,...
            tfm_para_user_P_pav{ivid}.av_peak,...
            tfm_para_user_P_pav{ivid}.av_peak_std};
        %         xlRange = ['L',3];
        %         xlwrite(newfile,A4,sheet,xlRange)
        %strain
        A5 = {tfm_para_user_U_pav{ivid}.t_peak,...
            tfm_para_user_U_pav{ivid}.av_peak,...
            tfm_para_user_U_pav{ivid}.av_peak_std};
        %         xlRange = ['O',3];
        %         xlwrite(newfile,A5,sheet,xlRange)
        %moment
        A6 = {tfm_para_user_mu_pav{ivid}.t_peak,...
            tfm_para_user_mu_pav{ivid}.av_peak,...
            tfm_para_user_mu_pav{ivid}.av_peak_std,...
            tfm_para_user_mu_pav{ivid}.av_theta,...
            tfm_para_user_mu_pav{ivid}.av_theta_std,...
            tfm_para_user_mu_pav{ivid}.av_cent(:,1),...
            tfm_para_user_mu_pav{ivid}.av_cent(:,2),...
            tfm_para_user_mu_pav{ivid}.av_cent_std(:,1),...
            tfm_para_user_mu_pav{ivid}.av_cent_std(:,2)};
        %         xlRange = ['R',3];
        %         xlwrite(newfile,A6,sheet,xlRange)
        
        
        clear A
        A = {A1{1,:},A2{1,:},A3{1,:},A4{1,:},A5{1,:},A6{1,:}};
        C = nan(max(cellfun('size',A,1)),size(A,2));
        for sA2 = 1:size(A,2)
            C(1:size(A{1,sA2},1),sA2) = A{:,sA2};
        end
        
        xlRange = 'A3';
        status5 = xlwrite(newfile,C,sheet,xlRange);
        
    end
    
    %statusbar
    sb=statusbar(h_para.fig,'Saving - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    
    %check if user wants to save plots
    value = get(h_para.checkbox_save, 'Value');
    
    if value
        %loop over videos
        for ivid=1:tfm_init_user_Nfiles
            if isequal(exist([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots'], 'dir'),7)
                rmdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots'],'s')
            end
            %make output folder for displacements
            mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots'])
            
            %waitbar
            sb=statusbar(h_para.fig,['Saving curve plots... ',num2str(floor(100*(ivid-1)/sum(tfm_init_user_Nfiles))), '%% done']);
            sb.getComponent(0).setForeground(java.awt.Color.red);
            
            %d
            sh=figure('Visible','off');
            plot(tfm_para_user_dt{ivid},tfm_para_user_d{ivid})
            title('Displacement')
            xlabel('Time [s]')
            ylabel('Average displacement [m]')
            savefig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/displacement']);
            saveas(sh,[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/displacement','.png']);
            %export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/displacement'],'-png','-m1.5',sh);
            close(sh);
            %vel
            sh=figure('Visible','off');
            plot(tfm_para_user_dt{ivid},tfm_para_user_velocity{ivid})
            title('Velocity')
            xlabel('Time [s]')
            ylabel('Velocity [m/s]')
            savefig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/velocity']);
            export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/velocity'],'-png','-m1.5',sh);
            close(sh);
            %forces
            sh=figure('Visible','off');
            plot(tfm_para_user_dt{ivid},tfm_para_user_Fx_tot{ivid},'b'), hold on;
            plot(tfm_para_user_dt{ivid},tfm_para_user_Fy_tot{ivid},'r'), hold on;
            plot(tfm_para_user_dt{ivid},tfm_para_user_F_tot{ivid},'g'), hold on;
            legend('|Fx|','|Fy|','|F|')
            title('Forces')
            xlabel('Time [s]')
            ylabel('Forces [N]')
            savefig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/forces']);
            export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/forces'],'-png','-m1.5',sh);
            close(sh);
            %power
            sh=figure('Visible','off');
            plot(tfm_para_user_dt{ivid},tfm_para_user_power{ivid})
            title('Power')
            xlabel('Time [s]')
            ylabel('Power [W]')
            savefig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/power']);
            export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/power'],'-png','-m1.5',sh);
            close(sh);
            %strain
            sh=figure('Visible','off');
            plot(tfm_para_user_dt{ivid},tfm_para_user_U{ivid})
            title('Power')
            xlabel('Time [s]')
            ylabel('Strain [J]')
            savefig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/strain']);
            export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/strain'],'-png','-m1.5',sh);
            close(sh);
            %moment
            sh=figure('Visible','off');
            plot(tfm_para_user_dt{ivid},tfm_para_user_Mxx{ivid})
            title('Power')
            xlabel('Time [s]')
            ylabel('Mxx [Nm]')
            savefig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/Mxx']);
            export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/Mxx'],'-png','-m1.5',sh);
            close(sh);
            sh=figure('Visible','off');
            plot(tfm_para_user_dt{ivid},tfm_para_user_Mxy{ivid})
            title('Power')
            xlabel('Time [s]')
            ylabel('Mxy [Nm]')
            savefig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/Mxy']);
            export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/Mxy'],'-png','-m1.5',sh);
            close(sh);
            sh=figure('Visible','off');
            plot(tfm_para_user_dt{ivid},tfm_para_user_Myy{ivid})
            title('Power')
            xlabel('Time [s]')
            ylabel('Myy [Nm]')
            savefig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/Myy']);
            export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/Myy'],'-png','-m1.5',sh);
            close(sh);
            sh=figure('Visible','off');
            plot(tfm_para_user_dt{ivid},tfm_para_user_mu{ivid})
            title('Power')
            xlabel('Time [s]')
            ylabel('mu [Nm]')
            savefig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/mu']);
            export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Curve Plots/mu'],'-png','-m1.5',sh);
            close(sh);
            %orientation
            
            %center

        end
        %statusbar
        sb=statusbar(h_para.fig,'Saving - Done !');
        sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    end
    
    %check if user wants to save raw traction data
    value = get(h_para.checkbox_save_traction, 'Value');
    if value
        %loop over videos
        for ivid=1:tfm_init_user_Nfiles
            mask=double(tfm_init_user_binary2{ivid});
            mask(mask==0)=NaN;
            s_x = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_x.mat'],'x');
            s_y = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_y.mat'],'y');
            s_Fx = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_Fx.mat'],'Fx');
            s_Fy = load(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_Fy.mat'],'Fy');
            Fx_interp = zeros(s_y.y(end,end,1),s_x.x(end,end,1),size(s_x.x,3));
            Fy_interp = zeros(s_y.y(end,end,1),s_x.x(end,end,1),size(s_x.x,3));
            for frame=1:tfm_init_user_Nframes{ivid}
                %load spacing
                x=s_x.x(:,:,frame);
                y=s_y.y(:,:,frame);
                %load tfm data
                Fx=s_Fx.Fx(:,:,frame).*mask(y(:,1) ,x(1,:));
                Fy=s_Fy.Fy(:,:,frame).*mask(y(:,1) ,x(1,:));
                x_full = linspace(s_x.x(1,1,frame),s_x.x(end,end,frame),s_x.x(end,end,frame));
                y_full = linspace(s_y.y(1,1,frame),s_y.y(end,end,frame),s_y.y(end,end,frame));
                [x_full, y_full] = meshgrid(x_full,y_full);
                %interpolate to full frame
                Fx_interp(:,:,frame) = interp2(s_x.x(:,:,frame),s_y.y(:,:,frame),Fx,x_full,y_full);
                Fy_interp(:,:,frame) = interp2(s_x.x(:,:,frame),s_y.y(:,:,frame),Fx,x_full,y_full);           
            end
            %save in results folder
            if isequal(exist([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Traction Data'], 'dir'),7)
                rmdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Traction Data'],'s')
            end
            mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Traction Data'])
            save([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Traction Data/Fx_interp.mat'],'Fx_interp');
            save([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Traction Data/Fy_interp.mat'],'Fy_interp');
        end
    end
    
    %
    setappdata(0,'tfm_para_user_other_comments',tfm_para_user_other_comments);
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end


%userTiming.mainTiming{2} = toc(userTiming.mainTiming{1});
%setappdata(0,'userTiming',userTiming)

%save profile to html
%profsave(profile('info'),[tfm_init_user_pathnamestack{1} '/Profile']);
%profile off

%save user timing to file
%temp_table = struct2table(userTiming);
%writetable(temp_table,[tfm_init_user_pathnamestack{1},'UserTiming.csv']);
fprintf(1,'CXS-TFM: Data successfully saved in folder: %s\n',tfm_init_user_pathnamestack{1})

% send notif
myMessage='Saving results finished';
notif = getappdata(0,'notif');
if notif.on
    for i = size(notif.url)
        webwrite(notif.url{i},'value1',myMessage);
    end
end

%enable
enableDisableFig(h_para.fig,1);

%change main windows 3. button status
set(h_main.button_para,'ForegroundColor',[0 .5 0]);

%close window
close(h_para.fig);




function para_buttongroup_freq(hObject, eventdata, h_para)
%load shared needed para
tfm_para_user_d=getappdata(0,'tfm_para_user_d');
tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
freq=getappdata(0,'tfm_para_user_freq');
y_fft=getappdata(0,'tfm_para_user_y_fft');
dt=getappdata(0,'tfm_para_user_dt');
tfm_para_user_para_freq=getappdata(0,'tfm_para_user_para_freq');
tfm_para_user_para_freqy=getappdata(0,'tfm_para_user_para_freqy');
tfm_para_user_freq2=getappdata(0,'tfm_para_user_freq2');
tfm_para_user_para_freq2=getappdata(0,'tfm_para_user_para_freq2');
tfm_para_user_d_s = getappdata(0,'tfm_para_user_d_s');

if get(h_para.radiobutton_fft,'Value')
    %make unwanted buttons invisible
    set(h_para.button_freq_add,'Visible','off');
    set(h_para.button_freq_remove,'Visible','off');
    set(h_para.button_freq_clearall,'Visible','off');
    %enable wanted button
    set(h_para.button_freq_addfft,'Visible','on');
    %plot frequency. in axes
    x=tfm_para_user_para_freq{tfm_para_user_counter};
    y=tfm_para_user_para_freqy{tfm_para_user_counter};
    cla(h_para.axes_freq)
    axes(h_para.axes_freq)
    plot(freq{tfm_para_user_counter},y_fft{tfm_para_user_counter},'-b'), hold on;
    plot(x,y,'.g','MarkerSize',10)
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    set(gca, 'XLim', [0 5]);% freq{tfm_para_user_counter}(end)]);
    %set(gca, 'YLim', [0 max(y_fft{tfm_para_user_counter})]);
    %para
    set(h_para.text_freq1,'String',['f=',num2str(x,'%.2e'),'[Hz]']);
    set(h_para.text_freq2,'String',['T=',num2str(1/(x+eps),'%.2e'),'[s]']);
elseif get(h_para.radiobutton_pick,'Value')
    %make  buttons visible
    set(h_para.button_freq_add,'Visible','on');
    set(h_para.button_freq_remove,'Visible','on');
    set(h_para.button_freq_clearall,'Visible','on');
    %disable unwanted button
    set(h_para.button_freq_addfft,'Visible','off');
    %plot displ. in axes
    t_new=tfm_para_user_freq2{tfm_para_user_counter};
    x=1/(tfm_para_user_para_freq2{tfm_para_user_counter}+eps);
    cla(h_para.axes_freq)
    axes(h_para.axes_freq)
    plot(dt{tfm_para_user_counter},tfm_para_user_d{tfm_para_user_counter},'-b'), hold on;
    %plot delta t
    dtcontr=zeros(1,size(t_new,1));
    cmap = hsv(size(t_new,1));
    for i=1:size(t_new,1)
        plot(t_new(i,1),t_new(i,3),'.','Color',cmap(i,:),'MarkerSize',10)
        plot(t_new(i,2),t_new(i,4),'.','Color',cmap(i,:),'MarkerSize',10)
        dtcontr(1,i)=abs(t_new(i,2)-t_new(i,1));
        plot(linspace(t_new(i,1),t_new(i,2),100),linspace(0,0,100),'Color',cmap(i,:),'LineWidth',5)
    end
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %para
    set(h_para.text_freq1,'String',['f=',num2str(1/(x+eps),'%.2e'),'[Hz]']);
    set(h_para.text_freq2,'String',['T=',num2str(x,'%.2e'),'[s]']);
    
elseif get(h_para.radiobutton_autocorr,'Value')
    %make unwanted buttons invisible
    set(h_para.button_freq_add,'Visible','off');
    set(h_para.button_freq_remove,'Visible','off');
    set(h_para.button_freq_clearall,'Visible','off');
    %disable unwanted button
    set(h_para.button_freq_addfft,'Visible','off');
    
    cla(h_para.axes_freq)
    axes(h_para.axes_freq)
    plot(tfm_para_user_d_s{tfm_para_user_counter}.signal_t,tfm_para_user_d_s{tfm_para_user_counter}.autocorr_signal,'-m'), hold on;
    plot(tfm_para_user_d_s{tfm_para_user_counter}.autocorr_peaks_lags/tfm_para_user_d_s{tfm_para_user_counter}.framerate,tfm_para_user_d_s{tfm_para_user_counter}.autocorr_peaks,'ob','MarkerSize',3); hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %para
    set(h_para.text_freq1,'String',['f= XX [Hz]']);
    set(h_para.text_freq2,'String',['T= XX [s]']);
end


function para_buttongroup_forces(hObject, eventdata, h_para)

if get(h_para.radiobutton_forcetot,'Value') %ftot
    %load
    tfm_para_user_Fmax=getappdata(0,'tfm_para_user_Fmax');
    tfm_para_user_Fmin=getappdata(0,'tfm_para_user_Fmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_F_tot=getappdata(0,'tfm_para_user_F_tot');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_DeltaF=getappdata(0,'tfm_para_user_para_DeltaF');
    %set correct plot
    cla(h_para.axes_forces)
    axes(h_para.axes_forces)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_F_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
    plot(tfm_para_user_Fmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
    plot(tfm_para_user_Fmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %set correct text
    set(h_para.text_forces,'String',['F=',num2str(tfm_para_user_para_DeltaF{tfm_para_user_counter},'%.2e'),'[N]']);
elseif get(h_para.radiobutton_forcex,'Value') %fx
    %load
    tfm_para_user_Fxmax=getappdata(0,'tfm_para_user_Fxmax');
    tfm_para_user_Fxmin=getappdata(0,'tfm_para_user_Fxmin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Fx_tot=getappdata(0,'tfm_para_user_Fx_tot');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_DeltaFx=getappdata(0,'tfm_para_user_para_DeltaFx');
    %set correct plot
    cla(h_para.axes_forces)
    axes(h_para.axes_forces)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fx_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
    plot(tfm_para_user_Fxmax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
    plot(tfm_para_user_Fxmin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fxmin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %set correct text
    set(h_para.text_forces,'String',['Fx=',num2str(tfm_para_user_para_DeltaFx{tfm_para_user_counter},'%.2e'),'[N]']);
elseif get(h_para.radiobutton_forcey,'Value') %fy
    %load
    tfm_para_user_Fymax=getappdata(0,'tfm_para_user_Fymax');
    tfm_para_user_Fymin=getappdata(0,'tfm_para_user_Fymin');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Fy_tot=getappdata(0,'tfm_para_user_Fy_tot');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_DeltaFy=getappdata(0,'tfm_para_user_para_DeltaFy');
    %set correct plot
    cla(h_para.axes_forces)
    axes(h_para.axes_forces)
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Fy_tot{tfm_para_user_counter}*1e9,'-b'), hold on;
    plot(tfm_para_user_Fymax{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymax{tfm_para_user_counter}(:,2)*1e9,'.g','MarkerSize',10), hold on;
    plot(tfm_para_user_Fymin{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Fymin{tfm_para_user_counter}(:,2)*1e9,'.r','MarkerSize',10), hold on;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %set correct text
    set(h_para.text_forces,'String',['Fy=',num2str(tfm_para_user_para_DeltaFy{tfm_para_user_counter},'%.2e'),'[N]']);
end


function para_buttongroup_moments(hObject, eventdata, h_para)

if get(h_para.radiobutton_Mxx,'Value') %Mxx
    %load
    tfm_para_user_Mxx_max=getappdata(0,'tfm_para_user_Mxx_max');
    tfm_para_user_Mxx_min=getappdata(0,'tfm_para_user_Mxx_min');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Mxx=getappdata(0,'tfm_para_user_Mxx');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Mxx=getappdata(0,'tfm_para_user_para_Mxx');
    %set correct plot
    cla(h_para.axes_moment)
    axes(h_para.axes_moment)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Mxx{tfm_para_user_counter},'-b')
    plot(tfm_para_user_Mxx_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10)
    plot(tfm_para_user_Mxx_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Mxx_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10)
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %set correct text
    set(h_para.text_moment,'String',['Mxx=',num2str(tfm_para_user_para_Mxx{tfm_para_user_counter},'%.2e'),'[Nm]']);
elseif get(h_para.radiobutton_Myy,'Value') %Myy
    %load
    tfm_para_user_Myy_max=getappdata(0,'tfm_para_user_Myy_max');
    tfm_para_user_Myy_min=getappdata(0,'tfm_para_user_Myy_min');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_Myy=getappdata(0,'tfm_para_user_Myy');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_Myy=getappdata(0,'tfm_para_user_para_Myy');
    %set correct plot
    cla(h_para.axes_moment)
    axes(h_para.axes_moment)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_Myy{tfm_para_user_counter},'-b')
    plot(tfm_para_user_Myy_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10)
    plot(tfm_para_user_Myy_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_Myy_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10)
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %set correct text
    set(h_para.text_moment,'String',['Myy=',num2str(tfm_para_user_para_Myy{tfm_para_user_counter},'%.2e'),'[Nm]']);
elseif get(h_para.radiobutton_mu,'Value') %mu
    %load
    tfm_para_user_mu_max=getappdata(0,'tfm_para_user_mu_max');
    tfm_para_user_mu_min=getappdata(0,'tfm_para_user_mu_min');
    tfm_para_user_dt=getappdata(0,'tfm_para_user_dt');
    tfm_para_user_mu=getappdata(0,'tfm_para_user_mu');
    tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_para_user_para_mu=getappdata(0,'tfm_para_user_para_mu');
    %set correct plot
    cla(h_para.axes_moment)
    axes(h_para.axes_moment)
    plot(tfm_para_user_dt{tfm_para_user_counter},zeros(1,length(tfm_para_user_dt{tfm_para_user_counter})),'--k'), hold on;
    plot(tfm_para_user_dt{tfm_para_user_counter},tfm_para_user_mu{tfm_para_user_counter},'-b')
    plot(tfm_para_user_mu_max{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_max{tfm_para_user_counter}(:,2),'.g','MarkerSize',10)
    plot(tfm_para_user_mu_min{tfm_para_user_counter}(:,1)/tfm_init_user_framerate{tfm_para_user_counter},tfm_para_user_mu_min{tfm_para_user_counter}(:,2),'.r','MarkerSize',10)
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    %set correct text
    set(h_para.text_moment,'String',['mu=',num2str(tfm_para_user_para_mu{tfm_para_user_counter},'%.2e'),'[Nm]']);
end


function para_buttongroup_orient(hObject, eventdata, h_para)

%load
tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');
tfm_para_user_d=getappdata(0,'tfm_para_user_d');
tfm_para_user_center=getappdata(0,'tfm_para_user_center');
tfm_para_user_dtheta=getappdata(0,'tfm_para_user_dtheta');
tfm_para_user_Mxx=getappdata(0,'tfm_para_user_Mxx');

% sort center, orient by displacement
[d_sort,di] = sort(tfm_para_user_d{tfm_para_user_counter});
center_sort = tfm_para_user_center{tfm_para_user_counter}(di,:);
theta_sort = tfm_para_user_dtheta{tfm_para_user_counter}(di);
Mxx_sort = tfm_para_user_Mxx{tfm_para_user_counter}(di);

if get(h_para.radiobutton_center,'Value')
    %plot center of contraction
    reset(h_para.axes_orient)
    axes(h_para.axes_orient)
    [theta_center,r_center] = cart2pol(center_sort(:,1),center_sort(:,2));
    polarscatter(theta_center,r_center,10,d_sort,'filled');
    %set(gca, 'RTickLabel', []);
    set(gca, 'ThetaTickLabel', []);
    colorbar('southoutside','TickLabels',[])
    rlim([0 5e-6]);
    rticks([2.5e-6 5e-6]);
    rticklabels({'r = 2.5e-6 [m]',''});
elseif get(h_para.radiobutton_orient,'Value')
    %plot traction orientation
    reset(h_para.axes_orient)
    axes(h_para.axes_orient)
    polarscatter(theta_sort.*(pi/180),Mxx_sort,10,d_sort,'filled');
    set(gca, 'RTickLabel', []);
    set(gca, 'ThetaTickLabel', []);
    colorbar('southoutside','TickLabels',[]);
end


function para_checkbox_dpyes(hObject, eventdata, h_para)
% set(h_para.panel_dp2,'Visible','on');
set(h_para.checkbox_dpno,'Value',0);

tfm_para_user_para_tagdp=getappdata(0,'tfm_para_user_para_tagdp');
tfm_para_user_para_ratiodp=getappdata(0,'tfm_para_user_para_ratiodp');
tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');

%yes: tag dp
if get(h_para.checkbox_dpyes,'Value')
    tfm_para_user_para_tagdp{tfm_para_user_counter}=1;
else
    tfm_para_user_para_tagdp{tfm_para_user_counter}=0;
end
set(h_para.edit_dp2,'String',num2str(tfm_para_user_para_ratiodp{tfm_para_user_counter}))
setappdata(0,'tfm_para_user_para_tagdp',tfm_para_user_para_tagdp);


function para_checkbox_dpno(hObject, eventdata, h_para)
% set(h_para.panel_dp2,'Visible','off');
set(h_para.checkbox_dpyes,'Value',0);

tfm_para_user_para_tagdp=getappdata(0,'tfm_para_user_para_tagdp');
tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');

%yes: tag dp
if ~get(h_para.checkbox_dpno,'Value')
    tfm_para_user_para_tagdp{tfm_para_user_counter}=1;
else
    tfm_para_user_para_tagdp{tfm_para_user_counter}=0;
end
setappdata(0,'tfm_para_user_para_tagdp',tfm_para_user_para_tagdp);


function para_checkbox_disc(hObject, eventdata, h_para)
tfm_para_user_discard_tag=getappdata(0,'tfm_para_user_discard_tag');
tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');

%yes: tag disc
if get(h_para.checkbox_disc,'Value')
    tfm_para_user_discard_tag{tfm_para_user_counter}=1;
else
    tfm_para_user_discard_tag{tfm_para_user_counter}=0;
end
setappdata(0,'tfm_para_user_discard_tag',tfm_para_user_discard_tag);


function para_checkbox_dbl(hObject, eventdata, h_para)
tfm_para_user_dbl_tag=getappdata(0,'tfm_para_user_dbl_tag');
tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');

%yes: tag dp
if get(h_para.checkbox_dbl,'Value')
    tfm_para_user_dbl_tag{tfm_para_user_counter}=1;
else
    tfm_para_user_dbl_tag{tfm_para_user_counter}=0;
end
setappdata(0,'tfm_para_user_dbl_tag',tfm_para_user_dbl_tag);


function para_checkbox_drift(hObject, eventdata, h_para)
tfm_para_user_drift_tag=getappdata(0,'tfm_para_user_drift_tag');
tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');

%yes: tag dp
if get(h_para.checkbox_drift,'Value')
    tfm_para_user_drift_tag{tfm_para_user_counter}=1;
else
    tfm_para_user_drift_tag{tfm_para_user_counter}=0;
end
setappdata(0,'tfm_para_user_drift_tag',tfm_para_user_drift_tag);


function para_checkbox_other(hObject, eventdata, h_para)
tfm_para_user_other_tag=getappdata(0,'tfm_para_user_other_tag');
tfm_para_user_counter=getappdata(0,'tfm_para_user_counter');

%yes: tag dp
if get(h_para.checkbox_other,'Value')
    tfm_para_user_other_tag{tfm_para_user_counter}=1;
else
    tfm_para_user_other_tag{tfm_para_user_counter}=0;
end
setappdata(0,'tfm_para_user_other_tag',tfm_para_user_other_tag);

%
