function area = calc_box_area(vcells, vpoints, nodes, box)
    % Calcula a area de cada uma das celulas do voronoi, limitadas por uma
    % regiao quadrada.
    % vcells -> lista com celulas do voronoi (Vetor C da funcao voronoin)
    % vpoints -> lista com os pontos do voronoi (Vetor V da funcao
    % voronoin)
    % nodes -> lista de nos que geraram o voronoi
    % box_min e box_max -> coordenadas dos extremos do quadrado:
    %            +------+ <- box_max
    %            |      |
    %            |      |
    % box_min -> +------+
    
    nlist = cell(length(vpoints),1);
    
    for k = 1:length(vcells)
        % Se a regiao for ilimitada, entao sera preciso adicionar mais 
        % vertices. 
        if any(vcells{k} == 1) % Ponto #1 -> Inf
            for j=1:length(vcells{k})
                nlist{vcells{k}(j)} = [nlist{vcells{k}(j)} k];                
            end
        end
    end

    i = length(vpoints);
    newv = vpoints;
    newc = vcells;
    a = [];
    % Ponto #1 -> Inf
    for k = 2:length(nlist)
        for i1 = 1:length(nlist{k})
            for i2 = i1+1:length(nlist{k})
                n1 = nlist{k}(i1);
                n2 = nlist{k}(i2);                
                i = i + 1;
                p1  = nodes(n1,:);
                p2  = nodes(n2,:) ; 
                m   = (p1 + p2)*0.5;
                vec = m - vpoints(k,:);
                
                p = get_intpoint(vpoints(k,:),vec, box);
                newv = [newv; p];
                newc{n1} = [newc{n1} i];
                newc{n2} = [newc{n2} i];
            end
        end
    end
    
    % Adicionando as quinas.
    newv = [newv; box];
    
    % Calculando os pontos mais proximos de cada uma das bordas.
    near = inf(length(box),2); % near -> (#no, distancia)
    for k = 1:length(nodes)
        if norm(box(1,:) - nodes(k,:)) < near(1,2)
            near(1,1) = k;
            near(1,2) = norm(box(1,:) - nodes(k,:));
        end
        
        if norm(box(2,:) - nodes(k,:)) < near(2,2)
            near(2,1) = k;
            near(2,2) = norm(box(2,:) - nodes(k,:));
        end
        
        if norm(box(3,:) - nodes(k,:)) < near(3,2)
            near(3,1) = k;
            near(3,2) = norm(box(3,:) - nodes(k,:));
        end
        
        if norm(box(4,:) - nodes(k,:)) < near(4,2)
            near(4,1) = k;
            near(4,2) = norm(box(4,:) - nodes(k,:));
        end
    end
    newc{near(1,1)} = [newc{near(1,1)} i+1];
    newc{near(2,1)} = [newc{near(2,1)} i+2];
    newc{near(3,1)} = [newc{near(3,1)} i+3];
    newc{near(4,1)} = [newc{near(4,1)} i+4];
    
    % Removendo a referencia ao ponto no infinito
    for k = 1:length(newc)
        newc{k} = newc{k}(newc{k}~=1);
    end
    
    % Calculando as areas
    area = zeros(length(newc),1);
    for k = 1:length(newc)
        VertCell = newv(newc{k},:);
        % Verificando se a regiao e' limitada.
        if all(newc{k}~= 1) % Ponto #1 -> Inf
            [~, area(k)] = convhulln(VertCell);
        else
            area(k) = Inf;
        end
    end
