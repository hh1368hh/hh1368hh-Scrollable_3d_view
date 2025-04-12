function [D_3d,Resized_img] = Scrollable(info_file,File)

global fdata loaded ax img info img_rs img_rs_slice d
img=File;
info=info_file;
%% Find the spacings
pixel_spc=info{1,1}.PixelSpacing;
slide_spc=info{1,1}.SliceThickness;
%% Resizing
img_rs=imresize3(img,[1*size(img,1),1*size(img,2),slide_spc/pixel_spc(1)*size(img,3)]);
img_rs_slice=imresize3(img,[1/3*size(img,1),1/3*size(img,2),slide_spc/(3*pixel_spc(1))*size(img,3)]);

fdata = figure( 'windowstyle', 'normal', 'resize', 'on', 'position',[200 100 900 600],...
    'name', 'Visualizer', 'NumberTitle', 'off','KeyPressFcn',@keyPress);

Load = uicontrol('parent', fdata, 'Style', 'pushbutton', 'units', 'normalized', 'String', 'LOAD', ...
    'Position', [0.03 0.9 0.05 0.05], 'Callback', @loadfile);

% sel = uicontrol('parent', fdata, 'Style', 'pushbutton', 'units', 'normalized', 'String', 'Sel', ...
%     'Position', [0.03 0.8 0.05 0.05], 'Callback', @sel_img);

done = uicontrol('parent', fdata, 'Style', 'pushbutton', 'units', 'normalized', 'String', 'Done', ...
    'Position', [0.03 0.8 0.05 0.05], 'Callback', @done_loading);

% dvoxel_view = uicontrol('parent', fdata, 'Style', 'pushbutton', 'units', 'normalized', 'String', '3dVoxel', ...
%     'Position', [0.03 0.7 0.05 0.05], 'Callback', @dvoxel_show);

function done_loading(hObject, eventdata)
% global d img_rs
D_3d=d;
Resized_img=img_rs;

% save('Dim_3d.mat','D_3d','Resized_img')

close(fdata)

uiresume;
end


uiwait;
end

function loadfile(hObject, eventdata)
global fdata img loaded ax d info Slider_a Slider_s Slider_c text_a text_s text_c img_rs img_rs_slice s_h I_S I_C I_A

%% Loading the Image
d=[floor(size(img_rs,1)/2) floor(size(img_rs,2)/2) floor(size(img_rs,3)/2)];
d_slice=floor(d/3);
img_axial=img_rs(:,:,d(3));
img_sagitall=(squeeze(img_rs(:,d(2),:)))';
img_coronal=(squeeze(img_rs(d(1),:,:)))';

ax(1)=subplot(2,3,4);
I_A=imagesc(img_axial);
axis image
colormap('gray')
ax(2)=subplot(2,3,5);
I_S=imagesc(img_sagitall);
axis image
colormap('gray')

ax(3)=subplot(2,3,6);
I_C=imagesc(img_coronal);
axis image
colormap('gray')

ax(4)=subplot(2,3,1:3);
s_h=slice(double(img_rs),d(1),d(2),d(3));
axis image
colormap('gray')
shading interp
% set(ax(4),'Ydir','reverse')
% set(ax(4),'Xdir','reverse')
set(ax(4),'Zdir','reverse')
% view(140,30)


%% creating the sliders

Slider_a = uicontrol('parent', fdata, 'Style', 'slider', 'units', 'normalized',...
    'Position', [0.13 0.05 0.2 0.03],'Callback', @slider_a_func);
set(Slider_a,'Sliderstep',[1/(size(img_rs,3)-1) 1],...
    'max',size(img_rs,3),'min',1,'Value',d(3))
text_a= uicontrol('parent', fdata, 'Style', 'text', 'String', num2str(get(Slider_a,'value')), 'units', 'normalized', ...
    'FontSize',7,'Position', [0.2 0.0 0.05 0.05]);
%==================================
Slider_s = uicontrol('parent', fdata, 'Style', 'slider', 'units', 'normalized',...
    'Position', [0.4 0.05 0.2 0.03],'Callback', @slider_s_func);
set(Slider_s,'Sliderstep',[1/(size(img_rs,2)-1) 1],...
    'max',size(img_rs,2),'min',1,'Value',d(2))
