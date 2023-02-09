
%% Animation

% Each link is only allowed to have 1 degree of freedom.


function [output] = AnimationSimm(input)

    th1 = input(1);
    th2 = input(2);
    th3 = input(3);

    L1 = 2;
    L2 = 2;
    L3 = 2;
    P = L1+L2+L3; % work envelope/ perimeter
%     th1 = theta1*pi/180;
%     th2 = theta2*pi/180;
%     th3 = theta3*pi/180;

    base.z = 0:0.1:1;
    base.x = base.z*0;
    base.y = base.z*0;
    
    plot(base.x,base.y)
    hold on;
    grid on;
    %axis([-P*1.1 P*1.1 -P*1.1 P*1.1]);

    T01 = TRANS(0, 0, 0, th1);
    T12 = TRANS(0, L1, 0, th2);
    T23 = TRANS(0, L2, 0, th3);
    T34 = TRANS(0, L3, 0, 0);
    
%     T04 = T01*T12*T23*T34
%     alpha = atan2(T04(2,1),T04(1,1))*180/pi;
%     if alpha < 0
%         alpha = alpha + 360
%     else
%         alpha = alpha
%     end
% %     
%     P01 = T01(1:3,4);
%     P12 = T12(1:3,4);
%     P23 = T23(1:3,4);
%     P34 = T34(1:3,4);
% 
%     R01 = T01(1:3,1:3);
%     R12 = T01(1:3,1:3);
%     R23 = T01(1:3,1:3);
%     R34 = T01(1:3,1:3);
    %T04 = T01*T12*T23*T34;
    q1 = th1;
    q2 = th2; 
    q3 = th3;
    
    X = L1*cos(q1) + L2*cos(q1 + q2) + L3*cos(q1 + q2 + q3);
    Y = L1*sin(q1) + L2*sin(q1 + q2) + L3*sin(q1 + q2 + q3);
    ALPHA = wrapToPi(q1+q2+q3);
    
    link1.a = T01*[0 0 0 1]';
    link1.b = T01*[L1 0 0 1]';

    link2.a = T01*T12*[0 0 0 1]';
    link2.b = T01*T12*[L2 0 0 1]';

    link3.a = T01*T12*T23*[0 0 0 1]';
    link3.b = T01*T12*T23*[L3 0 0 1]';

    link1.X = [link1.a(1) link1.b(1)];
    link1.Y = [link1.a(2) link1.b(2)];
    link1.plot = plot(link1.X, link1.Y,'-or','LineWidth',3);

    link2.X = [link2.a(1) link2.b(1)];
    link2.Y = [link2.a(2) link2.b(2)];
    link2.plot = plot(link2.X, link2.Y,'-og','LineWidth',3);

    link3.X = [link3.a(1) link3.b(1)];
    link3.Y = [link3.a(2) link3.b(2)];
    link3.plot = plot(link3.X, link3.Y,'-ob','LineWidth',3);
    
    axis([-P*1.1 P*1.1 -P*1.1 P*1.1]);
    

    %plot(T04(4,1),T04(4,2));
    %legend([link1.plot link2.plot link3.plot], strcat('\theta1= ',num2str(th1*180/pi)),strcat('\theta2= ',num2str(th2*180/pi,3)),strcat('\theta3= ',num2str(th3*180/pi)));
    %title('\fontsize{12}NO actuator torque, NO gravity')
    %     pause(0.001);
    
    hold off;
    output = [th1, th2, th3, X, Y, ALPHA];
    %output = [th1, th2, th3];

    %Export Gif
    
    Counter = input(7);
    name = 'NewAn.gif';
    %if (rem(Counter,0.011) == 0.00) || (Counter == 0.00)
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if Counter == 0.00
            imwrite(imind,cm,name,'gif', 'Loopcount',inf);
        else
            imwrite(imind,cm,name,'gif','WriteMode','append');
        end
end


function T = TRANS(alpha ,a, d, th)
    T = [cos(th) -sin(th) 0 a;
        sin(th)*cos(alpha) cos(th)*cos(alpha) -sin(alpha) -sin(alpha)*d;
        sin(th)*sin(alpha) cos(th)*sin(alpha) cos(alpha) cos(alpha)*d;
        0 0 0 1];
end



