import PetriKit


public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        let m0 = MarkingGraph(marking: marking)
        // Soit m0 le graphe initial.
        var visited = [m0]
        // On cree un tableau de marquages que l'on a vu
        var toVisit = [m0]
        // On cree un tableau de marquages dont on doit voir les successeurs
        while let presentMarking = toVisit.popLast(){
            // On prend le dernier marquage dans la liste des marquages vus
            for presentTransition in self.transitions{
                if (presentTransition.isFireable(from: presentMarking.marking)){
                    // si on peut tirer une transition à partir de ce marquage
                    // on la tire
                    let nextMark = presentTransition.fire(from: presentMarking.marking)!
                    // Soit nextMark le nouveau marquage qu'on obtient après avoir tiré la transition
                    if(seen(p: nextMark, q: visited)) {
                        // Si le nouveau marquage ne se trouve pas dans la liste des
                        // marquages visités:
                        var nextMarking = MarkingGraph(marking: nextMark)
                        presentMarking.successors[presentTransition] = nextMarking
                        // On definit ce nouveau marquage comme successeur du marquage précédent
                        toVisit.append(nextMarking)
                        // On rajoute ce nouveau marquage dans la liste des marquages
                        // dont il faut voir les successeurs
                        visited.append(nextMarking)
                        // On rajoute ce nouveau marquage dans la liste des marquages déjà vu
                    }
                    else if (nextMark == presentMarking.marking) {
                        // Si le marquage n'est pas nouveau
                        presentMarking.successors[presentTransition] = presentMarking
                        // On le définit juste comme successeur du marquage précédent
                    }
                }
            }
        }
        return visited[0]
    }




    public func seen(p: PTMarking, q: [MarkingGraph]) -> Bool {
        // Cette fonction prend en paramètre un marquage "p" et un graphe de
        // marquage "q". Si jamais le marquage se trouve dans le graphe de
        // marquage, la fonction retourne 'false' pour dire que ce marquage n'est
        // pas nouveau. Sinon elle retourne'true' pour dire qu'elle ne l'a jamais vu.
        for n in q {
            if(n.marking == p){
                return false
                // pour chaque marquage "n" dans le graphe de marquage
                // la boucle vérifie si "n" est égal à "p"
            }
        }
        return true
    }




    public func showGraph(i: MarkingGraph){
        // Cette fonction permet d'afficher le graphe de marquage.
        var visited = [i]
        // Les marquages déjà vus
        var toVisit = [i]
        // Les marquages dont on doit voir les successeurs
        print("Nous obtenons le graphe de marquage suivant:")
        while let present = toVisit.popLast(){
            // On prend le dernier marquage du tableau des marquages à voir
            for (transitions, successors) in present.successors {
                // On regarde chaque transition et successeur du marquages selectionné
                if !visited.contains(where: { $0 === successors}){
                    // Si la liste de marquages vu ne possède pas ce successeur
                    visited.append(successors)
                    // On l'ajoute dans la liste des marquages vus
                    toVisit.append(successors)
                    // On l'ajoute dans la liste des marquages dont il faut regarder
                    // les successeurs
                    print(transitions, "  ", successors.marking)
                    // On print la transition faite, ainsi que le marquage auqel
                    // aboutit la transition

                }
            }
        }
    }




    public func countNodes(markingGraph: MarkingGraph) -> Int {
        // Cette fonction compte le nombre d'états différents que peut prendre le réseau.
        var visited = [markingGraph]
        // les marquages déjà vus
        var toVisit = [markingGraph]
        // les marquages dont on doit voir les successeurs
        while let present = toVisit.popLast(){
            // On prend un marquage dont on a pas encore regarder les successeurs
            for (_, successors) in present.successors{
                if !visited.contains(where: { $0 === successors}) {
                    visited.append(successors)
                    // Si le marquage successeur n'as jamais été vu on le mets
                    // dans la liste des marquages vu
                    toVisit.append(successors)
                    // et dans la liste des marquages dont on doit regarder les successeurs
                }
            }
        }
        return visited.count
        // On compte le nombre total de marquages vus

    }




    public func twoSmokers(m0: MarkingGraph) -> Bool {
        // Cette fonction retourne 'true' ou 'false' si il est possible
        // ou non que deux fumeurs différents puissent fumer en même temps.
        var visited = [m0]
        // Les marquages déjà vus
        var toVisit = [m0]
        // Les marquages dont on doit voir les successeurs
        while let present = toVisit.popLast(){
            for (_, successors) in present.successors{
                if !visited.contains(where: { $0 === successors}){
                    visited.append(successors)
                    toVisit.append(successors)
                    let place1 = self.places.first(where: { $0.name == "s1" })!
                    let place2 = self.places.first(where: { $0.name == "s2" })!
                    let place3 = self.places.first(where: { $0.name == "s3" })!
                    // Soit place1, 2 ,3 la place des fumeurs 1, 2 et 3
                    let smoker1 = (successors.marking[place1] != 0)
                    let smoker2 = (successors.marking[place2] != 0)
                    let smoker3 = (successors.marking[place3] != 0)
                    // Soit smoker 1, 2, 3 des boulléens qui retourne false ou true
                    // False si ils n'ont pas de jetons, true sinon.

                    if smoker1 && smoker2 || smoker1 && smoker3 || smoker3 && smoker2 {
                        // si plus d'un fumeur possède un jeton (est en train de fumer)
                        // la fonction sort true, sinon elle retourne false
                        return true
                    }
                }
            }
        }
        return false
    }




    public func sameIngredient(m0: MarkingGraph) -> Bool {
        // Cette fonction retourne 'true' ou 'false' si il est possible
        // ou non que deux fois le même ingrédient puisse se retrouver
        // sur la table.
        var visited = [m0]
        // les marquages déjà vus
        var toVisit = [m0]
        // Les marquages dont on doit voir les successeurs
        while let present = toVisit.popLast(){
            for (_, successors) in present.successors{
                if !visited.contains(where: { $0 === successors}){
                    visited.append(successors)
                    toVisit.append(successors)
                    let place1 = self.places.first(where: { $0.name == "p" })!
                    let place2 = self.places.first(where: { $0.name == "m" })!
                    let place3 = self.places.first(where: { $0.name == "t" })!
                    // Soit place 1 , 2 ,3 les places des ingrédients paper , matches
                    // et tabaco respectivement
                    let ingr1 = successors.marking[place1]
                    let ingr2 = successors.marking[place2]
                    let ingr3 = successors.marking[place3]
                    // Si un ingrédient possède plus d'un jeton la fonction
                    // retourne true, sinon false
                    if ingr1! > 1 || ingr2! > 1 || ingr3! > 1 {
                        return true
                    }
                }
            }
        }
        return false
    }

}
