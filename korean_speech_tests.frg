#lang forge/froglet
open "korean_speech.frg"

//=============================================================================
// ASSERTIONS: NECESSARY CONDITIONS
//=============================================================================
// These assertions verify that each individual rule is properly enforced
// by the wellformed predicate

// Basic structure validation assertions
assert basicStructureValid is necessary for wellformed

// Pronoun rule assertions
assert seniorListenerUsesJeo is necessary for wellformed
assert juniorListenerUsesNa is necessary for wellformed
assert equalListenerUsesNa is necessary for wellformed

// Verb form rule assertions
assert seniorReferentUsesHonorific is necessary for wellformed
assert juniorReferentUsesBase is necessary for wellformed
assert equalReferentUsesBase is necessary for wellformed
assert noReferentSeniorListenerUsesHonorific is necessary for wellformed
assert noReferentJuniorListenerUsesBase is necessary for wellformed

// Speech level rule assertions
assert seniorFormalUsesHapsioche is necessary for wellformed
assert seniorPoliteUsesHaeyoche is necessary for wellformed
assert seniorCasualUsesHaeyoche is necessary for wellformed
assert juniorFormalUsesHaeyoche is necessary for wellformed
assert juniorCasualUsesHaeche is necessary for wellformed
assert equalFormalUsesHaeyoche is necessary for wellformed
assert equalCasualUsesHaeche is necessary for wellformed

//=============================================================================
// TEST PREDICATES: VALID CONFIGURATIONS
//=============================================================================
// These predicates describe valid configurations that should be satisfiable

// Senior listener in a formal setting
pred seniorFormalCase {
  some u: Utterance | {
    u.listener.relativeRank = Senior
    u.setting = Formal
  }
  wellformed
}

// Junior listener in a casual setting
pred juniorCasualCase {
  some u: Utterance | {
    u.listener.relativeRank = Junior
    u.setting = Casual
  }
  wellformed
}

// Equal-ranked listener in a polite setting
pred equalPoliteCase {
  some u: Utterance | {
    u.listener.relativeRank = Equal
    u.setting = Polite
  }
  wellformed
}

// Utterance with a senior referent
pred withSeniorReferentCase {
  some u: Utterance | {
    some u.referent
    u.referent.relativeRank = Senior
  }
  wellformed
}

//=============================================================================
// TEST PREDICATES: INVALID CONFIGURATIONS
//=============================================================================
// These predicates describe invalid configurations that should be
// unsatisfiable when combined with wellformed

// Incorrect pronoun for senior listener (Na instead of Jeo)
pred invalidSeniorPronoun {
  some u: Utterance | {
    u.listener.relativeRank = Senior
    u.speaker.pronoun = Na
  }
}

// Incorrect verb form for junior listener (Honorific instead of Base)
pred invalidJuniorVerbForm {
  some u: Utterance | {
    no u.referent
    u.listener.relativeRank = Junior
    u.verbForm = Honorific
  }
}

// Incorrect speech level for senior in formal setting (Haeche instead of Hapsioche)
pred invalidSpeechLevel {
  some u: Utterance | {
    u.listener.relativeRank = Senior
    u.setting = Formal
    u.speechLevel = Haeche
  }
}

//=============================================================================
// TEST-EXPECT BLOCKS
//=============================================================================
// These test blocks verify that valid configurations are satisfiable
// and invalid ones are unsatisfiable when combined with wellformed

test expect {
  // Valid configurations should be satisfiable
  validSeniorFormal: {seniorFormalCase} is sat
  validJuniorCasual: {juniorCasualCase} is sat
  validEqualPolite: {equalPoliteCase} is sat
  validWithReferent: {withSeniorReferentCase} is sat
  
  // Invalid configurations should be unsatisfiable when combined with wellformed
  invalidSeniorPronouns: {invalidSeniorPronoun and wellformed} is unsat
  invalidJuniorVerbs: {invalidJuniorVerbForm and wellformed} is unsat
  invalidSpeechLevels: {invalidSpeechLevel and wellformed} is unsat
}

//=============================================================================
// EXAMPLE INSTANCES
//=============================================================================
// These examples demonstrate concrete instances that satisfy the model

// Example: A formal conversation with a senior listener
example formalSeniorExample is {wellformed} for {
  RelativeRankToSpeaker = `Senior0 + `Junior0 + `Equal0
  Senior = `Senior0
  Junior = `Junior0
  Equal = `Equal0
  
  Pronoun = `Na0 + `Jeo0
  Na = `Na0
  Jeo = `Jeo0
  
  SpeechLevel = `Haeche0 + `Haeyoche0 + `Hapsioche0
  Haeche = `Haeche0
  Haeyoche = `Haeyoche0
  Hapsioche = `Hapsioche0
  
  VerbForm = `Base0 + `Honorific0
  Base = `Base0
  Honorific = `Honorific0
  
  Setting = `Formal0 + `Polite0 + `Casual0
  Formal = `Formal0
  Polite = `Polite0
  Casual = `Casual0
  
  Person = `Speaker0 + `Listener0
  SpeakingPerson = `Speaker0
  OtherPerson = `Listener0
  Utterance = `Utterance0
  
  `Speaker0.pronoun = `Jeo0
  `Listener0.relativeRank = `Senior0
  
  `Utterance0.speaker = `Speaker0
  `Utterance0.listener = `Listener0
  `Utterance0.verbForm = `Honorific0
  `Utterance0.speechLevel = `Hapsioche0
  `Utterance0.setting = `Formal0
  no `Utterance0.referent
}

// Example: A casual conversation with junior listener about senior referent
// This tests the interesting case of conflicting ranks between listener and referent
example withConflictingRanksExample is {wellformed} for {
  RelativeRankToSpeaker = `Senior0 + `Junior0 + `Equal0
  Senior = `Senior0
  Junior = `Junior0
  Equal = `Equal0
  
  Pronoun = `Na0 + `Jeo0
  Na = `Na0
  Jeo = `Jeo0
  
  SpeechLevel = `Haeche0 + `Haeyoche0 + `Hapsioche0
  Haeche = `Haeche0
  Haeyoche = `Haeyoche0
  Hapsioche = `Hapsioche0
  
  VerbForm = `Base0 + `Honorific0
  Base = `Base0
  Honorific = `Honorific0
  
  Setting = `Formal0 + `Polite0 + `Casual0
  Formal = `Formal0
  Polite = `Polite0
  Casual = `Casual0
  
  Person = `Speaker0 + `Listener0 + `Referent0
  SpeakingPerson = `Speaker0
  OtherPerson = `Listener0 + `Referent0
  Utterance = `Utterance0
  
  `Speaker0.pronoun = `Na0                 // Na used with junior listener
  `Listener0.relativeRank = `Junior0       // Junior listener
  `Referent0.relativeRank = `Senior0       // Senior referent
  
  `Utterance0.speaker = `Speaker0
  `Utterance0.listener = `Listener0
  `Utterance0.referent = `Referent0
  `Utterance0.verbForm = `Honorific0       // Honorific because referring to Senior
  `Utterance0.speechLevel = `Haeche0       // Haeche because speaking to Junior in Casual setting
  `Utterance0.setting = `Casual0
}