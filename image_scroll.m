function [] = image_scroll(img)

global img_rs img_rs_backup hdatadisplay Slider_a text_a D_3d I_main
img_rs=img;
img_rs_backup=img_rs;


%% Function Declaration
    function bselection(hObject, eventdata)
        
        b_sel_array=[r1.Value,r2.Value,r3.Value];
        b_sel_switch=find(b_sel_array,1);
        switch (b_sel_switch)
            
            case 1
                
                figure(hdatadisplay)
                
                c_img=img_rs(:,:,D_3d(3));
                I_main=imagesc(c_img);
                axis image
                colormap('gray')
                set(Slider_a,'Visible','on')
                set(text_a,'Visible','on')
                set(Slider_c,'Visible','off')
                set(text_c,'Visible','off')
                set(Slider_s,'Visible','off')
                set(text_s,'Visible','off')
                slider_a_func_main;
            case 2
                figure(hdatadisplay)
                
                c_img=rot90(squeeze(img_rs(:,D_3d(2),:)),-1);
                I_main=imagesc(c_img);
                axis image
                colormap('gray')
                set(Slider_a,'Visible','off')
                set(text_a,'Visible','off')
                
                set(Slider_c,'Visible','on')
                set(text_c,'Visible','on')
                
                set(Slider_s,'Visible','off')
                set(text_s,'Visible','off')
                
                slider_c_func_main;
                
            case 3
                figure(hdatadisplay)
                
                c_img=rot90(squeeze(img_rs(D_3d(1),:,:)),-1);
                I_main=imagesc(c_img);
                axis image
                colormap('gray')
                set(Slider_a,'Visible','off')
                set(text_a,'Visible','off')
                
                set(Slider_c,'Visible','off')
                set(text_c,'Visible','off')
                
                set(Slider_s,'Visible','on')
                set(text_s,'Visible','on')
                
                slider_s_func_main;
                
                
        end
        
        
    end



    function slider_win_level(hObject, eventdata)
        %% Window Level Visualization
        img_rs=img_rs_backup;
        
        if exist('deformed_img_show') && deformed_img_show
            img_rs=img_deformed;
        end
        
        l_v=get(Level_l,'value');
        set(text_l, 'String', num2str(round(l_v)));
        w_v=get(window_w,'value');
        set(text_w, 'String', num2str(round(w_v)));
        
        
        %% adjusting the contrast
        % first filter out all above and below values
        u_b=round(l_v+w_v/2);
        l_b=round(l_v-w_v/2);
        if max_image>=u_b || min_image<=l_b
            u_l=max_image;
            l_l=min_image;
            if max_image>u_b
                img_rs(img_rs>=u_b)=u_b;
                u_l=u_b;
            end
            if min_image<l_b
                img_rs(img_rs<=l_b)=l_b;
                l_l=l_b;
            end
            
            img_rs=(img_rs-l_l)*((max_image-min_image)/(u_l-l_l))+min_image;
            
            b_sel_array=[r1.Value,r2.Value,r3.Value];
            b_sel_switch=find(b_sel_array,1);
            switch (b_sel_switch)
                case 1
                    slider_a_func_main;
                case 2
                    slider_c_func_main;
                case 3
                    slider_s_func_main
            end
            
        end
    end


    function slider_a_func_main(hObject, eventdata)
        %         global hdatadisplay Slider_a text_a img_rs D_3d I_main
        nd=get(Slider_a,'value');
        set(text_a, 'String', num2str(round(nd)));
        
        
        
        %% Window Level Visualization
        % if l_v
        % l_v=get(Level_l,'value');
        % set(text_l, 'String', num2str(round(l_v)));
        % w_v=get(window_w,'value');
        % set(text_w, 'String', num2str(round(w_v)));
        %
        
        
        % end
        
        %%
        
        img_axial=img_rs(:,:,round(nd));
        D_3d(3)=round(nd);
        
        I_main.CData=img_axial;
        % newZ=round(nd)*ones(size(s_h(3).ZData));
        % s_h(3).ZData=newZ;
        if exist('h','var')
            delete(h)
        end
        % if isempty(dline_cell_a{round(nd)})
        %
        % d_line=[[],[]];
        % h.XData=[];
        % h.YData=[];
        % refreshdata(h)
        % I_main.CData=img_axial;
        % else
        %     d_line=dline_cell_a{round(nd)};
        %     hold on
        %     h=plot(d_line(:,1),d_line(:,2),'LineStyle','none','Marker','.','Color','r');
        %     hold off
        
        % end
        noverwrite=1;
        colorbar
        % contour_update
    end

    function slider_s_func_main(hObject, eventdata)
        nd=get(Slider_s,'value');
        set(text_s, 'String', num2str(round(nd)));
        
        img_coronal=rot90(squeeze(img_rs(round(nd),:,:)),-1);
        D_3d(1)=round(nd);
        
        I_main.CData=img_coronal;
        % newZ=round(nd)*ones(size(s_h(3).ZData));
        % s_h(3).ZData=newZ;
        if exist('h','var')
            delete(h)
        end
        %         if isempty(dline_cell_c{round(nd)})
        %             %
        %             % d_line=[[],[]];
        %             % h.XData=[];
        %             % h.YData=[];
        %             % refreshdata(h)
        %             % I_main.CData=img_axial;
        %         else
        %             d_line=dline_cell_c{round(nd)};
        %             hold on
        %             h=plot(d_line(:,1),d_line(:,2),'LineStyle','none','Marker','.','Color','r');
        %             hold off
        %
        %         end
        noverwrite=1;
        %         contour_update
        
        
        
        colorbar
        
    end

    function slider_c_func_main(hObject, eventdata)
        nd=get(Slider_c,'value');
        set(text_c, 'String', num2str(round(nd)));
        
        img_sagitall=rot90(squeeze(img_rs(:,round(nd),:)),-1);
        D_3d(2)=round(nd);
        
        I_main.CData=img_sagitall;
        % newZ=round(nd)*ones(size(s_h(3).ZData));
        % s_h(3).ZData=newZ;
        if exist('h','var')
            delete(h)
        end
        %         if isempty(dline_cell_s{round(nd)})
        %             %
        %             % d_line=[[],[]];
        %             % h.XData=[];
        %             % h.YData=[];
        %             % refreshdata(h)
        %             % I_main.CData=img_axial;
        %         else
        %             d_line=dline_cell_s{round(nd)};
        %             hold on
        %             h=plot(d_line(:,1),d_line(:,2),'LineStyle','none','Marker','.','Color','r');
        %             hold off
        %
        %         end
        noverwrite=1;
        colorbar
    end



