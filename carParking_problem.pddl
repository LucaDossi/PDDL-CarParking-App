(define (problem parking_problem) (:domain parking_car)
(:objects 
    c1
    c2
    c3
    c4 
    c5
    c6
    c7
    c8
    c9 - car

    p1
    p2
    p3 - park

    t1
    t2
    t3 - tempPark

    r1
    r2
    r3 - row
)

(:init
    
    (= (carCounter r1) 3)
    (= (carCounter r2) 3)
    (= (carCounter r3) 3)

    
    (isParkedIn c7 p1)
    (isParkedIn c4 p2)
    (isParkedIn c2 p3)

    (isBehind c1 c7)
    (isBehind c5 c4)
    (isBehind c9 c2)

    (isBehind c8 c1)
    (isBehind c3 c5)
    (isBehind c6 c9)

    (isClear c8)
    (isClear c3)
    (isClear c6)

    (isTempFree t1)
    (isTempFree t2)
    (isTempFree t3)

    (isInRow c7 r1)
    (isInRow c1 r1)
    (isInRow c8 r1)
    
    (isInRow c4 r2)
    (isInRow c5 r2)
    (isInRow c3 r2)
    
    (isInRow c2 r3)
    (isInRow c9 r3)
    (isInRow c6 r3)
 
    (rowNumber p1 r1)
    (rowNumber p2 r2)
    (rowNumber p3 r3)

)


(:goal (and
    (isParkedIn c1 p1)
    (isParkedIn c2 p2)
    (isParkedIn c3 p3)
    
    (isBehind c4 c1)
    (isBehind c5 c2)
    (isBehind c6 c3)

    (isBehind c7 c4)
    (isBehind c8 c5)
    (isBehind c9 c6)

))

(:metric minimize (total-cost))

)