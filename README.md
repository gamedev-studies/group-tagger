# group-tagger
Utility for batch tagging of Moose model entities. 

## Installation
On a Moose 10 image, execute the following code snippet in a Playground:

```Smalltalk
Metacello new
    baseline: 'GroupTagger';
    repository: 'github://gamedev-studies/group-tagger:main';
    onConflict: [ :ex | ex useIncoming ];
    onUpgrade: [ :ex | ex useIncoming ];
	onDowngrade: [ :ex | ex useLoaded ];
    load.
```

## Usage example with a generic Moose model
Let's consider you have a SoftwareSystem.csv similar to this:
```
subsystem,entity_name
veggie,carrot
fruit,banana
veggie,broccoli
fruit,apple
```

Instantiate and parametrize the tagger like this:
```
Smalltalk
"instantiate a new tagger and settings"
tagger := GroupTagger new.

"set index of the Moose model you want to query"
tagger setModel: 1.

"set tag colors and project name"
tagger setColorMap: (Dictionary newFrom: { 'fruit' -> '#f5e642'. 'veggie' -> '#42f545' }).
tagger setProjectName: 'SoftwareSystem'.

"search the model for entities with each entity_name, tag with the respective subsystem"
tagger initialize: '/home/user/Documents/SoftwareSystem.csv' recursive: false
```

## Usage example with Famix-CPP
Let's consider you have a SoftwareSystem.csv similar to this:
```
subsystem,path_from_root
Core,./SoftwareSystem/Core
ImportantSubsystem,./SoftwareSystem/Foo/Bar
ImportantSubsystem,./SoftwareSystem/Core/Foo
```

Instantiate and parametrize the tagger like this:
```
Smalltalk
"instantiate a new tagger and settings"
tagger := GroupTagger new.

"set index of the Moose model you want to query"
tagger setModel: 1.

"set tag colors and project name"
tagger setColorMap: (Dictionary newFrom: { 'Core' -> '#f0e442'. 'ImportantSubsystem' -> '#ff0000' }).
tagger setProjectName: 'SoftwareSystem'.

"search the model for each path_from_root, tag file/folder with respective subsystem"
tagger initialize: '/home/user/Documents/SoftwareSystem.csv' recursive: true
```

