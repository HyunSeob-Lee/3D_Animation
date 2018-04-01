% <<< DIGITAL FILTER BY BUTTERWORTH 2 ORDER >>>
% FILENAME : DigitalFilter.m
% Version : 1.1
% Reference : Biomechanics of Human Movement.-by D.A. Winter
% �ۼ��� : �� �� ��        �ۼ��� : 1998�� 7�� 31��
% 2�� Lowpass digital Butterworth filter�μ� butter() �Լ��� �̿��Ͽ� filter 
% ����� ���Ͽ� filtering�� �Ѵ��� �׷����� ��½�Ų��.
% Dummy point�� �����ϴ� ��ƾ�� ������, �ʱ� �ΰ��� filter�� ����� ���� 
% 0���� �Ͽ���.


disp('�ۼ��� : ������');
disp('�ۼ��� : 1998�� 7�� 29��');
disp('Butterworth 2�� Digital Filter�μ� digital filter�� ����� ����Ͽ�');
disp('�׷����� �׷��ش�');

dataform = input('������ ���´�?  1 : 1��,   2 : 2��,   3 : 3�� --->');
yno = input('�м��ϰ��� �ϴ� ����ȣ�� �Է��Ͻÿ�! --->');
framemarker = input('���� frame���� marker ������ �Է��Ͻÿ� --->');
markerno = input('�м��� ���ϴ� marker ��ȣ�� �Է��Ͻÿ� --->');
dummy = input('���ϴ� dummy point ������ ��ΰ� ? --->');

[filename, pathname]=uigetfile('*.dat', 'Load File');
fid = fopen(filename, 'r+');
% ������ ���¿� ���� �м��� ������ �����ͷ� �����.
switch dataform
  case 1
    y = fscanf(fid, '%g', [1, inf]);
    fclose(fid);
  
    y=y'; %�����͸� �຤�ͷ� �����.
    true_y = y(markerno:framemarker:end); %���ϴ� ��Ŀ���� �����Ѵ�.
    true_ylength = length(true_y);

    %dummy point�� �����Ѵ�.
    dummytemp = true_y(2) - true_y(1);
    for n=1:dummy
      startdummy = true_y(1) - dummytemp;
      true_y = [startdummy; true_y]; %������ ���ʿ� dummy point�� �Է��Ѵ�.
    end

    total_ylength = length(true_y);
  case 2
    y = fscanf(fid, '%g', [2, inf]);
    fclose(fid);
      
    switch yno
      case 1
        y=y(1, :)'; %ù��° ���� ��� ���� �����ͷ� ��ȯ�Ѵ�.
        true_y = y(markerno:framemarker:end); %���ϴ� ��Ŀ���� �����Ѵ�.
        true_ylength = length(true_y);
      case 2
        y=y(2, :)'; %�ι�° ���� ��� ���� �����ͷ� ��ȯ�Ѵ�.
        true_y = y(markerno:framemarker:end); %���ϴ� ��Ŀ���� �����Ѵ�.
        true_ylength = length(true_y);
      otherwise
        error('������ �� ��ȣ�� ������ �����!');
    end    

    %dummy point�� �����Ѵ�.
    dummytemp = true_y(2) - true_y(1);
    for n=1:dummy
      startdummy = true_y(1) - dummytemp;
      true_y = [startdummy; true_y]; %������ ���ʿ� dummy point�� �Է��Ѵ�.
    end

    total_ylength = length(true_y);
  case 3
    y = fscanf(fid, '%g', [3, inf]);
    fclose(fid);

    switch yno
      case 1
        y=y(1, :)'; %ù��° ���� ��� ���� �����ͷ� ��ȯ�Ѵ�.
        true_y = y(markerno:framemarker:end); %���ϴ� ��Ŀ���� �����Ѵ�.
        true_ylength = length(true_y);
      case 2
        y=y(2, :)'; %�ι�° ���� ��� ���� �����ͷ� ��ȯ�Ѵ�.
        true_y = y(markerno:framemarker:end); %���ϴ� ��Ŀ���� �����Ѵ�.
        true_ylength = length(true_y);
      case 3
        y=y(3, :)'; %����° ���� ��� ���� �����ͷ� ��ȯ�Ѵ�.
        true_y = y(markerno:framemarker:end); %���ϴ� ��Ŀ���� �����Ѵ�.
        true_ylength = length(true_y);
      oterwise
        error('Error : ������ �� ��ȣ�� ������ �����!');      
    end    
    
    %dummy point�� �����Ѵ�.
    dummytemp = true_y(2) - true_y(1);
    for n=1:dummy
      startdummy = true_y(1) - dummytemp;
      true_y = [startdummy; true_y]; %������ ���ʿ� dummy point�� �Է��Ѵ�.
    end

    total_ylength = length(true_y);
  otherwise
    error('Error : ������ ��ȣ�� ������ ���!');
end

sample_freq = input('Sampling frequency�� �Է��Ͻÿ� --->');
cutoff_freq = input('Cut  off frequency�� �Է��Ͻÿ� --->');

sample_freq = sample_freq / 2; %sample frequency�� ���� ���Ѵ�.
sample_cutoff_ratio = (cutoff_freq) / sample_freq;

[a, b] = butter(2, sample_cutoff_ratio); %filter ����� ���Ѵ�.

a0 = a(1); a1 = a(2); a2 = a(3); b1 = b(2); b2 = b(3);

% Digital Filter�� �����Ѵ�.
filtervalue = [0 0];

for i=3:total_ylength
  tempvalue = (a0*true_y(i)) + (a1*true_y(i-1)) + (a2*true_y(i-2)) + ...
              ((-b1)*filtervalue(i-1)) + ((-b2)*filtervalue(i-2));
  filtervalue(i) = tempvalue;
end

% dummy point�� �����Ѵ�.
true_y = true_y(dummy+1:end); %���ʿ� �ִ� dummy point�� ������ ������ ������
                              %�� �Է��Ѵ�(���� ������).
filtervalue = filtervalue(dummy+1:end);%�� ���ΰ� �����ϴ�.

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

% �����͸� �����ϴ� ��ƾ.
saveyn=input('Filtered Data�� ����?   1 : ��,   2 : �ƴϿ� ----> :');
switch saveyn
case 1
   [FILENAME, PATHNAME]=uiputfile('*.dat','Save File');
    if FILENAME ~= 0
       fid=fopen(FILENAME,'w');
       filtervalue = filtervalue'; %�����͸� �����ͷ� ��ȯ�Ѵ�.
       fprintf(fid, '%8.4f \n', filtervalue);
       fclose(fid);
    else
       error('Error : ȭ�� ó���� ������ �߻���');       
    end
      %return;
case 2
   return;
otherwise
   error('Error : ��ȣ�� �߸� �����Ͽ���');
end  

