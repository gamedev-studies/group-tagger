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
			spec
                package: 'Group-Tagger' 
                with: [ spec repository: 'github://svenvc/NeoCSV' ]
    ]
]
