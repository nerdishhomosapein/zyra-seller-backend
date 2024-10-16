SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.job_attempts DROP CONSTRAINT IF EXISTS fk_rails_93c60bcdb6;
ALTER TABLE IF EXISTS ONLY public.payment_order_refund_xref DROP CONSTRAINT IF EXISTS fk_rails_70fa349258;
ALTER TABLE IF EXISTS ONLY public.payment_attempts DROP CONSTRAINT IF EXISTS fk_rails_270bb3ff4f;
DROP INDEX IF EXISTS public.unique_index_on_oms_order_id_orders;
DROP INDEX IF EXISTS public.payment_order_xref_time_index;
DROP INDEX IF EXISTS public.payment_order_xref_ph_order_id_index;
DROP INDEX IF EXISTS public.payment_order_xref_oms_order_id_index;
DROP INDEX IF EXISTS public.payment_order_xref_merchant_partner_order_id_index;
DROP INDEX IF EXISTS public.payment_order_xref_index;
DROP INDEX IF EXISTS public.index_users_on_global_user_id;
DROP INDEX IF EXISTS public.index_refund_status_created_at;
DROP INDEX IF EXISTS public.index_payments_on_reference_id;
DROP INDEX IF EXISTS public.index_payments_on_payment_id;
DROP INDEX IF EXISTS public.index_payments_on_order_id;
DROP INDEX IF EXISTS public.index_payments_on_global_user_id;
DROP INDEX IF EXISTS public.index_payment_order_xref_on_ph_session_id;
DROP INDEX IF EXISTS public.index_payment_order_xref_on_cart_session_token;
DROP INDEX IF EXISTS public.index_payment_order_refund_xref_on_payment_order_xref_id;
DROP INDEX IF EXISTS public.index_payment_order_refund_xref_on_merchant_partner_refund_id;
DROP INDEX IF EXISTS public.index_payment_attempts_on_order_xref_id;
DROP INDEX IF EXISTS public.index_orders_on_oms_order_id;
DROP INDEX IF EXISTS public.index_orders_on_merchant_partner_source_identifier;
DROP INDEX IF EXISTS public.index_orders_on_global_user_id;
DROP INDEX IF EXISTS public.index_orders_on_created_at;
DROP INDEX IF EXISTS public.index_orders_on_cart_session_token;
DROP INDEX IF EXISTS public.index_order_xref_on_oms_order_id;
DROP INDEX IF EXISTS public.index_order_xref_on_merchant_partner_order_id;
DROP INDEX IF EXISTS public.index_order_xref_on_cart_session_token;
DROP INDEX IF EXISTS public.index_order_xref_on_cart_hash;
DROP INDEX IF EXISTS public.index_job_attempts_on_job_id;
DROP INDEX IF EXISTS public.index_carts_on_cart_session_token;
DROP INDEX IF EXISTS public.index_campaigns_on_type;
DROP INDEX IF EXISTS public.index_campaigns_on_description;
DROP INDEX IF EXISTS public.index_campaign_users_on_user_id;
DROP INDEX IF EXISTS public.index_campaign_users_on_status;
DROP INDEX IF EXISTS public.index_campaign_users_on_campaign_id;
DROP INDEX IF EXISTS public.index_auth_tokens_on_user_id;
DROP INDEX IF EXISTS public.index_auth_tokens_on_session_token;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.payments DROP CONSTRAINT IF EXISTS payments_pkey;
ALTER TABLE IF EXISTS ONLY public.payment_order_xref DROP CONSTRAINT IF EXISTS payment_order_xref_pkey;
ALTER TABLE IF EXISTS ONLY public.payment_order_refund_xref DROP CONSTRAINT IF EXISTS payment_order_refund_xref_pkey;
ALTER TABLE IF EXISTS ONLY public.payment_attempts DROP CONSTRAINT IF EXISTS payment_attempts_pkey;
ALTER TABLE IF EXISTS ONLY public.orders DROP CONSTRAINT IF EXISTS orders_pkey;
ALTER TABLE IF EXISTS ONLY public.order_xref DROP CONSTRAINT IF EXISTS order_xref_pkey;
ALTER TABLE IF EXISTS ONLY public.jobs DROP CONSTRAINT IF EXISTS jobs_pkey;
ALTER TABLE IF EXISTS ONLY public.job_attempts DROP CONSTRAINT IF EXISTS job_attempts_pkey;
ALTER TABLE IF EXISTS ONLY public.carts DROP CONSTRAINT IF EXISTS carts_pkey;
ALTER TABLE IF EXISTS ONLY public.campaigns DROP CONSTRAINT IF EXISTS campaigns_pkey;
ALTER TABLE IF EXISTS ONLY public.campaign_users DROP CONSTRAINT IF EXISTS campaign_users_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_tokens DROP CONSTRAINT IF EXISTS auth_tokens_pkey;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.schema_migrations;
DROP TABLE IF EXISTS public.payments;
DROP TABLE IF EXISTS public.payment_order_xref;
DROP TABLE IF EXISTS public.payment_order_refund_xref;
DROP TABLE IF EXISTS public.payment_attempts;
DROP TABLE IF EXISTS public.orders;
DROP TABLE IF EXISTS public.order_xref;
DROP TABLE IF EXISTS public.jobs;
DROP TABLE IF EXISTS public.job_attempts;
DROP TABLE IF EXISTS public.carts;
DROP TABLE IF EXISTS public.campaigns;
DROP TABLE IF EXISTS public.campaign_users;
DROP TABLE IF EXISTS public.auth_tokens;
DROP EXTENSION IF EXISTS "uuid-ossp";
DROP EXTENSION IF EXISTS pgcrypto;
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_tokens (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    session_token character varying NOT NULL,
    user_id character varying NOT NULL,
    is_valid boolean DEFAULT true,
    expires_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    device_id character varying,
    source character varying DEFAULT 'checkout'::character varying,
    scope jsonb
);


