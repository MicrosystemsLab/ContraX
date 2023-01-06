%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tfm_tfm.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part of the Streamlined TFM GUI: executes from the main Streamlined TFM 
% GUI menu after the Displacement step and computes the traction stress
% from the displacement using a Fourrier Transform Traction Cytometry
% (FTTC) algorithm
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

%main function for the tfm window of beads gui
function tfm_tfm(h_main)
fprintf(1,'\n');
fprintf(1,'CXS-TFM: TFM Module\n');

%userTiming= getappdata(0,'userTiming');
%userTiming.piv2tfm{2} = toc(userTiming.piv2tfm{1});

warning('off','MATLAB:MKDIR:DirectoryExists');

%create new window for tfm
%fig size
figsize=[470,800];
%get screen size
screensize = get(0,'ScreenSize');
%position fig on center of screen
xpos = ceil((screensize(3)-figsize(2))/2);
ypos = ceil((screensize(4)-figsize(1))/2);
%create fig; invisible at first
h_tfm.fig=figure(...
    'position',[xpos, ypos, figsize(2), figsize(1)],...
    'units','pixels',...
    'renderer','OpenGL',...
    'MenuBar','none',...
    'PaperPositionMode','auto',...
    'Name','ContraX Traction Forces',...
    'NumberTitle','off',...
    'Resize','off',...
    'Color',[.2,.2,.2],...
    'visible','off');

%color of the background and foreground
pcolor = [.2 .2 .2];
ptcolor = [1 1 1];
bcolor = [.3 .3 .3];
btcolor = [1 1 1];
h_tfm.ForegroundColor = ptcolor;
h_tfm.BackgroundColor = pcolor;
fontsizeA = 10;

%create uipanel for smartguess
%uipanel
h_tfm.panel_guess = uipanel('Parent',h_tfm.fig,'Title','Regularization','units','pixels','Position',[630,390,100,50]);
h_tfm.panel_guess.ForegroundColor = ptcolor;
h_tfm.panel_guess.BackgroundColor = pcolor;
%button
h_tfm.button_guess = uicontrol('Parent',h_tfm.panel_guess,'style','pushbutton','position',[5,10,87,25],'string','Guess all');

%create uipanel for settings
%uipanel
h_tfm.panel_settings = uipanel('Parent',h_tfm.fig,'Title','Settings','units','pixels','Position',[20,335,605,105]);
h_tfm.panel_settings.ForegroundColor = ptcolor;
h_tfm.panel_settings.BackgroundColor = pcolor;
%text: regul
h_tfm.text_regul = uicontrol('Parent',h_tfm.panel_settings,'style','text','position',[5,75,100,15],'string','Lambda','HorizontalAlignment','left');
h_tfm.text_regul.ForegroundColor = ptcolor;
h_tfm.text_regul.BackgroundColor = pcolor;
%text: youngs
h_tfm.text_youngs = uicontrol('Parent',h_tfm.panel_settings,'style','text','position',[5,60,100,15],'string','Substrate Young"s','HorizontalAlignment','left');
h_tfm.text_youngs.ForegroundColor = ptcolor;
h_tfm.text_youngs.BackgroundColor = pcolor;
%text: poisson
h_tfm.text_poisson = uicontrol('Parent',h_tfm.panel_settings,'style','text','position',[5,45,100,15],'string','Substrate Poisson"s','HorizontalAlignment','left');
h_tfm.text_poisson.ForegroundColor = ptcolor;
h_tfm.text_poisson.BackgroundColor = pcolor;
%text:traction limits
h_tfm.text_limits = uicontrol('Parent',h_tfm.panel_settings,'style','text','position',[180,70,100,15],'string','Visualization limits','HorizontalAlignment','left');
h_tfm.text_limits.ForegroundColor = ptcolor;
h_tfm.text_limits.BackgroundColor = pcolor;
%text:tmin
h_tfm.text_tmin = uicontrol('Parent',h_tfm.panel_settings,'style','text','position',[180,50,35,15],'string','T min.','HorizontalAlignment','left');
h_tfm.text_tmin.ForegroundColor = ptcolor;
h_tfm.text_tmin.BackgroundColor = pcolor;
%text:tmax
h_tfm.text_tmax = uicontrol('Parent',h_tfm.panel_settings,'style','text','position',[230,50,35,15],'string','T max.','HorizontalAlignment','left');
h_tfm.text_tmax.ForegroundColor = ptcolor;
h_tfm.text_tmax.BackgroundColor = pcolor;
%edit: regul
h_tfm.edit_regul = uicontrol('Parent',h_tfm.panel_settings,'style','edit','position',[105,75,40,15],'HorizontalAlignment','center');
%edit: youngs
% GASPARD's edit of Young's modulus default value to 3e4
%h_tfm.edit_youngs = uicontrol('Parent',h_tfm.panel_settings,'style','edit','position',[105,60,40,15],'HorizontalAlignment','center','String','1e4');
%h_tfm.edit_youngs = uicontrol('Parent',h_tfm.panel_settings,'style','edit','position',[105,60,40,15],'HorizontalAlignment','center','String','3e4');
h_tfm.edit_youngs = uicontrol('Parent',h_tfm.panel_settings,'style','edit','position',[105,60,40,15],'HorizontalAlignment','center');

%edit: poissons
%h_tfm.edit_poisson = uicontrol('Parent',h_tfm.panel_settings,'style','edit','position',[105,45,40,15],'HorizontalAlignment','center','String','0.4');
h_tfm.edit_poisson = uicontrol('Parent',h_tfm.panel_settings,'style','edit','position',[105,45,40,15],'HorizontalAlignment','center');

%radiobuttongroup
h_tfm.buttongroup_constrain = uibuttongroup('Parent',h_tfm.panel_settings,'Units', 'pixels','Position',[5,5,142,40]);
h_tfm.buttongroup_constrain.ForegroundColor = ptcolor;
h_tfm.buttongroup_constrain.BackgroundColor = pcolor;
%radiobutton 1: unconstrained
h_tfm.radiobutton_uncontrained = uicontrol('Parent',h_tfm.buttongroup_constrain,'style','radiobutton','position',[5,19,130,18],'string','unconstrained analysis','tag','radiobutton_unconstrained');
h_tfm.radiobutton_uncontrained.ForegroundColor = ptcolor;
h_tfm.radiobutton_uncontrained.BackgroundColor = pcolor;
%radiobutton 1: constrained
h_tfm.radiobutton_constrained = uicontrol('Parent',h_tfm.buttongroup_constrain,'style','radiobutton','position',[5,1,130,18],'string','constrained analysis','tag','radiobutton_constrained');
h_tfm.radiobutton_constrained.ForegroundColor = ptcolor;
h_tfm.radiobutton_constrained.BackgroundColor = pcolor;
%edit: tmin
h_tfm.edit_tmin = uicontrol('Parent',h_tfm.panel_settings,'style','edit','position',[180,35,35,15],'HorizontalAlignment','center');
%edit: tmax
h_tfm.edit_tmax = uicontrol('Parent',h_tfm.panel_settings,'style','edit','position',[230,35,35,15],'HorizontalAlignment','center');
%button: update
h_tfm.button_update = uicontrol('Parent',h_tfm.panel_settings,'style','pushbutton','position',[177,5,92,25],'string','Update preview');
%axes:
h_tfm.axes_settings = axes('Parent',h_tfm.panel_settings,'Units', 'pixels','Position',[285,5,200,85]);
%button: calculate all
h_tfm.button_calc = uicontrol('Parent',h_tfm.panel_settings,'style','pushbutton','position',[490,5,100,25],'string','Calculate all');
%button: forwards
h_tfm.button_forwards = uicontrol('Parent',h_tfm.panel_settings,'style','pushbutton','position',[515,67,25,25],'string','>');
%button: backwards
h_tfm.button_backwards = uicontrol('Parent',h_tfm.panel_settings,'style','pushbutton','position',[490,67,25,25],'string','<');
%text: show which video (i/n)
h_tfm.text_whichvid = uicontrol('Parent',h_tfm.panel_settings,'style','text','position',[545,75,25,15],'string','(1/1)','HorizontalAlignment','left');
h_tfm.text_whichvid.ForegroundColor = ptcolor;
h_tfm.text_whichvid.BackgroundColor = pcolor;
%text: show which video (name)
h_tfm.text_whichvidname = uicontrol('Parent',h_tfm.panel_settings,'style','text','position',[490,50,100,15],'string','Experiment','HorizontalAlignment','left');
h_tfm.text_whichvidname.ForegroundColor = ptcolor;
h_tfm.text_whichvidname.BackgroundColor = pcolor;

