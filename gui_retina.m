function varargout = gui_retina(varargin)
% GUI_RETINA MATLAB code for gui_retina.fig
%      GUI_RETINA, by itself, creates a new GUI_RETINA or raises the existing
%      singleton*.
%
%      H = GUI_RETINA returns the handle to a new GUI_RETINA or the handle to
%      the existing singleton*.
%
%      GUI_RETINA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_RETINA.M with the given input arguments.
%
%      GUI_RETINA('Property','Value',...) creates a new GUI_RETINA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_retina_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_retina_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_retina

% Last Modified by GUIDE v2.5 09-Jan-2019 09:43:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_retina_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_retina_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_retina is made visible.
function gui_retina_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_retina (see VARARGIN)

% Choose default command line output for gui_retina
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_retina wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_retina_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = uigetfile('*.jpeg');

myImage = fullfile(pn,fn);
fprintf('\nInputFile:\n\t%s',myImage)
axes(handles.axes1);
imshow(myImage);title('query image');
handles.ImgData1 = myImage;
guidata(hObject,handles);




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
set(handles.edit1,'string','');
I3 = handles.ImgData1;

disp('Loading saved models...')
load('net_vgg16.mat')
load('net_inception.mat')
load('net_alexnet.mat')
load model.mat



im1 = readEye1(I3);
im2 = readEye2(I3);
im3 = readEye3(I3);

layer = 'fc8';
feat1 = activations(net1,im1,layer,'OutputAs','rows');

layer = 'fc8';
feat2 = activations(net2,im2,layer,'OutputAs','rows');
   
layer = 'predictions_new';
feat3 = activations(net3,im3,layer,'OutputAs','rows');

feat = [feat1 feat2 feat3];

fprintf('\nPredicting output...')
label = predict(mdl,feat);
my_prediction = string(label);

set(handles.edit1,'string',my_prediction);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when uipanel1 is resized.
function uipanel1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
