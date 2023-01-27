"
Baseline of GroupTagger
"
Class {
	#name : #BaselineOfGroupTagger,
	#superclass : #BaselineOf,
	#category : #BaselineOfGroupTagger
}

{ #category : #baselines }
BaselineOfGroupTagger >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self neoCsv: spec.
		spec package: 'Group-Tagger'.
    ]
]

{ #category : #dependencies }
BaselineOfGroupTagger >> neoCsv: spec [

	spec
		baseline: 'NeoCSV'
		with: [ spec repository: 'https://github.com/svenvc/NeoCSV' ]
]