% Files to compile:
% These are stand alone .cpp files compiled with '-c' flag:
lib_ncorr_cpp = {'standard_datatypes','ncorr_datatypes','ncorr_lib'};
% These are .cpp mex functions compiled with libraries
func_ncorr_cpp = {'ncorr_alg_formmask', ...
    'ncorr_alg_formregions', ...
    'ncorr_alg_formboundary', ...
    'ncorr_alg_formthreaddiagram', ...
    'ncorr_alg_formunion', ...
    'ncorr_alg_extrapdata', ...
    'ncorr_alg_adddisp', ...
    'ncorr_alg_convert', ...
    'ncorr_alg_dispgrad'};
% These are .cpp mex functions compiled with libraries and possibly openmp:
func_ncorr_openmp_cpp = {'ncorr_alg_calcseeds','ncorr_alg_rgdic'};

% flags_0= horzcat({'CXXFLAGS="\$CXXFLAGS'},{'-fopenmp"'},
%                              {'CXXFLAGS="\$CXXFLAGS'},
%                              {'-DNCORR_OPENMP"'},{'CXXLIBS="\$CXXLIBS'},{'-lgomp"'});
%flags_f = 'CXXFLAGS="-fopenmp" -DNCORR_OPENMP CXXLIBS="-lgomp"';
flags_f = '';

% Compile libraries:
compile_lib_cpp_mex(lib_ncorr_cpp);
% Compile functions:
compile_func_cpp_mex(func_ncorr_cpp,lib_ncorr_cpp,{});
% Compile function with openmp:
compile_func_cpp_mex(func_ncorr_openmp_cpp,lib_ncorr_cpp,flags_f);

function compile_lib_cpp_mex(lib_cpp)
% This function compiles cpp_function_lib as object files.
%
% Inputs -----------------------------------------------------------------%
%   lib_cpp - cell of strings; names of libraries to be compiled as object
%   files
%
% Returns error if files are not found.

% Cycle over libraries and compile
for i = 0:length(lib_cpp)-1
    % First check if the cpp and header files exist
    if (exist([lib_cpp{i+1} '.cpp'],'file') && exist([lib_cpp{i+1} '.h'],'file'))
        disp(['Installing ' lib_cpp{i+1} '... Please wait']);
        
        % Generate compiler string
        string_compile = horzcat({'-c'},{[lib_cpp{i+1} '.cpp']});
        
        % Compile file
        mex(string_compile{:});
    else
        h_error = errordlg(['Files ' lib_cpp{i+1} '.cpp and ' lib_cpp{i+1} '.h were not found. Please find them and place them in the current directory before proceeding.'],'Error','modal');
        uiwait(h_error);
        
        % Spit error to invoke exception
        error('Compilation failed because file was not found.');
    end
end
end

function compile_func_cpp_mex(func_cpp,lib_cpp,flags_f)
% This function compiles func_cpp and linkes them with the lib_cpp object
% files. If flags are provided then they will be appended when compiling.
%
% Inputs -----------------------------------------------------------------%
%   func_cpp - cell of strings; names of .cpp files to be
%   compiled
%   lib_cpp - cell of strings; names of object files to be linked
%   flags_f - cell of strings; formatted compiler flags.
%
% Returns error if library object files or source code files are not found.

% Get the OS to find object extension
if (ispc) % pc
    objext = 'obj';
elseif (isunix) % unix
    objext = 'o';
end

% Check if lib files have been compiled first
for i = 0:length(lib_cpp)-1
    if (~exist([lib_cpp{i+1} '.' objext],'file'))
        % Object file doesnt exist, return error
        h_error = errordlg(['Library ' lib_cpp{i+1} ' has not yet been compiled. Please compile first and make sure the object file is located in the current directory before proceeding.'],'Error','modal');
        uiwait(h_error);
        
        % Spit error to invoke exception
        error('Library not compiled yet');
    end
end

% Cycle over mex files and compile
for i = 0:length(func_cpp)-1
    % First check if the cpp file exists
    if (exist([func_cpp{i+1} '.cpp'],'file'))
        disp(['Installing ' func_cpp{i+1} '... Please wait']);
        
        % Generate compiler string
        string_compile = {[func_cpp{i+1} '.cpp']};
        
        % Append libraries
        for j = 0:length(lib_cpp)-1
            string_compile = horzcat(string_compile,{[lib_cpp{j+1} '.' objext]}); %#ok<AGROW>
        end
        
        % Append flags
        string_compile = horzcat(string_compile,flags_f); %#ok<AGROW>
        
        % Compile
        disp(string_compile);
        mex(string_compile{:});
    else
        h_error = errordlg(['File ' filename '.cpp was not found. Please find it and place it in the current directory before proceeding'],'Error','modal');
        uiwait(h_error);
        
        % Spit error to invoke exception
        error('Compilation failed because file was not found.');
    end
end
end
