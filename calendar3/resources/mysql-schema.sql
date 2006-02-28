alter table adminGroupMembers drop foreign key FK3D8EC689891E4122;
alter table adminGroups drop foreign key FKCE66D203FCC6CD69;
alter table adminGroups drop foreign key FKCE66D2037094B8E3;
alter table alarm_attendees drop foreign key FK19F64E8B4E9CEE71;
alter table alarm_attendees drop foreign key FK19F64E8BAEDD20DC;
alter table alarms drop foreign key FKABA5D0427094B8E3;
alter table alarms drop foreign key FKABA5D0427BAF9231;
alter table alarms drop foreign key FKABA5D042ECC95E3C;
alter table auth drop foreign key FK2DDDA87D9DCBFB;
alter table authprefCalendars drop foreign key FK296C356A3D2DC521;
alter table authprefCalendars drop foreign key FK296C356A6D224B2B;
alter table authprefCategories drop foreign key FK37D48C477E8BD8A1;
alter table authprefCategories drop foreign key FK37D48C476D224B2B;
alter table authprefLocations drop foreign key FK2B901FD36D224B2B;
alter table authprefLocations drop foreign key FK2B901FD3FB77CC4F;
alter table authprefSponsors drop foreign key FK7D7DE5845A307285;
alter table authprefSponsors drop foreign key FK7D7DE5846D224B2B;
alter table calendars drop foreign key FKB6806CF57094B8E3;
alter table calendars drop foreign key FKB6806CF5E84B9CF2;
alter table calendars drop foreign key FKB6806CF5D321CC1C;
alter table categories drop foreign key FK4D47461C7094B8E3;
alter table categories drop foreign key FK4D47461CD321CC1C;
alter table eventAnnotations drop foreign key FKA912EC2A5A307285;
alter table eventAnnotations drop foreign key FKA912EC2A7094B8E3;
alter table eventAnnotations drop foreign key FKA912EC2A3D2DC521;
alter table eventAnnotations drop foreign key FKA912EC2AD321CC1C;
alter table eventAnnotations drop foreign key FKA912EC2A4FC14404;
alter table eventAnnotations drop foreign key FKA912EC2A247D7B73;
alter table eventAnnotations drop foreign key FKA912EC2AFB77CC4F;
alter table eventAnnotations drop foreign key FKA912EC2AEB04EBEF;
alter table event_annotation_attendees drop foreign key FK7D0DEE6E4E9CEE71;
alter table event_annotation_attendees drop foreign key FK7D0DEE6E13EADC74;
alter table event_annotation_categories drop foreign key FKDD91477E8BD8A1;
alter table event_annotation_categories drop foreign key FKDD914750C58A54;
alter table event_annotationexdates drop foreign key FK38128D3E50C58A54;
alter table event_annotationrdates drop foreign key FK2767404750C58A54;
alter table event_annotationrrules drop foreign key FK283582B950C58A54;
alter table event_attendees drop foreign key FK1943F944E9CEE71;
alter table event_attendees drop foreign key FK1943F94ECC95E3C;
alter table event_categories drop foreign key FKD2164E17E8BD8A1;
alter table event_categories drop foreign key FKD2164E1ECC95E3C;
alter table eventexdates drop foreign key FK84343DD8ECC95E3C;
alter table eventrdates drop foreign key FK3A60146DECC95E3C;
alter table eventrrules drop foreign key FK3B2E56DFECC95E3C;
alter table events drop foreign key FKB307E1195A307285;
alter table events drop foreign key FKB307E1197094B8E3;
alter table events drop foreign key FKB307E1193D2DC521;
alter table events drop foreign key FKB307E119D321CC1C;
alter table events drop foreign key FKB307E119FB77CC4F;
alter table events drop foreign key FKB307E119EB04EBEF;
alter table filter_categories drop foreign key FKFE8575438A948DF;
alter table filter_categories drop foreign key FKFE8575437E8BD8A1;
alter table filter_creators drop foreign key FK85FF52AEF90D3261;
alter table filter_creators drop foreign key FK85FF52AED321CC1C;
alter table filter_locations drop foreign key FKCEE027579ED90656;
alter table filter_locations drop foreign key FKCEE02757FB77CC4F;
alter table filter_sponsors drop foreign key FKAC0CDD805A307285;
alter table filter_sponsors drop foreign key FKAC0CDD80763F9ACF;
alter table filters drop foreign key FKCD10A3FB7094B8E3;
alter table filters drop foreign key FKCD10A3FBA562A89B;
alter table filters drop foreign key FKCD10A3FB36B842E3;
alter table filters drop foreign key FKCD10A3FBBA2D9A58;
alter table locations drop foreign key FKB8A4575E7094B8E3;
alter table locations drop foreign key FKB8A4575ED321CC1C;
alter table preferences drop foreign key FK769ADEF87094B8E3;
alter table preferences drop foreign key FK769ADEF85C7181DF;
alter table properties drop foreign key FKC8CD8D33329258C5;
alter table recurrences drop foreign key FKD6034B433910AF06;
alter table recurrences drop foreign key FKD6034B434FC14404;
alter table sponsors drop foreign key FK928F10997094B8E3;
alter table sponsors drop foreign key FK928F1099D321CC1C;
alter table subscriptions drop foreign key FK7674CAF67094B8E3;
alter table synchdata drop foreign key FK1DF1CA577D9DCBFB;
alter table synchinfo drop foreign key FK1DF43F5B7D9DCBFB;
alter table synchstate drop foreign key FKA1233F847D9DCBFB;
alter table synchstate drop foreign key FKA1233F84ECC95E3C;
alter table timezones drop foreign key FK3A9B79A7094B8E3;
alter table user_subscriptions drop foreign key FK5CFF898228D230A2;
alter table user_subscriptions drop foreign key FK5CFF8982EA44079E;
alter table user_views drop foreign key FK737824FA7CFB6A2A;
alter table user_views drop foreign key FK737824FAEA44079E;
alter table userinfo drop foreign key FKF02772F97D9DCBFB;
alter table view_subscriptions drop foreign key FKBC37D2DC4C4D13FD;
alter table view_subscriptions drop foreign key FKBC37D2DC28D230A2;
alter table views drop foreign key FK6B01A6E7094B8E3;
drop table if exists adminGroupMembers;
drop table if exists adminGroups;
drop table if exists alarm_attendees;
drop table if exists alarms;
drop table if exists attendees;
drop table if exists auth;
drop table if exists authprefCalendars;
drop table if exists authprefCategories;
drop table if exists authprefLocations;
drop table if exists authprefSponsors;
drop table if exists authprefs;
drop table if exists bedework_settings;
drop table if exists calendars;
drop table if exists categories;
drop table if exists eventAnnotations;
drop table if exists event_annotation_attendees;
drop table if exists event_annotation_categories;
drop table if exists event_annotationexdates;
drop table if exists event_annotationrdates;
drop table if exists event_annotationrrules;
drop table if exists event_attendees;
drop table if exists event_categories;
drop table if exists eventexdates;
drop table if exists eventrdates;
drop table if exists eventrrules;
drop table if exists events;
drop table if exists filter_categories;
drop table if exists filter_creators;
drop table if exists filter_locations;
drop table if exists filter_sponsors;
drop table if exists filters;
drop table if exists locations;
drop table if exists organizers;
drop table if exists preferences;
drop table if exists properties;
drop table if exists recurrences;
drop table if exists sponsors;
drop table if exists subscriptions;
drop table if exists synchdata;
drop table if exists synchinfo;
drop table if exists synchstate;
drop table if exists timezones;
drop table if exists todos;
drop table if exists user_subscriptions;
drop table if exists user_views;
drop table if exists userinfo;
drop table if exists users;
drop table if exists view_subscriptions;
drop table if exists views;
create table adminGroupMembers (
    groupid integer not null,
    memberid integer not null,
    member_is_group char(1) not null,
    primary key (groupid, memberid, member_is_group)
) type=InnoDB;
create table adminGroups (
    userid integer not null auto_increment,
    seq integer not null,
    name text,
    description text,
    groupOwner integer not null,
    ownerid integer not null,
    primary key (userid)
) type=InnoDB;
create table alarm_attendees (
    attendeeid integer not null,
    elt integer not null,
    primary key (attendeeid, elt)
) type=InnoDB;
create table alarms (
    alarmid integer not null auto_increment,
    sequence integer not null,
    alarm_type integer,
    ownerid integer not null,
    trigger text,
    trigger_start char(1) not null,
    duration text,
    repeat integer,
    attach text,
    description text,
    summary text,
    trigger_time bigint,
    previous_trigger bigint,
    repeat_count integer,
    expired char(1) not null,
    eventid integer,
    todoid integer,
    primary key (alarmid)
) type=InnoDB;
create table attendees (
    attendeeid integer not null auto_increment,
    sequence integer not null,
    cn text,
    cutype text,
    delegated_from text,
    delegated_to text,
    dir text,
    lang text,
    member text,
    rsvp char(1),
    role text,
    partstat text,
    sent_by text,
    attendee_uri text,
    primary key (attendeeid)
) type=InnoDB;
create table auth (
    userid integer not null,
    usertype integer,
    primary key (userid)
) type=InnoDB;
create table authprefCalendars (
    userid integer not null,
    calendarid integer,
    primary key (userid, calendarid)
) type=InnoDB;
create table authprefCategories (
    userid integer not null,
    categoryid integer,
    primary key (userid, categoryid)
) type=InnoDB;
create table authprefLocations (
    userid integer not null,
    locationid integer,
    primary key (userid, locationid)
) type=InnoDB;
create table authprefSponsors (
    userid integer not null,
    sponsorid integer,
    primary key (userid, sponsorid)
) type=InnoDB;
create table authprefs (
    userid integer not null,
    autoaddCategories char(1) not null,
    autoaddLocations char(1) not null,
    autoaddSponsors char(1) not null,
    autoaddCalendars char(1) not null,
    primary key (userid)
) type=InnoDB;
create table bedework_settings (
    id integer not null auto_increment,
    seq integer not null,
    name text,
    tzid text,
    systemid text,
    publicCalendarRoot text,
    userCalendarRoot text,
    userDefaultCalendar text,
    defaultTrashCalendar text,
    userInbox text,
    userOutbox text,
    defaultUserViewName text,
    public_user text,
    http_connections_per_user integer,
    http_connections_per_host integer,
    http_connections integer,
    maxPublicDescriptionLength integer,
    maxUserDescriptionLength integer,
    maxUserEntitySize integer,
    defaultUserQuota bigint,
    userauth_class text,
    mailer_class text,
    admingroups_class text,
    usergroups_class text,
    primary key (id)
) type=InnoDB;
create table calendars (
    id integer not null auto_increment,
    seq integer not null,
    creatorid integer not null,
    ownerid integer not null,
    access text,
    publick char(1) not null,
    name text not null,
    path text not null,
    summary text,
    description text,
    mail_list_id text,
    calendar_collection char(1) not null,
    parent integer,
    primary key (id)
) type=InnoDB;
create table categories (
    categoryid integer not null auto_increment,
    seq integer not null,
    creatorid integer not null,
    ownerid integer not null,
    access text,
    publick char(1) not null,
    word varchar(255) not null,
    description text,
    primary key (categoryid),
    unique (ownerid, word)
) type=InnoDB;
create table eventAnnotations (
    eventid integer not null auto_increment,
    seq integer not null,
    creatorid integer,
    ownerid integer,
    access text,
    publick char(1),
    start_date_type char(1),
    start_tzid varchar(255),
    start_dtval varchar(255),
    start_date varchar(255),
    end_date_type char(1),
    end_tzid varchar(255),
    end_dtval varchar(255),
    end_date varchar(255),
    duration varchar(255),
    end_type char(1),
    deleted char(1),
    summary varchar(255),
    description text,
    link varchar(255),
    status varchar(255),
    cost varchar(255),
    organizerid integer unique,
    calendarid integer,
    dtstamp varchar(255),
    lastmod varchar(255),
    created varchar(255),
    priority integer,
    sponsorid integer,
    locationid integer,
    eventname text,
    guid text,
    sequence integer,
    transparency text,
    categories_changed char(1),
    attendees_changed char(1),
    recurring char(1),
    recurrence_changed char(1),
    recurrence_id varchar(255),
    latest_date varchar(255),
    expanded char(1),
    targetid integer,
    masterid integer,
    primary key (eventid),
    unique (calendarid, guid(100), recurrence_id)
) type=InnoDB;
create table event_annotation_attendees (
    attendeeid integer not null,
    elt integer not null,
    primary key (attendeeid, elt)
) type=InnoDB;
create table event_annotation_categories (
    eventid integer not null,
    categoryid integer not null,
    primary key (eventid, categoryid)
) type=InnoDB;
create table event_annotationexdates (
    eventid integer not null,
    exdate varchar(255)
) type=InnoDB;
create table event_annotationrdates (
    eventid integer not null,
    rdate varchar(255)
) type=InnoDB;
create table event_annotationrrules (
    eventid integer not null,
    rrule varchar(255)
) type=InnoDB;
create table event_attendees (
    eventid integer not null,
    elt integer not null,
    primary key (eventid, elt)
) type=InnoDB;
create table event_categories (
    eventid integer not null,
    categoryid integer not null,
    primary key (eventid, categoryid)
) type=InnoDB;
create table eventexdates (
    eventid integer not null,
    exdate varchar(255) not null,
    primary key (eventid, exdate)
) type=InnoDB;
create table eventrdates (
    eventid integer not null,
    rdate varchar(255) not null,
    primary key (eventid, rdate)
) type=InnoDB;
create table eventrrules (
    eventid integer not null,
    rrule varchar(255) not null,
    primary key (eventid, rrule)
) type=InnoDB;
create table events (
    eventid integer not null auto_increment,
    seq integer not null,
    creatorid integer not null,
    ownerid integer not null,
    access text,
    publick char(1) not null,
    start_date_type char(1) not null,
    start_tzid varchar(255),
    start_dtval varchar(255) not null,
    start_date varchar(255) not null,
    end_date_type char(1),
    end_tzid varchar(255),
    end_dtval varchar(255),
    end_date varchar(255),
    duration varchar(255),
    end_type char(1) not null,
    deleted char(1) not null,
    summary varchar(255) not null,
    description text,
    link varchar(255),
    status varchar(255),
    cost varchar(255),
    organizerid integer unique,
    calendarid integer,
    dtstamp varchar(255),
    lastmod varchar(255) not null,
    created varchar(255) not null,
    priority integer not null,
    sponsorid integer,
    locationid integer,
    eventname text,
    guid text,
    sequence integer,
    transparency text,
    categories_changed char(1) not null,
    attendees_changed char(1) not null,
    recurring char(1) not null,
    recurrence_changed char(1) not null,
    recurrence_id varchar(255),
    latest_date varchar(255),
    expanded char(1) not null,
    primary key (eventid),
    unique (calendarid, guid(100), recurrence_id)
) type=InnoDB;
create table filter_categories (
    filterid integer not null,
    categoryid integer not null,
    primary key (filterid, categoryid)
) type=InnoDB;
create table filter_creators (
    filterid integer not null,
    creatorid integer not null,
    primary key (filterid, creatorid)
) type=InnoDB;
create table filter_locations (
    filterid integer not null,
    locationid integer not null,
    primary key (filterid, locationid)
) type=InnoDB;
create table filter_sponsors (
    filterid integer not null,
    sponsorid integer not null,
    primary key (filterid, sponsorid)
) type=InnoDB;
create table filters (
    filterid integer not null auto_increment,
    type char(1) not null,
    name varchar(200),
    description text,
    negated char(1) not null,
    ownerid integer not null,
    publick char(1) not null,
    parent integer,
    primary key (filterid)
) type=InnoDB;
create table locations (
    entityid integer not null auto_increment,
    seq integer not null,
    creatorid integer not null,
    ownerid integer not null,
    access text,
    publick char(1) not null,
    address varchar(255) not null,
    subaddress varchar(255),
    link varchar(255),
    primary key (entityid),
    unique (ownerid, address)
) type=InnoDB;
create table organizers (
    alarmid integer not null auto_increment,
    seq integer not null,
    cn text,
    dir text,
    language text,
    sent_by text,
    organizer_uri text,
    primary key (alarmid)
) type=InnoDB;
create table preferences (
    prefid integer not null auto_increment,
    seq integer not null,
    ownerid integer not null unique,
    email varchar(255),
    default_calendarid integer,
    skin_name varchar(255),
    skin_style varchar(255),
    preferred_view varchar(255),
    preferred_view_period varchar(255),
    workdays varchar(255),
    workday_start integer,
    workday_end integer,
    preferred_endtype varchar(255),
    primary key (prefid)
) type=InnoDB;
create table properties (
    user_info integer not null,
    name varchar(255) not null,
    val varchar(255),
    primary key (user_info, name)
) type=InnoDB;
create table recurrences (
    recurrence_id varchar(255) not null,
    masterid integer not null,
    start_date_type char(1) not null,
    start_tzid varchar(255),
    start_dtval varchar(255) not null,
    start_date varchar(255) not null,
    end_date_type char(1),
    end_tzid varchar(255),
    end_dtval varchar(255),
    end_date varchar(255),
    overrideid integer,
    primary key (recurrence_id, masterid)
) type=InnoDB;
create table sponsors (
    entityid integer not null auto_increment,
    seq integer not null,
    creatorid integer not null,
    ownerid integer not null,
    access text,
    publick char(1) not null,
    name varchar(255) not null,
    phone varchar(255),
    email varchar(255),
    link varchar(255),
    primary key (entityid),
    unique (ownerid, name)
) type=InnoDB;
create table subscriptions (
    subscriptionid integer not null auto_increment,
    seq integer not null,
    name text not null,
    ownerid integer not null,
    uri text not null,
    affects_free_busy char(1) not null,
    display char(1) not null,
    internal_Subscription char(1) not null,
    calendar_deleted char(1) not null,
    unremoveable char(1) not null,
    primary key (subscriptionid)
) type=InnoDB;
create table synchdata (
    userid integer not null,
    eventid integer not null,
    eventData text,
    primary key (userid, eventid)
) type=InnoDB;
create table synchinfo (
    userid integer not null,
    deviceid varchar(255) not null,
    calendarid integer,
    lastsynch varchar(255),
    primary key (userid, deviceid)
) type=InnoDB;
create table synchstate (
    userid integer not null,
    deviceid varchar(255) not null,
    eventid integer not null,
    guid varchar(255),
    state integer,
    primary key (userid, deviceid, eventid)
) type=InnoDB;
create table timezones (
    id integer not null auto_increment,
    tzid varchar(255) not null,
    ownerid integer not null,
    publick char(1) not null,
    vtimezone text,
    jtzid varchar(255),
    primary key (id),
    unique (tzid, ownerid)
) type=InnoDB;
create table todos (
    todoid integer not null auto_increment,
    start_date_type char(1) not null,
    start_tzid varchar(255),
    start_dtval varchar(255) not null,
    start_date varchar(255) not null,
    primary key (todoid)
) type=InnoDB;
create table user_subscriptions (
    prefid integer not null,
    elt integer not null,
    primary key (prefid, elt)
) type=InnoDB;
create table user_views (
    prefid integer not null,
    elt integer not null,
    primary key (prefid, elt)
) type=InnoDB;
create table userinfo (
    userid integer not null,
    lastname varchar(255),
    firstname varchar(255),
    phone varchar(255),
    email varchar(255),
    department varchar(255),
    primary key (userid)
) type=InnoDB;
create table users (
    userid integer not null auto_increment,
    seq integer not null,
    username varchar(20) not null,
    instance_owner char(1) not null,
    created datetime,
    last_logon datetime,
    last_access datetime,
    last_modify datetime,
    category_access text,
    sponsor_access text,
    location_access text,
    quota bigint,
    primary key (userid),
    unique (username)
) type=InnoDB;
create table view_subscriptions (
    viewid integer not null,
    elt integer not null,
    primary key (viewid, elt)
) type=InnoDB;
create table views (
    viewid integer not null auto_increment,
    seq integer not null,
    name text not null,
    ownerid integer not null,
    primary key (viewid)
) type=InnoDB;
alter table adminGroupMembers
    add index FK3D8EC689891E4122 (groupid),
    add constraint FK3D8EC689891E4122
    foreign key (groupid)
    references adminGroups (userid);