%uipanel for tfm calc preview
h_tfm.panel_tfm = uipanel('Parent',h_tfm.fig,'units','pixels','Position',[20,25,760,305]);
h_tfm.panel_tfm.ForegroundColor = ptcolor;
h_tfm.panel_tfm.BackgroundColor = pcolor;
h_tfm.axes_tfm = axes('Parent',h_tfm.panel_tfm,'Units', 'pixels','Position',[10,10,737,285]);

% h_tfm.panel_tfm_gif = uipanel('Parent',h_tfm.fig,'units','pixels','Position',[30,35,287,160]);
% h_tfm.axes_tfm_gif = axes('Parent',h_tfm.panel_tfm_gif,'Units', 'pixels','Position',[0,0,287,160]);%737,285]);

%create ok button
h_tfm.button_ok = uicontrol('Parent',h_tfm.fig,'style','pushbutton','position',[735,30,45,20],'string','OK','visible','on','FontWeight','bold'); % [735,413,45,20]
%create matrix save checkbox
h_tfm.checkbox_matrix = uicontrol('Parent',h_tfm.fig,'style','checkbox','position',[630,335,160,15],'string','Save traction matrices','HorizontalAlignment','left','value',1);
h_tfm.checkbox_matrix.ForegroundColor = ptcolor;
h_tfm.checkbox_matrix.BackgroundColor = pcolor;
%create heatmaps save checkbox
h_tfm.checkbox_heatmaps = uicontrol('Parent',h_tfm.fig,'style','checkbox','position',[630,355,160,15],'string','Save heatmaps','HorizontalAlignment','left');
h_tfm.checkbox_heatmaps.ForegroundColor = ptcolor;
h_tfm.checkbox_heatmaps.BackgroundColor = pcolor;

%callbacks for buttons and buttongroup
set(h_tfm.button_guess,'callback',{@tfm_push_guess,h_tfm})
set(h_tfm.button_update,'callback',{@tfm_push_update,h_tfm})
set(h_tfm.button_calc,'callback',{@tfm_push_calc,h_tfm,h_main})
set(h_tfm.button_forwards,'callback',{@tfm_push_forwards,h_tfm})
set(h_tfm.button_backwards,'callback',{@tfm_push_backwards,h_tfm})
set(h_tfm.button_ok,'callback',{@tfm_push_ok,h_tfm,h_main})
set(h_tfm.buttongroup_constrain,'SelectionChangeFcn',{@tfm_buttongroup_constrain,h_tfm})

%upon window openeing: make elements visible?unvisible
set(h_tfm.panel_settings,'visible','off')
set(h_tfm.panel_tfm,'visible','off')
%set(h_tfm.panel_tfm_gif,'visible','off')
set(h_tfm.button_ok,'visible','off')
set(h_tfm.checkbox_matrix,'visible','off')
set(h_tfm.checkbox_heatmaps,'visible','off')

%initiate counter
tfm_tfm_user_counter=1;

%Timing for tfm
%userTiming.tfm{1} = tic;

%store everything for shared use
%setappdata(0,'userTiming',userTiming);
setappdata(0,'tfm_tfm_user_counter',tfm_tfm_user_counter)

%make fig visible
set(h_tfm.fig,'visible','on');
%movegui(h_tfm.fig,'north');

%move main window to the side
% movegui(h_main.fig,'west')
% MH put the panel to the left of the main window
%  [left bottom width height]
fp = get(h_tfm.fig,'Position');
set(h_main.fig,'Units','pixels');
ap = get(h_main.fig,'Position');
set(h_main.fig,'Position',[fp(1)-ap(3) fp(2)+fp(4)-ap(4) ap(3) ap(4)]);

% initialize status bar
sb=statusbar(h_tfm.fig,'Ready');
sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));

% automatically trigger guess all
tfm_push_guess(h_tfm.button_guess, h_tfm, h_tfm, h_main)




function tfm_push_guess(hObject, eventdata, h_tfm, h_main)

%profile on

%disable figure during calculation
enableDisableFig(h_tfm.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_tfm.fig,1));

try
    %load shared needed para
    tfm_init_user_strln = getappdata(0,'tfm_init_user_strln');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_tfm_user_counter=getappdata(0,'tfm_tfm_user_counter');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_piv_user_contr=getappdata(0,'tfm_piv_user_contr');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    use_parallel=getappdata(0,'use_parallel');
    
    %initial values
    %E=str2double(get(h_tfm.edit_youngs,'String'));
    %nu=str2double(get(h_tfm.edit_poisson,'String'));
    
    %initialize
    tfm_tfm_user_lambda=cell(1,tfm_init_user_Nfiles);
    tfm_tfm_user_clims=cell(1,tfm_init_user_Nfiles);
    tfm_tfm_user_preview_V=cell(1,tfm_init_user_Nfiles);
    tfm_tfm_user_preview_x1=cell(1,tfm_init_user_Nfiles);
    tfm_tfm_user_preview_y1=cell(1,tfm_init_user_Nfiles);
    tfm_tfm_user_preview_u1_0=cell(1,tfm_init_user_Nfiles);
    tfm_tfm_user_preview_v1_0=cell(1,tfm_init_user_Nfiles);
    tfm_tfm_user_constraintval=ones(1,tfm_init_user_Nfiles);
    
    
    %waitbar
    %hf = waitbar(0,'SmartGuessing. Please wait...');
    sb=statusbar(h_tfm.fig,'Calculating regularization...');
    sb.getComponent(0).setForeground(java.awt.Color.red);
    
    parfor (current_vid=1:tfm_init_user_Nfiles, use_parallel)
%    for current_vid=1:tfm_init_user_Nfiles
        %hf=waitbar(current_vid/tfm_init_user_Nfiles,hf);
        %statusbar
