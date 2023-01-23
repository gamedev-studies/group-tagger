Class {
	#name : #GroupTagger,
	#superclass : #Object,
	#instVars : [
		'tagColors',
		'colorMap',
		'currentModel',
		'projectName'
	],
	#category : #'Group-Tagger'
}

{ #category : #'as yet unclassified' }
GroupTagger >> assignColors [
"assign colors to tags in the model; nonexisting tags will be created"
	colorMap keysDo: [ :key | (currentModel tagNamed: projectName , '-' , key) color: (Color fromHexString: (colorMap at: key))].
]

{ #category : #running }
GroupTagger >> doTagging: entity tag: tagName [
"tag entity, add project prefix"
	entity tagWith: (currentModel tagNamed: projectName,'-',tagName  )
]

{ #category : #running }
GroupTagger >> getParent: entity pathString: pathString [
"check if entity has a parent, and get its name recursively, returns full path"
	| hasParent |
	entity isNotNil
		ifTrue: [ 
			hasParent := entity allDeclaredProperties select: [ :each | 
				             each name = 'parentFolder' ].
			hasParent isNotEmpty
				ifTrue: [ 
					pathString = ''
						ifTrue: [ 
						^ self getParent: entity parentFolder pathString: entity name ]
						ifFalse: [ 
							^ self
								  getParent: entity parentFolder
								  pathString: entity name , '/' , pathString ] ]
				ifFalse: [ ^ pathString ] ]
		ifFalse: [ ^ pathString ]
]

{ #category : #initialization }
GroupTagger >> initialize: target tag: tagName recursive: recursive [
	"if recursive=false, search for target in model and tag; if recursive=true, split path, search for files matching the full path inside the group"

	| splittedPath group |
	self assignColors.

	recursive
		ifTrue: [ 
			splittedPath := target splitOn: '/'.
			group := currentModel select: [ :e | e name = splittedPath last ].

			self
				searchEntity: splittedPath
				originalPath: target
				on: group
				tag: tagName ]
		ifFalse: [ 
			group := currentModel select: [ :e | e name = target ].
			group do: [ :e | self doTagging: e tag: tagName ] ]
]

{ #category : #running }
GroupTagger >> searchEntity: splittedPath originalPath: originalPath on: group tag: tagName [
"search for full file path, compare if equals path provided"
	| listOfMatches gatheredPath |
	listOfMatches := group select: [ :f | f name = (splittedPath last) ].
	listOfMatches do: [ :f | 
				gatheredPath := (self getParent: f pathString: '').
			   originalPath = gatheredPath
					ifTrue: [
						self doTagging: f tag: tagName.
					]
			]
]

{ #category : #initialization }
GroupTagger >> setColorMap: dict [
"set color map that will be used in tag creation"
	colorMap := dict
]

{ #category : #initialization }
GroupTagger >> setModel:  modelId [
"set model that will store the tags"
	currentModel := (MooseModel root at: modelId).
]

{ #category : #initialization }
GroupTagger >> setProjectName: name [
"define tag prefix"
	projectName := name.
]
