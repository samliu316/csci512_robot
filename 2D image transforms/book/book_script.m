clear all
close all
IA = imread('book_A.jpg');
IB = imread('book_B.jpg');
figure, imshow(IA,[]);
figure, imshow(IB,[]);
% Using imtool, we find corresponding
% points (x;y), which are the four
% corners of the book
pA = [213   398 401 223;
      29    20  293 297;
      1     1   1   1];
pB = [207   391 339 164;
      7     34  302 270];
N = size(pA,2);
theta = 0;
tx = 0;
ty = 0;
x = [theta; tx; ty]; % initial guess

while true
    disp('Parameters (theta; tx; ty):'), disp(x);

    y = fRigid(x, pA); % Call function to compute expected measurements
    dy = reshape(pB,[],1) - y; % new residual
    J = zeros(2*N,3);
    % Fill in values of J 

    % Estimate J numerically
    e = 1e-6; % A tiny number
    J(:,1) = (fRigid(x+[e;0;0],pA) - y)/e;
    J(:,2) = (fRigid(x+[0;e;0],pA) - y)/e;
    J(:,3) = (fRigid(x+[0;0;e],pA) - y)/e;
    dx = pinv(J)*dy;

    % Stop if parameters are no longer changing
    if abs( norm(dx)/norm(x) ) < 1e-6
        break;
    end
    x = x + dx; % add correction
end

% Apply transform to image
theta = x(1);
tx = x(2);
ty = x(3);
A = [cos(theta) -sin(theta) tx;
     sin(theta) cos(theta)  ty;
     0          0           1];
T = maketform('affine', A');
I2 = imtransform(IA,T, ...
 'XData', [1 size(IA,2)], ...
 'YData', [1 size(IA,1)] );
figure, imshow(I2,[]);