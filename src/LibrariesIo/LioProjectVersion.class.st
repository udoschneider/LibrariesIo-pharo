Class {
	#name : #LioProjectVersion,
	#superclass : #LioObject,
	#instVars : [
		'repositorySources',
		'publishedAt',
		'originalLicense',
		'researchedAt',
		'spdxExpression',
		'number'
	],
	#category : #LibrariesIo
}

{ #category : #accessing }
LioProjectVersion class >> neoJsonMapping: mapper [

	super neoJsonMapping: mapper.

	mapper for: self do: [ :mapping | 
		mapping mapInstVars: #( number ).

		mapping mapInstVar: #repositorySources to: 'repository_sources'.
		(mapping mapInstVar: #publishedAt to: 'published_at') valueSchema:
			DateAndTime.
		mapping mapInstVar: #originalLicense to: 'original_license'.
		(mapping mapInstVar: #researchedAt to: 'researched_at') 
			valueSchema: DateAndTime.
		mapping mapInstVar: #spdxExpression to: 'spdx_expression' ]
]

{ #category : #printing }
LioProjectVersion >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPut: $(;
		nextPutAll: number;
		nextPut: $)
]
