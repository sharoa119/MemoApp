--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Homebrew)
-- Dumped by pg_dump version 14.9 (Homebrew)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: memos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.memos (
    id integer NOT NULL,
    title character varying(100),
    content character varying(500)
);


ALTER TABLE public.memos OWNER TO postgres;

--
-- Name: memos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.memos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.memos_id_seq OWNER TO postgres;

--
-- Name: memos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.memos_id_seq OWNED BY public.memos.id;


--
-- Name: memos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memos ALTER COLUMN id SET DEFAULT nextval('public.memos_id_seq'::regclass);


--
-- Name: memos memos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memos
    ADD CONSTRAINT memos_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

