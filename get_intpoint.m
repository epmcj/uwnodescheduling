function p = get_intpoint(vp, vec, corners)
    % Esta funcao retorna o ponto de intersecao entre a linha de um vertice
    % do diagrama de voronoi e uma das arestas de uma caixa.
    % 
    %         l2
    %  c2 +---------+ c3
    %     |         |
    % l1  |         |  l3
    %     |         |
    %  c1 +---------+ c4
    %         l4
    
    sides = [corners(2,:) - corners(1,:);   % l1
             corners(2,:) - corners(3,:);   % l2
             corners(4,:) - corners(3,:);   % l3
             corners(4,:) - corners(1,:)];  % l4
    
    if(vec(1) > 0)
        % Vetor aponta para NE (lados 2 ou 3)
        if(vec(2) > 0)
            p = intersection(vp, vec, corners(3,:), sides(2,:));
            if(p(1) > corners(3,1) || p(2) > corners(3,2))
                p = intersection(vp, vec, corners(3,:), sides(3,:));
            end
        
        % Vetor aponta para SE (lados 3 ou 4)
        elseif(vec(2) < 0)
            p = intersection(vp, vec, corners(3,:), sides(3,:));
            if(p(1) > corners(4,1) || p(2) < corners(4,2))
                p = intersection(vp, vec, corners(1,:), sides(4,:));
            end
            
        % Vetor aponta para L (lado 3)
        else
            p = intersection(vp, vec, corners(3,:), sides(3,:));            
        end
    elseif(vec(1) < 0)
        % Vetor aponta para NO (lados 1 ou 2)
        if(vec(2) > 0)
            p = intersection(vp, vec, corners(1,:), sides(1,:));
            if(p(1) < corners(2,1) || p(2) > corners(2,2))
                p = intersection(vp, vec, corners(3,:), sides(2,:));
            end
            
        % Vetor aponta para SO (lados 1 ou 4)
        elseif(vec(2) < 0)
            p = intersection(vp, vec, corners(1,:), sides(1,:));
            if(p(1) < corners(1,1) || p(2) < corners(1,2))
                p = intersection(vp, vec, corners(1,:), sides(4,:));
            end
            
        % Vetor aponta para O (lado 1)
        else
            p = intersection(vp, vec, corners(1,:), sides(1,:));   
        end 
    else
        % Vetor aponta para N (lado 2)
        if(vec(2) > 0)
            p = intersection(vp, vec, corners(3,:), sides(2,:));
        % Vetor aponta para S (lado 4)
        elseif(vec(2) < 0)
            p = intersection(vp, vec, corners(1,:), sides(4,:));
        % Fica no mesmo lugar
        else
            p = vp;
        end 
    end
