CREATE TABLE IF NOT EXISTS users_code_validation
(
    id         uuid        not null,
    user_id    uuid        not null,
    created_at timestamptz not null,
    code       int4,
    primary key (id),
    foreign key (user_id) references users (id),
    unique (user_id)
);