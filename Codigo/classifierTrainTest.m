function [resTrain,resTest] = classifierTrainTest(which, inputTrain, inputTest, path)

%path = ' -cp "C:\Program Files\Weka-3-8-4\*" ';

%
% Inputs:
%
% which - Number to select one of the following kinds of
% classifiers:
%
%       1 - C4.5
%       2 - Naive Bayes
%       3 - IB1
%       4 - SVM
%
% input - Input dataset
%
% Outputs:
%
%  resTrain - results for train dataset
%  resTest - results for test dataset
%
%  1) Correctly classified Instances - number
%  2) Correctly classified Instances - percentage
%  3) Incorrectly classified Instances - number
%  4) Incorrectly classified Instances - percentage
%  5) Kappa statistic
%  6) Mean absolute error
%  7) Root mean squared error
%  8) Relative absolute error
%  9) Root relative squared error
%  10) Total number of instances
%  11) Weighted Avg. TP Rate
%  12) Weighted Avg. FP Rate
%  13) Weighted Avg. Precision
%  14) Weighted Avg. Recall
%  15) Weighted Avg. F-Measure
%  16) Weighted Avg. MCC
%  17) Weighted Avg. ROC Area
%  18) Weighted Avg. PRC Area

% Log file
% Weka 3-6
%     switch(which)
%         case 'C4.5'
%             s = evalc(['!java ', path, ' -Xmx4g weka.classifiers.trees.J48 -i -C 0.50 -M 2 -t ', inputTrain, ' -T ', inputTest, ' -d j48.model']);            
%         case 'Naive-Bayes'
%             s = evalc(['!java ', path, ' -Xmx4g weka.classifiers.bayes.NaiveBayes -i -t ', inputTrain, ' -T ', inputTest, ' -d nb.model']);             
%         case 'IB1'
%             s = evalc(['!java ', path, ' -Xmx4g weka.classifiers.lazy.IB1 -i -t ', inputTrain, ' -T ', inputTest, ' -d ib1.model']);
%         case 'SVM'
%             s = evalc(['!java ', path, ' -Xmx4g weka.classifiers.functions.SMO -i -t ', inputTrain, ' -T ', inputTest, ' -d smo.model']);
%         otherwise
%            error('classifier:incorrectClassifier', 'Incorrect classifier'); 
%     end
% 
    %Weka 3-8
      switch(which)
        case 'C4.5'
            s = evalc(['!java ', path, ' -Xmx4g weka.classifiers.trees.J48 -C 0.50 -M 2 -t ', inputTrain, ' -T ', inputTest, ' -d j48.model']);
        case 'Naive-Bayes'
            s = evalc(['!java ', path, ' -Xmx4g weka.classifiers.bayes.NaiveBayes -t ', inputTrain, ' -T ', inputTest, ' -d nb.model']); %
        case 'IB1'
            s = evalc(['!java ', path, ' -Xmx4g weka.classifiers.lazy.IBk -K 1 -t ', inputTrain, ' -T ', inputTest, ' -d ib1.model']);
        case 'SVM'
            s = evalc(['!java ', path, ' -Xmx4g weka.classifiers.functions.SMO -t ', inputTrain, ' -T ', inputTest, ' -d smo.model']);
        otherwise
           error('classifier:incorrectClassifier', 'Incorrect classifier'); 
      end

% Mostrar para comprobar que son correctos
% inputTrain
% inputTest
% s

%s='Options: -K 1 === Classifier model (full training set) ===IB1 instance-based classifierusing 1 nearest neighbour(s) for classificationTime taken to build model: 0.28 secondsTime taken to test model on training data: 0.06 seconds=== Error on training data ===Correctly Classified Instances         349              100      %Incorrectly Classified Instances         0                0      %Kappa statistic                          1     Mean absolute error                      0.0042Root mean squared error                  0.0049Relative absolute error                  1.1872 %Root relative squared error              1.1602 %Total Number of Instances              349     === Detailed Accuracy By Class ===                 TP Rate  FP Rate  Precision  Recall   F-Measure  MCC      ROC Area  PRC Area  Class                 1,000    0,000    1,000      1,000    1,000      1,000    1,000     1,000     class1                 1,000    0,000    1,000      1,000    1,000      1,000    1,000     1,000     class2                 1,000    0,000    1,000      1,000    1,000      1,000    1,000     1,000     class3                 1,000    0,000    1,000      1,000    1,000      1,000    1,000     1,000     class4Weighted Avg.    1,000    0,000    1,000      1,000    1,000      1,000    1,000     1,000     === Confusion Matrix ===   a   b   c   d   <-- classified as 110   0   0   0 |   a = class1   0  58   0   0 |   b = class2   0   0 128   0 |   c = class3   0   0   0  53 |   d = class4Time taken to test model on test data: 0.02 seconds=== Error on test data ===Correctly Classified Instances         137               78.7356 %Incorrectly Classified Instances        37               21.2644 %Kappa statistic                          0.702 Mean absolute error                      0.1094Root mean squared error                  0.3243Relative absolute error                 30.487  %Root relative squared error             76.4975 %Total Number of Instances              174     === Detailed Accuracy By Class ===                 TP Rate  FP Rate  Precision  Recall   F-Measure  MCC      ROC Area  PRC Area  Class                 0,755    0,120    0,712      0,755    0,733      0,624    0,818     0,606     class1                 0,750    0,041    0,778      0,750    0,764      0,719    0,854     0,624     class2                 0,851    0,103    0,838      0,851    0,844      0,746    0,874     0,771     class3                 0,733    0,035    0,815      0,733    0,772      0,729    0,849     0,644     class4Weighted Avg.    0,787    0,086    0,789      0,787    0,787      0,704    0,851     0,679     === Confusion Matrix ===  a  b  c  d   <-- classified as 37  2  5  5 |  a = class1  1 21  6  0 |  b = class2  6  4 57  0 |  c = class3  8  0  0 22 |  d = class4 ';


