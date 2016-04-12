--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: feature_classes; Type: TABLE; Schema: public; Owner: grough-map; Tablespace: 
--

CREATE TABLE feature_classes (
    class_id integer NOT NULL,
    class_name character varying(100),
    class_draw_order smallint,
    class_subsurface boolean DEFAULT false NOT NULL,
    class_surface boolean DEFAULT true NOT NULL,
    class_overhead boolean DEFAULT false NOT NULL,
    class_plural_name character varying(100),
    class_radius integer DEFAULT 25,
    class_label boolean DEFAULT false NOT NULL,
    class_label_rank smallint
);


ALTER TABLE public.feature_classes OWNER TO "grough-map";

--
-- Name: feature_classes_class_id_seq; Type: SEQUENCE; Schema: public; Owner: grough-map
--

CREATE SEQUENCE feature_classes_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feature_classes_class_id_seq OWNER TO "grough-map";

--
-- Name: feature_classes_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grough-map
--

ALTER SEQUENCE feature_classes_class_id_seq OWNED BY feature_classes.class_id;


--
-- Name: class_id; Type: DEFAULT; Schema: public; Owner: grough-map
--

ALTER TABLE ONLY feature_classes ALTER COLUMN class_id SET DEFAULT nextval('feature_classes_class_id_seq'::regclass);


--
-- Data for Name: feature_classes; Type: TABLE DATA; Schema: public; Owner: grough-map
--

COPY feature_classes (class_id, class_name, class_draw_order, class_subsurface, class_surface, class_overhead, class_plural_name, class_radius, class_label, class_label_rank) FROM stdin;
16	Toilet	\N	f	t	f	Toilets	100	t	5
17	Ford	\N	f	t	f	Fords	100	t	4
7	Cattle grid	\N	f	t	f	Cattle grids	100	t	1
18	Stepping stones	\N	f	t	f	Stepping stones	100	t	4
19	Weir	\N	f	t	f	Weirs	200	t	4
20	Dam	\N	f	t	f	Dam	100	t	8
21	Lock	\N	f	t	f	Locks	100	t	5
22	Slipway	\N	f	t	f	Slipway	100	t	5
23	Jetty	\N	f	t	f	Jetties	100	t	5
24	Dock	\N	f	t	f	Docks	200	t	5
25	Sluice gate	\N	f	t	f	Sluice gates	100	t	2
28	Pond	\N	f	t	f	Ponds	100	t	3
29	Spring	\N	f	t	f	Springs	100	t	2
30	Cave	\N	f	t	f	Caves	100	t	4
33	Shaft	\N	f	t	f	Shafts	250	t	3
34	Shake hole	\N	f	t	f	Shake holes	250	t	2
44	Chimney	\N	f	t	f	Chimneys	100	t	4
5	Gate	\N	f	t	f	Gates	100	f	1
6	Stile	\N	f	t	f	Stiles	100	f	1
3	Hedge	\N	f	t	f	\N	75	f	\N
4	Overhead cables	\N	f	f	t	\N	75	f	\N
12	Pylon	\N	f	t	f	Pylons	75	f	\N
8	Earthworks	\N	f	t	f	\N	75	f	1
9	Cablecar or gondola	\N	f	f	t	\N	75	t	10
10	Ski lift	\N	f	f	t	\N	75	t	10
11	Zip line	\N	f	f	t	\N	75	t	10
26	Boat lift	\N	f	t	f	Boat lifts	75	t	7
27	Aqueduct	\N	f	t	f	Aqueduct	75	t	5
31	Well	\N	f	t	f	Wells	75	t	2
32	Fountain	\N	f	t	f	Fountains	75	t	2
35	Shelter	\N	f	t	f	Shelters	75	t	4
36	Memorial	\N	f	t	f	Memorials	75	t	4
37	Survey point	\N	f	t	f	Survey points	75	t	10
38	Flagpole	\N	f	t	f	Flagpoles	75	t	5
39	Telephone box	\N	f	t	f	Telephone boxes	75	t	5
40	Boundary stone	\N	f	t	f	Boundary stones	75	t	1
41	Dish	\N	f	t	f	Dishes	75	t	6
42	Tank	\N	f	t	f	Tanks	75	t	4
43	Silo	\N	f	t	f	Silos	75	t	4
45	Spoil	\N	f	t	f	Spoil	75	t	1
46	Lighthouse	\N	f	t	f	Lighthouses	75	t	7
47	Viaduct	\N	f	t	f	Viaducts	75	t	6
1	Fence	\N	f	t	f	\N	75	f	\N
2	Wall	\N	f	t	f	\N	75	f	\N
13	Cairn	\N	f	t	f	Cairns	100	t	3
14	Tower	\N	f	t	f	Towers	100	t	8
15	Water tower	\N	f	t	f	Water towers	100	t	8
\.


--
-- Name: feature_classes_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grough-map
--

SELECT pg_catalog.setval('feature_classes_class_id_seq', 48, true);


--
-- Name: PKEY: feature_classes::class_id; Type: CONSTRAINT; Schema: public; Owner: grough-map; Tablespace: 
--

ALTER TABLE ONLY feature_classes
    ADD CONSTRAINT "PKEY: feature_classes::class_id" PRIMARY KEY (class_id);


--
-- PostgreSQL database dump complete
--

