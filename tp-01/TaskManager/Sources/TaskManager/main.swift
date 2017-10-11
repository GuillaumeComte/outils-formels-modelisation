import TaskManagerLib
import PetriKit


let taskManager = createTaskManager()
// On définit les places et les transitions
let taskPool = taskManager.places.first { $0.name == "taskPool" }!
let processPool = taskManager.places.first { $0.name == "processPool" }!
let inProgress = taskManager.places.first { $0.name == "inProgress" }!

let create = taskManager.transitions.first { $0.name == "create" }!
let spawn = taskManager.transitions.first { $0.name == "spawn" }!
let exec = taskManager.transitions.first { $0.name == "exec" }!
let success = taskManager.transitions.first { $0.name == "success" }!
let fail = taskManager.transitions.first { $0.name == "fail" }!


print("Voici un exemple d'execution qui conduit à un problème:")
var m0 : PTMarking = [taskPool: 0, processPool: 0, inProgress: 0]
    let m1 = create.fire(from: m0)!
    print(m1)
    // On crée une tâche
    let m2 = spawn.fire(from: m1)!
    print(m2)
    // On crée un processus
    let m3 = spawn.fire(from: m2)!
    print(m3)
    // On crée un second processus
    let m4 = exec.fire(from: m3)!
    print(m4)
    // On execute la tâche
    let m5 = exec.fire(from: m4)!
    print(m5)
    // On execute à nouveau la même tâche
print ("Il y a deux jetons dans inProgress, la même tache a été executé 2 fois")
print ("avec deux processus différents")
    let m6 = success.fire(from: m5)!
    print(m6)
    // On réussi la tâche, mais il reste un jeton dans inProgress


print ("il n'y a plus de jeton dans taskPool, ni dans processPool")
print ("Mais il reste un jeton dans inProgress, alors que la tâche est déjà ")
print ("réussie")
print ("\n")

    // La même tâche peut etre executé plusieurs fois par deux processus
    // différents, cela empêche donc la réussite d'un processus en cours.
    // Il faut donc faire en sorte que la même tâche ne puisse pas s'executer
    // plusieurs fois avec plus d'un processus.


// La problème corrigé
let correctTaskManager = createCorrectTaskManager()
// On définit les places et les transitions
let correctTaskPool = correctTaskManager.places.first { $0.name == "taskPool" }!
let correctProcessPool = correctTaskManager.places.first { $0.name == "processPool" }!
let correctInProgress = correctTaskManager.places.first { $0.name == "inProgress" }!
let correctStop = correctTaskManager.places.first { $0.name == "stop" }!

let correctCreate = correctTaskManager.transitions.first { $0.name == "create" }!
let correctSpawn = correctTaskManager.transitions.first { $0.name == "spawn" }!
let correctExec = correctTaskManager.transitions.first { $0.name == "exec" }!
let correctSuccess = correctTaskManager.transitions.first { $0.name == "success" }!
let correctFail = correctTaskManager.transitions.first { $0.name == "fail" }!

print("Voici le problème corrigé:")
var m00 : PTMarking = [correctTaskPool: 0, correctProcessPool: 0, correctInProgress: 0, correctStop: 0]
    let m11 = correctCreate.fire(from: m00)!
    print(m11)
    // On crée une tâche, et on mets un jeton dans stop
    let m22 = correctSpawn.fire(from: m11)!
    print(m22)
    // On crée un processus
    let m33 = correctSpawn.fire(from: m22)!
    print(m33)
    // On crée un second processus
    let m44 = correctExec.fire(from: m33)!
    print(m44)
    // On execute la tâche

    // On ne peut pas executer la tache une seconde fois avec un autre processus
    // car il n'y a plus de jetons dans stop
    // Le problème est donc corrigé, de plus si l'éxecution échoue,
    // un jeton retournera dans stop ce qui permettra de re-executer la tache
    // qui a échoué
    // Si l'éxecution réussi, la tache et le processus seront détruits, ainsi
    // que le jeton dans stop.

print ("il reste 1 jeton dans taskPool, 1 jeton dans processPool,")
print ("1 jeton dans inProgress et 0 jeton dans stop. Le problème est corrigé, ")
print ("on ne peut donc plus executer la même tâche plusieurs fois avec deux  ")
print ("processus différents, car il faut un jeton dans stop pour executer une")
print ("tâche. ")
print ("\n")
