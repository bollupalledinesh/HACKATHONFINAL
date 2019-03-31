clc
clear all

%Types of alert signal
% alert=input('Enter number of alerts');

ip=fopen('inputdata.m','r++');
noa=fscanf(ip,'%d',1)
acx=fscanf(ip,'%d',[noa,1]);
acx=acx'

acy=fscanf(ip,'%d',[noa,1]);
acy=acy'
traffic=fscanf(ip,'%d',[17,6]);
traffic=traffic'
tic
%noa=4;
% acx=[50 35 70 10 ];
% acy=[40 65 80 30 ];
% acx=[50 35 70 10];
% acy=[40 65 80 30];
selected_hospital=zeros(1,noa);
for noaiter=1:noa
    alert=1;

if (alert==1) 
% case1  

% Traffic Matrix
% traffic=[85 20 17 70 68 34 90 79 8 19 39 54 90 23 90 32 59;
%     84 61 23 32 76 94 12 80 9 68 37 57 48 15 11 30 20;
%     45 59  91 43 67 93  11 70 7 21 45 55 60 13 92 28 51;
%     82 59 22 43 65 91 21 78 90  25 38 53 47 19 92 26 60;
%     81 58 24 45 65 91 15  79 15 29 5 54 59 13 89 25 62;
%     34 21 16 56 3 81 85 92 42 49 56 63 70 9 54 76 87];

s=size(traffic);
row=s(1);
count=zeros(1,row);

for iter=1:row
    
    % Choosing one particular traffic
    y=traffic(iter,:);
    
    % location of Accident
    accx=acx(noaiter);
    accy=acy(noaiter);
    %Plotting the Accident location
    subplot(3,2,noaiter),plot(accx,accy,'k--o',...
        'MarkerSize',10,...
        'MarkerFaceColor','r',...
        'LineWidth',1.5)
    
    hold on
    %n=number of hospitals
    n=17;
    
    locx=[25 83 12 16 53 34 46 41 67 76 34 78 54 50 30 40 22];
    locy=[32 75 45 58 67 27 78 32 89 92 23 90 76 20 89 10 81];
    subplot(3,2,noaiter),plot(locx,locy,'bs')
    
    
    for i=1:n
        
        distance(i)=sqrt((accx-locx(i))^2+(accy-locy(i))^2);
        if y(i)<=25
            line([locx(i),accx],[locy(i),accy],'color','b')
            
        end
        if (y(i)<75 && y(i)>25)
            line([locx(i),accx],[locy(i),accy],'color','y')
            
        end
        if y(i)>75
            line([locx(i),accx],[locy(i),accy],'color','r')
            
        end
        
        
    end
    
    
    threshold_distance=(max(distance)+min(distance))*0.5;
    a=distance;
    x=length(a);
    %Creating Cirle
    th=0:pi/100:2*pi;
    k=threshold_distance*cos(th)+accx;
    l=threshold_distance*sin(th)+accy;
    subplot(3,2,noaiter),plot(k,l);
    b=zeros(n,1);
    for i=1:n
        if a(i)<threshold_distance
            
            b(i)=a(i);
        end
    end
    
    
    [b,in]=sort(b,'descend');
    
    countt=0;
    for i=1:n
        if b(i)~=0
            countt=countt+1;
        end
    end
    countt;
    count_red=0;
    count_orange=0;
    count_blue=0;
    blue=[];
    orange=[];
    red=[];
    
    for i=1:countt
        
        k=in(i);
        if(y(k)>75&&y(k)<100)
            
            red(i)=b(i);
            if (red(i)>0)
                count_red=count_red+1;
            end
        else if(y(k)>25&&y(k)<75)
                orange(i)=b(i);
                if (orange(i)>0)
                    count_orange=count_orange+1;
                end
                
            else
                blue(i)=b(i);
                if (blue(i)>0)
                    count_blue=count_blue+1;
                end
                
            end
        end
    end
    red;
    orange;
    blue;
    count_red;
    count_orange;
    count_blue;
    
    for i=1:1
        if (count_blue==0)
            if (count_orange==0)
                red=sort(red,'descend');
                final_dis=red(count_red);
                break;
            else if(count_orange==1)
                    red=sort(red,'descend');
                    red_dis=red(count_red);
                    orange_dis=max(orange);
                    final_dis=min(orange_dis,red_dis);
                    break;
                else
                    orange=sort(orange,'descend');
                    final_dis=orange(count_orange);
                    break;
                end
            end
            
        else if (count_blue==1)
                blue_dis=max(blue);
                if (count_orange==0)
                    final_dis=blue_dis;
                    break;
                else if (count_orange==1)
                        orange_dis=max(orange);
                        final_dis=min(blue_dis,orange_dis);
                        break;
                    else
                        orange=sort(orange,'descend');
                        orange_dis=orange(count_orange);
                        final_dis=min(blue_dis,orange_dis);
                        break;
                    end
                end
                
                
            else
                blue=sort(blue,'descend');
                blue_dis=blue(count_blue);
                if (count_orange==0)
                    final_dis=blue_dis;
                    break;
                else if (count_orange==1)
                        orange_dis=max(orange);
                        final_dis=min(blue_dis,orange_dis);
                        break;
                    else
                        orange=sort(orange,'descend');
                        orange_dis=orange(count_orange);
                        final_dis=min(blue_dis,orange_dis);
                        break;
                    end
                end
            end
        end
    end
    for p=1:x
        if (final_dis==a(p))
            fprintf('the hospital to be selected in traffic %d is %d',iter,p);
            fprintf('\n');
            count(iter)=p;
        end
    end
