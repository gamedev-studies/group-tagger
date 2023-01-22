# group-tagger
Utility for batch tagging of Moose model entities. 

# Installation
On a Moose 10 image, execute the following code snippet in a Playground:

```Smalltalk
Metacello new
    baseline: 'group-tagger';
    repository: 'github://gamedev-studies/group-tagger.git';
    load.
```

# Usage example with Famix-CPP
```Smalltalk
    |tagger model|
    tagger := GroupTagger new.
    model := MooseModel root at: 5.
    tagger initialize: './path/example' model: model tag: 'example'.
```