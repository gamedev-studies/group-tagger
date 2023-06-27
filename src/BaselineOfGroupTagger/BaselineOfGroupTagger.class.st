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
        "Packages"
		self neoCSV: spec.

	spec package: 'Group-Tagger'
			with: [ spec requires: #( 'NeoCSV' ) ].
    ]

]

{ #category : #dependencies }
BaselineOfGroupTagger >> neoCSV: spec [

	spec
		baseline: 'NeoCSV'
		with: [ spec repository: 'github://svenvc/NeoCSV/repository' ]
        
]
