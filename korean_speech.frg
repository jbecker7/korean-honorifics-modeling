#lang forge/froglet


// Sigs 

abstract sig RelativeRankToSpeaker {} 
one sig Senior, Junior, Equal extends RelativeRankToSpeaker {}

abstract sig Pronoun {} 
one sig Na, Jeo extends Pronoun {}

abstract sig SpeechLevel {}  // 
one sig Haeche, Haeyoche, Hapsioche extends SpeechLevel {}

abstract sig VerbForm {} 
one sig Base, Honorific extends VerbForm {}

abstract sig Setting {}
one sig Formal, Polite, Casual extends Setting {}

abstract sig Person {}

sig OtherPerson extends Person {
    relativeRank: one RelativeRankToSpeaker
}

sig SpeakingPerson extends Person {
    pronoun: one Pronoun
}

sig Utterance {
    speaker: one SpeakingPerson,
    listener: one OtherPerson,
    referent: lone OtherPerson, // Optional, might not mention anyone
    verbForm: one VerbForm,
    speechLevel: one SpeechLevel,
    setting: one Setting
}

// Preds

// WHAT BASIC RULES SHOULD ALL WELL-FORMED UTTERANCES FOLLOW?

// - 1 Speaker (enforced by one sig)
// - 1 Listener (enforced by one sig)
// - 1 optional Referent
// - 1 speech level (enforced by one sig)
// - 1 Verb Form (enforced by one sig)
// - Speaker != Listener
// - Referent != either Speaker or Listener, if present

pred basicUtteranceValidity[ u:Utterance ] {
    u.speaker != u.listener
    some u.referent implies {
        u.referent != u.speaker 
        u.referent != u.listener
    }
}

// WHAT KOREAN-SPECIFIC RULES SHOULD ALL WELL-FORMED UTTERANCES FOLLOW?

// We know from the README's table of grammar rules that there are two factors which influence the type of
// speech used: 
// 1.  Listener rank relative to speaker (determines pronoun used, verb form; influences politeness level)
// 2.  Setting of the conversation (influences politeness level, with precedence to listener rank)

// For pronouns, rules are:
// - if listener is Junior or Equal in RankRelativeToSpeaker, then pronoun for "I" is Na
// - if listener is Senior in RankRelativeToSpeaker, then pronoun for "I" is Jeo

pred validPronoun[ u:Utterance ] {
    u.listener.relativeRank = Senior implies u.speaker.pronoun = Jeo
    (u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) implies u.speaker.pronoun = Na
}

// For verb form, rules are:
// - if listener is Junior or Equal in RankRelativeToSpeaker, then verb form is Base (banmal)
// - if listener is Senior in RankRelativeToSpeaker, then verb form is Honorific (jondaetmal)

// And if a referent exists for a given utterance, that language used to refer to it is specific to the
// referent's rank, so it follows the same rules as a listener for verb form:

// - if referent is Junior or Equal in RankRelativeToSpeaker, then verb form is Base (banmal)
// - if referent is Senior in RankRelativeToSpeaker, then verb form is Honorific (jondaetmal)

pred validVerbForm[ u:Utterance ] {
    // if there is no referent, use the rank of listener, as is normal
    no u.referent implies {
        (u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) implies u.verbForm = Base
        u.listener.relativeRank = Senior implies u.verbForm = Honorific
    }
    // else if there is a referent, use rank of referent, although this is not a perfect model
    some u.referent implies  {
        (u.referent.relativeRank = Junior or u.referent.relativeRank = Equal) implies u.verbForm = Base
        u.referent.relativeRank = Senior implies u.verbForm = Honorific
    }
}

// For politeness level, rules are:
// - if listener is Senior and setting is Formal, then politeness level is Hapsioche
// - if listener is Senior and setting is Polite or Casual, then politeness level is Haeyoche
// - if listener is Equal or Junior and setting is Formal or Polite, then politeness level is Haeyoche
// - if listener is Equal or Junior and setting is Casual, then politeness level is Haeche

