Class {
	#name : #LioProject,
	#superclass : #LioObject,
	#instVars : [
		'forks',
		'latestStableReleasePublishedAt',
		'latestReleaseNumber',
		'dependentsCount',
		'normalizedLicenses',
		'name',
		'latestReleasePublishedAt',
		'rank',
		'dependentReposCount',
		'deprecationReason',
		'language',
		'homepage',
		'stars',
		'licenses',
		'platform',
		'keywords',
		'description',
		'packageManagerUrl',
		'latestDownloadUrl',
		'licenseNormalized',
		'latestStableReleaseNumber',
		'repositoryUrl',
		'repositoryLicense',
		'status',
		'versions'
	],
	#category : #LibrariesIo
}

{ #category : #accessing }
LioProject class >> neoJsonMapping: mapper [

	super neoJsonMapping: mapper.
	
	mapper for: self do: [ :mapping | 
		mapping mapInstVars:
			#( forks name rank language homepage stars licenses platform
			   keywords description status ).

		(mapping
			 mapInstVar: #latestStableReleasePublishedAt
			 to: 'latest_stable_release_published_at') valueSchema: DateAndTime.
		mapping
			mapInstVar: #latestReleaseNumber to: 'latest_release_number';
			mapInstVar: #dependentsCount to: 'dependents_count'.
		(mapping mapInstVar: #homepage to: 'homepage') valueSchema: ZnUrl.
		mapping mapInstVar: #normalizedLicenses to: 'normalized_licenses'.
		(mapping
			 mapInstVar: #latestReleasePublishedAt
			 to: 'latest_release_published_at') valueSchema: DateAndTime.
		mapping
			mapInstVar: #dependentReposCount to: 'dependent_repos_count';
			mapInstVar: #deprecationReason to: 'deprecation_reason'.
		(mapping mapInstVar: #packageManagerUrl to: 'package_manager_url') 
			valueSchema: ZnUrl.
		(mapping mapInstVar: #latestDownloadUrl to: 'latest_download_url') 
			valueSchema: ZnUrl.
		mapping
			mapInstVar: #licenseNormalized to: 'license_normalized';
			mapInstVar: #latestStableReleaseNumber
			to: 'latest_stable_release_number'.
		(mapping mapInstVar: #repositoryUrl to: 'repository_url') 
			valueSchema: ZnUrl.
		mapping mapInstVar: #repositoryLicense to: 'repository_license'.
		(mapping mapInstVar: #versions) valueSchema: #ArrayOfProjectVersion ]
]

{ #category : #accessing }
LioProject >> keywords [
	^ keywords
]

{ #category : #printing }
LioProject >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPut: $(;
		nextPutAll: platform;
		nextPut: $/;
		nextPutAll: name;
		nextPut: $)
]
