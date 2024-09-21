# emotional-llm

### Ability Based EQ ([Results](./train_el/predictions/situ_merged.csv))
The results are based on the [Situational Intelligence (MacCann and Roberts (2008))](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6546921/#B33). 

It was relatively easy to generate the response for this test without major addition/change to the prompts/instructions.

Prompt
```
Read the given situation which has instructions and multiple choices a,b,c,d and e. Follow the instructions to sellect only one out of the given choices.

### instructions: 
{text}
### choices
a. {a}
b. {b}
c. {c}
d. {d}
e. {e}
### Predicted Choice
```

---

### Trait Based EQ ([Results](./train_el/tei_answers/csv_res/all_tei_preds.csv)
The trait based experiments are based on [TEIQUE](https://psychometriclab.com/obtaining-the-teique/)).

The instructions had to be significantly changed for the trait based predictions. Gemma-27B will not generate results for the multiple variation of the prompt for this task.
#### TODO: Look into gemma-27b for this task.

### Original Instruction for TEIQUE

```
Please answer each statement below by putting a circle around the number that best reflects your degree of agreement or disagreement with that statement. Do not think too long about the exact meaning of the statements. Work quickly and try to answer as accurately as possible. There are no right or wrong answers. There are seven possible responses to each statement ranging from ‘Completely Disagree’ (number 1) to ‘Completely Agree’ (number 7).
```

It had to be changed to the following template:

```
### Instructions:
Please answer each statement below by selecting one option that best reflects your degree of agreement or disagreement with that statement. Do not think too long about the exact meaning of the statements. Work quickly and try to answer as accurately as possible. There are no right or wrong answers. There are seven possible responses to each statement ranging from ‘Completely Disagree’ (number 1) to ‘Completely Agree’ (number 7).

### Options:
1. Completely Disagree
2. Strongly Disagree 
3. Weakly Disagree 
4. Neither Agree or Disagee 
5. Weakly Agree 
6. Strongly Agree 
7. Completely Agree
### Statement: {STATEMENT_FROM_DS}
Select one response from the given options.
### Answer:

```