alter table adminGroups
    add index FKCE66D203FCC6CD69 (groupOwner),
    add constraint FKCE66D203FCC6CD69
    foreign key (groupOwner)
    references users (userid);
alter table adminGroups
    add index FKCE66D2037094B8E3 (ownerid),
    add constraint FKCE66D2037094B8E3
    foreign key (ownerid)
    references users (userid);
alter table alarm_attendees
    add index FK19F64E8B4E9CEE71 (elt),
    add constraint FK19F64E8B4E9CEE71
    foreign key (elt)
    references attendees (attendeeid);
alter table alarm_attendees
    add index FK19F64E8BAEDD20DC (attendeeid),
    add constraint FK19F64E8BAEDD20DC
    foreign key (attendeeid)
    references alarms (alarmid);
create index valarms_user on alarms (ownerid);
alter table alarms
    add index FKABA5D0427094B8E3 (ownerid),
    add constraint FKABA5D0427094B8E3
    foreign key (ownerid)
    references users (userid);
alter table alarms
    add index FKABA5D0427BAF9231 (todoid),
    add constraint FKABA5D0427BAF9231
    foreign key (todoid)
    references todos (todoid);
alter table alarms
    add index FKABA5D042ECC95E3C (eventid),
    add constraint FKABA5D042ECC95E3C
    foreign key (eventid)
    references events (eventid);
