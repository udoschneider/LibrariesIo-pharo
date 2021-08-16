Class {
	#name : #LioSourceRank,
	#superclass : #LioObject,
	#instVars : [
		'anyOutdatedDependencies',
		'followsSemver',
		'allPrereleases',
		'subscribers',
		'isDeprecated',
		'versionsPresent',
		'readmePresent',
		'recentRelease',
		'isUnmaintained',
		'dependentProjects',
		'notBrandNew',
		'isRemoved',
		'repositoryPresent',
		'stars',
		'basicInfoPresent',
		'dependentRepositories',
		'licensePresent',
		'contributors',
		'onePointOh'
	],
	#category : #LibrariesIo
}

{ #category : #accessing }
LioSourceRank class >> neoJsonMapping: mapper [
	super neoJsonMapping: mapper.

	mapper for: self do: [:mapping |
		mapping mapInstVars: #(contributors stars subscribers).

			mapping mapInstVar: #allPrereleases to: 'all_prereleases'.
			mapping mapInstVar: #anyOutdatedDependencies to: 'any_outdated_dependencies'.
			mapping mapInstVar: #basicInfoPresent to: 'basic_info_present'.
			mapping mapInstVar: #dependentProjects to: 'dependent_projects'.
			mapping mapInstVar: #dependentRepositories to: 'dependent_repositories'.
			mapping mapInstVar: #followsSemver to: 'follows_semver'.
			mapping mapInstVar: #isDeprecated to: 'is_deprecated'.
			mapping mapInstVar: #isRemoved to: 'is_removed'.
			mapping mapInstVar: #isUnmaintained to: 'is_unmaintained'.
			mapping mapInstVar: #licensePresent to: 'license_present'.
			mapping mapInstVar: #notBrandNew to: 'not_brand_new'.
			mapping mapInstVar: #onePointOh to: 'one_point_oh'.
			mapping mapInstVar: #readmePresent to: 'readme_present'.
			mapping mapInstVar: #recentRelease to: 'recent_release'.
			mapping mapInstVar: #repositoryPresent to: 'repository_present'.
			mapping mapInstVar: #versionsPresent to: 'versions_present'.
]

]
