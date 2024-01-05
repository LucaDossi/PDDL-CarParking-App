(define (domain parking_car)
    (:requirements :typing :fluents)

(:types
    
    car
    park
    tempPark
    row
)

(:predicates

    ;a car is parked in a certain parking spot
    (isParkedIn ?c - car ?p - park)
    ;car c1 is parked behind car c2
    (isBehind ?c1 ?c2 - car)
    ;a car c is free to move
    (isClear ?c - car)
    ;a parking spot p is free, there is no car parked on it
    (isFree ?p - park)
    ;a temporary park is free when there is no car parked on it
    (isTempFree ?tp - tempPark)
    ;a car c is parked in a temporary park
    (isParkedInTemp ?c -car ?tp - tempPark)
    ;a car is placed in a certain row
    (isInRow ?c -car ?r - row)
    ;a parking spot is placed in a certain row
    (rowNumber ?p -park ?r - row)
)

(:functions
    ;count the number of car in a row
    (carCounter ?r -row)
    (total-cost)

)

;a car c moves from a parking spot to another when that spot is free and the car c is able to move
(:action move_park_to_park
    :parameters (?c -car ?p1 ?p2 - park ?r1 ?r2 - row)
    :precondition (and 
                    (isParkedIn ?c ?p1)
                    (isClear ?c)
                    (isFree ?p2)
                    (isInRow ?c ?r1)
                    (rowNumber ?p2 ?r2)
                    )
    :effect (and
            (not (isParkedIn ?c ?p1))
            (isParkedIn ?c ?p2)
            (isFree ?p1)
            (not (isFree ?p2))
            (not (isInRow ?c ?r1))
            (isInRow ?c ?r2)
                (increase (carCounter ?r2) 1)
                (decrease (carCounter ?r1) 1)
                (increase (total-cost) 1)
            )
)

;a car c1 moves from a parking spot p to behind a car c2
(:action move_park_to_behind_car
    :parameters (?c1 ?c2 -car ?p - park ?r1 ?r2 - row) 
    :precondition (and
                    (isParkedIn ?c1 ?p)
                    (isClear ?c1)
                    (isClear ?c2)
                    (isInRow ?c1 ?r1)
                    (isInRow ?c2 ?r2)
                        (< (carCounter ?r2) 3)
                    )
    :effect (and
            (not (isParkedIn ?c1 ?p))
            (isBehind ?c1 ?c2)
            (not (isClear ?c2))
            (isFree ?p)
            (not (isInRow ?c1 ?r1))
            (isInRow ?c1 ?r2)
                (increase (carCounter ?r2) 1)
                (decrease (carCounter ?r1) 1)
                (increase (total-cost) 1)
            )
)

;a car c1 moves from behind a car c2 to a free parking spot p
(:action move_behind_car_to_park
    :parameters (?c1 ?c2 - car ?p - park ?r1 ?r2 - row)
    :precondition (and 
                    (isBehind ?c1 ?c2)
                    (isClear ?c1)
                    (isFree ?p)
                    (isInRow ?c1 ?r1)
                    (isInRow ?c2 ?r1)
                    (rowNumber ?p ?r2)
                    )
    :effect (and 
            (isParkedIn ?c1 ?p)
            (not (isBehind ?c1 ?c2))
            (isClear ?c2)
            (not (isFree ?p))
            (not (isInRow ?c1 ?r1))
            (isInRow ?c1 ?r2)
                (increase (carCounter ?r2) 1)
                (decrease (carCounter ?r1) 1)
                (increase (total-cost) 1)
            )
)

;a car c1 moves from behind a car c2 to behind a car c3
(:action move_behind_car_to_behind_car
    :parameters (?c1 ?c2 ?c3 -car ?r1 ?r2 - row)
    :precondition (and 
                    (isBehind ?c1 ?c2)
                    (isClear ?c1)
                    (isClear ?c3)
                    (isInRow ?c1 ?r1)
                    (isInRow ?c2 ?r1)
                    (isInRow ?c3 ?r2)
                        (< (carCounter ?r2) 3)
                    )
    :effect (and
            (not (isBehind ?c1 ?c2))
            (isBehind ?c1 ?c3)
            (isClear ?c2)
            (not (isClear ?c3))
            (not (isInRow ?c1 ?r1))
            (isInRow ?c1 ?r2)
                (increase (carCounter ?r2) 1)
                (decrease (carCounter ?r1) 1)
                (increase (total-cost) 1)
            )
)


;a car c moves from a park p to a temporary park tp
(:action move_from_park_to_tempPark
    :parameters (?c - car ?p - park ?tp - tempPark ?r - row)
    :precondition (and 
                    (isParkedIn ?c ?p)
                    (isClear ?c)
                    (isTempFree ?tp)
                    (isInRow ?c ?r)
                    )
    :effect (and 
            (not (isParkedIn ?c ?p))
            (isFree ?p)
            (not (isTempFree ?tp))
            (isParkedInTemp ?c ?tp)
            (not (isInRow ?c ?r))
                (decrease (carCounter ?r) 1)
                (increase (total-cost) 1)
            )
)

;a car c1 moves from behind a car c2 to a temporary park tp
(:action move_from_behind_car_to_tempPark
    :parameters (?c1 ?c2 -car ?tp - tempPark ?r - row)
    :precondition (and 
                    (isBehind ?c1 ?c2)
                    (isClear ?c1)
                    (isTempFree ?tp)
                    (isInRow ?c1 ?r)
                    (isInRow ?c2 ?r)
                    )
    :effect (and
            (not (isBehind ?c1 ?c2))
            (isClear ?c2)
            (not (isTempFree ?tp))
            (isParkedInTemp ?c1 ?tp)
            (not (isInRow ?c1 ?r))
                (decrease (carCounter ?r) 1)
                (increase (total-cost) 1)
            )
)

;a car c moves from a temporary park tp to a free park p
(:action move_from_tempPark_to_park
    :parameters (?c -car ?p -park ?tp - tempPark ?r - row)
    :precondition (and
                    (isFree ?p)
                    (isParkedInTemp ?c ?tp)
                    (rowNumber ?p ?r)
                    )
    :effect (and
            (isParkedIn ?c ?p)
            (not (isFree ?p))
            (isTempFree ?tp)
            (not (isParkedInTemp ?c ?tp))
            (isInRow ?c ?r)
                (increase (carCounter ?r) 1)
                (increase (total-cost) 1)
            )
)

;a car c1 moves from a temporary park tp to behind a car c2
(:action move_from_tempPark_to_behind_car
    :parameters (?c1 ?c2 - car ?tp - tempPark ?r - row)
    :precondition (and
                    (isClear ?c2)
                    (isParkedInTemp ?c1 ?tp)
                    (isInRow ?c2 ?r)
                    )
    :effect (and
            (isBehind ?c1 ?c2)
            (not (isClear ?c2))
            (isTempFree ?tp)
            (not (isParkedInTemp ?c1 ?tp))
            (isInRow ?c1 ?r)
                (increase (carCounter ?r) 1)
                (increase (total-cost) 1)
            )
)
)