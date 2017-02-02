function v = intersection(b1, l1, b2, l2)
    % Encontra o ponto de interseccao entre duas retas. As duas retas sao
    % definidas atraves de um ponto de origem (b1 e b2) e um vetor (l1 e
    % l2).    
    % b1 -> vetor linha informando o ponto de partida 1
    % l1 -> vetor linha informando a reta 1
    % b2 -> vetor linha informando o ponto de partida 2
    % l2 -> vetor linha informando a reta 2
    b = b2 - b1;
    b = b.';
    A = [l1(1) -l2(1); l1(2) -l2(2)]; 
    x = A\b;
    v = b1 + x(1) * l1;