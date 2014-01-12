clc;

%I = imread('org.png');     % I = first frame
I = imread('e1.png');
BW = im2bw(I, graythresh(I));           % Detecting edge of fire pixel( high intensity pixel ) and detected pixel denoted by white area
%imshow(BW)
%area(BW);
%disp(size(I));



[row, col] = find(BW==1); % this is the coordinate of selected fire area inside detected edge
edge_count=size(row,1);    %   total number of fire pixel inside detected edge 


% color detection method

Rt=180;  % predefined ( research paper )

count=0; % to count no. of fire pixel after applying color detection method inside detect edge area.
for i=1:size(row)      % size(row) = total no. of coordinate selected in edge detection method
R=I(row(i),col(i),1);
G=I(row(i),col(i),2);
B=I(row(i),col(i),3);
if R > Rt & R > G & G > B
count=count+1;
end
end
count1=count;   % no. of fire pixel which declared as fire pixel after color detection method
                % count1 is to preserve count value for motion detection method

    
                
                
%ratio=(count1/edge_count)*100
%if ratio > 50
%alert = 'fire detected by applying color detection.....';
%else
%alert= 'no fire detected by applying color detection';
%end
%disp(alert);      




% this is to store colored pixel into matrix [rf cf]

j=1;
rf=zeros(count,1);
cf=zeros(count,1);
for i=1:size(row)
R=I(row(i),col(i),1);
G=I(row(i),col(i),2);
B=I(row(i),col(i),3);
if R > Rt & R > G & G > B
rf(j)=row(i);
cf(j)=col(i);
r1(j)=R;      % storing R into r1, G into g1, B into b1 so that we can use these RGB into motion detection method to compare with next frame
g1(j)=G;
b1(j)=B;
j=j+1;
end
end
rcf=[rf cf];


   
%hand = plot(rf, cf, 'r.');
%set(hand, '5000', 3000);




%  decision matrix

dm=[0 0 0];    %  dm=[result of motion detection method, result of gray cycle nethod, result of area detection method];






% to detect graycycle

alpha=20;     %  experimental value

% ymin,ymax,xmin,xmax    

ymin=min(rf);
ymin1=ymin;

ymax=max(rf);
ymax1=ymax;

xmin=min(cf);
xmin1=xmin;

xmax=max(cf);
xmax1=xmax;

ymid=floor((ymax-ymin)/2);

im_size=size(I);
im_xmax=im_size(1);
im_ymax=im_size(2);

if (xmin-alpha) <1
    xmin=alpha+1;
end

if (ymin-ymid) < 1
    upper_y=1;
end

if (xmax+alpha) > im_xmax
    xmax=im_xmax-alpha; 
end

% p,q,r,s= coordinate of rectangular area to find graycycle pixel 

p=[(xmin-alpha),ymin+ymid];
q=[(xmax+alpha),ymin+ymid];
r=[(xmax+alpha),upper_y];
s=[(xmin-alpha),upper_y];

%a1=[p(1) q(1) r(1) s(1)];
%b1=[p(2) q(2) r(2) s(2)];
%area(a1,b1);


 
% make data to plot - just a line.

%plot(rf,cf,'b-*','linewidth',1.5);





gray_count=0;   % variable to count no. of detected gray pixel
rgb_diff=15;     % 15 experimental value try to find mathematical relation to find rgb_diff and 110 and 220
for i=s(2):(p(2)-1)
for j=p(1):(q(1)-1)
R=I(j,i,1);
G=I(j,i,2);
B=I(j,i,3);

if abs(R-G) <rgb_diff & abs(G-B) <rgb_diff || abs(G-B) <rgb_diff & abs(B-R) <rgb_diff || abs(B-R) <rgb_diff & abs(R-G) <rgb_diff
if R > 110 & R < 220 & G > 110 & G < 220 & B > 110 & B < 220
gray_count=gray_count+1;
end
end
end
end


total_gray_p=(p(2)-s(2))*(q(1)-p(1));  % total number of pixel into rectangular area
gray_ratio=(gray_count/total_gray_p)*100;
if gray_ratio>14.23
dm(2)=1;
end



% to detect motion of fire

I1=imread('e2.png');   %  I1 = next frame

motion_count=0;
for i=1:count
r=I1(rf(i),cf(i),1);
g=I1(rf(i),cf(i),2);
b=I1(rf(i),cf(i),3);
if r==r1(i) & g==g1(i) & b==b1(i)
motion_count=motion_count+1;
end
r1(i)=r;
g1(i)=g;
b1(i)=b;
end

motion_p_ratio=(count-motion_count)*100/count;


if motion_p_ratio>80    % 80 is experimental value 
dm(1)=1;
end




% to detect area of fire

I=I1;
BW = im2bw(I, graythresh(I));

[row, col] = find(BW==1); 
edge_count=size(row,1);   

Rt=180;  

count=0; 
for i=1:size(row)     
R=I(row(i),col(i),1);
G=I(row(i),col(i),2);
B=I(row(i),col(i),3);
if R > Rt & R > G & G > B
count=count+1;
end
end
  
                

j=1;
rf1=zeros(count,1);
cf1=zeros(count,1);
for i=1:size(row)
R=I(row(i),col(i),1);
G=I(row(i),col(i),2);
B=I(row(i),col(i),3);
if R > Rt & R > G & G > B
rf1(j)=row(i);
cf1(j)=col(i);
r1(j)=R;     
g1(j)=G;
b1(j)=B;
j=j+1;
end

end
rcf=[rf1 cf1];

%area(rf1,cf1);

ymin2=min(rf1);

ymax2=max(rf1);

xmin2=min(cf1);

xmax2=max(cf1);


if count-count1>200
disp('area spread');
	dm(3)=1;
end


Motion_Detection=dm(1)
Gray_cycle_Detection=dm(2)
Area_spread_Detection=dm(3)

system_output=0;
if dm(1) & dm(3) | dm(2)
    system_output=1;
end

system_output