%         sb=statusbar(h_tfm.fig,['Calculating regularization: video ',num2str(current_vid),'/',num2str(tfm_init_user_Nfiles),'... ',num2str(floor(100*(current_vid-1)/tfm_init_user_Nfiles)), '%% done']);
%         sb.getComponent(0).setForeground(java.awt.Color.red);
        disp(['Guessing regularization for video #',num2str(current_vid)])
        
        %get displacmenets from calc. before
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_x.mat']); %FOSTER
        tfm_piv_user_xs=s.x(:,:,1);
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_y.mat']);
        tfm_piv_user_ys=s.y(:,:,1);
        
        tfm_piv_user_dismask=double(tfm_init_user_binary1{current_vid}(tfm_piv_user_ys(:,1) ,tfm_piv_user_xs(1,:)));
        %tfm_piv_user_dismask=ones(size(tfm_piv_user_xs));
        
        %
        contr=tfm_piv_user_contr{current_vid};
        relax=tfm_piv_user_relax{current_vid};
        
        %save inital values
        %tfm_tfm_user_E{current_vid}=E;
        %tfm_tfm_user_nu{current_vid}=nu;
        E=tfm_init_user_E{current_vid};
        nu=tfm_init_user_nu{current_vid};
        
        %tfm between relax and contr
        [ ~,x1,y1,~,~,u1_0,v1_0,V,lambda,~,~] = calculate_tfm_regul(tfm_init_user_filenamestack{1,current_vid},relax,contr,contr,tfm_piv_user_dismask,E,nu,tfm_init_user_conversion{current_vid});
        x1 = x1;
        y1 = y1;
        %save for later use
        [Xqu,Yqu]=meshgrid(x1(1):x1(end),y1(1):y1(end));
        maskV=double(tfm_init_user_binary1{current_vid}(Yqu(:,1) ,Xqu(1,:)));
        tfm_tfm_user_preview_V{current_vid}=V;
        tfm_tfm_user_preview_x1{current_vid}=x1;
        tfm_tfm_user_preview_y1{current_vid}=y1;
        tfm_tfm_user_preview_u1_0{current_vid}=u1_0;
        tfm_tfm_user_preview_v1_0{current_vid}=v1_0;
        tfm_tfm_user_lambda{current_vid}=lambda;
        tfm_tfm_user_clims{current_vid}=[.2*max(max(V.*maskV)),.8*max(max(V.*maskV))];
        
    end
    %new statusbar text
    sb=statusbar(h_tfm.fig,'SmartGuessing - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %make second panel visible
    set(h_tfm.panel_settings,'Visible','on');
    
    %%now display this info for 1st video.
    set(h_tfm.edit_regul,'String',num2str(tfm_tfm_user_lambda{tfm_tfm_user_counter}));
    set(h_tfm.edit_tmin,'String',num2str(tfm_tfm_user_clims{tfm_tfm_user_counter}(1)));
    set(h_tfm.edit_tmax,'String',num2str(tfm_tfm_user_clims{tfm_tfm_user_counter}(2)));
    set(h_tfm.edit_youngs,'String',num2str(tfm_init_user_E{tfm_tfm_user_counter}));
    set(h_tfm.edit_poisson,'String',num2str(tfm_init_user_nu{tfm_tfm_user_counter}));
    
    %plot heat plot
    axes(h_tfm.axes_settings);
    imagesc( tfm_tfm_user_preview_V{tfm_tfm_user_counter},tfm_tfm_user_clims{tfm_tfm_user_counter}); axis image; colormap parula; hold on;
    %quiver(tfm_tfm_user_preview_x1{1},tfm_tfm_user_preview_y1{1},tfm_tfm_user_preview_u1_0{1},tfm_tfm_user_preview_v1_0{1},'r');
    set(h_tfm.axes_settings, 'XTick', []);
    set(h_tfm.axes_settings, 'YTick', []);
    
    %disable backwards button
    set(h_tfm.button_backwards,'Enable','off');
    %if vid<vidtot, enable forward button
    if 1==tfm_init_user_Nfiles
        set(h_tfm.button_forwards,'Enable','off');
    end
    %disable regularization edit
    set(h_tfm.edit_regul,'Enable','off');
    
    %store everything for shared use
    setappdata(0,'tfm_init_user_E',tfm_init_user_E)
    setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
    setappdata(0,'tfm_tfm_user_lambda',tfm_tfm_user_lambda)
    setappdata(0,'tfm_tfm_user_clims',tfm_tfm_user_clims)
    setappdata(0,'tfm_tfm_user_preview_V',tfm_tfm_user_preview_V)
    setappdata(0,'tfm_tfm_user_preview_x1',tfm_tfm_user_preview_x1)
    setappdata(0,'tfm_tfm_user_preview_y1',tfm_tfm_user_preview_y1)
    setappdata(0,'tfm_tfm_user_preview_u1_0',tfm_tfm_user_preview_u1_0)
    setappdata(0,'tfm_tfm_user_preview_v1_0',tfm_tfm_user_preview_v1_0)
    setappdata(0,'tfm_tfm_user_constraintval',tfm_tfm_user_constraintval)

    
    %profile viewer
    %userTiming= getappdata(0,'userTiming');
    %userTiming.disp2ref{1} = tic;
    
    %store everything for shared use
    %setappdata(0,'userTiming',userTiming)

    % send notif
    %myMessage='Regularization calculation finished';
    %notif = getappdata(0,'notif');
    %if notif.on
    %    for i = size(notif.url)
    %        webwrite(notif.url{i},'value1',myMessage);
    %    end
    %end


catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

%Streamlining
if tfm_init_user_strln
    tfm_push_calc(h_tfm.button_calc, h_tfm, h_tfm, h_main)
end


%% tfm_push_update
function tfm_push_update(hObject, eventdata, h_tfm)

%profile on

%disable figure during calculation
enableDisableFig(h_tfm.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_tfm.fig,1));

