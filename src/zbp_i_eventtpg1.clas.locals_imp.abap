
CLASS lhc_event DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS determineeventid
      FOR DETERMINE ON MODIFY
      IMPORTING keys FOR event~determineeventid.

    METHODS determineinitialstatus
      FOR DETERMINE ON MODIFY
      IMPORTING keys FOR event~determineinitialstatus.

    METHODS validatedates
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR event~validatedates.

    METHODS openevent
      FOR MODIFY
      IMPORTING keys FOR ACTION event~openevent
      RESULT result.

    METHODS closeevent
      FOR MODIFY
      IMPORTING keys FOR ACTION event~closeevent
      RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Event RESULT result.

ENDCLASS.


CLASS lhc_event IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determineeventid.
    SELECT MAX( event_id ) FROM zevent_g1 INTO @DATA(max_id).
    IF max_id IS INITIAL.
      max_id = 0.
    ENDIF.

    DATA(new_id) = max_id + 1.

    MODIFY ENTITY IN LOCAL MODE zi_eventtpg1
      UPDATE FIELDS ( eventid )
      WITH VALUE #( FOR key IN keys
                      ( %tky = key-%tky eventid = new_id ) ).
  ENDMETHOD.


  METHOD determineinitialstatus.
    MODIFY ENTITY IN LOCAL MODE zi_eventtpg1
      UPDATE FIELDS ( status )
      WITH VALUE #( FOR key IN keys
                      ( %tky = key-%tky status = 'P' ) ).
  ENDMETHOD.


  METHOD validatedates.
    READ ENTITY IN LOCAL MODE zi_eventtpg1
      FIELDS ( startdate enddate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(events).

    LOOP AT events INTO DATA(ev).

      " Start < Today
      IF ev-startdate < sy-datum.
        APPEND VALUE #(
          %tky = ev-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Start date cannot be in the past.' )
        ) TO reported-event.

        APPEND VALUE #( %tky = ev-%tky ) TO failed-event.
      ENDIF.

      " End < Start
      IF ev-enddate < ev-startdate.
        APPEND VALUE #(
          %tky = ev-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'End date cannot be before start date.' )
        ) TO reported-event.

        APPEND VALUE #( %tky = ev-%tky ) TO failed-event.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  METHOD openevent.
    MODIFY ENTITY IN LOCAL MODE zi_eventtpg1
      UPDATE FIELDS ( status )
      WITH VALUE #( FOR key IN keys
                      ( %tky = key-%tky status = 'O' ) ).

    READ ENTITY IN LOCAL MODE zi_eventtpg1
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(events).

    result = VALUE #( FOR e IN events
                        ( %tky = e-%tky
                          %param = e ) ).
  ENDMETHOD.


  METHOD closeevent.
    MODIFY ENTITY IN LOCAL MODE zi_eventtpg1
      UPDATE FIELDS ( status )
      WITH VALUE #( FOR key IN keys
                      ( %tky = key-%tky status = 'C' ) ).

    READ ENTITY IN LOCAL MODE zi_eventtpg1
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(events).

    result = VALUE #( FOR e IN events
                        ( %tky = e-%tky
                          %param = e ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_registration DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS determineregistrationid FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Registration~DetermineRegistrationId.

    METHODS determineinitialstatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Registration~DetermineInitialStatus.

    METHODS validatemaxparticipants FOR VALIDATE ON SAVE
      IMPORTING keys FOR Registration~ValidateMaxParticipants.

    " HIER FEHLTE DIE VALIDATEPARTICIPANT METHODE:
    METHODS validateparticipant FOR VALIDATE ON SAVE
      IMPORTING keys FOR Registration~ValidateParticipant.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Registration RESULT result.

    " Actions
    METHODS approveregistration FOR MODIFY
      IMPORTING keys FOR ACTION Registration~ApproveRegistration RESULT result.

    METHODS rejectregistration FOR MODIFY
      IMPORTING keys FOR ACTION Registration~RejectRegistration RESULT result.

ENDCLASS.

CLASS lhc_registration IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determineregistrationid.
    SELECT MAX( registration_id ) FROM zregistration_g1 INTO @DATA(max_id).
    IF max_id IS INITIAL.
      max_id = 0.
    ENDIF.
    DATA(new_id) = max_id + 1.

    MODIFY ENTITY IN LOCAL MODE ZI_Registrationtpg1
      UPDATE FIELDS ( RegistrationId )
      WITH VALUE #( FOR key IN keys
                    ( %tky = key-%tky RegistrationId = new_id ) ).
  ENDMETHOD.

  METHOD determineinitialstatus.
    MODIFY ENTITY IN LOCAL MODE ZI_Registrationtpg1
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys
                    ( %tky = key-%tky Status = 'New' ) ).
  ENDMETHOD.

  METHOD validatemaxparticipants.
    READ ENTITY IN LOCAL MODE ZI_Registrationtpg1
      FIELDS ( EventUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(registrations).

    LOOP AT registrations INTO DATA(reg).
      READ ENTITY IN LOCAL MODE ZI_Eventtpg1
        FIELDS ( MaxParticipants Title )
        WITH VALUE #( ( %key-EventUuid = reg-EventUuid ) )
        RESULT DATA(events).

      READ TABLE events INTO DATA(event) INDEX 1.

      SELECT COUNT( * ) FROM zregistration_g1
        WHERE event_uuid = @reg-EventUuid
        INTO @DATA(current_count).

      IF current_count >= event-MaxParticipants.
         APPEND VALUE #(
           %tky = reg-%tky
           %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-error
                    text     = 'Max participants exceeded!' )
         ) TO reported-registration.
         APPEND VALUE #( %tky = reg-%tky ) TO failed-registration.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD approveregistration.
    READ ENTITY IN LOCAL MODE ZI_Registrationtpg1
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(registrations).

    LOOP AT registrations INTO DATA(registration).
      IF registration-Status = 'Approved'.
         APPEND VALUE #( %tky = registration-%tky
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Already approved.' )
                       ) TO reported-registration.
         APPEND VALUE #( %tky = registration-%tky ) TO failed-registration.
      ELSEIF registration-Status = 'Rejected'.
         APPEND VALUE #( %tky = registration-%tky
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Already rejected.' )
                       ) TO reported-registration.
         APPEND VALUE #( %tky = registration-%tky ) TO failed-registration.
      ELSE.
         MODIFY ENTITY IN LOCAL MODE ZI_Registrationtpg1
           UPDATE FIELDS ( Status )
           WITH VALUE #( ( %tky = registration-%tky Status = 'Approved' ) ).

         APPEND VALUE #( %tky = registration-%tky
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Approved successfully.' )
                       ) TO reported-registration.
      ENDIF.
    ENDLOOP.

    READ ENTITY IN LOCAL MODE ZI_Registrationtpg1
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT registrations.

    result = VALUE #( FOR r IN registrations
                      ( %tky = r-%tky %param = r ) ).
  ENDMETHOD.

  METHOD rejectregistration.
    READ ENTITY IN LOCAL MODE ZI_Registrationtpg1
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(registrations).

    LOOP AT registrations INTO DATA(registration).
      IF registration-Status = 'Rejected'.
         APPEND VALUE #( %tky = registration-%tky
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Already rejected.' )
                       ) TO reported-registration.
         APPEND VALUE #( %tky = registration-%tky ) TO failed-registration.
      ELSEIF registration-Status = 'Approved'.
         APPEND VALUE #( %tky = registration-%tky
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Already approved.' )
                       ) TO reported-registration.
         APPEND VALUE #( %tky = registration-%tky ) TO failed-registration.
      ELSE.
         MODIFY ENTITY IN LOCAL MODE ZI_Registrationtpg1
           UPDATE FIELDS ( Status )
           WITH VALUE #( ( %tky = registration-%tky Status = 'Rejected' ) ).

         APPEND VALUE #( %tky = registration-%tky
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Rejected successfully.' )
                       ) TO reported-registration.
      ENDIF.
    ENDLOOP.

    READ ENTITY IN LOCAL MODE ZI_Registrationtpg1
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT registrations.

    result = VALUE #( FOR r IN registrations
                      ( %tky = r-%tky %param = r ) ).
  ENDMETHOD.

  METHOD ValidateParticipant.

    " 1. Daten lesen (Wichtig: Wir brauchen auch die RegistrationUuid zum Vergleich!)
    READ ENTITIES OF ZI_Eventtpg1 IN LOCAL MODE
      ENTITY Registration
      FIELDS ( EventUuid ParticipantUuid RegistrationUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(new_registrations).

    LOOP AT new_registrations INTO DATA(new_reg).

      " ====================================================================
      " --- CHECK A: Mandatory Field (Verhindert leeren GUID/Initial) ---
      " ====================================================================
      IF new_reg-ParticipantUuid IS INITIAL.
          APPEND VALUE #( %tky = new_reg-%tky ) TO failed-registration.
          APPEND VALUE #( %tky = new_reg-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = 'Participant selection is mandatory.' )
                          %element-ParticipantUuid = if_abap_behv=>mk-on )
                        TO reported-registration.
          CONTINUE.
      ENDIF.

      " ====================================================================
      " --- CHECK B: Duplicate Entry (Verhindert doppelte Anmeldung) ---
      " ====================================================================

      " Prüfe in der DB, ob es eine ANDERE Registrierung mit gleichen Daten gibt
      SELECT SINGLE FROM zregistration_g1 AS reg
        FIELDS reg~registration_uuid
        WHERE reg~event_uuid       = @new_reg-EventUuid
          AND reg~participant_uuid = @new_reg-ParticipantUuid
          AND reg~registration_uuid <> @new_reg-RegistrationUuid " <--- WICHTIG: Mich selbst ausschließen!
        INTO @DATA(existing_registration).

      IF sy-subrc = 0.
          APPEND VALUE #( %tky = new_reg-%tky ) TO failed-registration.
          APPEND VALUE #( %tky = new_reg-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = 'This participant is already registered for this event.' )
                          %element-ParticipantUuid = if_abap_behv=>mk-on )
                        TO reported-registration.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


ENDCLASS.
