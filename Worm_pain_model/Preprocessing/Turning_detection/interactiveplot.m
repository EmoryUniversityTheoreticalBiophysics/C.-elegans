function varargout = interactiveplot(varargin)
% INTERACTIVEPLOT MATLAB code for interactiveplot.fig
%      INTERACTIVEPLOT, by itself, creates a new INTERACTIVEPLOT or raises the existing
%      singleton*.
%
%      H = INTERACTIVEPLOT returns the handle to a new INTERACTIVEPLOT or the handle to
%      the existing singleton*.
%
%      INTERACTIVEPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERACTIVEPLOT.M with the given input arguments.
%
%      INTERACTIVEPLOT('Property','Value',...) creates a new INTERACTIVEPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interactiveplot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interactiveplot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interactiveplot

% Last Modified by GUIDE v2.5 29-May-2013 14:22:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interactiveplot_OpeningFcn, ...
                   'gui_OutputFcn',  @interactiveplot_OutputFcn, ...
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

% --- Executes just before interactiveplot is made visible.
function interactiveplot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interactiveplot (see VARARGIN)

% Choose default command line output for interactiveplot
handles.output = hObject;
  
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interactiveplot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interactiveplot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1. (load button)
function pushbutton1_Callback(hObject, eventdata, handles)
    global  twormskelx twormskely currentfile tskelcurv
    load input_ctrl;
    currentfile = str2num(get(handles.currentedit,'String'))
    test = filename{currentfile}
    twormskelx = wormskelx(:,:,currentfile);
    twormskely = wormskely(:,:,currentfile);
    tskelcurv = skelcurv(:,:,currentfile);
    set(handles.filenametext,'String', filename{currentfile})
    plot(handles.axes1,twormskelx(1,:),twormskely(1,:));
    
    
    
    set(handles.edit3,'String','0');
    set(handles.edit1,'String','0');
    set(handles.reverseedit,'String','0');
    
    
    try
        
        
        
    end
    
    set(handles.lasertext,'String',num2str(I_ctrl(currentfile)));
    
    
    xlim([0 656])
    ylim([0 490])
    title('1')
    
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)

global twormskelx twormskely currentfile currentpos tskelcurv
slider_max = get(hObject,'Max');
slider_min = get(hObject,'Max');
slider_value = get(hObject,'Value');
currentpos = round(slider_value);
plot(handles.axes1,twormskelx(currentpos,:),twormskely(currentpos,:));
hold
plot(handles.axes1,twormskelx(currentpos,1),twormskely(currentpos,1),'O');
hold
title(currentpos)
xlim([0 656])
ylim([0 490])

curvvalue = mean(tskelcurv(currentpos,1:8));
set(handles.headcurvtext,'String',num2str(curvvalue));





% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



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



% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
    global currentpos
    set(handles.edit1, 'String', currentpos)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in endbutton.
function endbutton_Callback(hObject, eventdata, handles)
    global currentpos
    set(handles.edit3, 'String', currentpos)
% hObject    handle to endbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
global currentfile
load D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\DATAANLYSIS\Turning_analysis\output.mat
endnum(currentfile) = str2num(get(handles.edit3,'String'));
startnum(currentfile) = str2num(get(handles.edit1,'String'));
reversenum(currentfile) = str2num(get(handles.reverseedit,'String'));

radioselect(1)= get(handles.yesbutton,'Value');
radioselect(2)=get(handles.nobutton,'Value');
radioselect(3)=get(handles.maybebutton,'Value');

if radioselect(1) == 1
    reversevalue(currentfile) = 1;
end
if radioselect(2) == 1
    reversevalue(currentfile) = 0;
end
if radioselect(3) == 1
    reversevalue(currentfile) = 2;
end

radioselect2(1)=get(handles.radiobutton7,'Value');
radioselect2(2)=get(handles.radiobutton8,'Value');

if radioselect2(1) == 1
    wronghead(currentfile) = 1;
end
if radioselect2(2) == 1
    wronghead(currentfile) = 0;
