#lang forge/froglet

//=============================================================================
// SIGNATURE DEFINITIONS
//=============================================================================

// Ranks that a person can have relative to the speaker
abstract sig RelativeRankToSpeaker {} 
one sig Senior, Junior, Equal extends RelativeRankToSpeaker {}

// Pronouns for "I" in Korean
abstract sig Pronoun {} 
one sig Na, Jeo extends Pronoun {}
// Na: Standard form used with juniors/equals
// Jeo: Humble form used with seniors

// Speech levels for verb endings
abstract sig SpeechLevel {}
one sig Haeche, Haeyoche, Hapsioche extends SpeechLevel {}
// Haeche: Lowest formality, used with juniors/equals in casual settings
// Haeyoche: Medium formality, used with seniors (non-formal settings) and juniors/equals (formal settings)
// Hapsioche: Highest formality, used with seniors in formal settings

// Verb forms in Korean
abstract sig VerbForm {} 
one sig Base, Honorific extends VerbForm {}
// Base: Standard form used with juniors/equals (banmal)
// Honorific: Respectful form used with seniors (jondaetmal)

// Settings where conversations can take place
abstract sig Setting {}
one sig Formal, Polite, Casual extends Setting {}

// Person signatures for speakers and listeners
abstract sig Person {}

// Other people (listeners or referents)
sig OtherPerson extends Person {
    relativeRank: one RelativeRankToSpeaker
}

// The person speaking
sig SpeakingPerson extends Person {
    pronoun: one Pronoun  // Which form of "I" they use
}

// An utterance with all its properties
sig Utterance {
    speaker: one SpeakingPerson,
    listener: one OtherPerson,
    referent: lone OtherPerson,  // Optional person being talked about
    verbForm: one VerbForm,
    speechLevel: one SpeechLevel,
    setting: one Setting
}

//=============================================================================
// PREDICATES: BASIC STRUCTURAL VALIDITY
//=============================================================================

// Validates the basic structure of an utterance:
// - Speaker can't be the same as listener
// - Referent must be different from both speaker and listener
pred basicUtteranceValidity[u: Utterance] {
    u.speaker != u.listener
    some u.referent implies {
        u.referent != u.speaker 
        u.referent != u.listener
    }
}

//=============================================================================
// PREDICATES: KOREAN LANGUAGE RULES
//=============================================================================

// Rule 1: Pronoun choice depends on listener's rank
// - When speaking to a senior: use humble form "Jeo"
// - When speaking to a junior or equal: use standard form "Na"
pred validPronoun[u: Utterance] {
    u.listener.relativeRank = Senior implies u.speaker.pronoun = Jeo
    (u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) implies u.speaker.pronoun = Na
}

// Rule 2: Verb form depends on listener's rank (if no referent)
//         or on referent's rank (if there is a referent)
// - For seniors: use honorific form (jondaetmal)
// - For juniors/equals: use base form (banmal)
pred validVerbForm[u: Utterance] {
    // When there's no referent, verb form depends on listener's rank
    no u.referent implies {
        (u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) implies u.verbForm = Base
        u.listener.relativeRank = Senior implies u.verbForm = Honorific
    }
    
    // When there's a referent, verb form depends on referent's rank
    some u.referent implies {
        (u.referent.relativeRank = Junior or u.referent.relativeRank = Equal) implies u.verbForm = Base
        u.referent.relativeRank = Senior implies u.verbForm = Honorific
    }
}

// Rule 3: Speech level depends on both listener's rank and setting
// - Senior + Formal → Hapsioche (highest formality)
// - Senior + Polite/Casual → Haeyoche (medium formality)
// - Junior/Equal + Formal/Polite → Haeyoche (medium formality)
// - Junior/Equal + Casual → Haeche (lowest formality)
pred validSpeechLevel[u: Utterance] {
    // Senior listeners
    (u.listener.relativeRank = Senior and u.setting = Formal) implies u.speechLevel = Hapsioche
    (u.listener.relativeRank = Senior and (u.setting = Polite or u.setting = Casual)) implies u.speechLevel = Haeyoche
    
    // Junior or Equal listeners
    ((u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) and (u.setting = Polite or u.setting = Formal)) implies u.speechLevel = Haeyoche
    ((u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) and u.setting = Casual) implies u.speechLevel = Haeche
}

