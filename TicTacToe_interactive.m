cam=webcamlist;
cam=webcam(1);
greenThresh = 0.1; % Threshold for green detection
redThresh=0.2;% Threshold for red detection
hblob = vision.BlobAnalysis('AreaOutputPort', false, 'CentroidOutputPort', true, 'BoundingBoxOutputPort', true', 'MinimumBlobArea', 500,'MaximumBlobArea', 4000,'MaximumCount', 1);
rgbFrame = snapshot(cam); 
vert=size(rgbFrame,1)*[.1 .35 .6 ]';
vert_locs=repmat(vert,[3 1]);
horiz=size(rgbFrame,2)*[.1 .35 .6 ]';
horiz_locs=repelem(horiz,3);
height=size(rgbFrame,1)*.25;
width=size(rgbFrame,2)*.25;
f=figure;
ax=axes(f);
img=image(ax,rgbFrame);
set(gcf,'units','normalized','outerposition',[.125 0 .70 1]);

is_x = 1; 
state = [[-1 -1 -1]
         [-1 -1 -1]
         [-1 -1 -1]]; 
winner = -1; % is there a winner? is it a tie?
count=0;
pinLocation=0;

% main game loop. Continue until the game ends with winner ~= -1
while winner == -1
    xlabelText='';
    rgbFrame = snapshot(cam); 
    rgbFrame = flipdim(rgbFrame,2); % obtain the mirror image for displaying
    rgbFrame=insertShape(rgbFrame,'rectangle',[horiz_locs vert_locs ones(9,2).*[width height]],'Color','blue','LineWidth',3);

    if(is_x==1)
        diffFrameGreen = imsubtract(rgbFrame(:,:,2), rgb2gray(rgbFrame)); % Get blue component of the image
        diffFrameGreen = medfilt2(diffFrameGreen, [3 3]); % Filter out the noise by using median filter
        binFrameGreen = im2bw(diffFrameGreen, greenThresh); % Convert the image into binary image with the blue objects as white
        [centroids, bbox] = step(hblob, binFrameGreen); % Get the centroids and bounding boxes of the blue blobs
    else
        diffFrameRed= imsubtract(rgbFrame(:,:,1), rgb2gray(rgbFrame)); % Get blue component of the image
        diffFrameRed = medfilt2(diffFrameRed, [3 3]); % Filter out the noise by using median filter
        binFrameRed = im2bw(diffFrameRed, redThresh); % Convert the image into binary image with the blue objects as white
        [centroids, bbox] = step(hblob, binFrameRed); % Get the centroids and bounding boxes of the blue blobs
    end

    if (~isempty(centroids))
        if (is_x==1)
            rgbFrame=insertShape(rgbFrame,'Filledcircle',[centroids 15],'LineWidth',3,'Color','green');
        else
            rgbFrame=insertShape(rgbFrame,'Filledcircle',[centroids 15],'LineWidth',3,'Color','red');
        end
        location=mod(floor((centroids./flip(size(rgbFrame,1:2))-.1)/.25+1),4);
        if(all(location>0))
            pinLocationNew=(location(2)-1)*3+location(1);
            if (state(location(2),location(1))~=-1)
                pinLocation=0;
                count=0;    
                xlabelText=': Use unused tile';
            elseif pinLocationNew==pinLocation
                count=count+1;
            else
                pinLocation=pinLocationNew;
                count=0;
            end
        else
            pinLocation=0;
            count=0;
        end
    else
        pinLocation=0;
        count=0;
    end

    if count==10
       state(location(2), location(1)) = is_x;
       pinLocation=0;
       count=0;
       is_x = mod(is_x + 1,2); % pick the next player and update the player label

    end

   [Xy,Xx]=find(state==1);
   for i=1:length(Xx)
       pos=repmat([.1+(Xx(i)-1)*.25+.25/2, .1+(Xy(i)-1)*.25+.25/2],[2 2])-.08;
       pos(1,3:4)=pos(1,3:4)+.16;
       pos(2,2)=pos(2,2)+.16;
       pos(2,3)=pos(2,3)+.16;          

       rgbFrame=insertShape(rgbFrame,'Line',[flip(size(rgbFrame,1:2)) flip(size(rgbFrame,1:2))].*pos,'Color','green','LineWidth',4);
   end
   [Oy,Ox]=find(state==0);
   for i=1:length(Ox)
       pos=[.1+(Ox(i)-1)*.25+.25/2, .1+(Oy(i)-1)*.25+.25/2 40];
       rgbFrame=insertShape(rgbFrame,'Circle',[flip(size(rgbFrame,1:2)) 1].*pos,'Color','red','LineWidth',4);
   end
   img.CData=rgbFrame;      

   if is_x == 1
       title(['Player: Green (X)' xlabelText],'FontSize',20);
       set(gcf,'color','g')
   else
       title(['Player: Red (O)' xlabelText],'FontSize',20);
       set(gcf,'color','r')
   end
   winner = won(state);hold on;       


end
if winner == 0 % O won
    warndlg('O wins');
    title('O wins','FontSize',20);
    xlabel('');
elseif winner == 1 % X won
    warndlg('X wins');
    title('X wins','FontSize',20);
    xlabel('');
else % else it's a tie
    warndlg('Tie');
    title('Tie','FontSize',20);
    xlabel('');
end


function won = won(state)
    % Horizontal
    if (state(1,1) == state(1,2) && state(1,1) == state(1,3) && state(1,1) ~= -1)
        won = state(1,1);
    elseif (state(2,1) == state(2,2) && state(2,1) == state(2,3) && state(2,1) ~= -1)
        won = state(2,1);
    elseif (state(3,1) == state(3,2) && state(3,1) == state(3,3) && state(3,1) ~= -1)
        won = state(3,1);
    % Vertical
    elseif (state(1,1) == state(2,1) && state(1,1) == state(3,1) && state(3,1) ~= -1) 
        won = state(1,1);
    elseif (state(1,2) == state(2,2) && state(1,2) == state(3,2) && state(1,2) ~= -1) 
        won = state(1,2);
    elseif (state(1,3) == state(2,3) && state(1,3) == state(3,3) && state(1,3) ~= -1) 
        won = state(1,3);
    % Diagonal
    elseif (state(1,1) == state(2,2) && state(1,1) == state(3,3) && state(1,1) ~= -1)
        won = state(1,1);
    elseif (state(1,3) == state(2,2) && state(1,3) == state(3,1) && state(2,2) ~= -1)
        won = state(1,3);
    % If no more slots are open, it's a tie
    elseif ~ismember(state, -1)
        won = 2;
    else
        won = -1;
    end
end
% Returns the rounded off position of the mouse
function [col row] = position(x, y)
    col = floor(x);
    row = floor(y);
    if col > 2 % if we're right on the 3 line, we count it as 2
        col = 2;
    end
    
    if row > 2
        row = 2;
    end
end
