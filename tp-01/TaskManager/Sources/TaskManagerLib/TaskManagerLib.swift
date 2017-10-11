import PetriKit

public func createTaskManager() -> PTNet {
    // Places
    let taskPool    = PTPlace(named: "taskPool")
    let processPool = PTPlace(named: "processPool")
    let inProgress  = PTPlace(named: "inProgress")

    // Transitions
    let create      = PTTransition(
        named          : "create",
        preconditions  : [],
        postconditions : [PTArc(place: taskPool)])
    let spawn       = PTTransition(
        named          : "spawn",
        preconditions  : [],
        postconditions : [PTArc(place: processPool)])
    let success     = PTTransition(
        named          : "success",
        preconditions  : [PTArc(place: taskPool), PTArc(place: inProgress)],
        postconditions : [])
    let exec       = PTTransition(
        named          : "exec",
        preconditions  : [PTArc(place: taskPool), PTArc(place: processPool)],
        postconditions : [PTArc(place: taskPool), PTArc(place: inProgress)])
    let fail        = PTTransition(
        named          : "fail",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [])

    // P/T-net
    return PTNet(
        places: [taskPool, processPool, inProgress],
        transitions: [create, spawn, success, exec, fail])
}


public func createCorrectTaskManager() -> PTNet {
    // Places
    let taskPool    = PTPlace(named: "taskPool")
    let processPool = PTPlace(named: "processPool")
    let inProgress  = PTPlace(named: "inProgress")

    // Transitions
    let create      = PTTransition(
        named          : "create",
        preconditions  : [],
        postconditions : [PTArc(place: taskPool)])
    let spawn       = PTTransition(
        named          : "spawn",
        preconditions  : [],
        postconditions : [PTArc(place: processPool)])
    let success     = PTTransition(
        named          : "success",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [])
    // On enlève la pré-condition taskPool de success pour qu'une execution
    // puisse être réussi sans avoir un jeton dans taskPool 
    let exec       = PTTransition(
        named          : "exec",
        preconditions  : [PTArc(place: taskPool), PTArc(place: processPool)],
        postconditions : [PTArc(place: inProgress)])
    // j'ai retiré la postcondition taskPool qui permettait une tâches de
    // s'executer plusieurs fois si on avait plusieurs processus et de ce fait
    // laisser un jeton dans inProgress alors qu'il n'y a rien dans taskPool
    // permettant de réussir l'execution.

    let fail        = PTTransition(
        named          : "fail",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [PTArc(place: processPool), PTArc(place: taskPool)])

    // Pour la transition fail j'ai ajouté 2 postcondition, 1 allant vers
    // processPool, pour que le processus retourne dans
    // l'ensemble des processus après que l'éxecution. De cette manière si
    // l'exécution échoue il est possible de ré-executer la tâche.
    // ET 1 allant à taskPool pour que la tâche qui n'a pas pu être executé
    // retourne dans l'ensemble des tâches

    // P/T-net
    return PTNet(
         places: [taskPool, processPool, inProgress],
         transitions: [create, spawn, success, exec, fail])
}
