%Code to initialize micromanager and microscope
%Ohi Dibua, February 7, 2017
%Modified by Henry Lewis 12/22/2017

import mmcorej.*; %Import java class that contains all microManager related classes
import org.micromanager.api.*;
mmc = CMMCore; %Define variable as part of class CMMCore
mmc.loadSystemConfiguration ('C:\Program Files\Micro-Manager-2.0gamma\MMConfig_demo.cfg');


% % cd 'C:/Program Files/Micro-Manager-1.4'
% import org.micromanager.MMStudio;
% gui = MMStudio(false);
% % gui.show;
% mmc = gui.getCore;
% acq = gui.getAcquisitionEngine;
% 
% setappdata(0,'gui',gui);
% setappdata(0,'mmc',mmc);
% setappdata(0,'acq',acq);
