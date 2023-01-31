Class {
	#name : #GroupTagger,
	#superclass : #Object,
	#instVars : [
		'tagColors',
		'colorMap',
		'currentModel',
		'projectName',
		'csvPath'
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
GroupTagger >> initialize: pathToCsv recursive: recursive [

	| foldersTags pathColName |
	self setCSVPath: pathToCsv.
	pathColName := 'name'.

	recursive ifTrue: [ pathColName := 'path_from_root' ].

	foldersTags := self loadCSV: pathColName.
	foldersTags keysDo: [ :path | 
		self run: path tag: (foldersTags at: path) recursive: recursive ]
]

{ #category : #'as yet unclassified' }
GroupTagger >> loadCSV: pathColName [

	"Load CSV with file paths and their respective subsystems"

	| subsysColName columnArray foldersTags |
	csvPath isNotNil 
		ifTrue: [ 
			subsysColName := 'subsystem'.
			"slice from 2 so we ignore the header line"
			columnArray := (csvPath asFileReference readStreamDo: [ :stream | 
				               (NeoCSVReader on: stream readStream)
					               namedColumnsConfiguration;
					               upToEnd ]) sliceFrom: 2.
			foldersTags := Dictionary new.
			columnArray do: [ :item | "Check if first character of path equals dot"
				((item at: pathColName) at: 1) = $.
					ifTrue: [ 
						foldersTags
							at: (item at: pathColName)
							put: (item at: subsysColName) ]
					ifFalse: [ 
						self error:
							'Your file paths must start with dot, which represents the base folder' ] ].
			^ foldersTags ]
		ifFalse: [ 
			self error:
				'You must inform a path to a CSV file containing your file paths and their respective subsystems' ]
]

{ #category : #initialization }
GroupTagger >> run: target tag: tagName recursive: recursive [
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
GroupTagger >> setCSVPath: path [
	csvPath := path
]

{ #category : #initialization }
GroupTagger >> setColorMap: dict [
"set color map that will be used in tag creation"
	colorMap := dict
]

{ #category : #initialization }
GroupTagger >> setModel:  model [
"set model that will store the tags"
	currentModel := model.
]

{ #category : #initialization }
GroupTagger >> setProjectName: name [
"define tag prefix"
	projectName := name.
]
