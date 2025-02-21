#lang forge/froglet

sig Rank {} 
one sig Senior, Junior, Equal extends Rank {}

sig Pronoun {} 
one sig Na, Jeo extends Pronoun {}

sig SpeechLevel {}  // 
one sig Haeche, Haeyoche, Hapsioche extends SpeechLevel {}

sig VerbForm {} 
one sig Base, Honorific extends VerbForm {}

sig Person {
    rank: one Rank,
    pronoun: one Pronoun
}

sig Conversation {
    speaker: one Person,
    listener: one Person,
    referent: lone Person, // Optional, might not mention anyone
    speechLevel: one SpeechLevel,
    verbForm: one VerbForm
}

// TO-DO: Predicates for well-formedness and to validate each field
