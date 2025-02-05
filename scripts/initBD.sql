-------------------------------- Drop Tables --------------------------------
DROP TABLE IF EXISTS Plan_Subscription;
DROP TABLE IF EXISTS Plan_Device;
DROP TABLE IF EXISTS Subcription_Visit;
DROP TABLE IF EXISTS Tecnical_Visit;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Subscription;
DROP TABLE IF EXISTS Plan;
DROP TABLE IF EXISTS Discount;
DROP TABLE IF EXISTS Device;
DROP TABLE IF EXISTS Devices_Type;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS auth_group_permissions;
DROP TABLE IF EXISTS auth_user_user_permissions;
DROP TABLE IF EXISTS auth_user_groups;
DROP TABLE IF EXISTS auth_permission;
DROP TABLE IF EXISTS auth_group;
DROP TABLE IF EXISTS auth_user;

-------------------------------- Create Tables --------------------------------
CREATE TABLE auth_user (
    id SERIAL PRIMARY KEY,
    password VARCHAR(128) NOT NULL,
    last_login TIMESTAMP,
    is_superuser BOOLEAN NOT NULL,
    username VARCHAR(150) NOT NULL UNIQUE,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    email VARCHAR(254),
    is_staff BOOLEAN NOT NULL,
    is_active BOOLEAN NOT NULL,
    date_joined TIMESTAMP NOT NULL
);

CREATE TABLE auth_group (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE auth_permission (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    content_type_id INTEGER NOT NULL,
    codename VARCHAR(100) NOT NULL,
    UNIQUE (content_type_id, codename)
);

CREATE TABLE auth_user_groups (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES auth_user(id),
    group_id INTEGER NOT NULL REFERENCES auth_group(id),
    UNIQUE (user_id, group_id)
);

CREATE TABLE auth_user_user_permissions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES auth_user(id),
    permission_id INTEGER NOT NULL REFERENCES auth_permission(id),
    UNIQUE (user_id, permission_id)
);

CREATE TABLE auth_group_permissions (
    id SERIAL PRIMARY KEY,
    group_id INTEGER NOT NULL REFERENCES auth_group(id),
    permission_id INTEGER NOT NULL REFERENCES auth_permission(id),
    UNIQUE (group_id, permission_id)
);

CREATE TABLE Address (
    address_id SERIAL PRIMARY KEY,
    street TEXT,
    city TEXT,
    postal_code TEXT,
    country TEXT,
    user_id INTEGER REFERENCES auth_user(id)
);

CREATE TABLE Devices_Type (
    device_type_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE,
    description TEXT,
    image TEXT
);

CREATE TABLE Device (
    device_id SERIAL PRIMARY KEY,
    device_type_id INTEGER REFERENCES Devices_Type(device_type_id),
    installation_date TIMESTAMP,
    serial_number TEXT
);

CREATE TABLE Discount (
    discount_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE,
    percent INTEGER CHECK (percent >= 1 AND percent <= 100),
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE Plan (
    plan_id SERIAL PRIMARY KEY,
    name TEXT,
    description TEXT,
    image TEXT,
    price FLOAT CHECK (price >= 0.01),
    service_type VARCHAR(10) CHECK (service_type IN ('Telemovel', 'Internet', 'TV', 'Telefone'))
);

CREATE TABLE Subscription (
    subscription_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES auth_user(id),
    discount_id INTEGER REFERENCES Discount(discount_id),
    start_date TIMESTAMP,
    end_date TIMESTAMP
);

CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    subscription_id INTEGER REFERENCES Subscription(subscription_id),
    user_id INTEGER REFERENCES auth_user(id),
    amount FLOAT,
    date TIMESTAMP,
    entity TEXT,
    refence TEXT
);

CREATE TABLE Tecnical_Visit (
    tecnical_visit_id SERIAL PRIMARY KEY,
    tecnical_id INTEGER REFERENCES auth_user(id),
    device_id INTEGER REFERENCES Device(device_id),
    note TEXT,
    date TIMESTAMP
);

CREATE TABLE Subcription_Visit (
    subcription_visit_id SERIAL PRIMARY KEY,
    subscription_id INTEGER REFERENCES Subscription(subscription_id),
    tecnical_visit_id INTEGER REFERENCES Tecnical_Visit(tecnical_visit_id),
    UNIQUE (subscription_id, tecnical_visit_id)
);

CREATE TABLE Plan_Device (
    plan_device_id SERIAL PRIMARY KEY,
    plan_id INTEGER REFERENCES Plan(plan_id),
    device_id INTEGER REFERENCES Device(device_id)
);

CREATE TABLE Plan_Subscription (
    plan_subscription_id SERIAL PRIMARY KEY,
    plan_id INTEGER REFERENCES Plan(plan_id),
    subscription_id INTEGER REFERENCES Subscription(subscription_id)
);