try
    %load shared needed para
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary2=getappdata(0,'tfm_init_user_binary2');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_piv_user_contr=getappdata(0,'tfm_piv_user_contr');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    tfm_tfm_user_lambda=getappdata(0,'tfm_tfm_user_lambda');
    tfm_tfm_user_clims=getappdata(0,'tfm_tfm_user_clims');
    tfm_tfm_user_preview_V=getappdata(0,'tfm_tfm_user_preview_V');
    tfm_tfm_user_preview_x1=getappdata(0,'tfm_tfm_user_preview_x1');
    tfm_tfm_user_preview_y1=getappdata(0,'tfm_tfm_user_preview_y1');
    tfm_tfm_user_preview_u1_0=getappdata(0,'tfm_tfm_user_preview_u1_0');
    tfm_tfm_user_preview_v1_0=getappdata(0,'tfm_tfm_user_preview_v1_0');
    tfm_tfm_user_counter=getappdata(0,'tfm_tfm_user_counter');
    tfm_tfm_user_constraintval=getappdata(0,'tfm_tfm_user_constraintval');
    
    
    %statusbar
    sb=statusbar(h_tfm.fig,'Updating');
    sb.getComponent(0).setForeground(java.awt.Color(1,0,0));
    
    %which vid are we at?
    current_vid=tfm_tfm_user_counter;
    
    %read values
    E=str2double(get(h_tfm.edit_youngs,'String'));
    nu=str2double(get(h_tfm.edit_poisson,'String'));
    clims = [str2double(get(h_tfm.edit_tmin,'String')),str2double(get(h_tfm.edit_tmax,'String'))];
    
    
    s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_x.mat']);
    tfm_piv_user_xs= s.x(:,:,1);
    s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,current_vid},'/tfm_piv_y.mat']);
    tfm_piv_user_ys= s.y(:,:,1);
    
    
    %mask
    tfm_piv_user_dismask=double(tfm_init_user_binary1{current_vid}(tfm_piv_user_ys(:,1) ,tfm_piv_user_xs(1,:)));
    mask_all=double(tfm_init_user_binary1{current_vid}(tfm_piv_user_ys(:,1) ,tfm_piv_user_xs(1,:)));
    %     mask_all=ones(size(tfm_piv_user_ys));
    %
    contr=tfm_piv_user_contr{current_vid};
    relax=tfm_piv_user_relax{current_vid};
    
    %save inital values
    tfm_init_user_E{current_vid}=E;
    tfm_init_user_nu{current_vid}=nu;
    tfm_tfm_user_clims{current_vid}=clims;
    
    %tfm between relax and contr
    if tfm_tfm_user_constraintval(tfm_tfm_user_counter)==1 %unconstrained
        [ ~,x1,y1,~,~,u1_0,v1_0,V,~,~,~,~,~,~,~,~] = calculate_tfm(tfm_init_user_filenamestack{1,current_vid},relax,contr,contr,mask_all,E,nu,tfm_tfm_user_lambda{current_vid},tfm_init_user_conversion{current_vid});
    elseif tfm_tfm_user_constraintval(tfm_tfm_user_counter)==2 %constrained
        [ ~,x1,y1,~,~,u1_0,v1_0,V,~,~,~,~,~,~,~] = calculate_tfm_constrain(tfm_init_user_filenamestack{1,current_vid},relax,contr,contr,mask_all,tfm_piv_user_dismask,E,nu,tfm_init_user_conversion{current_vid});
    end
    
    %save for later use
    %[Xqu,Yqu]=meshgrid(x1(1):x1(end),y1(1):y1(end));
    %maskV=double(tfm_init_user_binary2{current_vid}(Yqu(:,1) ,Xqu(1,:)));
    tfm_tfm_user_preview_V{current_vid}=V;
    tfm_tfm_user_preview_x1{current_vid}=x1;
    tfm_tfm_user_preview_y1{current_vid}=y1;
    tfm_tfm_user_preview_u1_0{current_vid}=u1_0;
    tfm_tfm_user_preview_v1_0{current_vid}=v1_0;
    
    %new statusbar text
    sb=statusbar(h_tfm.fig,'Update - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %plot heat plot
    axes(h_tfm.axes_settings);
    imagesc( tfm_tfm_user_preview_V{tfm_tfm_user_counter},clims); axis image; colormap parula; hold on;
    %quiver(tfm_tfm_user_preview_x1{1},tfm_tfm_user_preview_y1{1},tfm_tfm_user_preview_u1_0{1},tfm_tfm_user_preview_v1_0{1},'r');
    set(h_tfm.axes_settings, 'XTick', []);
    set(h_tfm.axes_settings, 'YTick', []);
    
    if tfm_tfm_user_counter==1
        set(h_tfm.button_backwards,'Enable','off');
    else
        set(h_tfm.button_backwards,'Enable','on');
    end
    if tfm_tfm_user_counter<tfm_init_user_Nfiles
        set(h_tfm.button_forwards,'Enable','on');
    else
        set(h_tfm.button_forwards,'Enable','off');
    end
    %disable regularization edit
    set(h_tfm.edit_regul,'Enable','off');
    
    %store everything for shared use
    setappdata(0,'tfm_init_user_E',tfm_init_user_E)
    setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
    setappdata(0,'tfm_tfm_user_clims',tfm_tfm_user_clims)
    setappdata(0,'tfm_tfm_user_preview_V',tfm_tfm_user_preview_V)
    setappdata(0,'tfm_tfm_user_preview_x1',tfm_tfm_user_preview_x1)
    setappdata(0,'tfm_tfm_user_preview_y1',tfm_tfm_user_preview_y1)
    setappdata(0,'tfm_tfm_user_preview_u1_0',tfm_tfm_user_preview_u1_0)
    setappdata(0,'tfm_tfm_user_preview_v1_0',tfm_tfm_user_preview_v1_0)
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

%profile viewer

%% The 'Calculate all' button callback
function tfm_push_calc(hObject, eventdata, h_tfm, h_main)

%profile on
%userTiming= getappdata(0,'userTiming');
%userTiming.disp2ref{2} = toc(userTiming.disp2ref{1});

%store everything for shared use
%setappdata(0,'userTiming',userTiming)

%disable figure during calculation
enableDisableFig(h_tfm.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_tfm.fig,1));

try
    
    %load what shared para we need
    tfm_init_user_strln = getappdata(0,'tfm_init_user_strln');
    tfm_tfm_user_counter=getappdata(0,'tfm_tfm_user_counter');
    tfm_init_user_conversion=getappdata(0,'tfm_init_user_conversion');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_framerate=getappdata(0,'tfm_init_user_framerate');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_bf_preview_frame1=getappdata(0,'tfm_init_user_bf_preview_frame1');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    tfm_tfm_user_lambda=getappdata(0,'tfm_tfm_user_lambda');
    tfm_tfm_user_clims=getappdata(0,'tfm_tfm_user_clims');
    tfm_piv_user_relax=getappdata(0,'tfm_piv_user_relax');
    tfm_piv_user_contr=getappdata(0,'tfm_piv_user_contr');
    tfm_init_user_binary1=getappdata(0,'tfm_init_user_binary1');
    tfm_init_user_binary2=getappdata(0,'tfm_init_user_binary2');
    tfm_tfm_user_constraintval=getappdata(0,'tfm_tfm_user_constraintval');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_outline2x=getappdata(0,'tfm_init_user_outline2x');
    tfm_init_user_outline2y=getappdata(0,'tfm_init_user_outline2y');
    use_parallel = getappdata(0,'use_parallel');
    
    % overwrite current values
    tfm_init_user_E{tfm_tfm_user_counter}=str2double(get(h_tfm.edit_youngs,'String'));
    tfm_init_user_nu{tfm_tfm_user_counter}=str2double(get(h_tfm.edit_poisson,'String'));
    tfm_tfm_user_clims{tfm_tfm_user_counter}=[str2double(get(h_tfm.edit_tmin,'String')),str2double(get(h_tfm.edit_tmax,'String'))];
    
    
    sb=statusbar(h_tfm.fig,'Calculating TFM... ');
    sb.getComponent(0).setForeground(java.awt.Color.red);
    
    tfm_piv_user_xs = cell(tfm_init_user_Nfiles);
    tfm_piv_user_ys = cell(tfm_init_user_Nfiles);
    for ivid=1:tfm_init_user_Nfiles
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_x.mat']); %FOSTER
        tfm_piv_user_xs{ivid}=s.x(:,:,1);
        s=matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_y.mat']);
        tfm_piv_user_ys{ivid}=s.y(:,:,1);
    end

    %w_i=0;
    fprintf(1,'CXS-TFM: TF Calculations...\n');
    parfor (ivid=1:tfm_init_user_Nfiles, use_parallel)
    %for ivid=1:tfm_init_user_Nfiles
		tstartTFM = tic;
        
        %create folder to save disp.
        [mf,mf2] = mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots']);  %#ok<ASGLU> 
        [mf,mf2] = mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Traction Heatmaps']);  %#ok<ASGLU> 

