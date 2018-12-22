clear -regexp ^(?!(mnist|mydata)$).

mnist = load_mnist();
mydata = load_mydata();

%use MNIST traininig datasets
train_num = 60000; % The number of Training samples (MNIST has 60,000 Training samples)
train_images = mat2gray(mnist.train_images); % normalize images
train_labels = mnist.train_labels;

%use MYDATA training datasets
%train_num = 1800; % The number of Training samples (MYDATA has 1,800 Training samples)
%train_images = mat2gray(mydata.train_images); % normalize images
%train_labels = mydata.train_labels;

train_label_vecs = zeros(10,train_num);
for n=1:train_num
  train_label_vecs(train_labels(n)+1, n) = 1; %create training label vectors
end
 
%use MNIST test datasets
%test_num = 10000;   % The number of Test samples (MNIST has 10,000 Test samples) 
%test_images = mat2gray(mnist.test_images); % normalize images
%test_labels = mnist.test_labels;

%use MYDATA test datasets
test_num = 360;   % The number of Test samples (MYDATA has 360 Test samples) 
test_images = mat2gray(mydata.test_images); % normalize images
test_labels = mydata.test_labels;

test_label_vecs = zeros(10,test_num);
for n=1:test_num
  test_label_vecs(test_labels(n)+1, n) = 1; %create test label vectors
end

IU = 784; % the umber of input neurons (28*28)
HU = 10;  % the number of hidden neurons (Changeable)
OU = 10;  % the number of output neurons (Number of Classes)
 
w = 2.0*rand(HU,IU) - 1.0;
b = 2.0*rand(HU,1) - 1.0;
u = 2.0*rand(OU,HU) - 1.0;
c = 2.0*rand(OU,1) - 1.0;
 
EPOCH=100;  % The number of training epochs
LAMBDA=0.01; % learning rate
MINI_BATCH_SIZE = 100;
MINI_BATCH_NUM = train_num / MINI_BATCH_SIZE;

layer1 = Affine(w,b);
layer2 = Sigmoid();
layer3 = Affine(u,c);
layer4 = Sigmoid();
layer5 = MSE();

loss = 0;
mistaken_train_ids=[];
mistaken_test_ids=[];

for epoch=1:EPOCH

  %create mini batch indexes
  idx = randperm(train_num);  % Shuffled integer array from 1 to train_num
  idx = reshape(idx,[],MINI_BATCH_SIZE); %Split arrays into mini batch size
  
  for i=1 : MINI_BATCH_NUM
    
    %create mini batch datasets
    mini_batch = train_images(:,:,1,idx(i,:));
    xdata = reshape(mini_batch, 28*28, MINI_BATCH_SIZE);
    labels = train_label_vecs(1:10,idx(i,:));
  
    %forward calculation
    p = layer1.forward(xdata);
    y = layer2.forward(p);
    q = layer3.forward(y);
    z = layer4.forward(q);
    loss(end + 1) = layer5.forward(z,labels);
    
    %backward calculation (calculate gradient)
    dz = layer5.backward();
    dq = layer4.backward(dz);
    dy = layer3.backward(dq);
    dp = layer2.backward(dy);
    dx = layer1.backward(dp);
  
    %update weights and biases
    layer1.update(LAMBDA);
    layer3.update(LAMBDA);
  end
end

% Display loss change graph
figure(1);
plot(loss)
axis([0 EPOCH*MINI_BATCH_NUM 0 max(loss)])
xlabel('The number of minibatch learning');
ylabel('LOSS');

% Calculate accuracy for training datasets
train_res_mat = zeros(10, 10);
xdata = reshape(train_images, 28*28, train_num);
p = layer1.forward(xdata);
y = layer2.forward(p);
q = layer3.forward(y);
z = layer4.forward(q);
[value, index] = max(z);
for n=1:train_num
  train_res_mat(index(n), train_labels(n)+1) = ...
    train_res_mat(index(n), train_labels(n)+1) + 1;
  if index(n) ~= train_labels(n)+1
    mistaken_train_ids(end+1) = n;
  end
end
train_res_mat
train_accuracy = trace(train_res_mat)/sum(sum(train_res_mat))
mistaken_train_images = train_images(:,:,1,mistaken_train_ids);


% Calculate accuracy for test datasets
test_res_mat = zeros(10, 10);
xdata = reshape(test_images, 28*28, test_num);
p = layer1.forward(xdata);
y = layer2.forward(p);
q = layer3.forward(y);
z = layer4.forward(q);
[value, index] = max(z);
for n=1:test_num
  test_res_mat(index(n), test_labels(n)+1) = ...
    test_res_mat(index(n), test_labels(n)+1) + 1;
  if index(n) ~= test_labels(n)+1
    mistaken_test_ids(end+1) = n;
  end
end
test_res_mat
test_accuracy = trace(test_res_mat)/sum(sum(test_res_mat))
mistaken_test_images = test_images(:,:,1,mistaken_test_ids);
montage(mistaken_test_images)