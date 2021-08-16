Class {
	#name : #LioContributor,
	#superclass : #LioObject,
	#instVars : [
		'bio',
		'lastSyncedAt',
		'uuid',
		'login',
		'hostType',
		'name',
		'email',
		'createdAt',
		'company',
		'location',
		'githubId',
		'updatedAt',
		'hidden',
		'userType',
		'blog'
	],
	#category : #LibrariesIo
}

{ #category : #accessing }
LioContributor class >> neoJsonMapping: mapper [
	super neoJsonMapping: mapper.

	mapper for: self do: [:mapping |
		mapping mapInstVars: #(bio blog company email hidden location login name uuid).

			mapping mapInstVar: #createdAt to: 'created_at'.
			mapping mapInstVar: #githubId to: 'github_id'.
			mapping mapInstVar: #hostType to: 'host_type'.
			mapping mapInstVar: #lastSyncedAt to: 'last_synced_at'.
			mapping mapInstVar: #updatedAt to: 'updated_at'.
			mapping mapInstVar: #userType to: 'user_type'.
]

]

{ #category : #printing }
LioContributor >> printOn: aStream [

	super printOn: aStream.

	aStream
		space;
		nextPut: $(;
		nextPutAll: githubId.
	name ifNotNil: [ :value | 
		aStream
			nextPutAll: ' / ';
			nextPutAll: name ].
	aStream nextPut: $)
]
