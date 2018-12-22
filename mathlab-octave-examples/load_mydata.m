function mydata=load_mydata()

  imgDirName = 'data/mydata';
  csvfile = 'list.csv';

  if exist(imgDirName)
    if exist(strcat(imgDirName, '/', csvfile))
    else
      fprintf(strcat('csv file "', csvfile, '" Not found\n'));
      return;
    end
  else
    fprintf(strcat('imgDirName "', imgDirName,'" Not Found\n'));
    return;
  end
 
  csvdata = importdata(strcat(imgDirName, '/', csvfile), ',');
  ss= size(csvdata.data);
  imgNum = ss(1);
  if imgNum == 0
    fprintf('There are no image files. Please put .png files in ./mydata');
  else
    for i=1:imgNum
      imgFileName = char(csvdata.textdata(i));
      img = imread(strcat(imgDirName, '/', imgFileName));
      if ndims(img) == 3
          img = img(:,:,1);
      end
      img = imresize(img, [28,28]);
      out_images(:,:,1,i) = uint8(-1 .* (int16(im2uint8(img)) - 255));
      out_labels(i,1) = csvdata.data(i);
    end
  end
  
  sn = randperm(imgNum);
  TRAIN_NUM = 1800
  TEST_NUM = imgNum - TRAIN_NUM
  mydata.train_images = out_images(:,:,1,sn(1:TRAIN_NUM));
  mydata.train_labels = out_labels(sn(1:TRAIN_NUM),1);
  mydata.test_images = out_images(:,:,1,sn(TRAIN_NUM + 1:end));
  mydata.test_labels = out_labels(sn(TRAIN_NUM+1:end),1);
end

  

