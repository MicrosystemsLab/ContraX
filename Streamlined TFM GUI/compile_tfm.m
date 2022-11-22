% Script for compiling executable
% This script will attempt to compile the application
%
% Before compiling, ensure that all of the necessary files are on the MATLAB path.
%

%% Setup
progname='ContraX';
mainFunction='tfm_main';
updateRepo=0; % update the repository with this source code?
if ispc, updateRepo=0; end
%copyFiles=0; % copy executables to correct locations?

% make sure working directory is on the path
addpath(pwd);

arch = computer('arch');
matver=ver('MATLAB');
if ispc
    username=getenv('USERPROFILE');
else
    username=getenv('USER');
end


fprintf(1,'\nCompile %s:\n',progname);


if isempty(which([mainFunction '.m']))
    error('"%s" program files (*.m) not found on the MATLAB path.\n',mainFunction);
end


%% check dependencies
fprintf(1,'Checking dependencies\n');
[fList, pList] = matlab.codetools.requiredFilesAndProducts(mainFunction);
fprintf(1,'  Toolboxes Required:\n');
for k= 1:length(pList)
	disp(pList(k).Name)
end
fprintf(1,'\n');
if length(pList)>1
    fprintf(1,'WARNING: Looks like additional toolboxes are required (%d).\n',length(pList));
    fprintf(1,'  Ensure that they are included in the compile script.\n');
end


%% Create compile command
try
	cd('build')
catch
	fprintf('Cannot access "build" directory on current path. Exit.\n\n');
    return
end

% Create buildversion file
buildver=sprintf('%s/%s/%s',sprintf('%d%02d%02d%02d%02d%02.0f',datevec(now)),computer('arch'),matver.Release(2:end-1));
fprintf(1,'buildver: %s\n',buildver);
fid=fopen('buildversion.txt','w');
fprintf(fid,'%s',buildver);
fclose(fid);

% compile options
compile_cmd =['mcc -v -m -o ' progname ' ' mainFunction '.m' ' -N'];
if ispc
    compile_cmd=['mcc -W ''main:' progname ',version=1.0.0'' -T link:exe ' mainFunction '.m' ' -N -v'];
end

% -s Obfuscate folder structures and file names in the deployable archive (.ctf file) from the end user. Optionally encrypt additional file types.
%  R2021+ only

% runtime options
% suppress no display warning
%compile_cmd =[compile_cmd ' -R -nodisplay'];
% % use logfile
% compile_cmd =[compile_cmd ' -R ''-logfile,logMRdata_messages.txt'''];

% include build version number
compile_cmd =[compile_cmd ' -a buildversion.txt'];

% include some Java libraries
compile_cmd =[compile_cmd ' -a poi_library/'];

% include some template files
compile_cmd =[compile_cmd ' -a Master_DO_NOT_EDIT.xlsx -a Sample_DO_NOT_EDIT.xlsx'];

% include image files
%compile_cmd =[compile_cmd ' -a woodchuck5sm.jpg'];
%compile_cmd =[compile_cmd ' -a control_icon_graybk.jpg -a R_icon_graybk.jpg -a pid_equation.jpg'];
%compile_cmd =[compile_cmd ' -a CeNSE_logo_gray_sm.jpg'];
%compile_cmd =[compile_cmd ' -a HP_Blue_sm_trans_white.png'];

% include test scripts
%compile_cmd =[compile_cmd ' -a script.txt'];
%compile_cmd =[compile_cmd ' -a autotune_step_script.txt'];
%compile_cmd =[compile_cmd ' -a system_test_script.txt'];

% include User Guide
%compile_cmd =[compile_cmd ' -a PrsCtrl2_User_Guide.pdf'];
% % As of v1.14, the working directory is changed to location of
% application, so keep pdf in that directory

%% Toolboxes
% % begin with none, and add as necessary
% compile_cmd =[compile_cmd ' -N'];
if isempty(ver('signal'))
    fprintf(1,'WARNING: the Signal Processing Toolbox (signal) does not appear to be installed.\n');
else
    fprintf(1,'  with Signal Processing\n');
    compile_cmd=[compile_cmd ' -p signal'];
end

if isempty(ver('images'))
    fprintf(1,'WARNING: the Image Processing Toolbox (images) does not appear to be installed.\n');
