function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help main
% Last Modified by GUIDE v2.5 03-Dec-2019 10:31:58
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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

% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
clc;
clear all;

function dotsStart_Callback(hObject, eventdata, handles)
global numDotsClicked;
global stopState;
global x;
global y;
numDotsClicked = 0;
dotsCount = 0;
stopDots=0;

value=get(handles.dotsStart,'string');
if(strcmp(value,'Stop'))
    set(handles.dotsStart,'string','Kropki');
    stopDots=1;
end
if(strcmp(value,'Kropki'))
    set(handles.dotsStart,'string','Stop');
end

while(stopDots==0)
  numDotsClicked = numDotsClicked + 1;
  [x(numDotsClicked), y(numDotsClicked)] = ginput(1);
  hold(handles.photoLeft,'on');
  dotsCount = dotsCount + 1;
  set(handles.dotsText, 'String', dotsCount);
  drawnow;
  plot(x(numDotsClicked), y(numDotsClicked), 'yo', 'MarkerSize', 10);
end

function dotSave_Callback(hObject, eventdata, handles)
global leftPhoto; 
axes(handles.photoLeft);
imshow(leftPhoto);

function linesStart_Callback(hObject, eventdata, handles)
stop=0;
value=get(handles.linesStart,'string');
if(strcmp(value,'Stop'))
    set(handles.linesStart,'string','Linie');
    stop=1;
end
if(strcmp(value,'Linie'))
    set(handles.linesStart,'string','Stop');
end

while(stop==0)
M = imfreehand(gca,'Closed',0);
lines= sum(M.createMask);
lines=lines + sum(lines);
 set(handles.linesText, 'String', num2str(lines));

end

function linesSave_Callback(hObject, eventdata, handles)
% hObject    handle to linesSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in effusionStart.
function effusionStart_Callback(hObject, eventdata, handles)
% hObject    handle to effusionStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    activeWindow = handles.photoLeft;
    handleMask = imfreehand(activeWindow)
    mask = createMask(handleMask);
    area=regionprops(double(mask),'Area')
    set(handles.effusionText, 'String', num2str(area.Area));
 

  
% --- Executes on button press in effusionSave.
function effusionSave_Callback(hObject, eventdata, handles)
% hObject    handle to effusionSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in show.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function dotsCheckbox_Callback(hObject, eventdata, handles)
global numDotsClicked;
global x;
global y;
for i=0:numDotsClicked
   hold(handles.photoLeft,'on');
   plot(x(numDotsClicked), y(numDotsClicked), 'yo', 'MarkerSize', 15);
end

% --- Executes on button press in linesCheckbox.
function linesCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to linesCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of linesCheckbox

% --- Executes on button press in effusionCheckbox.
function effusionCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to effusionCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of effusionCheckbox

function selectPhotoLeft_Callback(hObject, eventdata, handles)
global leftPhoto; 
global leftPhotoSize;
cla(handles.photoLeft,'reset');
set(handles.dotsText, 'String', '');
set(handles.linesText, 'String', '');
set(handles.effusionText, 'String', '');

path=uigetfile('*.jpg');
leftPhoto=imread(path);
leftPhotoSize = size(leftPhoto);
set(handles.photoLeft,'Units','pixels');
resizePos = get(handles.photoLeft,'Position');
leftPhoto= imresize(leftPhoto, [resizePos(3) resizePos(3)]);
axes(handles.photoLeft);
imshow(leftPhoto);


function exportPhotoLeft_Callback(hObject, eventdata, handles)
Image = getframe(handles.photoLeft);
imwrite(Image.cdata, 'mask_image_L.jpg');

function selectPhotoRight_Callback(hObject, eventdata, handles)
global rightPhoto; 
global rightPhotoSize;
cla(handles.photoRight,'reset');
% set(handles.dotsText, 'String', '');
% set(handles.linesText, 'String', '');
% set(handles.effusionText, 'String', '');

path=uigetfile('*.jpg');
rightPhoto=imread(path);
rightPhotoSize = size(rightPhoto);
set(handles.photoRight,'Units','pixels');
resizePos = get(handles.photoRight,'Position');
rightPhoto= imresize(rightPhoto, [resizePos(3) resizePos(3)]);
axes(handles.photoRight);
imshow(rightPhoto);
 
a=rgb2gray(rightPhoto);
imshow(a)
imData=reshape(a,[],1);
imData=double(imData)
[IDX nn] = kmeans(imData,4);
imIDX=reshape(IDX,size(a));
imshow(imIDX==1,[]);

function exportPhotoRight_Callback(hObject, eventdata, handles)
Image = getframe(handles.photoRight);
answer = inputdlg('Podaj nazw pliku','Nazwa pliku', [1 50]);
imwrite(Image.cdata, strcat(answer,'.jpg'));

% --- Executes on button press in btnLeft.
function btnLeft_Callback(hObject, eventdata, handles)
% hObject    handle to btnLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rightPhoto; 

a=rgb2gray(rightPhoto);
imshow(a)
imData=reshape(a,[],1);
imData=double(imData)
[IDX nn] = kmeans(imData,4);
imIDX=reshape(IDX,size(a));
for i = 1:4
  imshow(imIDX==i,[]);

end

% --- Executes during object creation, after setting all properties.
function imageBrowser_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageBrowser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate imageBrowser


% --- Executes on button press in selectImgBrowser.
function selectImgBrowser_Callback(hObject, eventdata, handles)
% hObject    handle to selectImgBrowser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imageBrowser; 
global imageBrowserSize;
cla(handles.imageBrowser,'reset');
% set(handles.dotsText, 'String', '');
% set(handles.linesText, 'String', '');
% set(handles.effusionText, 'String', '');

path=uigetfile('*.jpg');
imageBrowser=imread(path);
imageBrowserSize = size(imageBrowser);
set(handles.imageBrowser,'Units','pixels');
resizePos = get(handles.imageBrowser,'Position');
imageBrowser= imresize(imageBrowser, [resizePos(3) resizePos(3)]);
axes(handles.imageBrowser);
imshow(imageBrowser);
