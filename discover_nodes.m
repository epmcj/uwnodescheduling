function [reach, list] = discover_nodes(type, nodes, srange)
    % 
    % 
    % reach -> celulas onde uma celula i abriga a lista de nos que sao 
    % acessiveis a partir dele.
    % list -> lista dos nos (somente pra aproveitar que esta pronto)
    
    a = size(nodes);
    nl = a(1); % number of layers
    
    % number of nodes in each layer
    nn = zeros(nl,1);
    n = 0;
    for k = 1:nl
        nn(k) = (nnz([nodes{k,:}])/3);
        n = n + nn(k);
    end
    
    list = zeros(n, 3);
    k = 1;
    for l1 = 1:nl % for each layer 
        for n1 = 1:nn(l1) % for each node in each layer 
            list(k,:) = nodes{l1,n1};
            k = k+1;
        end
    end
    
    switch type
        case 'l',   % Layering model (Estratificado)
            reach = cell((nl-1)*nn(2)+1,1);
            n_n = 1;
            
            for l1 = 1:nl % for each layer 
                for n1 = 1:nn(l1) % for each node in each layer (TX)
                    aux = zeros(nl*nn(2)+1,1);
                    ind = 1;
                    n_c = 1;   % counter to indentify a node.
                    
                    for l2 = 1:nl
                        % if the distance between the layers is bigger than
                        % the range fo the sensor, go to the next layer.
                        if abs(nodes{l1,1}(3) - nodes{l2,1}(3)) > srange
                            n_c = n_c + (nnz([nodes{l2,:}])/3);
                            continue;
                        end
                        
                        % look for nodes that can communicate with n1.                        
                        for n2 = 1:nn(l2)
                            dist = norm(nodes{l1,n1} - nodes{l2,n2});
                            if dist <= srange && dist > 0
                                aux(ind,1) = n_c;
                                ind = ind + 1;
                            end

                            n_c = n_c + 1; % move to next node
                        end
                    end
                    % save the list of nodes that can communicate with n1
                    reach{n_n} = aux(1:nnz(aux)); 
                    n_n = n_n + 1;
                    
                end
            end
            % removing the empty cells
            %reach = reach(~cellfun('isempty',reach));
            
        case 'u', 
            reach = cell(nn+1,1);
            % ...
            
        otherwise,
            error('Type not defined. Choose between "l" or "u".');
    end
    
    