if ~isempty(strfind(s,'Weka exception'))
    % error('classifier:wekaProblem', 'Weka exception in classifier');
    resTest = 0;
    resTrain = 0;    
else
    %  1) Correctly classified Instances - number
    t=strfind(s,'Correctly Classified Instances');
    resTrain(1)=str2num(s(t(1)+39:t(1)+46)); 
    resTest(1)=str2num(s(t(2)+39:t(2)+46)); 
    %  2) Correctly classified Instances - percentage 
    resTrain(2)=str2double(s(t(1)+56:t(1)+64)); 
    resTest(2)=str2double(s(t(2)+56:t(2)+64)); 
    %  3) Incorrectly classified Instances - number
    t=strfind(s,'Incorrectly Classified Instances');
    resTrain(3)=str2num(s(t(1)+39:t(1)+46)); 
    resTest(3)=str2num(s(t(2)+39:t(2)+46));     
    %  4) Incorrectly classified Instances - percentage
    resTrain(4)=str2double(s(t(1)+57:t(1)+63)); 
    resTest(4)=str2double(s(t(2)+54:t(2)+64)); 
    %  5) Kappa statistic
    t=strfind(s,'Kappa statistic');
    resTrain(5)=str2double(s(t(1)+39:t(1)+46)); 
    resTest(5)=str2double(s(t(2)+39:t(2)+46));     
    %  6) Mean absolute error
    t=strfind(s,'Mean absolute error');
    resTrain(6)=str2double(s(t(1)+39:t(1)+46)); 
    resTest(6)=str2double(s(t(2)+39:t(2)+46));     
    %  7) Root mean squared error
    t=strfind(s,'Root mean squared error');
    resTrain(7)=str2double(s(t(1)+39:t(1)+46)); 
    resTest(7)=str2double(s(t(2)+39:t(2)+46));
    %  8) Relative absolute error
    t=strfind(s,'Relative absolute error');
    resTrain(8)=str2double(s(t(1)+39:t(1)+46)); 
    resTest(8)=str2double(s(t(2)+39:t(2)+46));
    %  9) Root relative squared error
    t=strfind(s,'Root relative squared error');
    resTrain(9)=str2double(s(t(1)+39:t(1)+46)); 
    resTest(9)=str2double(s(t(2)+39:t(2)+46));
    %  10) Total number of instances
    t=strfind(s,'Total Number of Instances');
    resTrain(10)=str2num(s(t(1)+39:t(1)+46)); 
    resTest(10)=str2num(s(t(2)+39:t(2)+46));
    %  11) Weighted Avg. TP Rate
    t=strfind(s,'Weighted Avg.');
    resTrain(11)=str2double(s(t(1)+13:t(1)+22))/1000; 
    resTest(11)=str2double(s(t(2)+13:t(2)+22))/1000;
    %  12) Weighted Avg. FP Rate
    resTrain(12)=str2double(s(t(1)+25:t(1)+30))/1000; 
    resTest(12)=str2double(s(t(2)+25:t(2)+30))/1000;
    %  13) Weighted Avg. Precision
    resTrain(13)= str2double(s(t(1)+35:t(1)+40))/1000;
    resTest(13)= str2double(s(t(2)+35:t(2)+40))/1000;
    %  14) Weighted Avg. Recall
    resTrain(14)=str2double(s(t(1)+42:t(1)+50))/1000; 
    resTest(14)=str2double(s(t(2)+42:t(2)+50))/1000; 
    %  15) Weighted Avg. F-Measure
    resTrain(15)=str2double(s(t(1)+55:t(1)+60))/1000; 
    resTest(15)=str2double(s(t(2)+55:t(2)+60))/1000;   
    %  16) Weighted Avg. MCC
    resTrain(16)=str2double(s(t(1)+65:t(1)+70))/1000; 
    resTest(16)=str2double(s(t(2)+65:t(2)+70))/1000;   
    %  17) Weighted Avg. ROC Area
    resTrain(17)=str2double(s(t(1)+75:t(1)+80))/1000; 
    resTest(17)=str2double(s(t(2)+75:t(2)+80))/1000;   
    %  18) Weighted Avg. PRC Area
    resTrain(18)=str2double(s(t(1)+85:t(1)+90))/1000; 
    resTest(18)=str2double(s(t(2)+85:t(2)+90))/1000;       
    
end

end




%     t1=strfind(s, '=== Error on training data ===');
%     s2=s(t1+30:length(s));
%     t=strfind(s2,'%');
%     if (isempty(t))
%         resTrain = 0;
%     else
%         resultChar = s2(t(1)-9:t(1)-1);
%         resTrain = str2double(resultChar);
%     end
% 
%     t1=strfind(s,'=== Error on test data ===');
%     s2=s(t1+26:length(s));
%     t=strfind(s2,'%');
%     if (isempty(t))
%         resTest = 0;
%     else
%         resultChar = s2(t(1)-9:t(1)-1);
%         resTest = str2double(resultChar);
%     end
%     iniKappa=strfind(s,'Kappa statistic');
%     if (isempty(iniKappa))
%         kStat=0;
%     else
%         kStat =str2double(strtok(s(iniKappa+15:length(s))));
%     end
