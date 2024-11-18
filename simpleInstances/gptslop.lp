% Define persons and things based on instance data
person(P) :- legacyConfig(person(P)).
thing(T) :- legacyConfig(thing(T)).

% Ownership of things by persons
personTOthing(P, T) :- legacyConfig(personTOthing(P, T)).

% Define available domains for new cabinets and rooms
%cabinetDomainNew(C) :- legacyConfig(cabinetDomainNew(C)).
%roomDomainNew(R) :- legacyConfig(roomDomainNew(R)).
%
% Define which things are short or long
%thingShort(T) :- legacyConfig(thingShort(T)).
%thingLong(T) :- legacyConfig(thingLong(T)).
%
% Cost definitions from instance file
%reuseCabinetTOthingCost(Cost) :- legacyConfig(reuseCabinetTOthingCost(Cost)).
%reuseRoomTOcabinetCost(Cost) :- legacyConfig(reuseRoomTOcabinetCost(Cost)).
%reusePersonTOroomCost(Cost) :- legacyConfig(reusePersonTOroomCost(Cost)).
%reuseCabinetAsHighCost(Cost) :- legacyConfig(reuseCabinetAsHighCost(Cost)).
%reuseCabinetAsSmallCost(Cost) :- legacyConfig(reuseCabinetAsSmallCost(Cost)).
%reuseRoomCost(Cost) :- legacyConfig(reuseRoomCost(Cost)).
%removeCabinetTOthingCost(Cost) :- legacyConfig(removeCabinetTOthingCost(Cost)).
%removeRoomTOcabinetCost(Cost) :- legacyConfig(removeRoomTOcabinetCost(Cost)).
%removePersonTOroomCost(Cost) :- legacyConfig(removePersonTOroomCost(Cost)).
%removeCabinetCost(Cost) :- legacyConfig(removeCabinetCost(Cost)).
%removeRoomCost(Cost) :- legacyConfig(removeRoomCost(Cost)).
%cabinetHighCost(Cost) :- legacyConfig(cabinetHighCost(Cost)).
%cabinetSmallCost(Cost) :- legacyConfig(cabinetSmallCost(Cost)).
%roomCost(Cost) :- legacyConfig(roomCost(Cost)).
%
% Use the specified cabinet and room domains
{ cabinet(C) : cabinetDomainNew(C) }.
{ room(R) : roomDomainNew(R) }.

% Constraints for assigning things to cabinets and defining cabinet types
1 { cabinetTOthing(C, T) : cabinet(C) } 1 :- thing(T).
cabinetHigh(C) :- cabinetTOthing(C, T), thingLong(T).
cabinetSmall(C) :- cabinet(C), not cabinetHigh(C).

% Room constraints
roomTOcabinet(R, C) :- room(R), cabinet(C).
:- roomTOcabinet(R, C), cabinetHigh(C), countHigh(R, N), N > 4.

% Cost minimization
#minimize {
    cabinetHighCost * #count { C : cabinetHigh(C) },
    cabinetSmallCost * #count { C : cabinetSmall(C) },
    roomCost * #count { R : room(R) }
}.

% Auxiliary definition for counting high cabinets
countHigh(R, N) :- N = #count { C : roomTOcabinet(R, C), cabinetHigh(C) }.
%
%
#show cabinet/1.
#show room/1.
#show cabinetTOthing/2.
#show roomTOcabinet/2.
#show cost/1.

