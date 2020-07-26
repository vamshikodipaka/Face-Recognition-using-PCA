function varargout = GUI_PCA(varargin)
% GUI_PCA MATLAB code for GUI_PCA.fig
%      GUI_PCA, by itself, creates a new GUI_PCA or raises the existing
%      singleton*.
%
%      H = GUI_PCA returns the handle to a new GUI_PCA or the handle to
%      the existing singleton*.
%
%      GUI_PCA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PCA.M with the given input arguments.
%
%      GUI_PCA('Property','Value',...) creates a new GUI_PCA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_PCA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_PCA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_PCA

% Last Modified by GUIDE v2.5 05-Jan-2019 21:04:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_PCA_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_PCA_OutputFcn, ...
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


% --- Executes just before GUI_PCA is made visible.
function GUI_PCA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_PCA (see VARARGIN)

% Choose default command line output for GUI_PCA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% To set axes handles not to show ticks on axes
axes(handles.AxesInput);
set(gca,'XtickLabel',[],'YtickLabel',[]);
axes(handles.AxesMatch1);
set(gca,'XtickLabel',[],'YtickLabel',[]);
axes(handles.AxesMatch2);
set(gca,'XtickLabel',[],'YtickLabel',[]);
axes(handles.AxesMatch3);
set(gca,'XtickLabel',[],'YtickLabel',[]);

% To set the visibility off
set(handles.LoadDoneText,'visible','off');
set(handles.TestPathDoneText,'visible','off');
set(handles.MatchFoundText,'visible','off');

% UIWAIT makes GUI_PCA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_PCA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SelectImageButton.
function SelectImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Function to get Test Image
TestPath = handles.TestPath;
[filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.JPG'}, 'Select an Image',TestPath);
file_Name = fullfile(pathname,filename);

% Read Test Image
Test_Img = imread(file_Name);

% Display Test Image
axes(handles.AxesInput);
imshow(Test_Img);

handles.Test_Image = Test_Img;
handles.Image_Name = filename;
guidata(hObject, handles)


% --- Executes on button press in RecognizeButton.
function RecognizeButton_Callback(hObject, eventdata, handles)
% hObject    handle to RecognizeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get No. of Principal Components from the User
N_pca = str2double(get(handles.PCAEdit,'String'));

% Calculating PCA Transformation matrix (or) Projection Matrix
[P] = PCATransformationMatrix(handles.D, N_pca);

% Function to perform Face Recognition
[FirstMatch, SecondMatch, ThirdMatch, Accuracy] = ComputeEigenFaces(handles.Test_Image, handles.Image_Name, P, handles.D, handles.L, handles.TestPath);

% Displaying the Matches
axes(handles.AxesMatch1);
imshow(FirstMatch);

axes(handles.AxesMatch2);
imshow(SecondMatch);

axes(handles.AxesMatch3);
imshow(ThirdMatch);

set(handles.RecogAccuEdit,'String',Accuracy);

handles.Match1 = FirstMatch;
handles.Match2 = SecondMatch;
handles.Match3 = ThirdMatch;
handles.Accuracy = Accuracy;
guidata(hObject, handles)

set(handles.MatchFoundText,'visible','on');


% --- Executes on button press in LoadTrainDataButton.
function LoadTrainDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadTrainDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TrainPath = './Norm_Images/Train_Images/';
% TrainPath = uigetdir('./Norm_Images/');

% Creating Training Set
[D, L] = CreateTrainDatabase(TrainPath);

handles.D = D;
handles.L = L;
guidata(hObject, handles)

set(handles.LoadDoneText,'visible','on');


function PCAEdit_Callback(hObject, eventdata, handles)
% hObject    handle to PCAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PCAEdit as text
%        str2double(get(hObject,'String')) returns contents of PCAEdit as a double


% --- Executes during object creation, after setting all properties.
function PCAEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PCAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function RecogAccuEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RecogAccuEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RecogAccuEdit as text
%        str2double(get(hObject,'String')) returns contents of RecogAccuEdit as a double


% --- Executes during object creation, after setting all properties.
function RecogAccuEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RecogAccuEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SelectTestPathButton.
function SelectTestPathButton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectTestPathButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get Path for Test Images
TestPath = uigetdir('./Norm_Images/');

handles.TestPath = TestPath;
guidata(hObject, handles)

set(handles.TestPathDoneText,'visible','on');