alter table auth
    add index FK2DDDA87D9DCBFB (userid),
    add constraint FK2DDDA87D9DCBFB
    foreign key (userid)
    references users (userid);
alter table authprefCalendars
    add index FK296C356A3D2DC521 (calendarid),
    add constraint FK296C356A3D2DC521
    foreign key (calendarid)
    references calendars (id);
alter table authprefCalendars
    add index FK296C356A6D224B2B (userid),
    add constraint FK296C356A6D224B2B
    foreign key (userid)
    references authprefs (userid);
alter table authprefCategories
    add index FK37D48C477E8BD8A1 (categoryid),
    add constraint FK37D48C477E8BD8A1
    foreign key (categoryid)
    references categories (categoryid);
alter table authprefCategories
    add index FK37D48C476D224B2B (userid),
    add constraint FK37D48C476D224B2B
    foreign key (userid)
    references authprefs (userid);
alter table authprefLocations
    add index FK2B901FD36D224B2B (userid),
    add constraint FK2B901FD36D224B2B
    foreign key (userid)
    references authprefs (userid);
alter table authprefLocations
    add index FK2B901FD3FB77CC4F (locationid),
    add constraint FK2B901FD3FB77CC4F
    foreign key (locationid)
    references locations (entityid);
alter table authprefSponsors
    add index FK7D7DE5845A307285 (sponsorid),
    add constraint FK7D7DE5845A307285
    foreign key (sponsorid)
    references sponsors (entityid);
