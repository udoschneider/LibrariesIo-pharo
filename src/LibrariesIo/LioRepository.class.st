Class {
	#name : #LioRepository,
	#superclass : #LioObject,
	#instVars : [
		'stargazersCount',
		'defaultBranch',
		'scm',
		'language',
		'openIssuesCount',
		'hasIssues',
		'hasPages',
		'private',
		'size',
		'subscribersCount',
		'hasCoc',
		'fork',
		'name',
		'contributionsCount',
		'hasAudit',
		'lastSyncedAt',
		'rank',
		'hasWiki',
		'license',
		'hostType',
		'keywords',
		'pushedAt',
		'homepage',
		'hostDomain',
		'updatedAt',
		'hasThreatModel',
		'forkPolicy',
		'githubId',
		'forksCount',
		'hasChangelog',
		'uuid',
		'logoUrl',
		'hasContributing',
		'hasReadme',
		'description',
		'fullName',
		'pullRequestsEnabled',
		'status',
		'mirrorUrl',
		'sourceName',
		'hasLicense',
		'githubContributionsCount',
		'createdAt'
	],
	#category : #LibrariesIo
}

{ #category : #accessing }
LioRepository class >> neoJsonMapping: mapper [

	super neoJsonMapping: mapper.

	mapper for: self do: [ :mapping | 
		mapping mapInstVars:
			#( description fork  keywords language license name private
			   rank scm size status uuid ).

		mapping mapInstVar: #contributionsCount to: 'contributions_count'.
		(mapping mapInstVar: #createdAt to: 'created_at') valueSchema:
			DateAndTime.
		mapping mapInstVar: #defaultBranch to: 'default_branch'.
		mapping mapInstVar: #forkPolicy to: 'fork_policy'.
		mapping mapInstVar: #forksCount to: 'forks_count'.
		mapping mapInstVar: #fullName to: 'full_name'.
		mapping
			mapInstVar: #githubContributionsCount
			to: 'github_contributions_count'.
		mapping mapInstVar: #githubId to: 'github_id'.
		mapping mapInstVar: #hasAudit to: 'has_audit'.
		mapping mapInstVar: #hasChangelog to: 'has_changelog'.
		mapping mapInstVar: #hasCoc to: 'has_coc'.
		mapping mapInstVar: #hasContributing to: 'has_contributing'.
		mapping mapInstVar: #hasIssues to: 'has_issues'.
		mapping mapInstVar: #hasLicense to: 'has_license'.
		mapping mapInstVar: #hasPages to: 'has_pages'.
		mapping mapInstVar: #hasReadme to: 'has_readme'.
		mapping mapInstVar: #hasThreatModel to: 'has_threat_model'.
		mapping mapInstVar: #hasWiki to: 'has_wiki'.
		(mapping mapInstVar: #homepage) valueSchema: ZnUrl.
		mapping mapInstVar: #hostDomain to: 'host_domain'.
		mapping mapInstVar: #hostType to: 'host_type'.
		(mapping mapInstVar: #lastSyncedAt to: 'last_synced_at') 
			valueSchema: DateAndTime.
		(mapping mapInstVar: #logoUrl to: 'logo_url') valueSchema: ZnUrl.
		(mapping mapInstVar: #mirrorUrl to: 'mirror_url') valueSchema: ZnUrl.
		mapping mapInstVar: #openIssuesCount to: 'open_issues_count'.
		mapping mapInstVar: #pullRequestsEnabled to: 'pull_requests_enabled'.
		(mapping mapInstVar: #pushedAt to: 'pushed_at') valueSchema:
			DateAndTime.
		mapping mapInstVar: #sourceName to: 'source_name'.
		mapping mapInstVar: #stargazersCount to: 'stargazers_count'.
		mapping mapInstVar: #subscribersCount to: 'subscribers_count'.
		(mapping mapInstVar: #updatedAt to: 'updated_at') valueSchema:
			DateAndTime ]
]

{ #category : #'as yet unclassified' }
LioRepository >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPut: $(;
		nextPutAll: fullName;
		nextPut: $)
]