// Combined wellformedness check that applies all rules
pred wellformed {
    all u: Utterance | {
        validPronoun[u]
        validVerbForm[u]  
        validSpeechLevel[u]
        basicUtteranceValidity[u]
    }
}

//=============================================================================
// TEST PREDICATES: INDIVIDUAL RULE VALIDATION
//=============================================================================

// Basic structure tests
pred basicStructureValid {
    all u: Utterance | basicUtteranceValidity[u]
}

// Pronoun rule tests
pred seniorListenerUsesJeo {
    all u: Utterance | u.listener.relativeRank = Senior implies u.speaker.pronoun = Jeo
}

pred juniorListenerUsesNa {
    all u: Utterance | u.listener.relativeRank = Junior implies u.speaker.pronoun = Na
}

pred equalListenerUsesNa {
    all u: Utterance | u.listener.relativeRank = Equal implies u.speaker.pronoun = Na
}

// Verb form rule tests
pred seniorReferentUsesHonorific {
    all u: Utterance | some u.referent and u.referent.relativeRank = Senior implies u.verbForm = Honorific
}

pred juniorReferentUsesBase {
    all u: Utterance | some u.referent and u.referent.relativeRank = Junior implies u.verbForm = Base
}

pred equalReferentUsesBase {
    all u: Utterance | some u.referent and u.referent.relativeRank = Equal implies u.verbForm = Base
}

pred noReferentSeniorListenerUsesHonorific {
    all u: Utterance | no u.referent and u.listener.relativeRank = Senior implies u.verbForm = Honorific
}

pred noReferentJuniorListenerUsesBase {
    all u: Utterance | no u.referent and u.listener.relativeRank = Junior implies u.verbForm = Base
}

// Speech level rule tests
pred seniorFormalUsesHapsioche {
    all u: Utterance | u.listener.relativeRank = Senior and u.setting = Formal implies u.speechLevel = Hapsioche
}

pred seniorPoliteUsesHaeyoche {
    all u: Utterance | u.listener.relativeRank = Senior and u.setting = Polite implies u.speechLevel = Haeyoche
}

pred seniorCasualUsesHaeyoche {
    all u: Utterance | u.listener.relativeRank = Senior and u.setting = Casual implies u.speechLevel = Haeyoche
}

pred juniorFormalUsesHaeyoche {
    all u: Utterance | u.listener.relativeRank = Junior and u.setting = Formal implies u.speechLevel = Haeyoche
}

pred juniorCasualUsesHaeche {
    all u: Utterance | u.listener.relativeRank = Junior and u.setting = Casual implies u.speechLevel = Haeche
}

pred equalFormalUsesHaeyoche {
    all u: Utterance | u.listener.relativeRank = Equal and u.setting = Formal implies u.speechLevel = Haeyoche
}

pred equalCasualUsesHaeche {
    all u: Utterance | u.listener.relativeRank = Equal and u.setting = Casual implies u.speechLevel = Haeche
}

//=============================================================================
// COMPREHENSIVE VALIDATION PREDICATE 
//=============================================================================

// A complete validation predicate that checks all rules for a single utterance
// Used in test cases to ensure all rules are followed
pred allRulesValid[u: Utterance] {
    // Pronoun rules
    u.listener.relativeRank = Senior implies u.speaker.pronoun = Jeo
    (u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) implies u.speaker.pronoun = Na
    
    // Verb form rules
    some u.referent implies {
        (u.referent.relativeRank = Junior or u.referent.relativeRank = Equal) implies u.verbForm = Base
        u.referent.relativeRank = Senior implies u.verbForm = Honorific
    }
    no u.referent implies {
        (u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) implies u.verbForm = Base
        u.listener.relativeRank = Senior implies u.verbForm = Honorific
    }
    
    // Speech level rules
    (u.listener.relativeRank = Senior and u.setting = Formal) implies u.speechLevel = Hapsioche
    (u.listener.relativeRank = Senior and (u.setting = Polite or u.setting = Casual)) implies u.speechLevel = Haeyoche
    ((u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) and (u.setting = Polite or u.setting = Formal)) implies u.speechLevel = Haeyoche
    ((u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) and u.setting = Casual) implies u.speechLevel = Haeche
    
    // Basic validity
    basicUtteranceValidity[u]
}

