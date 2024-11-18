% Base predicates
person(P) :- legacyConfig(person(P)).
thing(T) :- legacyConfig(thing(T)).
owner(T,P) :- legacyConfig(personTOthing(P,T)).
cabinet(C) :- cabinetDomainNew(C).
room(R) :- roomDomainNew(R).

% Cabinet types
{ cabinetHigh(C) } :- cabinet(C).
cabinetSmall(C) :- cabinet(C), not cabinetHigh(C).

% Each thing must be in exactly one cabinet
1 { cabinetTOthing(C,T) : cabinet(C) } 1 :- thing(T).

% Each used cabinet must be in exactly one room
1 { roomTOcabinet(R,C) : room(R) } 1 :- cabinet(C), cabinetTOthing(C,_).

% Cabinet capacity constraint (max 5 things per cabinet)
:- #count { T : cabinetTOthing(Cab,T) } > 5, cabinet(Cab).

% Room capacity constraint
roomSlots(R,S) :- room(R), 
    S = #sum { 1,C : roomTOcabinet(R,C), cabinetSmall(C) ;
               2,C : roomTOcabinet(R,C), cabinetHigh(C) }.
:- roomSlots(R,S), S > 4.

% Room ownership constraint
:- roomTOcabinet(R,C1), roomTOcabinet(R,C2),
   cabinetTOthing(C1,T1), cabinetTOthing(C2,T2),
   owner(T1,P1), owner(T2,P2), P1 != P2.

% Define used cabinets and rooms
usedCabinet(C) :- cabinetTOthing(C,_).
usedRoom(R) :- roomTOcabinet(R,_).

% Total cost is sum of used cabinets and rooms
totalCost(TC) :- 
    #count { C : usedCabinet(C) } = CC,
    #count { R : usedRoom(R) } = RC,
    TC = CC + RC.

% Minimize total cost
#minimize { TC : totalCost(TC) }.

% Output predicates
#show cabinetTOthing/2.
#show roomTOcabinet/2.
#show cabinetHigh/1.
#show cabinetSmall/1.