alter table authprefSponsors
    add index FK7D7DE5846D224B2B (userid),
    add constraint FK7D7DE5846D224B2B
    foreign key (userid)
    references authprefs (userid);
create index cal_creator on calendars (creatorid);
create index cal_owner on calendars (ownerid);
create index calpath on calendars (path(100));
alter table calendars
    add index FKB6806CF57094B8E3 (ownerid),
    add constraint FKB6806CF57094B8E3
    foreign key (ownerid)
    references users (userid);
alter table calendars
    add index FKB6806CF5E84B9CF2 (parent),
    add constraint FKB6806CF5E84B9CF2
    foreign key (parent)
    references calendars (id);
alter table calendars
    add index FKB6806CF5D321CC1C (creatorid),
    add constraint FKB6806CF5D321CC1C
    foreign key (creatorid)
    references users (userid);
create index cat_word on categories (word);
create index idx_cat_owner on categories (ownerid);
create index idx_cat_creator on categories (creatorid);
alter table categories
    add index FK4D47461C7094B8E3 (ownerid),
    add constraint FK4D47461C7094B8E3
    foreign key (ownerid)
    references users (userid);
alter table categories
    add index FK4D47461CD321CC1C (creatorid),
    add constraint FK4D47461CD321CC1C
    foreign key (creatorid)
    references users (userid);
