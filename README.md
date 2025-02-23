# Korean Honorific Modeling in Forge

## **1. Background**

Korean is a language deeply rooted in hierarchical social structures, where the way one speaks depends on age, social status, and the relationship between the speaker, listener, and referent. Three key components define speech levels in Korean:

### **1.1 Humble vs. Neutral Pronouns**

Korean speakers use different pronouns to refer to themselves depending on the level of humility they wish to express:

- **나 (na)**: Neutral "I"
- **저 (jeo)**: Humble/polite "I"

### **1.2 Honorific (jondaetmal) vs. Base (banmal) Form Verbs**

When referring to respected individuals, speakers use honorific verb forms, which can either be completely different or just a modified version of the base verb:

- **Base (banmal) form:** 먹다 (meokda) – "to eat"
- **Honorific (jondaetmal) form:** 드시다 (deusida) – "to eat" (for elders or respected figures)

Other common honorific transformations:

- **하다 (hada) → 하시다 (hasida)** (to do)
- **말하다 (malhada) → 말씀하시다 (malsseumhasida)** (to speak)
- **말하다 (malhada) → 말씀하시다 (malsseumhasida)** (to speak)
- **있다 (itda) → 계시다 (gyesida)** (to exist, for living beings)
- **보다 (boda) → 뵙다 (boepda)** (to see, humble form used for meeting someone of higher status)

### **1.3 Politeness Levels**

Korean has three primary politeness levels that affect sentence endings:

- **해체 (haeche)**: Casual speech, often used with close friends and younger people (e.g., "먹었어?").
- **해요체 (haeyoche)**: Polite speech, commonly used in everyday interactions with strangers and acquaintances (e.g., "먹었어요?").
- **합시오체 (hapsioche)**: Formal speech, used in official settings or when addressing superiors (e.g., "드셨습니까?").

These politeness levels are combined with honorific speech when speaking to or about someone deserving of respect.

A complexity that we hope to represent in the project is that there can sometimes be multiple valid politeness levels. What exact social factors contribute to someone feeling they can use polite speech as opposed to formal speech with, say, their superiors at work is a very complex topic with a plethora of [research](https://www.taylorfrancis.com/chapters/edit/10.4324/9781003090205-23/linguistic-politeness-korean-young-mee-yu-cho-jaehyun-jo) being done about it.

## **2. Scope of the Project**

We aim to model a structured framework in **Forge** that ensures:

- The correct **humble pronoun** is used by the speaker based on the context.
- The **correct verb form (base vs. honorific)** is chosen by the speaker when referring to a person of higher status and demonstrating respect towards them.
- The **appropriate politeness level** is used by the speaker based on the speaker-listener relationship.

## **3. Korean Honorifics Configurations**

For any given speaker, here are the speaker's rules to follow. The first two columns represent the social context, while the latter three columns are the resultant grammar rules given this context:

| Listener Rank | Setting       | Pronoun Used | Verb Form              | Politeness Level     |
| ------------- | ------------- | ------------ | :--------------------- | :------------------- |
| Senior        | Formal        | 저 (jeo)     | Honorific (jondaetmal) | 합시오체 (hapsioche) |
| Senior        | Polite        | 저 (jeo)     | Honorific (jondaetmal) | 해요체 (haeyoche)    |
| Junior        | Polite/Formal | 나 (na)      | Base (banmal)          | 해요체 (haeyoche)    |
| Junior        | Casual        | 나 (na)      | Base (banmal)          | 해체 (haeche)        |
| Equal         | Polite/Formal | 나 (na)      | Base (banmal)          | 해요체 (haeyoche)    |
| Equal         | Casual        | 나 (na)      | Base (banmal)          | 해체 (haeche)        |
