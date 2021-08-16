Class {
	#name : #LioDependency,
	#superclass : #LioObject,
	#instVars : [
		'requirements',
		'latestStable',
		'kind',
		'name',
		'deprecated',
		'outdated',
		'projectName',
		'normalizedLicenses',
		'platform',
		'filepath',
		'latest'
	],
	#category : #LibrariesIo
}

{ #category : #accessing }
LioDependency class >> neoJsonMapping: mapper [

	super neoJsonMapping: mapper.

	mapper for: self do: [ :mapping | 
		mapping mapInstVars:
			#( requirements kind name deprecated outdated 
			   platform filepath latest ).
		mapping
			mapInstVar: #latestStable to: 'latest_stable';
			mapInstVar: #projectName to: 'project_name'; mapInstVar: #normalizedLicenses to: 'normalized_licenses' ]
]

{ #category : #printing }
LioDependency >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPut: $(;
		nextPutAll: platform;
		nextPut: $/;
		nextPutAll: name;
		space;
		nextPutAll: requirements;
		nextPut: $)
]
