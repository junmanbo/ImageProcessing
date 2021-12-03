clc;
clear;

% 주파수 잡음에 왜곡된 영상 불러오기
mask_origin = imread('mask.jpeg', 'jpeg');
mask = imresize(mask_origin, [256 NaN]);
nomask_origin = imread('nomask.jpeg', 'jpeg');
nomask = imresize(nomask_origin, [256 NaN]);

% 마스크 사진 Display
figure(13);
subplot(2,2,1);
imshow(nomask), title('원영상');

mask_gray = rgb2gray(nomask); % 회색조로 변경 - test할 사진 입력

windowSize = 7;
kernel = ones(windowSize) / windowSize ^ 2;
conv_img = conv2(mask_gray, kernel, 'same');
subplot(2, 2, 2), imshow(conv_img, []), title('7x7 커널');

% Thresholding 적용
for i=1:256
    for j=1:256
        if(conv_img(i,j) >= 200) % 임계값
            conv_img(i,j) = 1;
        else
            conv_img(i,j) = 0;
        end
    end
end
subplot(2, 2, 3), imshow(conv_img, []), title('Thresholding 적용');

% 1이상인 pixel 개수 counting
counting = 0;
for i=1:256
    for j=1:256
        if(conv_img(i,j) >= 1)
            counting = counting + 1;
        end
    end
end

% 12000개 이상이면 mask 착용했다고 판단
if(counting >= 12000)
    fprintf('마스크를 착용했습니다!');
else
    fprintf('마스크를 착용하지 않았습니다.');
end