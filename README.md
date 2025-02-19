# Korean Honorifics Modeling in Forge

## **1. Background**
Korean is a language deeply rooted in hierarchical social structures, where the way one speaks depends on age, social status, and the relationship between the speaker, listener, and referent. Three key components define speech levels in Korean:

### **1.1 Humble vs. Neutral Pronouns**
Korean speakers use different pronouns to refer to themselves depending on the level of humility they wish to express:
- **나 (na)**: Informal "I"
- **저 (jeo)**: Humble/polite "I"

### **1.2 Honorific vs. Base Form Verbs**
When referring to respected individuals, speakers use honorific verb forms:
- **Base form:** 먹다 (meokda) – "to eat"
- **Honorific form:** 드시다 (deusida) – "to eat" (for elders or respected figures)

Other common honorific transformations:
- **말하다 → 말씀하시다** (to speak)
- **있다 → 계시다** (to exist, for living beings)
- **보다 → 뵙다** (to see, humble form used for meeting someone of higher status)

### **1.3 Politeness Levels**
Korean has three primary politeness levels that affect sentence endings:
- **해체 (Haeche)**: Casual speech, often used with close friends and younger people (e.g., "먹었어?").
- **해요체 (Haeyoche)**: Polite speech, commonly used in everyday interactions with strangers and acquaintances (e.g., "먹었어요?").
- **합시오체 (Hapsioche)**: Formal speech, used in official settings or when addressing superiors (e.g., "드셨습니까?").

These politeness levels are combined with honorific speech when speaking to or about someone deserving of respect.

## **2. Scope of the Project**
We aim to model a structured framework in **Forge** that ensures:
- The correct **humble pronoun** is used based on the context.
- The **correct verb form (base vs. honorific)** is chosen when referring to a person of higher status.
- The **appropriate politeness level** is used based on the speaker-listener relationship.

### **2.1 What We Will Model**
We will define:
1. **People** with attributes:
   - Age
   - Social rank (Senior, Junior, Equal)
   - Relationship (Family, Work, Acquaintance)
2. **Pronouns** (나 vs. 저) based on status relationships.
3. **Verb transformations** (Base vs. Honorific Forms).
4. **Politeness levels** and enforce correct verb endings.

### **2.2 Example Scenarios to Validate**
- A student speaking to a teacher should use **저** and honorific verbs in **해요체** or **합시오체**.
- A boss addressing an employee can use **나** and casual verb forms in **해요체**.
- A younger sibling speaking to an older sibling should use **저** and **해요체**, but not honorifics.

This model will allow us to test and verify the correctness of speech levels across different social situations.

