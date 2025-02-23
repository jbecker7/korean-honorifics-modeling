#lang forge/froglet

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

// TO-DO: Predicates for well-formedness and to validate each field

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