pause(1);
end
count;
m=mode(count);
selected_hospital(noaiter)=m;
t=selected_hospital(noaiter);
fprintf(' Final hospital to be selected is = %d',m);
k=locx(m);
l=locy(m);
fprintf('Final coordinate of the  selected hospital is x= %d ,y= %d',k,l);
subplot(3,2,noaiter),plot(k,l,'bs',...
    'MarkerSize',10,...
    'MarkerFacecolor','r',...
    'LineWidth',1.5)
grid on


end
end
noacount=0;
t=4;
selected_hospital=[4 4 4 4];
for i=1:noa
    if (t==selected_hospital(i))
    noacount=noacount+1;
    end
end

if (noacount==noa)
% Case 2
% ACO Started  

% number of  Multiple causuality
hosx=25;
hosy=45;
%  plot(hosx,hosy,'ko',...
%         'MarkerSize',20,...
%         'MarkerFaceColor','y',...
%          'LineWidth',1.5)
   
 x=[4 12 22 31 60 40 hosx]
 y=[56 25 43 78 33 63 hosy]

  subplot(3,2,5),plot(x,y,'ko',...
        'MarkerSize',10,...
        'MarkerFaceColor','y',...
        'LineWidth',1.5)
 
 
s=size(x);
row=s(2);
n=row;
dis=zeros(n,n);
    
    for i=1:n-1
        for j=i+1:n
            
            dis(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            
            dis(j,i)=dis(i,j);
            
        end
    end
    dis;
%  dis=[0 50 15 40 7 18;
%      50 0 4 8 12 6;
%      15 4 0 1 6 7;
%      40 8 10 0 3 9;
%      7 12 6 3 0 2;
%      18 6 7 9 2 0];
%  

for i=1:n
    for j=1:n
        tauo(i,j)=1;
    end 
end
%tauo=[1 1 1 1 1 1;1 1 1 1 1 1;1 1 1 1 1 1;1 1 1 1 1 1;1 1 1 1 1 1;1 1 1 1 1 1];
n_ant=15;
itermax=50;
%n=6;% no of cities
alpha=1;
beta=2;
rho=0.05;
Q=1;
eta=zeros(n,n);
for i=1:n
    for j=1:n
        if i~=j
            eta(i,j)=1/dis(i,j);
        end
    end
end
 eta;
%eta=[0 0.4 0.2 0.7;0.1 0 0.12 0.4;0.2 0.13 0 0.5;0.3 0.2 0.14 0]
temp_eta=eta;
%tauo=[1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1]
eta; % eta is visibility of cities
 %d=round((n-1)*rand+1)
for iter=1:itermax
 ant_route=zeros(n_ant,n);
     for k=1:n_ant
         %randomly choose a no between 1 to n
           d=round((n-1)*rand+1);
           % d=3;
         city=zeros(1,n);
       
         route=zeros(1,n);
         for i=1:n % loop for city visiting
             
         route(i)= d ; 
          
             city(d)=d;
         eta(:,d)=0;
          sum=0;
          temp=0;
         for j=1:n
             
             if city(j)==0
                 num(j)=(tauo(d,j)^alpha)*(eta(d,j)^beta);
                 temp=num(j);
             
              sum=sum+temp;
             end
         end
            sum;
         for j=1:n
             
                 if city(j)==0
             
             
                 P(j)=num(j)/sum;
             end
         end
         
         % Roulett wheel selection
         
         [P,in]=sort(P,'descend');
         in;
         P;
         P=zeros(1,n);
         d=in(1);
         end
         eta=temp_eta;
       ant_route(k,:)=route;
        one_ant_dis=0;
        for m=1:n
            %if route(m+1)~=(n+1)
            if m+1>n
                
                route(m+1)=route(1);
            end
                one_ant_dis=one_ant_dis+dis(route(m),route(m+1));
        end
       ant_dis(k)=one_ant_dis;
     end
    ant_route;
     ant_dis;
     
     
     [ant_dis,in]=sort(ant_dis,'ascend');
     best_dis=min(ant_dis);
     %fprintf(' minimum distance in Iteration %d is = %f','iter','best_dis')
     %fprintf('\n');
      %disp(['Iteration ' iter ', Minimum distance = ' best_dis]);
    
    
     % best route
     
     ant_route(in(1),:);
    
         best_ant_route= ant_route(in(1),:);
    
     
         deltau=zeros(n,n);
         for k=1:n_ant
         for m=1:n
           %  for q=1:n
           if m+1>n
               ant_route(k,m+1)=ant_route(k,1);
           end
             deltau(ant_route(k,m),ant_route(k,m+1))=deltau(ant_route(k,m),ant_route(k,m+1))+(Q/ant_dis(k));
         
         end
         end
         deltau;
         
         tauo=((1-rho)*tauo)+deltau;
         
         best_ant_route;
         
         for i=1:n
             p(i)=x(best_ant_route(i));
             q(i)=y(best_ant_route(i));
         end
         p(n+1)=x(best_ant_route(1));
         q(n+1)=y(best_ant_route(1));
         p;
         q;
          subplot(3,2,5),plot(p,q,'-bs',...
        'MarkerSize',10,...
        'MarkerFaceColor','r',...
        'LineWidth',1.5)
         grid on
         pause(0.1);
         
           
end  
hold on
         ant_route;
         ant_dis;
          %fprintf(' hospital is x= %d ,y= %d',hosx,hosy);
          
          
%          k=p(n);
%          l=q(n);
% plot(k,l,'bo',...
%     'MarkerSize',10,...
%     'MarkerFacecolor','b',...
%     'LineWidth',1.5)
   
         fprintf(' hospital is x= %d ,y= %d',hosx,hosy);
         k=hosx
         l=hosy
 subplot(3,2,5),plot(k,l,'bo',...
    'MarkerSize',10,...
    'MarkerFacecolor','y',...
    'LineWidth',1.5)
          best_ant_route  
end  
% subplot(2,1,noaiter),plot
% end        
toc