else
    fprintf(1,'  with Image Processing\n');
    compile_cmd=[compile_cmd ' -p images'];
end

if isempty(ver('parallel'))
    fprintf(1,'WARNING: the Parallel Computing Toolbox (parallel) does not appear to be installed.\n');
else
    fprintf(1,'  with Parallel Computing\n');
    compile_cmd=[compile_cmd ' -p parallel'];
end

% if isempty(ver('control'))
%     fprintf(1,'WARNING: the Control System Toolbox (control) does not appear to be installed.\n');
%     fprintf(1,' Automatic PID support will not be included in the compiled executable.\n');
% else
%     fprintf(1,'  with PID tuning\n');
%     compile_cmd=[compile_cmd ' -p control'];
% end

% if isempty(ver('ident'))
%     fprintf(1,'WARNING: the System Identification Toolbox (ident) does not appear to be installed.\n');
%     fprintf(1,' System Model support will not be included in the compiled executable.\n');
% else
%     fprintf(1,'  with System Identification\n');
%     compile_cmd=[compile_cmd ' -p ident'];
% end


% Windows compile tool can include an icon in the executable
if ispc
    compile_cmd =[compile_cmd ' -r control_icon.ico'];
end

%% Compile
% The compile statement includes:
%  files for the main program
%  build version info
%  images
%  optional toolboxes
%

tic

disp(compile_cmd);
eval(compile_cmd);

toc
beep; pause(0.1); beep; pause(0.2); beep; pause(0.3); beep;
fprintf(1,'%s compilation complete at %s.\n\n',progname,datestr(clock));


%% Install OS X icon
if ismac
    fprintf(1,'Set OS X icon... ');
    icontarget = sprintf('%s.app/Contents/Resources/membrane.icns',progname);
    copyfile('membrane.icns',icontarget,'f');
    fprintf(1,'done.\n');
end

% %% Install Windows icon
% if ispc    
%     % Setting icon requires Resource Hacker
%     %  http://www.angusj.com/resourcehacker/
%     % For example:
% %     C:\Users\hopcroft\Documents\Software_20200317\build>"C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" -open PressureControl2.exe -save PressureControl2.exe -action addoverwrite -res control_icon.ico -mask ICONGROUP,1
% % 
% %     C:\Users\hopcroft\Documents\Software_20200317\build>
% % 
% %     [17 Mar 2020, 12:49:19]
% % 
% %     Current Directory:
% %     C:\Users\hopcroft\Documents\Software_20200317\build
% % 
% %     Commandline:
% %     "C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe"  -open PressureControl2.exe -save PressureControl2.exe -action addoverwrite -res control_icon.ico -mask ICONGROUP,1
% % 
% %     Open    : C:\Users\hopcroft\Documents\Software_20200317\build\PressureControl2.exe
% %     Save    : C:\Users\hopcroft\Documents\Software_20200317\build\PressureControl2.exe
% %     Resource: C:\Users\hopcroft\Documents\Software_20200317\build\control_icon.ico
% % 
% %       Modified: ICONGROUP,1,1033
% % 
% %     Success!
% 
%     iconFile=which('control_icon.ico');
%     reshackerPath='C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe';
%     iconcmd=sprintf('"%s" -open %s.exe -save %s.exe -action addoverwrite -res %s -mask ICONGROUP,1',reshackerPath,progname,progname,iconFile);
%     [sic,rmes] = system(iconcmd);
%     if sic < 0
%         fprintf(1,'WARNING: Icon Set command failed (%d)\n%s\n',sic,rmes);
%         fprintf(1,'  (Try runnning ResourceHacker manually)\n');
%     else
%         fprintf(1,'Icon set command succeeded (%d).\n',sic);
%         disp(rmes)
%     end
%     %system(['"C:\Program Files (x86)\Resource Hacker\ResHacker.exe" -addoverwrite TagVideo.exe, TagVideo.exe, ' iconFile ', ICONGROUP,1,']);
% end


cd('..');


%% update repo
if updateRepo
    svn_cmd=['git commit -a -m "compile ' progname ' build: ' buildver '"'];  

    disp(svn_cmd)
    system(svn_cmd);

    fprintf(1,'\n');
end

fprintf(1,'Compile complete.\n\n');