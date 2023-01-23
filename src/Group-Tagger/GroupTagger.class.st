Class {
	#name : #GroupTagger,
	#superclass : #Object,
	#instVars : [
		'modelId'
	],
	#category : #'Group-Tagger'
}

{ #category : #running }
GroupTagger >> doTagging: file tag: tagName [
	| modelList |
	modelList := MooseModel root.
	modelId < modelList size ifTrue: [ 
		file tagWith: ((modelList at: modelId) tagNamed: tagName) ]
]

{ #category : #running }
GroupTagger >> getParent: entity pathString: pathString [

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
GroupTagger >> initialize: path group: group modelId: id tag: tag [

	| splittedPath |
	modelId := id.
	splittedPath := path splitOn: '/'.
	self
		searchEntity: splittedPath
		originalPath: path
		on: group
		tag: tag
]

{ #category : #running }
GroupTagger >> searchEntity: splittedPath originalPath: originalPath on: group tag: tagName [
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
