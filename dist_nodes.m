function [P, edge_nodes] = dist_nodes(type, n, limX, limY, limZ)
    % Distributes nodes according to the distribution type chosen. The 
    % type parameter can have the values 'e' or 'n'. If type = 'e', then
    % the nodes are distributed in layers. Each layer will contain n nodes,
    % uniformly distributed between [0, limX] x [0, limY]. The depht of
    % each layer is defined in the parameters list. For example, the call
    % dist_nodes('e', 5, 10, 10, 5, 15, 25) will distribute 5 nodes in the 
    % depth of 5 m, another 5 in 15 m and another 5 in 25 m. 
    % If type = 'u', the n nodes will be distributed using a normal 
    % distribution, in a box of limX x limY x limZ.

    switch type
        case 'l',       % Layering model (Estratificado)
            P = cell(length(limZ)+1, n);
%           edge_nodes = zeros((nargin - 4) * 4, 3);
            
            P{1,1} = [rand(1)*limX, rand(1)*limY, 1];   % Sink node
            for j = 2:(length(limZ)+1)                
                for k = 1:n
                    P{j, k} = [rand(1)*limX, rand(1)*limY, limZ(j-1)];
                end
            end
            
%                 edge_nodes((j-1)*4 + 1, :) = [0 0 varargin{j}];
%                 edge_nodes((j-1)*4 + 2, :) = [limX 0 varargin{j}];
%                 edge_nodes((j-1)*4 + 3, :) = [limX limY varargin{j}];
%                 edge_nodes((j-1)*4 + 4, :) = [0 limY varargin{j}];
            
        case 'u',       % Uniform distribution
            P = zeros(n+1, 3);
            
%             edge_nodes = zeros(8, 3);
%             edge_nodes(1,:) = [0 0 0];
%             edge_nodes(2,:) = [limX 0 0];
%             edge_nodes(3,:) = [limX limY 0];
%             edge_nodes(4,:) = [0 limY 0];
%             edge_nodes(5,:) = [0 0 limZ];
%             edge_nodes(6,:) = [limX 0 limZ];
%             edge_nodes(8,:) = [limX limY limZ];
%             edge_nodes(7,:) = [0 limY limZ];
            P(1,:) = [rand(1)*limX, rand(1)*limY, 0];   % Sink node
            P(2:n+1,1) = rand(n,1) * limX;
            P(2:n+1,2) = rand(n,1) * limY;
            P(2:n+1,3) = rand(n,1) * limZ;
            
        otherwise
            error('Type not defined. Choose between "l" or "u".');
            
    end