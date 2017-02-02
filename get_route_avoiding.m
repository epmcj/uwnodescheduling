function route = get_route_avoiding(src, dst, links, avoid)
    %
    %
    
    route        = inf(1, length(links));
    next_node    = zeros(1, length(links));
    found        = inf(1, length(links));
    found(src)   = 0;
    next_node(1) = src;
    next_ptr     = 2;
    
    % Encontrando um caminho
    while found(dst) == Inf
        % Caso nao exista rota ate o no de destino.
        if next_node(1) == 0
            route = Inf;
            return;
        end
        curr_node = next_node(1);
        for i=1:length(links{curr_node})
            node = links{curr_node}(i);
            % Caso ainda nao tenha sido descoberto, entao deve-se marcar 
            % que e' possivel chegar nele atraves de curr_node e
            % adiciona-lo na lista dos proximos a serem explorados.
            if found(node) == Inf
                found(node) = curr_node;
                % se ele nao esta na lista dos nos a serem evitados, deve
                % ser avaliado.
                if avoid(node) == 0 
                    next_node(next_ptr) = node;
                    next_ptr = next_ptr + 1;
                end
            end
        end        
        next_node = next_node(2:length(next_node));
        next_ptr = next_ptr - 1;
    end
    route(1) = dst;
    i = 2;
    route(i) = found(dst);
    while route(i) ~= src
        i = i+1;
        route(i) = found(route(i-1));
    end
    
    route = route(route ~= Inf);
    route = fliplr(route);
    