create index idx_eventann_calendar on eventAnnotations (calendarid);
create index idx_eventann_location on eventAnnotations (locationid);
create index idx_eventann_sponsor on eventAnnotations (sponsorid);
create index sidx_eventann_owner on eventAnnotations (ownerid);
create index idx_eventann_creator on eventAnnotations (creatorid);
create index idx_eventann_deleted on eventAnnotations (deleted);
create index idx_eventann_expanded on eventAnnotations (expanded);
create index idx_eventann_end on eventAnnotations (end_date);
create index idx_eventann_start on eventAnnotations (start_date);
create index idx_eventann_latest_date on eventAnnotations (latest_date);
create index idx_eventann_recurring on eventAnnotations (recurring);
alter table eventAnnotations
    add index FKA912EC2A5A307285 (sponsorid),
    add constraint FKA912EC2A5A307285
    foreign key (sponsorid)
    references sponsors (entityid);
alter table eventAnnotations
    add index FKA912EC2A7094B8E3 (ownerid),
    add constraint FKA912EC2A7094B8E3
    foreign key (ownerid)
    references users (userid);
alter table eventAnnotations
    add index FKA912EC2A3D2DC521 (calendarid),
    add constraint FKA912EC2A3D2DC521
    foreign key (calendarid)
    references calendars (id);
