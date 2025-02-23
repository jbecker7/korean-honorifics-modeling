#lang forge/froglet

sig RelativeRankToSpeaker {} 
one sig Senior, Junior, Equal extends RelativeRankToSpeaker {}

sig Pronoun {} 
one sig Na, Jeo extends Pronoun {}

sig SpeechLevel {}  // 
one sig Haeche, Haeyoche, Hapsioche extends SpeechLevel {}

sig VerbForm {} 
one sig Base, Honorific extends VerbForm {}

sig Setting {}
one sig Formal, Polite, Casual extends Setting {}

sig Person {}

sig OtherPerson extends Person {
    relativeRank: one RelativeRankToSpeaker,
    pronoun: one Pronoun
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

// - 1 Speaker
// - 1 Listener
// - 1 optional Referent
// - 1 speech level
// - 1 Verb Form
// - Speaker != Listener
// - Referent != either Speaker or Listener, if present


// WHAT KOREAN-SPECIFIC RULES SHOULD ALL WELL-FORMED UTTERANCES FOLLOW?

// We know from the README's table of grammar rules that there are two factors which influence the type of
// speech used: 
// 1.  Listener rank relative to speaker (determines pronoun used, verb form; influences politeness level)
// 2.  Setting of the conversation (influences politeness level, with precedence to listener rank)

// For pronouns, rules are:
// - if listener is Junior or Equal in RankRelativeToSpeaker, then pronoun for "I" is Na
// - if listener is Senior in RankRelativeToSpeaker, then pronoun for "I" is Jeo

// For verb form, rules are:
// - if listener is Junior or Equal in RankRelativeToSpeaker, then verb form is Base (banmal)
// - if listener is Senior in RankRelativeToSpeaker, then verb form is Honorific (jondaetmal)

// For politeness level, rules are:
// - if listener is Senior and setting is Formal, then politeness level is Hapsioche
// - if listener is Senior and setting is Polite or Casual, then politeness level is Haeyoche
// - if listener is Equal or Junior and setting is Formal or Polite, then politeness level is Haeyoche
// - if listener is Equal or Junior and setting is Casual, then politeness level is Haeche

// And if a referent exists for a given utterance, that language used to refer to it is specific to the
// referent's rank, so it follows the same rules as a listener for verb form:

// - if referent is Junior or Equal in RankRelativeToSpeaker, then verb form is Base (banmal)
// - if referent is Senior in RankRelativeToSpeaker, then verb form is Honorific (jondaetmal)
