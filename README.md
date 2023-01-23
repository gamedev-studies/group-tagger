# group-tagger
Utility for batch tagging of Moose model entities. 

## Installation
On a Moose 10 image, execute the following code snippet in a Playground:

```Smalltalk
Metacello new
    baseline: 'group-tagger';
    repository: 'github://gamedev-studies/group-tagger.git';
    load.
```

## Usage example in a generic Moose model
```Smalltalk
foldersTags := Dictionary newFrom: {
'./SoftwareSystem/Core' -> 'Core' . './SoftwareSystem/Foo/Bar' -> 'ImportantSubsystem' . './SoftwareSystem/Core/Foo' -> 'ImportantSubsystem'}
tagsColors := Dictionary newFrom: { 'Core' -> '#f0e442'. 'ImportantSubsystem' -> '#ff0000' }.

"instantiate a new tagger and settings"
tagger := GroupTagger new.

"set index of the Moose model you want to query"
tagger setModel: 1.

"set tag colors and project name"
tagger setColorMap: tagsColors.
tagger setProjectName: 'SoftwareSystem'.

"for each file, get folders with name and tag"
foldersTags keys do: [ :path | 
    tagger initialize: path tag: (foldersTags at: path) recursive: true.
]

## Usage example with Famix-CPP
```Smalltalk
foldersTags := Dictionary newFrom: {
'./SoftwareSystem/Core' -> 'Core' . './SoftwareSystem/Foo/Bar' -> 'ImportantSubsystem' . './SoftwareSystem/Core/Foo' -> 'ImportantSubsystem'}
tagsColors := Dictionary newFrom: { 'Core' -> '#f0e442'. 'ImportantSubsystem' -> '#ff0000' }.

"instantiate a new tagger and settings"
tagger := GroupTagger new.

"set index of the Moose model you want to query"
tagger setModel: 1.

"set tag colors and project name"
tagger setColorMap: tagsColors.
tagger setProjectName: 'SoftwareSystem'.

"for each file, get folders with name and tag"
foldersTags keys do: [ :path | 
    tagger initialize: path tag: (foldersTags at: path) recursive: true.
]
```
