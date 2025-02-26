clear all
close all
movieObj = VideoReader('oneCCC.wmv'); % open file
images = read(movieObj);
get(movieObj) % display all information about movie
nFrames = movieObj.NumberOfFrames;
% Read every other frame from this movie.
%for iFrame=1:2:nFrames

vidObj = VideoWriter('mymovie .avi'); % create avi file
open(vidObj);

for i=1:nFrames
 I = images(:,:,:,i);
 %I = read(movieObj,iFrame); % get one RGB image
 fprintf('Frame %d\n', i);
 B = im2bw(I, graythresh(I)); % Threshold image
 s=strel('disk',1,0);
 B=~B;
 I2=imdilate(B,s);
 I3=imerode(I2,s);
 
 L = logical(I3); % Do connected component labeling
 blobs = regionprops(L); % Get region properties
 imshow(I,[]); % Display image
 for j=1:length(blobs)
 c = blobs(j).Centroid; % Get centroid of blob
 pixels_c = impixel(I3,c(1),c(2));
 pixels_c = pixels_c(1)+pixels_c(2)+pixels_c(3);
 pixels_1 = impixel(I3,blobs(j).BoundingBox(1)+blobs(j).BoundingBox(3)/4,...
                    blobs(j).BoundingBox(2)+blobs(j).BoundingBox(4)/4);
 pixels_1 = pixels_1(1)+pixels_1(2)+pixels_1(3);
 pixels_2 = impixel(I3,blobs(j).BoundingBox(1)+blobs(j).BoundingBox(3)/4,...
                    blobs(j).BoundingBox(2)+blobs(j).BoundingBox(4)*3/4);
 pixels_2 = pixels_2(1)+pixels_2(2)+pixels_2(3);
 w=blobs(j).BoundingBox(3);
 h=blobs(j).BoundingBox(4);
 if((pixels_c==0)&&(pixels_1)==3&&(pixels_2)==3&&(w<30)&&(h<30)&&(w>10)&&(h>10))
     
     rectangle('Position', blobs(j).BoundingBox, 'EdgeColor', 'r');
     % Draw crosshair at center of each blob

     line([c(1)-2 c(1)+2], [c(2) c(2)], 'Color', 'g');
     line([c(1) c(1)], [c(2)-2 c(2)+2], 'Color', 'g');
 end
    
 end
 %  imshow(I3,[]); % Display image
 %  Add next frame to movie

 newFrameOut = getframe;
 writeVideo(vidObj,newFrameOut);
 end
 
 
 % Pause a little so we can see the image. If no argument is given, it
 % waits until a key is pressed.
 %pause(0.01);

close(vidObj); % all done, close file