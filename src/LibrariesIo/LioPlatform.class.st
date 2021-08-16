Class {
	#name : #LioPlatform,
	#superclass : #LioObject,
	#instVars : [
		'color',
		'defaultLanguage',
		'homepage',
		'name',
		'projectCount'
	],
	#category : #LibrariesIo
}

{ #category : #accessing }
LioPlatform class >> neoJsonMapping: mapper [

	super neoJsonMapping: mapper.
	
	mapper for: self do: [ :mapping | 
		mapping mapInstVars: #( name projectCount ).
		(mapping mapInstVar: #color) valueSchema: Color.
		mapping mapInstVar: #defaultLanguage to: 'default_language'.
		(mapping mapInstVar: #homepage) valueSchema: ZnUrl.
		mapping mapInstVar: #projectCount to: 'project_count' ]
]

{ #category : #printing }
LioPlatform >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPut: $(;
		nextPutAll: name;
		nextPut: $)
]
