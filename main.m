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
% Last Modified by GUIDE v2.5 08-Dec-2019 06:35:00
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

function varargout = main_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
clc;
clear all;

function dotSave_Callback(hObject, eventdata, handles)
set(handles.chosenFcnLabel, 'String', '');
global leftPhoto; 
axes(handles.photoLeft);
imshow(leftPhoto);

function linesStart_Callback(hObject, eventdata, handles)
set(handles.chosenFcnLabel, 'String', 'Zaznaczanie naczyñ');
str= get(handles.linesText, 'String');
count=0;
xy=[];
if(~isempty(str))
  count=str2num(str); 
  xy=handles.xyNum;
else
photo=handles.photoLeft;
xSize=abs(photo.XLim(2)-photo.XLim(1));
ySize=abs(photo.YLim(2)-photo.YLim(1));
handles.maskLines=zeros(xSize,ySize);
end
M = imfreehand(gca,'Closed',0);
lines= M.createMask;
maskLogical=logical(lines);
handlesMask=handles.maskLines;
handlesMask = handlesMask + maskLogical;
handles.maskLines=logical(handlesMask);
count= count + sum(maskLogical(:));
xy = [xy;int32(M.getPosition)];
handles.xyNum=xy;
set(handles.linesText, 'String', num2str(count));
guidata(hObject, handles);


function effusionStart_Callback(hObject, eventdata, handles)
set(handles.chosenFcnLabel, 'String', 'Zaznaczanie wycieków');
global leftPhoto; 
lp = leftPhoto
activeWindow = handles.photoLeft;
handleMask = imfreehand(activeWindow)  
mask = createMask(handleMask);
xy = int32(handleMask.getPosition);
mask = false(size(lp));
linearIndexes = sub2ind(size(lp), xy(:, 2), xy(:, 1));
mask(linearIndexes) = true;
lp(linearIndexes) = 255;
    
area=regionprops(double(mask),'Area')
set(handles.effusionText, 'String', num2str(area.Area));

handles.effusion = lp
guidata(hObject, handles);


function show_Callback(hObject, eventdata, handles)
global numDotsClicked;
global dataDotsX;
global dataDotsY;
global IsDotsCheckbox;
global IsEffusionCheckbox;
global IsLinesCheckbox;
global effusion;
IsDotsCheckbox = get(handles.dotsCheckbox, 'value');
IsLinesCheckbox = get(handles.linesCheckbox, 'value')
IsEffusionCheckbox = get(handles.effusionCheckbox, 'value')

if(IsLinesCheckbox)
    photo=handles.photoLeft;
    xy=handles.xyNum;
    [X,Y]=size(xy);
       for j=1:X
        hold(handles.photoLeft,'on');
        plot(xy(j,1), xy(j,2), 'ro','MarkerSize',2);
        hold on;
       end
    hold(handles.photoLeft,'off');
end

if(IsEffusionCheckbox)
        photo=handles.photoLeft;
        effusion = handles.effusion
        imshow(effusion, 'Parent', photo);
end

if(IsDotsCheckbox)
    numDotsClicked = handles.numDotsClicked;
    dataDotsX = handles.dotsArrayX;
    dataDotsY = handles.dotsArrayY;  
    dataDotsX(:, end)=[];
    dataDotsY(:, end)=[];

    for i=1:(numDotsClicked)
        hold(handles.photoLeft,'on');
        plot(dataDotsX(i), dataDotsY(i), 'yo', 'MarkerSize', 10);
        hold on;
    end
    hold(handles.photoLeft,'off');
end

function dotsCheckbox_Callback(hObject, eventdata, handles)
global IsDotsCheckbox;
IsDotsCheckbox = get(handles.dotsCheckbox, 'value');
handles.IsDotsCheckbox = IsDotsCheckbox;
guidata(hObject, handles);

function linesCheckbox_Callback(hObject, eventdata, handles)
global IsLinesCheckbox;
IsLinesCheckbox = get(handles.linesCheckbox, 'value');
handles.IsLinesCheckbox = IsLinesCheckbox;
guidata(hObject, handles);

function effusionCheckbox_Callback(hObject, eventdata, handles)
global IsEffusionCheckbox;
IsEffusionCheckbox = get(handles.effusionCheckbox, 'value');
handles.IsEffusionCheckbox = IsEffusionCheckbox;
guidata(hObject, handles);

