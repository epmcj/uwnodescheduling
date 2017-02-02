function [toSleep, nodeAwaked] = verifyNodes(nodes, box, threshold)
    % Verifica quais nos contem area de monitoramento abaixo do limiar
    % especificado.
    
    toSleep = [];
    nodeAwaked = zeros(length(nodes), 3);
    nodeAwaked(:,1:2) = nodes(:,1:2);
    for k = 1:length(nodes)
        nodeAwaked(k,3) = k;
    end
    
    keep = 1;
    while keep == 1
        [V, C] = voronoin(nodeAwaked(:,1:2), {'Qbb','Qz'});
        Area = calc_box_area(C, V, nodeAwaked(:,1:2), box);        
        [Area,I] = sort(Area);
        smallest = Area(1);
        
        keep = 0;
        if smallest < threshold
            toSleep = [toSleep nodeAwaked(I(1),3)];
            nodeAwaked(I(1),:) = [];
            keep = 1;
        end
    end