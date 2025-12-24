--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache OWNER TO postgres;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO postgres;

--
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    id bigint NOT NULL,
    adresse character varying(255),
    cin character varying(255),
    email character varying(255),
    nom character varying(255),
    prenom character varying(255),
    telephone character varying(255)
);


ALTER TABLE public.client OWNER TO postgres;

--
-- Name: client_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.client_id_seq OWNER TO postgres;

--
-- Name: client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.client_id_seq OWNED BY public.client.id;


--
-- Name: defaut; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.defaut (
    id bigint NOT NULL,
    visite_id bigint,
    action_requise character varying(255),
    code character varying(255),
    description character varying(255),
    gravite character varying(255)
);


ALTER TABLE public.defaut OWNER TO postgres;

--
-- Name: defaut_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.defaut_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.defaut_id_seq OWNER TO postgres;

--
-- Name: defaut_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.defaut_id_seq OWNED BY public.defaut.id;


--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.failed_jobs_id_seq OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: fiche_pannes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fiche_pannes (
    fiche_id bigint NOT NULL,
    panne character varying(255)
);


ALTER TABLE public.fiche_pannes OWNER TO postgres;

--
-- Name: fiche_pieces_changees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fiche_pieces_changees (
    fiche_id bigint NOT NULL,
    piece character varying(255)
);


ALTER TABLE public.fiche_pieces_changees OWNER TO postgres;

--
-- Name: fiche_technique; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fiche_technique (
    id bigint NOT NULL,
    annee integer,
    cout_main_oeuvre double precision,
    cout_pieces double precision,
    date_diagnostic date,
    date_reparation date,
    description_diagnostic text,
    duree_reparation_heures integer,
    etat_carrosserie character varying(255),
    etat_electrique character varying(255),
    etat_freins character varying(255),
    etat_general character varying(255),
    etat_moteur character varying(255),
    etat_suspension character varying(255),
    gravite character varying(255),
    immatriculation character varying(255),
    kilometrage integer,
    marque character varying(255),
    modele character varying(255),
    observation_mecanicien text,
    reparable boolean,
    statut character varying(255),
    vehicule_id bigint,
    CONSTRAINT fiche_technique_etat_carrosserie_check CHECK (((etat_carrosserie)::text = ANY ((ARRAY['BON'::character varying, 'MOYEN'::character varying, 'MAUVAIS'::character varying])::text[]))),
    CONSTRAINT fiche_technique_etat_electrique_check CHECK (((etat_electrique)::text = ANY ((ARRAY['BON'::character varying, 'MOYEN'::character varying, 'MAUVAIS'::character varying])::text[]))),
    CONSTRAINT fiche_technique_etat_freins_check CHECK (((etat_freins)::text = ANY ((ARRAY['BON'::character varying, 'MOYEN'::character varying, 'MAUVAIS'::character varying])::text[]))),
    CONSTRAINT fiche_technique_etat_general_check CHECK (((etat_general)::text = ANY ((ARRAY['BON'::character varying, 'MOYEN'::character varying, 'MAUVAIS'::character varying])::text[]))),
    CONSTRAINT fiche_technique_etat_moteur_check CHECK (((etat_moteur)::text = ANY ((ARRAY['BON'::character varying, 'MOYEN'::character varying, 'MAUVAIS'::character varying])::text[]))),
    CONSTRAINT fiche_technique_etat_suspension_check CHECK (((etat_suspension)::text = ANY ((ARRAY['BON'::character varying, 'MOYEN'::character varying, 'MAUVAIS'::character varying])::text[]))),
    CONSTRAINT fiche_technique_gravite_check CHECK (((gravite)::text = ANY ((ARRAY['MINEURE'::character varying, 'MAJEURE'::character varying, 'CRITIQUE'::character varying])::text[]))),
    CONSTRAINT fiche_technique_statut_check CHECK (((statut)::text = ANY ((ARRAY['EN_COURS'::character varying, 'REPARE'::character varying, 'NON_REPARABLE'::character varying, 'A_REVOIR'::character varying])::text[])))
);


ALTER TABLE public.fiche_technique OWNER TO postgres;

--
-- Name: fiche_technique_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fiche_technique_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fiche_technique_id_seq OWNER TO postgres;

--
-- Name: fiche_technique_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fiche_technique_id_seq OWNED BY public.fiche_technique.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


ALTER TABLE public.job_batches OWNER TO postgres;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_id_seq OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO postgres;

--
-- Name: reparation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reparation (
    id bigint NOT NULL,
    visite_id bigint,
    description character varying(255),
    type character varying(255)
);


ALTER TABLE public.reparation OWNER TO postgres;

--
-- Name: reparation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reparation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reparation_id_seq OWNER TO postgres;

--
-- Name: reparation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reparation_id_seq OWNED BY public.reparation.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vehicule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicule (
    annee_mise_circulation integer,
    kilometrage_compteur integer,
    puissance_fiscale integer,
    client_id bigint,
    id bigint NOT NULL,
    carburant character varying(255),
    couleur character varying(255),
    immatriculation_part1 character varying(255),
    immatriculation_part2 character varying(255),
    immatriculation_part3 character varying(255),
    marque character varying(255),
    modele character varying(255),
    numero_chassis character varying(255),
    type_vehicule character varying(255)
);


ALTER TABLE public.vehicule OWNER TO postgres;

--
-- Name: vehicule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vehicule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vehicule_id_seq OWNER TO postgres;

--
-- Name: vehicule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vehicule_id_seq OWNED BY public.vehicule.id;


--
-- Name: visite_technique; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visite_technique (
    airbags boolean,
    bruit_moteur boolean,
    ceintures boolean,
    chassis boolean,
    clignotants boolean,
    date_limite_contre_visite date,
    date_validite date,
    date_visite date,
    direction boolean,
    essuie_glaces boolean,
    feux_arriere boolean,
    feux_position boolean,
    feux_stop boolean,
    freinage boolean,
    fuite_huile boolean,
    kilometrage integer,
    montant_paye double precision,
    pare_brise boolean,
    phares_avant boolean,
    pneus boolean,
    pot_echappement boolean,
    retroviseurs boolean,
    suspension boolean,
    id bigint NOT NULL,
    vehicule_id bigint,
    centre_visite character varying(255),
    controleur character varying(255),
    description_panne character varying(255),
    heure_visite character varying(255),
    mode_paiement character varying(255),
    niveau_emission character varying(255),
    numero_recu character varying(255),
    numero_visite character varying(255),
    observations_generales text,
    piece_manquante character varying(255),
    pieceareparer character varying(255),
    resultat_final character varying(255),
    statut_paiement character varying(255),
    temps_reparation character varying(255),
    type_visite character varying(255),
    ville character varying(255)
);


ALTER TABLE public.visite_technique OWNER TO postgres;

--
-- Name: visite_technique_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visite_technique_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visite_technique_id_seq OWNER TO postgres;

--
-- Name: visite_technique_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visite_technique_id_seq OWNED BY public.visite_technique.id;


--
-- Name: client id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client ALTER COLUMN id SET DEFAULT nextval('public.client_id_seq'::regclass);


