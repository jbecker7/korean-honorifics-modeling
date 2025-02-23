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