text_s= uicontrol('parent', fdata, 'Style', 'text', 'String', num2str(get(Slider_s,'value')), 'units', 'normalized', ...
        'FontSize',7,'Position', [0.48 0.0 0.05 0.05]);
%==================================
Slider_c = uicontrol('parent', fdata, 'Style', 'slider', 'units', 'normalized',...
    'Position', [0.7 0.05 0.2 0.03],'Callback', @slider_c_func);
set(Slider_c,'Sliderstep',[1/(size(img_rs,1)-1) 1],...
    'max',size(img_rs,1),'min',1,'Value',d(1))
text_c= uicontrol('parent', fdata, 'Style', 'text', 'String', num2str(get(Slider_c,'value')), 'units', 'normalized', ...
        'FontSize',7,'Position', [0.78 0.0 0.05 0.05]);
loaded=1;
end

function slider_a_func(hObject, eventdata)
global fdata img loaded ax d info Slider_a Slider_s Slider_c text_a text_s text_c img_rs s_h   I_A

% new value of d for visualizing
nd=get(Slider_a,'value');
set(text_a, 'String', num2str(round(nd)));

img_axial=img_rs(:,:,round(nd));
% ax(1)=subplot(2,3,4);
% imagesc(img_axial)
% axis image

I_A.CData=img_axial;
drawnow


d(3)=round(nd);
% ax(4)=subplot(2,3,1:3);
% slice(double(img_rs),d(1),d(2),d(3))
% axis image
% colormap('gray')
% shading interp
% set(ax(4),'Ydir','reverse')
% set(ax(4),'Xdir','reverse')
% set(ax(4),'Zdir','reverse')

s_h(3).CData=img_axial;
newZ=round(nd)*ones(size(s_h(3).ZData));
s_h(3).ZData=newZ;

end

function slider_s_func(hObject, eventdata)
global fdata img loaded ax d info Slider_a Slider_s Slider_c text_a text_s text_c  pixel_spc slide_spc img_rs s_h I_S

% new value of d for visualizing
nd=get(Slider_s,'value');
set(text_s, 'String', num2str(round(nd)));
img_sagitall=(squeeze(img_rs(:,round(nd),:)))';
% img_sagitall_rs=imresize(img_sagitall,[slide_spc/pixel_spc(1)*size(img_sagitall,1),size(img_sagitall,2)]);
% ax(2)=subplot(2,3,5);
% imagesc(img_sagitall)
% axis image
% colormap('gray')

I_S.CData=img_sagitall;
drawnow


d(2)=round(nd);
% ax(4)=subplot(2,3,1:3);
% slice(double(img_rs),d(1),d(2),d(3))
% axis image
% colormap('gray')
% shading interp
% % set(ax(4),'Ydir','reverse')
% % set(ax(4),'Xdir','reverse')
% set(ax(4),'Zdir','reverse')

s_h(1).CData=img_sagitall';
newX=round(nd)*ones(size(s_h(1).XData));
s_h(1).XData=newX;

end

function slider_c_func(hObject, eventdata)
global fdata img loaded ax d info Slider_a Slider_s Slider_c text_a text_s text_c  pixel_spc slide_spc img_rs s_h I_C

% new value of d for visualizing
nd=get(Slider_c,'value');
set(text_c, 'String', num2str(round(nd)));
img_coronal=(squeeze(img_rs(round(nd),:,:)))';
% img_coronal_rs=imresize(img_coronal,[slide_spc/pixel_spc(1)*size(img_coronal,1),size(img_coronal,2)]);
% ax(2)=subplot(2,3,6);
% imagesc(img_coronal)
% axis image
% colormap('gray')

I_C.CData=img_coronal;
drawnow


d(1)=round(nd);
% ax(4)=subplot(2,3,1:3);
% slice(double(img_rs),d(1),d(2),d(3))
% axis image
% colormap('gray')
% shading interp
% % set(ax(4),'Ydir','reverse')
% % set(ax(4),'Xdir','reverse')
% set(ax(4),'Zdir','reverse')
s_h(2).CData=img_coronal';
newY=round(nd)*ones(size(s_h(2).YData));
s_h(2).YData=newY;
end


