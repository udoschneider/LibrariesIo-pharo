Class {
	#name : #LioProjectWithDependencies,
	#superclass : #LioProject,
	#instVars : [
		'dependencies',
		'dependenciesForVersion'
	],
	#category : #LibrariesIo
}

{ #category : #accessing }
LioProjectWithDependencies class >> neoJsonMapping: mapper [

	super neoJsonMapping: mapper.

	mapper for: self do: [ :mapping | 
		mapping
			mapInstVar: #dependenciesForVersion
			to: 'dependencies_for_version'.
		(mapping mapInstVar: #dependencies) valueSchema: #ArrayOfDependency ]
]