end



tempdata(1,:) = reversevalue;
tempdata(2,:) = reversenum;
tempdata(3,:) = startnum;
tempdata(4,:) = endnum;
tempdata(5,:) = wronghead;
set(handles.uitable,'Data',tempdata);

save('D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\DATAANLYSIS\Turning_analysis\output.mat' ,'endnum' ,'startnum','reversenum','reversevalue','wronghead')

% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in refreshbutton.
function refreshbutton_Callback(hObject, eventdata, handles)
load D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\DATAANLYSIS\Turning_analysis\output.mat
tempdata(1,:) = reversevalue;
tempdata(2,:) = reversenum;
tempdata(3,:) = startnum;
tempdata(4,:) = endnum;
tempdata(5,:) = wronghead;
save('D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\DATAANLYSIS\Turning_analysis\tempdata.mat' ,'tempdata')
set(handles.uitable,'Data',tempdata);


% hObject    handle to refreshbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function currentedit_Callback(hObject, eventdata, handles)
% hObject    handle to currentedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentedit as text
%        str2double(get(hObject,'String')) returns contents of currentedit as a double


% --- Executes during object creation, after setting all properties.
function currentedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in minusbutton.
function minusbutton_Callback(hObject, eventdata, handles)
temp = num2str(str2num(get(handles.currentedit,'String'))-1);
set(handles.currentedit, 'String', temp);

% hObject    handle to minusbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plusbutton.
function plusbutton_Callback(hObject, eventdata, handles)
temp = num2str(str2num(get(handles.currentedit,'String'))+1);
set(handles.currentedit, 'String', temp);

% hObject    handle to plusbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function behaviortag_Callback(hObject, eventdata, handles)
% hObject    handle to behaviortag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of behaviortag as text
%        str2double(get(hObject,'String')) returns contents of behaviortag as a double


% --- Executes during object creation, after setting all properties.
function behaviortag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to behaviortag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Bebaviorbutton.
function Bebaviorbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Bebaviorbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in yesbutton.
function yesbutton_Callback(hObject, eventdata, handles)
% hObject    handle to yesbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of yesbutton


% --- Executes on button press in nobutton.
function nobutton_Callback(hObject, eventdata, handles)
% hObject    handle to nobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nobutton


% --- Executes on button press in maybebutton.
function maybebutton_Callback(hObject, eventdata, handles)
% hObject    handle to maybebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of maybebutton


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function reverseedit_Callback(hObject, eventdata, handles)
% hObject    handle to reverseedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reverseedit as text
%        str2double(get(hObject,'String')) returns contents of reverseedit as a double


% --- Executes during object creation, after setting all properties.
function reverseedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reverseedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reversebutton.
function reversebutton_Callback(hObject, eventdata, handles)
global currentpos
    set(handles.reverseedit, 'String', currentpos)
% hObject    handle to reversebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveflagbutton.
function saveflagbutton_Callback(hObject, eventdata, handles)
% hObject    handle to saveflagbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currentfile
try
load D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\DATAANLYSIS\Turning_analysis\slowmotionflag.mat
end


radioselect(1)= get(handles.radiobutton19,'Value');
radioselect(2)=get(handles.radiobutton20,'Value');
radioselect(3)=get(handles.radiobutton21,'Value');

if radioselect(1) == 1
    slowmotionflag(currentfile) = 1;
end
if radioselect(2) == 1
    slowmotionflag(currentfile) = 0;
end
if radioselect(3) == 1
    slowmotionflag(currentfile) = 2;
end

load D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\DATAANLYSIS\Turning_analysis\output.mat
tempdata(1,:) = reversevalue;
tempdata(2,:) = reversenum;
tempdata(3,:) = startnum;
tempdata(4,:) = endnum;
tempdata(5,:) = wronghead;
try
tempdata(6,:) = slowmotionflag;
end
set(handles.uitable,'Data',tempdata);

save D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\DATAANLYSIS\Turning_analysis\slowmotionflag.mat slowmotionflag
