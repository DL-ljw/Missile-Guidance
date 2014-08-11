close all
clear all

Vt = 300;
alphaT = 130;
alphaT_rad = alphaT*(pi/180);

R0 = 3000;
theta0 = 30;
theta0_rad = theta0*(pi/180);

xt0 = R0*cos(theta0_rad);
yt0 = R0*sin(theta0_rad);
Vt_hor = Vt*cos(alphaT_rad);
Vt_ver = Vt*sin(alphaT_rad);

Mu = 0.9;
Vm = Mu*Vt;

xm0 = 0;
ym0 = 0;

xt = xt0;
yt = yt0;
xm = xm0;
ym = ym0;
alphaM_rad = theta0_rad;
alphaM = alphaM_rad*(180/pi);
Vm_hor = Vm*cos(alphaM_rad);
Vm_ver = Vm*sin(alphaM_rad);

R = R0;
theta_rad = theta0_rad;
del_theta_rad = 0;
del_theta = del_theta_rad*(180/pi);
delta = 10;
delta_rad = delta*(pi/180);
Ka = 10;
delT = 0.1;

imgframe = 0;
figHandle = figure;
set(figHandle,'WindowStyle','docked');
hold on;
f1 = subplot(2,3,1);
l1 = plot(0,0,'*');

flag = 0;

for t = 0:delT:100
    
    del_R = (Vt*cos(alphaT_rad - theta_rad) - ...
            Vm*cos(delta_rad));
    R2 = R + del_R * delT; 
%     R2 = sqrt((yt-ym)^2 + (xt-xm)^2);
    
    if abs(R2) > abs(R)
        flag = flag+1;
    end
    if flag > 2 
        break;
    end
    
    R = R2;
    del_theta_rad = (Vt*sin(alphaT_rad - theta_rad)-Vm*sin(delta_rad))/R;
%     del_theta_rad = (theta2_rad - theta_rad)/delT;%rad/sec
    del_theta = del_theta_rad*(180/pi);
    
    theta_rad = theta_rad + del_theta_rad*delT;
%     atan3((yt-ym),(xt-xm));
    theta = theta_rad*(180/pi);
%     theta_rad = theta2_rad;
%     theta = theta_rad*(180/pi);    

    a_m = (Vm*del_theta_rad) - (Ka*(alphaM_rad-theta_rad-delta));    
%     a_m_hor = a_m*cos(((pi/2)+alphaM_rad));%+ve x axis
%     a_m_ver = a_m*sin(((pi/2)+alphaM_rad));%+ve y axis
            
    del_alphaM_rad = a_m/Vm;
    alphaM_rad = alphaM_rad + del_alphaM_rad*delT;
%     alphaM_rad = atan3((ym2-ym),(xm2-xm));
    alphaM = alphaM_rad*(180/pi);

    Vm_hor = Vm*cos(alphaM_rad);
    Vm_ver = Vm*sin(alphaM_rad);

    xm = xm + Vm_hor*delT;% + (a_m_hor*(delT^2))/2;
    ym = ym + Vm_ver*delT;% + (a_m_ver*(delT^2))/2;    

%     ym = ym2;
%     xm = xm2;
    
    xt = xt + Vt_hor*delT;
    yt = yt + Vt_ver*delT;

%     if t == 2
        pause(0.2);
%     end

%     f1 = figure(1);
%     set(f1,'WindowStyle','docked');
    f1 = subplot(2,3,1);
    box on;
    hold on;
    delete(l1);
    plot(xt,yt,'r*');    
    plot(xm,ym,'g*');
    l1 = plot([xt xm],[yt ym],'b');
    xlabel('X-coordinate (meters)');
    ylabel('Y-coordinate (meters)');
        
%     f2 = figure(2);
%     set(f2,'WindowStyle','docked');
    f2 = subplot(2,3,2);
    box on;
    hold on;
    plot(t,R,'*b');
    xlabel('Time');
    ylabel('LOS Distance (meters)');%('del_theta_rad');%
    
%     f3 = figure(3);
%     set(f3,'WindowStyle','docked');
    f3 = subplot(2,3,3);
    box on;
    hold on;
%     plot(t,(alphaM_rad-theta_rad),'+b');%alphaM_rad,
%     plot(t,(alphaM_rad),'+r');
    plot(t,(theta),'+g');
    xlabel('Time');
    ylabel('theta (degrees)');%('(alphaM_rad-theta_rad)');%
     
%     f4 = figure(4);
%     set(f4,'WindowStyle','docked');   
    f4 = subplot(2,3,4);
    box on;
    hold on;
    plot(t,a_m,'*r');
    xlabel('Time');
    ylabel('Lateral Acceleration (m/s^{2})');%del theta');%

%     f5 = figure(5);
%     set(f5,'WindowStyle','docked');  
    f5 = subplot(2,3,5);
    box on;
    hold on;
    plot(t,Vt*sin(alphaT_rad - theta_rad) - Vm*sin(delta_rad),'*r');
    plot(t,Vt*cos(alphaT_rad - theta_rad) - Vm*cos(delta_rad),'*b');
    xlabel('Time');
    ylabel(' V_{R}(blue) (m/s), V_{theta}(red) (m/s)');
    
%     f6 = figure(6);
%     set(f6,'WindowStyle','docked');  
    f6 = subplot(2,3,6);
    box on;
    hold on;
    plot(Vt*sin(alphaT_rad - theta_rad) - Vm*sin(delta_rad),Vt*cos(alphaT_rad - theta_rad) - Vm*cos(delta_rad),'k*');  
    xlabel('V_{theta} (m/s)');
    ylabel('V_R (m/s)');
    
    imgframe = imgframe+1;
    images1(imgframe) = getframe(figHandle);
    
end

filename = 'dp10CL0_9K10';
mkdir(['newData\' filename]);
for i = 1:imgframe-1
[im, map] = frame2im(images1(i));
name = ['newData\' filename '\' filename '_plot' num2str(i) '.jpg'];
imwrite(im,name,'jpg');
end

save(['newData\' filename '\' filename]);
movie2avi(images1,['newData\' filename '\' filename '.avi'],'fps',4);
movie2avi(images1,['newData\' filename '\' filename '_medium.avi'],'fps',5);
movie2avi(images1,['newData\' filename '\' filename '_small.avi'],'fps',6);
% movie2avi(images1,[filename '_ffds.avi'],'Compression','FFDS','fps',4);
