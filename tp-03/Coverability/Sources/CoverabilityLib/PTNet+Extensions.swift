import PetriKit

public extension PTNet {

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        let m0 = CoverabilityGraph(marking: marking)
        var visited = [CoverabilityGraph]()
        var toVisit = [m0]

        while let presentMarking = toVisit.popLast(){
            // pour chaque marquage de couverture à visiter
            let m1 = ptmarkfunc(from: presentMarking.marking)
            // On convertie presentMarking en marquage (comme pour construire un graphe de marquage)
            // "if presentTransition.isFireable(from: presentMarking)" ne fonctionne pas si
            // presentMarking est un marquage de couverture
            // c'est pour cela que l'on a transformé presentMarking en un simple
            // marquage nommé m1
            for presentTransition in self.transitions{
                // pour chaque transition qui existe
                if let m2 = presentTransition.fire(from: m1){
                    // Si la transition est tirable, on appelle m2 le successeur de m1
                    var nextMark = coverabilityfunc(from: m2)
                    // la comparaison de jeton ne pouvant se faire qu'entre marquages
                    // de couverture, on transforme m2 en marquage de couverture
                    // que l'on appelle nextMark
                    for previousMarking in m0{
                        // pour chaque marquage que l'on a eu précédement
                        if nextMark > previousMarking.marking{
                            // si le marquage que l'on a eu après la transition est
                            // supérieur au marquage précédent séléctionné
                            for place in self.places{
                                // Alors pour chaque place qui existe
                                if nextMark[place]! > previousMarking.marking[place]!{
                                    // On regarde quelle place précise du marquage obtenu
                                    // possède plus de jeton que le marquage précédent
                                    nextMark[place] = .omega
                                    // et pour cette place là nous mettons un omega.
                                }
                            }
                        }
                    }
                    if toVisit.contains(where: {$0.marking == nextMark}) {
                        // Si la liste de marquage à visiter possède le marquage que nous avons obtenu en tirant
                        // la transition
                    presentMarking.successors.updateValue(toVisit.first(where: {$0.marking == nextMark})!, forKey: presentTransition)
                    }
                    else if visited.contains(where: {$0.marking == nextMark}) {
                        // Si la liste de marquage déjà visité possède le marquage que nous avons obtenu en tirant
                        // la transition
                    presentMarking.successors.updateValue(visited.first(where: {$0.marking == nextMark})!, forKey: presentTransition)
                    }
                    else {
                        // Sinon
                    let newMark = CoverabilityGraph(marking : nextMark)
                    // Soit newMark le graphe de couverture du marquage obtenu
                    toVisit.append(newMark)
                    // On le rajoute dans la liste des marquages à visiter plus tard
                    presentMarking.successors.updateValue(newMark, forKey: presentTransition)
                    // Et on le met comme successeur de lu marquage initialement choisi.
                    }
                }
            }
            visited.append(presentMarking)
            // On mets dans la liste des marquages visités le marquage que nous avons choisis initialement
        }
        return m0
    }

    public func ptmarkfunc(from marking: CoverabilityMarking) -> PTMarking {
        // Pour transformer un marquage de couverture en un marquage tout court
         var resultat : PTMarking = [:]
         for place in self.places {

           resultat[place] = 100
           for n in 0...100 {
               // Nous parcourons ici les places une à une
             if UInt(n) == marking[place]!{

               resultat[place] = UInt(n)
             }
           }
         }
         return resultat
    }

    public func coverabilityfunc(from marking: PTMarking) -> CoverabilityMarking {
        // Pour transformer un marquage en un marquage de couverture
      var resultat : CoverabilityMarking = [:]
      for place in self.places {

          let nbrjetonmax : Int = 100
          if marking[place]! < nbrjetonmax{
            // Pour chaque place dans marking, si la place possède moins de 5 jetons.
           resultat[place] = .some(marking[place]!)
           // On laisse le nombre de jetons dans la place (UInt)
            }
            else {
            // Si le nombre de jeton dépasse 5
            resultat[place] = .omega
          // On met à cette place un omega
            }
        }
        return resultat
      // On retourne le marquage de couverture à la fin de la procédure
    }

}