--
-- Name: campaign_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.campaign_users (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    first_name character varying NOT NULL,
    campaign_id uuid NOT NULL,
    status character varying NOT NULL,
    activity character varying[] DEFAULT '{}'::character varying[],
    prizes jsonb,
    metadata jsonb,
    is_valid boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.campaigns (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    type character varying NOT NULL,
    title character varying NOT NULL,
    description character varying NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    result_date timestamp without time zone NOT NULL,
    prizes jsonb,
    metadata jsonb,
    is_valid boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: carts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.carts (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    cart_session_token character varying,
    merchant_checkout_token character varying,
    merchant_id uuid,
    domain character varying,
    user_id uuid,
    checkout_session jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: job_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_attempts (
    id character varying NOT NULL,
    job_id character varying NOT NULL,
    status character varying,
    failed_reason_metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id character varying NOT NULL,
    oms_order_id character varying,
    triggered_by character varying,
    job_type character varying,
    status character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
--
-- Name: order_xref; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_xref (
    id character varying NOT NULL,
    cart_hash character varying NOT NULL,
    cart_session_token character varying NOT NULL,
    oms_order_id character varying NOT NULL,
    oms_order_status character varying NOT NULL,
    merchant_partner_order_id character varying,
    merchant_partner_order_status character varying,
    successful_payment_id character varying,
    metadata jsonb,
    payment_succeeded_at timestamp with time zone,
    oms_confirmed_at timestamp with time zone,
    merchant_partner_confirmed_at timestamp with time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status character varying NOT NULL
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    global_user_id character varying,
    oms_order_id character varying NOT NULL,
    cart_session_token character varying NOT NULL,
    merchant_id uuid NOT NULL,
    status character varying NOT NULL,
    merchant_partner_order_status character varying,
    merchant_partner_order_id character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    merchant_partner_source_identifier character varying,
    integration_type character varying,
    shop_domain character varying,
    merchant_partner_failure_reason character varying,
    merchant_reference_id character varying,
    metadata jsonb
);


--
-- Name: payment_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_attempts (
    id character varying NOT NULL,
    order_xref_id character varying NOT NULL,
    payment_id character varying NOT NULL,
    payment_status character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    payment_mode character varying NOT NULL,
    metadata jsonb,
    payment_method character varying
);


--
-- Name: payment_order_refund_xref; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_order_refund_xref (
    id character varying NOT NULL,
    payment_order_xref_id character varying NOT NULL,
    merchant_partner_refund_id character varying NOT NULL,
    merchant_partner_refund_status character varying NOT NULL,
    ph_refund_reference_id character varying,
    ph_refund_status character varying,
    oms_refund_id character varying,
    oms_refund_status character varying,
    metadata jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: payment_order_xref; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_order_xref (
    id character varying NOT NULL,
    cart_session_token character varying,
    merchant_partner_payment_session_id character varying NOT NULL,
    merchant_partner_payment_status character varying NOT NULL,
    merchant_partner_order_id character varying,
    merchant_id uuid,
    oms_order_id character varying,
    oms_order_status character varying,
    ph_session_id character varying,
    ph_payment_status character varying,
    redirection_url character varying,
    user_id character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    payment_mode character varying,
    ph_order_id character varying,
    cart_metadata jsonb,
    oms_order_failure_reason character varying,
    merchant_partner_order_failure_reason character varying
);


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    payment_id character varying NOT NULL,
    global_user_id character varying NOT NULL,
    order_id character varying NOT NULL,
    amount_in_paise integer,
    merchant_id uuid NOT NULL,
    status character varying NOT NULL,
    payment_mode character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    reference_id character varying,
    completed_at timestamp without time zone,
    cancelled_at timestamp without time zone,
    metadata jsonb,
    payment_mode_extra jsonb,
    business_unit character varying
);


-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);



--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    global_user_id character varying NOT NULL,
    is_valid boolean DEFAULT true,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    khata_user_id character varying
);


--
-- Name: auth_tokens auth_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_tokens
    ADD CONSTRAINT auth_tokens_pkey PRIMARY KEY (id);



--
-- Name: campaign_users campaign_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campaign_users
    ADD CONSTRAINT campaign_users_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: job_attempts job_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_attempts
    ADD CONSTRAINT job_attempts_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);



--
-- Name: order_xref order_xref_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_xref
    ADD CONSTRAINT order_xref_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payment_attempts payment_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_attempts
    ADD CONSTRAINT payment_attempts_pkey PRIMARY KEY (id);


--
-- Name: payment_order_refund_xref payment_order_refund_xref_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_order_refund_xref
    ADD CONSTRAINT payment_order_refund_xref_pkey PRIMARY KEY (id);


--
-- Name: payment_order_xref payment_order_xref_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_order_xref
    ADD CONSTRAINT payment_order_xref_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);








