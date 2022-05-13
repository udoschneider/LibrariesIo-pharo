Class {
	#name : #LibrariesIoApi,
	#superclass : #Object,
	#instVars : [
		'api'
	],
	#classInstVars : [
		'Current'
	],
	#category : #LibrariesIo
}

{ #category : #'api definition' }
LibrariesIoApi class >> baseUrl [

	^ 'https://libraries.io/api' asUrl
]

{ #category : #'api definition' }
LibrariesIoApi class >> defineApi [

	^ CoffeeCupApi baseUrl: self baseUrl do: [ :api | 
		  api
			  title: 'API for Libraries.io';
			  description: '# Rate limit

All requests are subject to a 60/request/minute rate limit based on your `api_key`, any further requests within that timeframe will result in a 429 response.

# Pagination

All requests that return multiple results can be paginated using the `page` and `per_page` query parameters. 
';
			  reference: 'https://libraries.io/api';
			  parameter: #api_key do: [ :param | 
				  param
					  description:
						  'All API requests must include `api_key` parameter, get your api key from your [account page](https://libraries.io/account) , all examples on this page include your API key.';
					  required: true ];
			  parameter: #page
			  do: [ :param | param description: 'page (default 1)' ];
			  parameter: #per_page do: [ :param | 
			  param description:
				  'results per page (default is `30`, max is `100`)' ].
		  self definePlatformsEndpoint: api.
		  self definePlatformNamespace: api ]
]

{ #category : #'api definition' }
LibrariesIoApi class >> definePlatformNamespace: api [

	api namespace: #platform do: [ :platform | 
		platform
			title: 'Platform Namespace';
			path: '{id}';
			namespace: #project do: [ :project | 
				project
					title: 'Project Namespace';
					path: '{id}'.
				self defineProjectInformationEndpoint: project.
				self defineProjectDependenciesEndpoint: project ] ]
]

{ #category : #'api definition' }
LibrariesIoApi class >> definePlatformsEndpoint: api [

	api endpoint: #platforms do: [ :ep | 
		ep
			title: 'Platforms';
			description: 'Get a list of supported package managers';
			reference: 'https://libraries.io/api#platforms' ]
]

{ #category : #'api definition' }
LibrariesIoApi class >> defineProjectDependenciesEndpoint: project [

	^ project endpoint: #dependencies do: [ :dependencies | 
		  dependencies
			  title: 'Project Dependencies';
			  description:
				  'Get a list of dependencies for a version of a project';
			  reference: 'https://libraries.io/api#project-dependencies';
			  path: '/{version}/dependencies';
			  parameter: #version
			  do: [ :version | version description: 'Project version' ] ]
]

{ #category : #'api definition' }
LibrariesIoApi class >> defineProjectDependentsEndpoint: project [

	^ project endpoint: #dependencies do: [ :dependencies | 
		  dependencies
			  description:
				  'Get packages that have at least one version that depends on a given project. ';
			  path: '/{version}/dependents';
			  parameter: #version
			  do: [ :version | version description: 'Project version' ] ]
]

{ #category : #'api definition' }
LibrariesIoApi class >> defineProjectInformationEndpoint: project [

	project endpoint: #information do: [ :info | 
		info
			title: 'Project information';
			description: 'Get information about a package and it''s versions';
			reference: 'https://libraries.io/api#project';
			path: '' ]
]

{ #category : #examples }
LibrariesIoApi class >> exampleDocumentation [

	^ self new api documentationString inspect
]

{ #category : #examples }
LibrariesIoApi class >> examplePlatforms [

	^ self current platforms inspect 
]

{ #category : #examples }
LibrariesIoApi class >> exampleProjectContributors [

	^ (self current platform: 'NPM' projectContributors: 'base62')
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
LibrariesIoApi class >> exampleProjectInformation [

	^ (self current platform: 'NPM' projectInformation: 'base62') inspect
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

{ #category : #accessing }
LibrariesIoApi >> api [
	^ api
]

{ #category : #accessing }
LibrariesIoApi >> apiKey: aString [

	api parameter: #api_key do: [ :param | 
		param
			required: true;
			default: aString ]
]

{ #category : #initialization }
LibrariesIoApi >> initialize [

	super initialize.
	api := self class defineApi
]

{ #category : #api }
LibrariesIoApi >> platform: platform projectContributors: project [

	"Get users that have contributed to a given project."

	| response reader |
	response :=  ((api platform: platform) project: project) contributors.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader nextAs: #ArrayOfContributor
]

{ #category : #api }
LibrariesIoApi >> platform: platform projectInformation: project [

	"Get information about a package and its versions. "

	| response reader |
	response := ((api platform: platform) project: project) information.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader nextAs: LioProject
]

{ #category : #api }
LibrariesIoApi >> platforms [

	"Get a list of supported package managers. "

	| response reader |
	response := api platforms.
	reader := NeoJSONReader on: response entity readStream.
	LioObject neoJsonMapping: reader.
	^ reader nextAs: #ArrayOfPlatform
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
