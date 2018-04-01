% <<< DIGITAL FILTER BY BUTTERWORTH 2 ORDER >>>
% FILENAME : DigitalFilter.m
% Version : 1.1
% Reference : Biomechanics of Human Movement.-by D.A. Winter
% 작성자 : 이 현 섭        작성일 : 1998년 7월 31일
% 2차 Lowpass digital Butterworth filter로서 butter() 함수를 이용하여 filter 
% 계수를 구하여 filtering을 한다음 그래프를 출력시킨다.
% Dummy point을 삽입하는 루틴이 있으며, 초기 두개의 filter를 통과한 값을 
% 0으로 하였다.


disp('작성자 : 이현섭');
disp('작성일 : 1998년 7월 29일');
disp('Butterworth 2차 Digital Filter로서 digital filter의 계수를 계산하여');
disp('그래프를 그려준다');

dataform = input('데이터 형태는?  1 : 1열,   2 : 2열,   3 : 3열 --->');
yno = input('분석하고자 하는 열번호를 입력하시요! --->');
framemarker = input('단일 frame내의 marker 개수를 입력하시요 --->');
markerno = input('분석을 원하는 marker 번호를 입력하시요 --->');
dummy = input('원하는 dummy point 개수는 몇개인가 ? --->');

[filename, pathname]=uigetfile('*.dat', 'Load File');
fid = fopen(filename, 'r+');
% 데이터 형태에 따라 분석이 가능한 데이터로 만든다.
switch dataform
  case 1
    y = fscanf(fid, '%g', [1, inf]);
    fclose(fid);
  
    y=y'; %열벡터를 행벡터로 만든다.
    true_y = y(markerno:framemarker:end); %원하는 마커만을 추출한다.
    true_ylength = length(true_y);

    %dummy point를 생성한다.
    dummytemp = true_y(2) - true_y(1);
    for n=1:dummy
      startdummy = true_y(1) - dummytemp;
      true_y = [startdummy; true_y]; %데이터 앞쪽에 dummy point를 입력한다.
    end

    total_ylength = length(true_y);
  case 2
    y = fscanf(fid, '%g', [2, inf]);
    fclose(fid);
      
    switch yno
      case 1
        y=y(1, :)'; %첫번째 행의 모든 열을 열벡터로 변환한다.
        true_y = y(markerno:framemarker:end); %원하는 마커만을 추출한다.
        true_ylength = length(true_y);
      case 2
        y=y(2, :)'; %두번째 행의 모든 열을 열벡터로 변환한다.
        true_y = y(markerno:framemarker:end); %원하는 마커만을 추출한다.
        true_ylength = length(true_y);
      otherwise
        error('선택한 열 번호가 범위를 벗어났음!');
    end    

    %dummy point를 생성한다.
    dummytemp = true_y(2) - true_y(1);
    for n=1:dummy
      startdummy = true_y(1) - dummytemp;
      true_y = [startdummy; true_y]; %데이터 앞쪽에 dummy point를 입력한다.
    end

    total_ylength = length(true_y);
  case 3
    y = fscanf(fid, '%g', [3, inf]);
    fclose(fid);

    switch yno
      case 1
        y=y(1, :)'; %첫번째 행의 모든 열을 열벡터로 변환한다.
        true_y = y(markerno:framemarker:end); %원하는 마커만을 추출한다.
        true_ylength = length(true_y);
      case 2
        y=y(2, :)'; %두번째 행의 모든 열을 열벡터로 변환한다.
        true_y = y(markerno:framemarker:end); %원하는 마커만을 추출한다.
        true_ylength = length(true_y);
      case 3
        y=y(3, :)'; %세번째 행의 모든 열을 열벡터로 변환한다.
        true_y = y(markerno:framemarker:end); %원하는 마커만을 추출한다.
        true_ylength = length(true_y);
      oterwise
        error('Error : 선택한 열 번호가 범위를 벗어났음!');      
    end    
    
    %dummy point를 생성한다.
    dummytemp = true_y(2) - true_y(1);
    for n=1:dummy
      startdummy = true_y(1) - dummytemp;
      true_y = [startdummy; true_y]; %데이터 앞쪽에 dummy point를 입력한다.
    end

    total_ylength = length(true_y);
  otherwise
    error('Error : 선택한 번호가 범위를 벗어남!');
end

sample_freq = input('Sampling frequency를 입력하시요 --->');
cutoff_freq = input('Cut  off frequency를 입력하시요 --->');

sample_freq = sample_freq / 2; %sample frequency의 반을 취한다.
sample_cutoff_ratio = (cutoff_freq) / sample_freq;

[a, b] = butter(2, sample_cutoff_ratio); %filter 계수를 구한다.

a0 = a(1); a1 = a(2); a2 = a(3); b1 = b(2); b2 = b(3);

% Digital Filter를 수행한다.
filtervalue = [0 0];

for i=3:total_ylength
  tempvalue = (a0*true_y(i)) + (a1*true_y(i-1)) + (a2*true_y(i-2)) + ...
              ((-b1)*filtervalue(i-1)) + ((-b2)*filtervalue(i-2));
  filtervalue(i) = tempvalue;
end

% dummy point를 제거한다.
true_y = true_y(dummy+1:end); %앞쪽에 있는 dummy point를 제외한 나머지 데이터
                              %를 입력한다(실제 데이터).
filtervalue = filtervalue(dummy+1:end);%윗 라인과 동일하다.

x_axis = length(true_y);
xx_axis = length(filtervalue);

x_axis = 1:1:x_axis;
xx_axis = 1:1:xx_axis;

plot(x_axis, true_y, 'r-', xx_axis, filtervalue, 'b-');
ratio = (sample_freq*2) / cutoff_freq;
ratio = num2str(ratio);
xlabel(' X : 1 2 3 .... ');
ylabel('Filtered Value');
title(ratio);
zoom on;

% 데이터를 저장하는 루틴.
saveyn=input('Filtered Data를 저장?   1 : 예,   2 : 아니오 ----> :');
switch saveyn
case 1
   [FILENAME, PATHNAME]=uiputfile('*.dat','Save File');
    if FILENAME ~= 0
       fid=fopen(FILENAME,'w');
       filtervalue = filtervalue'; %데이터를 열벡터로 변환한다.
       fprintf(fid, '%8.4f \n', filtervalue);
       fclose(fid);
    else
       error('Error : 화일 처리에 에러가 발생함');       
    end
      %return;
case 2
   return;
otherwise
   error('Error : 번호를 잘못 선택하였음');
end  

