import PetriKit
import SmokersLib

// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" })
else {
    fatalError("invalid model")
}



// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {
    print("Avec comme marquage de départ:\n      ", initialMarking)
    model.showGraph(i: markingGraph)
    // Write here the code necessary to answer questions of Exercise 4.
    print(" \n")


    // 1. Combien d'états différents votre réseau peut-il avoir ?
    let nodes = model.countNodes(markingGraph: markingGraph)
    print("1. Combien d'états différents votre réseau peut-il avoir ?")
    print("Le réseau peut avoir ",nodes, " états différents.\n")

    // 2. Est-il possible que deux fumeurs différents fument en même temps ?
    print("2. Est-il possible que deux fumeurs différents fument en même temps ?")
    let many = model.twoSmokers(m0: markingGraph)
    if many == true {
        print("Oui, il est possible que deux fumeurs différents fument en même temps. \n")
    } else {
        print("Non, il n'est pas possible que deux fumeurs fument en même temps. \n")
    }

    // 3. Est-il possible d'avoir deux fois le même ingrédient sur la table ?
    print("3. Est-il possible d'avoir deux fois le même ingrédient sur la table ?")
    let ingredient = model.sameIngredient(m0: markingGraph)
    if ingredient == true {
        print("Oui, il est possible d'avoir deux fois le même ingrédient sur la table. \n")
    } else {
        print("Non, il n'est pas possible d'avoir deux fois le même ingrédient sur la table. \n")
    }
}