alter table eventAnnotations
    add index FKA912EC2AD321CC1C (creatorid),
    add constraint FKA912EC2AD321CC1C
    foreign key (creatorid)
    references users (userid);
alter table eventAnnotations
    add index FKA912EC2A4FC14404 (masterid),
    add constraint FKA912EC2A4FC14404
    foreign key (masterid)
    references events (eventid);
alter table eventAnnotations
    add index FKA912EC2A247D7B73 (targetid),
    add constraint FKA912EC2A247D7B73
    foreign key (targetid)
    references events (eventid);
alter table eventAnnotations
    add index FKA912EC2AFB77CC4F (locationid),
    add constraint FKA912EC2AFB77CC4F
    foreign key (locationid)
    references locations (entityid);
alter table eventAnnotations
    add index FKA912EC2AEB04EBEF (organizerid),
    add constraint FKA912EC2AEB04EBEF
    foreign key (organizerid)
    references organizers (alarmid);
alter table event_annotation_attendees
    add index FK7D0DEE6E4E9CEE71 (elt),
    add constraint FK7D0DEE6E4E9CEE71
    foreign key (elt)
    references attendees (attendeeid);
alter table event_annotation_attendees
    add index FK7D0DEE6E13EADC74 (attendeeid),
    add constraint FK7D0DEE6E13EADC74
    foreign key (attendeeid)
    references eventAnnotations (eventid);
alter table event_annotation_categories
    add index FKDD91477E8BD8A1 (categoryid),
    add constraint FKDD91477E8BD8A1
    foreign key (categoryid)
    references categories (categoryid);
alter table event_annotation_categories
    add index FKDD914750C58A54 (eventid),
    add constraint FKDD914750C58A54
    foreign key (eventid)
    references eventAnnotations (eventid);
alter table event_annotationexdates
    add index FK38128D3E50C58A54 (eventid),
    add constraint FK38128D3E50C58A54
    foreign key (eventid)
    references eventAnnotations (eventid);
alter table event_annotationrdates
    add index FK2767404750C58A54 (eventid),
    add constraint FK2767404750C58A54
    foreign key (eventid)
    references eventAnnotations (eventid);
alter table event_annotationrrules
    add index FK283582B950C58A54 (eventid),
    add constraint FK283582B950C58A54
    foreign key (eventid)
    references eventAnnotations (eventid);
