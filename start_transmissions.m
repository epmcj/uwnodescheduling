function [cicle, nmsg, list, nEnergy] = start_transmissions(nodes, ... 
                                        iEnergy,links,max_cicles, avoid)
    % nodes: lista dos nos
    % iEnergy: lista com o nivel de energia de cada um dos nos [0,1]
    % links: celulas com listas de nos que comunicam com os outros.
    % max_cicles: numero maximo de ciclos a serem executados.
    
    maxTry  = 3; % Numero maximo de tentativas de entrega da mensagem.
    nEnergy = iEnergy;    
    list    = [];
    cicle   = 0;
    fin     = 0;
    nmsg    = 0;
    qt      = 000.2/100;    % quantum of energy spent on transmission
    qn      = 00.01/100;    % quantum of energy spent awaken
    qs      = 0.001/100;    % quantum of energy spent slepping
    
    % Se todos os nos tiverem de ser evitados.
%     if length(avoid) == length(nodes)
%         return
%     end
    
    while cicle < max_cicles
        cicle = cicle + 1;
        src = randi([2 length(nodes)], 1, 1); 
        while avoid(src) == 1
            src = randi([2 length(nodes)], 1, 1);
        end
        %list = [list src];
        % Rota para alcancar a superficie:
        route = get_route_avoiding(src, 1, links, avoid); 
        if isempty(route)
            return;
        end
%fprintf('Ciclo: %d, Src: %d\n', cicle, src);
%disp(route)
            
        % Realizando o caminho da mensagem.
        for i=1:(length(route)-1)
            % Transmite os dados e verifica quantas transmissoes foram
            % realizadas.
            %disp(nEnergy);
            [done, num, nEnergy] = transmit_msg(nodes, route(i), ...
                route(i+1), maxTry, nEnergy, qt);
            nmsg = nmsg + num;
            % Caso o numero maximo de transmissoes tenha sido atingido
            %disp(nEnergy);
            if done == 0 
                break;
            end 
            
            for k=1:length(nEnergy)
                if avoid(k) == 0    % no acordado
                   nEnergy(k) = nEnergy(k) - qn * num; 
                else                % no dormindo
                   nEnergy(k) = nEnergy(k) - qs * num;
                end
            end
     
            % Se a energia de algum dos nos se esgotou
            if any(nEnergy <= 0) == 1
                %avoid(find(nEnergy <= 0)) = 1;
                list = find(nEnergy <= 0);
                fin = 1; % Marca que deve terminar
                break;
            end                      
        end
        
        if fin == 1
            break;
        end
    end
    