% removed for parfor                    
%         reset(h_tfm.axes_tfm);
%         cla(h_tfm.axes_tfm);
%         set(h_tfm.panel_tfm,'visible','on')
        
%         reset(h_tfm.axes_tfm_gif)
%         cla(h_tfm.axes_tfm_gif)
%         set(h_tfm.panel_tfm_gif,'visible','off');
               
        
%removed for parfor

        Num=tfm_init_user_Nframes{ivid};
        E=tfm_init_user_E{ivid};
        nu=tfm_init_user_nu{ivid};
        lambda=tfm_tfm_user_lambda{ivid};
        clims=tfm_tfm_user_clims{ivid};
        
        %mask
        tfm_piv_user_dismask=double(tfm_init_user_binary1{ivid}(tfm_piv_user_ys{ivid}(:,1) ,tfm_piv_user_xs{ivid}(1,:)));
        mask_all=double(tfm_init_user_binary1{ivid}(tfm_piv_user_ys{ivid}(:,1) ,tfm_piv_user_xs{ivid}(1,:)));
        %             mask_all=ones(size(tfm_piv_user_ys));
        
        cell_outline=bwperim(tfm_init_user_binary1{ivid});
        elipse_outline=bwperim(tfm_init_user_binary2{ivid});
        %tfm_init_user_outline1x{ivid}=BWoutline{1}(:,2);
        %tfm_init_user_outline1y{ivid}=BWoutline{1}(:,1);
        
        contr=tfm_piv_user_contr{ivid};
        relax=tfm_piv_user_relax{ivid};
        
        % compress BF image and convert to rgb
        im = tfm_init_user_bf_preview_frame1{ivid};
        gif_size = min(size(im),[160,287]);
        im = imresize(im,'OutputSize',gif_size);
        cell_outline = imresize(cell_outline,'OutputSize',gif_size);
        elipse_outline = imresize(elipse_outline,'OutputSize',gif_size);
        
        %FOSTER
        im_rgb = cat(3,im,im,im);
        im_rgb = imoverlay(im_rgb,cell_outline,[1 0 0]);
        im_rgb = imoverlay(im_rgb,elipse_outline,[0 0 1]);
        im_gif = zeros([gif_size,1,Num]);
        
        V=0; % this just eliminates a MATLAB warning about uninitialized variables
        %Run tfm to calculate the first frame of the gif
        if tfm_tfm_user_constraintval(ivid)==1 %unconstrained
            [ ~,~,~,~,~,~,~,V,~,~,~,~,~,~,~,~] = calculate_tfm(tfm_init_user_filenamestack{1,ivid},tfm_piv_user_relax{ivid},tfm_piv_user_contr{ivid},contr,mask_all,E,nu,lambda,tfm_init_user_conversion{ivid});
        elseif tfm_tfm_user_constraintval(ivid)==2 %constrained
            [ ~,~,~,~,~,~,~,V,~,~,~,~,~,~,~,~] = calculate_tfm_constrain(tfm_init_user_filenamestack{1,ivid},relax,contr,contr,mask_all,tfm_piv_user_dismask,E,nu,tfm_init_user_conversion{ivid});
        end
        
        V_rgb = interp1(linspace(clims(1), clims(2)/0.8,256),1:256,V);
        V_rgb = round(imresize(V_rgb,'OutputSize',gif_size));
        V_rgb(isnan(V_rgb)) = 128;
        V_rgb(V_rgb>256) = 256;
        V_rgb(V_rgb<1) = 1;
        cmapt = parula(256);
        cmapt(128,:) = [0.5 0.5 0.5];
        V_rgb = reshape(cmapt(V_rgb,:),[size(V_rgb),3]);
        gif = imfuse(im_rgb,V_rgb,'blend','Scaling','none');
        
        [im_gif,cmap] = rgb2ind(gif,256);
        
        %Removed for parfor
        %clear V;
        
        %FOSTER pre-define all parameter variables as 3D arrays 
        s = matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_x.mat']);
        sample_frame_x = s.x(:,:,1);
        s = matfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_piv_y.mat']);
        sample_frame_y = s.y(:,:,1);
        [Xqu,~]=meshgrid(sample_frame_x(1):sample_frame_x(end),sample_frame_y(1):sample_frame_y(end));
        [rows, cols] = size(sample_frame_x);
        theta2 = zeros(1,Num);
        xr = zeros(rows,cols,Num);
        yr = zeros(rows,cols,Num);
        ur = zeros(rows,cols,Num);
        vr = zeros(rows,cols,Num);
        u1_0 = zeros(rows,cols,Num);
        v1_0 = zeros(rows,cols,Num);
        V = zeros(size(Xqu,1),size(Xqu,2),Num);
        absd = zeros(rows,cols,Num);
        Fx = zeros(rows,cols,Num);
        Fy = zeros(rows,cols,Num);
        F = zeros(rows,cols,Num);
        Trx = zeros(rows,cols,Num);
        Try = zeros(rows,cols,Num);
        v = zeros(rows,cols,Num);
        M = zeros(2,2,Num);
       
        % perform TFM calcs on each pair of frames in video #ivid
        for frame=1:Num %does not work well and fills the RAM...
