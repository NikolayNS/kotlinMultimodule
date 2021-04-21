create sequence categories_id_seq;

create sequence zone_id_seq;

create sequence opening_hours_rules_id_seq;

create table if not exists cities
(
    id             uuid         not null
        constraint cities_pkey
            primary key,
    created_at     timestamp    not null,
    is_delete      boolean      not null,
    deleted_at     timestamp,
    updated_at     timestamp    not null,
    latitude       double precision,
    longitude      double precision,
    sort_position  integer,
    timezone       varchar(255) not null,
    title          varchar(255) not null,
    parent_city_id uuid
        constraint fk_cities__city
            references cities
);

INSERT INTO cities
VALUES ('e2c45ef0-4720-45e9-9920-9310b6a9f420', now(), false, null, now(), 0.0, 0.0, 0, '+03:00', 'Любой город', null);

create table if not exists miniapps
(
    id         varchar(255) not null
        constraint miniapps_pkey
            primary key,
    created_at timestamp    not null,
    is_delete  boolean      not null,
    deleted_at timestamp,
    updated_at timestamp    not null
);

create table if not exists categories
(
    id            bigint       not null
        constraint categories_pkey
            primary key,
    created_at    timestamp    not null,
    is_delete     boolean      not null,
    deleted_at    timestamp,
    updated_at    timestamp    not null,
    title         varchar(255) not null,
    preview_image varchar,
    miniapp_id    varchar(255)
        constraint fk_categories__miniapp
            references miniapps,
    parent_id     bigint
        constraint fk_categories__category
            references categories,
    constraint uk_categories__miniapp_title_parent
        unique (miniapp_id, title, parent_id)
);

create table if not exists geo_entities
(
    id                      uuid         not null
        constraint geo_entities_pkey
            primary key,
    created_at              timestamp    not null,
    is_delete               boolean      not null,
    deleted_at              timestamp,
    updated_at              timestamp    not null,
    building                varchar(50),
    date                    timestamp,
    description             varchar(255),
    house                   varchar(50),
    image_url               varchar(255),
    latitude                double precision,
    longitude               double precision,
    miniapp_entity_class    varchar(255) not null,
    miniapp_entity_id       varchar(255) not null,
    miniapp_group_key       varchar(255),
    needs_reindex           boolean      not null,
    next_open_recalculation timestamp,
    open                    boolean      not null,
    preview_image_url       varchar(255),
    properties              jsonb,
    street                  varchar(200),
    tags                    text[],
    title                   varchar(255) not null,
    works_till              smallint,
    sort_position           integer,
    city_id                 uuid         not null
        constraint fk_geo_entities__city
            references cities,
    miniapp_id              varchar(255) not null
        constraint fk_geo_entities__miniapp
            references miniapps,
    constraint uk_geo_entities__miniapp_miniapp_entity
        unique (miniapp_id, miniapp_entity_id)
);

CREATE TABLE IF NOT EXISTS geo_entity_category
(
    geo_entity_id uuid   not null
        constraint fk_geo_entity_category_geo_entity
            references geo_entities,
    category_id   bigint not null
        constraint fk_geo_entity_category_category
            references categories,
    primary key (geo_entity_id, category_id)
);

create table if not exists zones
(
    id                   bigint       not null
        constraint zones_pkey
            primary key,
    geometry_coordinates jsonb        not null,
    geometry_type        varchar(255) not null,
    miniapp_zone_id      varchar(255),
    properties           jsonb,
    sort_position        integer,
    geo_entity_id        uuid         not null
        constraint fk_zone__geo_entities
            references geo_entities,
    constraint uk_zones__miniapp_zone_geo_entity
        unique (geo_entity_id, miniapp_zone_id)
);

create table if not exists opening_hours_rules
(
    id            bigint   not null
        constraint opening_hours_rules_pkey
            primary key,
    date          date,
    day_of_week   int2,

    open_from     smallint not null,
    open_to       smallint not null,
    geo_entity_id uuid     not null
        constraint fk_opening_hours_rules__geo_entity
            references geo_entities,
    constraint uk_opening_hours_rules__date_day_of_week_geo_entity
        unique (day_of_week, date, geo_entity_id),
    constraint uk_opening_hours__day_of_week_geo_entity
        unique (day_of_week, geo_entity_id),
    constraint uk_opening_hours__date_geo_entity
        unique (date, geo_entity_id)
);

CREATE TABLE IF NOT EXISTS dashboard
(
    id           uuid         not null
        constraint dashboard_pkey
            primary key,
    title        varchar(255) not null,
    type         varchar(255) not null,
    miniapp_id   varchar(255)
        constraint fk_dashboard__miniapp
            references miniapps,
    profile_type varchar(255) not null,
    ancor_menu   boolean      not null,
    created_at   timestamp    not null,
    is_delete    boolean      not null,
    deleted_at   timestamp,
    updated_at   timestamp    not null
);

CREATE TABLE IF NOT EXISTS section
(
    id            uuid         not null
        constraint section_pkey
            primary key,
    title         varchar(255) not null,
    section_class varchar(255) not null,
    ancor         varchar,
    miniapp_id    varchar(255)
        constraint fk_section__miniapp
            references miniapps,
    created_at    timestamp    not null,
    is_delete     boolean      not null,
    deleted_at    timestamp,
    updated_at    timestamp    not null
);

CREATE TABLE IF NOT EXISTS dashboard_section
(
    id           uuid not null
        constraint dashboard_section_pkey
            primary key,
    dashboard_id uuid
        constraint fk_dashboard_section_dashboard
            references dashboard,
    section_id   uuid
        constraint fk_dashboard_section_section
            references section
);

CREATE TABLE IF NOT EXISTS content_params
(
    id                     uuid         not null
        constraint content_params_pkey
            primary key,
    type                   varchar(255) not null,
    method                 varchar(255) not null,
    latitude               double precision,
    longitude              double precision,
    zone_hit_only          boolean,
    miniapp_ids            text[],
    query                  varchar,
    limit_city_id          uuid,
    include_city_id        uuid,
    is_group               boolean,
    miniapp_group_keys     text[],
    is_open                boolean,
    sort_by                varchar,
    sort_order             varchar,
    radius                 integer,
    category_ids           text[],
    tags                   text[],
    date_from              timestamp,
    date_to                timestamp,
    miniapp_entity_ids     text[],
    filters                text[],
    miniapp_entity_classes text[],
    properties             text[]
);

CREATE TABLE IF NOT EXISTS content
(
    id            uuid         not null
        constraint content_pkey
            primary key,
    title         varchar,
    section_id    uuid
        constraint fk_content_section
            references section,
    content_class varchar(255) not null,
    content_type  varchar(255) not null,
    content_params_id    uuid
        constraint fk_content_content_params
            references content_params,
    created_at    timestamp    not null,
    is_delete     boolean      not null,
    deleted_at    timestamp,
    updated_at    timestamp    not null
);