--
-- Name: index_auth_tokens_on_session_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auth_tokens_on_session_token ON public.auth_tokens USING btree (session_token);


--
-- Name: index_auth_tokens_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auth_tokens_on_user_id ON public.auth_tokens USING btree (user_id);



--
-- Name: index_campaign_users_on_campaign_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_campaign_users_on_campaign_id ON public.campaign_users USING btree (campaign_id);


--
-- Name: index_campaign_users_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_campaign_users_on_status ON public.campaign_users USING btree (status);


--
-- Name: index_campaign_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_campaign_users_on_user_id ON public.campaign_users USING btree (user_id);


--
-- Name: index_campaigns_on_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_campaigns_on_description ON public.campaigns USING btree (description);


--
-- Name: index_campaigns_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_campaigns_on_type ON public.campaigns USING btree (type);


--
-- Name: index_carts_on_cart_session_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_carts_on_cart_session_token ON public.carts USING btree (cart_session_token);



--
-- Name: index_job_attempts_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_attempts_on_job_id ON public.job_attempts USING btree (job_id);



--
-- Name: index_order_xref_on_cart_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_order_xref_on_cart_hash ON public.order_xref USING btree (cart_hash);


--
-- Name: index_order_xref_on_cart_session_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_xref_on_cart_session_token ON public.order_xref USING btree (cart_session_token);


