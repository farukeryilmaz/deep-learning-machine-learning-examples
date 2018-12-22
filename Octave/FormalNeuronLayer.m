classdef FormalNeuronLayer
	properties
		weights;
		threshold;
	end
	
	methods
        function obj = FormalNeuronLayer(w,h)
            obj.weights = w;
            obj.threshold = h;
       end
      
    	function y = forward(obj, x)
            p = obj.weights * x;
        	y = p > obj.threshold;
    	end
	end
end
