function a = can_reach_not_using(src, dst, avoid, nodelist)
    % src is the index of the source node in the nodelist.
    % dst is the index of the destination node in the nodelist.
    % nodelist e' a lista de nos.
        
    can_reach = zeros(length(nodelist),1);
    next = zeros(length(nodelist),1);
    ind_n = 1;
    ind_add = 2; 
    next(1) = src; % Primeiro a ser investigado deve ser o no origem.
    can_reach(src) = 1;
    
    % marcando os nos que devem ser evitados
    for k=1:length(avoid)
        can_reach(avoid(k)) = -1;
    end
    
    % Enquanto o no de destino ainda nao tiver sido descoberto e ainda
    % existirem nos a serem investigados.
    while can_reach(dst) == 0 && ind_n < ind_add
        l = next(ind_n);
        
        for k = 1:length(nodelist{l})
            % Caso o no nao tenha sido encontrado ainda, deve-se
            % adiciona-lo na lista e coloca-lo na fila para ser explorado.
%             if nodelist{l}(k) > length(nodelist{l})
%                 return; % tratar 
%             end
            if can_reach(nodelist{l}(k)) == 0
                can_reach(nodelist{l}(k)) = 1;
                next(ind_add) = nodelist{l}(k);
                ind_add = ind_add + 1;
            end
        end
        ind_n = ind_n + 1;
    end
    a = can_reach(dst);