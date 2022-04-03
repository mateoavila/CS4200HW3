construction_type(door;wall;floor;bed).

0 {construction(XX, YY, CONSTRUCTION_TYPE) : construction_type(CONSTRUCTION_TYPE)} 1 :-
    width(XX),
    height(YY),
    terrain(XX, YY, grass).

0 {construction(XX, YY, CONSTRUCTION_TYPE) : construction_type(CONSTRUCTION_TYPE)} 1 :-
    width(XX),
    height(YY),
    terrain(XX, YY, flower).  


construction_neighbors(XX, YY, TYPE, COUNT) :-
    COUNT = {construction(XX-1, YY-1, TYPE);
             construction(XX, YY-1, TYPE);
             construction(XX+1, YY-1, TYPE);
             construction(XX-1, YY, TYPE);
             construction(XX+1, YY, TYPE);
             construction(XX-1, YY+1, TYPE);
             construction(XX, YY+1, TYPE);
             construction(XX+1, YY+1, TYPE)},
             construction(XX, YY, _),
             construction_type(TYPE).

immediate_construction_neighbors(XX, YY, TYPE, COUNT) :-
    COUNT = {construction(XX, YY-1, TYPE);
             construction(XX-1, YY, TYPE);
             construction(XX+1, YY, TYPE);
             construction(XX, YY+1, TYPE)},
             construction(XX, YY, _),
             construction_type(TYPE).

door_reachable(XX, YY) :- construction(XX, YY, door).
door_reachable(XX, YY) :- door_reachable(XX+1, YY), construction(XX, YY, wall).
door_reachable(XX, YY) :- door_reachable(XX-1, YY), construction(XX, YY, wall).
door_reachable(XX, YY) :- door_reachable(XX, YY+1), construction(XX, YY, wall).
door_reachable(XX, YY) :- door_reachable(XX, YY-1), construction(XX, YY, wall).

bed_reachable(XX, YY) :- construction(XX, YY, bed).
bed_reachable(XX, YY) :- bed_reachable(XX+1, YY), construction(XX, YY, floor).
bed_reachable(XX, YY) :- bed_reachable(XX-1, YY), construction(XX, YY, floor).
bed_reachable(XX, YY) :- bed_reachable(XX, YY+1), construction(XX, YY, floor).
bed_reachable(XX, YY) :- bed_reachable(XX, YY-1), construction(XX, YY, floor).

% wall
:- construction(XX, YY, wall), immediate_construction_neighbors(XX, YY, wall, W_COUNT), immediate_construction_neighbors(XX, YY, door, D_COUNT), W_COUNT + D_COUNT != 2.

:- construction(XX, YY, wall), construction_neighbors(XX, YY, floor, F_COUNT), construction_neighbors(XX, YY, bed, B_COUNT), F_COUNT + B_COUNT < 1.
:- construction(XX, YY, wall), construction_neighbors(XX, YY, floor, F_COUNT), construction_neighbors(XX, YY, bed, B_COUNT), F_COUNT + B_COUNT > 5.

:- construction(XX, YY, wall), construction_neighbors(XX, YY, wall, W_COUNT), construction_neighbors(XX, YY, door, D_COUNT), W_COUNT + D_COUNT > 4.
:- construction(XX, YY, wall), construction_neighbors(XX, YY, wall, W_COUNT), construction_neighbors(XX, YY, door, D_COUNT), W_COUNT + D_COUNT < 2.

:- construction(XX, YY, wall), not door_reachable(XX, YY).

% door
:- {construction(XX, YY, door)} 1.

:- construction(XX, YY, door), construction_neighbors(XX, YY, door, D_COUNT), D_COUNT != 0.

:- construction(XX, YY, door), immediate_construction_neighbors(XX, YY, wall, W_COUNT), W_COUNT != 2.

:- construction(XX, YY, door), immediate_construction_neighbors(XX, YY, floor, F_COUNT), immediate_construction_neighbors(XX, YY, bed, B_COUNT), F_COUNT + B_COUNT != 1.

:- construction(XX, YY, door), neighbors(XX, YY, water, W_COUNT), neighbors(XX, YY, bridge, B_COUNT), neighbors(XX, YY, tree, T_COUNT), W_COUNT + B_COUNT + T_COUNT != 0.

% floor
:- construction(XX, YY, floor), construction_neighbors(XX, YY, door, D_COUNT), construction_neighbors(XX, YY, wall, W_COUNT), construction_neighbors(XX, YY, floor, F_COUNT), 
    construction_neighbors(XX, YY, bed, B_COUNT), D_COUNT + W_COUNT + F_COUNT + B_COUNT != 8.

:- construction(XX, YY, floor), not bed_reachable(XX, YY).

% bed
:- {construction(XX, YY, bed)} 1.

:- construction(XX, YY, bed), construction_neighbors(XX, YY, wall, W_COUNT), construction_neighbors(XX, YY, door, D_COUNT), construction_neighbors(XX, YY, floor, F_COUNT), 
    construction_neighbors(XX, YY, bed, B_COUNT), W_COUNT + D_COUNT + F_COUNT + B_COUNT != 8.