%        for frame=1:Num
            %disp(frame)
            %statusbar
            %w_i=w_i+1;
            %sb=statusbar(h_tfm.fig,['Calculating Video ',num2str(ivid),'/',num2str(tfm_init_user_Nfiles),' frame ',num2str(frame),'/',num2str(Num),'... ',num2str(floor(100*(w_i-1)/sum([tfm_init_user_Nframes{:}]))), '%% done']);
            %sb.getComponent(0).setForeground(java.awt.Color.red);
           
           
            %tfm
            if tfm_tfm_user_constraintval(ivid)==1 %unconstrained
                [ theta2(:,frame),xr(:,:,frame),yr(:,:,frame),ur(:,:,frame),vr(:,:,frame),u1_0(:,:,frame),v1_0(:,:,frame),V(:,:,frame),absd(:,:,frame),Fx(:,:,frame),Fy(:,:,frame),F(:,:,frame),Trx(:,:,frame),Try(:,:,frame),v(:,:,frame),M(:,:,frame)] = calculate_tfm(tfm_init_user_filenamestack{1,ivid},tfm_piv_user_relax{ivid},tfm_piv_user_contr{ivid},frame,mask_all,E,nu,lambda,tfm_init_user_conversion{ivid});
            elseif tfm_tfm_user_constraintval(ivid)==2 %constrained
                [ theta2(frame),xr(:,:,frame),yr(:,:,frame),ur(:,:,frame),vr(:,:,frame),u1_0(:,:,frame),v1_0(:,:,frame),V(:,:,frame),absd(:,:,frame),Fx(:,:,frame),Fy(:,:,frame),F(:,:,frame),Trx(:,:,frame),Try(:,:,frame),v(:,:,frame),M(:,:,frame)] = calculate_tfm_constrain(tfm_init_user_filenamestack{1,ivid},relax,contr,frame,mask_all,tfm_piv_user_dismask,E,nu,tfm_init_user_conversion{ivid});
            end
            
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_dtheta_',num2str(frame),'.mat'],'theta2','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_xr_',num2str(frame),'.mat'],'xr','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_yr_',num2str(frame),'.mat'],'yr','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_ur_',num2str(frame),'.mat'],'ur','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_vr_',num2str(frame),'.mat'],'vr','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_absd_',num2str(frame),'.mat'],'absd','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_Fx_',num2str(frame),'.mat'],'Fx','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_Fy_',num2str(frame),'.mat'],'Fy','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_F_',num2str(frame),'.mat'],'F','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_Trx_',num2str(frame),'.mat'],'Trx','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_Try_',num2str(frame),'.mat'],'Try','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_v_',num2str(frame),'.mat'],'v','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_V_',num2str(frame),'.mat'],'V','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_u1_0_',num2str(frame),'.mat'],'u1_0','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_v1_0_',num2str(frame),'.mat'],'v1_0','-v7.3')
%             save(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_M_',num2str(frame),'.mat'],'M','-v7.3')
            
            %plot heat plot
            %cla(h_tfm.axes_tfm);

% removed for parfor            
%             imagesc(V,'Parent',h_tfm.axes_tfm,clims);
%             set(h_tfm.axes_tfm, 'XTick', []);
%             set(h_tfm.axes_tfm, 'YTick', []);
%             %colorbar;
%             hold on;
%             plot(tfm_init_user_outline2x{ivid},tfm_init_user_outline2y{ivid},'g','LineWidth',1);

            %hold off
            %quiver(x1,y1,u1_0,v1_0,'r');
            
            
            V_rgb = interp1(linspace(clims(1), clims(2)/0.8,256),1:256,V(:,:,frame));
            V_rgb = round(imresize(V_rgb,'OutputSize',gif_size));
            V_rgb(isnan(V_rgb)) = 128;
            V_rgb(V_rgb>256) = 256;
            V_rgb(V_rgb<1) = 1;
            V_rgb = reshape(cmapt(V_rgb,:),[size(V_rgb),3]);
            gif = imfuse(im_rgb,V_rgb,'blend','Scaling','none');
            im_gif(:,:,1,frame) = rgb2ind(gif,cmap);
        
            
%             V_rgb = round(interp1(linspace(clims(1)/0.5, clims(2)/0.8,256),1:256,V));
%             mask = isnan(V_rgb);
%             V_rgb(mask) = 256;
%             V_rgb = reshape(cmapt(V_rgb,:),[size(V_rgb),3]);
%             V_rgb([mask mask mask]) = im_rgb([mask mask mask]);%NaN
%             V_rgb = imresize(V_rgb,'OutputSize',gif_size);
%             gif_i = imfuse(im_rgb,V_rgb,'blend','Scaling','none');            
%             im_gif(:,:,1,frame) = rgb2ind(gif_i,gcmap);

            %JFM
            %              save png
            %              c=figure('visible','off');
            %              imagesc(V,clims); colormap parula; hold on;
            %              plot(tfm_init_user_outline2x{ivid},tfm_init_user_outline2y{ivid},'g','LineWidth',1);
            %              set(gca,'xtick',[],'ytick',[])
            %              axis image;
            %              colorbar;
            %              export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Traction Heatmaps/heatmap',int2str(frame)],'-png','-m1.5',c);
            %             close(c)
            %+++++++++
            
            %TO DELETE
            %+++++++++
            %             % create gif
            %             % resize V matrix
            %             hmap_im = mat2gray(V,clims);
            %             hmap_im = imresize(hmap_im,'OutputSize',[160,287]);
            %             p=figure('visible','off');
            %             %             cla(h_tfm.axes_tfm_gif);
            %             %             axes(h_tfm.axes_tfm_gif);
            %             imshow(im_rgb); hold on;
            %             hmap=imagesc(hmap_im,'AlphaData',hmap_im);
            %             %             set(h_tfm.axes_tfm_gif, 'XTick', []);
            %             %             set(h_tfm.axes_tfm_gif, 'YTick', []);
            %
            %             %colormap jet;
            %             %plot(tfm_init_user_outline2x{ivid},tfm_init_user_outline2y{ivid},'g','LineWidth',2);
            %             %set(gca,'xtick',[],'ytick',[])
            %             % axis image;
            %             % colorbar;
            %             % save png
            %             % export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Traction Heatmaps/heatmap',int2str(frame)],'-png','-m1.5',p);
            %             % colorbar;
            %             % adjust transparency
            %             % alphamap = mat2gray(V,clims);
            %             % hmap.AlphaData = hmap_im;
            %
            %             % save gif frame
            %             frm = getframe(imgca(p));
            %             %close(p)
            %+++++++++

        % save heatmap with colorbar
        p=figure('visible','on');
        imagesc(V(:,:,frame)); colormap parula; hold on;
        plot(tfm_init_user_outline2x{ivid},tfm_init_user_outline2y{ivid},'g','LineWidth',1);
        set(gca,'xtick',[],'ytick',[])
        axis image;
        colorbar;
        saveas(p,[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Traction Heatmaps/heatmap',int2str(frame),'.png']);
        %export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Traction Heatmaps/heatmap',int2str(frame)],'-png','-m1.5',p);
        close(p)


        end % End frame-to-frame TFM calcs
        %save to mat
        save2disk(theta2,xr,yr,ur,vr,absd,Fx,Fy,F,Trx,Try,v,V,u1_0,v1_0,M,tfm_init_user_filenamestack{1,ivid})

   
        % write gif
        delay = 1/tfm_init_user_framerate{ivid};
        imwrite(im_gif,cmap,[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/heatmap_anim.gif'],'gif','Loopcount',Inf,'DelayTime',delay);
        
        %FOSTER'S EDITS
        %compare tfm heatmaps to displacement heatmaps generated earlier
%         for frame = 1:size(im_gif,4)
%             %load appropriate displacement heatmap
%             disp_heatmap_path = strcat(tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid}, '/Plots/Displacement Heatmaps/heatmap', num2str(frame),'.png');
%             disp_heatmap = imread(disp_heatmap_path);
%             tfm_heatmap = im_gif(:,:,1,frame);
%             diff_heatmap = disp_heatmap - im_gif(frame);
%             p = figure('visible','off');
%             imagesc(diff_heatmap);colormap('parula');
%             caxis([0,10]);
%             set(gca,'xtick',[],'ytick',[]);
%             set(gca,'linewidth',2);
%             axis image;
%      
%             export_fig([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Difference Heatmaps/heatmap',int2str(frame)],'-png','-m1.5',p);
%             close(p);
%         end

        
        % reset gif ims
        hmap_im = [];
        im_gif = [];
		
		fprintf(1,' Traction stress calculation for video #%d completed in %.02f s\n',ivid,toc(tstartTFM));
    end

    %statusbar
    sb=statusbar(h_tfm.fig,'Calculation - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
    %ok button and checkboxes
    set(h_tfm.button_ok,'Visible','on');
    set(h_tfm.checkbox_heatmaps,'Visible','on');
    set(h_tfm.checkbox_matrix,'Visible','on');
    
    %profile viewer
    
    % send notif
%     myMessage='TFM calculation finished';
%     notif = getappdata(0,'notif');
%     if notif.on
%         for i = size(notif.url)
%             webwrite(notif.url{i},'value1',myMessage);
%         end
%     end

catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

%Streamlining
if tfm_init_user_strln
    tfm_push_ok(h_tfm.button_ok, h_tfm, h_tfm, h_main)
end

function save2disk(theta2,xr,yr,ur,vr,absd,Fx,Fy,F,Trx,Try,v,V,u1_0,v1_0,M,filename)

            save(['vars_DO_NOT_DELETE/',filename,'/tfm_dtheta.mat'],'theta2','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_xr.mat'],'xr','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_yr.mat'],'yr','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_ur.mat'],'ur','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_vr.mat'],'vr','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_absd.mat'],'absd','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_Fx.mat'],'Fx','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_Fy.mat'],'Fy','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_F.mat'],'F','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_Trx.mat'],'Trx','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_Try.mat'],'Try','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_v.mat'],'v','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_V.mat'],'V','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_u1_0.mat'],'u1_0','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_v1_0.mat'],'v1_0','-v7.3')
            save(['vars_DO_NOT_DELETE/',filename,'/tfm_M.mat'],'M','-v7.3')
            