--
-- Name: index_order_xref_on_merchant_partner_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_order_xref_on_merchant_partner_order_id ON public.order_xref USING btree (merchant_partner_order_id);


--
-- Name: index_order_xref_on_oms_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_order_xref_on_oms_order_id ON public.order_xref USING btree (oms_order_id);


--
-- Name: index_orders_on_cart_session_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_cart_session_token ON public.orders USING btree (cart_session_token);


--
-- Name: index_orders_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_created_at ON public.orders USING btree (created_at);


--
-- Name: index_orders_on_global_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_global_user_id ON public.orders USING btree (global_user_id);


--
-- Name: index_orders_on_merchant_partner_source_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_merchant_partner_source_identifier ON public.orders USING btree (merchant_partner_source_identifier);


--
-- Name: index_orders_on_oms_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_oms_order_id ON public.orders USING btree (oms_order_id);


--
-- Name: index_payment_attempts_on_order_xref_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_attempts_on_order_xref_id ON public.payment_attempts USING btree (order_xref_id);


--
-- Name: index_payment_order_refund_xref_on_merchant_partner_refund_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_order_refund_xref_on_merchant_partner_refund_id ON public.payment_order_refund_xref USING btree (merchant_partner_refund_id);


--
-- Name: index_payment_order_refund_xref_on_payment_order_xref_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_order_refund_xref_on_payment_order_xref_id ON public.payment_order_refund_xref USING btree (payment_order_xref_id);


--
-- Name: index_payment_order_xref_on_cart_session_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_order_xref_on_cart_session_token ON public.payment_order_xref USING btree (cart_session_token);


--
-- Name: index_payment_order_xref_on_ph_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_payment_order_xref_on_ph_session_id ON public.payment_order_xref USING btree (ph_session_id);


--
-- Name: index_payments_on_global_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_global_user_id ON public.payments USING btree (global_user_id);


--
-- Name: index_payments_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_order_id ON public.payments USING btree (order_id);


--
-- Name: index_payments_on_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_payment_id ON public.payments USING btree (payment_id);


--
-- Name: index_payments_on_reference_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_reference_id ON public.payments USING btree (reference_id);


--
-- Name: index_refund_status_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_refund_status_created_at ON public.payment_order_refund_xref USING btree (merchant_partner_refund_status, oms_refund_id, created_at);



--
-- Name: index_users_on_global_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_global_user_id ON public.users USING btree (global_user_id);


--
-- Name: payment_order_xref_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX payment_order_xref_index ON public.payment_order_xref USING btree (merchant_partner_payment_session_id, merchant_id);


--
-- Name: payment_order_xref_merchant_partner_order_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_order_xref_merchant_partner_order_id_index ON public.payment_order_xref USING btree (merchant_id, merchant_partner_order_id);


--
-- Name: payment_order_xref_oms_order_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_order_xref_oms_order_id_index ON public.payment_order_xref USING btree (oms_order_id);


--
-- Name: payment_order_xref_ph_order_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_order_xref_ph_order_id_index ON public.payment_order_xref USING btree (ph_order_id);


--
-- Name: payment_order_xref_time_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_order_xref_time_index ON public.payment_order_xref USING btree (created_at);

--
-- Name: unique_index_on_oms_order_id_orders; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_index_on_oms_order_id_orders ON public.orders USING btree (oms_order_id);

--
-- Name: payment_attempts fk_rails_270bb3ff4f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_attempts
    ADD CONSTRAINT fk_rails_270bb3ff4f FOREIGN KEY (order_xref_id) REFERENCES public.order_xref(id);


--
-- Name: payment_order_refund_xref fk_rails_70fa349258; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_order_refund_xref
    ADD CONSTRAINT fk_rails_70fa349258 FOREIGN KEY (payment_order_xref_id) REFERENCES public.payment_order_xref(id);


--
-- Name: job_attempts fk_rails_93c60bcdb6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_attempts
    ADD CONSTRAINT fk_rails_93c60bcdb6 FOREIGN KEY (job_id) REFERENCES public.jobs(id);

--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20220620171341'),
