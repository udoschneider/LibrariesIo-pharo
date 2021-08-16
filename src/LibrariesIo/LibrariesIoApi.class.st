Class {
	#name : #LibrariesIoApi,
	#superclass : #Object,
	#instVars : [
		'client',
		'apiKey',
		'requests',
		'cache'
	],
	#classInstVars : [
		'Current'
	],
	#category : #LibrariesIo
}

{ #category : #accessing }
LibrariesIoApi class >> current [

	^ Current ifNil: [ 
		 
		  Current := self new ]
]

{ #category : #examples }
LibrariesIoApi class >> examplePlatforms [


	^ self current platforms inspect
]

{ #category : #examples }
LibrariesIoApi class >> exampleProject [

	^ (self current project: 'NPM' name: 'base62') inspect
]

{ #category : #examples }
LibrariesIoApi class >> exampleProjectContributors [

	^ (self current projectContributors: 'NPM' name: 'base62')
		  inspect
]

{ #category : #examples }
LibrariesIoApi class >> exampleProjectDependencies [

	^ (self current projectDependencies: 'NPM' name: 'base62' version: '2.0.1') inspect
]

{ #category : #examples }
LibrariesIoApi class >> exampleProjectDependentRepositories [

	^ (self current projectDependentRepositories: 'NPM' name: 'base62') inspect
]

{ #category : #examples }
LibrariesIoApi class >> exampleProjectDependents [

	^ (self current projectDependents: 'NPM' name: 'base62') inspect
]

{ #category : #examples }
LibrariesIoApi class >> exampleProjectSearch1 [

	^ (self current projectSearch: 'grunt') inspect
]

{ #category : #examples }
LibrariesIoApi class >> exampleProjectSearch2 [

	

	^ (self current
		  
		   projectSearch: 'grunt'
		   filter: { ('keywords' -> 'mocha') } asDictionary
		   sortBy: 'rank') inspect
]

{ #category : #examples }
LibrariesIoApi class >> exampleProjectSourceRank [

	^ (self current projectSourceRank: 'NPM' name: 'base62') inspect
]

{ #category : #initialization }
LibrariesIoApi class >> reset [

	Current := nil.
]

{ #category : #private }
LibrariesIoApi >> apiGet: path [

	^ self apiGet: path queries: Dictionary new
]

{ #category : #private }
LibrariesIoApi >> apiGet: path queries: queries [

	| response url |
	url := self baseUrl / path & (#api_key -> self apiKey) & (#per_page -> 100).
	url queryAddAll: queries.
	^ self cacheAt: url ifAbsentPut: [ 
		  response := self client
			              url: url;
			              execute;
			              response.
		  response isSuccess ifFalse: [ ^ Error signal: 'response contents' ].
		  (response contentType matches: ZnMimeType applicationJson) 
			  ifFalse: [ ^ Error signal: 'Wrong content type. JSON expected!' ].
		  response ]
]

{ #category : #accessing }
LibrariesIoApi >> apiKey [

	apiKey ifNil: [ Error signal: 'API key not set!' ].
	^ apiKey 
]

{ #category : #accessing }
LibrariesIoApi >> apiKey: aString [
apiKey := aString
]

{ #category : #private }
LibrariesIoApi >> baseUrl [

	^ 'https://libraries.io/api' asUrl
]

{ #category : #private }
LibrariesIoApi >> cacheAt: key ifAbsentPut: aBlock [
^aBlock value
	"^ cache at: key ifAbsentPut: aBlock"
]

{ #category : #private }
LibrariesIoApi >> client [

	^ client := ZnClient new
		            method: #GET;
		            timeout: 120;
		            yourself
]

{ #category : #initialization }
LibrariesIoApi >> initialize [

	super initialize.
	requests := OrderedCollection new.
	cache := TTLCache new
]

{ #category : #api }
LibrariesIoApi >> platforms [
"Get a list of supported package managers. "
	| response reader |
	response := self apiGet: 'platforms'.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader nextAs: #ArrayOfPlatform
]

{ #category : #api }
LibrariesIoApi >> project: platform name: name [
"Get information about a package and its versions. "
	| response reader |
	response := self apiGet: platform , '/' , name.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader nextAs: LioProject
]

{ #category : #api }
LibrariesIoApi >> projectContributors: platform name: name [

	"Get users that have contributed to a given project."

	| response reader |
	response := self apiGet: platform , '/' , name , '/contributors'.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader nextAs: #ArrayOfContributor
]

{ #category : #api }
LibrariesIoApi >> projectDependencies: platform name: name version: version [

	"Get packages that have at least one version that depends on a given project. "

	| response reader |
	response := self apiGet:
		            platform , '/' , name , '/' , version , '/dependencies'.
		self halt.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader nextAs: LioProjectWithDependencies
]

{ #category : #api }
LibrariesIoApi >> projectDependentRepositories: platform name: name [

	"Get packages that have at least one version that depends on a given project."

	| response reader |
	response := self apiGet:
		            platform , '/' , name , '/dependent_repositories'.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader nextAs: #ArrayOfRepository
]

{ #category : #api }
LibrariesIoApi >> projectDependents: platform name: name [

	"Get packages that have at least one version that depends on a given project."

	| response reader |
	response := self apiGet: platform , '/' , name , '/dependents'.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader nextAs: #ArrayOfProject
]

{ #category : #api }
LibrariesIoApi >> projectSearch: query [

	"Search for projects"

	| queries response reader |
	queries := Dictionary new
		           at: 'q' put: query;
		           yourself.
	response := self apiGet: 'search' queries: queries.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader nextAs: #ArrayOfProject
]

{ #category : #api }
LibrariesIoApi >> projectSearch: query filter: filterDictionary sortBy: sortKey [

	"Search for projects
	
	 The search endpoint accepts a sort parameter, one of rank, stars, dependents_count,
	dependent_repos_count, latest_release_published_at, contributions_count, created_at.

	The search endpoint accepts number of other parameters to filter results:

    	languages
    	licenses
    	keywords
    	platforms
	"

	| queries response reader |
	queries := Dictionary new
		           at: 'q' put: query;
		           yourself.
	filterDictionary notEmpty ifTrue: [ queries addAll: filterDictionary ].
	sortKey notNil ifTrue: [ queries at: 'sort' put: sortKey ].
	response := self apiGet: 'search' queries: queries.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader next"As: #ArrayOfProject"
]

{ #category : #api }
LibrariesIoApi >> projectSourceRank: platform name: name [

	"Get breakdown of SourceRank score for a given project."

	| response reader |
	response := self apiGet: platform , '/' , name , '/sourcerank'.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader nextAs: LioSourceRank 
]
