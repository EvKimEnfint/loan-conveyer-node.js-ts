PGDMP     1    )    	            {            deals    15.4 (Debian 15.4-1.pgdg120+1)    15.4 (Debian 15.4-1.pgdg120+1) g    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16384    deals    DATABASE     p   CREATE DATABASE deals WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE deals;
                postgres    false                        3079    16385    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            �           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2                        3079    16422 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            �           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    3            �           1247    16434    application_status_enum    TYPE     �   CREATE TYPE public.application_status_enum AS ENUM (
    'PREAPPROVAL',
    'APPROVED',
    'CC_DENIED',
    'CC_PAPROVED',
    'PREPARE_DOCUMENTS',
    'DOCUMENT_CREATED',
    'CLIENT_DENIED',
    'DOCUMENT_SIGNED',
    'CREDIT_ISSUED'
);
 *   DROP TYPE public.application_status_enum;
       public          postgres    false            �            1259    16453    application    TABLE     �  CREATE TABLE public.application (
    client_id bigint,
    credit_id bigint,
    status public.application_status_enum,
    creation_date timestamp without time zone,
    applied_offer character varying(255),
    sign_date timestamp without time zone,
    ses_code character varying(255),
    status_history jsonb,
    application_id uuid DEFAULT public.uuid_generate_v4() NOT NULL
);
    DROP TABLE public.application;
       public         heap    postgres    false    3    907            �            1259    16459    application_id_seq    SEQUENCE     {   CREATE SEQUENCE public.application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.application_id_seq;
       public          postgres    false            �            1259    16460    application_status    TABLE     �  CREATE TABLE public.application_status (
    id integer NOT NULL,
    application_status public.application_status_enum NOT NULL,
    CONSTRAINT chk_application_status CHECK ((application_status = ANY (ARRAY['PREAPPROVAL'::public.application_status_enum, 'APPROVED'::public.application_status_enum, 'CC_DENIED'::public.application_status_enum, 'CC_PAPROVED'::public.application_status_enum, 'PREPARE_DOCUMENTS'::public.application_status_enum, 'DOCUMENT_CREATED'::public.application_status_enum, 'CLIENT_DENIED'::public.application_status_enum, 'DOCUMENT_SIGNED'::public.application_status_enum, 'CREDIT_ISSUED'::public.application_status_enum])))
);
 &   DROP TABLE public.application_status;
       public         heap    postgres    false    907    907            �            1259    16464    application_status_id_seq    SEQUENCE     �   CREATE SEQUENCE public.application_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.application_status_id_seq;
       public          postgres    false    218            �           0    0    application_status_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.application_status_id_seq OWNED BY public.application_status.id;
          public          postgres    false    219            �            1259    16465    change_type    TABLE     n   CREATE TABLE public.change_type (
    id integer NOT NULL,
    change_type character varying(255) NOT NULL
);
    DROP TABLE public.change_type;
       public         heap    postgres    false            �            1259    16468    change_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.change_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.change_type_id_seq;
       public          postgres    false    220            �           0    0    change_type_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.change_type_id_seq OWNED BY public.change_type.id;
          public          postgres    false    221            �            1259    16469    client_id_seq    SEQUENCE     v   CREATE SEQUENCE public.client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.client_id_seq;
       public          postgres    false            �            1259    16470    client    TABLE     �  CREATE TABLE public.client (
    client_id integer DEFAULT nextval('public.client_id_seq'::regclass) NOT NULL,
    last_name character varying(255),
    first_name character varying(255),
    middle_name character varying(255),
    birth_date date,
    email character varying(255),
    gender_id integer,
    marital_status_id integer,
    dependent_amount integer,
    passport_id character varying(255),
    employment_id uuid,
    account character varying(255)
);
    DROP TABLE public.client;
       public         heap    postgres    false    222            �            1259    16476    credit_id_seq    SEQUENCE     v   CREATE SEQUENCE public.credit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.credit_id_seq;
       public          postgres    false            �            1259    16477    credit    TABLE     I  CREATE TABLE public.credit (
    credit_id integer DEFAULT nextval('public.credit_id_seq'::regclass) NOT NULL,
    amount numeric,
    term integer,
    monthly_payment numeric,
    rate numeric,
    psk numeric,
    payment_schedule text,
    insurance_enable boolean,
    salary_client boolean,
    credit_status_id integer
);
    DROP TABLE public.credit;
       public         heap    postgres    false    224            �            1259    16483    credit_status    TABLE     r   CREATE TABLE public.credit_status (
    id integer NOT NULL,
    credit_status character varying(255) NOT NULL
);
 !   DROP TABLE public.credit_status;
       public         heap    postgres    false            �            1259    16486    credit_status_id_seq    SEQUENCE     �   CREATE SEQUENCE public.credit_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.credit_status_id_seq;
       public          postgres    false    226            �           0    0    credit_status_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.credit_status_id_seq OWNED BY public.credit_status.id;
          public          postgres    false    227            �            1259    16487 
   employment    TABLE       CREATE TABLE public.employment (
    status_id integer,
    employer_inn character varying(255),
    salary numeric,
    position_id integer,
    work_experience_total integer,
    work_experience_current integer,
    employment_id uuid DEFAULT public.uuid_generate_v4() NOT NULL
);
    DROP TABLE public.employment;
       public         heap    postgres    false    3            �            1259    16493    employment_position    TABLE     y  CREATE TABLE public.employment_position (
    id integer NOT NULL,
    employment_position character varying(255) NOT NULL,
    CONSTRAINT check_employment_position CHECK (((employment_position)::text = ANY (ARRAY[('MID_MANAGER'::character varying)::text, ('TOP_MANAGER'::character varying)::text, ('WORKER'::character varying)::text, ('OWNER'::character varying)::text])))
);
 '   DROP TABLE public.employment_position;
       public         heap    postgres    false            �            1259    16497    employment_position_id_seq    SEQUENCE     �   CREATE SEQUENCE public.employment_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.employment_position_id_seq;
       public          postgres    false    229            �           0    0    employment_position_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.employment_position_id_seq OWNED BY public.employment_position.id;
          public          postgres    false    230            �            1259    16498    employment_status    TABLE     }  CREATE TABLE public.employment_status (
    id integer NOT NULL,
    employment_status character varying(255) NOT NULL,
    CONSTRAINT check_employment_status CHECK (((employment_status)::text = ANY (ARRAY[('UNEMPLOYED'::character varying)::text, ('SELF_EMPLOYED'::character varying)::text, ('BUSINESS_OWNER'::character varying)::text, ('EMPLOYED'::character varying)::text])))
);
 %   DROP TABLE public.employment_status;
       public         heap    postgres    false            �            1259    16502    employment_status_id_seq    SEQUENCE     �   CREATE SEQUENCE public.employment_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.employment_status_id_seq;
       public          postgres    false    231            �           0    0    employment_status_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.employment_status_id_seq OWNED BY public.employment_status.id;
          public          postgres    false    232            �            1259    16503    gender    TABLE       CREATE TABLE public.gender (
    id integer NOT NULL,
    gender character varying(255) NOT NULL,
    CONSTRAINT check_gender CHECK (((gender)::text = ANY (ARRAY[('MALE'::character varying)::text, ('FEMALE'::character varying)::text, ('NON_BINARY'::character varying)::text])))
);
    DROP TABLE public.gender;
       public         heap    postgres    false            �            1259    16507    gender_id_seq    SEQUENCE     �   CREATE SEQUENCE public.gender_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.gender_id_seq;
       public          postgres    false    233            �           0    0    gender_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.gender_id_seq OWNED BY public.gender.id;
          public          postgres    false    234            �            1259    16508    marital_status    TABLE     t   CREATE TABLE public.marital_status (
    id integer NOT NULL,
    marital_status character varying(255) NOT NULL
);
 "   DROP TABLE public.marital_status;
       public         heap    postgres    false            �            1259    16511    marital_status_id_seq    SEQUENCE     �   CREATE SEQUENCE public.marital_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.marital_status_id_seq;
       public          postgres    false    235            �           0    0    marital_status_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.marital_status_id_seq OWNED BY public.marital_status.id;
          public          postgres    false    236            �            1259    16512    passport    TABLE     �   CREATE TABLE public.passport (
    passport_id character varying NOT NULL,
    series character varying(255),
    number character varying(255),
    issue_branch character varying(255),
    issue_date date
);
    DROP TABLE public.passport;
       public         heap    postgres    false            �            1259    16517    status_history    TABLE     �   CREATE TABLE public.status_history (
    status character varying(255) NOT NULL,
    "time" timestamp without time zone NOT NULL,
    change_type_id integer,
    application_id uuid
);
 "   DROP TABLE public.status_history;
       public         heap    postgres    false            �           2604    16520    application_status id    DEFAULT     ~   ALTER TABLE ONLY public.application_status ALTER COLUMN id SET DEFAULT nextval('public.application_status_id_seq'::regclass);
 D   ALTER TABLE public.application_status ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    218            �           2604    16521    change_type id    DEFAULT     p   ALTER TABLE ONLY public.change_type ALTER COLUMN id SET DEFAULT nextval('public.change_type_id_seq'::regclass);
 =   ALTER TABLE public.change_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    220            �           2604    16522    credit_status id    DEFAULT     t   ALTER TABLE ONLY public.credit_status ALTER COLUMN id SET DEFAULT nextval('public.credit_status_id_seq'::regclass);
 ?   ALTER TABLE public.credit_status ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226            �           2604    16523    employment_position id    DEFAULT     �   ALTER TABLE ONLY public.employment_position ALTER COLUMN id SET DEFAULT nextval('public.employment_position_id_seq'::regclass);
 E   ALTER TABLE public.employment_position ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    230    229            �           2604    16524    employment_status id    DEFAULT     |   ALTER TABLE ONLY public.employment_status ALTER COLUMN id SET DEFAULT nextval('public.employment_status_id_seq'::regclass);
 C   ALTER TABLE public.employment_status ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    231            �           2604    16525 	   gender id    DEFAULT     f   ALTER TABLE ONLY public.gender ALTER COLUMN id SET DEFAULT nextval('public.gender_id_seq'::regclass);
 8   ALTER TABLE public.gender ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    233            �           2604    16526    marital_status id    DEFAULT     v   ALTER TABLE ONLY public.marital_status ALTER COLUMN id SET DEFAULT nextval('public.marital_status_id_seq'::regclass);
 @   ALTER TABLE public.marital_status ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            �          0    16453    application 
   TABLE DATA           �   COPY public.application (client_id, credit_id, status, creation_date, applied_offer, sign_date, ses_code, status_history, application_id) FROM stdin;
    public          postgres    false    216   �       �          0    16460    application_status 
   TABLE DATA           D   COPY public.application_status (id, application_status) FROM stdin;
    public          postgres    false    218   g�       �          0    16465    change_type 
   TABLE DATA           6   COPY public.change_type (id, change_type) FROM stdin;
    public          postgres    false    220   �       �          0    16470    client 
   TABLE DATA           �   COPY public.client (client_id, last_name, first_name, middle_name, birth_date, email, gender_id, marital_status_id, dependent_amount, passport_id, employment_id, account) FROM stdin;
    public          postgres    false    223   �       �          0    16477    credit 
   TABLE DATA           �   COPY public.credit (credit_id, amount, term, monthly_payment, rate, psk, payment_schedule, insurance_enable, salary_client, credit_status_id) FROM stdin;
    public          postgres    false    225   ��       �          0    16483    credit_status 
   TABLE DATA           :   COPY public.credit_status (id, credit_status) FROM stdin;
    public          postgres    false    226   ��       �          0    16487 
   employment 
   TABLE DATA           �   COPY public.employment (status_id, employer_inn, salary, position_id, work_experience_total, work_experience_current, employment_id) FROM stdin;
    public          postgres    false    228   ��       �          0    16493    employment_position 
   TABLE DATA           F   COPY public.employment_position (id, employment_position) FROM stdin;
    public          postgres    false    229   ��       �          0    16498    employment_status 
   TABLE DATA           B   COPY public.employment_status (id, employment_status) FROM stdin;
    public          postgres    false    231   ޑ       �          0    16503    gender 
   TABLE DATA           ,   COPY public.gender (id, gender) FROM stdin;
    public          postgres    false    233   %�       �          0    16508    marital_status 
   TABLE DATA           <   COPY public.marital_status (id, marital_status) FROM stdin;
    public          postgres    false    235   [�       �          0    16512    passport 
   TABLE DATA           Y   COPY public.passport (passport_id, series, number, issue_branch, issue_date) FROM stdin;
    public          postgres    false    237   ��       �          0    16517    status_history 
   TABLE DATA           X   COPY public.status_history (status, "time", change_type_id, application_id) FROM stdin;
    public          postgres    false    238   ٓ       �           0    0    application_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.application_id_seq', 68, true);
          public          postgres    false    217            �           0    0    application_status_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.application_status_id_seq', 9, true);
          public          postgres    false    219            �           0    0    change_type_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.change_type_id_seq', 2, true);
          public          postgres    false    221            �           0    0    client_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.client_id_seq', 154, true);
          public          postgres    false    222            �           0    0    credit_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.credit_id_seq', 164, true);
          public          postgres    false    224            �           0    0    credit_status_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.credit_status_id_seq', 2, true);
          public          postgres    false    227            �           0    0    employment_position_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.employment_position_id_seq', 4, true);
          public          postgres    false    230            �           0    0    employment_status_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.employment_status_id_seq', 5, true);
          public          postgres    false    232            �           0    0    gender_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.gender_id_seq', 4, true);
          public          postgres    false    234            �           0    0    marital_status_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.marital_status_id_seq', 4, true);
          public          postgres    false    236            �           2606    16528    application application_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_pkey PRIMARY KEY (application_id);
 F   ALTER TABLE ONLY public.application DROP CONSTRAINT application_pkey;
       public            postgres    false    216            �           2606    16530 *   application_status application_status_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.application_status
    ADD CONSTRAINT application_status_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.application_status DROP CONSTRAINT application_status_pkey;
       public            postgres    false    218                       2606    16532    change_type change_type_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.change_type
    ADD CONSTRAINT change_type_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.change_type DROP CONSTRAINT change_type_pkey;
       public            postgres    false    220                       2606    16534    client client_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (client_id);
 <   ALTER TABLE ONLY public.client DROP CONSTRAINT client_pkey;
       public            postgres    false    223                       2606    16536    credit credit_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.credit
    ADD CONSTRAINT credit_pkey PRIMARY KEY (credit_id);
 <   ALTER TABLE ONLY public.credit DROP CONSTRAINT credit_pkey;
       public            postgres    false    225                       2606    16538     credit_status credit_status_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.credit_status
    ADD CONSTRAINT credit_status_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.credit_status DROP CONSTRAINT credit_status_pkey;
       public            postgres    false    226                       2606    16540    employment employment_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.employment
    ADD CONSTRAINT employment_pkey PRIMARY KEY (employment_id);
 D   ALTER TABLE ONLY public.employment DROP CONSTRAINT employment_pkey;
       public            postgres    false    228                       2606    16542 ,   employment_position employment_position_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.employment_position
    ADD CONSTRAINT employment_position_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.employment_position DROP CONSTRAINT employment_position_pkey;
       public            postgres    false    229                       2606    16544 (   employment_status employment_status_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.employment_status
    ADD CONSTRAINT employment_status_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.employment_status DROP CONSTRAINT employment_status_pkey;
       public            postgres    false    231                       2606    16546    gender gender_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.gender
    ADD CONSTRAINT gender_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.gender DROP CONSTRAINT gender_pkey;
       public            postgres    false    233                       2606    16548    gender gender_unique 
   CONSTRAINT     Q   ALTER TABLE ONLY public.gender
    ADD CONSTRAINT gender_unique UNIQUE (gender);
 >   ALTER TABLE ONLY public.gender DROP CONSTRAINT gender_unique;
       public            postgres    false    233                       2606    16550 "   marital_status marital_status_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.marital_status
    ADD CONSTRAINT marital_status_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.marital_status DROP CONSTRAINT marital_status_pkey;
       public            postgres    false    235                       2606    16552 $   marital_status marital_status_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.marital_status
    ADD CONSTRAINT marital_status_unique UNIQUE (marital_status);
 N   ALTER TABLE ONLY public.marital_status DROP CONSTRAINT marital_status_unique;
       public            postgres    false    235                       2606    16554    client passport_id_unique 
   CONSTRAINT     [   ALTER TABLE ONLY public.client
    ADD CONSTRAINT passport_id_unique UNIQUE (passport_id);
 C   ALTER TABLE ONLY public.client DROP CONSTRAINT passport_id_unique;
       public            postgres    false    223                        2606    16556    passport passport_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.passport
    ADD CONSTRAINT passport_pkey PRIMARY KEY (passport_id);
 @   ALTER TABLE ONLY public.passport DROP CONSTRAINT passport_pkey;
       public            postgres    false    237            "           2606    16558 "   status_history status_history_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.status_history
    ADD CONSTRAINT status_history_pkey PRIMARY KEY (status, "time");
 L   ALTER TABLE ONLY public.status_history DROP CONSTRAINT status_history_pkey;
       public            postgres    false    238    238            �           2606    16560 (   application unique_application_credit_id 
   CONSTRAINT     h   ALTER TABLE ONLY public.application
    ADD CONSTRAINT unique_application_credit_id UNIQUE (credit_id);
 R   ALTER TABLE ONLY public.application DROP CONSTRAINT unique_application_credit_id;
       public            postgres    false    216                       2606    16562 ,   application_status unique_application_status 
   CONSTRAINT     u   ALTER TABLE ONLY public.application_status
    ADD CONSTRAINT unique_application_status UNIQUE (application_status);
 V   ALTER TABLE ONLY public.application_status DROP CONSTRAINT unique_application_status;
       public            postgres    false    218                       2606    16564    credit unique_credit_id 
   CONSTRAINT     W   ALTER TABLE ONLY public.credit
    ADD CONSTRAINT unique_credit_id UNIQUE (credit_id);
 A   ALTER TABLE ONLY public.credit DROP CONSTRAINT unique_credit_id;
       public            postgres    false    225            	           2606    16566    client unique_employment_id 
   CONSTRAINT     _   ALTER TABLE ONLY public.client
    ADD CONSTRAINT unique_employment_id UNIQUE (employment_id);
 E   ALTER TABLE ONLY public.client DROP CONSTRAINT unique_employment_id;
       public            postgres    false    223                       1259    16567    unique_employment_status    INDEX     j   CREATE UNIQUE INDEX unique_employment_status ON public.employment_status USING btree (employment_status);
 ,   DROP INDEX public.unique_employment_status;
       public            postgres    false    231            #           2606    16568 &   application application_client_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.client(client_id);
 P   ALTER TABLE ONLY public.application DROP CONSTRAINT application_client_id_fkey;
       public          postgres    false    216    223    3333            $           2606    16573 &   application application_credit_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_credit_id_fkey FOREIGN KEY (credit_id) REFERENCES public.credit(credit_id);
 P   ALTER TABLE ONLY public.application DROP CONSTRAINT application_credit_id_fkey;
       public          postgres    false    225    216    3339            &           2606    16578     client client_employment_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_employment_id_fkey FOREIGN KEY (employment_id) REFERENCES public.employment(employment_id);
 J   ALTER TABLE ONLY public.client DROP CONSTRAINT client_employment_id_fkey;
       public          postgres    false    223    3345    228            '           2606    16583    client client_gender_id_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_gender_id_fkey FOREIGN KEY (gender_id) REFERENCES public.gender(id);
 F   ALTER TABLE ONLY public.client DROP CONSTRAINT client_gender_id_fkey;
       public          postgres    false    3352    233    223            (           2606    16588 $   client client_marital_status_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_marital_status_id_fkey FOREIGN KEY (marital_status_id) REFERENCES public.marital_status(id);
 N   ALTER TABLE ONLY public.client DROP CONSTRAINT client_marital_status_id_fkey;
       public          postgres    false    223    235    3356            )           2606    16593    client client_passport_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_passport_id_fkey FOREIGN KEY (passport_id) REFERENCES public.passport(passport_id);
 H   ALTER TABLE ONLY public.client DROP CONSTRAINT client_passport_id_fkey;
       public          postgres    false    223    237    3360            *           2606    16598 #   credit credit_credit_status_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.credit
    ADD CONSTRAINT credit_credit_status_id_fkey FOREIGN KEY (credit_status_id) REFERENCES public.credit_status(id);
 M   ALTER TABLE ONLY public.credit DROP CONSTRAINT credit_credit_status_id_fkey;
       public          postgres    false    225    226    3343            +           2606    16603 &   employment employment_position_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.employment
    ADD CONSTRAINT employment_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.employment_position(id);
 P   ALTER TABLE ONLY public.employment DROP CONSTRAINT employment_position_id_fkey;
       public          postgres    false    228    3347    229            ,           2606    16608 $   employment employment_status_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.employment
    ADD CONSTRAINT employment_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.employment_status(id);
 N   ALTER TABLE ONLY public.employment DROP CONSTRAINT employment_status_id_fkey;
       public          postgres    false    228    231    3349            %           2606    16613 -   application fk_application_application_status    FK CONSTRAINT     �   ALTER TABLE ONLY public.application
    ADD CONSTRAINT fk_application_application_status FOREIGN KEY (status) REFERENCES public.application_status(application_status);
 W   ALTER TABLE ONLY public.application DROP CONSTRAINT fk_application_application_status;
       public          postgres    false    216    218    3329            -           2606    16618 ,   status_history fk_status_history_change_type    FK CONSTRAINT     �   ALTER TABLE ONLY public.status_history
    ADD CONSTRAINT fk_status_history_change_type FOREIGN KEY (change_type_id) REFERENCES public.change_type(id);
 V   ALTER TABLE ONLY public.status_history DROP CONSTRAINT fk_status_history_change_type;
       public          postgres    false    238    220    3331            .           2606    16623 1   status_history status_history_application_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.status_history
    ADD CONSTRAINT status_history_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.application(application_id);
 [   ALTER TABLE ONLY public.status_history DROP CONSTRAINT status_history_application_id_fkey;
       public          postgres    false    3323    216    238            /           2606    16628 1   status_history status_history_change_type_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.status_history
    ADD CONSTRAINT status_history_change_type_id_fkey FOREIGN KEY (change_type_id) REFERENCES public.change_type(id);
 [   ALTER TABLE ONLY public.status_history DROP CONSTRAINT status_history_change_type_id_fkey;
       public          postgres    false    3331    220    238            �   k  x�͗KoI��ç@s�[�]��H�C6��n"�g�g������ݷbo �&�9!14=?������������dx}}s���C��&�/e ���n{y[ ��T5�UN2��F���z��ll��!����*k��Xa�e&QG�j����"��g���x:�����M��x��>�����ż���a5��+['���V0,!1g�*	)
�* ����6m�T��U�)�5ț�&.^֞�zI�� _>��ϋ����L�;�%\lRt=�LW��:��4Y�b�Ȭf�M�/�q�O��|ww����9��@9�"��K�̗������� �ğ���o��l7��}R&�v��W�����������C�u����vƄ Pqe�g�fW��t��P�M�XE �K,�iϭ��b�Z$k�{����NSFX�����=�ײkk��HNk�bQ�u�� �o�cw�A؎����zr�Xj�*˵����z��@��d��&R?�*�ht?�\N�>	})�� <�^�T�%]���r�(-��&��*�tUe҈l|5���\��������~"�sxBZ��^�e�R��A"���f(��Fj�ў�V}JZ��Ҫ��JY[�dP��47�gV���S�*a�F�:��l�2H��y���Ǿ8u�=��;�yNn���jHf�&���9���t0�Rձ��ؖ�7���Ryք��/����W*d�R4%tY! ۱��_��O�91�"�_�%�9&�Q�:���Bt��c�'z>p���Ҋ�{%�зv��\:���ǩ�l��>�|3�{&m��a]kj������u��AH���ڟ�Xo���Z}N��>�^��/5��      �   m   x�E�K
�0D��a
I��YYA��
����L\��y��4�S���6��z�'���g��z��D]��*;����\���io�M����dF0�K��R�~=��$�      �   "   x�3�t��u�t�2��u�u������ Rz�      �   �  x�����1�k�]&�=3�����Dw�ג��C:%y z*��::	��g�{#�.w	B�c��;�~��?�5D�٢���\���ˉ2!hЦM��q�ϯ�@��O��+u�����1�ݾ02�O��c�{
,��|X8���a�·�c���6�
���`2(,�ծ@�!p(�C��+�W���F��a3|�7�/�������FW��t5��`/���bv��`֮iAA! ��Rt>&�Bvd�/n����@<�j+h�+Pq	�`S�#U\�M���ł�.Y��&`�4S��)&$x�℉���߻z-`����6�"�[�!�j����B9���X��0�iՂmSW��Jd�R�u��ׇ�6ORçf�����e�QÇ�-�n����c��~1��eo��\׺��Y�.�b��(LJ(�@�d��Slf��^%[��s��5�b!���t0�B亓�rw���h4�y�!      �   �  x��?o�FGk�c���������O��!J` ��R�|���L�,�%�+~.m��$g�[
 �L�g`R�O��*%4e?�����Sʒ�\L�?o�}����|}�_��QH܅��x�_�/|z���z��������v��_�����r�뗏_$	������z{���S�����A�9�eNg:J�P�zr:���·�b�j��3M�Z��(�%CO�B�)�O�z����8�9�q5*�/�cJ�����S;u���Ǌ����tϖ��M驢�a:�7t'1M鹢��t���]���T��a����<{fx���(�,��Xriv�Y*x:��튻p����}�m��C&�	d�@&���L(2�L �2�L,g�#�2�L ��r&2�L �2�L,g""�2�L ��r&2�L �2�L,g"#�2�L ��b&<!�2�L ��r&�@&�	d�@&�3����	d�@&���L�-ld�@&�	db%x�@&�	d�X���F&�	d�@&V2����	d�@&���L�-ld�@&�	db%x�@&�	d�X���F&�	d�@&2!'4��3�R�-J�f?��p��:�3��〭;�	Qʍ��3��&�`���(�U�r"�^�L���v\)��S����!p�{�n�L�+�ܐ�d��O��~f�ٲ�O��G����њE�b\�z?2�"/���Bʴ��~�7kSȮ�2fi���L����6XI�[Ć���b�G�Ώ��S�Q�Ajc~>���'nv97��b�I����u�M�]��J����tɸ��:���}.^`z��H�����w��\[�Ƶu.�.n3%���ܘ���>/0��X�����e��d��dg�|L7���L�V��q	�u��Ts�%j�J�}>^��=�FwR�o�r���:�s�n�<;���>��t�=��Y&B�L!���1�!����Z�5rt�O����&;���CV�]eC��L�������'�-!�3͗A%�!��G�r7���ږ]pcC^�*m��icǮ�;N!o��I�! ��)e��B�f��G���g�!�~&Y!'�>ٱO[B�6�^��ДD����$k�FJ_7���"23��o,/n�d%C�P2�%�(JV(J���d(�GP��~y:�N��xL(      �   !   x�3�tv�q�qqu�2��2b���� W��      �   �  x�}WK�l+W��/��{�1f�Kh�oַ�AVf�QdIv��΢6���c?��ۏ���-K�L�����B�,R2yv���������4��.�$�z�d��<�dXg�{>�hu	r��:{�?�W�\n�%��7�i��5�)+���Q��Y��6�]��/YCj�f�O�u�����b���t�źcG����p�~�n��Ţm�ðd����I#m���qxV{x��%��Dײ��ڣ�=�`�³������^I�O&M�Z�&��y�{�ܖK[ 3�V3P݊�vxjSݯ��9��K��9(S�.�#Z����Yv�15�4��AH-qz+�59�qNuEa>�`�}�e��v�2���tA��> ������wY����D�A/����h�,���wZ*?e��M+P�q	�U�&��a��Eݵ{g0
[�q_a�u���� }~�5G���1? �<�.�'��yY�����x ��\V��U�/�͟h��Lډ���)VH��q�ɦ���|��u���G-���y.?��k܅��'�vd_:^~�y�l$����C�3 n������7������Vr�"܇�����yTǃ��E�6���F�RwtP3�i#��$P�64?;�~��p��j����Ŝ ��,��S�噟�_S;��&�_Ps8�A@}��e��}Yf̲�������ӟA31�Z�,~�U��2&ɨ?1����^����K;qM�ªQ���[�~Lg�W��r�e��B�����!}8��W�]��$d}D�ʣ4U!�.�����Z:��ߎpQ��a;�hGO����"f��s���s���_�!/���>R���!_T�Ns��bC��W���ަ�a�F
I�Q���C�,ޯ�gZ��}
"�ߏoZc�y��_��a_�;}�<W�>��q=�k@#��D��Jo��7���u�7XVo6jr}�CF�~8|�Ӗ/�i���	����7�Ƙ���q����Z���hf�?�$�4*�T,���zs΄�[}�փu}��mCe��θ�S���6Q	�P��y�y�h������˿��
iұJ̊o��ݰ���i��&��78/#��KL���'vZƨ`�X����R�S$�}3f�|����>�=�7�����B�[�m�k'gUF<��i�������q��L�^6�~��5����P:4�/�I��-����~�xj��      �   0   x�3���t��u�stw�2����9�����N�p? ���� :y�      �   7   x�3�t���tu�2���s�9�]}���|N��`O?���x�p?� �=... �)^      �   &   x�3��u�q�2�ts3L8����<��"�b���� ��R      �   6   x�3���s�q�2��u
�tu�2�t��r2M8�=]�����kW� 7K�      �   (  x���MJ�1��_N�L��'[W��V�&�Fޠ�CD��Z(��+Lo� �O��^�IxfQic�8��s>1�0Maaڃi�i��)�#�8:�/��e��g���dШ`"����C3��u�A�6��1s���z�N鿎�U]w@�l�r0T7��Ѓ�M�7ܳ��y�����zPZX_MQ�@Q���>Ciƃ���j6��jw�����^hEo|?hM+I��@�t'�6��v�յ�O�Hz�IF\�Wz�GV����h���R��4�P-�Zrk�r�����y�����+_̄_..��      �   !  x���=n�0��>E.@��$mڵ:t�";���P�sU6�><��������m�0���0�!�,��%zo�R!�#����WC��j��s��MCZ"�,<IA)����B#��D�
H5�N.{@v�_�(�y�Q�YH�Q#�iG�r�ќs��g�4���/z���8��B�Dr�'[���Z��iΐ[�@�s6�$՟9<(�:i��^���l��%O��Q�����s�\��[�e��?Dd��o�Rfx���d'���Iǅ��sX�>K��s�� [?�     