alter table event_attendees
    add index FK1943F944E9CEE71 (elt),
    add constraint FK1943F944E9CEE71
    foreign key (elt)
    references attendees (attendeeid);
alter table event_attendees
    add index FK1943F94ECC95E3C (eventid),
    add constraint FK1943F94ECC95E3C
    foreign key (eventid)
    references events (eventid);
alter table event_categories
    add index FKD2164E17E8BD8A1 (categoryid),
    add constraint FKD2164E17E8BD8A1
    foreign key (categoryid)
    references categories (categoryid);
alter table event_categories
    add index FKD2164E1ECC95E3C (eventid),
    add constraint FKD2164E1ECC95E3C
    foreign key (eventid)
    references events (eventid);
alter table eventexdates
    add index FK84343DD8ECC95E3C (eventid),
    add constraint FK84343DD8ECC95E3C
    foreign key (eventid)
    references events (eventid);
alter table eventrdates
    add index FK3A60146DECC95E3C (eventid),
    add constraint FK3A60146DECC95E3C
    foreign key (eventid)
    references events (eventid);
alter table eventrrules
    add index FK3B2E56DFECC95E3C (eventid),
    add constraint FK3B2E56DFECC95E3C
    foreign key (eventid)
    references events (eventid);
create index idx_event_expanded on events (expanded);
create index sidx_event_owner on events (ownerid);
create index eli on events (locationid);
create index esi on events (sponsorid);
create index idx_event_calendar on events (calendarid);
create index idx_event_end on events (end_date);
create index idx_event_creator on events (creatorid);
create index idx_event_start on events (start_date);
create index idx_event_deleted on events (deleted);
create index idx_event_recurring on events (recurring);
create index idx_event_latest_date on events (latest_date);
alter table events
    add index FKB307E1195A307285 (sponsorid),
    add constraint FKB307E1195A307285
    foreign key (sponsorid)
    references sponsors (entityid);
alter table events
    add index FKB307E1197094B8E3 (ownerid),
    add constraint FKB307E1197094B8E3
    foreign key (ownerid)
    references users (userid);
alter table events
    add index FKB307E1193D2DC521 (calendarid),
    add constraint FKB307E1193D2DC521
    foreign key (calendarid)
    references calendars (id);
alter table events
    add index FKB307E119D321CC1C (creatorid),
    add constraint FKB307E119D321CC1C
    foreign key (creatorid)
    references users (userid);
alter table events
    add index FKB307E119FB77CC4F (locationid),
    add constraint FKB307E119FB77CC4F
    foreign key (locationid)
    references locations (entityid);
alter table events
    add index FKB307E119EB04EBEF (organizerid),
    add constraint FKB307E119EB04EBEF
    foreign key (organizerid)
    references organizers (alarmid);
alter table filter_categories
    add index FKFE8575438A948DF (filterid),
    add constraint FKFE8575438A948DF
    foreign key (filterid)
    references filters (filterid);
alter table filter_categories
    add index FKFE8575437E8BD8A1 (categoryid),
    add constraint FKFE8575437E8BD8A1
    foreign key (categoryid)
    references categories (categoryid);
alter table filter_creators
    add index FK85FF52AEF90D3261 (filterid),
    add constraint FK85FF52AEF90D3261
    foreign key (filterid)
    references filters (filterid);
alter table filter_creators
    add index FK85FF52AED321CC1C (creatorid),
    add constraint FK85FF52AED321CC1C
    foreign key (creatorid)
    references users (userid);
alter table filter_locations
    add index FKCEE027579ED90656 (filterid),
    add constraint FKCEE027579ED90656
    foreign key (filterid)
    references filters (filterid);
alter table filter_locations
    add index FKCEE02757FB77CC4F (locationid),
    add constraint FKCEE02757FB77CC4F
    foreign key (locationid)
    references locations (entityid);
alter table filter_sponsors
    add index FKAC0CDD805A307285 (sponsorid),
    add constraint FKAC0CDD805A307285
    foreign key (sponsorid)
    references sponsors (entityid);
alter table filter_sponsors
    add index FKAC0CDD80763F9ACF (filterid),
    add constraint FKAC0CDD80763F9ACF
    foreign key (filterid)
    references filters (filterid);
create index calowner on filters (ownerid);
create index calpub on filters (publick);
alter table filters
    add index FKCD10A3FB7094B8E3 (ownerid),
    add constraint FKCD10A3FB7094B8E3
    foreign key (ownerid)
    references users (userid);
alter table filters
    add index FKCD10A3FBA562A89B (parent),
    add constraint FKCD10A3FBA562A89B
    foreign key (parent)
    references filters (filterid);
alter table filters
    add index FKCD10A3FB36B842E3 (parent),
    add constraint FKCD10A3FB36B842E3
    foreign key (parent)
    references filters (filterid);
