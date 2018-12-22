function download_mnist()
%DOWNLOADDATASETS
  % CIFAR10_URL = 'http://www.cs.toronto.edu/~kriz/cifar-10-matlab.tar.gz';
  % MNIST_URLS = { ...
  %   'http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz', ...
  %   'http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz', ...
  %   'http://yann.lecun.com/exdb/downmnist/t10k-images-idx3-ubyte.gz', ...
  %   'http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz' ...
  %   };
  BASE_URL = 'https://nittc.tokyo-ct.ac.jp/web/j/usr/yamashita/file/';
  CIFAR10_URL = [BASE_URL, 'cifar-10-matlab.tar.gz'];
  MNIST_URLS = {[BASE_URL, 'train-images-idx3-ubyte.gz'], ...
                [BASE_URL, 'train-labels-idx1-ubyte.gz'], ...
                [BASE_URL, 't10k-images-idx3-ubyte.gz'], ...
                [BASE_URL, 't10k-labels-idx1-ubyte.gz']};
  root_dir = fileparts(mfilename('fullpath'));

  % Download MNIST.
  if ~exist(fullfile(root_dir, 'data', 'mnist'), 'dir')
    fprintf('Downloading MNIST dataset.\n');
    mkdir(fullfile(root_dir, 'data', 'mnist'));
    cwd = cd(fullfile(root_dir, 'data', 'mnist'));
    try
      for i = 1:numel(MNIST_URLS)
        fprintf('%s\n', MNIST_URLS{i});
        [~, basename, extname] = fileparts(MNIST_URLS{i});
        urlwrite(MNIST_URLS{i}, [basename, extname]);
        assert(exist([basename, extname], 'file') > 0);
        gunzip([basename, extname]);
      end
      cd(cwd);
    catch e
      cd(cwd);
      rethrow(e);
    end
  end
end
