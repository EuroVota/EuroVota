CREATE TABLE IF NOT EXISTS users
(
    id           uuid         not null,
    phone        varchar(255) not null,
    created_at   timestamptz  not null,
    validated_at timestamptz,
    enabled      boolean      not null,
    deleted      boolean      not null,
    primary key (id)
);