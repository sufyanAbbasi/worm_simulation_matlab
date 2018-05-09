%{
Sufyan Abbasi
Last Modified: 5/8/18
File: init_world.m
Final: Computer Worm Epidemic
Initializes the world space given constants from constants.m
- adds the cellphones to 

World Space:

            n = 2

+------+------+------+------+
|      |      |      |      |
|  C   |      |      |      |
|      |      |      |      |
+------R-------------R------+
|      |      |      |      |
|      |      |      |      |
|      |      |      |      |
+---------------------------+  m = 2
|      |      |      |      |
|      |      |  C   |      |
|      |      |      |      |
+------R-------------R------+
|      |      |      |      |
|      |      |      |      |
|      |      |      |      |
+------+------+------+------+

R : location of a router
C : location of a cellphone
n : number of 2x2 blocks, width-wise
m : number of 2x2 blocks, height-wise
%}
function [world_space, routers, adjacency_matrix] = init_world(config)

eval(config);
width = 2*n;
height = 2*m;
world_space = zeros(width, height);
adjacency_matrix = zeros(n*m, n*m);
routers = ones(n, m); % initialize all routers to suscepitble

% place uninfected cellphones randomly in the world space
for c=1:C_num - C_infected
    rand_width = randi(width);
    rand_height = randi(height);
    while world_space(rand_width, rand_height)
        rand_width = randi(width);
        rand_height = randi(height);
    end
    world_space(rand_width, rand_height) = S;
end
% place infected cellphones randomly in the world space
for c=1:C_infected
    rand_width = randi(width);
    rand_height = randi(height);
    while world_space(rand_width, rand_height)
        rand_width = randi(width);
        rand_height = randi(height);
    end
    world_space(rand_width, rand_height) = N;
end

% set R_infected number routers to infected
for r=1:R_infected
    rand_n = randi(n);
    rand_m = randi(m);
    while routers(rand_n, rand_m) == N
        rand_n = randi(width);
        rand_m = randi(height);
    end
    routers(rand_n, rand_m) = N;
end

% initialize the adjacency matrix with random connections,
% where infected routers do not connect with any others

for e=1:num_edges
    node1 = randi(n*m);
    node2 = randi(n*m);
    while node2 == node1 || routers(node1) == N || routers(node2) == N || adjacency_matrix(node1, node2)
        node1 = randi(n*m);
        node2 = randi(n*m);
    end
    adjacency_matrix(node1, node2) = 1;
    adjacency_matrix(node2, node1) = 1;
end
end
