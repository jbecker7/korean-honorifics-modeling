# Korean Honorific Speech Formality Modeling
**Jonathan Becker, Ben Kang**  
CS 1710 – [Logic for Systems]

## Project Objective

This project models the complex speech formality system in Korean language using Forge. Korean is a language deeply rooted in hierarchical social structures, where the way one speaks depends on social status, relationship contexts, and formality settings.<sup>[1](https://onlinelibrary.wiley.com/doi/epdf/10.1002/9781118371008.ch17)</sup> 

The model aims to capture three key components of Korean speech formality:
- **Pronoun Choice**: When to use humble "jeo" vs. neutral "na" for "I"
- **Verb Form**: When to use honorific (jondaetmal) vs. base (banmal) forms
- **Speech Level**: When to use formal (hapsioche), polite (haeyoche), or casual (haeche) speech levels

The model enforces grammatical correctness based on relationships between the speaker, listener, and optionally a third-person referent, as well as the social context of the conversation.

## Korean Honorifics Configurations

For any given conversation, the following rules determine the correct speech elements to use:

| Listener Rank | Setting       | Pronoun Used | Verb Form              | Politeness Level     |
| ------------- | ------------- | ------------ | ---------------------- | -------------------- |
| Senior        | Formal        | 저 (jeo)     | Honorific (jondaetmal) | 합시오체 (hapsioche) |
| Senior        | Polite/Casual | 저 (jeo)     | Honorific (jondaetmal) | 해요체 (haeyoche)    |
| Junior        | Polite/Formal | 나 (na)      | Base (banmal)          | 해요체 (haeyoche)    |
| Junior        | Casual        | 나 (na)      | Base (banmal)          | 해체 (haeche)        |
| Equal         | Polite/Formal | 나 (na)      | Base (banmal)          | 해요체 (haeyoche)    |
| Equal         | Casual        | 나 (na)      | Base (banmal)          | 해체 (haeche)        |

Additionally, when speaking about a third person (referent), the verb form follows this rule:

| Referent Rank | Verb Form              |
| ------------- | ---------------------- |
| Senior        | Honorific (jondaetmal) |
| Junior        | Base (banmal)          |
| Equal         | Base (banmal)          |

## Model Design

### Design Overview

The model represents an utterance in Korean as having:
- A speaker who uses a specific pronoun
- A listener who has a rank relative to the speaker (senior, junior, or equal)
- An optional referent (person being discussed) who also has a relative rank
- A speech level and verb form that must conform to Korean formality rules
- A setting (formal, polite, or casual)

### Run Statements

The model includes multiple run statements to test different scenarios:
- Conversations with listeners of different ranks (senior, junior, equal)
- Utterances with and without referents
- Different combinations of settings (formal, polite, casual)

The most interesting cases involve a referent with a different rank than the listener, which creates a complex interplay of rules. For example, when speaking to a junior person about a senior person, the speaker must use:
- The pronoun "na" (because the listener is junior)
- The speech level "haeche" in casual settings (because the listener is junior)
- But honorific verb forms (because the referent is senior)

### Interpreting Instances

When examining an instance in Sterling's default visualization:
- Look for Person objects (speakers and listeners) and their relationships
- Check Utterance objects to verify that pronoun choice matches listener rank
- Verify that verb form matches referent rank (if present) or listener rank (if no referent)
- Confirm that speech level conforms to both listener rank and conversation setting

## Signatures and Predicates

### Key Signatures

- **RelativeRankToSpeaker**: Represents the hierarchical relationship (Senior, Junior, Equal)
- **Pronoun**: Represents Korean first-person pronouns (Na, Jeo)
- **SpeechLevel**: Represents degrees of formality in speech (Haeche, Haeyoche, Hapsioche)
- **VerbForm**: Represents the basic/honorific distinction in verbs (Base, Honorific)
- **Setting**: Represents conversational contexts (Formal, Polite, Casual)
- **Utterance**: Ties together a speaker, listener, optional referent, and linguistic choices

### Core Predicates

- **validPronoun**: Ensures the correct pronoun is used based on listener rank
- **validVerbForm**: Ensures the correct verb form is used based on listener or referent rank
- **validSpeechLevel**: Ensures the appropriate formality level based on rank and setting
- **basicUtteranceValidity**: Enforces structural constraints on utterances
- **wellformed**: Combines all rules to define a grammatically correct Korean utterance
- **allRulesValid**: A utility predicate that enforces all rules on a single utterance

## Testing

The testing approach is comprehensive, with tests organized into separate files to ensure the model correctly implements Korean speech formality rules.

### Assertion Tests

The model includes assertions to verify that each individual rule is properly enforced:
- Assertions for pronoun selection rules (e.g., `seniorListenerUsesJeo`)
- Assertions for verb form rules (e.g., `seniorReferentUsesHonorific`)
- Assertions for speech level rules (e.g., `seniorFormalUsesHapsioche`)

### Satisfiability Tests

Test-expect blocks verify that:
- Valid configurations are satisfiable (e.g., `seniorFormalCase`)
- Invalid configurations are unsatisfiable when combined with wellformedness rules (e.g., `invalidSeniorPronoun`)

### Example Tests

Concrete examples demonstrate key scenarios:
- `formalSeniorExample`: A formal conversation with a senior listener
- `withConflictingRanksExample`: A case where the listener is junior but the referent is senior, testing the interplay of different rules

## Insights and Limitations

This model successfully captures the core grammatical rules of Korean speech formality. Some interesting insights:

1. The model reveals the independence of certain aspects of speech - verb form can be determined by referent rank while pronoun and speech level are determined by listener rank.

2. The formality system creates a complex decision matrix where different elements can pull in different directions.

3. While the model accurately represents the rule-based components of Korean formality, it doesn't capture some of the nuanced social factors that can sometimes override these rules in real-world contexts.

Future work could extend this model to include:
- Additional speech levels that exist in Korean
- Modeling mood and tense interactions with formality
- Representing regional and age-based variations in formality rules
- A custom visualization with color coding for different ranks and settings

## References

Brown, L. (2015). Honorifics and politeness. *The handbook of Korean linguistics* (pp. 303–319). https://doi.org/10.1002/9781118371008.ch17
