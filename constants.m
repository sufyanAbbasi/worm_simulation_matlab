%{
Sufyan Abbasi
Last Modified: 5/8/18
File: constants.m
Final: Computer Worm Epidemic
Defines the constants for the computer worm spread model

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

% ~~~~~~~~~~~~~ World Space Parameters ~~~~~~~~~~~~~

n = 3; % number of 2x2 blocks, width-wise
m = 3; % number of 2x2 blocks, height-wise

world_width = n*2;  % width of total grid space
world_height = m*2; % height of total grid space

% ~~~~~~~~~~~~~ Cellphone Parameters ~~~~~~~~~~~~~
C_num = 5;   % number of cellphones
C_infected = 1; % number of infected phones

% ~~~~~~~~~~~~~  Router Parameters  ~~~~~~~~~~~~~
R_num = n * m;    % number of routers
R_infected = 1;   % number of infected routers
num_edges = 5;    % number of edges in the router graph

% ~~~~~~~~~~~~~ Probability Parameters ~~~~~~~~~~~~~

% Movement Probabilities
% =======================
movement_probability = 1;

% State Transitions
% =================
%{
S: Susceptible 
N: iNfected
I: Immune
%}
% defines the index for each state
S = 1;
N = 2;
I = 3;

% Cellphone Transition Probabilities
% -----------------------------------

% defines the cellphone transition probabilities from the current state to
% a new state, due to local router state or spontaneity
%                                 S   N   I - transition state 
cellphone_state_transitions = [[ 0.0 1.00 0.01]  % S
                               [ 0.0 0.00 0.05]  % N   
                               [ 0.0 0.00 0.00]];% I - current state

% defines the weighting due to the local router state to be applied to the
% cellphone transition probability
%                            S   N   I - cellphone state 
router_to_cellphone_matrix = [[ 1   0   1  ]  % S
                              [ 0   1   1  ]  % N   
                              [ 0   0   1  ]];% I - router state

% Router Transition Probabilities
% --------------------------------
                        
% defines the router transition probabilities from the current state to
% a new state, due to cellphones or spontanaity
%                              S   N    I - transition state 
router_state_transitions = [[ 0.0 1.00 0.01]  % S
                            [ 0.0 0.00 0.10]  % N   
                            [ 0.0 0.00 0.00]];% I - current state
                                 
% defines the router transition probabilities from the current state to
% a new state, due connected routers as multiplier
%                                    S   N    I - transition state 
router_from_router_transitions = [[ 0.0 1.0  0.5 ]% S
                                  [ 0.0 0.0  0.1 ] % N   
                                  [ 0.0 0.0  0.0 ]];% I - current state