alter table filters
    add index FKCD10A3FBBA2D9A58 (parent),
    add constraint FKCD10A3FBBA2D9A58
    foreign key (parent)
    references filters (filterid);
create index location_creator on locations (creatorid);
create index location_owner on locations (ownerid);
alter table locations
    add index FKB8A4575E7094B8E3 (ownerid),
    add constraint FKB8A4575E7094B8E3
    foreign key (ownerid)
    references users (userid);
alter table locations
    add index FKB8A4575ED321CC1C (creatorid),
    add constraint FKB8A4575ED321CC1C
    foreign key (creatorid)
    references users (userid);
create index prefowner on preferences (ownerid);
alter table preferences
    add index FK769ADEF87094B8E3 (ownerid),
    add constraint FK769ADEF87094B8E3
    foreign key (ownerid)
    references users (userid);
alter table preferences
    add index FK769ADEF85C7181DF (default_calendarid),
    add constraint FK769ADEF85C7181DF
    foreign key (default_calendarid)
    references calendars (id);
alter table properties
    add index FKC8CD8D33329258C5 (user_info),
    add constraint FKC8CD8D33329258C5
    foreign key (user_info)
    references userinfo (userid);
create index idx_recur_end on recurrences (end_date);
create index idx_recur_start on recurrences (start_date);
alter table recurrences
    add index FKD6034B433910AF06 (overrideid),
    add constraint FKD6034B433910AF06
    foreign key (overrideid)
    references eventAnnotations (eventid);
alter table recurrences
    add index FKD6034B434FC14404 (masterid),
    add constraint FKD6034B434FC14404
    foreign key (masterid)
    references events (eventid);
create index idx_sp_creator on sponsors (creatorid);
create index idx_sp_owner on sponsors (ownerid);
alter table sponsors
    add index FK928F10997094B8E3 (ownerid),
    add constraint FK928F10997094B8E3
    foreign key (ownerid)
    references users (userid);
alter table sponsors
    add index FK928F1099D321CC1C (creatorid),
    add constraint FK928F1099D321CC1C
    foreign key (creatorid)
    references users (userid);
create index subscriptionowner on subscriptions (ownerid);
alter table subscriptions
    add index FK7674CAF67094B8E3 (ownerid),
    add constraint FK7674CAF67094B8E3
    foreign key (ownerid)
    references users (userid);
alter table synchdata
    add index FK1DF1CA577D9DCBFB (userid),
    add constraint FK1DF1CA577D9DCBFB
    foreign key (userid)
    references users (userid);
alter table synchinfo
    add index FK1DF43F5B7D9DCBFB (userid),
    add constraint FK1DF43F5B7D9DCBFB
    foreign key (userid)
    references users (userid);
alter table synchstate
    add index FKA1233F847D9DCBFB (userid),
    add constraint FKA1233F847D9DCBFB
    foreign key (userid)
    references users (userid);
alter table synchstate
    add index FKA1233F84ECC95E3C (eventid),
    add constraint FKA1233F84ECC95E3C
    foreign key (eventid)
    references events (eventid);
create index timezoneowner on timezones (ownerid);
alter table timezones
    add index FK3A9B79A7094B8E3 (ownerid),
    add constraint FK3A9B79A7094B8E3
    foreign key (ownerid)
    references users (userid);
alter table user_subscriptions
    add index FK5CFF898228D230A2 (elt),
    add constraint FK5CFF898228D230A2
    foreign key (elt)
    references subscriptions (subscriptionid);
alter table user_subscriptions
    add index FK5CFF8982EA44079E (prefid),
    add constraint FK5CFF8982EA44079E
    foreign key (prefid)
    references preferences (prefid);
alter table user_views
    add index FK737824FA7CFB6A2A (elt),
    add constraint FK737824FA7CFB6A2A
    foreign key (elt)
    references views (viewid);
alter table user_views
    add index FK737824FAEA44079E (prefid),
    add constraint FK737824FAEA44079E
    foreign key (prefid)
    references preferences (prefid);
alter table userinfo
    add index FKF02772F97D9DCBFB (userid),
    add constraint FKF02772F97D9DCBFB
    foreign key (userid)
    references users (userid);
create index idx_user_instance_owner on users (instance_owner);
alter table view_subscriptions
    add index FKBC37D2DC4C4D13FD (viewid),
    add constraint FKBC37D2DC4C4D13FD
    foreign key (viewid)
    references views (viewid);
alter table view_subscriptions
    add index FKBC37D2DC28D230A2 (elt),
    add constraint FKBC37D2DC28D230A2
    foreign key (elt)
    references subscriptions (subscriptionid);
create index viewowner on views (ownerid);
alter table views
    add index FK6B01A6E7094B8E3 (ownerid),
    add constraint FK6B01A6E7094B8E3
    foreign key (ownerid)
    references users (userid);