%% Figure Creation

hdatadisplay = figure('Name', 'Data Display','IntegerHandle','off', 'units','normalized','outerposition',[0.0 0.05 1 .95],'NumberTitle','off');%,'Color',[0,0,.05],'toolbar','none');
% axis image;
%% Initialization
D_3d=[floor(size(img_rs,1)/2) floor(size(img_rs,2)/2) floor(size(img_rs,3)/2)];
%% Done Button
done = uicontrol('parent', hdatadisplay, 'Style', 'pushbutton', 'units', 'normalized', 'String', 'Done', ...
    'Position', [0.03 0.8 0.05 0.05], 'Callback', @done_loading);
%% Slider Definitions

Slider_a = uicontrol('parent', hdatadisplay, 'Style', 'slider', 'units', 'normalized',...
    'Position', [0.4 0.05 0.2 0.03],'Callback', @slider_a_func_main);
set(Slider_a,'Sliderstep',[1/(size(img_rs,3)-1) 10/(size(img_rs,3)-1)],...
    'max',size(img_rs,3),'min',1,'Value',D_3d(3))
text_a= uicontrol('parent', hdatadisplay, 'Style', 'text', 'String', num2str(get(Slider_a,'value')), 'units', 'normalized', ...
    'FontSize',7,'Position', [0.48 0.0 0.05 0.05]);

Slider_c = uicontrol('parent', hdatadisplay, 'Style', 'slider', 'units', 'normalized',...
    'Position', [0.4 0.05 0.2 0.03],'Callback', @slider_c_func_main);
