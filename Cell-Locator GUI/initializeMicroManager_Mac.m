%Code to initialize micromanager and microscope
%Ohi Dibua, February 7, 2017
%Modified by Henry Lewis 12/22/2017

% import mmcorej.*; %Import java class that contains all microManager related classes
% mmc = CMMCore; %Define variable as part of class CMMCore
% mmc.loadSystemConfiguration ('/Applications/Micro-Manager1.4/MMConfig_demo.cfg');

% java.lang.System.clearProperty('java.util.prefs.PreferencesFactory')
cd '/Applications/Micro-Manager1.4'
import org.micromanager.internal.MMStudio;
gui = MMStudio(false);
% gui.show;
mmc = gui.getCore;
acq = gui.getAcquisitionEngine;

setappdata(0,'gui',gui);
setappdata(0,'mmc',mmc);
setappdata(0,'acq',acq);
% 
