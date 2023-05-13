function [out1] = Data_Recorder(filename)
slopenum=100; % number of points to calculate the slope over
tarenum=10;
f_zero=0;
lastTime=10; %initial plot width
maxf=20; % max force for plot scaling
Calibration=8.668475056020756e-04;
updateTime=.5; %how often the plot gets updated
%checks to see if you entered a file name, if you haven't it will prompt you
if exist('filename','var')==0
    filename=input('Filename to store data?   ','s');
end
filename=strcat(filename,'.csv'); 
FID=fopen(filename,'w'); 
%opens the serial port using a custom function to find the arduino port
s=serialport(['COM' num2str(3)],57600);
%opens the control window
fig = uifigure('Name','Control','Position',[200 500 500 200]); 
btnMark = uibutton(fig,'state','Text', 'slope','Value',false,'Position',[5,150, 200, 20]);
btnStop = uibutton(fig,'state','Text', 'Start','Value', false,'Position',[220,150, 50,20]); 
btnTare = uibutton(fig,'state','Text', 'Tare','Value', false,'Position',[5,125, 50,20]); 
reading = uilabel(fig,'Text','0','Position',[5,25, 600,80],'FontSize',60);
%createds the plot figure   
figure(1)
plot([0 3000],[15 15],'Color','blue')
hold on
h=animatedline('color','red');
hold off
axis([0 lastTime 0 maxf]);  
grid on; 
yticks(0:20)
xlabel('time[s]'); 
ylabel('Force'); 
title ('Force'); 
hold on 

%***********  start main data collection loop  ******************* 
%runs while waiting for you to press the start button
i=0;
while btnStop.Value<1
    i=i+1;
    out=readline(s); 
    C=textscan(out,'%f'); 
    A=cell2mat(C);  
    time=A(1)/1000;
    force=A(2)*Calibration-f_zero;
    reading.Text=['Force: ' num2str(force) ' lb'];
    f_temp(i)=force;
    if btnTare.Value==1
        if i>tarenum
            f_zero=mean(f_temp(i-tarenum:i))+f_zero;
        end
        btnTare.Value=0;
    end
end
%logs first data point
btnStop.Value=0;
btnStop.Text='Stop';
i=1;
startTime=time;
time=A(1)/1000-startTime;
f(i)=force;
t(i)=time;
addpoints(h,time,force);
%logs the second data point onwards
while btnStop.Value<1
    i=i+1;
    out=readline(s); 
    C=textscan(out,'%f'); 
    A=cell2mat(C);  
    time=A(1)/1000-startTime;
    force=A(2)*Calibration-f_zero;
    f(i)=force;
    t(i)=time;
    reading.Text=['Force: ' num2str(force) ' lb'];
    if mod(i,ceil(updateTime/(t(2)-t(1))))==0 %updates the plot every .5 seconds
        if btnMark.Value==1
            if i>slopenum
                favg=mean(f(i-slopenum:i));
                P = polyfit(t(i-slopenum:i),f(i-slopenum:i),1);
                btnMark.Text=['slope: ' num2str(P(1)) ' mean: ' num2str(favg)];
            end
            btnMark.Value=0;
        end
        addpoints(h,time,force);
        if time>lastTime
            lastTime=lastTime+10;
            axis([0 lastTime 0 maxf]); 
        end
        drawnow
    end
end
clear s
for i=1:length(f)
    fprintf(FID,'%10.3f, %10.3f \r\n',t(i),f(i));
end
close(fig); 
fclose(FID);
close all;
out1=[t',f'];
end

