"
Baseline of group tagger
"
Class {
	#name : #BaselineOfGroupTagger,
	#superclass : #BaselineOf,
	#category : #BaselineOfGroupTagger
}

{ #category : #baselines }
BaselineOfFamixCpp >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self neoCsv: spec.
		spec package: 'Group-Tagger'.
    ]
]

{ #category : #dependencies }
BaselineOfFamixCpp >> neoCsv: spec [

	spec
		baseline: 'NeoCSV'
		with: [ spec repository: 'https://github.com/svenvc/NeoCSV' ]
]