function tfm_push_forwards(hObject, eventdata, h_tfm)
%disable figure during calculation
enableDisableFig(h_tfm.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_tfm.fig,1));

%load what shared para we need
tfm_tfm_user_counter=getappdata(0,'tfm_tfm_user_counter');
tfm_tfm_user_preview_V=getappdata(0,'tfm_tfm_user_preview_V');
tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
tfm_init_user_E=getappdata(0,'tfm_init_user_E');
tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
tfm_tfm_user_lambda=getappdata(0,'tfm_tfm_user_lambda');
tfm_tfm_user_clims=getappdata(0,'tfm_tfm_user_clims');
tfm_tfm_user_constraintval=getappdata(0,'tfm_tfm_user_constraintval');

%save current stuff
E=str2double(get(h_tfm.edit_youngs,'String'));
nu=str2double(get(h_tfm.edit_poisson,'String'));
clims = [str2double(get(h_tfm.edit_tmin,'String')),str2double(get(h_tfm.edit_tmax,'String'))];
tfm_init_user_E{tfm_tfm_user_counter}=E;
tfm_init_user_nu{tfm_tfm_user_counter}=nu;
tfm_tfm_user_clims{tfm_tfm_user_counter}=clims;

%go to video before
tfm_tfm_user_counter=tfm_tfm_user_counter+1;

%put the correct values for new count in boxes:
set(h_tfm.edit_youngs,'String',num2str(tfm_init_user_E{tfm_tfm_user_counter}));
set(h_tfm.edit_poisson,'String',num2str(tfm_init_user_nu{tfm_tfm_user_counter}));
set(h_tfm.edit_regul,'String',num2str(tfm_tfm_user_lambda{tfm_tfm_user_counter}));
set(h_tfm.edit_tmin,'String',num2str(tfm_tfm_user_clims{tfm_tfm_user_counter}(1)));
set(h_tfm.edit_tmax,'String',num2str(tfm_tfm_user_clims{tfm_tfm_user_counter}(2)));

%plot heat plot
axes(h_tfm.axes_settings);
cla(h_tfm.axes_settings);
imagesc( tfm_tfm_user_preview_V{tfm_tfm_user_counter},tfm_tfm_user_clims{tfm_tfm_user_counter}); axis image; colormap parula;colorbar; hold on;
set(h_tfm.axes_settings, 'XTick', []);
set(h_tfm.axes_settings, 'YTick', []);

%set texts to vid
set(h_tfm.text_whichvidname,'String',tfm_init_user_filenamestack{1,tfm_tfm_user_counter});
set(h_tfm.text_whichvid,'String',[num2str(tfm_tfm_user_counter),'/',num2str(tfm_init_user_Nfiles)]);

%constrained / unconstrained
if tfm_tfm_user_constraintval(tfm_tfm_user_counter)==1
    set(h_tfm.edit_regul,'visible','on')
    set(h_tfm.text_regul,'visible','on')
    set(h_tfm.radiobutton_uncontrained,'value',1)
elseif tfm_tfm_user_constraintval(tfm_tfm_user_counter)==2
    set(h_tfm.edit_regul,'visible','off')
    set(h_tfm.text_regul,'visible','off')
    set(h_tfm.radiobutton_uncontrained,'value',0)
end

if tfm_tfm_user_counter==1
    set(h_tfm.button_backwards,'Enable','off');
else
    set(h_tfm.button_backwards,'Enable','on');
end
if tfm_tfm_user_counter<tfm_init_user_Nfiles
    set(h_tfm.button_forwards,'Enable','on');
else
    set(h_tfm.button_forwards,'Enable','off');
end

%store everything for shared use
setappdata(0,'tfm_init_user_E',tfm_init_user_E)
setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
setappdata(0,'tfm_tfm_user_lambda',tfm_tfm_user_lambda)
setappdata(0,'tfm_tfm_user_clims',tfm_tfm_user_clims)
setappdata(0,'tfm_tfm_user_counter',tfm_tfm_user_counter)

function tfm_push_backwards(hObject, eventdata, h_tfm)
%disable figure during calculation
enableDisableFig(h_tfm.fig,0);

%turn back on in the end
clean1=onCleanup(@()enableDisableFig(h_tfm.fig,1));

%load what shared para we need
tfm_tfm_user_counter=getappdata(0,'tfm_tfm_user_counter');
tfm_tfm_user_preview_V=getappdata(0,'tfm_tfm_user_preview_V');
tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
tfm_init_user_E=getappdata(0,'tfm_init_user_E');
tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
tfm_tfm_user_lambda=getappdata(0,'tfm_tfm_user_lambda');
tfm_tfm_user_clims=getappdata(0,'tfm_tfm_user_clims');
tfm_tfm_user_constraintval=getappdata(0,'tfm_tfm_user_constraintval');

%save current stuff
E=str2double(get(h_tfm.edit_youngs,'String'));
nu=str2double(get(h_tfm.edit_poisson,'String'));
clims = [str2double(get(h_tfm.edit_tmin,'String')),str2double(get(h_tfm.edit_tmax,'String'))];
tfm_init_user_E{tfm_tfm_user_counter}=E;
tfm_init_user_nu{tfm_tfm_user_counter}=nu;
tfm_tfm_user_clims{tfm_tfm_user_counter}=clims;

%go to video before
tfm_tfm_user_counter=tfm_tfm_user_counter-1;

%put the correct values for new count in boxes:
set(h_tfm.edit_youngs,'String',num2str(tfm_init_user_E{tfm_tfm_user_counter}));
set(h_tfm.edit_poisson,'String',num2str(tfm_init_user_nu{tfm_tfm_user_counter}));
set(h_tfm.edit_regul,'String',num2str(tfm_tfm_user_lambda{tfm_tfm_user_counter}));
set(h_tfm.edit_tmin,'String',num2str(tfm_tfm_user_clims{tfm_tfm_user_counter}(1)));
set(h_tfm.edit_tmax,'String',num2str(tfm_tfm_user_clims{tfm_tfm_user_counter}(2)));

%plot heat plot
axes(h_tfm.axes_settings);
cla(h_tfm.axes_settings)
imagesc( tfm_tfm_user_preview_V{tfm_tfm_user_counter},tfm_tfm_user_clims{tfm_tfm_user_counter}); axis image; colormap parula;colorbar; hold on;
set(h_tfm.axes_settings, 'XTick', []);
set(h_tfm.axes_settings, 'YTick', []);

