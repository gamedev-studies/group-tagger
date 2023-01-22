Class {
	#name : #GroupTagger,
	#superclass : #Object,
	#instVars : [],
	#category : #'Group-Tagger'
}

{ #category : #initialization }
GroupTagger >> initialize: path model: model tag: tag [
	|splittedPath|
	splittedPath := path splitOn: '/'.
	self searchEntity: splittedPath originalPath: path on: model tag: tag.
]

{ #category : #running }
GroupTagger >> searchEntity: splittedPath originalPath: originalPath on: group tag: tagName [
	| listOfMatches gatheredPath |
	listOfMatches := group select: [ :f | f name = (splittedPath last) ].
	listOfMatches do: [ :f | 
				gatheredPath := (self getParent: f pathString: '').
				Transcript show: originalPath. 
				Transcript show: '='. 
				Transcript show: gatheredPath. 
				Transcript cr.
			   originalPath = gatheredPath
					ifTrue: [
						Transcript show: 'tag file: ', (f name), ' with ', tagName. 
						Transcript cr.
					]
					ifFalse: [
						Transcript show: 'do not tag'. 
						Transcript cr.
					]
			]
]

{ #category : #running }
GroupTagger >> getParent: entity pathString: pathString [
	| hasParent |
	entity isNotNil
		ifTrue: [ 
			hasParent := entity allDeclaredProperties select: [ :each | each name = 'parentFolder' ].
			hasParent isNotEmpty
				ifTrue: [ 
						pathString = ''
						    ifTrue: [ ^self getParent: (entity parentFolder) pathString: (entity name) ]
						    ifFalse: [ ^self getParent: (entity parentFolder) pathString: (entity name , '/' , pathString) ]
						]
				ifFalse: [ ^ pathString ] 
		]
		ifFalse: [ ^ pathString ]
]

{ #category : #running }
GroupTagger >> doTagging: group tag: tagName parentName: parent [
    Transcript show: 'Called'.
	Transcript cr.
    group do: [:f | 
        f parentFolder name = parent
            ifTrue: [ Transcript show: 'Tag ', f name, ' with ', tagName. Transcript cr. ]    
    ]
]