function selectPhotoLeft_Callback(hObject, eventdata, handles)
global leftPhoto; 
global leftPhotoSize;
cla(handles.photoLeft,'reset');
set(handles.dotsText, 'String', '');
set(handles.linesText, 'String', '');
set(handles.effusionText, 'String', '');

path=uigetfile('*.tif');
leftPhoto=imread(path);
leftPhotoSize = size(leftPhoto);
set(handles.photoLeft,'Units','pixels');
resizePos = get(handles.photoLeft,'Position');
leftPhoto= imresize(leftPhoto, [resizePos(3) resizePos(3)]);
axes(handles.photoLeft);
imshow(leftPhoto);



function exportPhotoLeft_Callback(hObject, eventdata, handles)
Image = getframe(handles.photoLeft);
answer = inputdlg('Podaj nazw pliku:','Nazwa pliku', [1 50]);

value = char(answer);
ext= char('.jpg');
imwrite(Image.cdata, strcat(value,ext));

function selectPhotoRight_Callback(hObject, eventdata, handles)
global rightPhoto; 
global rightPhotoSize;
cla(handles.photoRight,'reset');

path=uigetfile('*.tif');
rightPhoto=imread(path);
rightPhotoSize = size(rightPhoto);
set(handles.photoRight,'Units','pixels');
resizePos = get(handles.photoRight,'Position');
rightPhoto= imresize(rightPhoto, [resizePos(3) resizePos(3)]);
axes(handles.photoRight);
imshow(rightPhoto);
 
imData=reshape(rightPhoto,[],1);
imData=double(imData)
[IDX nn] = kmeans(imData,4);
imIDX=reshape(IDX,size(rightPhoto));
imshow(imIDX==1,[]);

function exportPhotoRight_Callback(hObject, eventdata, handles)
Image = getframe(handles.photoRight);
answer = inputdlg('Podaj nazw pliku:','Nazwa pliku', [1 50]);

value = char(answer);
ext= char('.jpg');
imwrite(Image.cdata, strcat(value,ext));

function btnLeft_Callback(hObject, eventdata, handles)
global rightPhoto; 

axes(handles.photoRight);
imshow(rightPhoto);
imData=reshape(rightPhoto,[],1);
imData=double(imData);
[IDX nn] = kmeans(imData,4);
imIDX=reshape(IDX,size(rightPhoto));
for i = 1:4
  imshow(imIDX==i,[]);
end

function selectImgBrowser_Callback(hObject, eventdata, handles)
global imageBrowser; 
global imageBrowserSize;
cla(handles.imageBrowser,'reset');

path=uigetfile('*.tif');
imageBrowser=imread(path);
imageBrowserSize = size(imageBrowser);
set(handles.imageBrowser,'Units','pixels');
resizePos = get(handles.imageBrowser,'Position');
imageBrowser= imresize(imageBrowser, [resizePos(3) resizePos(3)]);
axes(handles.imageBrowser);
imshow(imageBrowser);

function clearBtn_Callback(hObject, eventdata, handles)
handles.numDotsClicked = [];
handles.dotsArray = [];
handles.maskLines=[];
set(handles.linesText, 'String', '');
guidata(hObject, handles);

function togglebuttonDots_Callback(hObject, eventdata, handles)
set(handles.chosenFcnLabel, 'String', 'Zaznaczanie mikrotêtniaków');
numDotsClicked = 1;
dotsCount = 1;
set(handles.togglebuttonDots,'string','Mikrotetniaki');

 while get(hObject,'Value')
   pause(1);
   if(get(hObject,'Value'))
   set(handles.togglebuttonDots,'string','Stop');
   [x(numDotsClicked), y(numDotsClicked)] = ginput(1)
   set(handles.dotsText, 'String', dotsCount);
   hold(handles.photoLeft,'on');
   plot(x(numDotsClicked), y(numDotsClicked), 'yo', 'MarkerSize', 10);
   handles.dotsArrayX = x;
   handles.dotsArrayY = y;
   dotsCount = dotsCount + 1;
   numDotsClicked = numDotsClicked + 1;
   end
 end

set(handles.dotsText, 'String', dotsCount-2);
handles.numDotsClicked = numDotsClicked - 2;
hold(handles.photoLeft, 'off');
guidata(hObject, handles);
