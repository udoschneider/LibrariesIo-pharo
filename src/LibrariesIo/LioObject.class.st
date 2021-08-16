Class {
	#name : #LioObject,
	#superclass : #Object,
	#category : #LibrariesIo
}

{ #category : #'as yet unclassified' }
LioObject class >> ifNotEmptyOrNil: value do: aBlock [

	value ifNil: [ ^ nil ].
	value ifEmpty: [ ^ nil ].
	^ aBlock value: value
]

{ #category : #accessing }
LioObject class >> neoJsonMapping: mapper [

	mapper
		for: ZnUrl customDo: [ :mapping | 
			mapping
				decoder: [ :value | 
					self
						ifNotEmptyOrNil: value
						do: [ :string | ZnUrl fromString: string ] ];
				encoder: [ :url | Error notYetImplemented ] ];
		for: DateAndTime customDo: [ :mapping | 
		mapping
			decoder: [ :value | 
				self
					ifNotEmptyOrNil: value
					do: [ :string | DateAndTime fromString: string ] ];
			encoder: [ :dateAndTime | Error notYetImplemented ] ];
		for: Color customDo: [ :mapping | 
		mapping
			decoder: [ :string | Color fromString: string ];
			encoder: [ :color | Error notYetImplemented ] ].
	mapper
		for: #ArrayOfProject
		customDo: [ :mapping | mapping listOfElementSchema: LioProject ];
		for: #ArrayOfPlatform
		customDo: [ :mapping | mapping listOfElementSchema: LioPlatform ];
		for: #ArrayOfProjectVersion
		customDo: [ :mapping | 
			mapping listOfElementSchema: LioProjectVersion ];
		for: #ArrayOfDependency
		customDo: [ :mapping | mapping listOfElementSchema: LioDependency ];
		for: #ArrayOfRepository
		customDo: [ :mapping | mapping listOfElementSchema: LioRepository ];
		for: #ArrayOfContributor
		customDo: [ :mapping | mapping listOfElementSchema: LioContributor ];
		for: #ArrayOfSourceRank
		customDo: [ :mapping | mapping listOfElementSchema: LioSourceRank  ]
]
