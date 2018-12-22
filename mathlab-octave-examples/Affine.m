classdef Affine < handle
  properties
		weights;
		bias;
    x;
    dw;
    db;
    gw; % for AdaGrad
    gb; % for AdaGrad
	end
	
	methods
    function obj = Affine(w,b)
      obj.weights = w;
      obj.bias = b;
      gw = zeros(size(w)) * 0.0001; % for AdaGrad
      gb = zeros(size(b)) * 0.0001; % for AdaGrad
    end
      
		function y = forward(obj, x)
      obj.x = x;
			p = obj.weights * x;
      y = p + obj.bias;
		end
    
    function dL = backward(obj, dL0)
      dL = obj.weights' * dL0;
      obj.dw = dL0 * obj.x';
      obj.db = sum(dL0,2);
    end

    function update(obj, learning_rate) % AdaGrad
      obj.gw = obj.gw + obj.dw .^ 2;
      obj.gb = obj.gb + obj.db .^ 2;
      lambda_g = learning_rate * obj.gw .^ (-1/2);
      lambda_b = learning_rate * obj.gb .^ (-1/2);
      obj.weights = obj.weights - (lambda_g .* obj.dw * 0.001 - lambda_g .* obj.dw);
      obj.bias = obj.bias - lambda_b .* obj.db;
    end
	end
end