set(Slider_c,'Sliderstep',[1/(size(img_rs,1)-1) 10/(size(img_rs,1)-1)],...
    'max',size(img_rs,1),'min',1,'Value',D_3d(1),'Visible','off')
text_c= uicontrol('parent', hdatadisplay, 'Style', 'text', 'String', num2str(get(Slider_c,'value')), 'units', 'normalized', ...
    'FontSize',7,'Position', [0.48 0.0 0.05 0.05],'Visible','off');

Slider_s = uicontrol('parent', hdatadisplay, 'Style', 'slider', 'units', 'normalized',...
    'Position', [0.4 0.05 0.2 0.03],'Callback', @slider_s_func_main);
set(Slider_s,'Sliderstep',[1/(size(img_rs,2)-1) 10/(size(img_rs,2)-1)],...
    'max',size(img_rs,2),'min',1,'Value',D_3d(2),'Visible','off')
text_s= uicontrol('parent', hdatadisplay, 'Style', 'text', 'String', num2str(get(Slider_s,'value')), 'units', 'normalized', ...
    'FontSize',7,'Position', [0.48 0.0 0.05 0.05],'Visible','off');
%% Image Visualization Window and level

max_image=round(double(max(img_rs,[],'all')));
min_image=round(double(min(img_rs,[],'all')));
range_image=round(max_image-min_image);

Level_l = uicontrol('parent', hdatadisplay, 'Style', 'slider', 'units', 'normalized',...
    'Position', [0.65 0.05 0.1 0.03],'Callback', @slider_win_level);
set(Level_l,'Sliderstep',[1/range_image 10/range_image],...
    'max',max_image,'min',min_image,'Value',round((max_image+min_image)/2),'Visible','on')
text_l= uicontrol('parent', hdatadisplay, 'Style', 'text', 'String', num2str(get(Level_l,'value')), 'units', 'normalized', ...
    'FontSize',7,'Position', [0.68 0.0 0.05 0.05],'Visible','on');
set(Level_l,'Value',min(img_rs,[],'all')+range(img_rs,'all')/3);

window_w = uicontrol('parent', hdatadisplay, 'Style', 'slider', 'units', 'normalized',...
    'Position', [0.8 0.05 0.1 0.03],'Callback', @slider_win_level);
set(window_w,'Sliderstep',[1/(range_image-1) 10/(range_image-1)],...
    'max',range_image,'min',1,'Value',round(range_image),'Visible','on')
text_w= uicontrol('parent', hdatadisplay, 'Style', 'text', 'String', num2str(get(window_w,'value')), 'units', 'normalized', ...
    'FontSize',7,'Position', [0.83 0.0 0.05 0.05],'Visible','on');
set(window_w,'Value',range(img_rs,'all')/5);


%% Radio Buttons definition


%         ff=figure

bg = uibuttongroup('parent', hdatadisplay,'Visible','on',...
    'units', 'normalized','Position', [0.92 0.65 0.07 0.2],...
    'SelectionChangedFcn',@bselection);

% Create three radio buttons in the button group.
r1 = uicontrol(bg,'Style',...
    'radiobutton',...
    'String','Axial',...
    'units', 'normalized','Position', [0.0 0.7 0.8 0.2],...
    'HandleVisibility','off');

r2 = uicontrol(bg,'Style','radiobutton',...
    'String','Sagittal',...
    'units', 'normalized','Position', [0 0.4 0.8 0.2],...
    'HandleVisibility','off');

r3 = uicontrol(bg,'Style','radiobutton',...
    'String','Coronal',...
    'units', 'normalized','Position', [0 0.1 0.8 0.2],...
    'HandleVisibility','off');
%% Updating
bselection;
slider_win_level;
colorbar



uiwait;









end

function done_loading(hObject, eventdata)
global hdatadisplay
%         D_3d=d;
%         Resized_img=img_rs;

% save('Dim_3d.mat','D_3d','Resized_img')

close(hdatadisplay)

uiresume;
end



