import PetriKit
import PhilosophersLib

print()

do {
    print("1. Combien y a-t-il de marquages possibles dans le modèle des philosophes")
    print("   non bloquable à 5 philosophes ?")
    let question1 = lockFreePhilosophers(n: 5)
    // let philosophers = lockablePhilosophers(n: 3)
    let marking_graph_1 = question1.markingGraph(from: question1.initialMarking!)
    print("   Il y a ",marking_graph_1!.count, "marquages possibles.\n")
    /*for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)*/
    print("2. Combien y a-t-il de marquages possibles dans le modèle des philosophes")
    print("   bloquable à 5 philosophes ?")
    let question2 = lockablePhilosophers(n: 5)
    let marking_graph_2 = question2.markingGraph(from: question2.initialMarking!)
    print("   Il y a ",marking_graph_2!.count, "marquages possibles.\n")

    print("3. Donnez un exemple d'état où le réseau est bloqué dans le modèle ")
    print("   des philosophes bloquable à 5 philosophes.")
    let question3 = lockablePhilosophers(n: 5)
    let marking_graph_3 = question3.markingGraph(from: question3.initialMarking!)
    for markings in marking_graph_3! {
        var successorsAbsent = true
        for (_, successorsByBinding) in markings.successors {
            if !(successorsByBinding.isEmpty){
                successorsAbsent = false
            }
         }
         if (successorsAbsent) {
             print("   Un exemple d'état où le réseau est bloqué est:")
             print("  ",markings.marking)
             break
         }
    }
    print("\n")
}
