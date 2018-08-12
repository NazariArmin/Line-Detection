 clc; clear; close all; warning off; 

O=imread('/home/armin/Desktop/i.jpg');
Osize = size(O);
I = rgb2gray(O);
% I = zeros(500,500);
% 
% I(100:300,100:300) = 1;


I = im2double(I);
Isize=size(I);
%detect edge with sobel mask
for i=2:Isize(1)-1
    for j=2:Isize(2)-1
        Dx(i,j)=([I(i+1,j-1)-I(i-1,j-1)]+2*[I(i+1,j)-I(i-1,j)]+[I(i+1,j+1)-I(i-1,j+1)]) / 4;
        Dy(i,j)=([I(i-1,j+1)-I(i-1,j-1)]+2*[I(i,j+1)-I(i,j-1)]+[I(i+1,j+1)-I(i+1,j-1)]) / 4;
        S(i,j) = sqrt(Dx(i,j)^2 + Dy(i,j)^2);
    end
end
S = im2bw(S, 0.2);
Ssize=size(S);

%the histogram hough transform
HIS = zeros(round(2*(sqrt(Ssize(2)^2 + Ssize(1)^2))),1800);
for x = 1:Ssize(1) - 1
    for y = 1:Ssize(2) - 1
        if(S(x,y) == 1)
            for T = -899:900
                R = x *  sind(T/10) + y * cosd(T/10);
                R = R + round((sqrt(Ssize(2)^2 + Ssize(1)^2)));
                T = T + 900;
                HIS(round(R),T) = HIS(round(R),T) + 1;
            end
        end
    end
end

%teta for maximum pick
TM = 0;
%R for maximum pick
RM = 0;
figure();
imshow(O);    
hold on;

%find five pick
for num = 1 : 5
    HPick = HIS(1,1);
    %find R and T for maximum pick
    for R2 = 1 : 2*(sqrt(Ssize(2)^2 + Ssize(1)^2) -1)
        for T2 = 1 : 1800
            if HPick < HIS(R2,T2)
               HPick = HIS(R2,T2);
                RM = R2;
                TM = T2;
            end
        end
    end
   
    %convert R and T to X and Y
    RM =  RM - round((sqrt(Ssize(2)^2 + Ssize(1)^2)));
    TM = TM - 900;
    if TM == 1800
        TM = 1790;
    end
    x = [1,Osize(1)];
    y = [(RM - x(1) * sind(TM/10)) / cosd(TM/10) , (RM - x(2) * sind(TM/10)) / cosd(TM/10)]; 

    %drop the line on picture
    plot([y(1),y(2)],[x(1),x(2)],'Color','r','LineWidth',3)

    
    RM =  RM + round((sqrt(Ssize(2)^2 + Ssize(1)^2)));
    TM = TM + 900;
    
    %delete the neighbor of maximum pick
    for i = 0 : 100
        for j = 0 : 100
            if TM - j > 0  
            HIS(RM + i,TM - j) = 0;
            HIS(RM - i,TM - j) = 0;
            end
            if TM + j < 1800
            HIS(RM - i,TM + j) = 0;
            HIS(RM + i,TM + j) = 0;
            
            end
        end
    end
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    