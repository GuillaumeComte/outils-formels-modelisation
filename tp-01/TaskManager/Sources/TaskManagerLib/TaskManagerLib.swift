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
    let stop        = PTPlace(named: "stop")
    // On ajoute une place appelé stop qui permettra d'executer une tâche
    // avec un seul et unique processus seulement. Le nombre de jeton
    // dans stop représentera le nombre de tâches différentes dans
    // taskPool.

    // Transitions
    let create      = PTTransition(
        named          : "create",
        preconditions  : [],
        postconditions : [PTArc(place: taskPool), PTArc(place: stop)])
    // une post condition de create est "stop" cela permet qu'à chaque fois
    // qu'on crée une tache qu'un jeton s'ajoute aussi dans stop, ainsi chaque
    // jeton dans stop représentera chaques tâches différentes.

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
        preconditions  : [PTArc(place: taskPool), PTArc(place: processPool), PTArc(place: stop)],
        postconditions : [PTArc(place: taskPool), PTArc(place: inProgress)])
    // j'ai ajouté la précondition stop à la transitions exec.
    // Le nombre de jetons dans stop représente le nombre de tâches différentes
    // de ce fait pour qu'une tache soit executée, stop doit posséder un jeton
    // Si une tache souhaite être executer et que stop ne possède pas de jeton
    // cela signifie que la têche est déjà en cours d'éxecution avec un processus.

    let fail        = PTTransition(
        named          : "fail",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [PTArc(place: stop)])

    // Pour la transition fail j'ai ajouté 1 postcondition allant vers
    // la place stop, pour qu'une tâche puisse être re-executer après avoir échouée
    // Elle sera re exécuté lorsqu'il y aura un processus dans processPool. 


    // P/T-net
    return PTNet(
         places: [taskPool, processPool, inProgress, stop],
         transitions: [create, spawn, success, exec, fail])
}