function gif(varargin)
% gif is the simplest way to make gifs. Simply call
% 
%   gif('myfile.gif') 
% 
% to write the first frame, and then call 
% 
%   gif
% 
% to write each subsequent frame. That's it. 
% 
%% Syntax
% 
%  gif('filename.gif') 
%  gif(...,'DelayTime',DelayTimeValue,...) 
%  gif(...,'LoopCount',LoopCountValue,...) 
%  gif(...,'frame',handle,...) 
%  gif(...,'resolution',res)
%  gif(...,'nodither') 
%  gif(...,'overwrite',true)
%  gif 
%  gif('clear') 
% 
%% Description 
% 
% gif('filename.gif') writes the first frame of a new gif file by the name filename.gif. 
% 
% gif(...,'DelayTime',DelayTimeValue,...) specifies a the delay time in seconds between
% frames. Default delay time is 1/15. 
% 
% gif(...,'LoopCount',LoopCountValue,...) specifies the number of times the gif animation 
% will play. Default loop count is Inf. 
% 
% gif(...,'frame',handle,...) uses the frame of the given figure or set of axes. The default 
% frame handle is gcf, meaning the current figure. To turn just one set of axes into a gif, 
% use 'frame',gca. This behavior changed in Jan 2021, as the default option changed from
% gca to gcf.
% 
% gif(...,'resolution',res) specifies the resolution (in dpi) of each frame. This option
% requires export_fig (https://www.mathworks.com/matlabcentral/fileexchange/23629).
%
% gif(...,'nodither') maps each color in the original image to the closest color in the new 
% without dithering. Dithering is performed by default to achieve better color resolution, 
% albeit at the expense of spatial resolution.
% 
% gif(...,'overwrite',true) bypasses a dialoge box that would otherwise verify 
% that you want to overwrite an existing file by the specified name. 
%
% gif adds a frame to the current gif file. 
% 
% gif('clear') clears the persistent variables associated with the most recent gif. 
% 
%% Example 
% For examples, type 
% 
%   cdt gif
% 
%% Author Information 
% This function was written by Chad A. Greene of the University of Texas 
% Institute for Geophysics (UTIG), June 2017. 
% 
% See also: imwrite, getframe, and rgb2ind. 
% Define persistent variables: 
persistent gif_filename firstframe DelayTime DitherOption LoopCount frame resolution
%% Parse Inputs
if nargin>0 
   
   % The user may want to clear things and start over: 
   if any(strcmpi(varargin,'clear'))
            
      % Clear persistent variables associated with this function: 
      clear gif_filename firstframe DelayTime DitherOption LoopCount frame resolution
   end
   
   % If the first input ends in .gif, assume this is the first frame:
   if strcmpi(varargin{1}(end-3:end),'.gif')
      
      % This is what the user wants to call the new .gif file: 
      gif_filename = varargin{1}; 
      
      % Check for an existing .gif file by the same name: 
      if exist(gif_filename,'file')==2
         OverWrite = false; % By default, do NOT overwrite an existing file by the input name. 
         if nargin>1
            tmp = strncmpi(varargin,'overwrite',4); 
            if any(tmp)
               OverWrite = varargin{find(tmp)+1}; 
               assert(islogical(OverWrite),'Error: Overwrite input must be either true or false.')
            end
         end
         
         if ~OverWrite
         
            % Ask the user if (s)he wants to overwrite the existing file: 
            choice = questdlg(['The file  ',gif_filename,' already exists. Overwrite it?'], ...
               'The file already exists.','Overwrite','Cancel','Cancel');
            if strcmp(choice,'Overwrite')
               OverWrite = true; 
            end
         end
         
         % Overwriting basically means deleting and starting from scratch: 
         if OverWrite
            delete(gif_filename) 
         else 
            clear gif_filename firstframe DelayTime DitherOption LoopCount frame
            error('The giffing has been canceled.') 
         end
         
      end
      
      firstframe = true; 
      
      % Set defaults: 
      DelayTime = 1/15; 
      DitherOption = 'dither'; 
      LoopCount = Inf; 
      frame = gcf; 
      resolution = 0; % When 0, it's used as a boolean to say "don't use export_fig". If greater than zero, the boolean says "use export_fig and use the specified resolution."  
   end
   
   tmp = strcmpi(varargin,'DelayTime'); 
   if any(tmp) 
      DelayTime = varargin{find(tmp)+1}; 
      assert(isscalar(DelayTime),'Error: DelayTime must be a scalar value.') 
   end
   
   if any(strcmpi(varargin,'nodither'))
      DitherOption = 'nodither'; 
   end
   
   tmp = strcmpi(varargin,'LoopCount'); 
   if any(tmp) 
      LoopCount = varargin{find(tmp)+1}; 
      assert(isscalar(LoopCount),'Error: LoopCount must be a scalar value.') 
   end
   
   tmp = strncmpi(varargin,'resolution',3); 
   if any(tmp) 
      resolution = varargin{find(tmp)+1}; 
      assert(isscalar(resolution),'Error: resolution must be a scalar value.') 
      assert(exist('export_fig.m','file')==2,'export_fig not found. If you wish to specify the image resolution, get export_fig here :https://www.mathworks.com/matlabcentral/fileexchange/23629. Otherwise remove the resolution from the gif inputs to use the default (lower quality) built-in getframe functionality.')  
      warning off export_fig:exportgraphics
   end
   
   tmp = strcmpi(varargin,'frame'); 
   if any(tmp) 
      frame = varargin{find(tmp)+1}; 
      assert(ishandle(frame)==1,'Error: frame must be a figure handle or axis handle.') 
   end
   
else
   assert(isempty(gif_filename)==0,'Error: The first call of the gif function requires a filename ending in .gif.') 
end
%% Perform work: 
if resolution % If resolution is >0, it means use export_fig
   
   if isgraphics(frame,'figure')
      f = export_fig('-nocrop',['-r',num2str(resolution)]);
   else
      % If the frame is a set of axes instead of a figure, use default cropping: 
      f = export_fig(['-r',num2str(resolution)]);
   end
      
else
   % Get frame: 
   fr = getframe(frame); 
   f =  fr.cdata; 
end
% Convert the frame to a colormap and corresponding indices: 
[imind,cmap] = rgb2ind(f,256,DitherOption);    
% Write the file:     
if firstframe
   imwrite(imind,cmap,gif_filename,'gif','LoopCount',LoopCount,'DelayTime',DelayTime)
   firstframe = false;
else
   imwrite(imind,cmap,gif_filename,'gif','WriteMode','append','DelayTime',DelayTime)
end
end