pred validSpeechLevel[ u:Utterance ] {
    (u.listener.relativeRank = Senior and u.setting = Formal) implies u.speechLevel = Hapsioche
    (u.listener.relativeRank = Senior and (u.setting = Polite or u.setting = Casual)) implies u.speechLevel = Haeyoche
    ((u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) and (u.setting = Polite or u.setting = Formal)) implies u.speechLevel = Haeyoche
    ((u.listener.relativeRank = Junior or u.listener.relativeRank = Equal) and u.setting = Casual) implies u.speechLevel = Haeche
}

// All together, we can now check for wellformedness:

pred wellformed {
    all u : Utterance | {
        validPronoun[u]
        validVerbForm[u]  
        validSpeechLevel[u]
        basicUtteranceValidity[u]
    }
}

// Tests if a basic utterance satisfies structural constraints
pred basicStructureValid {
    all u: Utterance | basicUtteranceValidity[u]
}

// Test for various pronoun combinations
pred seniorListenerUsesJeo {
    all u: Utterance | u.listener.relativeRank = Senior implies u.speaker.pronoun = Jeo
}

pred juniorListenerUsesNa {
    all u: Utterance | u.listener.relativeRank = Junior implies u.speaker.pronoun = Na
}

pred equalListenerUsesNa {
    all u: Utterance | u.listener.relativeRank = Equal implies u.speaker.pronoun = Na
}

// Test for verb form rules
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

// Test for speech level rules
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

// Run commands for pronoun predicates
senior_listener_jeo: run {
    all u: Utterance | u.listener.relativeRank = Senior
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

junior_listener_na: run {
    all u: Utterance | u.listener.relativeRank = Junior
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

equal_listener_na: run {
    all u: Utterance | u.listener.relativeRank = Equal
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

// Run commands for verb form predicates
senior_referent_honorific: run {
    all u: Utterance | some u.referent and u.referent.relativeRank = Senior
    all u: Utterance | allRulesValid[u]
} for exactly 3 Person, exactly 1 Utterance

junior_referent_base: run {
    all u: Utterance | some u.referent and u.referent.relativeRank = Junior
    all u: Utterance | allRulesValid[u]
} for exactly 3 Person, exactly 1 Utterance

equal_referent_base: run {
    all u: Utterance | some u.referent and u.referent.relativeRank = Equal
    all u: Utterance | allRulesValid[u]
} for exactly 3 Person, exactly 1 Utterance

no_referent_senior_honorific: run {
    all u: Utterance | no u.referent and u.listener.relativeRank = Senior
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

no_referent_junior_base: run {
    all u: Utterance | no u.referent and u.listener.relativeRank = Junior
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

// Run commands for speech level predicates
senior_formal_hapsioche: run {
    all u: Utterance | u.listener.relativeRank = Senior and u.setting = Formal
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

senior_polite_haeyoche: run {
    all u: Utterance | u.listener.relativeRank = Senior and u.setting = Polite
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

senior_casual_haeyoche: run {
    all u: Utterance | u.listener.relativeRank = Senior and u.setting = Casual
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

junior_formal_haeyoche: run {
    all u: Utterance | u.listener.relativeRank = Junior and u.setting = Formal
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

junior_casual_haeche: run {
    all u: Utterance | u.listener.relativeRank = Junior and u.setting = Casual
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

equal_formal_haeyoche: run {
    all u: Utterance | u.listener.relativeRank = Equal and u.setting = Formal
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

equal_casual_haeche: run {
    all u: Utterance | u.listener.relativeRank = Equal and u.setting = Casual
    all u: Utterance | allRulesValid[u]
} for exactly 2 Person, exactly 1 Utterance

one_utterance_no_referent: run {
  wellformed
} for exactly 2 Person, exactly 1 Utterance

run {
  wellformed
} for exactly 3 Person, exactly 1 Utterance