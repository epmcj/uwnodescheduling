function simulation(isOn, n, ndepth, limX, limY, s_range, thresh_prcntg, fp)
    % isOn          : escalonamento ativado se isOn = 1.
    % n             : numero de nos por camada.
    % ndepth        : numero de camadas.
    % limX          : Limite no eixo X da caixa onde os nos estarao 
    %                 distribuidos, em metros.
    % limY          : Limite no eixo Y da caixa onde os nos estarao 
    %                 distribuidos, em metros.
    % s_range       : Alcance dos transmissores dos nos, em metros.
    % thresh_prcntg : Limiar para determinar nos a serem desativados.
    % fp            : Ponteiro para o arquivo onde estara o resultado da 
    %                 simulacao.
    
    
    warning('off','all');
    threshold = (s_range * s_range * 3.1415) * thresh_prcntg; % m2
    tcicles = 0;
    tmsg    = 0;
    min_nodes = 0.5;
    
    % Definindo a profundidade de cada camada.
    rand('seed', 0) %#ok<RAND> 
    depthi = 0;
    depth = zeros(ndepth,1);
    for i=1:ndepth
        depth(i) = depthi + randi([floor(s_range/2) s_range], 1, 1);
        depthi = depth(i);
    end

    nnodes = length(depth) * n; % Nao considera os nos da camada 1.

    % Espacamento para evitar que os nos fiquem nas fronteiras da area de
    % cada camada: 100
    box2 = [-100 -100;
            -100 limY;
            limX limY;
            limX -100];

    nodes = dist_nodes('l', n, limX-100, limY-100, depth);
    %Para se ter diferentes valoresa cada execucao:
    rand('state', sum(100*clock)) %#ok<RAND> 
   
    nEnergy = ones(length(depth) * n + 1, 1); % Energia dos nos.
    nEnergy(1) = 10; % No Sink possui mais energia que os outros.

    
    [reach, nlist] = discover_nodes('l',nodes, s_range); 
    noOff = zeros(length(nlist),1);
    avoid = zeros(length(nlist),1);
    isOff = zeros(length(nlist),1);

    % Simulacao
    while 1
        base  = 2;
        avoid(:) = 0;
        isOff(:) = 0;
        
        % Extraindo uma das camadas:
        while base < length(nlist)
            layer_depth = nlist(base, 3);
            layer = nlist(nlist(:,3)==layer_depth,:);

            % Verificando nós que podem ser removidos (indices dentro da
            % camada)
            [ind, aN] = verifyNodes(layer(:,1:2), box2, threshold); 
            ind = ind + (base - 1); % Fazendo com que os valores 
                                    % correspondam com o no na lista

            for k=1:length(ind)
                sleep = 1;
                % Verificando se todos os nos que sao alcançaveis pelo no 
                % investigado podem alcancar o no sink atraves de outro no
                avoid(ind(k)) = 1;
                for j=1:length(reach{ind(k)}) 
                    if isOff(reach{ind(k)}) == 1
                        continue;
                    end                    
                    if can_comm_avoiding(reach{ind(k)}(j), ...
                            1, avoid, reach) == 0
                        sleep = 0;
                        break;
                    end                  
                end

                if sleep == 1
                    isOff(ind(k)) = 1;
                else
                    avoid(ind(k)) = 0;
                end
                
            end
            base = base + length(layer);
        end

        if isOn == 1
            evitar = isOff;
        else
            evitar = noOff;
        end

        [ncicles, nmsgs, dead, aEnergy] = start_transmissions(nlist, nEnergy, ...
            reach, Inf, evitar);
        tcicles = tcicles + ncicles;
        tmsg    = tmsg + nmsgs;

        % Atualizacoes para proxima iteracao
        nEnergy = aEnergy;
        dead = sort(dead,'descend');
        for i = 1:length(dead)
            % Removendo no da lista e ajustando as numeracoes (tambem da contagem
            % de energia)
            for j = dead(i):(length(nlist)-1)
                nlist(j,:) = nlist(j+1,:);
                nEnergy(j) = nEnergy(j+1);
                reach{j} = reach{j+1};
            end

            % Removendo ligacoes.
            for j = 1:length(reach)
                reach{j} = reach{j}(reach{j} ~= dead(i));
            end

            nlist = nlist(1:end-1,:);
            nEnergy = nEnergy(1:end-1,:);
        end

        % Solucao temporaria para remover ultima celula.
        temp = cell(length(reach)-1,1);
        for i = 1:(length(reach)-1)
           temp{i} = reach{i};
        end

        reach = temp;

        % Atualizacao das numeracoes
        for k = 1:length(dead)
            for i = 1:length(reach)
                for j = 1:length(reach{i})
                    if reach{i}(j) > dead(k)
                        reach{i}(j) = reach{i}(j) - 1;
                    end
                end
            end
        end

        active_nodes = 0;
        for i=2:length(nlist)
            if get_route(i, 1, reach) ~= Inf
                active_nodes = active_nodes + 1;
            end
        end
        % Se a porcentagem de nos vivas for menor do que o desejado, parar
        % simulacao.
        if (active_nodes/nnodes) < min_nodes
            fprintf('Fim :: %.2f \n', (active_nodes/ nnodes));
            break;
        end
    end

    fprintf(fp, '%d %d\n', tcicles, tmsg);