//=============================================================================
// EXAMPLES AND TEST CASES 
//=============================================================================

// Example of a formal utterance to a senior
example formalSeniorExample is {wellformed} for {
  // Define all signature atoms
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
  
  // Define relationships - speaking formally to senior listener
  `Speaker0.pronoun = `Jeo0
  `Listener0.relativeRank = `Senior0
  
  `Utterance0.speaker = `Speaker0
  `Utterance0.listener = `Listener0
  `Utterance0.verbForm = `Honorific0
  `Utterance0.speechLevel = `Hapsioche0
  `Utterance0.setting = `Formal0
  no `Utterance0.referent
}

// Example with conflicting ranks (junior listener but senior referent)
example conflictingRanksExample is {wellformed} for {
  // Define all signature atoms
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
  
  // Define relationships - complex case with mixed ranks
  `Speaker0.pronoun = `Na0
  `Listener0.relativeRank = `Junior0
  `Referent0.relativeRank = `Senior0
  
  `Utterance0.speaker = `Speaker0
  `Utterance0.listener = `Listener0
  `Utterance0.referent = `Referent0
  `Utterance0.verbForm = `Honorific0  // Uses Honorific because referent is Senior
  `Utterance0.speechLevel = `Haeche0  // Uses Haeche because listener is Junior in Casual setting
  `Utterance0.setting = `Casual0
}

//=============================================================================
// RUN COMMANDS
//=============================================================================

// Run commands for pronoun predicates
// senior_listener_jeo: run {
//     all u: Utterance | u.listener.relativeRank = Senior
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// junior_listener_na: run {
//     all u: Utterance | u.listener.relativeRank = Junior
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// equal_listener_na: run {
//     all u: Utterance | u.listener.relativeRank = Equal
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// Run commands for verb form predicates
// senior_referent_honorific: run {
//     all u: Utterance | some u.referent and u.referent.relativeRank = Senior
//     all u: Utterance | allRulesValid[u]
// } for exactly 3 Person, exactly 1 Utterance

// junior_referent_base: run {
//     all u: Utterance | some u.referent and u.referent.relativeRank = Junior
//     all u: Utterance | allRulesValid[u]
// } for exactly 3 Person, exactly 1 Utterance

// equal_referent_base: run {
//     all u: Utterance | some u.referent and u.referent.relativeRank = Equal
//     all u: Utterance | allRulesValid[u]
// } for exactly 3 Person, exactly 1 Utterance

// no_referent_senior_honorific: run {
//     all u: Utterance | no u.referent and u.listener.relativeRank = Senior
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// no_referent_junior_base: run {
//     all u: Utterance | no u.referent and u.listener.relativeRank = Junior
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// Run commands for speech level predicates
// senior_formal_hapsioche: run {
//     all u: Utterance | u.listener.relativeRank = Senior and u.setting = Formal
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// senior_polite_haeyoche: run {
//     all u: Utterance | u.listener.relativeRank = Senior and u.setting = Polite
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// senior_casual_haeyoche: run {
//     all u: Utterance | u.listener.relativeRank = Senior and u.setting = Casual
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// junior_formal_haeyoche: run {
//     all u: Utterance | u.listener.relativeRank = Junior and u.setting = Formal
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// junior_casual_haeche: run {
//     all u: Utterance | u.listener.relativeRank = Junior and u.setting = Casual
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// equal_formal_haeyoche: run {
//     all u: Utterance | u.listener.relativeRank = Equal and u.setting = Formal
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// equal_casual_haeche: run {
//     all u: Utterance | u.listener.relativeRank = Equal and u.setting = Casual
//     all u: Utterance | allRulesValid[u]
// } for exactly 2 Person, exactly 1 Utterance

// one_utterance_no_referent: run {
//   wellformed
// } for exactly 2 Person, exactly 1 Utterance

// Generate an example with a referent
run {
  wellformed
  some u: Utterance | some u.referent
} for exactly 3 Person, exactly 1 Utterance