%set texts to vid
set(h_tfm.text_whichvidname,'String',tfm_init_user_filenamestack{1,tfm_tfm_user_counter});
set(h_tfm.text_whichvid,'String',[num2str(tfm_tfm_user_counter),'/',num2str(tfm_init_user_Nfiles)]);

%constrained / unconstrained
if tfm_tfm_user_constraintval(tfm_tfm_user_counter)==1
    set(h_tfm.edit_regul,'visible','on')
    set(h_tfm.text_regul,'visible','on')
    set(h_tfm.radiobutton_uncontrained,'value',1)
elseif tfm_tfm_user_constraintval(tfm_tfm_user_counter)==2
    set(h_tfm.edit_regul,'visible','off')
    set(h_tfm.text_regul,'visible','off')
    set(h_tfm.radiobutton_uncontrained,'value',0)
end

if tfm_tfm_user_counter==1
    set(h_tfm.button_backwards,'Enable','off');
else
    set(h_tfm.button_backwards,'Enable','on');
end
if tfm_tfm_user_counter<tfm_init_user_Nfiles
    set(h_tfm.button_forwards,'Enable','on');
else
    set(h_tfm.button_forwards,'Enable','off');
end

%store everything for shared use
setappdata(0,'tfm_init_user_E',tfm_init_user_E)
setappdata(0,'tfm_init_user_nu',tfm_init_user_nu)
setappdata(0,'tfm_tfm_user_lambda',tfm_tfm_user_lambda)
setappdata(0,'tfm_tfm_user_clims',tfm_tfm_user_clims)
setappdata(0,'tfm_tfm_user_counter',tfm_tfm_user_counter)


%% Callback for the "OK" button
function tfm_push_ok(hObject, eventdata, h_tfm, h_main)
%disable figure during calculation
enableDisableFig(h_tfm.fig,0);

%userTiming= getappdata(0,'userTiming');
%userTiming.tfm{2} = toc(userTiming.tfm{1});
%userTiming.tfm2para{1} = tic;
%save for shared use
%setappdata(0,'userTiming',userTiming)


try
    %load what shared para we need
    tfm_init_user_strln = getappdata(0,'tfm_init_user_strln');
    tfm_init_user_Nfiles=getappdata(0,'tfm_init_user_Nfiles');
    tfm_init_user_Nframes=getappdata(0,'tfm_init_user_Nframes');
    tfm_init_user_filenamestack=getappdata(0,'tfm_init_user_filenamestack');
    tfm_init_user_pathnamestack=getappdata(0,'tfm_init_user_pathnamestack');
    tfm_init_user_E=getappdata(0,'tfm_init_user_E');
    tfm_init_user_nu=getappdata(0,'tfm_init_user_nu');
    tfm_tfm_user_lambda=getappdata(0,'tfm_tfm_user_lambda');
    
    masterfile = [tfm_init_user_pathnamestack{1},'/Batch_Results.xlsx'];
    %loop over files
    for ivid=1:tfm_init_user_Nfiles
        %waitbar
        sb=statusbar(h_tfm.fig,['Saving parameters... ',num2str(floor(100*(ivid-1)/sum(tfm_init_user_Nfiles))), '%% done']);
        sb.getComponent(0).setForeground(java.awt.Color.red);
        
        newfile=[tfm_init_user_pathnamestack{1,ivid},'/',tfm_init_user_filenamestack{1,ivid},'/Results/',tfm_init_user_filenamestack{1,ivid},'.xlsx'];
        A = {tfm_init_user_E{1,ivid},tfm_init_user_nu{1,ivid},[],tfm_tfm_user_lambda{1,ivid}};
        sheet = 'General';
        xlRange = 'O3';
        xlwrite(newfile,A,sheet,xlRange);
        
        %write to master file
        A = {tfm_init_user_E{1,ivid},tfm_init_user_nu{1,ivid},tfm_tfm_user_lambda{1,ivid}};
        sheet = 'Curves Parameters Batch Summary';
        xlRange = ['I',num2str(ivid+2)];
        xlwrite(masterfile,A,sheet,xlRange);
        
    end
    
    %check if user wants to save
    value = get(h_tfm.checkbox_matrix, 'Value');
    
    if value
        %w_i=0;
        %loop over videos
        for ivid=1:tfm_init_user_Nfiles
            %make output folder for displacements
            if ~isequal(exist([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Traction Forces'], 'dir'),7)
                [mf,mf2] = mkdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Traction Forces']); %#ok<ASGLU> 
            end
            
            %loop over frames
            %for ifr=1:tfm_init_user_Nframes{ivid}
                %waitbar
            %    w_i=w_i+1;
            %    sb=statusbar(h_tfm.fig,['Saving full fields... ',num2str(floor(100*(w_i-1)/sum([tfm_init_user_Nframes{:}]))), '%% done']);
            %    sb.getComponent(0).setForeground(java.awt.Color.red);
                %copy displacements
                copyfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_xr.mat'],[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Traction Forces/tfm_xr.mat']);
                copyfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_yr.mat'],[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Traction Forces/tfm_yr.mat']);
                copyfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_Trx.mat'],[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Traction Forces/tfm_Trx.mat']);
                copyfile(['vars_DO_NOT_DELETE/',tfm_init_user_filenamestack{1,ivid},'/tfm_Try.mat'],[tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Datasets/Traction Forces/tfm_Try.mat']);
            %end
        end
    end
    
    %check if user wants to save heatmaps
    value = get(h_tfm.checkbox_heatmaps, 'Value');
    
    if ~value
        for ivid=1:tfm_init_user_Nfiles
            rmdir([tfm_init_user_pathnamestack{1,ivid},tfm_init_user_filenamestack{1,ivid},'/Plots/Traction Heatmaps'],'s')
        end
    end
    
    %statusbar
    sb=statusbar(h_tfm.fig,'Saving - Done !');
    sb.getComponent(0).setForeground(java.awt.Color(0,.5,0));
    
catch errorObj
    % If there is a problem, we display the error message
    errordlg(getReport(errorObj,'extended','hyperlinks','off'));
end

fprintf(1,'CXS-TFM: TFM calculations complete.\n')
fprintf(1,'  Analysis End Time: %s \n',datestr(now));

%enable fig
enableDisableFig(h_tfm.fig,1);

%change main windows 3. button status
set(h_main(1).button_tfm,'ForegroundColor',[0 .5 0]);
set(h_main(1).button_para,'Enable','on');

%close window
close(h_tfm.fig);

%move main window to the side
movegui(h_main(1).fig,'center')

%Streamlining
if tfm_init_user_strln
    tfm_para(h_main)
end



function tfm_buttongroup_constrain(hObject, eventdata, h_tfm)
%load
tfm_tfm_user_counter=getappdata(0,'tfm_tfm_user_counter');
tfm_tfm_user_constraintval=getappdata(0,'tfm_tfm_user_constraintval');

switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'radiobutton_unconstrained'
        tfm_tfm_user_constraintval(tfm_tfm_user_counter)=1;
        set(h_tfm.edit_regul,'visible','on')
        set(h_tfm.text_regul,'visible','on')
    case 'radiobutton_constrained'
        tfm_tfm_user_constraintval(tfm_tfm_user_counter)=2;
        set(h_tfm.edit_regul,'visible','off')
        set(h_tfm.text_regul,'visible','off')
end
setappdata(0,'tfm_tfm_user_constraintval',tfm_tfm_user_constraintval)
