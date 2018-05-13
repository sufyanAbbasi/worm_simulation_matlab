constants

% evaluates the given probability
evaluate_probability = @(probability) rand() < probability;

% returns the index of the local router given world space coordinate
get_local_router = @(x, y, router_size) ...
      sub2ind(router_size, idivide(x+1, int32(2)), idivide(y+1, int32(2)));
  
% returns the cellphone transition probabilities from the current state
% given the local router state
get_cellphone_state_probs = @(router_state, current_state)...
                           cellphone_state_transitions(current_state, :)...
                           .* router_to_cellphone_matrix(router_state, :);
% returns the router transition probabilities from the current state
% from cellphone exposure
get_router_state_probs_cellphone = @(current_state, num_inf_cellphones)...
                        router_state_transitions(current_state, :) ...
                        .* [1 num_inf_cellphones 1];
                        
% returns the router transition probabilities from the current state
% from connected router exposure
get_router_state_probs_router = @(current_state, num_inf_connections, num_imm_connections)...
                       router_from_router_transitions(current_state, :)...
                       .* [1 num_inf_connections num_imm_connections];
                   
                   
% Initialize World
% =================
% [world, routers, adjacency] = init_world(n, m, C_num, C_infected, ...
%                                          R_infected, num_edges)
initialworlda
visualize(world, routers, adjacency, "t=0")
t = 0;


%{
Run Simulation
===================
run while the following conditions are true:
    - there is at least one infected router or one infected cellphone
    - not all of the routers are immune
%}
while (~isempty(find(routers==N, 1)) || ~isempty(find(world==N, 1))) ...
      && length(find(routers==I)) < numel(routers)
visualize(world, routers, adjacency, "t="+t);
% number of infected cellphones around a given router
[width, height] = size(world);
[router_x, router_y] = size(routers);
num_infected_cellphones = zeros(size(routers));
new_world = zeros(size(world));
new_routers = routers;

% evaluate the new cellphone states and positions
for y=1:height
    for x=1:width
        current_state = world(x,y);
        local_router = get_local_router(x,y,size(routers));
        router_state = routers(local_router);
        if current_state
            % if there is a cellphone
            new_state = current_state;
            new_pos = [x y];
            if current_state == N
                % increment the number of infected cellphones for the local
                % router
                num_infected_cellphones(local_router) = num_infected_cellphones(local_router) + 1;
            end
            % generates the state transition probabilities and evaluates
            % them for each state, produces a boolean array where the index 
            % is the successful state transition
            transitions = arrayfun(evaluate_probability, get_cellphone_state_probs(router_state, current_state));
            if find(transitions==1)
                % if there is a successful transition, pick the last one
                % (favors the immune transition)
                new_state = find(transitions==1, 1, 'last' );
            end
            if evaluate_probability(movement_probability)
                % evaluate the Von-Neumann direction validity: [top bottom left right]
                valid_pos = [
                             ((x-1) >= 1      && ~world(x-1, y) && ~new_world(x-1, y))
                             ((x+1) <= height && ~world(x+1, y) && ~new_world(x+1, y))

                             ((y-1) >= 1     && ~world(x, y-1) && ~new_world(x, y-1))
                             ((y+1) <= width && ~world(x, y+1) && ~new_world(x, y+1))
                            ];
                valid_pos = find(valid_pos==1);
                if valid_pos
                    rand_pos = valid_pos(randi(length(valid_pos)));
                    if rand_pos == 1
                        new_pos = [x-1 y];
                    elseif rand_pos == 2
                        new_pos = [x+1 y];
                    elseif rand_pos == 3
                        new_pos = [x y-1];
                    else
                        new_pos = [x y+1];
                    end
                end
            end
            new_world(new_pos(1), new_pos(2)) = new_state;
        end
    end
end

% evaluate the new router states
for i=1:router_x
    for j=1:router_y
        curr_state = routers(i,j);
        % evaluate transitions from local cellphones
        transitions_from_cellphones = arrayfun(evaluate_probability, ...
            get_router_state_probs_cellphone(curr_state, num_infected_cellphones(i,j)));
        % evaluate transitions from router connections
        transitions_from_connections = [0 0 0];
        adjacency_index = sub2ind([router_x router_y], i, j);
        connections = find(adjacency(adjacency_index,:)==1);
        if connections
            num_infected_connections = length(find(routers(connections)==N));
            num_immune_connections = length(find(routers(connections)==I));
            transitions_from_connections = arrayfun(evaluate_probability, ...
                get_router_state_probs_router(curr_state, num_infected_connections, num_immune_connections));
        end
        transitions = transitions_from_cellphones | transitions_from_connections;
        if find(transitions==1)
            % if there is a successful transition, pick the last one
            % (favors the immune transition)
            new_routers(i,j) = find(transitions==1, 1, 'last' );
        end
    end
end

world = new_world;
routers = new_routers;
waitforbuttonpress;
clf(1);
t = t + 1;
end
visualize(world, routers, adjacency, "Final: t="+t);