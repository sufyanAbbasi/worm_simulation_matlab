%{
Sufyan Abbasi
Last Modified: 5/8/18
File: visualize.m
Final: Computer Worm Epidemic
Visualizes a world space configuration with cellphone/router locations
and state (color), and router connections

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

function visualize(config, world, routers, adjacency, plot_title)
eval(config);
[height, width] = size(world);

% draw cellphones
% ================
[cell_S_rows, cell_S_cols] = find(world==S);
[cell_N_rows, cell_N_cols] = find(world==N);
[cell_I_rows, cell_I_cols] = find(world==I);

cell_S_x = cell_S_cols - 0.5;
cell_S_y = cell_S_rows - 0.5;

cell_N_x = cell_N_cols - 0.5;
cell_N_y = cell_N_rows - 0.5;

cell_I_x = cell_I_cols - 0.5;
cell_I_y = cell_I_rows - 0.5;

% draw routers 
% ================
[router_S_rows, router_S_cols] = find(routers==S);
[router_N_rows, router_N_cols] = find(routers==N);
[router_I_rows, router_I_cols] = find(routers==I);

router_N_x = router_N_cols.*2 - 1;
router_N_y = router_N_rows.*2 - 1;

router_S_x = router_S_cols.*2 - 1;
router_S_y = router_S_rows.*2 - 1;

router_I_x = router_I_cols.*2 - 1;
router_I_y = router_I_rows.*2 - 1;

% draw router connections 
% =======================
[dest, source] = find(triu(adjacency)==1);
[source_y, source_x] = ind2sub(size(routers), source);
[dest_y, dest_x] = ind2sub(size(routers), dest);

source_x = source_x.*2 - 1;
source_y = source_y.*2 - 1;

dest_x = dest_x.*2 - 1;
dest_y = dest_y.*2 - 1;

figure(1);
hold on;
title(plot_title);
xlim([0 width]);
ylim([0 height]);
for i=1:length(source_x)
    line([source_x(i), dest_x(i)], [source_y(i), dest_y(i)], 'Color',[.6 .6 .6],'LineStyle','--')
end
plot(cell_S_x, cell_S_y, 'b.', 'markers', 10)
plot(cell_N_x, cell_N_y, 'r.', 'markers', 10)
plot(cell_I_x, cell_I_y, 'g.', 'markers', 10)
plot(router_S_x, router_S_y, 'b.', 'markers', 25)
plot(router_N_x, router_N_y, 'r.', 'markers', 25)
plot(router_I_x, router_I_y, 'g.', 'markers', 25)
set (gca,'YDir','reverse')
yticklabels([])
xticklabels([])
grid on;
hold off;
end