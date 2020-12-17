# Knowledge Base

The program is completely configurable using a JSON knowledge base (KB). The knwoledge base consists of rules, questions and goals that are used to guide the inference process. The following code snippet represents the basic structure of a a knowledge base.
```{json}
{
  "goals": [ <goal>, <goal>, ... ],
  "rules": [ <rule>, <rule>, ... ],
  "questions": [ <question>, <question>, ... ]
}
```

There are some common recurring fields that are part of the definition of a goal, rule and question.

| Field         | Type     |                                            |
| ------------- | -------- | ------------------------------------------ |
| name          | optional | The unique name/identifier                 |
| description   | optional | The description                            |
| conditions    | optional | List of conditions that activate the object|
| events        | optional | List of events that are executed           |

## Goal
Goals are the most simple objects containing a list of conditions that specify whether the goal condition is fulfilled. A goal is definied by the following parameters: It has a name and description that give information about the goal itself. The 'name' and 'description' fields are optional and may be null. The goal will get an auto generated name and an empty description if they are not specified. However, the 'conditions' variable must be specified. It must to be a list of strings that are parsable as expressions. If all conditions in this list evaluate to true (this also means an empty list) the goal will be activated.

A basic example goal:
```{json}
{
    "name": "A simple example goal",
    "description": "This goal shows how to build a goal using the JSON knowledge base",
    "conditions": [ "goal_set", "goal_changed AND goal_static" ]
}
```

## Rule
Rules are used to infere additional knowledge from existing variables in the knowledge base. They follow the a basic structure. Each rule has a name and description that give some general information. The 'name' and 'description' fields are optional and may be null. The rule will get an auto generated name and an empty description if they are not specified. Each rule must contain a list of conditions and an additional list of events that will be executed as soon as the conditions are fullfilled.

A basic example rule:
```{json}
{
    "name": "A simple Rule",
    "description": "This is a simple example Rule showing how they work",
    "conditions": [ "goal_set" ],
    "events": [ "goal_static = 1", "goal_dynamic = 0" ]
}
```
## Question
Questions are used to gain additional knowledge that lies outside of the model's domain.

A basic example question:
```{json}
{
    "name": "A simple Question"
    "description": "This is a simple example question showing how they work",
    "conditions": [ "goal" ]
    "options": [
        {
            "description": "This is answer option 1",
            "events": [ "option1 = 1" ]
        },
        {
            "description": "This is answer option 2",
            "events": [ "option2 = 1" ]
        }
    ]
}
```