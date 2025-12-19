@EndUserText.label: 'Root-Business-Object Veranstaltung'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true             
@Metadata.ignorePropagatedAnnotations: true 
define root view entity ZC_EVENTTPG1
  provider contract transactional_query
  as projection on ZI_EventTPG1
{
  key EventUuid,
  
      @EndUserText.label: 'Event ID'
      EventId,
      
      @EndUserText.label: 'Title'
      Title,
      
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @EndUserText.label: 'Location'
      Location,
      
      @EndUserText.label: 'Start Date'
      StartDate,
      
      @EndUserText.label: 'End Date'
      EndDate,
      
      @EndUserText.label: 'Max. Participants'
      MaxParticipants,
      
      @EndUserText.label: 'Status'
      StatusText,
      
      @EndUserText.label: 'Status Code'
      Status,
      
      @EndUserText.label: 'Description'
      Description,
      
      /* Admin Data */
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Created At'
      CreatedAt,
      @EndUserText.label: 'Last Changed By'
      LastChangedBy,
      @EndUserText.label: 'Last Changed At'
      LastChangedAt,
      
      /* Associations */
      _Registrations : redirected to composition child ZC_REGISTRATIONTPG1
}