--
-- Name: defaut id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.defaut ALTER COLUMN id SET DEFAULT nextval('public.defaut_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: fiche_technique id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fiche_technique ALTER COLUMN id SET DEFAULT nextval('public.fiche_technique_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: reparation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reparation ALTER COLUMN id SET DEFAULT nextval('public.reparation_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vehicule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicule ALTER COLUMN id SET DEFAULT nextval('public.vehicule_id_seq'::regclass);


--
-- Name: visite_technique id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visite_technique ALTER COLUMN id SET DEFAULT nextval('public.visite_technique_id_seq'::regclass);


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (id, adresse, cin, email, nom, prenom, telephone) FROM stdin;
1	123 Rue de la Paix, Casablanca	AB123456	ahmed.benani@email.com	Benani	Ahmed	0661234567
2	45 Avenue Hassan II, Rabat	CD987654	karim.alami@email.com	Alami	Karim	0669876543
3	12 Bd Mohammed V, Tanger	EF456789	sara.ouali@email.com	Ouali	Sara	0661122334
4	Appartement 1, Rue des Fleurs, Fes	CIN00101	driss.berrada1@email.com	Berrada	Driss	0695856358
5	Appartement 2, Rue des Fleurs, Kenitra	CIN00102	fatima.tazi2@email.com	Tazi	Fatima	0656146834
6	Appartement 3, Rue des Fleurs, Meknes	CIN00103	fatima.alami3@email.com	Alami	Fatima	0620990278
7	Appartement 4, Rue des Fleurs, Agadir	CIN00104	driss.alami4@email.com	Alami	Driss	0690937523
8	Appartement 5, Rue des Fleurs, Oujda	CIN00105	sara.slaoui5@email.com	Slaoui	Sara	0696899742
9	Appartement 6, Rue des Fleurs, Oujda	CIN00106	meriem.habibi6@email.com	Habibi	Meriem	0688909416
10	Appartement 7, Rue des Fleurs, Marrakech	CIN00107	sara.mansouri7@email.com	Mansouri	Sara	0673279545
11	Appartement 8, Rue des Fleurs, Rabat	CIN00108	yassine.idrissi8@email.com	Idrissi	Yassine	0607298249
12	Appartement 9, Rue des Fleurs, Tangier	CIN00109	omar.fassi9@email.com	Fassi	Omar	0652465867
13	Appartement 10, Rue des Fleurs, Tangier	CIN00110	karim.habibi10@email.com	Habibi	Karim	0625690358
14	Appartement 11, Rue des Fleurs, Fes	CIN00111	leila.tazi11@email.com	Tazi	Leila	0635648689
15	Appartement 12, Rue des Fleurs, Kenitra	CIN00112	leila.alami12@email.com	Alami	Leila	0622859098
16	Appartement 13, Rue des Fleurs, Fes	CIN00113	omar.slaoui13@email.com	Slaoui	Omar	0616137522
17	Appartement 14, Rue des Fleurs, Agadir	CIN00114	fatima.benani14@email.com	Benani	Fatima	0647639529
18	Appartement 15, Rue des Fleurs, Oujda	CIN00115	karim.tazi15@email.com	Tazi	Karim	0686159042
19	Appartement 16, Rue des Fleurs, Tetouan	CIN00116	omar.alami16@email.com	Alami	Omar	0616518755
20	Appartement 17, Rue des Fleurs, Tangier	CIN00117	karim.berrada17@email.com	Berrada	Karim	0612619324
21	Appartement 18, Rue des Fleurs, Agadir	CIN00118	meriem.fassi18@email.com	Fassi	Meriem	0628653713
22	Appartement 19, Rue des Fleurs, Tetouan	CIN00119	karim.alami19@email.com	Alami	Karim	0633861669
23	Appartement 20, Rue des Fleurs, Marrakech	CIN00120	salma.idrissi20@email.com	Idrissi	Salma	0614231685
24	Appartement 21, Rue des Fleurs, Agadir	CIN00121	fatima.slaoui21@email.com	Slaoui	Fatima	0676798446
25	Appartement 22, Rue des Fleurs, Rabat	CIN00122	meriem.mansouri22@email.com	Mansouri	Meriem	0691848668
26	Appartement 23, Rue des Fleurs, Kenitra	CIN00123	fatima.tazi23@email.com	Tazi	Fatima	0612249904
27	Appartement 24, Rue des Fleurs, Oujda	CIN00124	sara.idrissi24@email.com	Idrissi	Sara	0693523452
28	Appartement 25, Rue des Fleurs, Tetouan	CIN00125	omar.benani25@email.com	Benani	Omar	0613206511
29	Appartement 26, Rue des Fleurs, Oujda	CIN00126	omar.benani26@email.com	Benani	Omar	0615522904
30	Appartement 27, Rue des Fleurs, Rabat	CIN00127	ahmed.tazi27@email.com	Tazi	Ahmed	0692154072
31	Appartement 28, Rue des Fleurs, Casablanca	CIN00128	meriem.fassi28@email.com	Fassi	Meriem	0628430761
32	Appartement 29, Rue des Fleurs, Meknes	CIN00129	driss.alami29@email.com	Alami	Driss	0629955204
33	Appartement 30, Rue des Fleurs, Tetouan	CIN00130	driss.habibi30@email.com	Habibi	Driss	0619247668
34	Appartement 31, Rue des Fleurs, Meknes	CIN00131	karim.slaoui31@email.com	Slaoui	Karim	0607484853
35	Appartement 32, Rue des Fleurs, Marrakech	CIN00132	meriem.zaki32@email.com	Zaki	Meriem	0668149961
36	Appartement 33, Rue des Fleurs, Casablanca	CIN00133	sara.idrissi33@email.com	Idrissi	Sara	0674024023
37	Appartement 34, Rue des Fleurs, Fes	CIN00134	ahmed.fassi34@email.com	Fassi	Ahmed	0698901664
38	Appartement 35, Rue des Fleurs, Rabat	CIN00135	karim.zaki35@email.com	Zaki	Karim	0663990315
39	Appartement 36, Rue des Fleurs, Casablanca	CIN00136	fatima.idrissi36@email.com	Idrissi	Fatima	0612033226
40	Appartement 37, Rue des Fleurs, Tangier	CIN00137	yassine.zaki37@email.com	Zaki	Yassine	0694467391
41	Appartement 38, Rue des Fleurs, Tangier	CIN00138	sara.slaoui38@email.com	Slaoui	Sara	0614157307
42	Appartement 39, Rue des Fleurs, Casablanca	CIN00139	leila.fassi39@email.com	Fassi	Leila	0634973441
43	Appartement 40, Rue des Fleurs, Tangier	CIN00140	driss.benani40@email.com	Benani	Driss	0662662378
44	Appartement 41, Rue des Fleurs, Tetouan	CIN00141	meriem.habibi41@email.com	Habibi	Meriem	0628723457
45	Appartement 42, Rue des Fleurs, Agadir	CIN00142	driss.benani42@email.com	Benani	Driss	0637566350
46	Appartement 43, Rue des Fleurs, Rabat	CIN00143	fatima.mansouri43@email.com	Mansouri	Fatima	0631387952
47	Appartement 44, Rue des Fleurs, Oujda	CIN00144	sara.tazi44@email.com	Tazi	Sara	0680036707
48	Appartement 45, Rue des Fleurs, Casablanca	CIN00145	fatima.fassi45@email.com	Fassi	Fatima	0641123362
49	Appartement 46, Rue des Fleurs, Tangier	CIN00146	meriem.slaoui46@email.com	Slaoui	Meriem	0642708134
50	Appartement 47, Rue des Fleurs, Meknes	CIN00147	meriem.fassi47@email.com	Fassi	Meriem	0672457036
51	Appartement 48, Rue des Fleurs, Kenitra	CIN00148	karim.slaoui48@email.com	Slaoui	Karim	0647729300
52	Appartement 49, Rue des Fleurs, Kenitra	CIN00149	salma.habibi49@email.com	Habibi	Salma	0618293573
53	Appartement 50, Rue des Fleurs, Kenitra	CIN00150	ahmed.mansouri50@email.com	Mansouri	Ahmed	0625784495
54	Appartement 51, Rue des Fleurs, Fes	CIN00151	driss.fassi51@email.com	Fassi	Driss	0625528841
55	Appartement 52, Rue des Fleurs, Kenitra	CIN00152	yassine.fassi52@email.com	Fassi	Yassine	0618423032
56	Appartement 53, Rue des Fleurs, Rabat	CIN00153	salma.mansouri53@email.com	Mansouri	Salma	0697146673
57	Appartement 54, Rue des Fleurs, Rabat	CIN00154	driss.zaki54@email.com	Zaki	Driss	0686139445
58	Appartement 55, Rue des Fleurs, Rabat	CIN00155	meriem.alami55@email.com	Alami	Meriem	0687623483
59	Appartement 56, Rue des Fleurs, Fes	CIN00156	salma.benani56@email.com	Benani	Salma	0626988588
60	Appartement 57, Rue des Fleurs, Tangier	CIN00157	driss.alami57@email.com	Alami	Driss	0648781512
61	Appartement 58, Rue des Fleurs, Fes	CIN00158	ahmed.mansouri58@email.com	Mansouri	Ahmed	0655615206
62	Appartement 59, Rue des Fleurs, Casablanca	CIN00159	meriem.zaki59@email.com	Zaki	Meriem	0645141208
63	Appartement 60, Rue des Fleurs, Kenitra	CIN00160	salma.zaki60@email.com	Zaki	Salma	0680819693
64	Appartement 61, Rue des Fleurs, Fes	CIN00161	driss.habibi61@email.com	Habibi	Driss	0669007119
65	Appartement 62, Rue des Fleurs, Fes	CIN00162	meriem.zaki62@email.com	Zaki	Meriem	0647673229
66	Appartement 63, Rue des Fleurs, Casablanca	CIN00163	salma.tazi63@email.com	Tazi	Salma	0674867700
67	Appartement 64, Rue des Fleurs, Casablanca	CIN00164	fatima.benani64@email.com	Benani	Fatima	0661263661
68	Appartement 65, Rue des Fleurs, Fes	CIN00165	yassine.zaki65@email.com	Zaki	Yassine	0656352644
69	Appartement 66, Rue des Fleurs, Agadir	CIN00166	leila.mansouri66@email.com	Mansouri	Leila	0652269249
70	Appartement 67, Rue des Fleurs, Rabat	CIN00167	omar.berrada67@email.com	Berrada	Omar	0658168820
71	Appartement 68, Rue des Fleurs, Kenitra	CIN00168	driss.zaki68@email.com	Zaki	Driss	0608623252
72	Appartement 69, Rue des Fleurs, Fes	CIN00169	sara.alami69@email.com	Alami	Sara	0679368573
73	Appartement 70, Rue des Fleurs, Fes	CIN00170	fatima.idrissi70@email.com	Idrissi	Fatima	0651850631
74	Appartement 71, Rue des Fleurs, Casablanca	CIN00171	karim.slaoui71@email.com	Slaoui	Karim	0603443652
75	Appartement 72, Rue des Fleurs, Tangier	CIN00172	salma.tazi72@email.com	Tazi	Salma	0602599253
76	Appartement 73, Rue des Fleurs, Fes	CIN00173	yassine.benani73@email.com	Benani	Yassine	0602509033
77	Appartement 74, Rue des Fleurs, Tangier	CIN00174	karim.mansouri74@email.com	Mansouri	Karim	0628657876
78	Appartement 75, Rue des Fleurs, Fes	CIN00175	sara.idrissi75@email.com	Idrissi	Sara	0609918408
79	Appartement 76, Rue des Fleurs, Casablanca	CIN00176	sara.alami76@email.com	Alami	Sara	0698566706
80	Appartement 77, Rue des Fleurs, Meknes	CIN00177	fatima.tazi77@email.com	Tazi	Fatima	0615951411
81	Appartement 78, Rue des Fleurs, Tetouan	CIN00178	sara.berrada78@email.com	Berrada	Sara	0636588345
82	Appartement 79, Rue des Fleurs, Tetouan	CIN00179	ahmed.idrissi79@email.com	Idrissi	Ahmed	0605408826
83	Appartement 80, Rue des Fleurs, Marrakech	CIN00180	leila.fassi80@email.com	Fassi	Leila	0683771277
84	Appartement 81, Rue des Fleurs, Rabat	CIN00181	karim.tazi81@email.com	Tazi	Karim	0616115301
85	Appartement 82, Rue des Fleurs, Oujda	CIN00182	yassine.habibi82@email.com	Habibi	Yassine	0671895786
86	Appartement 83, Rue des Fleurs, Fes	CIN00183	omar.alami83@email.com	Alami	Omar	0652988661
87	Appartement 84, Rue des Fleurs, Tangier	CIN00184	fatima.benani84@email.com	Benani	Fatima	0649661544
88	Appartement 85, Rue des Fleurs, Casablanca	CIN00185	driss.berrada85@email.com	Berrada	Driss	0601266729
89	Appartement 86, Rue des Fleurs, Rabat	CIN00186	ahmed.slaoui86@email.com	Slaoui	Ahmed	0646269625
90	Appartement 87, Rue des Fleurs, Fes	CIN00187	salma.zaki87@email.com	Zaki	Salma	0689099892
91	Appartement 88, Rue des Fleurs, Agadir	CIN00188	ahmed.benani88@email.com	Benani	Ahmed	0685719143
92	Appartement 89, Rue des Fleurs, Tangier	CIN00189	meriem.tazi89@email.com	Tazi	Meriem	0680065225
93	Appartement 90, Rue des Fleurs, Marrakech	CIN00190	karim.habibi90@email.com	Habibi	Karim	0672609560
94	Appartement 91, Rue des Fleurs, Fes	CIN00191	omar.idrissi91@email.com	Idrissi	Omar	0673340625
95	Appartement 92, Rue des Fleurs, Rabat	CIN00192	karim.berrada92@email.com	Berrada	Karim	0676717772
96	Appartement 93, Rue des Fleurs, Kenitra	CIN00193	fatima.mansouri93@email.com	Mansouri	Fatima	0688524337
97	Appartement 94, Rue des Fleurs, Kenitra	CIN00194	yassine.mansouri94@email.com	Mansouri	Yassine	0612113179
98	Appartement 95, Rue des Fleurs, Kenitra	CIN00195	driss.mansouri95@email.com	Mansouri	Driss	0658036423
99	Appartement 96, Rue des Fleurs, Meknes	CIN00196	salma.slaoui96@email.com	Slaoui	Salma	0609304184
100	Appartement 97, Rue des Fleurs, Tetouan	CIN00197	ahmed.berrada97@email.com	Berrada	Ahmed	0649916395
101	Appartement 98, Rue des Fleurs, Agadir	CIN00198	karim.benani98@email.com	Benani	Karim	0618492274
102	Appartement 99, Rue des Fleurs, Tangier	CIN00199	ahmed.tazi99@email.com	Tazi	Ahmed	0631328944
103	Appartement 100, Rue des Fleurs, Meknes	CIN00200	karim.slaoui100@email.com	Slaoui	Karim	0667065805
104	rue 22	EF456789	YOUNESS.ABACH1@ibm.com	ads	Mohammed	0610674517
105	rue 22	EF456789	YOUNESS.ABACH1@ibm.com	XXXXX	YYYYYY	06106222222
106	rue 22	BH13242455	YOUNESS.ABACH1@ibm.com	RACHID	RACHID	0610674513
107	string	string	string	string	string	string
108	rue 22 saada 11	AB1234562	TEST.de.mail@email.com	YOUNESS	LAMBARGINI	0669876588
\.


--
-- Data for Name: defaut; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.defaut (id, visite_id, action_requise, code, description, gravite) FROM stdin;
1	2	Réparer le système de freinage	1.1.2	Efficacité du frein de service insuffisante	MAJEUR
2	2	Changer les pneus avant	5.2.3	Pneumatique: usure excessive	MAJEUR
3	2	Souder ou remplacer	6.1.1	Fuite importante système échappement	MINEUR
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: fiche_pannes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fiche_pannes (fiche_id, panne) FROM stdin;
3	Feux défaillants
3	Courroie de distribution usée
3	Problème d'embrayage
4	Courroie de distribution usée
5	Feux défaillants
5	Climatisation en panne
5	Amortisseurs défaillants
6	Plaquettes de frein usées
7	Pneus usés
7	Amortisseurs défaillants
8	Feux défaillants
8	Climatisation en panne
9	Pneus usés
10	Pneus usés
11	Pneus usés
11	Batterie faible
11	Échappement percé
12	Amortisseurs défaillants
13	Courroie de distribution usée
13	Échappement percé
13	Problème d'embrayage
14	Fuite d'huile moteur
14	Climatisation en panne
15	Batterie faible
15	Amortisseurs défaillants
15	Plaquettes de frein usées
16	Amortisseurs défaillants
17	Amortisseurs défaillants
17	Feux défaillants
18	Climatisation en panne
19	Amortisseurs défaillants
19	Pneus usés
20	Courroie de distribution usée
21	Plaquettes de frein usées
22	Problème d'embrayage
22	Pneus usés
22	Échappement percé
23	Climatisation en panne
23	Pneus usés
24	Plaquettes de frein usées
24	Problème d'embrayage
24	Courroie de distribution usée
25	Plaquettes de frein usées
26	Feux défaillants
26	Pneus usés
27	Amortisseurs défaillants
27	Fuite d'huile moteur
27	Climatisation en panne
28	Feux défaillants
29	Amortisseurs défaillants
29	Échappement percé
29	Batterie faible
30	Feux défaillants
30	Fuite d'huile moteur
30	Climatisation en panne
31	Climatisation en panne
31	Amortisseurs défaillants
31	Batterie faible
32	Pneus usés
32	Plaquettes de frein usées
33	Échappement percé
33	Problème d'embrayage
33	Feux défaillants
34	Échappement percé
35	Échappement percé
35	Fuite d'huile moteur
35	Échappement percé
37	Pneus usés
37	Problème d'embrayage
37	Climatisation en panne
38	Climatisation en panne
39	Échappement percé
39	Feux défaillants
39	Échappement percé
40	Climatisation en panne
41	Climatisation en panne
41	Plaquettes de frein usées
42	Problème d'embrayage
42	Problème d'embrayage
43	Courroie de distribution usée
43	Plaquettes de frein usées
44	Batterie faible
45	Problème d'embrayage
46	Plaquettes de frein usées
46	Plaquettes de frein usées
46	Problème d'embrayage
47	Courroie de distribution usée
47	Batterie faible
48	Échappement percé
48	Feux défaillants
49	Courroie de distribution usée
49	Feux défaillants
50	Pneus usés
36	Amortisseurs défaillants
36	Plaquettes de frein usées
36	Batterie faible
52	panne 1
52	panne 2
53	d
53	dsdd
53	dsdsds
53	dsdsds
2	Amortisseurs défaillants
2	Feux défaillants
2	Batterie faible
\.


--
-- Data for Name: fiche_pieces_changees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fiche_pieces_changees (fiche_id, piece) FROM stdin;
4	Pneus
4	Plaquettes de frein
4	Courroie de distribution
5	Bougies d'allumage
5	Batterie
6	Amortisseurs
6	Bougies d'allumage
6	Pneus
7	Courroie de distribution
7	Bougies d'allumage
8	Amortisseurs
9	Rotules
11	Bougies d'allumage
11	Pneus
12	Filtre à huile
13	Courroie de distribution
15	Filtre à air
15	Rotules
16	Amortisseurs
16	Plaquettes de frein
16	Amortisseurs
17	Courroie de distribution
17	Pneus
18	Filtre à air
19	Amortisseurs
19	Filtre à huile
19	Filtre à huile
20	Bougies d'allumage
21	Rotules
21	Filtre à huile
22	Courroie de distribution
22	Courroie de distribution
23	Courroie de distribution
23	Disques de frein
24	Batterie
24	Disques de frein
25	Bougies d'allumage
25	Batterie
26	Bougies d'allumage
27	Pneus
29	Batterie
29	Filtre à huile
31	Bougies d'allumage
31	Disques de frein
32	Bougies d'allumage
32	Amortisseurs
32	Bougies d'allumage
33	Rotules
34	Amortisseurs
34	Filtre à huile
37	Batterie
37	Amortisseurs
38	Filtre à air
38	Plaquettes de frein
38	Pneus
39	Courroie de distribution
39	Disques de frein
40	Plaquettes de frein
41	Bougies d'allumage
41	Rotules
43	Pneus
43	Filtre à huile
47	Disques de frein
50	Pneus
50	Amortisseurs
50	Filtre à huile
36	Plaquettes de frein
36	Filtre à air
36	Rotules
52	freine
52	roues
53	ssdsd
53	sddd
2	Disques de frein
2	Plaquettes de frein
\.


--
-- Data for Name: fiche_technique; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fiche_technique (id, annee, cout_main_oeuvre, cout_pieces, date_diagnostic, date_reparation, description_diagnostic, duree_reparation_heures, etat_carrosserie, etat_electrique, etat_freins, etat_general, etat_moteur, etat_suspension, gravite, immatriculation, kilometrage, marque, modele, observation_mecanicien, reparable, statut, vehicule_id) FROM stdin;
3	2017	\N	\N	2025-07-09	2025-07-14	Diagnostic généré #2. 3 pannes détectées.	\N	MAUVAIS	MOYEN	MAUVAIS	MOYEN	MAUVAIS	MOYEN	MAJEURE	96946-A-60	64854	Toyota	Dynamic 2015	Généré automatiquement.	f	REPARE	74
4	2015	58.210400672257805	310.5482797307202	2025-06-14	\N	Diagnostic généré #3. 1 pannes détectées.	5	MOYEN	BON	MAUVAIS	MAUVAIS	BON	MAUVAIS	MAJEURE	11223-D-1	214522	Renault	Kangoo	Généré automatiquement.	t	NON_REPARABLE	3
5	2018	144.64248860020987	303.33053333650605	2025-11-10	2025-11-14	Diagnostic généré #4. 3 pannes détectées.	2	MAUVAIS	MAUVAIS	MAUVAIS	BON	BON	BON	MINEURE	00087-A-46	196352	BMW	L 2016	Généré automatiquement.	t	REPARE	81
6	2012	215.7899241465452	807.8527297631888	2025-08-02	2025-08-03	Diagnostic généré #5. 1 pannes détectées.	1	MOYEN	MAUVAIS	BON	MOYEN	MAUVAIS	MOYEN	CRITIQUE	12409-A-54	198234	Hyundai	Dynamic 2014	Généré automatiquement.	t	A_REVOIR	49
7	2014	79.75129609283229	521.1633628062202	2025-02-28	\N	Diagnostic généré #6. 2 pannes détectées.	6	BON	MOYEN	MOYEN	MAUVAIS	MOYEN	MOYEN	MAJEURE	33165-A-53	90774	Fiat	Active 2020	Généré automatiquement.	t	EN_COURS	20
8	2013	64.32976598930762	385.68041515096627	2025-06-29	2025-06-30	Diagnostic généré #7. 2 pannes détectées.	5	MOYEN	MOYEN	MAUVAIS	MAUVAIS	MOYEN	MAUVAIS	MAJEURE	52512-A-65	169990	Mercedes	Dynamic 2019	Généré automatiquement.	t	A_REVOIR	91
9	2015	199.10757250584888	619.3752965579112	2025-02-17	\N	Diagnostic généré #8. 1 pannes détectées.	7	MOYEN	MOYEN	MOYEN	BON	MOYEN	MOYEN	MINEURE	50334-A-88	45887	Fiat	Comfort 2021	Généré automatiquement.	t	A_REVOIR	94
10	2022	\N	\N	2025-07-10	2025-07-12	Diagnostic généré #9. 1 pannes détectées.	\N	BON	BON	MAUVAIS	MAUVAIS	MAUVAIS	BON	CRITIQUE	67811-A-38	105837	Toyota	M 2019	Généré automatiquement.	f	EN_COURS	29
11	2021	192.1178220355516	239.3450678930519	2025-05-09	\N	Diagnostic généré #10. 3 pannes détectées.	2	MAUVAIS	MAUVAIS	MOYEN	BON	MOYEN	MOYEN	CRITIQUE	21460-A-83	94834	Fiat	Sport 2022	Généré automatiquement.	t	EN_COURS	92
12	2015	238.03817052861203	214.29225421070373	2025-12-03	\N	Diagnostic généré #11. 1 pannes détectées.	4	MOYEN	MOYEN	MAUVAIS	BON	MOYEN	BON	MAJEURE	25118-A-76	144023	Ford	Active 2013	Généré automatiquement.	t	EN_COURS	12
13	2010	109.43430277958262	929.6817483383317	2025-06-14	\N	Diagnostic généré #12. 3 pannes détectées.	1	BON	MAUVAIS	MAUVAIS	MOYEN	MAUVAIS	BON	CRITIQUE	82353-A-84	202471	Toyota	Business 2010	Généré automatiquement.	t	A_REVOIR	39
14	2014	\N	\N	2025-09-27	\N	Diagnostic généré #13. 2 pannes détectées.	\N	MOYEN	MAUVAIS	MOYEN	BON	BON	MAUVAIS	MAJEURE	67456-A-54	106583	Fiat	Dynamic 2016	Généré automatiquement.	f	EN_COURS	37
15	2014	106.90431473741613	583.1802988115103	2025-10-05	2025-10-10	Diagnostic généré #14. 3 pannes détectées.	3	BON	BON	MAUVAIS	MAUVAIS	MAUVAIS	MAUVAIS	MAJEURE	46002-A-81	127085	Toyota	Dynamic 2014	Généré automatiquement.	t	REPARE	69
16	2011	112.41035187664932	676.302861795088	2025-07-11	2025-07-13	Diagnostic généré #15. 1 pannes détectées.	1	MAUVAIS	BON	MOYEN	MOYEN	MOYEN	BON	MINEURE	08718-A-36	81851	Renault	XL 2013	Généré automatiquement.	t	NON_REPARABLE	52
17	2013	243.8318263665575	106.47314909740156	2025-07-14	2025-07-15	Diagnostic généré #16. 2 pannes détectées.	2	MOYEN	BON	BON	MOYEN	BON	BON	MAJEURE	85257-A-3	36622	Hyundai	Premium 2018	Généré automatiquement.	t	NON_REPARABLE	7
18	2012	67.81846727402434	852.8383823337364	2025-07-16	2025-07-17	Diagnostic généré #17. 1 pannes détectées.	7	BON	MOYEN	MOYEN	MAUVAIS	MOYEN	BON	MINEURE	15603-A-31	38504	Dacia	Premium 2018	Généré automatiquement.	t	A_REVOIR	61
19	2019	165.86186073646786	174.57115610027023	2025-08-29	2025-09-02	Diagnostic généré #18. 2 pannes détectées.	6	MOYEN	BON	MAUVAIS	MOYEN	MAUVAIS	MOYEN	MAJEURE	86602-A-13	127014	BMW	L 2017	Généré automatiquement.	t	A_REVOIR	88
20	2022	74.83542329667767	806.1588709454787	2025-12-04	2025-12-06	Diagnostic généré #19. 1 pannes détectées.	8	MAUVAIS	MAUVAIS	MAUVAIS	BON	MAUVAIS	MOYEN	MAJEURE	19684-A-47	209835	BMW	XL 2021	Généré automatiquement.	t	REPARE	31
21	2020	95.51686406375254	772.340177293675	2025-05-08	\N	Diagnostic généré #20. 1 pannes détectées.	8	BON	MOYEN	BON	BON	MOYEN	MOYEN	CRITIQUE	32707-A-51	132114	Peugeot	Comfort 2022	Généré automatiquement.	t	EN_COURS	72
22	2015	231.54422598960628	466.34959557528316	2025-09-24	\N	Diagnostic généré #21. 3 pannes détectées.	7	MAUVAIS	BON	BON	MOYEN	MOYEN	MOYEN	MAJEURE	11223-D-1	211801	Renault	Kangoo	Généré automatiquement.	t	REPARE	3
23	2019	59.581733304499295	813.5984269754855	2025-01-19	\N	Diagnostic généré #22. 2 pannes détectées.	8	MOYEN	MOYEN	MOYEN	BON	BON	MAUVAIS	MINEURE	76770-A-46	72863	Dacia	Active 2012	Généré automatiquement.	t	REPARE	26
24	2013	140.94798132115983	793.4109713647595	2025-02-04	\N	Diagnostic généré #23. 3 pannes détectées.	4	MAUVAIS	MOYEN	MAUVAIS	BON	MAUVAIS	MAUVAIS	MAJEURE	52512-A-65	171310	Mercedes	Dynamic 2019	Généré automatiquement.	t	NON_REPARABLE	91
25	2011	219.87073684976227	529.8766638872187	2025-07-17	\N	Diagnostic généré #24. 1 pannes détectées.	3	MAUVAIS	BON	BON	MOYEN	MOYEN	MAUVAIS	MINEURE	28096-A-25	70237	Ford	S 2022	Généré automatiquement.	t	NON_REPARABLE	73
26	2017	115.57651974300147	304.7857344942623	2025-05-04	\N	Diagnostic généré #25. 2 pannes détectées.	3	MAUVAIS	MOYEN	MAUVAIS	MOYEN	MOYEN	MAUVAIS	MINEURE	49078-A-23	175159	BMW	XL 2014	Généré automatiquement.	t	EN_COURS	87
27	2014	168.82628256969463	850.3077146492263	2025-04-06	2025-04-07	Diagnostic généré #26. 3 pannes détectées.	8	MOYEN	MOYEN	MOYEN	MAUVAIS	MOYEN	BON	MINEURE	27729-A-4	31832	Toyota	Sport 2021	Généré automatiquement.	t	NON_REPARABLE	22
28	2016	\N	\N	2025-01-21	2025-01-26	Diagnostic généré #27. 1 pannes détectées.	\N	BON	MOYEN	MOYEN	MOYEN	BON	BON	MINEURE	47663-A-72	148805	Renault	XL 2020	Généré automatiquement.	f	A_REVOIR	33
29	2023	99.06941065759398	756.8295790055698	2025-10-10	\N	Diagnostic généré #28. 3 pannes détectées.	1	BON	BON	BON	MAUVAIS	BON	BON	MAJEURE	95868-A-44	98986	Fiat	Comfort 2011	Généré automatiquement.	t	NON_REPARABLE	99
30	2014	\N	\N	2025-10-01	2025-10-05	Diagnostic généré #29. 3 pannes détectées.	\N	MOYEN	BON	MAUVAIS	BON	BON	BON	MINEURE	32296-A-26	66082	Dacia	Active 2017	Généré automatiquement.	f	EN_COURS	46
31	2020	118.61480269011844	454.1045055040209	2025-06-13	\N	Diagnostic généré #30. 3 pannes détectées.	1	MOYEN	MOYEN	MAUVAIS	BON	BON	MAUVAIS	MAJEURE	84530-A-28	195883	Volkswagen	Sport 2015	Généré automatiquement.	t	A_REVOIR	32
32	2015	214.0900089863805	338.087194039132	2025-02-26	\N	Diagnostic généré #31. 2 pannes détectées.	4	BON	MOYEN	MAUVAIS	MOYEN	BON	MAUVAIS	MAJEURE	11223-D-1	212889	Renault	Kangoo	Généré automatiquement.	t	NON_REPARABLE	3
2	2022	56672	233	2025-10-20	2025-10-23	Diagnostic généré #1. 3 pannes détectées.	4	MAUVAIS	MOYEN	BON	BON	MAUVAIS	MAUVAIS	MINEURE	99887-H-40	18596	Toyota	Yaris	Généré automatiquement.	t	A_REVOIR	4
33	2021	109.42948679586385	664.5655283405333	2025-07-06	2025-07-07	Diagnostic généré #32. 3 pannes détectées.	1	BON	MOYEN	MAUVAIS	MOYEN	BON	MOYEN	CRITIQUE	47631-A-33	127406	Fiat	Active 2015	Généré automatiquement.	t	NON_REPARABLE	103
34	2013	75.80043417157441	996.6687210031871	2025-01-20	2025-01-27	Diagnostic généré #33. 1 pannes détectées.	1	MOYEN	MAUVAIS	MOYEN	MOYEN	BON	MAUVAIS	MAJEURE	52512-A-65	173438	Mercedes	Dynamic 2019	Généré automatiquement.	t	A_REVOIR	91
35	2019	\N	\N	2025-03-15	2025-03-18	Diagnostic généré #34. 3 pannes détectées.	\N	BON	MAUVAIS	MAUVAIS	BON	BON	MOYEN	MAJEURE	99431-A-47	197915	Hyundai	Premium 2021	Généré automatiquement.	f	A_REVOIR	10
37	2014	83.49697572888735	572.7838318409486	2025-07-27	2025-07-30	Diagnostic généré #36. 3 pannes détectées.	1	BON	MOYEN	MOYEN	MOYEN	BON	MOYEN	MINEURE	46002-A-81	125036	Toyota	Dynamic 2014	Généré automatiquement.	t	NON_REPARABLE	69
38	2015	173.13196028220756	922.6070801230902	2025-10-06	2025-10-13	Diagnostic généré #37. 1 pannes détectées.	5	BON	MAUVAIS	MOYEN	MOYEN	MOYEN	BON	MINEURE	50334-A-88	46154	Fiat	Comfort 2021	Généré automatiquement.	t	REPARE	94
39	2013	53.819725482008685	789.5845207343853	2025-05-17	\N	Diagnostic généré #38. 3 pannes détectées.	8	MAUVAIS	MOYEN	BON	BON	MAUVAIS	MAUVAIS	MINEURE	13519-A-62	84425	Dacia	Active 2013	Généré automatiquement.	t	REPARE	38
40	2019	193.90072928110857	854.8995219453536	2025-01-10	\N	Diagnostic généré #39. 1 pannes détectées.	5	MOYEN	MAUVAIS	BON	BON	MOYEN	MOYEN	MAJEURE	49661-A-68	206137	Renault	L 2017	Généré automatiquement.	t	EN_COURS	6
41	2019	63.75990649798477	452.1411526653873	2025-10-20	\N	Diagnostic généré #40. 2 pannes détectées.	4	MAUVAIS	BON	BON	BON	MOYEN	MOYEN	MAJEURE	74750-A-10	181330	Renault	Comfort 2022	Généré automatiquement.	t	EN_COURS	78
42	2016	\N	\N	2025-07-14	\N	Diagnostic généré #41. 2 pannes détectées.	\N	MAUVAIS	MAUVAIS	MOYEN	MAUVAIS	MAUVAIS	MAUVAIS	CRITIQUE	23511-A-21	122840	Mercedes	Active 2011	Généré automatiquement.	f	A_REVOIR	21
43	2018	152.66445724073844	615.7537753277894	2025-05-09	2025-05-14	Diagnostic généré #42. 2 pannes détectées.	2	MOYEN	MOYEN	BON	MOYEN	MOYEN	MOYEN	MINEURE	34007-A-50	194912	Peugeot	Business 2018	Généré automatiquement.	t	A_REVOIR	70
44	2015	\N	\N	2025-10-11	\N	Diagnostic généré #43. 1 pannes détectées.	\N	BON	BON	MAUVAIS	MAUVAIS	MAUVAIS	MOYEN	MINEURE	03102-A-69	161262	Ford	Premium 2020	Généré automatiquement.	f	NON_REPARABLE	66
45	2018	\N	\N	2024-12-20	2024-12-26	Diagnostic généré #44. 1 pannes détectées.	\N	MOYEN	MAUVAIS	MAUVAIS	MOYEN	BON	BON	CRITIQUE	12345-A-6	124372	Dacia	Logan	Généré automatiquement.	f	REPARE	1
46	2013	\N	\N	2025-04-15	2025-04-21	Diagnostic généré #45. 3 pannes détectées.	\N	BON	MOYEN	MOYEN	MAUVAIS	BON	MAUVAIS	CRITIQUE	63063-A-74	177329	Peugeot	Business 2012	Généré automatiquement.	f	A_REVOIR	96
47	2019	52.46037951182909	840.1738865381684	2025-03-31	\N	Diagnostic généré #46. 2 pannes détectées.	7	MAUVAIS	MOYEN	BON	MOYEN	BON	BON	CRITIQUE	99431-A-47	196325	Hyundai	Premium 2021	Généré automatiquement.	t	A_REVOIR	10
48	2021	\N	\N	2025-06-15	\N	Diagnostic généré #47. 2 pannes détectées.	\N	BON	BON	MAUVAIS	MOYEN	MOYEN	MAUVAIS	MAJEURE	76983-A-19	142907	Fiat	Active 2021	Généré automatiquement.	f	EN_COURS	17
49	2022	\N	\N	2025-05-27	\N	Diagnostic généré #48. 2 pannes détectées.	\N	MOYEN	BON	BON	MOYEN	BON	MOYEN	CRITIQUE	19684-A-47	209968	BMW	XL 2021	Généré automatiquement.	f	EN_COURS	31
50	2019	222.64509441794283	903.4559830425075	2025-10-15	\N	Diagnostic généré #49. 1 pannes détectées.	7	MAUVAIS	BON	MAUVAIS	MOYEN	MAUVAIS	MOYEN	MINEURE	04023-A-12	188531	Volkswagen	Dynamic 2010	Généré automatiquement.	t	EN_COURS	41
36	2020	156.08051276131948	808.7396652589264	2025-07-29	2025-07-31	Diagnostic généré #35. 3 pannes détectées.	7	MAUVAIS	BON	MOYEN	MAUVAIS	MAUVAIS	MOYEN	CRITIQUE	56789-B-6	48770	Peugeot	208	Généré automatiquement.	t	NON_REPARABLE	\N
51	2019	1	1	2025-12-20	\N	\N	1	BON	BON	BON	BON	BON	BON	MINEURE	17734-A-72	59537	Peugeot	Business 2022	\N	t	REPARE	5
52	2015	4	3	2025-12-20	\N	teste test test	10	BON	BON	MAUVAIS	BON	BON	BON	CRITIQUE	11223-D-1	210000	Renault	Kangoo	observation test test	t	EN_COURS	3
1	2018	4	4	2025-12-19	\N	freine freine freine	3	MAUVAIS	BON	MOYEN	BON	BON	BON	MAJEURE	12345-A-6	120000	Dacia	Logan	Observation du Mécanicien\nObservation du Mécanicien\nObservation du Mécanicien\n	t	A_REVOIR	1
53	2025	3	4	2025-12-20	\N	ssdsd	3	BON	BON	BON	BON	BON	BON	MINEURE	67700-B-1	7	DACIA	DUSTER	\N	t	A_REVOIR	108
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000002_create_jobs_table	1
4	2025_12_19_121215_create_clients_table	1
5	2025_12_19_121215_create_vehicules_table	1
6	2025_12_19_121215_create_visite_techniques_table	1
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: reparation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reparation (id, visite_id, description, type) FROM stdin;
1	3	Remplacement des plaquettes et disques de frein	CHANGEMENT
2	3	Remplacement 2 pneus avant	CHANGEMENT
3	3	Soudure pot échappement	REPARATION
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, email_verified_at, password, remember_token, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: vehicule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicule (annee_mise_circulation, kilometrage_compteur, puissance_fiscale, client_id, id, carburant, couleur, immatriculation_part1, immatriculation_part2, immatriculation_part3, marque, modele, numero_chassis, type_vehicule) FROM stdin;
2018	120000	7	1	1	Diesel	Blanc	12345	A	6	Dacia	Logan	VF1LOGAN12345678	Tourisme
2015	210000	8	2	3	Diesel	Noir	11223	D	1	Renault	Kangoo	VF1KANGOO554433	Utilitaire
2022	15000	5	3	4	Hybride	Bleu	99887	H	40	Toyota	Yaris	JTDKYARIS112233	Tourisme
2019	59537	14	19	5	Diesel	Couleur 1	17734	A	72	Peugeot	Business 2022	VIN000000001001	4x4
2019	201469	5	68	6	Essence	Couleur 2	49661	A	68	Renault	L 2017	VIN000000001002	4x4
2013	36357	4	81	7	Hybride	Couleur 3	85257	A	3	Hyundai	Premium 2018	VIN000000001003	4x4
2019	72726	5	75	8	Hybride	Couleur 4	48237	A	36	Toyota	Premium 2015	VIN000000001004	Utilitaire
2018	53310	14	72	9	Electrique	Couleur 5	54239	A	84	Volkswagen	L 2012	VIN000000001005	Camionnette
2019	193253	8	52	10	Essence	Couleur 6	99431	A	47	Hyundai	Premium 2021	VIN000000001006	Tourisme
2011	73278	4	76	11	Essence	Couleur 7	39300	A	6	Ford	Active 2021	VIN000000001007	Tourisme
2015	143072	5	43	12	Diesel	Couleur 8	25118	A	76	Ford	Active 2013	VIN000000001008	Camionnette
2022	69623	11	94	13	Essence	Couleur 9	11088	A	80	Toyota	L 2018	VIN000000001009	Tourisme
2022	71491	14	19	14	Electrique	Couleur 10	31807	A	53	Dacia	Business 2011	VIN000000001010	Utilitaire
2013	105388	6	75	15	Diesel	Couleur 11	31553	A	18	Volkswagen	Premium 2010	VIN000000001011	Utilitaire
2021	182861	8	4	16	Electrique	Couleur 12	77650	A	21	Dacia	Comfort 2011	VIN000000001012	Camionnette
2021	140901	14	83	17	Diesel	Couleur 13	76983	A	19	Fiat	Active 2021	VIN000000001013	Camionnette
2012	107120	5	13	18	Essence	Couleur 14	06283	A	19	Fiat	Premium 2015	VIN000000001014	Utilitaire
2019	85261	4	100	19	Essence	Couleur 15	74780	A	27	Hyundai	XL 2015	VIN000000001015	Tourisme
2014	87825	7	95	20	Electrique	Couleur 16	33165	A	53	Fiat	Active 2020	VIN000000001016	Camionnette
2016	121658	14	26	21	Electrique	Couleur 17	23511	A	21	Mercedes	Active 2011	VIN000000001017	4x4
2014	28661	6	76	22	Electrique	Couleur 18	27729	A	4	Toyota	Sport 2021	VIN000000001018	4x4
2016	92979	4	85	23	Electrique	Couleur 19	32444	A	79	Dacia	L 2013	VIN000000001019	4x4
2018	71273	7	63	24	Essence	Couleur 20	73825	A	42	Dacia	Business 2011	VIN000000001020	Camionnette
2021	12804	8	77	25	Essence	Couleur 21	75820	A	8	Ford	M 2020	VIN000000001021	Camionnette
2019	71518	6	34	26	Electrique	Couleur 22	76770	A	46	Dacia	Active 2012	VIN000000001022	Camionnette
2018	50849	10	22	27	Hybride	Couleur 23	07354	A	88	Hyundai	L 2018	VIN000000001023	Camionnette
2014	38579	9	83	28	Hybride	Couleur 24	07858	A	82	Renault	S 2021	VIN000000001024	Tourisme
2022	105129	13	78	29	Diesel	Couleur 25	67811	A	38	Toyota	M 2019	VIN000000001025	Camionnette
2021	124326	4	99	30	Essence	Couleur 26	49964	A	10	Ford	Dynamic 2020	VIN000000001026	Utilitaire
2022	209113	15	90	31	Diesel	Couleur 27	19684	A	47	BMW	XL 2021	VIN000000001027	Camionnette
2020	191025	7	56	32	Essence	Couleur 28	84530	A	28	Volkswagen	Sport 2015	VIN000000001028	Tourisme
2016	146357	4	72	33	Electrique	Couleur 29	47663	A	72	Renault	XL 2020	VIN000000001029	Tourisme
2017	146627	10	81	34	Diesel	Couleur 30	60705	A	27	Renault	L 2016	VIN000000001030	Tourisme
2016	17018	4	39	35	Hybride	Couleur 31	23878	A	15	Ford	S 2015	VIN000000001031	4x4
2013	105058	11	79	36	Essence	Couleur 32	91643	A	9	Peugeot	M 2010	VIN000000001032	Camionnette
2014	106007	4	86	37	Electrique	Couleur 33	67456	A	54	Fiat	Dynamic 2016	VIN000000001033	4x4
2013	81495	5	12	38	Hybride	Couleur 34	13519	A	62	Dacia	Active 2013	VIN000000001034	Utilitaire
2010	199885	8	56	39	Essence	Couleur 35	82353	A	84	Toyota	Business 2010	VIN000000001035	Camionnette
2017	190085	15	71	40	Hybride	Couleur 36	28310	A	32	Peugeot	M 2018	VIN000000001036	Camionnette
2019	184626	13	19	41	Hybride	Couleur 37	04023	A	12	Volkswagen	Dynamic 2010	VIN000000001037	Tourisme
2021	53564	15	95	42	Essence	Couleur 38	57478	A	85	Renault	Active 2010	VIN000000001038	Utilitaire
2019	47528	5	56	43	Electrique	Couleur 39	74172	A	29	Peugeot	Comfort 2016	VIN000000001039	Utilitaire
2015	123122	12	19	44	Essence	Couleur 40	57647	A	80	Ford	Sport 2017	VIN000000001040	Utilitaire
2019	15510	6	91	45	Essence	Couleur 41	65437	A	39	Hyundai	Comfort 2014	VIN000000001041	Camionnette
2014	62706	7	44	46	Essence	Couleur 42	32296	A	26	Dacia	Active 2017	VIN000000001042	Tourisme
2022	28402	9	97	47	Diesel	Couleur 43	60336	A	29	Toyota	S 2014	VIN000000001043	Tourisme
2019	202718	9	16	48	Electrique	Couleur 44	35834	A	28	BMW	Comfort 2016	VIN000000001044	Utilitaire
2012	194071	12	72	49	Electrique	Couleur 45	12409	A	54	Hyundai	Dynamic 2014	VIN000000001045	Utilitaire
2019	83246	4	79	50	Electrique	Couleur 46	98041	A	43	Ford	Business 2018	VIN000000001046	Utilitaire
2019	191630	9	20	51	Hybride	Couleur 47	74922	A	4	Ford	Dynamic 2015	VIN000000001047	Tourisme
2011	80498	11	58	52	Essence	Couleur 48	08718	A	36	Renault	XL 2013	VIN000000001048	4x4
2010	52862	7	13	53	Essence	Couleur 49	92200	A	79	Fiat	L 2017	VIN000000001049	4x4
2021	73225	11	86	54	Essence	Couleur 50	64427	A	82	Volkswagen	Dynamic 2014	VIN000000001050	Utilitaire
2020	129116	11	45	55	Diesel	Couleur 51	62496	A	38	Hyundai	Sport 2014	VIN000000001051	Tourisme
2010	60176	10	45	56	Electrique	Couleur 52	72612	A	2	Volkswagen	XL 2019	VIN000000001052	4x4
2018	206756	8	46	57	Electrique	Couleur 53	63118	A	80	Ford	Premium 2014	VIN000000001053	Utilitaire
2016	32458	12	57	58	Electrique	Couleur 54	74061	A	65	Dacia	Business 2016	VIN000000001054	Utilitaire
2019	93602	7	11	59	Diesel	Couleur 55	48653	A	76	BMW	XL 2018	VIN000000001055	4x4
2022	143916	12	99	60	Hybride	Couleur 56	81108	A	89	Volkswagen	S 2016	VIN000000001056	Tourisme
2012	36837	11	59	61	Essence	Couleur 57	15603	A	31	Dacia	Premium 2018	VIN000000001057	Tourisme
2021	153882	12	18	62	Electrique	Couleur 58	86456	A	13	Fiat	Business 2012	VIN000000001058	Camionnette
2021	203217	13	13	63	Electrique	Couleur 59	13969	A	85	Peugeot	Active 2022	VIN000000001059	Utilitaire
2015	65803	15	100	64	Electrique	Couleur 60	02196	A	35	BMW	Premium 2020	VIN000000001060	4x4
2011	151224	6	76	65	Electrique	Couleur 61	72018	A	49	Ford	S 2012	VIN000000001061	Tourisme
2015	156619	12	52	66	Electrique	Couleur 62	03102	A	69	Ford	Premium 2020	VIN000000001062	4x4
2019	89900	4	33	67	Diesel	Couleur 63	02488	A	37	BMW	Premium 2020	VIN000000001063	Tourisme
2013	38690	9	18	68	Essence	Couleur 64	39285	A	79	Dacia	Business 2018	VIN000000001064	Utilitaire
2014	124965	12	64	69	Diesel	Couleur 65	46002	A	81	Toyota	Dynamic 2014	VIN000000001065	Tourisme
2018	192396	15	49	70	Electrique	Couleur 66	34007	A	50	Peugeot	Business 2018	VIN000000001066	Tourisme
2021	86154	6	54	71	Essence	Couleur 67	31844	A	21	Toyota	Dynamic 2018	VIN000000001067	Tourisme
2020	128788	11	16	72	Hybride	Couleur 68	32707	A	51	Peugeot	Comfort 2022	VIN000000001068	4x4
2011	68247	5	62	73	Hybride	Couleur 69	28096	A	25	Ford	S 2022	VIN000000001069	4x4
2017	61236	10	37	74	Diesel	Couleur 70	96946	A	60	Toyota	Dynamic 2015	VIN000000001070	4x4
2020	17155	7	10	75	Electrique	Couleur 71	04174	A	42	Mercedes	M 2016	VIN000000001071	4x4
2021	46609	6	94	76	Essence	Couleur 72	39648	A	54	Toyota	Dynamic 2018	VIN000000001072	Tourisme
2013	200794	14	5	77	Diesel	Couleur 73	33148	A	10	Ford	Business 2010	VIN000000001073	4x4
2019	180465	5	65	78	Diesel	Couleur 74	74750	A	10	Renault	Comfort 2022	VIN000000001074	Tourisme
2012	143472	9	29	79	Essence	Couleur 75	47886	A	28	Volkswagen	S 2020	VIN000000001075	Utilitaire
2023	112335	11	80	80	Electrique	Couleur 76	00742	A	78	Ford	L 2013	VIN000000001076	Tourisme
2018	193254	13	18	81	Essence	Couleur 77	00087	A	46	BMW	L 2016	VIN000000001077	Tourisme
2014	79829	13	33	82	Essence	Couleur 78	64187	A	24	Volkswagen	XL 2011	VIN000000001078	Camionnette
2011	196436	8	52	83	Essence	Couleur 79	55971	A	78	Mercedes	Comfort 2017	VIN000000001079	4x4
2013	45679	15	76	84	Hybride	Couleur 80	37279	A	81	Mercedes	S 2015	VIN000000001080	4x4
2017	114273	7	68	85	Diesel	Couleur 81	43334	A	52	Mercedes	Dynamic 2017	VIN000000001081	Camionnette
2013	185605	5	24	86	Electrique	Couleur 82	66632	A	75	BMW	Dynamic 2014	VIN000000001082	4x4
2017	173152	15	30	87	Essence	Couleur 83	49078	A	23	BMW	XL 2014	VIN000000001083	Camionnette
2019	125175	14	97	88	Essence	Couleur 84	86602	A	13	BMW	L 2017	VIN000000001084	Camionnette
2014	81579	7	61	89	Electrique	Couleur 85	82264	A	79	Volkswagen	S 2016	VIN000000001085	Camionnette
2017	15302	11	102	90	Diesel	Couleur 86	82770	A	56	Toyota	XL 2015	VIN000000001086	4x4
2013	168987	11	84	91	Diesel	Couleur 87	52512	A	65	Mercedes	Dynamic 2019	VIN000000001087	Camionnette
2021	94447	5	46	92	Hybride	Couleur 88	21460	A	83	Fiat	Sport 2022	VIN000000001088	Camionnette
2017	25882	4	92	93	Essence	Couleur 89	49676	A	39	BMW	Active 2018	VIN000000001089	4x4
2015	44013	8	4	94	Electrique	Couleur 90	50334	A	88	Fiat	Comfort 2021	VIN000000001090	4x4
2014	159912	5	66	95	Hybride	Couleur 91	58899	A	50	Renault	Business 2010	VIN000000001091	Tourisme
2013	176035	14	79	96	Electrique	Couleur 92	63063	A	74	Peugeot	Business 2012	VIN000000001092	Utilitaire
2018	142415	5	12	97	Electrique	Couleur 93	01862	A	48	Hyundai	Business 2021	VIN000000001093	Utilitaire
2019	173865	4	23	98	Hybride	Couleur 94	45852	A	15	Fiat	S 2010	VIN000000001094	4x4
2023	93992	11	78	99	Diesel	Couleur 95	95868	A	44	Fiat	Comfort 2011	VIN000000001095	4x4
2017	64891	4	11	100	Hybride	Couleur 96	37115	A	66	BMW	Dynamic 2020	VIN000000001096	Tourisme
2023	11880	12	103	101	Hybride	Couleur 97	60744	A	10	Peugeot	Sport 2013	VIN000000001097	Tourisme
2021	12279	15	30	102	Hybride	Couleur 98	63505	A	11	Volkswagen	Dynamic 2022	VIN000000001098	Camionnette
2021	122568	5	44	103	Essence	Couleur 99	47631	A	33	Fiat	Active 2015	VIN000000001099	4x4
2017	204801	14	31	104	Essence	Couleur 100	71568	A	1	BMW	S 2022	VIN000000001100	Utilitaire
2025	0	8	104	105	Diesel	N/A	66762	D	8	BMW	X5	9	4x4
2025	0	7	106	106	Diesel	N/A	99901	D	9	RENEAULT	HUNDAI	B	Tourisme
2020	45000	6	1	2	Essence	Gris	56789	B	6	DAIHATY	YRV	VF3PEUGEOT98765	Tourisme
2025	0	7	108	107	Hybride	N/A	88666	Y	6	DACIA	LOGAN	2	Tourisme
2025	0	7	108	108	Diesel	N/A	67700	B	1	DACIA	DUSTER	8	Tourisme
\.


--
-- Data for Name: visite_technique; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visite_technique (airbags, bruit_moteur, ceintures, chassis, clignotants, date_limite_contre_visite, date_validite, date_visite, direction, essuie_glaces, feux_arriere, feux_position, feux_stop, freinage, fuite_huile, kilometrage, montant_paye, pare_brise, phares_avant, pneus, pot_echappement, retroviseurs, suspension, id, vehicule_id, centre_visite, controleur, description_panne, heure_visite, mode_paiement, niveau_emission, numero_recu, numero_visite, observations_generales, piece_manquante, pieceareparer, resultat_final, statut_paiement, temps_reparation, type_visite, ville) FROM stdin;
f	f	t	t	t	2024-03-10	\N	2024-02-10	t	t	f	t	t	f	t	205000	400	t	t	f	f	t	t	2	3	Centre Auto Rabat	Youssef Fassi	\N	14:00	Carte Bancaire	Opacité: 1.5	REC-002	V-2024-002	Défauts majeurs constatés sur le système de freinage et les pneumatiques.	\N	\N	NON_REPARE	PAYE	\N	Périodique	Rabat
t	f	t	t	t	\N	2025-02-10	2024-02-25	t	t	t	t	t	t	f	205500	100	t	t	t	t	t	t	3	3	Centre Auto Rabat	Youssef Fassi	\N	10:00	Espèces	Opacité: 0.8	REC-003	V-2024-003	Défauts corrigés. Véhicule conforme.	\N	\N	REPARE	PAYE	\N	Contre-visite	Rabat
\N	\N	\N	t	\N	\N	\N	2025-07-10	f	\N	\N	\N	\N	f	\N	135768	353	\N	\N	f	\N	\N	t	4	27	Centre Auto Meknes	Expert 1	\N	09:44	\N	\N	\N	V-2024-0001	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Agadir
\N	\N	\N	t	\N	\N	\N	2025-09-28	f	\N	\N	\N	\N	t	\N	148961	292	\N	\N	t	\N	\N	t	5	5	Centre Auto Oujda	Expert 2	\N	10:24	\N	\N	\N	V-2024-0002	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Meknes
\N	\N	\N	t	\N	\N	\N	2025-07-24	t	\N	\N	\N	\N	t	\N	134815	359	\N	\N	f	\N	\N	t	6	74	Centre Auto Casablanca	Expert 3	\N	10:58	\N	\N	\N	V-2024-0003	\N	\N	\N	APTE	PAYE	\N	Périodique	Tetouan
\N	\N	\N	t	\N	\N	\N	2025-08-26	f	\N	\N	\N	\N	f	\N	88857	376	\N	\N	t	\N	\N	t	7	61	Centre Auto Marrakech	Expert 4	\N	16:00	\N	\N	\N	V-2024-0004	\N	\N	\N	APTE	PAYE	\N	Périodique	Tetouan
\N	\N	\N	t	\N	\N	\N	2025-09-23	f	\N	\N	\N	\N	f	\N	25952	433	\N	\N	f	\N	\N	t	8	58	Centre Auto Meknes	Expert 5	\N	10:07	\N	\N	\N	V-2024-0005	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Tangier
\N	\N	\N	t	\N	\N	\N	2024-12-21	t	\N	\N	\N	\N	f	\N	91345	438	\N	\N	f	\N	\N	f	9	53	Centre Auto Rabat	Expert 6	\N	15:56	\N	\N	\N	V-2024-0006	\N	\N	\N	APTE	PAYE	\N	Périodique	Fes
\N	\N	\N	t	\N	\N	\N	2024-12-27	t	\N	\N	\N	\N	t	\N	145807	296	\N	\N	t	\N	\N	t	10	27	Centre Auto Tangier	Expert 7	\N	13:26	\N	\N	\N	V-2024-0007	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Meknes
\N	\N	\N	t	\N	\N	\N	2025-06-27	f	\N	\N	\N	\N	t	\N	62239	448	\N	\N	t	\N	\N	t	11	37	Centre Auto Fes	Expert 8	\N	10:03	\N	\N	\N	V-2024-0008	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-07-14	f	\N	\N	\N	\N	f	\N	65566	284	\N	\N	f	\N	\N	f	12	14	Centre Auto Marrakech	Expert 9	\N	11:33	\N	\N	\N	V-2024-0009	\N	\N	\N	APTE	PAYE	\N	Périodique	Kenitra
\N	\N	\N	t	\N	\N	\N	2025-09-21	f	\N	\N	\N	\N	t	\N	76235	308	\N	\N	t	\N	\N	f	13	101	Centre Auto Marrakech	Expert 10	\N	13:50	\N	\N	\N	V-2024-0010	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Kenitra
\N	\N	\N	t	\N	\N	\N	2025-08-11	f	\N	\N	\N	\N	t	\N	119482	292	\N	\N	f	\N	\N	f	14	59	Centre Auto Tangier	Expert 11	\N	13:11	\N	\N	\N	V-2024-0011	\N	\N	\N	APTE	PAYE	\N	Périodique	Agadir
\N	\N	\N	t	\N	\N	\N	2025-05-24	f	\N	\N	\N	\N	t	\N	40537	323	\N	\N	t	\N	\N	t	15	34	Centre Auto Oujda	Expert 12	\N	16:07	\N	\N	\N	V-2024-0012	\N	\N	\N	APTE	PAYE	\N	Périodique	Agadir
\N	\N	\N	t	\N	\N	\N	2025-11-02	f	\N	\N	\N	\N	f	\N	111594	394	\N	\N	f	\N	\N	f	16	68	Centre Auto Casablanca	Expert 13	\N	08:59	\N	\N	\N	V-2024-0013	\N	\N	\N	APTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-04-07	f	\N	\N	\N	\N	t	\N	12606	399	\N	\N	t	\N	\N	f	17	13	Centre Auto Rabat	Expert 14	\N	15:29	\N	\N	\N	V-2024-0014	\N	\N	\N	APTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-10-09	f	\N	\N	\N	\N	t	\N	114238	308	\N	\N	t	\N	\N	t	18	70	Centre Auto Marrakech	Expert 15	\N	09:35	\N	\N	\N	V-2024-0015	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-06-18	f	\N	\N	\N	\N	t	\N	69087	378	\N	\N	t	\N	\N	f	19	15	Centre Auto Tangier	Expert 16	\N	12:41	\N	\N	\N	V-2024-0016	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Meknes
\N	\N	\N	t	\N	\N	\N	2025-01-18	f	\N	\N	\N	\N	f	\N	143976	329	\N	\N	t	\N	\N	t	20	63	Centre Auto Marrakech	Expert 17	\N	11:15	\N	\N	\N	V-2024-0017	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Oujda
\N	\N	\N	t	\N	\N	\N	2025-08-24	t	\N	\N	\N	\N	t	\N	28472	275	\N	\N	t	\N	\N	t	21	11	Centre Auto Kenitra	Expert 18	\N	08:43	\N	\N	\N	V-2024-0018	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Fes
\N	\N	\N	t	\N	\N	\N	2025-11-22	t	\N	\N	\N	\N	t	\N	98587	365	\N	\N	f	\N	\N	t	22	82	Centre Auto Marrakech	Expert 19	\N	14:15	\N	\N	\N	V-2024-0019	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-03-10	t	\N	\N	\N	\N	t	\N	80363	411	\N	\N	f	\N	\N	f	23	51	Centre Auto Agadir	Expert 20	\N	16:53	\N	\N	\N	V-2024-0020	\N	\N	\N	APTE	PAYE	\N	Périodique	Fes
\N	\N	\N	t	\N	\N	\N	2025-09-21	t	\N	\N	\N	\N	t	\N	62988	323	\N	\N	f	\N	\N	f	24	9	Centre Auto Meknes	Expert 21	\N	17:35	\N	\N	\N	V-2024-0021	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-10-14	f	\N	\N	\N	\N	t	\N	142103	350	\N	\N	t	\N	\N	f	25	13	Centre Auto Agadir	Expert 22	\N	17:48	\N	\N	\N	V-2024-0022	\N	\N	\N	APTE	PAYE	\N	Périodique	Meknes
\N	\N	\N	t	\N	\N	\N	2025-08-04	f	\N	\N	\N	\N	t	\N	51254	396	\N	\N	f	\N	\N	t	26	74	Centre Auto Rabat	Expert 23	\N	13:58	\N	\N	\N	V-2024-0023	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-07-25	t	\N	\N	\N	\N	f	\N	118198	422	\N	\N	f	\N	\N	t	27	98	Centre Auto Casablanca	Expert 24	\N	12:32	\N	\N	\N	V-2024-0024	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Marrakech
\N	\N	\N	t	\N	\N	\N	2025-07-17	t	\N	\N	\N	\N	t	\N	117550	381	\N	\N	f	\N	\N	t	28	32	Centre Auto Agadir	Expert 25	\N	12:04	\N	\N	\N	V-2024-0025	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Tangier
\N	\N	\N	t	\N	\N	\N	2025-02-10	f	\N	\N	\N	\N	f	\N	114829	257	\N	\N	t	\N	\N	t	29	8	Centre Auto Casablanca	Expert 26	\N	08:13	\N	\N	\N	V-2024-0026	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-07-08	f	\N	\N	\N	\N	f	\N	57371	417	\N	\N	t	\N	\N	t	30	19	Centre Auto Tetouan	Expert 27	\N	15:07	\N	\N	\N	V-2024-0027	\N	\N	\N	APTE	PAYE	\N	Périodique	Agadir
\N	\N	\N	t	\N	\N	\N	2025-11-13	t	\N	\N	\N	\N	t	\N	80865	397	\N	\N	t	\N	\N	f	31	30	Centre Auto Kenitra	Expert 28	\N	13:24	\N	\N	\N	V-2024-0028	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Fes
\N	\N	\N	t	\N	\N	\N	2025-05-01	f	\N	\N	\N	\N	t	\N	46325	260	\N	\N	f	\N	\N	f	32	49	Centre Auto Oujda	Expert 29	\N	10:05	\N	\N	\N	V-2024-0029	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-11-11	f	\N	\N	\N	\N	t	\N	137456	359	\N	\N	t	\N	\N	f	33	86	Centre Auto Casablanca	Expert 30	\N	16:12	\N	\N	\N	V-2024-0030	\N	\N	\N	APTE	PAYE	\N	Périodique	Oujda
\N	\N	\N	t	\N	\N	\N	2025-10-21	f	\N	\N	\N	\N	t	\N	87533	270	\N	\N	t	\N	\N	t	34	66	Centre Auto Marrakech	Expert 31	\N	14:49	\N	\N	\N	V-2024-0031	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-03-18	t	\N	\N	\N	\N	t	\N	51744	280	\N	\N	f	\N	\N	t	35	34	Centre Auto Rabat	Expert 32	\N	11:03	\N	\N	\N	V-2024-0032	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Oujda
\N	\N	\N	t	\N	\N	\N	2025-03-25	f	\N	\N	\N	\N	t	\N	55634	429	\N	\N	t	\N	\N	t	36	51	Centre Auto Oujda	Expert 33	\N	16:06	\N	\N	\N	V-2024-0033	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Oujda
\N	\N	\N	t	\N	\N	\N	2024-12-22	f	\N	\N	\N	\N	t	\N	133536	266	\N	\N	f	\N	\N	t	37	40	Centre Auto Agadir	Expert 34	\N	12:29	\N	\N	\N	V-2024-0034	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Agadir
\N	\N	\N	t	\N	\N	\N	2025-10-03	f	\N	\N	\N	\N	f	\N	20540	315	\N	\N	t	\N	\N	f	38	33	Centre Auto Meknes	Expert 35	\N	13:18	\N	\N	\N	V-2024-0035	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Fes
\N	\N	\N	t	\N	\N	\N	2025-09-10	t	\N	\N	\N	\N	t	\N	95713	422	\N	\N	t	\N	\N	f	39	60	Centre Auto Casablanca	Expert 36	\N	12:07	\N	\N	\N	V-2024-0036	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Tetouan
\N	\N	\N	t	\N	\N	\N	2025-06-02	f	\N	\N	\N	\N	t	\N	116652	336	\N	\N	t	\N	\N	f	40	18	Centre Auto Agadir	Expert 37	\N	15:59	\N	\N	\N	V-2024-0037	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Agadir
\N	\N	\N	t	\N	\N	\N	2025-10-28	f	\N	\N	\N	\N	f	\N	26177	405	\N	\N	f	\N	\N	f	41	90	Centre Auto Fes	Expert 38	\N	13:53	\N	\N	\N	V-2024-0038	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Oujda
\N	\N	\N	t	\N	\N	\N	2025-03-29	t	\N	\N	\N	\N	t	\N	20900	305	\N	\N	t	\N	\N	t	42	6	Centre Auto Kenitra	Expert 39	\N	15:32	\N	\N	\N	V-2024-0039	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Meknes
\N	\N	\N	t	\N	\N	\N	2025-08-11	f	\N	\N	\N	\N	t	\N	37019	305	\N	\N	t	\N	\N	f	43	92	Centre Auto Fes	Expert 40	\N	17:05	\N	\N	\N	V-2024-0040	\N	\N	\N	APTE	PAYE	\N	Périodique	Agadir
\N	\N	\N	t	\N	\N	\N	2025-12-09	f	\N	\N	\N	\N	f	\N	86722	434	\N	\N	t	\N	\N	f	44	50	Centre Auto Tangier	Expert 41	\N	08:40	\N	\N	\N	V-2024-0041	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Tangier
\N	\N	\N	t	\N	\N	\N	2025-11-01	f	\N	\N	\N	\N	t	\N	143608	324	\N	\N	t	\N	\N	t	45	79	Centre Auto Oujda	Expert 42	\N	09:11	\N	\N	\N	V-2024-0042	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Oujda
\N	\N	\N	t	\N	\N	\N	2025-03-21	t	\N	\N	\N	\N	f	\N	18957	448	\N	\N	f	\N	\N	t	46	18	Centre Auto Casablanca	Expert 43	\N	12:43	\N	\N	\N	V-2024-0043	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Kenitra
\N	\N	\N	t	\N	\N	\N	2025-07-22	t	\N	\N	\N	\N	t	\N	76770	361	\N	\N	f	\N	\N	t	47	25	Centre Auto Casablanca	Expert 44	\N	12:48	\N	\N	\N	V-2024-0044	\N	\N	\N	APTE	PAYE	\N	Périodique	Oujda
\N	\N	\N	t	\N	\N	\N	2025-07-25	f	\N	\N	\N	\N	f	\N	96850	317	\N	\N	f	\N	\N	f	48	43	Centre Auto Tangier	Expert 45	\N	13:34	\N	\N	\N	V-2024-0045	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Tetouan
\N	\N	\N	t	\N	\N	\N	2025-10-19	t	\N	\N	\N	\N	t	\N	42451	377	\N	\N	f	\N	\N	f	49	9	Centre Auto Agadir	Expert 46	\N	13:40	\N	\N	\N	V-2024-0046	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-11-13	t	\N	\N	\N	\N	f	\N	133699	390	\N	\N	t	\N	\N	f	50	92	Centre Auto Oujda	Expert 47	\N	15:24	\N	\N	\N	V-2024-0047	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Tetouan
\N	\N	\N	t	\N	\N	\N	2025-06-16	f	\N	\N	\N	\N	t	\N	85574	432	\N	\N	f	\N	\N	f	51	87	Centre Auto Agadir	Expert 48	\N	15:13	\N	\N	\N	V-2024-0048	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-01-11	t	\N	\N	\N	\N	t	\N	155444	381	\N	\N	t	\N	\N	f	52	95	Centre Auto Meknes	Expert 49	\N	09:50	\N	\N	\N	V-2024-0049	\N	\N	\N	APTE	PAYE	\N	Périodique	Tetouan
\N	\N	\N	t	\N	\N	\N	2025-09-02	t	\N	\N	\N	\N	t	\N	93041	367	\N	\N	f	\N	\N	t	53	43	Centre Auto Tangier	Expert 50	\N	13:55	\N	\N	\N	V-2024-0050	\N	\N	\N	APTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2024-12-29	t	\N	\N	\N	\N	f	\N	136868	390	\N	\N	t	\N	\N	f	54	69	Centre Auto Rabat	Expert 51	\N	16:35	\N	\N	\N	V-2024-0051	\N	\N	\N	APTE	PAYE	\N	Périodique	Kenitra
\N	\N	\N	t	\N	\N	\N	2025-10-17	t	\N	\N	\N	\N	f	\N	51532	429	\N	\N	t	\N	\N	t	55	7	Centre Auto Oujda	Expert 52	\N	11:22	\N	\N	\N	V-2024-0052	\N	\N	\N	APTE	PAYE	\N	Périodique	Agadir
\N	\N	\N	t	\N	\N	\N	2025-06-17	f	\N	\N	\N	\N	t	\N	29011	264	\N	\N	f	\N	\N	t	56	74	Centre Auto Fes	Expert 53	\N	15:39	\N	\N	\N	V-2024-0053	\N	\N	\N	APTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-06-05	f	\N	\N	\N	\N	f	\N	89953	393	\N	\N	t	\N	\N	f	57	83	Centre Auto Rabat	Expert 54	\N	10:23	\N	\N	\N	V-2024-0054	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-09-24	f	\N	\N	\N	\N	f	\N	93744	394	\N	\N	f	\N	\N	t	58	57	Centre Auto Casablanca	Expert 55	\N	15:58	\N	\N	\N	V-2024-0055	\N	\N	\N	APTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-05-08	f	\N	\N	\N	\N	t	\N	26613	435	\N	\N	f	\N	\N	t	59	48	Centre Auto Oujda	Expert 56	\N	13:24	\N	\N	\N	V-2024-0056	\N	\N	\N	APTE	PAYE	\N	Périodique	Tetouan
\N	\N	\N	t	\N	\N	\N	2025-06-18	t	\N	\N	\N	\N	t	\N	28711	373	\N	\N	t	\N	\N	t	61	28	Centre Auto Tetouan	Expert 58	\N	16:29	\N	\N	\N	V-2024-0058	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Meknes
\N	\N	\N	t	\N	\N	\N	2025-09-26	t	\N	\N	\N	\N	f	\N	94082	421	\N	\N	f	\N	\N	t	62	32	Centre Auto Oujda	Expert 59	\N	08:02	\N	\N	\N	V-2024-0059	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Marrakech
\N	\N	\N	t	\N	\N	\N	2025-11-13	f	\N	\N	\N	\N	t	\N	57450	385	\N	\N	f	\N	\N	f	63	46	Centre Auto Tangier	Expert 60	\N	08:55	\N	\N	\N	V-2024-0060	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-07-11	t	\N	\N	\N	\N	f	\N	108644	357	\N	\N	f	\N	\N	t	64	96	Centre Auto Kenitra	Expert 61	\N	17:59	\N	\N	\N	V-2024-0061	\N	\N	\N	APTE	PAYE	\N	Périodique	Kenitra
\N	\N	\N	t	\N	\N	\N	2025-03-15	t	\N	\N	\N	\N	t	\N	22761	378	\N	\N	t	\N	\N	f	65	55	Centre Auto Tangier	Expert 62	\N	14:34	\N	\N	\N	V-2024-0062	\N	\N	\N	APTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-09-04	t	\N	\N	\N	\N	t	\N	9433	257	\N	\N	f	\N	\N	t	66	66	Centre Auto Tetouan	Expert 63	\N	15:38	\N	\N	\N	V-2024-0063	\N	\N	\N	APTE	PAYE	\N	Périodique	Kenitra
\N	\N	\N	t	\N	\N	\N	2025-04-15	t	\N	\N	\N	\N	t	\N	23849	381	\N	\N	t	\N	\N	f	67	37	Centre Auto Rabat	Expert 64	\N	12:45	\N	\N	\N	V-2024-0064	\N	\N	\N	APTE	PAYE	\N	Périodique	Tangier
\N	\N	\N	t	\N	\N	\N	2025-06-24	f	\N	\N	\N	\N	f	\N	41162	449	\N	\N	f	\N	\N	t	68	64	Centre Auto Oujda	Expert 65	\N	11:07	\N	\N	\N	V-2024-0065	\N	\N	\N	APTE	PAYE	\N	Périodique	Tangier
\N	\N	\N	t	\N	\N	\N	2025-11-19	f	\N	\N	\N	\N	t	\N	69176	258	\N	\N	f	\N	\N	t	69	9	Centre Auto Tetouan	Expert 66	\N	08:13	\N	\N	\N	V-2024-0066	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Meknes
\N	\N	\N	t	\N	\N	\N	2025-10-28	t	\N	\N	\N	\N	t	\N	75986	305	\N	\N	t	\N	\N	t	70	45	Centre Auto Casablanca	Expert 67	\N	12:19	\N	\N	\N	V-2024-0067	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Fes
\N	\N	\N	t	\N	\N	\N	2025-10-21	t	\N	\N	\N	\N	f	\N	136377	379	\N	\N	t	\N	\N	f	71	48	Centre Auto Agadir	Expert 68	\N	15:38	\N	\N	\N	V-2024-0068	\N	\N	\N	APTE	PAYE	\N	Périodique	Tetouan
\N	\N	\N	t	\N	\N	\N	2025-01-28	t	\N	\N	\N	\N	f	\N	44502	284	\N	\N	t	\N	\N	t	72	85	Centre Auto Oujda	Expert 69	\N	16:40	\N	\N	\N	V-2024-0069	\N	\N	\N	APTE	PAYE	\N	Périodique	Tetouan
\N	\N	\N	t	\N	\N	\N	2025-06-21	f	\N	\N	\N	\N	f	\N	66746	377	\N	\N	t	\N	\N	t	73	46	Centre Auto Agadir	Expert 70	\N	08:14	\N	\N	\N	V-2024-0070	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-04-26	t	\N	\N	\N	\N	f	\N	85013	283	\N	\N	t	\N	\N	t	74	53	Centre Auto Casablanca	Expert 71	\N	12:26	\N	\N	\N	V-2024-0071	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-02-13	f	\N	\N	\N	\N	f	\N	91018	294	\N	\N	f	\N	\N	t	75	45	Centre Auto Agadir	Expert 72	\N	17:19	\N	\N	\N	V-2024-0072	\N	\N	\N	APTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-09-17	t	\N	\N	\N	\N	t	\N	15773	304	\N	\N	f	\N	\N	t	76	64	Centre Auto Rabat	Expert 73	\N	12:49	\N	\N	\N	V-2024-0073	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Tangier
\N	\N	\N	t	\N	\N	\N	2025-08-09	t	\N	\N	\N	\N	f	\N	113812	419	\N	\N	f	\N	\N	t	77	33	Centre Auto Kenitra	Expert 74	\N	17:23	\N	\N	\N	V-2024-0074	\N	\N	\N	APTE	PAYE	\N	Périodique	Fes
\N	\N	\N	t	\N	\N	\N	2025-10-14	f	\N	\N	\N	\N	t	\N	114216	441	\N	\N	f	\N	\N	t	79	83	Centre Auto Casablanca	Expert 76	\N	12:41	\N	\N	\N	V-2024-0076	\N	\N	\N	APTE	PAYE	\N	Périodique	Agadir
\N	\N	\N	t	\N	\N	\N	2025-08-23	t	\N	\N	\N	\N	f	\N	150033	301	\N	\N	f	\N	\N	f	80	6	Centre Auto Tangier	Expert 77	\N	16:05	\N	\N	\N	V-2024-0077	\N	\N	\N	APTE	PAYE	\N	Périodique	Marrakech
\N	\N	\N	t	\N	\N	\N	2025-04-04	t	\N	\N	\N	\N	f	\N	83013	411	\N	\N	t	\N	\N	f	81	13	Centre Auto Marrakech	Expert 78	\N	09:17	\N	\N	\N	V-2024-0078	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2025-08-02	f	\N	\N	\N	\N	t	\N	54439	419	\N	\N	f	\N	\N	f	82	51	Centre Auto Meknes	Expert 79	\N	08:06	\N	\N	\N	V-2024-0079	\N	\N	\N	APTE	PAYE	\N	Périodique	Fes
\N	\N	\N	t	\N	\N	\N	2025-03-22	t	\N	\N	\N	\N	f	\N	86526	312	\N	\N	f	\N	\N	f	83	34	Centre Auto Rabat	Expert 80	\N	17:26	\N	\N	\N	V-2024-0080	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Oujda
\N	\N	\N	t	\N	\N	\N	2025-02-27	f	\N	\N	\N	\N	t	\N	69136	354	\N	\N	f	\N	\N	t	84	93	Centre Auto Kenitra	Expert 81	\N	10:03	\N	\N	\N	V-2024-0081	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-10-22	f	\N	\N	\N	\N	t	\N	69518	336	\N	\N	t	\N	\N	f	85	75	Centre Auto Kenitra	Expert 82	\N	13:36	\N	\N	\N	V-2024-0082	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Meknes
\N	\N	\N	t	\N	\N	\N	2025-12-15	t	\N	\N	\N	\N	t	\N	27432	384	\N	\N	t	\N	\N	f	87	94	Centre Auto Oujda	Expert 84	\N	11:12	\N	\N	\N	V-2024-0084	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Kenitra
\N	\N	\N	t	\N	\N	\N	2025-03-03	t	\N	\N	\N	\N	t	\N	82009	405	\N	\N	t	\N	\N	f	88	72	Centre Auto Kenitra	Expert 85	\N	13:28	\N	\N	\N	V-2024-0085	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Marrakech
\N	\N	\N	t	\N	\N	\N	2025-01-22	t	\N	\N	\N	\N	f	\N	42349	338	\N	\N	f	\N	\N	t	89	26	Centre Auto Meknes	Expert 86	\N	16:43	\N	\N	\N	V-2024-0086	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Rabat
\N	\N	\N	t	\N	\N	\N	2024-12-21	f	\N	\N	\N	\N	t	\N	42714	323	\N	\N	t	\N	\N	t	90	9	Centre Auto Kenitra	Expert 87	\N	15:36	\N	\N	\N	V-2024-0087	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-07-18	t	\N	\N	\N	\N	t	\N	68592	302	\N	\N	t	\N	\N	f	91	61	Centre Auto Casablanca	Expert 88	\N	12:35	\N	\N	\N	V-2024-0088	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Marrakech
\N	\N	\N	t	\N	\N	\N	2025-09-30	f	\N	\N	\N	\N	t	\N	137132	339	\N	\N	t	\N	\N	t	92	9	Centre Auto Fes	Expert 89	\N	10:31	\N	\N	\N	V-2024-0089	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Agadir
\N	\N	\N	t	\N	\N	\N	2025-09-21	t	\N	\N	\N	\N	t	\N	12153	339	\N	\N	f	\N	\N	f	93	100	Centre Auto Tangier	Expert 90	\N	12:15	\N	\N	\N	V-2024-0090	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Kenitra
\N	\N	\N	t	\N	\N	\N	2025-10-24	f	\N	\N	\N	\N	f	\N	82629	398	\N	\N	f	\N	\N	t	94	17	Centre Auto Meknes	Expert 91	\N	10:35	\N	\N	\N	V-2024-0091	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Oujda
\N	\N	\N	t	\N	\N	\N	2025-08-06	f	\N	\N	\N	\N	t	\N	75163	363	\N	\N	t	\N	\N	f	95	75	Centre Auto Oujda	Expert 92	\N	08:04	\N	\N	\N	V-2024-0092	\N	\N	\N	APTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-03-24	t	\N	\N	\N	\N	f	\N	127837	309	\N	\N	t	\N	\N	f	96	84	Centre Auto Marrakech	Expert 93	\N	10:55	\N	\N	\N	V-2024-0093	\N	\N	\N	APTE	PAYE	\N	Périodique	Oujda
\N	\N	\N	t	\N	\N	\N	2025-11-17	t	\N	\N	\N	\N	t	\N	597200000	330	\N	\N	t	\N	\N	f	86	35	Centre Auto Tangier	Expert 83	\N	12:44	\N	\N	\N	V-2024-0083	\N	\N	\N	REPARE	PAYE	\N	Volontaire	Marrakech
\N	\N	\N	t	\N	\N	\N	2025-07-10	f	\N	\N	\N	\N	f	\N	105034	422	\N	\N	t	\N	\N	f	78	35	Centre Auto Tetouan	Expert 75	\N	13:50	\N	\N	\N	V-2024-0075	\N	\N	\N	NON_REPARE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-01-16	f	\N	\N	\N	\N	f	\N	137401	289	\N	\N	t	\N	\N	f	97	50	Centre Auto Rabat	Expert 94	\N	15:58	\N	\N	\N	V-2024-0094	\N	\N	\N	APTE	PAYE	\N	Périodique	Tetouan
\N	\N	\N	t	\N	\N	\N	2024-12-23	t	\N	\N	\N	\N	t	\N	95653	281	\N	\N	t	\N	\N	f	98	92	Centre Auto Oujda	Expert 95	\N	10:23	\N	\N	\N	V-2024-0095	\N	\N	\N	APTE	PAYE	\N	Périodique	Oujda
\N	\N	\N	t	\N	\N	\N	2025-08-12	t	\N	\N	\N	\N	f	\N	66556	389	\N	\N	f	\N	\N	t	99	30	Centre Auto Oujda	Expert 96	\N	09:22	\N	\N	\N	V-2024-0096	\N	\N	\N	APTE	PAYE	\N	Périodique	Tetouan
\N	\N	\N	t	\N	\N	\N	2025-05-20	f	\N	\N	\N	\N	f	\N	132691	449	\N	\N	f	\N	\N	t	100	65	Centre Auto Rabat	Expert 97	\N	12:37	\N	\N	\N	V-2024-0097	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Casablanca
\N	\N	\N	t	\N	\N	\N	2025-09-11	f	\N	\N	\N	\N	f	\N	65182	272	\N	\N	t	\N	\N	t	101	8	Centre Auto Agadir	Expert 98	\N	13:00	\N	\N	\N	V-2024-0098	\N	\N	\N	APTE	PAYE	\N	Périodique	Agadir
\N	\N	\N	t	\N	\N	\N	2025-08-04	f	\N	\N	\N	\N	f	\N	50517	261	\N	\N	f	\N	\N	t	102	82	Centre Auto Tangier	Expert 99	\N	16:08	\N	\N	\N	V-2024-0099	\N	\N	\N	INAPTE	PAYE	\N	Périodique	Tangier
\N	\N	\N	t	\N	\N	\N	2025-04-03	t	\N	\N	\N	\N	f	\N	135798	369	\N	\N	f	\N	\N	f	103	38	Centre Auto Rabat	Expert 100	\N	10:37	\N	\N	\N	V-2024-0100	\N	\N	\N	APTE	PAYE	\N	Périodique	Tangier
t	\N	t	t	t	\N	\N	2025-12-18	t	t	t	t	t	t	\N	7	99999	t	t	t	\N	t	t	104	105	\N	\N	eoor frein visite	\N	\N	\N	\N	\N	\N	huile	frein 	NON_REPARE	EN_ATTENTE	2h	Contre-visite	\N
t	\N	t	t	t	\N	\N	2025-12-18	t	t	t	t	t	t	\N	188888	3000	t	t	t	\N	t	t	105	3	\N	\N	xxxx	\N	\N	\N	\N	\N	\N	xxxx	xxxxxx	NON_REPARE	EN_ATTENTE	xxxxx	Contre-visite	\N
t	\N	t	t	t	\N	\N	2025-12-18	t	t	t	t	t	t	\N	111222	222	t	t	t	\N	t	t	106	106	\N	\N	222	\N	\N	\N	\N	\N	\N	222	222	REPARE	EN_ATTENTE	2h	Contre-visite	\N
t	\N	t	t	t	\N	\N	2025-12-18	t	t	t	t	t	t	\N	5	12	t	t	t	\N	t	t	107	2	\N	\N	cxcxcxc	\N	\N	\N	\N	\N	\N	cxcxcx	xxxxxvvv	REPARE	EN_ATTENTE	xcxcxc	Contre-visite	\N
\.


--
-- Name: client_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.client_id_seq', 108, true);


--
-- Name: defaut_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.defaut_id_seq', 3, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: fiche_technique_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fiche_technique_id_seq', 53, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 6, true);


--
-- Name: reparation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reparation_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: vehicule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vehicule_id_seq', 108, true);


--
-- Name: visite_technique_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visite_technique_id_seq', 109, true);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id);


--
-- Name: defaut defaut_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.defaut
    ADD CONSTRAINT defaut_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: fiche_technique fiche_technique_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fiche_technique
    ADD CONSTRAINT fiche_technique_pkey PRIMARY KEY (id);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: reparation reparation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reparation
    ADD CONSTRAINT reparation_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vehicule vehicule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicule
    ADD CONSTRAINT vehicule_pkey PRIMARY KEY (id);


--
-- Name: visite_technique visite_technique_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visite_technique
    ADD CONSTRAINT visite_technique_pkey PRIMARY KEY (id);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: fiche_pannes fk4w8buopaf2vc7phndl3nnuebb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fiche_pannes
    ADD CONSTRAINT fk4w8buopaf2vc7phndl3nnuebb FOREIGN KEY (fiche_id) REFERENCES public.fiche_technique(id);


--
-- Name: fiche_pieces_changees fk8c2a4w8abfqfnwyjmftfto5on; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fiche_pieces_changees
    ADD CONSTRAINT fk8c2a4w8abfqfnwyjmftfto5on FOREIGN KEY (fiche_id) REFERENCES public.fiche_technique(id);


--
-- Name: fiche_technique fkjjemoln4r319pp3ts4pc77vrl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fiche_technique
    ADD CONSTRAINT fkjjemoln4r319pp3ts4pc77vrl FOREIGN KEY (vehicule_id) REFERENCES public.vehicule(id);


--
-- Name: vehicule fklyxwvj30a3fghjif06drel91q; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicule
    ADD CONSTRAINT fklyxwvj30a3fghjif06drel91q FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: visite_technique fkr6ce1pbnfq4ge7wpe9y00ba9i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visite_technique
    ADD CONSTRAINT fkr6ce1pbnfq4ge7wpe9y00ba9i FOREIGN KEY (vehicule_id) REFERENCES public.vehicule(id);


--
-- Name: defaut fks0d7ysj2vk3e8f93edyi4g2fo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.defaut
    ADD CONSTRAINT fks0d7ysj2vk3e8f93edyi4g2fo FOREIGN KEY (visite_id) REFERENCES public.visite_technique(id);


--
-- Name: reparation fkst4lbkv60d1utdsdaqbyknm3d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reparation
    ADD CONSTRAINT fkst4lbkv60d1utdsdaqbyknm3d FOREIGN KEY (visite_id) REFERENCES public.visite_technique(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

