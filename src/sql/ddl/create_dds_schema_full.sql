DROP SCHEMA IF EXISTS dds;

CREATE SCHEMA dds AUTHORIZATION jovyan;

-- DROP SEQUENCE dds.dm_orders_id_seq;

CREATE SEQUENCE dds.dm_orders_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE dds.dm_products_id_seq;

CREATE SEQUENCE dds.dm_products_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE dds.dm_restaurants_id_seq;

CREATE SEQUENCE dds.dm_restaurants_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE dds.dm_timestamps_id_seq;

CREATE SEQUENCE dds.dm_timestamps_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE dds.dm_users_id_seq;

CREATE SEQUENCE dds.dm_users_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE dds.fct_product_sales_id_seq;

CREATE SEQUENCE dds.fct_product_sales_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE dds.srv_wf_settings_id_seq;

CREATE SEQUENCE dds.srv_wf_settings_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- dds.dm_restaurants definition

-- Drop table

-- DROP TABLE dds.dm_restaurants;

CREATE TABLE dds.dm_restaurants (
	id serial4 NOT NULL,
	restaurant_id varchar NOT NULL,
	restaurant_name varchar NOT NULL,
	active_from timestamp NOT NULL,
	active_to timestamp NOT NULL,
	CONSTRAINT dm_restaurants_pkey PRIMARY KEY (id)
);


-- dds.dm_timestamps definition

-- Drop table

-- DROP TABLE dds.dm_timestamps;

CREATE TABLE dds.dm_timestamps (
	id serial4 NOT NULL,
	ts timestamp NOT NULL,
	"year" int2 NOT NULL,
	"month" int2 NOT NULL,
	"day" int2 NOT NULL,
	"time" time NOT NULL,
	"date" date NOT NULL,
	CONSTRAINT dm_timestamps_day_check CHECK (((day >= 1) AND (day <= 31))),
	CONSTRAINT dm_timestamps_month_check CHECK (((month >= 1) AND (month <= 12))),
	CONSTRAINT dm_timestamps_pkey PRIMARY KEY (id),
	CONSTRAINT dm_timestamps_year_check CHECK (((year >= 2022) AND (year < 2500)))
);


-- dds.dm_users definition

-- Drop table

-- DROP TABLE dds.dm_users;

CREATE TABLE dds.dm_users (
	id serial4 NOT NULL,
	user_id varchar NOT NULL,
	user_name varchar NOT NULL,
	user_login varchar NOT NULL,
	CONSTRAINT dm_users_pkey PRIMARY KEY (id)
);


-- dds.srv_wf_settings definition

-- Drop table

-- DROP TABLE dds.srv_wf_settings;

CREATE TABLE dds.srv_wf_settings (
	id serial4 NOT NULL,
	workflow_key varchar NOT NULL,
	workflow_settings json NOT NULL,
	CONSTRAINT srv_wf_settings_pkey PRIMARY KEY (id),
	CONSTRAINT srv_wf_settings_workflow_key_key UNIQUE (workflow_key)
);


-- dds.dm_orders definition

-- Drop table

-- DROP TABLE dds.dm_orders;

CREATE TABLE dds.dm_orders (
	id serial4 NOT NULL,
	user_id int4 NOT NULL,
	restaurant_id int4 NOT NULL,
	timestamp_id int4 NOT NULL,
	order_key varchar NOT NULL,
	order_status varchar NOT NULL,
	CONSTRAINT dm_orders_pkey PRIMARY KEY (id),
	CONSTRAINT dm_orders_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES dds.dm_restaurants(id),
	CONSTRAINT dm_orders_timestamp_id_fkey FOREIGN KEY (timestamp_id) REFERENCES dds.dm_timestamps(id),
	CONSTRAINT dm_orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES dds.dm_users(id)
);


-- dds.dm_products definition

-- Drop table

-- DROP TABLE dds.dm_products;

CREATE TABLE dds.dm_products (
	id serial4 NOT NULL,
	product_id varchar NOT NULL,
	restaurant_id int4 NOT NULL,
	product_name varchar NOT NULL,
	product_price numeric(14, 2) NOT NULL DEFAULT 0,
	active_from timestamp NOT NULL,
	active_to timestamp NOT NULL,
	CONSTRAINT dm_products_pkey PRIMARY KEY (id),
	CONSTRAINT dm_products_price_check CHECK ((product_price >= (0)::numeric)),
	CONSTRAINT dm_products_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES dds.dm_restaurants(id)
);


-- dds.fct_product_sales definition

-- Drop table

-- DROP TABLE dds.fct_product_sales;

CREATE TABLE dds.fct_product_sales (
	id serial4 NOT NULL,
	product_id int4 NOT NULL,
	order_id int4 NOT NULL,
	count int4 NOT NULL DEFAULT 0,
	price numeric(14, 2) NOT NULL DEFAULT 0,
	total_sum numeric(14, 2) NOT NULL DEFAULT 0,
	bonus_payment numeric(14, 2) NOT NULL DEFAULT 0,
	bonus_grant numeric(14, 2) NOT NULL DEFAULT 0,
	CONSTRAINT fct_product_sales_bonus_grant_check CHECK ((bonus_grant >= (0)::numeric)),
	CONSTRAINT fct_product_sales_bonus_payment_check CHECK ((bonus_payment >= (0)::numeric)),
	CONSTRAINT fct_product_sales_count_check CHECK ((count >= 0)),
	CONSTRAINT fct_product_sales_pkey PRIMARY KEY (id),
	CONSTRAINT fct_product_sales_price_check CHECK ((price >= (0)::numeric)),
	CONSTRAINT fct_product_sales_total_sum_check CHECK ((total_sum >= (0)::numeric)),
	CONSTRAINT fct_product_sales_order_id_fkey FOREIGN KEY (order_id) REFERENCES dds.dm_orders(id),
	CONSTRAINT fct_product_sales_product_id_fkey FOREIGN KEY (product_id) REFERENCES dds.dm_products(id)
);



