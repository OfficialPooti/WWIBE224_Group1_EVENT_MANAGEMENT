CLASS zcl_g1_event_datagen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS zcl_g1_event_datagen IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: lt_events        TYPE TABLE OF zevent_g1,
          lt_participants  TYPE TABLE OF zparticipant_g1,
          lt_registrations TYPE TABLE OF zregistration_g1,
          ls_event         TYPE zevent_g1,
          ls_participant   TYPE zparticipant_g1,
          ls_registration  TYPE zregistration_g1.


    DELETE FROM zregistration_g1.
    DELETE FROM zevent_g1.
    DELETE FROM zparticipant_g1.

    DELETE FROM zregistratio_g1d.
    DELETE FROM zevent_g1d.
    DELETE FROM zparticipant_g1d.

    COMMIT WORK.
    out->write( |Vorherige Testdaten gelöscht.| ).


    TYPES char50 TYPE c LENGTH 50.

    DATA: lt_firstnames TYPE STANDARD TABLE OF char50 WITH DEFAULT KEY,
          lt_lastnames  TYPE STANDARD TABLE OF char50 WITH DEFAULT KEY.

    lt_firstnames = VALUE #(
      ( 'Anna' )
      ( 'Markus' )
      ( 'Julia' )
      ( 'Sebastian' )
      ( 'Laura' )
    ).

    lt_lastnames = VALUE #(
      ( 'Müller' )
      ( 'Schneider' )
      ( 'Fischer' )
      ( 'Weber' )
      ( 'Koch' )
    ).

    DATA(lv_index) = 0.

    LOOP AT lt_firstnames ASSIGNING FIELD-SYMBOL(<fn>).
      lv_index += 1.
      READ TABLE lt_lastnames ASSIGNING FIELD-SYMBOL(<ln>) INDEX lv_index.

      CLEAR ls_participant.
      ls_participant-client           = sy-mandt.
      ls_participant-participant_uuid = cl_system_uuid=>create_uuid_x16_static( ).
      ls_participant-participant_id   = lv_index.
      ls_participant-first_name       = <fn>.
      ls_participant-last_name        = <ln>.
      ls_participant-email            = |{ to_lower( <fn> ) }.{ to_lower( <ln> ) }@beispiel.de|.
      ls_participant-phone            = |+49 30 12345{ lv_index }|.
      ls_participant-created_by       = sy-uname.
      GET TIME STAMP FIELD ls_participant-created_at.
      ls_participant-last_changed_by  = sy-uname.
      GET TIME STAMP FIELD ls_participant-last_changed_at.

      APPEND ls_participant TO lt_participants.
    ENDLOOP.

    INSERT zparticipant_g1 FROM TABLE @lt_participants.
    out->write( |Teilnehmer angelegt: { lines( lt_participants ) }| ).


    TYPES char100 TYPE c LENGTH 100.

    DATA: lt_titles    TYPE STANDARD TABLE OF char100 WITH DEFAULT KEY,
          lt_locations TYPE STANDARD TABLE OF char100 WITH DEFAULT KEY.

    lt_titles = VALUE #(
      ( 'SAP Tech Days 2025' )
      ( 'Berliner Innovationsforum' )
      ( 'Hamburger Digitalmesse' )
      ( 'Kölner Entwicklerkonferenz' )
      ( 'Münchner IT-Sicherheitskongress' )
    ).

    lt_locations = VALUE #(
      ( 'Walldorf' )
      ( 'Berlin' )
      ( 'Hamburg' )
      ( 'Köln' )
      ( 'München' )
    ).

    lv_index = 0.

    LOOP AT lt_titles ASSIGNING FIELD-SYMBOL(<title>).
      lv_index += 1.
      READ TABLE lt_locations ASSIGNING FIELD-SYMBOL(<loc>) INDEX lv_index.

      CLEAR ls_event.
      ls_event-client     = sy-mandt.
      ls_event-event_uuid = cl_system_uuid=>create_uuid_x16_static( ).
      ls_event-event_id   = lv_index.
      ls_event-title      = <title>.
      ls_event-location   = <loc>.

      CASE lv_index.
        WHEN 1.
          ls_event-start_date = sy-datum + 5.
          ls_event-end_date   = ls_event-start_date + 2.

        WHEN 2.
          ls_event-start_date = sy-datum + 10.
          ls_event-end_date   = ls_event-start_date + 1.

        WHEN 3.
          ls_event-start_date = sy-datum + 20.
          ls_event-end_date   = ls_event-start_date + 3.

        WHEN 4.
          ls_event-start_date = sy-datum + 30.
          ls_event-end_date   = ls_event-start_date + 2.

        WHEN 5.
          ls_event-start_date = sy-datum + 90.
          ls_event-end_date   = ls_event-start_date + 1.
      ENDCASE.

      ls_event-max_participants = 150.
      ls_event-status           = 'P'.
      ls_event-description      =
        |{ <title> } in { <loc> }: Fachveranstaltung für IT- und Digitalexperten.|.

      ls_event-created_by       = sy-uname.
      GET TIME STAMP FIELD ls_event-created_at.
      ls_event-last_changed_by  = sy-uname.
      GET TIME STAMP FIELD ls_event-last_changed_at.

      APPEND ls_event TO lt_events.
    ENDLOOP.

    INSERT zevent_g1 FROM TABLE @lt_events.
    out->write( |Veranstaltungen angelegt: { lines( lt_events ) }| ).


    DATA(lv_reg_index) = 0.
    DATA(lv_p_index)   = 0.

    LOOP AT lt_participants ASSIGNING FIELD-SYMBOL(<p>).
      lv_p_index += 1.

      DO lv_p_index TIMES.
        READ TABLE lt_events ASSIGNING FIELD-SYMBOL(<e>) INDEX sy-index.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.

        lv_reg_index += 1.
        CLEAR ls_registration.
        ls_registration-client            = sy-mandt.
        ls_registration-registration_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        ls_registration-registration_id   = lv_reg_index.
        ls_registration-event_uuid        = <e>-event_uuid.
        ls_registration-participant_uuid  = <p>-participant_uuid.
        ls_registration-status            = 'New'.
        ls_registration-remarks           =
          |{ <p>-first_name } { <p>-last_name } ist für "{ <e>-title }" angemeldet.|.

        ls_registration-created_by        = sy-uname.
        GET TIME STAMP FIELD ls_registration-created_at.
        ls_registration-last_changed_by   = sy-uname.
        GET TIME STAMP FIELD ls_registration-last_changed_at.

        APPEND ls_registration TO lt_registrations.
      ENDDO.
    ENDLOOP.

    INSERT zregistration_g1 FROM TABLE @lt_registrations.
    out->write( |Registrierungen angelegt: { lines( lt_registrations ) }| ).


    out->write(
      |Testdaten erfolgreich erzeugt: Teilnehmer={ lines( lt_participants ) }, |
      && |Events={ lines( lt_events ) }, Registrierungen={ lines( lt_registrations ) }.|
    ).

  ENDMETHOD.
ENDCLASS.

