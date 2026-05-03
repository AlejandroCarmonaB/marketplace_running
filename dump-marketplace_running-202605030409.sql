--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2026-05-03 04:09:36

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
-- TOC entry 218 (class 1259 OID 25232)
-- Name: categoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categoria (
    id_categoria integer NOT NULL,
    nombre_categoria character varying(60) NOT NULL,
    descripcion_categoria character varying(200)
);


--
-- TOC entry 217 (class 1259 OID 25231)
-- Name: categoria_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.categoria ALTER COLUMN id_categoria ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categoria_id_categoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 25314)
-- Name: detalle_transaccion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_transaccion (
    id_detalle integer NOT NULL,
    id_transaccion integer NOT NULL,
    id_prod integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    CONSTRAINT detalle_transaccion_cantidad_check CHECK ((cantidad > 0))
);


--
-- TOC entry 227 (class 1259 OID 25313)
-- Name: detalle_transaccion_id_detalle_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.detalle_transaccion ALTER COLUMN id_detalle ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.detalle_transaccion_id_detalle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 25283)
-- Name: imagen_producto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.imagen_producto (
    id_imagen integer NOT NULL,
    id_prod integer NOT NULL,
    url_imagen text NOT NULL,
    public_id character varying(255)
);


--
-- TOC entry 223 (class 1259 OID 25282)
-- Name: imagen_producto_id_imagen_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.imagen_producto ALTER COLUMN id_imagen ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.imagen_producto_id_imagen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 33597)
-- Name: log_auditoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.log_auditoria (
    id_log integer NOT NULL,
    id_actor integer,
    accion character varying(100) NOT NULL,
    entidad character varying(50) NOT NULL,
    id_objetivo_usuario integer,
    id_objetivo_producto integer,
    detalle text,
    fecha_accion timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 33596)
-- Name: log_auditoria_id_log_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.log_auditoria_id_log_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 235
-- Name: log_auditoria_id_log_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.log_auditoria_id_log_seq OWNED BY public.log_auditoria.id_log;


--
-- TOC entry 222 (class 1259 OID 25260)
-- Name: producto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.producto (
    id_prod integer NOT NULL,
    id_vendedor integer NOT NULL,
    id_categoria integer NOT NULL,
    titulo character varying(120) NOT NULL,
    descripcion text NOT NULL,
    precio numeric(10,2) NOT NULL,
    stock integer NOT NULL,
    fecha_publicacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado_fisico character varying(20) NOT NULL,
    estado_publicacion character varying(15) NOT NULL,
    borrado_logico boolean DEFAULT false NOT NULL,
    fecha_baja_programada timestamp without time zone,
    motivo_baja text,
    eliminado_por integer,
    fecha_restauracion timestamp without time zone,
    CONSTRAINT producto_estado_fisico_check CHECK (((estado_fisico)::text = ANY (ARRAY[('como nuevo'::character varying)::text, ('excelente estado'::character varying)::text, ('muy poco uso'::character varying)::text, ('buen estado'::character varying)::text, ('uso moderado'::character varying)::text]))),
    CONSTRAINT producto_estado_publicacion_check CHECK (((estado_publicacion)::text = ANY ((ARRAY['activo'::character varying, 'vendido'::character varying, 'rechazado'::character varying, 'inactivo'::character varying])::text[]))),
    CONSTRAINT producto_precio_check CHECK ((precio >= (0)::numeric)),
    CONSTRAINT producto_stock_check CHECK ((stock >= 0))
);


--
-- TOC entry 221 (class 1259 OID 25259)
-- Name: producto_id_prod_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.producto ALTER COLUMN id_prod ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.producto_id_prod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 25353)
-- Name: resenya_producto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resenya_producto (
    id_resenya_prod integer NOT NULL,
    id_usuario_autor integer NOT NULL,
    id_prod integer NOT NULL,
    valoracion integer NOT NULL,
    comentario text NOT NULL,
    fecha_resenya timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT resenya_producto_valoracion_check CHECK (((valoracion >= 1) AND (valoracion <= 5)))
);


--
-- TOC entry 231 (class 1259 OID 25352)
-- Name: resenya_producto_id_resenya_prod_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.resenya_producto ALTER COLUMN id_resenya_prod ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.resenya_producto_id_resenya_prod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 25373)
-- Name: resenya_usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resenya_usuario (
    id_resenya_usuario integer NOT NULL,
    id_usuario_autor integer NOT NULL,
    id_usuario_resenyado integer NOT NULL,
    valoracion integer NOT NULL,
    comentario text NOT NULL,
    fecha_resenya timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT resenya_usuario_valoracion_check CHECK (((valoracion >= 1) AND (valoracion <= 5)))
);


--
-- TOC entry 233 (class 1259 OID 25372)
-- Name: resenya_usuario_id_resenya_usuario_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.resenya_usuario ALTER COLUMN id_resenya_usuario ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.resenya_usuario_id_resenya_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 25224)
-- Name: rol; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rol (
    id_rol integer NOT NULL,
    nombre_rol character varying(20) NOT NULL,
    descripcion_rol character varying(200)
);


--
-- TOC entry 215 (class 1259 OID 25223)
-- Name: rol_id_rol_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.rol ALTER COLUMN id_rol ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.rol_id_rol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 25296)
-- Name: transaccion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transaccion (
    id_transaccion integer NOT NULL,
    id_comprador integer NOT NULL,
    id_vendedor integer NOT NULL,
    fecha_transaccion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_transaccion numeric(10,2) NOT NULL,
    estado_transaccion character varying(30) NOT NULL,
    comision_plataforma numeric(10,2) NOT NULL,
    importe_vendedor numeric(10,2) NOT NULL,
    CONSTRAINT transaccion_estado_transaccion_check CHECK (((estado_transaccion)::text = ANY ((ARRAY['pago_retenido'::character varying, 'completada'::character varying, 'reembolsada'::character varying])::text[])))
);


--
-- TOC entry 225 (class 1259 OID 25295)
-- Name: transaccion_id_transaccion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.transaccion ALTER COLUMN id_transaccion ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.transaccion_id_transaccion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 25241)
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    id_rol integer NOT NULL,
    nombre character varying(60) NOT NULL,
    apellidos character varying(80) NOT NULL,
    nickname character varying(40) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado_cuenta character varying(15) NOT NULL,
    borrado_logico boolean DEFAULT false NOT NULL,
    fecha_baja_programada timestamp without time zone,
    motivo_baja text,
    eliminado_por integer,
    fecha_restauracion timestamp without time zone,
    CONSTRAINT usuario_estado_cuenta_check CHECK (((estado_cuenta)::text = ANY ((ARRAY['activa'::character varying, 'bloqueada'::character varying, 'suspendida'::character varying])::text[])))
);


--
-- TOC entry 219 (class 1259 OID 25240)
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.usuario ALTER COLUMN id_usuario ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.usuario_id_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 25331)
-- Name: verificacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.verificacion (
    id_verificacion integer NOT NULL,
    id_transaccion integer NOT NULL,
    id_revisor integer NOT NULL,
    resultado_verificacion character varying(20) NOT NULL,
    motivo_rechazo text,
    fecha_revision timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT verificacion_resultado_verificacion_check CHECK (((resultado_verificacion)::text = ANY ((ARRAY['aprobada'::character varying, 'rechazada'::character varying])::text[])))
);


--
-- TOC entry 229 (class 1259 OID 25330)
-- Name: verificacion_id_verificacion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.verificacion ALTER COLUMN id_verificacion ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.verificacion_id_verificacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4692 (class 2604 OID 33600)
-- Name: log_auditoria id_log; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_auditoria ALTER COLUMN id_log SET DEFAULT nextval('public.log_auditoria_id_log_seq'::regclass);


--
-- TOC entry 4909 (class 0 OID 25232)
-- Dependencies: 218
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categoria OVERRIDING SYSTEM VALUE VALUES (11, 'Zapatillas', NULL);
INSERT INTO public.categoria OVERRIDING SYSTEM VALUE VALUES (12, 'Textil', NULL);
INSERT INTO public.categoria OVERRIDING SYSTEM VALUE VALUES (13, 'Relojes y electrónica deportiva', NULL);
INSERT INTO public.categoria OVERRIDING SYSTEM VALUE VALUES (14, 'Mochilas e hidratación', NULL);
INSERT INTO public.categoria OVERRIDING SYSTEM VALUE VALUES (15, 'Accesorios', NULL);
INSERT INTO public.categoria OVERRIDING SYSTEM VALUE VALUES (16, 'Nutrición deportiva', NULL);
INSERT INTO public.categoria OVERRIDING SYSTEM VALUE VALUES (17, 'Equipamiento trail', NULL);
INSERT INTO public.categoria OVERRIDING SYSTEM VALUE VALUES (18, 'Calcetines técnicos', NULL);
INSERT INTO public.categoria OVERRIDING SYSTEM VALUE VALUES (19, 'Gafas deportivas', NULL);
INSERT INTO public.categoria OVERRIDING SYSTEM VALUE VALUES (20, 'Recuperación y fisioterapia', NULL);


--
-- TOC entry 4919 (class 0 OID 25314)
-- Dependencies: 228
-- Data for Name: detalle_transaccion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (1, 1, 4, 1, 94.57);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (2, 2, 19, 1, 81.14);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (3, 3, 20, 1, 68.29);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (4, 4, 29, 1, 129.86);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (5, 5, 31, 1, 166.22);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (6, 6, 40, 1, 177.50);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (7, 7, 44, 1, 108.75);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (8, 8, 45, 1, 107.97);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (9, 9, 48, 1, 176.44);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (10, 10, 51, 1, 210.82);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (11, 11, 53, 1, 187.27);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (12, 12, 61, 1, 76.44);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (13, 13, 77, 1, 111.80);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (14, 14, 81, 1, 99.87);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (15, 15, 83, 1, 144.03);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (16, 16, 89, 1, 127.89);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (17, 17, 91, 1, 156.30);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (18, 18, 93, 1, 161.13);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (19, 19, 99, 1, 127.24);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (20, 20, 102, 1, 150.61);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (21, 21, 106, 1, 122.57);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (22, 22, 107, 1, 95.71);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (23, 23, 114, 1, 37.91);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (24, 24, 124, 1, 34.48);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (25, 25, 125, 1, 38.01);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (26, 26, 142, 1, 30.21);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (27, 27, 145, 1, 84.51);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (28, 28, 156, 1, 50.46);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (29, 29, 167, 1, 56.19);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (30, 30, 172, 1, 74.37);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (31, 31, 173, 1, 34.72);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (32, 32, 175, 1, 41.49);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (33, 33, 177, 1, 37.78);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (34, 34, 193, 1, 343.80);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (35, 35, 195, 1, 390.68);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (36, 36, 199, 1, 259.83);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (37, 37, 200, 1, 277.93);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (38, 38, 204, 1, 489.56);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (39, 39, 211, 1, 168.98);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (40, 40, 215, 1, 64.89);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (41, 41, 216, 1, 56.20);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (42, 42, 218, 1, 188.35);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (43, 43, 224, 1, 90.56);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (44, 44, 229, 1, 544.50);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (45, 45, 233, 1, 360.39);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (46, 46, 234, 1, 429.19);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (47, 47, 236, 1, 404.87);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (48, 48, 238, 1, 104.60);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (49, 49, 243, 1, 162.58);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (50, 50, 249, 1, 85.13);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (51, 51, 251, 1, 108.25);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (52, 52, 258, 1, 176.13);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (53, 53, 259, 1, 189.61);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (54, 54, 265, 1, 115.43);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (55, 55, 266, 1, 99.26);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (56, 56, 267, 1, 99.53);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (57, 57, 273, 1, 106.34);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (58, 58, 277, 1, 128.08);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (59, 59, 280, 1, 152.05);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (60, 60, 285, 1, 16.36);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (61, 61, 296, 1, 19.81);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (62, 62, 298, 1, 39.63);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (63, 63, 301, 1, 40.58);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (64, 64, 306, 1, 35.80);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (65, 65, 313, 1, 33.41);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (66, 66, 319, 1, 124.20);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (67, 67, 328, 1, 20.13);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (68, 68, 331, 1, 15.50);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (69, 69, 332, 1, 15.48);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (70, 70, 337, 1, 10.67);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (71, 71, 354, 1, 31.97);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (72, 72, 356, 1, 30.07);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (73, 73, 367, 1, 27.66);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (74, 74, 369, 1, 22.02);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (75, 75, 371, 1, 23.57);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (76, 76, 384, 1, 67.23);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (77, 77, 391, 1, 42.00);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (78, 78, 393, 1, 33.07);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (79, 79, 396, 1, 40.20);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (80, 80, 398, 1, 24.70);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (81, 81, 406, 1, 193.51);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (82, 82, 407, 1, 150.23);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (83, 83, 411, 1, 101.59);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (84, 84, 414, 1, 120.19);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (85, 85, 416, 1, 130.54);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (86, 86, 418, 1, 15.81);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (87, 87, 423, 1, 23.84);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (88, 88, 424, 1, 22.18);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (89, 89, 438, 1, 17.10);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (90, 90, 442, 1, 22.65);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (91, 91, 449, 1, 19.97);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (92, 92, 455, 1, 18.32);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (93, 93, 463, 1, 131.40);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (94, 94, 466, 1, 114.24);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (95, 95, 468, 1, 179.09);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (96, 96, 475, 1, 160.21);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (97, 97, 481, 1, 79.76);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (98, 98, 486, 1, 66.04);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (99, 99, 491, 1, 104.21);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (100, 100, 497, 1, 250.18);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (101, 101, 498, 1, 169.65);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (102, 102, 499, 1, 188.24);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (103, 103, 500, 1, 181.64);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (104, 104, 502, 1, 184.28);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (105, 105, 504, 1, 43.88);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (106, 106, 520, 1, 40.29);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (107, 107, 524, 1, 24.25);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (108, 108, 531, 1, 570.41);
INSERT INTO public.detalle_transaccion OVERRIDING SYSTEM VALUE VALUES (109, 109, 532, 1, 735.32);


--
-- TOC entry 4915 (class 0 OID 25283)
-- Dependencies: 224
-- Data for Name: imagen_producto; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.imagen_producto OVERRIDING SYSTEM VALUE VALUES (1068, 533, 'https://res.cloudinary.com/douvg1pdv/image/upload/v1776984544/marketplace_running/productos/zt8j4uaad56geuwjhqit.jpg', 'marketplace_running/productos/zt8j4uaad56geuwjhqit');
INSERT INTO public.imagen_producto OVERRIDING SYSTEM VALUE VALUES (1071, 533, 'https://res.cloudinary.com/douvg1pdv/image/upload/v1776984816/marketplace_running/productos/mpagt77fjgdliwfp1x6j.jpg', 'marketplace_running/productos/mpagt77fjgdliwfp1x6j');


--
-- TOC entry 4927 (class 0 OID 33597)
-- Dependencies: 236
-- Data for Name: log_auditoria; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.log_auditoria VALUES (1, 50, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 52, NULL, 'Baja programada hasta Sat Apr 25 2026 02:49:41 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-18 02:49:41.73683');
INSERT INTO public.log_auditoria VALUES (2, 50, 'PROGRAMAR_BAJA_PRODUCTO', 'producto', NULL, 529, 'Baja programada hasta Sat Apr 25 2026 02:50:19 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-18 02:50:19.879892');
INSERT INTO public.log_auditoria VALUES (3, 99, 'RESTAURAR_PRODUCTO', 'producto', NULL, 529, 'Restauración antes de la purga definitiva', '2026-04-18 02:51:13.519269');
INSERT INTO public.log_auditoria VALUES (4, 99, 'RESTAURAR_USUARIO', 'usuario', 52, NULL, 'Restauración antes de la purga definitiva', '2026-04-18 02:51:14.752837');
INSERT INTO public.log_auditoria VALUES (5, 99, 'CAMBIAR_ROL_USUARIO', 'usuario', 50, NULL, 'Nuevo id_rol: 3', '2026-04-18 03:38:33.706821');
INSERT INTO public.log_auditoria VALUES (6, 99, 'CAMBIAR_ROL_USUARIO', 'usuario', 50, NULL, 'Nuevo id_rol: 3', '2026-04-18 03:38:36.503954');
INSERT INTO public.log_auditoria VALUES (7, 99, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 52, NULL, 'Baja programada hasta Sat Apr 25 2026 04:19:42 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-18 04:19:42.877746');
INSERT INTO public.log_auditoria VALUES (8, 99, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 54, NULL, 'Baja programada hasta Sat Apr 25 2026 04:19:45 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-18 04:19:45.291245');
INSERT INTO public.log_auditoria VALUES (9, 99, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 56, NULL, 'Baja programada hasta Sat Apr 25 2026 04:19:47 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-18 04:19:47.167264');
INSERT INTO public.log_auditoria VALUES (10, 99, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 62, NULL, 'Baja programada hasta Sat Apr 25 2026 04:19:49 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-18 04:19:49.776322');
INSERT INTO public.log_auditoria VALUES (11, 99, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 59, NULL, 'Baja programada hasta Sat Apr 25 2026 04:19:53 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-18 04:19:53.134909');
INSERT INTO public.log_auditoria VALUES (12, 99, 'RESTAURAR_USUARIO', 'usuario', 52, NULL, 'Restauración antes de la purga definitiva', '2026-04-18 04:20:10.621055');
INSERT INTO public.log_auditoria VALUES (13, 99, 'RESTAURAR_USUARIO', 'usuario', 54, NULL, 'Restauración antes de la purga definitiva', '2026-04-18 04:20:15.425726');
INSERT INTO public.log_auditoria VALUES (14, 99, 'RESTAURAR_USUARIO', 'usuario', 56, NULL, 'Restauración antes de la purga definitiva', '2026-04-18 04:20:19.547415');
INSERT INTO public.log_auditoria VALUES (15, 99, 'RESTAURAR_USUARIO', 'usuario', 62, NULL, 'Restauración antes de la purga definitiva', '2026-04-18 04:20:23.179255');
INSERT INTO public.log_auditoria VALUES (16, 99, 'RESTAURAR_USUARIO', 'usuario', 59, NULL, 'Restauración antes de la purga definitiva', '2026-04-18 04:20:27.025219');
INSERT INTO public.log_auditoria VALUES (17, 99, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 52, NULL, 'Baja programada hasta Sat Apr 25 2026 04:28:25 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-18 04:28:25.635549');
INSERT INTO public.log_auditoria VALUES (18, 99, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 53, NULL, 'Baja programada hasta Sun Apr 26 2026 02:14:53 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-19 02:14:53.079184');
INSERT INTO public.log_auditoria VALUES (19, 99, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 54, NULL, 'Baja programada hasta Sun Apr 26 2026 02:15:01 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-19 02:15:01.021962');
INSERT INTO public.log_auditoria VALUES (20, 99, 'RESTAURAR_USUARIO', 'usuario', 54, NULL, 'Restauración antes de la purga definitiva', '2026-04-19 02:15:38.346308');
INSERT INTO public.log_auditoria VALUES (21, 99, 'RESTAURAR_USUARIO', 'usuario', 53, NULL, 'Restauración antes de la purga definitiva', '2026-04-19 02:15:39.098402');
INSERT INTO public.log_auditoria VALUES (22, 99, 'RESTAURAR_USUARIO', 'usuario', 52, NULL, 'Restauración antes de la purga definitiva', '2026-04-19 02:15:39.625731');
INSERT INTO public.log_auditoria VALUES (23, 99, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 52, NULL, 'Baja programada hasta Sun Apr 26 2026 02:15:56 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-19 02:15:56.949788');
INSERT INTO public.log_auditoria VALUES (24, 99, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 53, NULL, 'Baja programada hasta Sun Apr 26 2026 02:16:05 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-19 02:16:05.07599');
INSERT INTO public.log_auditoria VALUES (25, 99, 'RESTAURAR_USUARIO', 'usuario', 53, NULL, 'Restauración antes de la purga definitiva', '2026-04-19 02:16:39.618133');
INSERT INTO public.log_auditoria VALUES (26, 99, 'RESTAURAR_USUARIO', 'usuario', 52, NULL, 'Restauración antes de la purga definitiva', '2026-04-19 02:16:40.427879');
INSERT INTO public.log_auditoria VALUES (27, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:17:08.313238');
INSERT INTO public.log_auditoria VALUES (28, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:17:10.876283');
INSERT INTO public.log_auditoria VALUES (29, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:17:11.48507');
INSERT INTO public.log_auditoria VALUES (30, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:17:12.30333');
INSERT INTO public.log_auditoria VALUES (31, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:17:12.860953');
INSERT INTO public.log_auditoria VALUES (32, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:17:13.41756');
INSERT INTO public.log_auditoria VALUES (33, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:17:13.904186');
INSERT INTO public.log_auditoria VALUES (34, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:17:15.80785');
INSERT INTO public.log_auditoria VALUES (35, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:17:16.534173');
INSERT INTO public.log_auditoria VALUES (36, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:17:16.95362');
INSERT INTO public.log_auditoria VALUES (37, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:17:17.85241');
INSERT INTO public.log_auditoria VALUES (38, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:17:20.258033');
INSERT INTO public.log_auditoria VALUES (39, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:17:20.72');
INSERT INTO public.log_auditoria VALUES (40, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:17:21.23077');
INSERT INTO public.log_auditoria VALUES (41, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:01.776868');
INSERT INTO public.log_auditoria VALUES (42, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:02.863828');
INSERT INTO public.log_auditoria VALUES (43, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:03.470229');
INSERT INTO public.log_auditoria VALUES (44, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:04.19046');
INSERT INTO public.log_auditoria VALUES (45, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:04.66948');
INSERT INTO public.log_auditoria VALUES (46, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:05.386798');
INSERT INTO public.log_auditoria VALUES (47, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:05.838639');
INSERT INTO public.log_auditoria VALUES (48, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:06.331346');
INSERT INTO public.log_auditoria VALUES (49, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:06.736271');
INSERT INTO public.log_auditoria VALUES (50, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:07.151086');
INSERT INTO public.log_auditoria VALUES (51, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:07.62853');
INSERT INTO public.log_auditoria VALUES (52, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:09.241658');
INSERT INTO public.log_auditoria VALUES (53, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:09.68422');
INSERT INTO public.log_auditoria VALUES (54, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:10.651391');
INSERT INTO public.log_auditoria VALUES (55, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:11.06864');
INSERT INTO public.log_auditoria VALUES (56, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:12.375584');
INSERT INTO public.log_auditoria VALUES (57, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:12.836333');
INSERT INTO public.log_auditoria VALUES (58, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:14.257276');
INSERT INTO public.log_auditoria VALUES (59, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:15.630379');
INSERT INTO public.log_auditoria VALUES (60, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:17.585229');
INSERT INTO public.log_auditoria VALUES (61, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:17.975403');
INSERT INTO public.log_auditoria VALUES (62, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:18.404686');
INSERT INTO public.log_auditoria VALUES (63, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:18.842708');
INSERT INTO public.log_auditoria VALUES (64, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:19.319232');
INSERT INTO public.log_auditoria VALUES (65, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:19.757981');
INSERT INTO public.log_auditoria VALUES (66, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:20.210827');
INSERT INTO public.log_auditoria VALUES (67, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:43:20.653429');
INSERT INTO public.log_auditoria VALUES (68, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 02:43:21.076806');
INSERT INTO public.log_auditoria VALUES (69, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 02:44:32.416181');
INSERT INTO public.log_auditoria VALUES (70, 99, 'CAMBIAR_ROL_USUARIO', 'usuario', 50, NULL, 'Nuevo id_rol: 3', '2026-04-19 03:11:23.55305');
INSERT INTO public.log_auditoria VALUES (71, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:11:25.721899');
INSERT INTO public.log_auditoria VALUES (72, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:29:30.262794');
INSERT INTO public.log_auditoria VALUES (73, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:29:31.10052');
INSERT INTO public.log_auditoria VALUES (74, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:29:31.549909');
INSERT INTO public.log_auditoria VALUES (75, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:29:32.055539');
INSERT INTO public.log_auditoria VALUES (76, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:29:50.945914');
INSERT INTO public.log_auditoria VALUES (77, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:29:51.67198');
INSERT INTO public.log_auditoria VALUES (78, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:29:52.422873');
INSERT INTO public.log_auditoria VALUES (79, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:29:53.004843');
INSERT INTO public.log_auditoria VALUES (80, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:29:55.48545');
INSERT INTO public.log_auditoria VALUES (81, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:29:56.322963');
INSERT INTO public.log_auditoria VALUES (82, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:29:56.765489');
INSERT INTO public.log_auditoria VALUES (83, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:29:57.610951');
INSERT INTO public.log_auditoria VALUES (84, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:29:58.018372');
INSERT INTO public.log_auditoria VALUES (85, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:29:59.680016');
INSERT INTO public.log_auditoria VALUES (86, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:30:00.095948');
INSERT INTO public.log_auditoria VALUES (87, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:30:00.744568');
INSERT INTO public.log_auditoria VALUES (88, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:30:01.168149');
INSERT INTO public.log_auditoria VALUES (89, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:30:01.939134');
INSERT INTO public.log_auditoria VALUES (90, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:30:02.402014');
INSERT INTO public.log_auditoria VALUES (91, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:30:03.083895');
INSERT INTO public.log_auditoria VALUES (92, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:30:03.886747');
INSERT INTO public.log_auditoria VALUES (93, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:30:05.114597');
INSERT INTO public.log_auditoria VALUES (94, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:30:10.583265');
INSERT INTO public.log_auditoria VALUES (95, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:30:11.655961');
INSERT INTO public.log_auditoria VALUES (96, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:30:14.192929');
INSERT INTO public.log_auditoria VALUES (97, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:30:14.91921');
INSERT INTO public.log_auditoria VALUES (98, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:30:17.503387');
INSERT INTO public.log_auditoria VALUES (99, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:30:20.801721');
INSERT INTO public.log_auditoria VALUES (100, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:30:24.864706');
INSERT INTO public.log_auditoria VALUES (101, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:53:26.689243');
INSERT INTO public.log_auditoria VALUES (102, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 03:54:08.782341');
INSERT INTO public.log_auditoria VALUES (103, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 03:54:15.456592');
INSERT INTO public.log_auditoria VALUES (104, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 04:22:32.441537');
INSERT INTO public.log_auditoria VALUES (105, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 04:22:33.47477');
INSERT INTO public.log_auditoria VALUES (106, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 04:22:34.277635');
INSERT INTO public.log_auditoria VALUES (107, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 04:22:35.127066');
INSERT INTO public.log_auditoria VALUES (108, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: bloqueada', '2026-04-19 04:22:35.655505');
INSERT INTO public.log_auditoria VALUES (109, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 50, NULL, 'Nuevo estado: activa', '2026-04-19 04:22:36.197089');
INSERT INTO public.log_auditoria VALUES (110, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 56, NULL, 'Nuevo estado: bloqueada', '2026-04-19 04:22:37.797123');
INSERT INTO public.log_auditoria VALUES (111, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 56, NULL, 'Nuevo estado: activa', '2026-04-19 04:22:38.961053');
INSERT INTO public.log_auditoria VALUES (112, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 56, NULL, 'Nuevo estado: bloqueada', '2026-04-19 04:22:39.583527');
INSERT INTO public.log_auditoria VALUES (113, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 56, NULL, 'Nuevo estado: activa', '2026-04-19 04:22:40.344938');
INSERT INTO public.log_auditoria VALUES (114, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 56, NULL, 'Nuevo estado: bloqueada', '2026-04-19 04:22:40.928654');
INSERT INTO public.log_auditoria VALUES (115, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 56, NULL, 'Nuevo estado: activa', '2026-04-19 04:22:41.710946');
INSERT INTO public.log_auditoria VALUES (116, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 56, NULL, 'Nuevo estado: bloqueada', '2026-04-19 04:22:43.611618');
INSERT INTO public.log_auditoria VALUES (117, 99, 'CAMBIAR_ESTADO_USUARIO_SUPERADMIN', 'usuario', 56, NULL, 'Nuevo estado: activa', '2026-04-19 04:22:47.669924');
INSERT INTO public.log_auditoria VALUES (118, 99, 'CAMBIAR_ROL_USUARIO', 'usuario', 59, NULL, 'Nuevo id_rol: 3', '2026-04-20 00:56:52.450426');
INSERT INTO public.log_auditoria VALUES (119, 99, 'CAMBIAR_ROL_USUARIO', 'usuario', 59, NULL, 'Nuevo id_rol: 1', '2026-04-20 00:58:22.730193');
INSERT INTO public.log_auditoria VALUES (120, 99, 'CAMBIAR_ROL_USUARIO', 'usuario', 59, NULL, 'Nuevo id_rol: 1', '2026-04-20 00:58:54.321996');
INSERT INTO public.log_auditoria VALUES (121, 50, 'CAMBIAR_ESTADO_USUARIO', 'usuario', 59, NULL, 'Nuevo estado: bloqueada', '2026-04-20 01:07:12.89996');
INSERT INTO public.log_auditoria VALUES (122, 50, 'CAMBIAR_ESTADO_USUARIO', 'usuario', 59, NULL, 'Nuevo estado: activa', '2026-04-20 01:07:33.925028');
INSERT INTO public.log_auditoria VALUES (123, 50, 'PROGRAMAR_BAJA_USUARIO', 'usuario', 59, NULL, 'Baja programada hasta Mon Apr 27 2026 01:08:23 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-20 01:08:23.952335');
INSERT INTO public.log_auditoria VALUES (124, 50, 'PROGRAMAR_BAJA_PRODUCTO', 'producto', NULL, 532, 'Baja programada hasta Mon Apr 27 2026 01:14:36 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-20 01:14:36.045538');
INSERT INTO public.log_auditoria VALUES (125, 50, 'PROGRAMAR_BAJA_PRODUCTO', 'producto', NULL, 531, 'Baja programada hasta Mon Apr 27 2026 01:14:39 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-20 01:14:39.031381');
INSERT INTO public.log_auditoria VALUES (126, 50, 'PROGRAMAR_BAJA_PRODUCTO', 'producto', NULL, 530, 'Baja programada hasta Mon Apr 27 2026 01:14:43 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-20 01:14:43.963954');
INSERT INTO public.log_auditoria VALUES (127, 50, 'CAMBIAR_ESTADO_PRODUCTO', 'producto', NULL, 529, 'Nuevo estado: activo', '2026-04-20 01:14:57.690424');
INSERT INTO public.log_auditoria VALUES (128, 50, 'CAMBIAR_ESTADO_PRODUCTO', 'producto', NULL, 529, 'Nuevo estado: activo', '2026-04-20 01:15:24.40331');
INSERT INTO public.log_auditoria VALUES (129, 50, 'CAMBIAR_ESTADO_PRODUCTO', 'producto', NULL, 529, 'Nuevo estado: activo', '2026-04-20 01:15:26.708894');
INSERT INTO public.log_auditoria VALUES (130, 50, 'CAMBIAR_ESTADO_PRODUCTO', 'producto', NULL, 529, 'Nuevo estado: inactivo', '2026-04-20 01:15:29.997647');
INSERT INTO public.log_auditoria VALUES (131, 50, 'CAMBIAR_ESTADO_PRODUCTO', 'producto', NULL, 529, 'Nuevo estado: inactivo', '2026-04-20 01:15:32.19693');
INSERT INTO public.log_auditoria VALUES (132, 99, 'RESTAURAR_USUARIO', 'usuario', 59, NULL, 'Restauración antes de la purga definitiva', '2026-04-20 01:32:13.052341');
INSERT INTO public.log_auditoria VALUES (133, 99, 'RESTAURAR_PRODUCTO', 'producto', NULL, 532, 'Restauración antes de la purga definitiva', '2026-04-20 01:32:13.969194');
INSERT INTO public.log_auditoria VALUES (134, 99, 'RESTAURAR_PRODUCTO', 'producto', NULL, 531, 'Restauración antes de la purga definitiva', '2026-04-20 01:32:14.623277');
INSERT INTO public.log_auditoria VALUES (135, 99, 'RESTAURAR_PRODUCTO', 'producto', NULL, 530, 'Restauración antes de la purga definitiva', '2026-04-20 01:32:16.903028');
INSERT INTO public.log_auditoria VALUES (136, 50, 'CAMBIAR_ESTADO_PRODUCTO', 'producto', NULL, 532, 'Nuevo estado: inactivo', '2026-04-21 00:54:03.811028');
INSERT INTO public.log_auditoria VALUES (137, 50, 'CAMBIAR_ESTADO_PRODUCTO', 'producto', NULL, 532, 'Nuevo estado: activo', '2026-04-21 00:54:05.603666');
INSERT INTO public.log_auditoria VALUES (138, 50, 'CAMBIAR_ESTADO_PRODUCTO', 'producto', NULL, 532, 'Nuevo estado: inactivo', '2026-04-21 00:54:07.772479');
INSERT INTO public.log_auditoria VALUES (139, 50, 'CAMBIAR_ESTADO_PRODUCTO', 'producto', NULL, 532, 'Nuevo estado: activo', '2026-04-21 00:54:08.617166');
INSERT INTO public.log_auditoria VALUES (140, 50, 'PROGRAMAR_BAJA_PRODUCTO', 'producto', NULL, 532, 'Baja programada hasta Tue Apr 28 2026 00:58:11 GMT+0200 (hora de verano de Europa central). Motivo: Baja administrativa desde panel admin', '2026-04-21 00:58:11.984847');
INSERT INTO public.log_auditoria VALUES (141, 99, 'RESTAURAR_PRODUCTO', 'producto', NULL, 532, 'Restauración antes de la purga definitiva', '2026-04-21 00:58:55.828792');
INSERT INTO public.log_auditoria VALUES (142, 99, 'CAMBIAR_ESTADO_PRODUCTO', 'producto', NULL, 531, 'Nuevo estado: inactivo', '2026-04-21 21:10:15.144718');
INSERT INTO public.log_auditoria VALUES (143, 99, 'CAMBIAR_ROL_USUARIO', 'usuario', 87, NULL, 'Nuevo id_rol: 2', '2026-04-24 01:14:20.890871');
INSERT INTO public.log_auditoria VALUES (144, 99, 'CAMBIAR_ROL_USUARIO', 'usuario', 87, NULL, 'Nuevo id_rol: 1', '2026-04-24 01:17:06.159336');


--
-- TOC entry 4913 (class 0 OID 25260)
-- Dependencies: 222
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (3, 72, 11, 'Nike Air Zoom Pegasus 40', 'Zapatillas de running Nike Air Zoom Pegasus 40, amortiguación reactiva y ajuste seguro. Ideales para entrenamientos diarios de distancia media.', 84.20, 1, '2025-01-08 08:24:55.845', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (4, 75, 11, 'Nike Air Zoom Pegasus 40 - Talla 39 - Blanco', 'Zapatillas de running Nike Air Zoom Pegasus 40, amortiguación reactiva y ajuste seguro. Ideales para entrenamientos diarios de distancia media.', 94.57, 0, '2025-11-03 07:00:14.749', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (5, 79, 11, 'Nike Air Zoom Pegasus 40 - Talla 40 - Azul', 'Zapatillas de running Nike Air Zoom Pegasus 40, amortiguación reactiva y ajuste seguro. Ideales para entrenamientos diarios de distancia media.', 77.59, 1, '2025-03-02 07:11:14.932', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (6, 60, 11, 'Nike Air Zoom Pegasus 40 - Talla 41 - Rojo', 'Zapatillas de running Nike Air Zoom Pegasus 40, amortiguación reactiva y ajuste seguro. Ideales para entrenamientos diarios de distancia media.', 80.46, 1, '2025-11-20 14:30:47.631', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (7, 61, 11, 'Nike Air Zoom Pegasus 40 - Talla 42 - Verde', 'Zapatillas de running Nike Air Zoom Pegasus 40, amortiguación reactiva y ajuste seguro. Ideales para entrenamientos diarios de distancia media.', 89.37, 1, '2025-02-08 00:32:17.61', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (8, 71, 11, 'Adidas Ultraboost 23', 'Zapatillas Adidas Ultraboost 23 con tecnología Boost para máxima amortiguación. Perfectas para largas distancias y maratones.', 114.51, 1, '2025-10-16 17:19:21.034', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (9, 71, 11, 'Adidas Ultraboost 23 - Talla 39 - Blanco', 'Zapatillas Adidas Ultraboost 23 con tecnología Boost para máxima amortiguación. Perfectas para largas distancias y maratones.', 111.96, 1, '2025-03-14 21:18:52.4', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (10, 93, 11, 'Adidas Ultraboost 23 - Talla 40 - Azul', 'Zapatillas Adidas Ultraboost 23 con tecnología Boost para máxima amortiguación. Perfectas para largas distancias y maratones.', 118.88, 1, '2025-09-24 19:35:57.034', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (11, 98, 11, 'Adidas Ultraboost 23 - Talla 41 - Rojo', 'Zapatillas Adidas Ultraboost 23 con tecnología Boost para máxima amortiguación. Perfectas para largas distancias y maratones.', 119.39, 1, '2025-05-10 12:39:32.246', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (12, 70, 11, 'Adidas Ultraboost 23 - Talla 42 - Verde', 'Zapatillas Adidas Ultraboost 23 con tecnología Boost para máxima amortiguación. Perfectas para largas distancias y maratones.', 123.28, 1, '2025-08-03 04:21:06.641', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (13, 89, 11, 'ASICS Gel-Kayano 30', 'Zapatillas de estabilidad ASICS Gel-Kayano 30 con tecnología Gel en talón y antepié. Excelente soporte para pronadores.', 88.16, 1, '2025-04-20 16:14:10.751', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (14, 91, 11, 'ASICS Gel-Kayano 30 - Talla 39 - Blanco', 'Zapatillas de estabilidad ASICS Gel-Kayano 30 con tecnología Gel en talón y antepié. Excelente soporte para pronadores.', 106.70, 1, '2025-04-18 07:24:26.19', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (15, 97, 11, 'ASICS Gel-Kayano 30 - Talla 40 - Azul', 'Zapatillas de estabilidad ASICS Gel-Kayano 30 con tecnología Gel en talón y antepié. Excelente soporte para pronadores.', 91.95, 1, '2026-03-24 09:18:51.553', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (16, 67, 11, 'ASICS Gel-Kayano 30 - Talla 41 - Rojo', 'Zapatillas de estabilidad ASICS Gel-Kayano 30 con tecnología Gel en talón y antepié. Excelente soporte para pronadores.', 91.31, 1, '2025-10-08 06:01:24.931', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (17, 74, 11, 'ASICS Gel-Kayano 30 - Talla 42 - Verde', 'Zapatillas de estabilidad ASICS Gel-Kayano 30 con tecnología Gel en talón y antepié. Excelente soporte para pronadores.', 102.44, 1, '2025-06-17 21:46:56.477', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (18, 97, 11, 'Brooks Ghost 15', 'Zapatillas neutras Brooks Ghost 15, suaves y versátiles. Perfectas para corredores que buscan comodidad en entrenamientos diarios.', 77.30, 1, '2025-05-06 04:51:22.758', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (19, 76, 11, 'Brooks Ghost 15 - Talla 39 - Blanco', 'Zapatillas neutras Brooks Ghost 15, suaves y versátiles. Perfectas para corredores que buscan comodidad en entrenamientos diarios.', 81.14, 0, '2025-04-08 11:09:32.009', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (20, 65, 11, 'Brooks Ghost 15 - Talla 40 - Azul', 'Zapatillas neutras Brooks Ghost 15, suaves y versátiles. Perfectas para corredores que buscan comodidad en entrenamientos diarios.', 68.29, 0, '2025-02-17 13:42:52.117', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (21, 82, 11, 'Brooks Ghost 15 - Talla 41 - Rojo', 'Zapatillas neutras Brooks Ghost 15, suaves y versátiles. Perfectas para corredores que buscan comodidad en entrenamientos diarios.', 65.48, 1, '2026-02-21 11:47:23.684', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (22, 98, 11, 'Brooks Ghost 15 - Talla 42 - Verde', 'Zapatillas neutras Brooks Ghost 15, suaves y versátiles. Perfectas para corredores que buscan comodidad en entrenamientos diarios.', 75.35, 1, '2025-07-22 09:21:32.003', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (23, 88, 11, 'Hoka Clifton 9', 'Zapatillas maximalistas Hoka Clifton 9 con amplia plataforma de amortiguación. Ideales para corredores que buscan protección articular.', 103.20, 1, '2025-12-12 23:18:58.501', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (24, 78, 11, 'Hoka Clifton 9 - Talla 39 - Blanco', 'Zapatillas maximalistas Hoka Clifton 9 con amplia plataforma de amortiguación. Ideales para corredores que buscan protección articular.', 114.32, 1, '2026-01-04 02:18:57.993', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (25, 92, 11, 'Hoka Clifton 9 - Talla 40 - Azul', 'Zapatillas maximalistas Hoka Clifton 9 con amplia plataforma de amortiguación. Ideales para corredores que buscan protección articular.', 109.09, 1, '2025-12-02 03:25:58.931', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (26, 87, 11, 'Hoka Clifton 9 - Talla 41 - Rojo', 'Zapatillas maximalistas Hoka Clifton 9 con amplia plataforma de amortiguación. Ideales para corredores que buscan protección articular.', 94.32, 1, '2025-04-27 02:31:27.843', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (27, 75, 11, 'Hoka Clifton 9 - Talla 42 - Verde', 'Zapatillas maximalistas Hoka Clifton 9 con amplia plataforma de amortiguación. Ideales para corredores que buscan protección articular.', 115.88, 1, '2025-10-06 15:20:52.247', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (28, 90, 11, 'Saucony Endorphin Speed 3', 'Zapatillas de competición Saucony Endorphin Speed 3 con placa de nylon. Diseñadas para carreras y entrenamientos de velocidad.', 140.36, 1, '2025-07-04 22:16:17.135', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (29, 98, 11, 'Saucony Endorphin Speed 3 - Talla 39 - Blanco', 'Zapatillas de competición Saucony Endorphin Speed 3 con placa de nylon. Diseñadas para carreras y entrenamientos de velocidad.', 129.86, 0, '2025-12-04 01:03:40.532', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (30, 60, 11, 'Saucony Endorphin Speed 3 - Talla 40 - Azul', 'Zapatillas de competición Saucony Endorphin Speed 3 con placa de nylon. Diseñadas para carreras y entrenamientos de velocidad.', 123.91, 1, '2025-02-06 23:08:02.815', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (31, 77, 11, 'Saucony Endorphin Speed 3 - Talla 41 - Rojo', 'Zapatillas de competición Saucony Endorphin Speed 3 con placa de nylon. Diseñadas para carreras y entrenamientos de velocidad.', 166.22, 0, '2026-01-16 05:51:35.434', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (32, 68, 11, 'Saucony Endorphin Speed 3 - Talla 42 - Verde', 'Zapatillas de competición Saucony Endorphin Speed 3 con placa de nylon. Diseñadas para carreras y entrenamientos de velocidad.', 134.63, 1, '2025-02-09 12:05:54.608', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (33, 91, 11, 'New Balance Fresh Foam X 1080v13', 'Zapatillas premium New Balance con amortiguación Fresh Foam X de nueva generación. Máximo confort para largas distancias.', 126.59, 1, '2026-01-12 02:48:04.58', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (34, 82, 11, 'New Balance Fresh Foam X 1080v13 - Talla 39 - Blanco', 'Zapatillas premium New Balance con amortiguación Fresh Foam X de nueva generación. Máximo confort para largas distancias.', 123.51, 1, '2025-07-10 21:37:46.418', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (35, 83, 11, 'New Balance Fresh Foam X 1080v13 - Talla 40 - Azul', 'Zapatillas premium New Balance con amortiguación Fresh Foam X de nueva generación. Máximo confort para largas distancias.', 114.84, 1, '2025-01-03 22:17:25.352', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (36, 79, 11, 'New Balance Fresh Foam X 1080v13 - Talla 41 - Rojo', 'Zapatillas premium New Balance con amortiguación Fresh Foam X de nueva generación. Máximo confort para largas distancias.', 126.29, 1, '2025-05-01 04:47:49.777', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (37, 79, 11, 'New Balance Fresh Foam X 1080v13 - Talla 42 - Verde', 'Zapatillas premium New Balance con amortiguación Fresh Foam X de nueva generación. Máximo confort para largas distancias.', 139.87, 1, '2025-03-22 14:42:10.588', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (38, 72, 11, 'On Cloudsurfer', 'Zapatillas On Cloudsurfer con tecnología CloudTec para transición fluida. Ligeras y responsivas para ritmos medios y altos.', 141.77, 1, '2026-02-11 01:10:37.848', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (39, 96, 11, 'On Cloudsurfer - Talla 39 - Blanco', 'Zapatillas On Cloudsurfer con tecnología CloudTec para transición fluida. Ligeras y responsivas para ritmos medios y altos.', 147.00, 1, '2025-10-27 01:30:59.816', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (40, 73, 11, 'On Cloudsurfer - Talla 40 - Azul', 'Zapatillas On Cloudsurfer con tecnología CloudTec para transición fluida. Ligeras y responsivas para ritmos medios y altos.', 177.50, 0, '2025-09-19 13:52:55.007', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (41, 71, 11, 'On Cloudsurfer - Talla 41 - Rojo', 'Zapatillas On Cloudsurfer con tecnología CloudTec para transición fluida. Ligeras y responsivas para ritmos medios y altos.', 156.41, 1, '2025-08-21 01:21:47.819', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (42, 81, 11, 'On Cloudsurfer - Talla 42 - Verde', 'Zapatillas On Cloudsurfer con tecnología CloudTec para transición fluida. Ligeras y responsivas para ritmos medios y altos.', 145.68, 1, '2026-02-21 21:26:01.361', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (43, 60, 11, 'Salomon Speedcross 6', 'Zapatillas trail Salomon Speedcross 6 con suela agresiva Contagrip. Perfectas para terrenos blandos y embarrados.', 106.92, 1, '2025-02-26 06:35:31.963', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (44, 59, 11, 'Salomon Speedcross 6 - Talla 39 - Blanco', 'Zapatillas trail Salomon Speedcross 6 con suela agresiva Contagrip. Perfectas para terrenos blandos y embarrados.', 108.75, 0, '2025-10-03 12:45:21.914', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (45, 87, 11, 'Salomon Speedcross 6 - Talla 40 - Azul', 'Zapatillas trail Salomon Speedcross 6 con suela agresiva Contagrip. Perfectas para terrenos blandos y embarrados.', 107.97, 0, '2025-04-24 17:20:32.949', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (46, 68, 11, 'Salomon Speedcross 6 - Talla 41 - Rojo', 'Zapatillas trail Salomon Speedcross 6 con suela agresiva Contagrip. Perfectas para terrenos blandos y embarrados.', 111.72, 1, '2025-05-27 21:59:24.575', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (47, 60, 11, 'Salomon Speedcross 6 - Talla 42 - Verde', 'Zapatillas trail Salomon Speedcross 6 con suela agresiva Contagrip. Perfectas para terrenos blandos y embarrados.', 93.63, 1, '2025-02-12 13:30:45.034', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (48, 67, 11, 'Nike Vaporfly 3', 'Zapatillas de competición Nike Vaporfly 3 con placa de carbono. Para buscadores de récords personales en distancias largas.', 176.44, 0, '2025-09-10 03:00:32.501', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (49, 64, 11, 'Nike Vaporfly 3 - Talla 39 - Blanco', 'Zapatillas de competición Nike Vaporfly 3 con placa de carbono. Para buscadores de récords personales en distancias largas.', 195.30, 1, '2025-03-27 20:08:11.303', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (50, 85, 11, 'Nike Vaporfly 3 - Talla 40 - Azul', 'Zapatillas de competición Nike Vaporfly 3 con placa de carbono. Para buscadores de récords personales en distancias largas.', 160.15, 1, '2025-02-22 15:17:25.44', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (51, 79, 11, 'Nike Vaporfly 3 - Talla 41 - Rojo', 'Zapatillas de competición Nike Vaporfly 3 con placa de carbono. Para buscadores de récords personales en distancias largas.', 210.82, 0, '2025-02-17 02:43:16.56', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (52, 91, 11, 'Nike Vaporfly 3 - Talla 42 - Verde', 'Zapatillas de competición Nike Vaporfly 3 con placa de carbono. Para buscadores de récords personales en distancias largas.', 208.02, 1, '2025-02-26 03:54:15.754', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (53, 92, 11, 'Adidas Adizero Adios Pro 3', 'Zapatillas de élite Adidas con 5 varillas de carbono. Diseño para competición en maratón y media maratón.', 187.27, 0, '2025-04-09 12:09:54.981', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (54, 92, 11, 'Adidas Adizero Adios Pro 3 - Talla 39 - Blanco', 'Zapatillas de élite Adidas con 5 varillas de carbono. Diseño para competición en maratón y media maratón.', 172.08, 1, '2025-08-09 22:54:27.961', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (55, 59, 11, 'Adidas Adizero Adios Pro 3 - Talla 40 - Azul', 'Zapatillas de élite Adidas con 5 varillas de carbono. Diseño para competición en maratón y media maratón.', 193.46, 1, '2025-04-21 14:29:41.572', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (56, 85, 11, 'Adidas Adizero Adios Pro 3 - Talla 41 - Rojo', 'Zapatillas de élite Adidas con 5 varillas de carbono. Diseño para competición en maratón y media maratón.', 185.19, 1, '2025-11-27 20:21:12.468', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (57, 94, 11, 'Adidas Adizero Adios Pro 3 - Talla 42 - Verde', 'Zapatillas de élite Adidas con 5 varillas de carbono. Diseño para competición en maratón y media maratón.', 223.56, 1, '2025-01-20 06:32:10.991', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (58, 80, 11, 'Mizuno Wave Rider 27', 'Zapatillas neutras Mizuno Wave Rider 27 con placa Wave para estabilidad dinámica. Versatiles para entrenamientos variados.', 84.73, 1, '2025-08-21 07:28:12.001', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (59, 86, 11, 'Mizuno Wave Rider 27 - Talla 39 - Blanco', 'Zapatillas neutras Mizuno Wave Rider 27 con placa Wave para estabilidad dinámica. Versatiles para entrenamientos variados.', 93.26, 1, '2025-05-14 12:47:07.978', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (60, 85, 11, 'Mizuno Wave Rider 27 - Talla 40 - Azul', 'Zapatillas neutras Mizuno Wave Rider 27 con placa Wave para estabilidad dinámica. Versatiles para entrenamientos variados.', 93.49, 1, '2025-11-25 05:29:16.265', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (61, 85, 11, 'Mizuno Wave Rider 27 - Talla 41 - Rojo', 'Zapatillas neutras Mizuno Wave Rider 27 con placa Wave para estabilidad dinámica. Versatiles para entrenamientos variados.', 76.44, 0, '2025-02-24 08:18:40.448', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (62, 75, 11, 'Mizuno Wave Rider 27 - Talla 42 - Verde', 'Zapatillas neutras Mizuno Wave Rider 27 con placa Wave para estabilidad dinámica. Versatiles para entrenamientos variados.', 93.55, 1, '2026-03-21 02:20:10.641', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (63, 67, 11, 'Puma Deviate Nitro 2', 'Zapatillas Puma Deviate Nitro 2 con placa de carbono NITROFOAM. Excelente relación calidad-precio para competición.', 128.81, 1, '2025-12-23 16:14:34.432', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (64, 73, 11, 'Puma Deviate Nitro 2 - Talla 39 - Blanco', 'Zapatillas Puma Deviate Nitro 2 con placa de carbono NITROFOAM. Excelente relación calidad-precio para competición.', 129.15, 1, '2025-04-06 11:41:16.124', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (65, 74, 11, 'Puma Deviate Nitro 2 - Talla 40 - Azul', 'Zapatillas Puma Deviate Nitro 2 con placa de carbono NITROFOAM. Excelente relación calidad-precio para competición.', 120.08, 1, '2025-01-03 12:57:01.709', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (66, 85, 11, 'Puma Deviate Nitro 2 - Talla 41 - Rojo', 'Zapatillas Puma Deviate Nitro 2 con placa de carbono NITROFOAM. Excelente relación calidad-precio para competición.', 106.77, 1, '2025-06-08 07:28:23.452', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (67, 79, 11, 'Puma Deviate Nitro 2 - Talla 42 - Verde', 'Zapatillas Puma Deviate Nitro 2 con placa de carbono NITROFOAM. Excelente relación calidad-precio para competición.', 114.48, 1, '2025-02-01 23:18:17.948', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (68, 90, 11, 'Inov-8 Trailfly Ultra G 300', 'Zapatillas trail Inov-8 con grafeno en la suela para máxima durabilidad. Ideales para ultra trail en terrenos variados.', 183.06, 1, '2025-02-09 01:07:54.747', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (69, 89, 11, 'Inov-8 Trailfly Ultra G 300 - Talla 39 - Blanco', 'Zapatillas trail Inov-8 con grafeno en la suela para máxima durabilidad. Ideales para ultra trail en terrenos variados.', 150.90, 1, '2025-10-13 23:55:52.297', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (70, 83, 11, 'Inov-8 Trailfly Ultra G 300 - Talla 40 - Azul', 'Zapatillas trail Inov-8 con grafeno en la suela para máxima durabilidad. Ideales para ultra trail en terrenos variados.', 184.61, 1, '2025-05-06 19:28:24.482', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (71, 64, 11, 'Inov-8 Trailfly Ultra G 300 - Talla 41 - Rojo', 'Zapatillas trail Inov-8 con grafeno en la suela para máxima durabilidad. Ideales para ultra trail en terrenos variados.', 143.38, 1, '2025-06-04 03:15:28.439', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (72, 73, 11, 'Inov-8 Trailfly Ultra G 300 - Talla 42 - Verde', 'Zapatillas trail Inov-8 con grafeno en la suela para máxima durabilidad. Ideales para ultra trail en terrenos variados.', 142.04, 1, '2026-01-09 14:00:45.261', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (73, 92, 11, 'Altra Lone Peak 7', 'Zapatillas trail Altra con horma ancha y drop cero. Perfectas para corredores que buscan posición natural del pie.', 113.35, 1, '2026-02-05 18:10:53.533', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (74, 84, 11, 'Altra Lone Peak 7 - Talla 39 - Blanco', 'Zapatillas trail Altra con horma ancha y drop cero. Perfectas para corredores que buscan posición natural del pie.', 104.86, 1, '2025-10-07 23:06:52.528', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (75, 82, 11, 'Altra Lone Peak 7 - Talla 40 - Azul', 'Zapatillas trail Altra con horma ancha y drop cero. Perfectas para corredores que buscan posición natural del pie.', 110.76, 1, '2025-05-30 16:37:53.518', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (76, 95, 11, 'Altra Lone Peak 7 - Talla 41 - Rojo', 'Zapatillas trail Altra con horma ancha y drop cero. Perfectas para corredores que buscan posición natural del pie.', 102.42, 1, '2025-09-23 18:22:12.459', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (77, 76, 11, 'Altra Lone Peak 7 - Talla 42 - Verde', 'Zapatillas trail Altra con horma ancha y drop cero. Perfectas para corredores que buscan posición natural del pie.', 111.80, 0, '2025-10-29 12:42:45.228', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (78, 78, 11, 'Nike React Infinity Run 4', 'Zapatillas Nike React Infinity Run 4 diseñadas para reducir el riesgo de lesiones. Ideal para corredores con historial de lesiones.', 92.28, 1, '2026-03-31 21:10:59.004', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (79, 68, 11, 'Nike React Infinity Run 4 - Talla 39 - Blanco', 'Zapatillas Nike React Infinity Run 4 diseñadas para reducir el riesgo de lesiones. Ideal para corredores con historial de lesiones.', 98.22, 1, '2025-07-16 16:23:57.763', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (80, 77, 11, 'Nike React Infinity Run 4 - Talla 40 - Azul', 'Zapatillas Nike React Infinity Run 4 diseñadas para reducir el riesgo de lesiones. Ideal para corredores con historial de lesiones.', 100.99, 1, '2025-09-15 14:43:41.091', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (81, 77, 11, 'Nike React Infinity Run 4 - Talla 41 - Rojo', 'Zapatillas Nike React Infinity Run 4 diseñadas para reducir el riesgo de lesiones. Ideal para corredores con historial de lesiones.', 99.87, 0, '2025-08-04 15:20:18.014', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (82, 62, 11, 'Nike React Infinity Run 4 - Talla 42 - Verde', 'Zapatillas Nike React Infinity Run 4 diseñadas para reducir el riesgo de lesiones. Ideal para corredores con historial de lesiones.', 90.45, 1, '2025-06-21 01:20:31.609', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (83, 87, 11, 'Adidas Terrex Speed Ultra', 'Zapatillas trail Adidas Terrex Speed Ultra para competición en montaña. Ligeras, rápidas y con excelente agarre.', 144.03, 0, '2025-12-19 14:58:56.818', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (84, 72, 11, 'Adidas Terrex Speed Ultra - Talla 39 - Blanco', 'Zapatillas trail Adidas Terrex Speed Ultra para competición en montaña. Ligeras, rápidas y con excelente agarre.', 162.97, 1, '2025-12-22 08:32:32.02', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (85, 70, 11, 'Adidas Terrex Speed Ultra - Talla 40 - Azul', 'Zapatillas trail Adidas Terrex Speed Ultra para competición en montaña. Ligeras, rápidas y con excelente agarre.', 146.29, 1, '2026-01-01 12:46:43.17', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (86, 84, 11, 'Adidas Terrex Speed Ultra - Talla 41 - Rojo', 'Zapatillas trail Adidas Terrex Speed Ultra para competición en montaña. Ligeras, rápidas y con excelente agarre.', 161.72, 1, '2025-11-20 03:17:13.514', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (87, 69, 11, 'Adidas Terrex Speed Ultra - Talla 42 - Verde', 'Zapatillas trail Adidas Terrex Speed Ultra para competición en montaña. Ligeras, rápidas y con excelente agarre.', 162.17, 1, '2026-01-30 12:11:50.023', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (88, 60, 11, 'Hoka Speedgoat 5', 'Zapatillas trail Hoka Speedgoat 5 con máxima amortiguación para terrenos técnicos. Favoritas de los ultratraileros.', 150.78, 1, '2025-03-16 11:18:21.168', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (89, 69, 11, 'Hoka Speedgoat 5 - Talla 39 - Blanco', 'Zapatillas trail Hoka Speedgoat 5 con máxima amortiguación para terrenos técnicos. Favoritas de los ultratraileros.', 127.89, 0, '2025-04-14 05:56:44.813', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (90, 91, 11, 'Hoka Speedgoat 5 - Talla 40 - Azul', 'Zapatillas trail Hoka Speedgoat 5 con máxima amortiguación para terrenos técnicos. Favoritas de los ultratraileros.', 141.29, 1, '2025-03-19 10:30:57.116', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (91, 83, 11, 'Hoka Speedgoat 5 - Talla 41 - Rojo', 'Zapatillas trail Hoka Speedgoat 5 con máxima amortiguación para terrenos técnicos. Favoritas de los ultratraileros.', 156.30, 0, '2025-07-07 03:53:09.279', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (92, 73, 11, 'Hoka Speedgoat 5 - Talla 42 - Verde', 'Zapatillas trail Hoka Speedgoat 5 con máxima amortiguación para terrenos técnicos. Favoritas de los ultratraileros.', 148.22, 1, '2025-03-01 21:09:26.58', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (93, 82, 11, 'Scott Kinabalu 3', 'Zapatillas trail Scott Kinabalu 3 con placa de carbono para trail racing. Diseño agresivo para terrenos variados.', 161.13, 0, '2025-05-22 21:22:22.861', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (94, 89, 11, 'Scott Kinabalu 3 - Talla 39 - Blanco', 'Zapatillas trail Scott Kinabalu 3 con placa de carbono para trail racing. Diseño agresivo para terrenos variados.', 133.75, 1, '2025-09-05 14:18:00.51', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (95, 64, 11, 'Scott Kinabalu 3 - Talla 40 - Azul', 'Zapatillas trail Scott Kinabalu 3 con placa de carbono para trail racing. Diseño agresivo para terrenos variados.', 131.87, 1, '2026-02-04 14:38:15.869', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (96, 67, 11, 'Scott Kinabalu 3 - Talla 41 - Rojo', 'Zapatillas trail Scott Kinabalu 3 con placa de carbono para trail racing. Diseño agresivo para terrenos variados.', 166.75, 1, '2026-03-27 18:28:44.666', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (97, 93, 11, 'Scott Kinabalu 3 - Talla 42 - Verde', 'Zapatillas trail Scott Kinabalu 3 con placa de carbono para trail racing. Diseño agresivo para terrenos variados.', 158.66, 1, '2025-02-03 03:03:21.929', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (98, 64, 11, 'La Sportiva Jackal II', 'Zapatillas trail La Sportiva Jackal II ideales para skyrunning y carreras técnicas de montaña.', 130.13, 1, '2025-09-29 12:18:04.417', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (99, 59, 11, 'La Sportiva Jackal II - Talla 39 - Blanco', 'Zapatillas trail La Sportiva Jackal II ideales para skyrunning y carreras técnicas de montaña.', 127.24, 0, '2025-03-18 08:43:01.563', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (100, 59, 11, 'La Sportiva Jackal II - Talla 40 - Azul', 'Zapatillas trail La Sportiva Jackal II ideales para skyrunning y carreras técnicas de montaña.', 139.02, 1, '2025-06-10 21:40:23.958', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (101, 65, 11, 'La Sportiva Jackal II - Talla 41 - Rojo', 'Zapatillas trail La Sportiva Jackal II ideales para skyrunning y carreras técnicas de montaña.', 121.61, 1, '2025-02-11 20:15:42.952', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (102, 89, 11, 'La Sportiva Jackal II - Talla 42 - Verde', 'Zapatillas trail La Sportiva Jackal II ideales para skyrunning y carreras técnicas de montaña.', 150.61, 0, '2025-12-26 01:58:32.721', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (103, 87, 11, 'Merrell Agility Peak 5', 'Zapatillas trail Merrell Agility Peak 5 con suela Vibram y protección FloatPro. Versatilidad para todo tipo de terrenos.', 124.53, 1, '2025-05-12 07:45:16.11', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (104, 87, 11, 'Merrell Agility Peak 5 - Talla 39 - Blanco', 'Zapatillas trail Merrell Agility Peak 5 con suela Vibram y protección FloatPro. Versatilidad para todo tipo de terrenos.', 122.03, 1, '2025-12-25 07:12:33.323', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (105, 67, 11, 'Merrell Agility Peak 5 - Talla 40 - Azul', 'Zapatillas trail Merrell Agility Peak 5 con suela Vibram y protección FloatPro. Versatilidad para todo tipo de terrenos.', 110.29, 1, '2026-01-12 11:23:17.687', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (106, 71, 11, 'Merrell Agility Peak 5 - Talla 41 - Rojo', 'Zapatillas trail Merrell Agility Peak 5 con suela Vibram y protección FloatPro. Versatilidad para todo tipo de terrenos.', 122.57, 0, '2026-01-16 21:45:20.625', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (107, 72, 11, 'Merrell Agility Peak 5 - Talla 42 - Verde', 'Zapatillas trail Merrell Agility Peak 5 con suela Vibram y protección FloatPro. Versatilidad para todo tipo de terrenos.', 95.71, 0, '2025-11-09 14:39:42.199', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (108, 96, 12, 'Camiseta técnica Nike Dri-FIT', 'Camiseta de running Nike Dri-FIT con tecnología de gestión de humedad. Ligera y transpirable para entrenamientos intensos.', 24.62, 1, '2025-11-01 18:03:52.437', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (109, 82, 12, 'Camiseta técnica Nike Dri-FIT - Talla 39 - Blanco', 'Camiseta de running Nike Dri-FIT con tecnología de gestión de humedad. Ligera y transpirable para entrenamientos intensos.', 28.73, 1, '2025-08-15 10:25:07.735', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (110, 93, 12, 'Camiseta técnica Nike Dri-FIT - Talla 40 - Azul', 'Camiseta de running Nike Dri-FIT con tecnología de gestión de humedad. Ligera y transpirable para entrenamientos intensos.', 31.93, 1, '2025-04-09 20:30:53.024', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (111, 89, 12, 'Camiseta técnica Nike Dri-FIT - Talla 41 - Rojo', 'Camiseta de running Nike Dri-FIT con tecnología de gestión de humedad. Ligera y transpirable para entrenamientos intensos.', 32.03, 1, '2025-05-17 14:54:56.224', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (112, 64, 12, 'Camiseta técnica Nike Dri-FIT - Talla 42 - Verde', 'Camiseta de running Nike Dri-FIT con tecnología de gestión de humedad. Ligera y transpirable para entrenamientos intensos.', 24.67, 1, '2025-12-16 08:41:20.897', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (113, 85, 12, 'Mallas Adidas Techfit 3/4', 'Mallas 3/4 Adidas Techfit con compresión graduada. Soporte muscular durante el entrenamiento y recuperación activa.', 45.15, 1, '2025-01-09 07:50:55.694', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (114, 97, 12, 'Mallas Adidas Techfit 3/4 - Talla 39 - Blanco', 'Mallas 3/4 Adidas Techfit con compresión graduada. Soporte muscular durante el entrenamiento y recuperación activa.', 37.91, 0, '2025-08-03 08:46:34.512', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (115, 91, 12, 'Mallas Adidas Techfit 3/4 - Talla 40 - Azul', 'Mallas 3/4 Adidas Techfit con compresión graduada. Soporte muscular durante el entrenamiento y recuperación activa.', 44.10, 1, '2025-01-12 16:33:45.101', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (116, 67, 12, 'Mallas Adidas Techfit 3/4 - Talla 41 - Rojo', 'Mallas 3/4 Adidas Techfit con compresión graduada. Soporte muscular durante el entrenamiento y recuperación activa.', 46.31, 1, '2025-01-24 08:22:42.833', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (117, 64, 12, 'Mallas Adidas Techfit 3/4 - Talla 42 - Verde', 'Mallas 3/4 Adidas Techfit con compresión graduada. Soporte muscular durante el entrenamiento y recuperación activa.', 40.02, 1, '2025-05-13 13:37:36.299', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (118, 87, 12, 'Chaqueta cortavientos Brooks Run', 'Chaqueta cortavientos Brooks ligera y compacta. Protección contra el viento sin sacrificar transpirabilidad.', 71.49, 1, '2025-10-29 10:51:13.094', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (119, 81, 12, 'Chaqueta cortavientos Brooks Run - Talla 39 - Blanco', 'Chaqueta cortavientos Brooks ligera y compacta. Protección contra el viento sin sacrificar transpirabilidad.', 59.86, 1, '2025-06-11 10:53:50.56', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (120, 91, 12, 'Chaqueta cortavientos Brooks Run - Talla 40 - Azul', 'Chaqueta cortavientos Brooks ligera y compacta. Protección contra el viento sin sacrificar transpirabilidad.', 59.42, 1, '2025-07-28 11:56:11.869', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (121, 64, 12, 'Chaqueta cortavientos Brooks Run - Talla 41 - Rojo', 'Chaqueta cortavientos Brooks ligera y compacta. Protección contra el viento sin sacrificar transpirabilidad.', 73.40, 1, '2026-03-10 20:36:11.624', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (122, 63, 12, 'Chaqueta cortavientos Brooks Run - Talla 42 - Verde', 'Chaqueta cortavientos Brooks ligera y compacta. Protección contra el viento sin sacrificar transpirabilidad.', 56.08, 1, '2025-10-12 23:54:16.329', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (123, 78, 12, 'Shorts ASICS 2 en 1', 'Shorts de running ASICS con malla interior integrada. Comodidad y libertad de movimiento para entrenamientos de verano.', 32.26, 1, '2025-10-27 10:00:06.163', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (124, 93, 12, 'Shorts ASICS 2 en 1 - Talla 39 - Blanco', 'Shorts de running ASICS con malla interior integrada. Comodidad y libertad de movimiento para entrenamientos de verano.', 34.48, 0, '2026-01-26 02:32:08.816', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (125, 70, 12, 'Shorts ASICS 2 en 1 - Talla 40 - Azul', 'Shorts de running ASICS con malla interior integrada. Comodidad y libertad de movimiento para entrenamientos de verano.', 38.01, 0, '2025-01-02 12:24:31.228', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (126, 60, 12, 'Shorts ASICS 2 en 1 - Talla 41 - Rojo', 'Shorts de running ASICS con malla interior integrada. Comodidad y libertad de movimiento para entrenamientos de verano.', 30.08, 1, '2026-01-05 21:49:57.059', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (127, 65, 12, 'Shorts ASICS 2 en 1 - Talla 42 - Verde', 'Shorts de running ASICS con malla interior integrada. Comodidad y libertad de movimiento para entrenamientos de verano.', 35.23, 1, '2026-04-04 01:32:24.032', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (128, 65, 12, 'Top deportivo Salomon XA', 'Top de running Salomon con tecnología AdvancedSkin. Diseñado para trail running con bolsillo trasero integrado.', 40.80, 1, '2026-01-06 00:28:27.333', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (129, 80, 12, 'Top deportivo Salomon XA - Talla 39 - Blanco', 'Top de running Salomon con tecnología AdvancedSkin. Diseñado para trail running con bolsillo trasero integrado.', 40.98, 1, '2025-01-06 01:08:02.563', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (130, 84, 12, 'Top deportivo Salomon XA - Talla 40 - Azul', 'Top de running Salomon con tecnología AdvancedSkin. Diseñado para trail running con bolsillo trasero integrado.', 42.61, 1, '2025-09-02 01:32:33.515', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (131, 97, 12, 'Top deportivo Salomon XA - Talla 41 - Rojo', 'Top de running Salomon con tecnología AdvancedSkin. Diseñado para trail running con bolsillo trasero integrado.', 49.40, 1, '2025-08-28 21:48:26.665', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (132, 76, 12, 'Top deportivo Salomon XA - Talla 42 - Verde', 'Top de running Salomon con tecnología AdvancedSkin. Diseñado para trail running con bolsillo trasero integrado.', 41.95, 1, '2026-01-09 21:37:46.773', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (133, 84, 12, 'Mallas largas Hoka One One', 'Mallas de running Hoka con tejido técnico de compresión. Perfectas para entrenamientos en condiciones frías.', 71.39, 1, '2025-02-03 06:06:12.846', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (134, 81, 12, 'Mallas largas Hoka One One - Talla 39 - Blanco', 'Mallas de running Hoka con tejido técnico de compresión. Perfectas para entrenamientos en condiciones frías.', 69.94, 1, '2025-02-04 06:52:41.929', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (135, 81, 12, 'Mallas largas Hoka One One - Talla 40 - Azul', 'Mallas de running Hoka con tejido técnico de compresión. Perfectas para entrenamientos en condiciones frías.', 72.63, 1, '2025-02-27 17:45:49.241', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (136, 96, 12, 'Mallas largas Hoka One One - Talla 41 - Rojo', 'Mallas de running Hoka con tejido técnico de compresión. Perfectas para entrenamientos en condiciones frías.', 77.54, 1, '2025-02-17 22:43:03.432', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (137, 88, 12, 'Mallas largas Hoka One One - Talla 42 - Verde', 'Mallas de running Hoka con tejido técnico de compresión. Perfectas para entrenamientos en condiciones frías.', 82.17, 1, '2025-07-01 13:13:24.861', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (138, 92, 12, 'Camiseta sin mangas Saucony Freedom', 'Camiseta sin mangas Saucony con tejido FORMFIT. Máxima transpirabilidad para entrenamientos de alta intensidad.', 33.51, 1, '2025-12-29 19:46:52.621', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (139, 88, 12, 'Camiseta sin mangas Saucony Freedom - Talla 39 - Blanco', 'Camiseta sin mangas Saucony con tejido FORMFIT. Máxima transpirabilidad para entrenamientos de alta intensidad.', 36.23, 1, '2025-06-01 21:01:16.381', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (140, 61, 12, 'Camiseta sin mangas Saucony Freedom - Talla 40 - Azul', 'Camiseta sin mangas Saucony con tejido FORMFIT. Máxima transpirabilidad para entrenamientos de alta intensidad.', 28.76, 1, '2026-01-20 06:44:23.315', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (141, 93, 12, 'Camiseta sin mangas Saucony Freedom - Talla 41 - Rojo', 'Camiseta sin mangas Saucony con tejido FORMFIT. Máxima transpirabilidad para entrenamientos de alta intensidad.', 28.82, 1, '2025-04-29 23:20:16.121', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (142, 89, 12, 'Camiseta sin mangas Saucony Freedom - Talla 42 - Verde', 'Camiseta sin mangas Saucony con tejido FORMFIT. Máxima transpirabilidad para entrenamientos de alta intensidad.', 30.21, 0, '2025-09-29 16:19:04.469', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (143, 82, 12, 'Chaqueta impermeable Inov-8', 'Chaqueta impermeable Inov-8 ultraligera. Protección contra lluvia sin apenas añadir peso al equipamiento.', 81.46, 1, '2025-02-03 08:33:19.624', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (144, 92, 12, 'Chaqueta impermeable Inov-8 - Talla 39 - Blanco', 'Chaqueta impermeable Inov-8 ultraligera. Protección contra lluvia sin apenas añadir peso al equipamiento.', 84.97, 1, '2026-03-25 02:48:05.675', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (145, 63, 12, 'Chaqueta impermeable Inov-8 - Talla 40 - Azul', 'Chaqueta impermeable Inov-8 ultraligera. Protección contra lluvia sin apenas añadir peso al equipamiento.', 84.51, 0, '2025-09-26 11:39:07.221', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (146, 74, 12, 'Chaqueta impermeable Inov-8 - Talla 41 - Rojo', 'Chaqueta impermeable Inov-8 ultraligera. Protección contra lluvia sin apenas añadir peso al equipamiento.', 76.22, 1, '2025-12-30 19:54:15.504', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (147, 62, 12, 'Chaqueta impermeable Inov-8 - Talla 42 - Verde', 'Chaqueta impermeable Inov-8 ultraligera. Protección contra lluvia sin apenas añadir peso al equipamiento.', 73.13, 1, '2026-02-03 09:15:34.345', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (148, 77, 12, 'Gorro running New Balance', 'Gorro de running New Balance con visera y tecnología NB DRY. Protección solar y gestión del sudor.', 24.37, 1, '2025-05-05 16:21:12.051', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (149, 95, 12, 'Gorro running New Balance - Talla 39 - Blanco', 'Gorro de running New Balance con visera y tecnología NB DRY. Protección solar y gestión del sudor.', 19.24, 1, '2025-11-01 04:12:29.156', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (150, 64, 12, 'Gorro running New Balance - Talla 40 - Azul', 'Gorro de running New Balance con visera y tecnología NB DRY. Protección solar y gestión del sudor.', 21.40, 1, '2025-03-08 23:58:38.315', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (151, 74, 12, 'Gorro running New Balance - Talla 41 - Rojo', 'Gorro de running New Balance con visera y tecnología NB DRY. Protección solar y gestión del sudor.', 24.35, 1, '2026-01-25 04:02:21.15', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (152, 77, 12, 'Gorro running New Balance - Talla 42 - Verde', 'Gorro de running New Balance con visera y tecnología NB DRY. Protección solar y gestión del sudor.', 24.10, 1, '2025-03-04 04:34:57.585', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (153, 60, 12, 'Medias de compresión CEP', 'Medias de compresión CEP para running y recuperación. Mejoran el retorno venoso y reducen la fatiga muscular.', 46.27, 1, '2025-05-01 10:31:06.852', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (154, 83, 12, 'Medias de compresión CEP - Talla 39 - Blanco', 'Medias de compresión CEP para running y recuperación. Mejoran el retorno venoso y reducen la fatiga muscular.', 44.47, 1, '2025-12-02 13:43:59.041', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (155, 73, 12, 'Medias de compresión CEP - Talla 40 - Azul', 'Medias de compresión CEP para running y recuperación. Mejoran el retorno venoso y reducen la fatiga muscular.', 50.71, 1, '2025-05-31 23:15:21.668', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (156, 90, 12, 'Medias de compresión CEP - Talla 41 - Rojo', 'Medias de compresión CEP para running y recuperación. Mejoran el retorno venoso y reducen la fatiga muscular.', 50.46, 0, '2025-03-18 14:48:47.579', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (157, 88, 12, 'Medias de compresión CEP - Talla 42 - Verde', 'Medias de compresión CEP para running y recuperación. Mejoran el retorno venoso y reducen la fatiga muscular.', 38.25, 1, '2025-10-20 04:13:27.464', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (158, 81, 12, 'Camiseta manga larga Odlo', 'Camiseta técnica de manga larga Odlo con tejido Ceramicool. Regulación térmica inteligente para entrenamientos fríos.', 54.20, 1, '2025-12-13 20:33:17.047', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (159, 64, 12, 'Camiseta manga larga Odlo - Talla 39 - Blanco', 'Camiseta técnica de manga larga Odlo con tejido Ceramicool. Regulación térmica inteligente para entrenamientos fríos.', 58.04, 1, '2025-03-17 13:35:23.238', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (160, 83, 12, 'Camiseta manga larga Odlo - Talla 40 - Azul', 'Camiseta técnica de manga larga Odlo con tejido Ceramicool. Regulación térmica inteligente para entrenamientos fríos.', 55.69, 1, '2025-03-22 01:02:03.563', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (161, 80, 12, 'Camiseta manga larga Odlo - Talla 41 - Rojo', 'Camiseta técnica de manga larga Odlo con tejido Ceramicool. Regulación térmica inteligente para entrenamientos fríos.', 53.50, 1, '2025-05-07 11:15:30.911', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (162, 82, 12, 'Camiseta manga larga Odlo - Talla 42 - Verde', 'Camiseta técnica de manga larga Odlo con tejido Ceramicool. Regulación térmica inteligente para entrenamientos fríos.', 56.67, 1, '2025-05-11 16:02:58.655', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (163, 68, 12, 'Shorts trail Salomon Agile', 'Shorts de trail Salomon Agile con bolsillos laterales integrados. Ligeros y funcionales para carreras por montaña.', 50.67, 1, '2025-08-01 23:30:00.889', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (164, 94, 12, 'Shorts trail Salomon Agile - Talla 39 - Blanco', 'Shorts de trail Salomon Agile con bolsillos laterales integrados. Ligeros y funcionales para carreras por montaña.', 50.24, 1, '2025-06-03 13:36:20.106', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (165, 79, 12, 'Shorts trail Salomon Agile - Talla 40 - Azul', 'Shorts de trail Salomon Agile con bolsillos laterales integrados. Ligeros y funcionales para carreras por montaña.', 62.31, 1, '2025-03-31 20:54:40.961', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (166, 63, 12, 'Shorts trail Salomon Agile - Talla 41 - Rojo', 'Shorts de trail Salomon Agile con bolsillos laterales integrados. Ligeros y funcionales para carreras por montaña.', 55.92, 1, '2025-03-30 16:58:12.35', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (167, 90, 12, 'Shorts trail Salomon Agile - Talla 42 - Verde', 'Shorts de trail Salomon Agile con bolsillos laterales integrados. Ligeros y funcionales para carreras por montaña.', 56.19, 0, '2025-07-30 13:58:26.971', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (168, 81, 12, 'Chaleco running Montane', 'Chaleco de running Montane Minimus ligero y versátil. Protección térmica sin limitar el movimiento.', 83.72, 1, '2025-02-27 00:11:05.626', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (169, 60, 12, 'Chaleco running Montane - Talla 39 - Blanco', 'Chaleco de running Montane Minimus ligero y versátil. Protección térmica sin limitar el movimiento.', 74.30, 1, '2025-05-16 13:25:44.05', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (170, 93, 12, 'Chaleco running Montane - Talla 40 - Azul', 'Chaleco de running Montane Minimus ligero y versátil. Protección térmica sin limitar el movimiento.', 66.48, 1, '2025-05-21 09:50:46.971', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (171, 73, 12, 'Chaleco running Montane - Talla 41 - Rojo', 'Chaleco de running Montane Minimus ligero y versátil. Protección térmica sin limitar el movimiento.', 78.53, 1, '2025-12-28 16:41:19.818', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (172, 97, 12, 'Chaleco running Montane - Talla 42 - Verde', 'Chaleco de running Montane Minimus ligero y versátil. Protección térmica sin limitar el movimiento.', 74.37, 0, '2026-01-19 10:15:59.77', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (173, 82, 12, 'Camiseta compresión Under Armour', 'Camiseta de compresión Under Armour HeatGear. Mantiene los músculos frescos y reduce la fatiga en entrenamientos intensos.', 34.72, 0, '2026-02-09 01:19:32.092', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (174, 93, 12, 'Camiseta compresión Under Armour - Talla 39 - Blanco', 'Camiseta de compresión Under Armour HeatGear. Mantiene los músculos frescos y reduce la fatiga en entrenamientos intensos.', 41.45, 1, '2025-12-23 03:03:27.188', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (175, 93, 12, 'Camiseta compresión Under Armour - Talla 40 - Azul', 'Camiseta de compresión Under Armour HeatGear. Mantiene los músculos frescos y reduce la fatiga en entrenamientos intensos.', 41.49, 0, '2025-08-09 12:59:25.889', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (176, 93, 12, 'Camiseta compresión Under Armour - Talla 41 - Rojo', 'Camiseta de compresión Under Armour HeatGear. Mantiene los músculos frescos y reduce la fatiga en entrenamientos intensos.', 43.00, 1, '2025-10-11 09:21:57.428', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (177, 74, 12, 'Camiseta compresión Under Armour - Talla 42 - Verde', 'Camiseta de compresión Under Armour HeatGear. Mantiene los músculos frescos y reduce la fatiga en entrenamientos intensos.', 37.78, 0, '2025-12-27 22:35:13.56', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (178, 64, 12, 'Mallas running Kalenji', 'Mallas de running Kalenji con tecnología de gestión de la humedad. Excelente relación calidad-precio para runners habituales.', 26.49, 1, '2025-05-18 01:53:44.103', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (179, 82, 12, 'Mallas running Kalenji - Talla 39 - Blanco', 'Mallas de running Kalenji con tecnología de gestión de la humedad. Excelente relación calidad-precio para runners habituales.', 21.46, 1, '2025-04-11 23:25:07.179', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (180, 90, 12, 'Mallas running Kalenji - Talla 40 - Azul', 'Mallas de running Kalenji con tecnología de gestión de la humedad. Excelente relación calidad-precio para runners habituales.', 23.40, 1, '2026-04-09 08:13:33.2', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (181, 75, 12, 'Mallas running Kalenji - Talla 41 - Rojo', 'Mallas de running Kalenji con tecnología de gestión de la humedad. Excelente relación calidad-precio para runners habituales.', 26.76, 1, '2025-08-06 15:19:31.506', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (182, 92, 12, 'Mallas running Kalenji - Talla 42 - Verde', 'Mallas de running Kalenji con tecnología de gestión de la humedad. Excelente relación calidad-precio para runners habituales.', 26.80, 1, '2025-02-07 11:03:24.112', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (183, 97, 13, 'Garmin Forerunner 255', 'GPS running Garmin Forerunner 255 con métricas avanzadas de entrenamiento. Batería de hasta 14 días en modo smartwatch.', 216.57, 1, '2025-03-28 22:26:41.16', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (184, 84, 13, 'Garmin Forerunner 255 - Talla 39 - Blanco', 'GPS running Garmin Forerunner 255 con métricas avanzadas de entrenamiento. Batería de hasta 14 días en modo smartwatch.', 211.04, 1, '2025-12-12 20:30:23.481', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (185, 74, 13, 'Garmin Forerunner 255 - Talla 40 - Azul', 'GPS running Garmin Forerunner 255 con métricas avanzadas de entrenamiento. Batería de hasta 14 días en modo smartwatch.', 229.91, 1, '2026-02-27 10:43:27.14', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (186, 91, 13, 'Garmin Forerunner 255 - Talla 41 - Rojo', 'GPS running Garmin Forerunner 255 con métricas avanzadas de entrenamiento. Batería de hasta 14 días en modo smartwatch.', 222.79, 1, '2025-09-14 07:32:35.21', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (187, 79, 13, 'Garmin Forerunner 255 - Talla 42 - Verde', 'GPS running Garmin Forerunner 255 con métricas avanzadas de entrenamiento. Batería de hasta 14 días en modo smartwatch.', 192.11, 1, '2025-12-17 03:41:49.836', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (188, 65, 13, 'Polar Vantage M2', 'Reloj multideporte Polar Vantage M2 con GPS integrado y sensor óptico de frecuencia cardiaca. Análisis detallado del entrenamiento.', 178.48, 1, '2025-09-19 07:58:33.765', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (189, 91, 13, 'Polar Vantage M2 - Talla 39 - Blanco', 'Reloj multideporte Polar Vantage M2 con GPS integrado y sensor óptico de frecuencia cardiaca. Análisis detallado del entrenamiento.', 174.90, 1, '2025-07-27 07:26:49.035', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (190, 81, 13, 'Polar Vantage M2 - Talla 40 - Azul', 'Reloj multideporte Polar Vantage M2 con GPS integrado y sensor óptico de frecuencia cardiaca. Análisis detallado del entrenamiento.', 209.55, 1, '2026-03-01 01:17:22.342', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (191, 65, 13, 'Polar Vantage M2 - Talla 41 - Rojo', 'Reloj multideporte Polar Vantage M2 con GPS integrado y sensor óptico de frecuencia cardiaca. Análisis detallado del entrenamiento.', 203.53, 1, '2026-01-01 22:42:50.325', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (192, 75, 13, 'Polar Vantage M2 - Talla 42 - Verde', 'Reloj multideporte Polar Vantage M2 con GPS integrado y sensor óptico de frecuencia cardiaca. Análisis detallado del entrenamiento.', 197.62, 1, '2025-07-25 14:27:30.915', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (193, 72, 13, 'Suunto 9 Peak Pro', 'Reloj GPS Suunto 9 Peak Pro con batería de hasta 300 horas. Diseñado para ultras y aventuras de larga duración.', 343.80, 0, '2025-08-30 17:23:35.266', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (194, 59, 13, 'Suunto 9 Peak Pro - Talla 39 - Blanco', 'Reloj GPS Suunto 9 Peak Pro con batería de hasta 300 horas. Diseñado para ultras y aventuras de larga duración.', 377.34, 1, '2025-08-11 14:27:15.8', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (195, 79, 13, 'Suunto 9 Peak Pro - Talla 40 - Azul', 'Reloj GPS Suunto 9 Peak Pro con batería de hasta 300 horas. Diseñado para ultras y aventuras de larga duración.', 390.68, 0, '2026-01-28 03:43:07.937', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (196, 70, 13, 'Suunto 9 Peak Pro - Talla 41 - Rojo', 'Reloj GPS Suunto 9 Peak Pro con batería de hasta 300 horas. Diseñado para ultras y aventuras de larga duración.', 327.45, 1, '2025-07-24 17:38:37.41', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (197, 86, 13, 'Suunto 9 Peak Pro - Talla 42 - Verde', 'Reloj GPS Suunto 9 Peak Pro con batería de hasta 300 horas. Diseñado para ultras y aventuras de larga duración.', 358.20, 1, '2025-02-22 15:19:13.292', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (198, 65, 13, 'Apple Watch Series 8', 'Apple Watch Series 8 con GPS y sensor de temperatura. Integración perfecta con apps de running para iPhone.', 283.17, 1, '2025-01-23 12:28:41.749', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (199, 83, 13, 'Apple Watch Series 8 - Talla 39 - Blanco', 'Apple Watch Series 8 con GPS y sensor de temperatura. Integración perfecta con apps de running para iPhone.', 259.83, 0, '2026-01-11 12:28:25.397', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (200, 72, 13, 'Apple Watch Series 8 - Talla 40 - Azul', 'Apple Watch Series 8 con GPS y sensor de temperatura. Integración perfecta con apps de running para iPhone.', 277.93, 0, '2025-11-03 19:14:14.751', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (201, 68, 13, 'Apple Watch Series 8 - Talla 41 - Rojo', 'Apple Watch Series 8 con GPS y sensor de temperatura. Integración perfecta con apps de running para iPhone.', 247.39, 1, '2025-06-24 12:15:12.039', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (202, 67, 13, 'Apple Watch Series 8 - Talla 42 - Verde', 'Apple Watch Series 8 con GPS y sensor de temperatura. Integración perfecta con apps de running para iPhone.', 312.98, 1, '2025-05-17 19:41:06.714', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (203, 67, 13, 'Garmin Fenix 7', 'Reloj multisport premium Garmin Fenix 7 con topografía integrada y mapas. Referencia para trail running y aventura.', 512.37, 1, '2025-05-12 17:53:22.402', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (204, 73, 13, 'Garmin Fenix 7 - Talla 39 - Blanco', 'Reloj multisport premium Garmin Fenix 7 con topografía integrada y mapas. Referencia para trail running y aventura.', 489.56, 0, '2026-04-02 22:27:52.185', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (205, 64, 13, 'Garmin Fenix 7 - Talla 40 - Azul', 'Reloj multisport premium Garmin Fenix 7 con topografía integrada y mapas. Referencia para trail running y aventura.', 439.69, 1, '2025-08-26 16:02:53.285', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (206, 91, 13, 'Garmin Fenix 7 - Talla 41 - Rojo', 'Reloj multisport premium Garmin Fenix 7 con topografía integrada y mapas. Referencia para trail running y aventura.', 400.40, 1, '2025-09-12 00:28:18.782', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (207, 84, 13, 'Garmin Fenix 7 - Talla 42 - Verde', 'Reloj multisport premium Garmin Fenix 7 con topografía integrada y mapas. Referencia para trail running y aventura.', 515.30, 1, '2025-08-16 02:20:58.477', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (208, 72, 13, 'Coros Pace 2', 'GPS running Coros Pace 2 ultraligero con 30 horas de batería en modo GPS. Excelente relación calidad-precio.', 146.01, 1, '2025-07-11 02:35:23.112', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (209, 85, 13, 'Coros Pace 2 - Talla 39 - Blanco', 'GPS running Coros Pace 2 ultraligero con 30 horas de batería en modo GPS. Excelente relación calidad-precio.', 151.30, 1, '2025-09-09 19:22:17.493', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (210, 84, 13, 'Coros Pace 2 - Talla 40 - Azul', 'GPS running Coros Pace 2 ultraligero con 30 horas de batería en modo GPS. Excelente relación calidad-precio.', 169.20, 1, '2025-08-12 07:31:55.22', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (211, 86, 13, 'Coros Pace 2 - Talla 41 - Rojo', 'GPS running Coros Pace 2 ultraligero con 30 horas de batería en modo GPS. Excelente relación calidad-precio.', 168.98, 0, '2025-11-26 17:01:31.314', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (212, 73, 13, 'Coros Pace 2 - Talla 42 - Verde', 'GPS running Coros Pace 2 ultraligero con 30 horas de batería en modo GPS. Excelente relación calidad-precio.', 135.81, 1, '2025-11-13 13:32:10.073', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (213, 59, 13, 'Wahoo TICKR X Monitor Cardiaco', 'Monitor de frecuencia cardiaca pectoral Wahoo TICKR X con memoria interna. Compatible con Bluetooth y ANT+.', 72.37, 1, '2025-07-18 02:32:41.624', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (214, 70, 13, 'Wahoo TICKR X Monitor Cardiaco - Talla 39 - Blanco', 'Monitor de frecuencia cardiaca pectoral Wahoo TICKR X con memoria interna. Compatible con Bluetooth y ANT+.', 61.84, 1, '2025-06-14 10:18:36.642', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (215, 75, 13, 'Wahoo TICKR X Monitor Cardiaco - Talla 40 - Azul', 'Monitor de frecuencia cardiaca pectoral Wahoo TICKR X con memoria interna. Compatible con Bluetooth y ANT+.', 64.89, 0, '2025-02-04 22:07:17.697', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (216, 86, 13, 'Wahoo TICKR X Monitor Cardiaco - Talla 41 - Rojo', 'Monitor de frecuencia cardiaca pectoral Wahoo TICKR X con memoria interna. Compatible con Bluetooth y ANT+.', 56.20, 0, '2026-02-07 22:08:53.061', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (217, 59, 13, 'Wahoo TICKR X Monitor Cardiaco - Talla 42 - Verde', 'Monitor de frecuencia cardiaca pectoral Wahoo TICKR X con memoria interna. Compatible con Bluetooth y ANT+.', 70.52, 1, '2025-05-23 04:05:49.62', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (218, 82, 13, 'Stryd Pod de Potencia Running', 'Sensor de potencia para running Stryd. Mide vatios en carrera para un entrenamiento más preciso y eficiente.', 188.35, 0, '2025-01-01 07:00:05.95', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (219, 59, 13, 'Stryd Pod de Potencia Running - Talla 39 - Blanco', 'Sensor de potencia para running Stryd. Mide vatios en carrera para un entrenamiento más preciso y eficiente.', 196.75, 1, '2025-07-27 04:01:47.074', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (220, 70, 13, 'Stryd Pod de Potencia Running - Talla 40 - Azul', 'Sensor de potencia para running Stryd. Mide vatios en carrera para un entrenamiento más preciso y eficiente.', 209.62, 1, '2025-06-26 07:28:50.203', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (221, 92, 13, 'Stryd Pod de Potencia Running - Talla 41 - Rojo', 'Sensor de potencia para running Stryd. Mide vatios en carrera para un entrenamiento más preciso y eficiente.', 197.03, 1, '2025-06-12 09:18:41.414', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (222, 63, 13, 'Stryd Pod de Potencia Running - Talla 42 - Verde', 'Sensor de potencia para running Stryd. Mide vatios en carrera para un entrenamiento más preciso y eficiente.', 169.98, 1, '2025-03-21 07:52:06.776', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (223, 82, 13, 'Aftershokz Aeropex', 'Auriculares de conducción ósea Aftershokz Aeropex. Escucha música mientras corres sin perder conciencia del entorno.', 102.33, 1, '2025-04-10 19:36:14.006', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (224, 70, 13, 'Aftershokz Aeropex - Talla 39 - Blanco', 'Auriculares de conducción ósea Aftershokz Aeropex. Escucha música mientras corres sin perder conciencia del entorno.', 90.56, 0, '2025-05-30 05:40:06.932', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (225, 85, 13, 'Aftershokz Aeropex - Talla 40 - Azul', 'Auriculares de conducción ósea Aftershokz Aeropex. Escucha música mientras corres sin perder conciencia del entorno.', 87.09, 1, '2025-06-05 01:37:35.024', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (226, 90, 13, 'Aftershokz Aeropex - Talla 41 - Rojo', 'Auriculares de conducción ósea Aftershokz Aeropex. Escucha música mientras corres sin perder conciencia del entorno.', 95.68, 1, '2026-01-13 09:24:00.325', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (227, 88, 13, 'Aftershokz Aeropex - Talla 42 - Verde', 'Auriculares de conducción ósea Aftershokz Aeropex. Escucha música mientras corres sin perder conciencia del entorno.', 100.94, 1, '2025-08-02 11:09:24.357', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (228, 63, 13, 'Garmin Forerunner 965', 'GPS running premium Garmin Forerunner 965 con pantalla AMOLED y mapas detallados. Lo mejor de Garmin para corredores.', 585.27, 1, '2026-04-04 22:55:04.632', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (229, 89, 13, 'Garmin Forerunner 965 - Talla 39 - Blanco', 'GPS running premium Garmin Forerunner 965 con pantalla AMOLED y mapas detallados. Lo mejor de Garmin para corredores.', 544.50, 0, '2025-01-03 03:45:50.21', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (230, 83, 13, 'Garmin Forerunner 965 - Talla 40 - Azul', 'GPS running premium Garmin Forerunner 965 con pantalla AMOLED y mapas detallados. Lo mejor de Garmin para corredores.', 542.74, 1, '2026-04-03 15:48:40.992', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (231, 65, 13, 'Garmin Forerunner 965 - Talla 41 - Rojo', 'GPS running premium Garmin Forerunner 965 con pantalla AMOLED y mapas detallados. Lo mejor de Garmin para corredores.', 471.37, 1, '2025-08-25 16:49:34.606', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (232, 89, 13, 'Garmin Forerunner 965 - Talla 42 - Verde', 'GPS running premium Garmin Forerunner 965 con pantalla AMOLED y mapas detallados. Lo mejor de Garmin para corredores.', 513.66, 1, '2025-10-24 16:54:03.318', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (233, 80, 13, 'Polar Grit X Pro', 'Reloj outdoor Polar Grit X Pro con mapas offline y brújula. Diseñado para aventuras extremas en montaña.', 360.39, 0, '2025-07-10 18:26:58.343', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (234, 88, 13, 'Polar Grit X Pro - Talla 39 - Blanco', 'Reloj outdoor Polar Grit X Pro con mapas offline y brújula. Diseñado para aventuras extremas en montaña.', 429.19, 0, '2025-05-26 00:58:14.252', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (235, 65, 13, 'Polar Grit X Pro - Talla 40 - Azul', 'Reloj outdoor Polar Grit X Pro con mapas offline y brújula. Diseñado para aventuras extremas en montaña.', 362.34, 1, '2026-04-11 06:08:47.359', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (236, 78, 13, 'Polar Grit X Pro - Talla 41 - Rojo', 'Reloj outdoor Polar Grit X Pro con mapas offline y brújula. Diseñado para aventuras extremas en montaña.', 404.87, 0, '2025-04-28 22:35:15.864', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (237, 65, 13, 'Polar Grit X Pro - Talla 42 - Verde', 'Reloj outdoor Polar Grit X Pro con mapas offline y brújula. Diseñado para aventuras extremas en montaña.', 366.86, 1, '2025-04-12 09:57:05.939', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (238, 64, 13, 'Garmin HRM-Pro Plus', 'Correa de frecuencia cardiaca Garmin HRM-Pro Plus con dinámica de carrera avanzada. Compatible con todos los GPS Garmin.', 104.60, 0, '2025-12-03 20:58:19.262', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (239, 70, 13, 'Garmin HRM-Pro Plus - Talla 39 - Blanco', 'Correa de frecuencia cardiaca Garmin HRM-Pro Plus con dinámica de carrera avanzada. Compatible con todos los GPS Garmin.', 102.01, 1, '2025-10-23 16:32:26.081', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (240, 66, 13, 'Garmin HRM-Pro Plus - Talla 40 - Azul', 'Correa de frecuencia cardiaca Garmin HRM-Pro Plus con dinámica de carrera avanzada. Compatible con todos los GPS Garmin.', 98.05, 1, '2025-09-28 06:25:11.428', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (241, 67, 13, 'Garmin HRM-Pro Plus - Talla 41 - Rojo', 'Correa de frecuencia cardiaca Garmin HRM-Pro Plus con dinámica de carrera avanzada. Compatible con todos los GPS Garmin.', 100.88, 1, '2026-02-10 11:05:25.224', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (242, 67, 13, 'Garmin HRM-Pro Plus - Talla 42 - Verde', 'Correa de frecuencia cardiaca Garmin HRM-Pro Plus con dinámica de carrera avanzada. Compatible con todos los GPS Garmin.', 104.53, 1, '2025-04-27 00:12:47.851', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (243, 75, 14, 'Salomon ADV Skin 12', 'Chaleco de hidratación Salomon ADV Skin 12 con 12L de capacidad. Diseño ergonómico para trail running de larga distancia.', 162.58, 0, '2025-03-19 11:03:16.556', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (244, 98, 14, 'Salomon ADV Skin 12 - Talla 39 - Blanco', 'Chaleco de hidratación Salomon ADV Skin 12 con 12L de capacidad. Diseño ergonómico para trail running de larga distancia.', 138.43, 1, '2025-07-25 21:41:36.803', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (245, 72, 14, 'Salomon ADV Skin 12 - Talla 40 - Azul', 'Chaleco de hidratación Salomon ADV Skin 12 con 12L de capacidad. Diseño ergonómico para trail running de larga distancia.', 157.15, 1, '2026-01-16 16:31:32.228', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (246, 77, 14, 'Salomon ADV Skin 12 - Talla 41 - Rojo', 'Chaleco de hidratación Salomon ADV Skin 12 con 12L de capacidad. Diseño ergonómico para trail running de larga distancia.', 123.67, 1, '2025-03-28 02:44:47.09', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (247, 97, 14, 'Salomon ADV Skin 12 - Talla 42 - Verde', 'Chaleco de hidratación Salomon ADV Skin 12 con 12L de capacidad. Diseño ergonómico para trail running de larga distancia.', 142.65, 1, '2025-08-16 03:10:41.611', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (248, 69, 14, 'Nathan VaporKrar 4L', 'Mochila de hidratación Nathan VaporKrar con 4L de capacidad. Ultraligera y ajustable para carreras de montaña.', 99.36, 1, '2026-02-21 17:40:30.09', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (249, 83, 14, 'Nathan VaporKrar 4L - Talla 39 - Blanco', 'Mochila de hidratación Nathan VaporKrar con 4L de capacidad. Ultraligera y ajustable para carreras de montaña.', 85.13, 0, '2025-04-10 04:40:56.096', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (250, 80, 14, 'Nathan VaporKrar 4L - Talla 40 - Azul', 'Mochila de hidratación Nathan VaporKrar con 4L de capacidad. Ultraligera y ajustable para carreras de montaña.', 109.48, 1, '2025-08-15 18:31:29.509', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (251, 93, 14, 'Nathan VaporKrar 4L - Talla 41 - Rojo', 'Mochila de hidratación Nathan VaporKrar con 4L de capacidad. Ultraligera y ajustable para carreras de montaña.', 108.25, 0, '2025-07-14 02:55:02.967', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (252, 79, 14, 'Nathan VaporKrar 4L - Talla 42 - Verde', 'Mochila de hidratación Nathan VaporKrar con 4L de capacidad. Ultraligera y ajustable para carreras de montaña.', 89.70, 1, '2025-05-20 16:30:19.517', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (253, 83, 14, 'Osprey Duro 6', 'Mochila trail Osprey Duro 6 con 6L de capacidad y depósito 2L incluido. Perfecta para rutas de media distancia.', 81.28, 1, '2025-03-24 08:14:12.733', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (254, 77, 14, 'Osprey Duro 6 - Talla 39 - Blanco', 'Mochila trail Osprey Duro 6 con 6L de capacidad y depósito 2L incluido. Perfecta para rutas de media distancia.', 93.18, 1, '2025-10-31 18:20:24.085', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (255, 68, 14, 'Osprey Duro 6 - Talla 40 - Azul', 'Mochila trail Osprey Duro 6 con 6L de capacidad y depósito 2L incluido. Perfecta para rutas de media distancia.', 83.29, 1, '2025-10-26 10:10:30.135', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (256, 90, 14, 'Osprey Duro 6 - Talla 41 - Rojo', 'Mochila trail Osprey Duro 6 con 6L de capacidad y depósito 2L incluido. Perfecta para rutas de media distancia.', 85.91, 1, '2025-09-22 17:58:57.861', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (257, 69, 14, 'Osprey Duro 6 - Talla 42 - Verde', 'Mochila trail Osprey Duro 6 con 6L de capacidad y depósito 2L incluido. Perfecta para rutas de media distancia.', 86.70, 1, '2026-02-19 05:23:06.974', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (258, 65, 14, 'Ultimate Direction Adventure Vesta 6.0', 'Chaleco de hidratación Ultimate Direction con 6L de capacidad. Diseñado con los mejores ultramaratonistas del mundo.', 176.13, 0, '2025-02-07 18:58:30.433', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (259, 69, 14, 'Ultimate Direction Adventure Vesta 6.0 - Talla 39 - Blanco', 'Chaleco de hidratación Ultimate Direction con 6L de capacidad. Diseñado con los mejores ultramaratonistas del mundo.', 189.61, 0, '2025-10-02 16:37:01.341', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (260, 78, 14, 'Ultimate Direction Adventure Vesta 6.0 - Talla 40 - Azul', 'Chaleco de hidratación Ultimate Direction con 6L de capacidad. Diseñado con los mejores ultramaratonistas del mundo.', 181.19, 1, '2025-05-05 22:59:57.237', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (261, 90, 14, 'Ultimate Direction Adventure Vesta 6.0 - Talla 41 - Rojo', 'Chaleco de hidratación Ultimate Direction con 6L de capacidad. Diseñado con los mejores ultramaratonistas del mundo.', 162.81, 1, '2026-02-21 11:31:45.319', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (262, 85, 14, 'Ultimate Direction Adventure Vesta 6.0 - Talla 42 - Verde', 'Chaleco de hidratación Ultimate Direction con 6L de capacidad. Diseñado con los mejores ultramaratonistas del mundo.', 181.59, 1, '2026-02-15 03:19:08.389', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (263, 78, 14, 'Raidlight Responsiv 6L', 'Chaleco trail Raidlight Responsiv con 6L de capacidad. Fabricado en Francia con materiales reciclados.', 112.55, 1, '2025-01-04 00:00:51.429', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (264, 61, 14, 'Raidlight Responsiv 6L - Talla 39 - Blanco', 'Chaleco trail Raidlight Responsiv con 6L de capacidad. Fabricado en Francia con materiales reciclados.', 95.51, 1, '2025-09-24 15:42:10.636', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (265, 87, 14, 'Raidlight Responsiv 6L - Talla 40 - Azul', 'Chaleco trail Raidlight Responsiv con 6L de capacidad. Fabricado en Francia con materiales reciclados.', 115.43, 0, '2026-04-06 16:21:00.22', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (266, 75, 14, 'Raidlight Responsiv 6L - Talla 41 - Rojo', 'Chaleco trail Raidlight Responsiv con 6L de capacidad. Fabricado en Francia con materiales reciclados.', 99.26, 0, '2025-04-19 16:07:35.973', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (267, 89, 14, 'Raidlight Responsiv 6L - Talla 42 - Verde', 'Chaleco trail Raidlight Responsiv con 6L de capacidad. Fabricado en Francia con materiales reciclados.', 99.53, 0, '2025-08-17 22:56:01.555', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (268, 87, 14, 'CamelBak Circuit Run 1.5L', 'Mochila de hidratación CamelBak Circuit con depósito 1.5L. Compacta y estable para entrenamientos y rutas cortas.', 49.03, 1, '2026-04-09 04:16:45.033', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (269, 67, 14, 'CamelBak Circuit Run 1.5L - Talla 39 - Blanco', 'Mochila de hidratación CamelBak Circuit con depósito 1.5L. Compacta y estable para entrenamientos y rutas cortas.', 56.48, 1, '2025-12-06 21:38:31.183', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (270, 89, 14, 'CamelBak Circuit Run 1.5L - Talla 40 - Azul', 'Mochila de hidratación CamelBak Circuit con depósito 1.5L. Compacta y estable para entrenamientos y rutas cortas.', 54.20, 1, '2025-01-27 12:59:59.963', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (271, 88, 14, 'CamelBak Circuit Run 1.5L - Talla 41 - Rojo', 'Mochila de hidratación CamelBak Circuit con depósito 1.5L. Compacta y estable para entrenamientos y rutas cortas.', 49.29, 1, '2025-08-18 12:20:55.91', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (272, 84, 14, 'CamelBak Circuit Run 1.5L - Talla 42 - Verde', 'Mochila de hidratación CamelBak Circuit con depósito 1.5L. Compacta y estable para entrenamientos y rutas cortas.', 52.61, 1, '2026-02-18 15:26:45.327', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (273, 70, 14, 'Black Diamond Distance 15L', 'Mochila trail Black Diamond Distance 15L con paneles portapalos. Para aventuras largas en montaña con todo el material.', 106.34, 0, '2025-12-28 03:46:31.379', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (274, 91, 14, 'Black Diamond Distance 15L - Talla 39 - Blanco', 'Mochila trail Black Diamond Distance 15L con paneles portapalos. Para aventuras largas en montaña con todo el material.', 122.25, 1, '2025-02-12 08:56:55.633', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (275, 60, 14, 'Black Diamond Distance 15L - Talla 40 - Azul', 'Mochila trail Black Diamond Distance 15L con paneles portapalos. Para aventuras largas en montaña con todo el material.', 117.12, 1, '2025-05-17 02:49:41.84', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (276, 91, 14, 'Black Diamond Distance 15L - Talla 41 - Rojo', 'Mochila trail Black Diamond Distance 15L con paneles portapalos. Para aventuras largas en montaña con todo el material.', 122.88, 1, '2026-04-10 22:10:32.468', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (277, 67, 14, 'Black Diamond Distance 15L - Talla 42 - Verde', 'Mochila trail Black Diamond Distance 15L con paneles portapalos. Para aventuras largas en montaña con todo el material.', 128.08, 0, '2026-03-24 20:07:38.201', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (278, 69, 14, 'Inov-8 Race Ultra 10L', 'Chaleco de carrera Inov-8 Race Ultra con 10L de capacidad. Ligero y funcional para ultra trail con equipamiento completo.', 123.89, 1, '2025-05-01 05:59:11.298', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (279, 86, 14, 'Inov-8 Race Ultra 10L - Talla 39 - Blanco', 'Chaleco de carrera Inov-8 Race Ultra con 10L de capacidad. Ligero y funcional para ultra trail con equipamiento completo.', 131.20, 1, '2025-02-06 14:02:25.938', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (280, 90, 14, 'Inov-8 Race Ultra 10L - Talla 40 - Azul', 'Chaleco de carrera Inov-8 Race Ultra con 10L de capacidad. Ligero y funcional para ultra trail con equipamiento completo.', 152.05, 0, '2026-01-02 22:06:11.816', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (281, 73, 14, 'Inov-8 Race Ultra 10L - Talla 41 - Rojo', 'Chaleco de carrera Inov-8 Race Ultra con 10L de capacidad. Ligero y funcional para ultra trail con equipamiento completo.', 131.38, 1, '2025-08-17 07:26:23.065', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (282, 81, 14, 'Inov-8 Race Ultra 10L - Talla 42 - Verde', 'Chaleco de carrera Inov-8 Race Ultra con 10L de capacidad. Ligero y funcional para ultra trail con equipamiento completo.', 147.28, 1, '2025-04-15 08:49:43.539', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (283, 86, 14, 'Hydrapak Softflask 500ml', 'Botella blanda Hydrapak 500ml plegable. Ideal para llevar en chalecos de hidratación durante carreras y entrenamientos.', 19.29, 1, '2025-07-24 03:21:41.461', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (284, 77, 14, 'Hydrapak Softflask 500ml - Talla 39 - Blanco', 'Botella blanda Hydrapak 500ml plegable. Ideal para llevar en chalecos de hidratación durante carreras y entrenamientos.', 18.76, 1, '2025-05-10 18:58:12.732', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (285, 93, 14, 'Hydrapak Softflask 500ml - Talla 40 - Azul', 'Botella blanda Hydrapak 500ml plegable. Ideal para llevar en chalecos de hidratación durante carreras y entrenamientos.', 16.36, 0, '2025-07-22 04:51:07.359', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (286, 64, 14, 'Hydrapak Softflask 500ml - Talla 41 - Rojo', 'Botella blanda Hydrapak 500ml plegable. Ideal para llevar en chalecos de hidratación durante carreras y entrenamientos.', 16.29, 1, '2025-12-09 04:45:42.781', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (287, 75, 14, 'Hydrapak Softflask 500ml - Talla 42 - Verde', 'Botella blanda Hydrapak 500ml plegable. Ideal para llevar en chalecos de hidratación durante carreras y entrenamientos.', 15.61, 1, '2025-10-22 21:43:31.206', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (288, 74, 15, 'Petzl Actik Core Frontal', 'Frontal de running Petzl Actik Core con 450 lúmenes y batería recargable. Ideal para entrenamientos nocturnos y trail.', 62.59, 1, '2025-09-19 06:40:25.486', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (289, 70, 15, 'Petzl Actik Core Frontal - Talla 39 - Blanco', 'Frontal de running Petzl Actik Core con 450 lúmenes y batería recargable. Ideal para entrenamientos nocturnos y trail.', 49.61, 1, '2025-11-25 10:51:31.815', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (290, 72, 15, 'Petzl Actik Core Frontal - Talla 40 - Azul', 'Frontal de running Petzl Actik Core con 450 lúmenes y batería recargable. Ideal para entrenamientos nocturnos y trail.', 50.21, 1, '2026-02-24 18:43:48.377', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (291, 91, 15, 'Petzl Actik Core Frontal - Talla 41 - Rojo', 'Frontal de running Petzl Actik Core con 450 lúmenes y batería recargable. Ideal para entrenamientos nocturnos y trail.', 50.34, 1, '2025-12-18 08:23:54.26', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (292, 72, 15, 'Petzl Actik Core Frontal - Talla 42 - Verde', 'Frontal de running Petzl Actik Core con 450 lúmenes y batería recargable. Ideal para entrenamientos nocturnos y trail.', 49.78, 1, '2025-08-19 08:17:38.564', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (293, 85, 15, 'Buff Original Coolnet UV+', 'Multifuncional Buff Coolnet con protección UV+. Versatil para running, trail y actividades al aire libre.', 19.69, 1, '2025-03-31 03:10:38.558', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (294, 77, 15, 'Buff Original Coolnet UV+ - Talla 39 - Blanco', 'Multifuncional Buff Coolnet con protección UV+. Versatil para running, trail y actividades al aire libre.', 22.53, 1, '2026-03-26 16:27:40.886', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (295, 90, 15, 'Buff Original Coolnet UV+ - Talla 40 - Azul', 'Multifuncional Buff Coolnet con protección UV+. Versatil para running, trail y actividades al aire libre.', 25.16, 1, '2025-05-30 06:52:49.175', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (296, 59, 15, 'Buff Original Coolnet UV+ - Talla 41 - Rojo', 'Multifuncional Buff Coolnet con protección UV+. Versatil para running, trail y actividades al aire libre.', 19.81, 0, '2025-01-17 00:21:46.429', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (297, 71, 15, 'Buff Original Coolnet UV+ - Talla 42 - Verde', 'Multifuncional Buff Coolnet con protección UV+. Versatil para running, trail y actividades al aire libre.', 24.34, 1, '2025-06-02 21:29:08.807', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (298, 88, 15, 'Compressport Cinturón de Hidratación', 'Cinturón de hidratación Compressport con 3 portabotellas. Estable y cómodo para carreras de media distancia.', 39.63, 0, '2025-01-04 12:49:08.83', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (299, 62, 15, 'Compressport Cinturón de Hidratación - Talla 39 - Blanco', 'Cinturón de hidratación Compressport con 3 portabotellas. Estable y cómodo para carreras de media distancia.', 33.47, 1, '2025-05-03 01:30:29.38', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (300, 65, 15, 'Compressport Cinturón de Hidratación - Talla 40 - Azul', 'Cinturón de hidratación Compressport con 3 portabotellas. Estable y cómodo para carreras de media distancia.', 43.53, 1, '2025-03-18 02:37:41.197', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (301, 59, 15, 'Compressport Cinturón de Hidratación - Talla 41 - Rojo', 'Cinturón de hidratación Compressport con 3 portabotellas. Estable y cómodo para carreras de media distancia.', 40.58, 0, '2025-09-23 07:02:42.907', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (302, 74, 15, 'Compressport Cinturón de Hidratación - Talla 42 - Verde', 'Cinturón de hidratación Compressport con 3 portabotellas. Estable y cómodo para carreras de media distancia.', 40.66, 1, '2025-03-29 20:16:18.718', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (303, 68, 15, 'Black Diamond Spot 400 Frontal', 'Frontal Black Diamond Spot 400 lúmenes con PowerTap Technology. Resistente al agua IPX8 para cualquier condición.', 37.38, 1, '2025-08-19 01:17:47.974', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (304, 83, 15, 'Black Diamond Spot 400 Frontal - Talla 39 - Blanco', 'Frontal Black Diamond Spot 400 lúmenes con PowerTap Technology. Resistente al agua IPX8 para cualquier condición.', 35.88, 1, '2026-02-23 14:53:25.324', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (305, 76, 15, 'Black Diamond Spot 400 Frontal - Talla 40 - Azul', 'Frontal Black Diamond Spot 400 lúmenes con PowerTap Technology. Resistente al agua IPX8 para cualquier condición.', 40.76, 1, '2026-03-14 23:06:34.383', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (306, 72, 15, 'Black Diamond Spot 400 Frontal - Talla 41 - Rojo', 'Frontal Black Diamond Spot 400 lúmenes con PowerTap Technology. Resistente al agua IPX8 para cualquier condición.', 35.80, 0, '2025-08-08 00:23:53.847', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (307, 66, 15, 'Black Diamond Spot 400 Frontal - Talla 42 - Verde', 'Frontal Black Diamond Spot 400 lúmenes con PowerTap Technology. Resistente al agua IPX8 para cualquier condición.', 36.77, 1, '2026-02-20 01:19:54.098', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (308, 97, 15, 'Sidas 3Feet Pulse Mid Plantillas', 'Plantillas de running Sidas 3Feet con soporte de arco dinámico. Reducen el impacto y mejoran la eficiencia de carrera.', 36.65, 1, '2025-10-16 07:25:32.735', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (309, 60, 15, 'Sidas 3Feet Pulse Mid Plantillas - Talla 39 - Blanco', 'Plantillas de running Sidas 3Feet con soporte de arco dinámico. Reducen el impacto y mejoran la eficiencia de carrera.', 34.99, 1, '2025-06-24 10:37:44.706', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (310, 80, 15, 'Sidas 3Feet Pulse Mid Plantillas - Talla 40 - Azul', 'Plantillas de running Sidas 3Feet con soporte de arco dinámico. Reducen el impacto y mejoran la eficiencia de carrera.', 38.54, 1, '2025-11-28 08:19:37.066', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (311, 95, 15, 'Sidas 3Feet Pulse Mid Plantillas - Talla 41 - Rojo', 'Plantillas de running Sidas 3Feet con soporte de arco dinámico. Reducen el impacto y mejoran la eficiencia de carrera.', 32.86, 1, '2025-08-19 20:55:20.454', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (312, 88, 15, 'Sidas 3Feet Pulse Mid Plantillas - Talla 42 - Verde', 'Plantillas de running Sidas 3Feet con soporte de arco dinámico. Reducen el impacto y mejoran la eficiencia de carrera.', 37.52, 1, '2025-11-19 05:46:25.781', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (313, 76, 15, 'Flipbelt Cinturón Running', 'Cinturón de running Flipbelt sin rebotes para llevar móvil, llaves y geles. Compatible con todos los tamaños de smartphones.', 33.41, 0, '2025-05-04 02:10:17.881', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (314, 83, 15, 'Flipbelt Cinturón Running - Talla 39 - Blanco', 'Cinturón de running Flipbelt sin rebotes para llevar móvil, llaves y geles. Compatible con todos los tamaños de smartphones.', 30.21, 1, '2025-04-04 14:14:26.26', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (315, 72, 15, 'Flipbelt Cinturón Running - Talla 40 - Azul', 'Cinturón de running Flipbelt sin rebotes para llevar móvil, llaves y geles. Compatible con todos los tamaños de smartphones.', 29.66, 1, '2026-01-19 17:43:32.698', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (316, 82, 15, 'Flipbelt Cinturón Running - Talla 41 - Rojo', 'Cinturón de running Flipbelt sin rebotes para llevar móvil, llaves y geles. Compatible con todos los tamaños de smartphones.', 27.91, 1, '2025-08-14 18:40:11.271', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (317, 60, 15, 'Flipbelt Cinturón Running - Talla 42 - Verde', 'Cinturón de running Flipbelt sin rebotes para llevar móvil, llaves y geles. Compatible con todos los tamaños de smartphones.', 29.18, 1, '2025-11-26 17:41:16.03', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (318, 94, 15, 'Bastones Leki Ultratrail FX One', 'Bastones plegables Leki Ultratrail FX One ultraligeros. Imprescindibles para carreras de montaña con mucho desnivel.', 156.11, 1, '2025-10-24 19:36:13.729', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (319, 76, 15, 'Bastones Leki Ultratrail FX One - Talla 39 - Blanco', 'Bastones plegables Leki Ultratrail FX One ultraligeros. Imprescindibles para carreras de montaña con mucho desnivel.', 124.20, 0, '2026-03-30 11:07:13.4', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (320, 96, 15, 'Bastones Leki Ultratrail FX One - Talla 40 - Azul', 'Bastones plegables Leki Ultratrail FX One ultraligeros. Imprescindibles para carreras de montaña con mucho desnivel.', 132.21, 1, '2025-06-15 11:43:15.226', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (321, 61, 15, 'Bastones Leki Ultratrail FX One - Talla 41 - Rojo', 'Bastones plegables Leki Ultratrail FX One ultraligeros. Imprescindibles para carreras de montaña con mucho desnivel.', 148.01, 1, '2025-03-10 08:12:39.512', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (322, 63, 15, 'Bastones Leki Ultratrail FX One - Talla 42 - Verde', 'Bastones plegables Leki Ultratrail FX One ultraligeros. Imprescindibles para carreras de montaña con mucho desnivel.', 162.99, 1, '2025-10-27 04:09:46.77', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (323, 92, 15, 'Gaiters Dirty Girl Trail', 'Polainas cortas Dirty Girl para trail running. Evitan la entrada de piedras y suciedad en las zapatillas.', 26.09, 1, '2025-07-26 03:44:24.099', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (324, 90, 15, 'Gaiters Dirty Girl Trail - Talla 39 - Blanco', 'Polainas cortas Dirty Girl para trail running. Evitan la entrada de piedras y suciedad en las zapatillas.', 28.73, 1, '2025-01-02 04:01:40.907', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (325, 64, 15, 'Gaiters Dirty Girl Trail - Talla 40 - Azul', 'Polainas cortas Dirty Girl para trail running. Evitan la entrada de piedras y suciedad en las zapatillas.', 22.96, 1, '2025-03-21 06:22:08.089', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (326, 77, 15, 'Gaiters Dirty Girl Trail - Talla 41 - Rojo', 'Polainas cortas Dirty Girl para trail running. Evitan la entrada de piedras y suciedad en las zapatillas.', 26.72, 1, '2025-09-12 20:24:19.164', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (327, 88, 15, 'Gaiters Dirty Girl Trail - Talla 42 - Verde', 'Polainas cortas Dirty Girl para trail running. Evitan la entrada de piedras y suciedad en las zapatillas.', 24.73, 1, '2025-10-19 11:24:58.242', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (328, 82, 15, 'Nathan Brazalete Porta Móvil', 'Brazalete porta móvil Nathan para running. Ajustable y compatible con pantallas táctiles.', 20.13, 0, '2025-11-09 04:00:49.238', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (329, 92, 15, 'Nathan Brazalete Porta Móvil - Talla 39 - Blanco', 'Brazalete porta móvil Nathan para running. Ajustable y compatible con pantallas táctiles.', 18.57, 1, '2025-10-05 19:14:12.928', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (330, 85, 15, 'Nathan Brazalete Porta Móvil - Talla 40 - Azul', 'Brazalete porta móvil Nathan para running. Ajustable y compatible con pantallas táctiles.', 19.93, 1, '2025-10-15 12:27:12.035', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (331, 66, 15, 'Nathan Brazalete Porta Móvil - Talla 41 - Rojo', 'Brazalete porta móvil Nathan para running. Ajustable y compatible con pantallas táctiles.', 15.50, 0, '2025-03-03 12:36:01.393', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (332, 87, 15, 'Nathan Brazalete Porta Móvil - Talla 42 - Verde', 'Brazalete porta móvil Nathan para running. Ajustable y compatible con pantallas táctiles.', 15.48, 0, '2025-02-23 01:03:15.564', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (333, 81, 15, 'Squirrel Nut Butter Antifricción', 'Crema antifricción Squirrel Nut Butter para prevenir rozaduras durante carreras largas. Formato de bolsillo para llevar en ruta.', 10.52, 1, '2025-01-18 00:12:28.297', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (334, 91, 15, 'Squirrel Nut Butter Antifricción - Talla 39 - Blanco', 'Crema antifricción Squirrel Nut Butter para prevenir rozaduras durante carreras largas. Formato de bolsillo para llevar en ruta.', 13.21, 1, '2025-01-06 09:18:15.936', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (335, 73, 15, 'Squirrel Nut Butter Antifricción - Talla 40 - Azul', 'Crema antifricción Squirrel Nut Butter para prevenir rozaduras durante carreras largas. Formato de bolsillo para llevar en ruta.', 13.05, 1, '2025-01-03 15:27:03.02', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (336, 74, 15, 'Squirrel Nut Butter Antifricción - Talla 41 - Rojo', 'Crema antifricción Squirrel Nut Butter para prevenir rozaduras durante carreras largas. Formato de bolsillo para llevar en ruta.', 11.80, 1, '2025-12-27 21:45:01.37', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (337, 94, 15, 'Squirrel Nut Butter Antifricción - Talla 42 - Verde', 'Crema antifricción Squirrel Nut Butter para prevenir rozaduras durante carreras largas. Formato de bolsillo para llevar en ruta.', 10.67, 0, '2026-04-10 17:56:18.431', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (338, 60, 16, 'SIS Beta Fuel Gel Energético x10', 'Pack de 10 geles energéticos SIS Beta Fuel con 40g de carbohidratos. Fórmula sin gluten y de fácil digestión para esfuerzos largos.', 29.77, 1, '2025-01-07 14:25:54.474', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (339, 81, 16, 'SIS Beta Fuel Gel Energético x10 - Talla 39 - Blanco', 'Pack de 10 geles energéticos SIS Beta Fuel con 40g de carbohidratos. Fórmula sin gluten y de fácil digestión para esfuerzos largos.', 29.96, 1, '2025-04-04 00:51:28.231', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (340, 95, 16, 'SIS Beta Fuel Gel Energético x10 - Talla 40 - Azul', 'Pack de 10 geles energéticos SIS Beta Fuel con 40g de carbohidratos. Fórmula sin gluten y de fácil digestión para esfuerzos largos.', 25.51, 1, '2026-02-17 05:52:25.662', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (341, 82, 16, 'SIS Beta Fuel Gel Energético x10 - Talla 41 - Rojo', 'Pack de 10 geles energéticos SIS Beta Fuel con 40g de carbohidratos. Fórmula sin gluten y de fácil digestión para esfuerzos largos.', 30.51, 1, '2026-02-24 10:52:37.765', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (342, 65, 16, 'SIS Beta Fuel Gel Energético x10 - Talla 42 - Verde', 'Pack de 10 geles energéticos SIS Beta Fuel con 40g de carbohidratos. Fórmula sin gluten y de fácil digestión para esfuerzos largos.', 27.98, 1, '2025-05-27 05:41:41.467', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (343, 66, 16, 'Maurten Gel 100 x12', 'Pack 12 geles Maurten Gel 100 con tecnología Hydrogel. Máxima absorción sin problemas gastrointestinales.', 49.79, 1, '2026-01-21 09:58:50.626', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (344, 90, 16, 'Maurten Gel 100 x12 - Talla 39 - Blanco', 'Pack 12 geles Maurten Gel 100 con tecnología Hydrogel. Máxima absorción sin problemas gastrointestinales.', 52.57, 1, '2025-04-15 10:57:47.418', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (345, 72, 16, 'Maurten Gel 100 x12 - Talla 40 - Azul', 'Pack 12 geles Maurten Gel 100 con tecnología Hydrogel. Máxima absorción sin problemas gastrointestinales.', 49.51, 1, '2025-10-31 09:27:04.105', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (346, 79, 16, 'Maurten Gel 100 x12 - Talla 41 - Rojo', 'Pack 12 geles Maurten Gel 100 con tecnología Hydrogel. Máxima absorción sin problemas gastrointestinales.', 41.25, 1, '2025-04-13 22:22:19.285', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (347, 93, 16, 'Maurten Gel 100 x12 - Talla 42 - Verde', 'Pack 12 geles Maurten Gel 100 con tecnología Hydrogel. Máxima absorción sin problemas gastrointestinales.', 47.85, 1, '2025-11-30 07:43:37.747', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (348, 60, 16, 'High5 Energy Drink Mix 2.2kg', 'Bebida isotónica High5 en polvo formato 2.2kg. Electrolitos y carbohidratos para hidratación durante el ejercicio.', 32.59, 1, '2025-07-25 21:55:54.964', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (349, 90, 16, 'High5 Energy Drink Mix 2.2kg - Talla 39 - Blanco', 'Bebida isotónica High5 en polvo formato 2.2kg. Electrolitos y carbohidratos para hidratación durante el ejercicio.', 34.00, 1, '2026-03-19 03:52:15.944', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (350, 61, 16, 'High5 Energy Drink Mix 2.2kg - Talla 40 - Azul', 'Bebida isotónica High5 en polvo formato 2.2kg. Electrolitos y carbohidratos para hidratación durante el ejercicio.', 36.93, 1, '2025-05-10 04:08:03.389', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (351, 61, 16, 'High5 Energy Drink Mix 2.2kg - Talla 41 - Rojo', 'Bebida isotónica High5 en polvo formato 2.2kg. Electrolitos y carbohidratos para hidratación durante el ejercicio.', 33.99, 1, '2025-04-13 19:43:08.945', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (352, 78, 16, 'High5 Energy Drink Mix 2.2kg - Talla 42 - Verde', 'Bebida isotónica High5 en polvo formato 2.2kg. Electrolitos y carbohidratos para hidratación durante el ejercicio.', 37.04, 1, '2026-01-10 08:47:05.253', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (353, 89, 16, 'GU Energy Stroopwafel x16', 'Pack 16 barritas tipo waffle GU Energy. Sabor caramel coffee para reponer energía de forma sólida durante carreras.', 30.96, 1, '2025-12-22 01:47:06.127', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (354, 91, 16, 'GU Energy Stroopwafel x16 - Talla 39 - Blanco', 'Pack 16 barritas tipo waffle GU Energy. Sabor caramel coffee para reponer energía de forma sólida durante carreras.', 31.97, 0, '2026-01-04 21:16:23.152', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (355, 74, 16, 'GU Energy Stroopwafel x16 - Talla 40 - Azul', 'Pack 16 barritas tipo waffle GU Energy. Sabor caramel coffee para reponer energía de forma sólida durante carreras.', 27.60, 1, '2025-06-05 01:54:44.313', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (356, 82, 16, 'GU Energy Stroopwafel x16 - Talla 41 - Rojo', 'Pack 16 barritas tipo waffle GU Energy. Sabor caramel coffee para reponer energía de forma sólida durante carreras.', 30.07, 0, '2025-03-06 17:43:10.718', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (357, 74, 16, 'GU Energy Stroopwafel x16 - Talla 42 - Verde', 'Pack 16 barritas tipo waffle GU Energy. Sabor caramel coffee para reponer energía de forma sólida durante carreras.', 35.11, 1, '2025-07-19 10:33:12.498', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (358, 79, 16, 'Tailwind Nutrition 810g Mandarina', 'Bebida de carbohidratos y electrolitos Tailwind Nutrition. Todo en uno para hidratación y energía en ultras.', 47.28, 1, '2026-01-15 14:07:24.437', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (359, 80, 16, 'Tailwind Nutrition 810g Mandarina - Talla 39 - Blanco', 'Bebida de carbohidratos y electrolitos Tailwind Nutrition. Todo en uno para hidratación y energía en ultras.', 38.33, 1, '2025-04-14 14:31:28.159', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (360, 67, 16, 'Tailwind Nutrition 810g Mandarina - Talla 40 - Azul', 'Bebida de carbohidratos y electrolitos Tailwind Nutrition. Todo en uno para hidratación y energía en ultras.', 38.80, 1, '2026-02-19 11:53:48.817', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (361, 60, 16, 'Tailwind Nutrition 810g Mandarina - Talla 41 - Rojo', 'Bebida de carbohidratos y electrolitos Tailwind Nutrition. Todo en uno para hidratación y energía en ultras.', 36.64, 1, '2025-04-18 20:01:32.492', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (362, 77, 16, 'Tailwind Nutrition 810g Mandarina - Talla 42 - Verde', 'Bebida de carbohidratos y electrolitos Tailwind Nutrition. Todo en uno para hidratación y energía en ultras.', 37.63, 1, '2025-08-06 02:14:36.255', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (363, 77, 16, 'Clif Shot Bloks x18', 'Pack 18 gominolas energéticas Clif Shot Bloks con 50mg cafeína. Fáciles de masticar y digerir en carrera.', 26.74, 1, '2026-01-07 12:50:24.572', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (364, 70, 16, 'Clif Shot Bloks x18 - Talla 39 - Blanco', 'Pack 18 gominolas energéticas Clif Shot Bloks con 50mg cafeína. Fáciles de masticar y digerir en carrera.', 22.69, 1, '2025-10-18 03:00:24.691', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (365, 80, 16, 'Clif Shot Bloks x18 - Talla 40 - Azul', 'Pack 18 gominolas energéticas Clif Shot Bloks con 50mg cafeína. Fáciles de masticar y digerir en carrera.', 28.74, 1, '2026-02-25 04:11:47.446', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (366, 66, 16, 'Clif Shot Bloks x18 - Talla 41 - Rojo', 'Pack 18 gominolas energéticas Clif Shot Bloks con 50mg cafeína. Fáciles de masticar y digerir en carrera.', 25.68, 1, '2025-03-21 04:55:45.702', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (367, 70, 16, 'Clif Shot Bloks x18 - Talla 42 - Verde', 'Pack 18 gominolas energéticas Clif Shot Bloks con 50mg cafeína. Fáciles de masticar y digerir en carrera.', 27.66, 0, '2025-12-04 09:22:54.336', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (368, 91, 16, 'Precision Hydration PH1000 x20', 'Pack 20 tabletas de electrolitos Precision Hydration. Formulación científica para prevenir la hiponatremia.', 23.28, 1, '2025-01-12 00:26:41.775', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (369, 68, 16, 'Precision Hydration PH1000 x20 - Talla 39 - Blanco', 'Pack 20 tabletas de electrolitos Precision Hydration. Formulación científica para prevenir la hiponatremia.', 22.02, 0, '2025-12-09 00:58:26.801', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (370, 85, 16, 'Precision Hydration PH1000 x20 - Talla 40 - Azul', 'Pack 20 tabletas de electrolitos Precision Hydration. Formulación científica para prevenir la hiponatremia.', 19.73, 1, '2026-02-24 17:02:06.658', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (371, 86, 16, 'Precision Hydration PH1000 x20 - Talla 41 - Rojo', 'Pack 20 tabletas de electrolitos Precision Hydration. Formulación científica para prevenir la hiponatremia.', 23.57, 0, '2025-06-24 04:36:37.183', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (372, 61, 16, 'Precision Hydration PH1000 x20 - Talla 42 - Verde', 'Pack 20 tabletas de electrolitos Precision Hydration. Formulación científica para prevenir la hiponatremia.', 22.10, 1, '2025-10-08 07:55:06.869', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (373, 75, 16, 'Veloforte Barritas Naturales x12', 'Pack 12 barritas energéticas naturales Veloforte. Elaboradas con ingredientes reales para deportistas exigentes.', 36.63, 1, '2025-06-09 03:27:10.202', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (374, 71, 16, 'Veloforte Barritas Naturales x12 - Talla 39 - Blanco', 'Pack 12 barritas energéticas naturales Veloforte. Elaboradas con ingredientes reales para deportistas exigentes.', 37.38, 1, '2025-03-17 00:44:47.753', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (375, 70, 16, 'Veloforte Barritas Naturales x12 - Talla 40 - Azul', 'Pack 12 barritas energéticas naturales Veloforte. Elaboradas con ingredientes reales para deportistas exigentes.', 41.27, 1, '2025-11-15 07:17:37.686', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (376, 71, 16, 'Veloforte Barritas Naturales x12 - Talla 41 - Rojo', 'Pack 12 barritas energéticas naturales Veloforte. Elaboradas con ingredientes reales para deportistas exigentes.', 35.27, 1, '2026-01-25 06:11:35.285', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (377, 91, 16, 'Veloforte Barritas Naturales x12 - Talla 42 - Verde', 'Pack 12 barritas energéticas naturales Veloforte. Elaboradas con ingredientes reales para deportistas exigentes.', 36.48, 1, '2025-08-02 17:09:50.394', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (378, 59, 17, 'Black Diamond Carbon Z Bastones', 'Bastones de carbono Black Diamond Carbon Z plegables. Ultraligeros y resistentes para las rutas más exigentes.', 187.02, 1, '2025-11-29 18:20:34.39', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (379, 98, 17, 'Black Diamond Carbon Z Bastones - Talla 39 - Blanco', 'Bastones de carbono Black Diamond Carbon Z plegables. Ultraligeros y resistentes para las rutas más exigentes.', 171.30, 1, '2025-01-25 20:15:21.105', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (380, 88, 17, 'Black Diamond Carbon Z Bastones - Talla 40 - Azul', 'Bastones de carbono Black Diamond Carbon Z plegables. Ultraligeros y resistentes para las rutas más exigentes.', 188.29, 1, '2025-10-08 02:43:02.139', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (381, 77, 17, 'Black Diamond Carbon Z Bastones - Talla 41 - Rojo', 'Bastones de carbono Black Diamond Carbon Z plegables. Ultraligeros y resistentes para las rutas más exigentes.', 207.48, 1, '2025-06-01 15:09:01.929', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (382, 80, 17, 'Black Diamond Carbon Z Bastones - Talla 42 - Verde', 'Bastones de carbono Black Diamond Carbon Z plegables. Ultraligeros y resistentes para las rutas más exigentes.', 180.22, 1, '2025-10-13 19:54:16.338', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (383, 88, 17, 'Kahtoola MICROspikes', 'Microcrampones Kahtoola para nieve compacta y hielo. Se colocan sobre cualquier zapatilla en segundos.', 67.62, 1, '2025-10-13 11:17:55.17', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (384, 60, 17, 'Kahtoola MICROspikes - Talla 39 - Blanco', 'Microcrampones Kahtoola para nieve compacta y hielo. Se colocan sobre cualquier zapatilla en segundos.', 67.23, 0, '2025-08-31 11:10:28.947', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (385, 60, 17, 'Kahtoola MICROspikes - Talla 40 - Azul', 'Microcrampones Kahtoola para nieve compacta y hielo. Se colocan sobre cualquier zapatilla en segundos.', 76.92, 1, '2025-05-23 06:33:52.06', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (386, 77, 17, 'Kahtoola MICROspikes - Talla 41 - Rojo', 'Microcrampones Kahtoola para nieve compacta y hielo. Se colocan sobre cualquier zapatilla en segundos.', 61.27, 1, '2025-04-19 18:22:32.874', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (387, 91, 17, 'Kahtoola MICROspikes - Talla 42 - Verde', 'Microcrampones Kahtoola para nieve compacta y hielo. Se colocan sobre cualquier zapatilla en segundos.', 64.03, 1, '2025-07-31 10:13:18.55', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (388, 87, 17, 'Silva Trail Runner Free Brújula', 'Brújula de carrera Silva Trail Runner Free para orientación en montaña. Ligera y precisa para trail y orientación.', 39.28, 1, '2026-02-25 05:41:25.3', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (389, 70, 17, 'Silva Trail Runner Free Brújula - Talla 39 - Blanco', 'Brújula de carrera Silva Trail Runner Free para orientación en montaña. Ligera y precisa para trail y orientación.', 49.75, 1, '2026-03-18 00:48:25.197', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (390, 87, 17, 'Silva Trail Runner Free Brújula - Talla 40 - Azul', 'Brújula de carrera Silva Trail Runner Free para orientación en montaña. Ligera y precisa para trail y orientación.', 44.12, 1, '2025-03-14 11:17:55.159', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (391, 90, 17, 'Silva Trail Runner Free Brújula - Talla 41 - Rojo', 'Brújula de carrera Silva Trail Runner Free para orientación en montaña. Ligera y precisa para trail y orientación.', 42.00, 0, '2025-05-06 19:11:35.764', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (392, 80, 17, 'Silva Trail Runner Free Brújula - Talla 42 - Verde', 'Brújula de carrera Silva Trail Runner Free para orientación en montaña. Ligera y precisa para trail y orientación.', 49.19, 1, '2026-01-15 01:29:35.598', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (393, 98, 17, 'Petzl Tikka Frontal 300lm', 'Frontal Petzl Tikka 300 lúmenes con tres modos de iluminación. Ligero y duradero para trail y camping.', 33.07, 0, '2025-04-23 23:15:40.344', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (394, 80, 17, 'Petzl Tikka Frontal 300lm - Talla 39 - Blanco', 'Frontal Petzl Tikka 300 lúmenes con tres modos de iluminación. Ligero y duradero para trail y camping.', 37.04, 1, '2025-01-01 11:10:05.337', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (395, 71, 17, 'Petzl Tikka Frontal 300lm - Talla 40 - Azul', 'Frontal Petzl Tikka 300 lúmenes con tres modos de iluminación. Ligero y duradero para trail y camping.', 39.18, 1, '2025-05-15 14:56:22.525', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (396, 86, 17, 'Petzl Tikka Frontal 300lm - Talla 41 - Rojo', 'Frontal Petzl Tikka 300 lúmenes con tres modos de iluminación. Ligero y duradero para trail y camping.', 40.20, 0, '2025-05-26 22:28:33.923', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (397, 60, 17, 'Petzl Tikka Frontal 300lm - Talla 42 - Verde', 'Frontal Petzl Tikka 300 lúmenes con tres modos de iluminación. Ligero y duradero para trail y camping.', 39.19, 1, '2025-05-03 00:13:50.752', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (398, 67, 17, 'Emergency Bivouac SOL Escape', 'Vivac de emergencia SOL Escape ultraligero. Imprescindible en el kit de seguridad para rutas de montaña.', 24.70, 0, '2025-12-05 03:43:11.799', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (399, 66, 17, 'Emergency Bivouac SOL Escape - Talla 39 - Blanco', 'Vivac de emergencia SOL Escape ultraligero. Imprescindible en el kit de seguridad para rutas de montaña.', 30.56, 1, '2025-03-12 14:24:26.986', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (400, 98, 17, 'Emergency Bivouac SOL Escape - Talla 40 - Azul', 'Vivac de emergencia SOL Escape ultraligero. Imprescindible en el kit de seguridad para rutas de montaña.', 25.01, 1, '2025-06-07 16:38:48.386', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (401, 86, 17, 'Emergency Bivouac SOL Escape - Talla 41 - Rojo', 'Vivac de emergencia SOL Escape ultraligero. Imprescindible en el kit de seguridad para rutas de montaña.', 32.10, 1, '2025-07-30 09:12:10.933', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (402, 87, 17, 'Emergency Bivouac SOL Escape - Talla 42 - Verde', 'Vivac de emergencia SOL Escape ultraligero. Imprescindible en el kit de seguridad para rutas de montaña.', 25.98, 1, '2025-11-03 01:21:07.029', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (403, 75, 17, 'Montane Minimus Lite Jacket', 'Chubasquero ultraligero Montane Minimus Lite para montaña. Protección impermeable sin apenas añadir volumen.', 170.60, 1, '2025-03-02 08:25:47.472', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (404, 80, 17, 'Montane Minimus Lite Jacket - Talla 39 - Blanco', 'Chubasquero ultraligero Montane Minimus Lite para montaña. Protección impermeable sin apenas añadir volumen.', 161.64, 1, '2025-01-19 21:26:37.135', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (405, 91, 17, 'Montane Minimus Lite Jacket - Talla 40 - Azul', 'Chubasquero ultraligero Montane Minimus Lite para montaña. Protección impermeable sin apenas añadir volumen.', 165.47, 1, '2025-10-11 14:20:15.435', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (406, 85, 17, 'Montane Minimus Lite Jacket - Talla 41 - Rojo', 'Chubasquero ultraligero Montane Minimus Lite para montaña. Protección impermeable sin apenas añadir volumen.', 193.51, 0, '2025-10-20 17:05:29.547', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (407, 97, 17, 'Montane Minimus Lite Jacket - Talla 42 - Verde', 'Chubasquero ultraligero Montane Minimus Lite para montaña. Protección impermeable sin apenas añadir volumen.', 150.23, 0, '2025-05-28 20:20:50.172', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (408, 72, 17, 'Grivel G12 Crampones', 'Crampones de 12 puntas Grivel G12 para nieve y hielo. Imprescindibles para rutas de alta montaña en invierno.', 83.40, 1, '2025-01-17 05:02:23.708', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (409, 61, 17, 'Grivel G12 Crampones - Talla 39 - Blanco', 'Crampones de 12 puntas Grivel G12 para nieve y hielo. Imprescindibles para rutas de alta montaña en invierno.', 99.37, 1, '2025-03-15 21:25:45.719', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (410, 97, 17, 'Grivel G12 Crampones - Talla 40 - Azul', 'Crampones de 12 puntas Grivel G12 para nieve y hielo. Imprescindibles para rutas de alta montaña en invierno.', 82.67, 1, '2025-05-08 23:24:14.367', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (411, 69, 17, 'Grivel G12 Crampones - Talla 41 - Rojo', 'Crampones de 12 puntas Grivel G12 para nieve y hielo. Imprescindibles para rutas de alta montaña en invierno.', 101.59, 0, '2025-06-28 16:40:32.876', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (412, 69, 17, 'Grivel G12 Crampones - Talla 42 - Verde', 'Crampones de 12 puntas Grivel G12 para nieve y hielo. Imprescindibles para rutas de alta montaña en invierno.', 88.60, 1, '2025-09-15 18:01:04.536', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (413, 91, 17, 'Grivel Ghost Ice Axe Piolet', 'Piolet Grivel Ghost de aluminio para alpinismo clásico. Ligero y versátil para rutas de cresta y glaciar.', 133.41, 1, '2025-11-23 03:22:58.156', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (414, 83, 17, 'Grivel Ghost Ice Axe Piolet - Talla 39 - Blanco', 'Piolet Grivel Ghost de aluminio para alpinismo clásico. Ligero y versátil para rutas de cresta y glaciar.', 120.19, 0, '2026-03-03 17:27:12.989', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (415, 59, 17, 'Grivel Ghost Ice Axe Piolet - Talla 40 - Azul', 'Piolet Grivel Ghost de aluminio para alpinismo clásico. Ligero y versátil para rutas de cresta y glaciar.', 111.40, 1, '2025-04-07 16:35:03.859', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (416, 63, 17, 'Grivel Ghost Ice Axe Piolet - Talla 41 - Rojo', 'Piolet Grivel Ghost de aluminio para alpinismo clásico. Ligero y versátil para rutas de cresta y glaciar.', 130.54, 0, '2026-02-09 20:43:02.839', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (417, 91, 17, 'Grivel Ghost Ice Axe Piolet - Talla 42 - Verde', 'Piolet Grivel Ghost de aluminio para alpinismo clásico. Ligero y versátil para rutas de cresta y glaciar.', 138.23, 1, '2025-09-12 08:20:11.025', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (418, 75, 18, 'Injinji Trail Midweight Mini-Crew', 'Calcetines de dedos Injinji Trail para trail running. Eliminan las ampollas entre dedos en largas distancias.', 15.81, 0, '2026-03-04 03:41:41.291', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (419, 73, 18, 'Injinji Trail Midweight Mini-Crew - Talla 39 - Blanco', 'Calcetines de dedos Injinji Trail para trail running. Eliminan las ampollas entre dedos en largas distancias.', 18.18, 1, '2025-10-16 06:15:51.323', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (420, 71, 18, 'Injinji Trail Midweight Mini-Crew - Talla 40 - Azul', 'Calcetines de dedos Injinji Trail para trail running. Eliminan las ampollas entre dedos en largas distancias.', 19.36, 1, '2025-04-03 00:33:51.064', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (421, 89, 18, 'Injinji Trail Midweight Mini-Crew - Talla 41 - Rojo', 'Calcetines de dedos Injinji Trail para trail running. Eliminan las ampollas entre dedos en largas distancias.', 15.70, 1, '2026-03-28 00:21:29.267', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (422, 63, 18, 'Injinji Trail Midweight Mini-Crew - Talla 42 - Verde', 'Calcetines de dedos Injinji Trail para trail running. Eliminan las ampollas entre dedos en largas distancias.', 20.65, 1, '2025-07-08 10:17:52.202', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (423, 61, 18, 'Darn Tough Vertex Running', 'Calcetines merino Darn Tough Vertex con garantía de por vida. Regulación térmica natural y antibacteriano.', 23.84, 0, '2026-04-09 04:21:53.198', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (424, 66, 18, 'Darn Tough Vertex Running - Talla 39 - Blanco', 'Calcetines merino Darn Tough Vertex con garantía de por vida. Regulación térmica natural y antibacteriano.', 22.18, 0, '2026-02-03 11:48:49.928', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (425, 94, 18, 'Darn Tough Vertex Running - Talla 40 - Azul', 'Calcetines merino Darn Tough Vertex con garantía de por vida. Regulación térmica natural y antibacteriano.', 24.83, 1, '2025-11-04 06:31:53.05', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (426, 92, 18, 'Darn Tough Vertex Running - Talla 41 - Rojo', 'Calcetines merino Darn Tough Vertex con garantía de por vida. Regulación térmica natural y antibacteriano.', 24.82, 1, '2026-02-10 07:19:43.538', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (427, 82, 18, 'Darn Tough Vertex Running - Talla 42 - Verde', 'Calcetines merino Darn Tough Vertex con garantía de por vida. Regulación térmica natural y antibacteriano.', 22.57, 1, '2025-10-22 11:06:39.481', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (428, 93, 18, 'Balega Blister Resist', 'Calcetines anti-ampollas Balega con tecnología mohair. Protección superior para runners de larga distancia.', 17.84, 1, '2026-01-18 19:35:51.695', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (429, 60, 18, 'Balega Blister Resist - Talla 39 - Blanco', 'Calcetines anti-ampollas Balega con tecnología mohair. Protección superior para runners de larga distancia.', 14.82, 1, '2025-04-11 05:56:23.804', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (430, 84, 18, 'Balega Blister Resist - Talla 40 - Azul', 'Calcetines anti-ampollas Balega con tecnología mohair. Protección superior para runners de larga distancia.', 16.74, 1, '2025-08-25 03:32:20.199', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (431, 83, 18, 'Balega Blister Resist - Talla 41 - Rojo', 'Calcetines anti-ampollas Balega con tecnología mohair. Protección superior para runners de larga distancia.', 13.82, 1, '2025-11-05 13:22:26.685', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (432, 90, 18, 'Balega Blister Resist - Talla 42 - Verde', 'Calcetines anti-ampollas Balega con tecnología mohair. Protección superior para runners de larga distancia.', 16.34, 1, '2026-02-25 20:27:57.093', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (433, 66, 18, 'Compressport Pro Racing V4.0', 'Calcetines de competición Compressport Pro Racing con compresión en el arco. Para corredores exigentes.', 22.54, 1, '2025-04-12 10:28:15.147', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (434, 69, 18, 'Compressport Pro Racing V4.0 - Talla 39 - Blanco', 'Calcetines de competición Compressport Pro Racing con compresión en el arco. Para corredores exigentes.', 22.04, 1, '2025-12-16 01:19:26.979', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (435, 74, 18, 'Compressport Pro Racing V4.0 - Talla 40 - Azul', 'Calcetines de competición Compressport Pro Racing con compresión en el arco. Para corredores exigentes.', 20.77, 1, '2025-04-26 04:36:57.488', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (436, 85, 18, 'Compressport Pro Racing V4.0 - Talla 41 - Rojo', 'Calcetines de competición Compressport Pro Racing con compresión en el arco. Para corredores exigentes.', 22.28, 1, '2025-11-26 14:46:00.554', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (437, 77, 18, 'Compressport Pro Racing V4.0 - Talla 42 - Verde', 'Calcetines de competición Compressport Pro Racing con compresión en el arco. Para corredores exigentes.', 26.68, 1, '2025-06-08 08:24:19.712', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (438, 85, 18, 'Falke RU4 Running Socks', 'Calcetines de running Falke RU4 con zonas de amortiguación diferenciadas. Comodidad premium para cada pisada.', 17.10, 0, '2025-04-03 00:22:07.678', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (439, 89, 18, 'Falke RU4 Running Socks - Talla 39 - Blanco', 'Calcetines de running Falke RU4 con zonas de amortiguación diferenciadas. Comodidad premium para cada pisada.', 17.51, 1, '2025-08-07 09:37:42.502', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (440, 96, 18, 'Falke RU4 Running Socks - Talla 40 - Azul', 'Calcetines de running Falke RU4 con zonas de amortiguación diferenciadas. Comodidad premium para cada pisada.', 20.32, 1, '2025-11-02 09:53:37.618', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (441, 92, 18, 'Falke RU4 Running Socks - Talla 41 - Rojo', 'Calcetines de running Falke RU4 con zonas de amortiguación diferenciadas. Comodidad premium para cada pisada.', 17.77, 1, '2025-06-17 08:11:30.165', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (442, 98, 18, 'Falke RU4 Running Socks - Talla 42 - Verde', 'Calcetines de running Falke RU4 con zonas de amortiguación diferenciadas. Comodidad premium para cada pisada.', 22.65, 0, '2025-06-04 09:57:24.881', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (443, 71, 18, 'Stance Run Tab 3-pack', 'Pack 3 pares calcetines de running Stance Run Tab. Diseño bajo que evita la fricción con la zapatilla.', 37.97, 1, '2025-09-17 03:52:02.15', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (445, 67, 18, 'Stance Run Tab 3-pack - Talla 40 - Azul', 'Pack 3 pares calcetines de running Stance Run Tab. Diseño bajo que evita la fricción con la zapatilla.', 38.80, 1, '2025-10-14 18:14:07.404', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (446, 78, 18, 'Stance Run Tab 3-pack - Talla 41 - Rojo', 'Pack 3 pares calcetines de running Stance Run Tab. Diseño bajo que evita la fricción con la zapatilla.', 33.63, 1, '2025-11-04 19:49:35.082', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (447, 84, 18, 'Stance Run Tab 3-pack - Talla 42 - Verde', 'Pack 3 pares calcetines de running Stance Run Tab. Diseño bajo que evita la fricción con la zapatilla.', 36.23, 1, '2025-03-07 23:05:04.905', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (448, 77, 18, 'Wigwam Cool Lite Hiker Pro', 'Calcetines de senderismo y trail Wigwam de lana merino. Regulación natural de temperatura en todas las condiciones.', 17.85, 1, '2026-01-22 08:26:37.124', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (449, 74, 18, 'Wigwam Cool Lite Hiker Pro - Talla 39 - Blanco', 'Calcetines de senderismo y trail Wigwam de lana merino. Regulación natural de temperatura en todas las condiciones.', 19.97, 0, '2025-12-01 05:41:10.771', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (450, 93, 18, 'Wigwam Cool Lite Hiker Pro - Talla 40 - Azul', 'Calcetines de senderismo y trail Wigwam de lana merino. Regulación natural de temperatura en todas las condiciones.', 18.49, 1, '2025-06-13 11:44:25.306', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (451, 81, 18, 'Wigwam Cool Lite Hiker Pro - Talla 41 - Rojo', 'Calcetines de senderismo y trail Wigwam de lana merino. Regulación natural de temperatura en todas las condiciones.', 17.94, 1, '2025-10-05 14:29:16.751', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (452, 91, 18, 'Wigwam Cool Lite Hiker Pro - Talla 42 - Verde', 'Calcetines de senderismo y trail Wigwam de lana merino. Regulación natural de temperatura en todas las condiciones.', 17.32, 1, '2025-10-23 07:26:33.615', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (453, 62, 18, 'Swiftwick Aspire Four', 'Calcetines de compresión leve Swiftwick Aspire Four. Gestión de humedad superior para maratones y ultras.', 18.49, 1, '2025-08-17 16:19:37.758', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (454, 79, 18, 'Swiftwick Aspire Four - Talla 39 - Blanco', 'Calcetines de compresión leve Swiftwick Aspire Four. Gestión de humedad superior para maratones y ultras.', 16.16, 1, '2026-02-17 07:55:24.581', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (455, 89, 18, 'Swiftwick Aspire Four - Talla 40 - Azul', 'Calcetines de compresión leve Swiftwick Aspire Four. Gestión de humedad superior para maratones y ultras.', 18.32, 0, '2026-03-01 06:00:44.966', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (456, 96, 18, 'Swiftwick Aspire Four - Talla 41 - Rojo', 'Calcetines de compresión leve Swiftwick Aspire Four. Gestión de humedad superior para maratones y ultras.', 17.30, 1, '2025-09-07 05:26:15.906', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (457, 67, 18, 'Swiftwick Aspire Four - Talla 42 - Verde', 'Calcetines de compresión leve Swiftwick Aspire Four. Gestión de humedad superior para maratones y ultras.', 17.26, 1, '2025-03-08 12:21:58.513', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (458, 74, 19, 'Oakley Sutro Lite Sweep', 'Gafas de running Oakley Sutro Lite Sweep con lente Prizm Road. Campo de visión ampliado para mayor seguridad.', 169.99, 1, '2025-06-13 03:35:22.928', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (459, 66, 19, 'Oakley Sutro Lite Sweep - Talla 39 - Blanco', 'Gafas de running Oakley Sutro Lite Sweep con lente Prizm Road. Campo de visión ampliado para mayor seguridad.', 157.59, 1, '2026-03-05 04:27:24.392', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (460, 93, 19, 'Oakley Sutro Lite Sweep - Talla 40 - Azul', 'Gafas de running Oakley Sutro Lite Sweep con lente Prizm Road. Campo de visión ampliado para mayor seguridad.', 170.03, 1, '2025-04-14 07:06:23.88', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (461, 63, 19, 'Oakley Sutro Lite Sweep - Talla 41 - Rojo', 'Gafas de running Oakley Sutro Lite Sweep con lente Prizm Road. Campo de visión ampliado para mayor seguridad.', 131.81, 1, '2026-02-25 02:10:58.959', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (462, 81, 19, 'Oakley Sutro Lite Sweep - Talla 42 - Verde', 'Gafas de running Oakley Sutro Lite Sweep con lente Prizm Road. Campo de visión ampliado para mayor seguridad.', 134.74, 1, '2025-03-31 19:40:29.562', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (463, 64, 19, 'Rudy Project Spinshield', 'Gafas deportivas Rudy Project Spinshield con sistema de ventilación. Anti-vaho y anti-reflejo para todas las condiciones.', 131.40, 0, '2025-08-01 09:38:45.953', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (464, 70, 19, 'Rudy Project Spinshield - Talla 39 - Blanco', 'Gafas deportivas Rudy Project Spinshield con sistema de ventilación. Anti-vaho y anti-reflejo para todas las condiciones.', 144.45, 1, '2025-11-23 03:37:48.083', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (465, 77, 19, 'Rudy Project Spinshield - Talla 40 - Azul', 'Gafas deportivas Rudy Project Spinshield con sistema de ventilación. Anti-vaho y anti-reflejo para todas las condiciones.', 137.74, 1, '2025-09-22 01:56:25.266', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (466, 66, 19, 'Rudy Project Spinshield - Talla 41 - Rojo', 'Gafas deportivas Rudy Project Spinshield con sistema de ventilación. Anti-vaho y anti-reflejo para todas las condiciones.', 114.24, 0, '2025-06-21 16:42:17.77', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (467, 78, 19, 'Rudy Project Spinshield - Talla 42 - Verde', 'Gafas deportivas Rudy Project Spinshield con sistema de ventilación. Anti-vaho y anti-reflejo para todas las condiciones.', 120.80, 1, '2025-02-23 02:05:40.264', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (468, 74, 19, 'Smith Attack MAG', 'Gafas Smith Attack MAG con sistema de cambio de lente magnético. Adaptación rápida a diferentes condiciones de luz.', 179.09, 0, '2025-04-21 14:15:02.489', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (469, 96, 19, 'Smith Attack MAG - Talla 39 - Blanco', 'Gafas Smith Attack MAG con sistema de cambio de lente magnético. Adaptación rápida a diferentes condiciones de luz.', 167.60, 1, '2025-04-05 08:53:19.67', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (470, 74, 19, 'Smith Attack MAG - Talla 40 - Azul', 'Gafas Smith Attack MAG con sistema de cambio de lente magnético. Adaptación rápida a diferentes condiciones de luz.', 185.53, 1, '2025-06-30 09:31:35.57', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (471, 80, 19, 'Smith Attack MAG - Talla 41 - Rojo', 'Gafas Smith Attack MAG con sistema de cambio de lente magnético. Adaptación rápida a diferentes condiciones de luz.', 163.28, 1, '2025-01-23 09:31:34.511', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (472, 97, 19, 'Smith Attack MAG - Talla 42 - Verde', 'Gafas Smith Attack MAG con sistema de cambio de lente magnético. Adaptación rápida a diferentes condiciones de luz.', 178.48, 1, '2025-03-09 10:00:33.642', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (473, 59, 19, 'Julbo Aerolite', 'Gafas trail Julbo Aerolite con lente Reactiv fotocromática. Se adaptan automáticamente a la luminosidad del entorno.', 126.16, 1, '2025-11-26 17:25:37.197', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (474, 87, 19, 'Julbo Aerolite - Talla 39 - Blanco', 'Gafas trail Julbo Aerolite con lente Reactiv fotocromática. Se adaptan automáticamente a la luminosidad del entorno.', 146.15, 1, '2026-03-28 07:29:37.829', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (475, 81, 19, 'Julbo Aerolite - Talla 40 - Azul', 'Gafas trail Julbo Aerolite con lente Reactiv fotocromática. Se adaptan automáticamente a la luminosidad del entorno.', 160.21, 0, '2025-12-03 05:00:44.719', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (476, 66, 19, 'Julbo Aerolite - Talla 41 - Rojo', 'Gafas trail Julbo Aerolite con lente Reactiv fotocromática. Se adaptan automáticamente a la luminosidad del entorno.', 158.80, 1, '2025-12-21 03:06:18.376', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (477, 84, 19, 'Julbo Aerolite - Talla 42 - Verde', 'Gafas trail Julbo Aerolite con lente Reactiv fotocromática. Se adaptan automáticamente a la luminosidad del entorno.', 156.42, 1, '2025-12-25 23:29:37.915', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (478, 98, 19, 'Salomon S/Lab Sonic', 'Gafas de trail Salomon S/Lab Sonic ultraligeras. Diseñadas con atletas de élite para máxima comodidad en carrera.', 83.99, 1, '2025-08-16 03:45:15.054', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (479, 73, 19, 'Salomon S/Lab Sonic - Talla 39 - Blanco', 'Gafas de trail Salomon S/Lab Sonic ultraligeras. Diseñadas con atletas de élite para máxima comodidad en carrera.', 81.20, 1, '2026-01-22 07:33:05.123', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (480, 65, 19, 'Salomon S/Lab Sonic - Talla 40 - Azul', 'Gafas de trail Salomon S/Lab Sonic ultraligeras. Diseñadas con atletas de élite para máxima comodidad en carrera.', 92.86, 1, '2025-10-09 08:59:02.459', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (481, 78, 19, 'Salomon S/Lab Sonic - Talla 41 - Rojo', 'Gafas de trail Salomon S/Lab Sonic ultraligeras. Diseñadas con atletas de élite para máxima comodidad en carrera.', 79.76, 0, '2026-03-20 14:20:44.456', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (482, 62, 19, 'Salomon S/Lab Sonic - Talla 42 - Verde', 'Gafas de trail Salomon S/Lab Sonic ultraligeras. Diseñadas con atletas de élite para máxima comodidad en carrera.', 88.68, 1, '2026-01-30 20:20:26.68', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (483, 79, 19, 'Adidas Sport Eyewear SP0038', 'Gafas deportivas Adidas con montura envolvente. Protección solar y estabilidad durante esfuerzos intensos.', 69.28, 1, '2026-04-07 11:28:07.47', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (484, 75, 19, 'Adidas Sport Eyewear SP0038 - Talla 39 - Blanco', 'Gafas deportivas Adidas con montura envolvente. Protección solar y estabilidad durante esfuerzos intensos.', 72.14, 1, '2025-05-16 23:24:23.082', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (485, 63, 19, 'Adidas Sport Eyewear SP0038 - Talla 40 - Azul', 'Gafas deportivas Adidas con montura envolvente. Protección solar y estabilidad durante esfuerzos intensos.', 75.20, 1, '2025-11-09 09:54:39.536', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (486, 62, 19, 'Adidas Sport Eyewear SP0038 - Talla 41 - Rojo', 'Gafas deportivas Adidas con montura envolvente. Protección solar y estabilidad durante esfuerzos intensos.', 66.04, 0, '2026-01-03 06:48:47.67', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (487, 83, 19, 'Adidas Sport Eyewear SP0038 - Talla 42 - Verde', 'Gafas deportivas Adidas con montura envolvente. Protección solar y estabilidad durante esfuerzos intensos.', 65.63, 1, '2025-08-07 02:40:35.151', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (488, 82, 19, 'Bolle Bolt 2.0', 'Gafas de competición Bollé Bolt 2.0 con ventilación optimizada. Diseño aerodinámico para ciclismo y triatlón.', 90.10, 1, '2025-09-01 01:58:33.541', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (489, 77, 19, 'Bolle Bolt 2.0 - Talla 39 - Blanco', 'Gafas de competición Bollé Bolt 2.0 con ventilación optimizada. Diseño aerodinámico para ciclismo y triatlón.', 91.92, 1, '2025-07-03 06:31:51.873', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (490, 80, 19, 'Bolle Bolt 2.0 - Talla 40 - Azul', 'Gafas de competición Bollé Bolt 2.0 con ventilación optimizada. Diseño aerodinámico para ciclismo y triatlón.', 98.10, 1, '2025-01-22 23:44:40.24', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (491, 63, 19, 'Bolle Bolt 2.0 - Talla 41 - Rojo', 'Gafas de competición Bollé Bolt 2.0 con ventilación optimizada. Diseño aerodinámico para ciclismo y triatlón.', 104.21, 0, '2025-08-13 11:51:16.599', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (492, 85, 19, 'Bolle Bolt 2.0 - Talla 42 - Verde', 'Gafas de competición Bollé Bolt 2.0 con ventilación optimizada. Diseño aerodinámico para ciclismo y triatlón.', 108.85, 1, '2026-01-27 09:46:41.049', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (493, 79, 20, 'Theragun Prime Gen 5', 'Pistola de masaje Theragun Prime Gen 5 con 5 velocidades y app conectada. Recuperación muscular profunda post entrenamiento.', 255.57, 1, '2026-02-19 21:30:14.677', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (494, 78, 20, 'Theragun Prime Gen 5 - Talla 39 - Blanco', 'Pistola de masaje Theragun Prime Gen 5 con 5 velocidades y app conectada. Recuperación muscular profunda post entrenamiento.', 210.68, 1, '2025-09-01 11:33:04.671', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (495, 64, 20, 'Theragun Prime Gen 5 - Talla 40 - Azul', 'Pistola de masaje Theragun Prime Gen 5 con 5 velocidades y app conectada. Recuperación muscular profunda post entrenamiento.', 192.62, 1, '2025-05-24 03:23:30.904', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (496, 74, 20, 'Theragun Prime Gen 5 - Talla 41 - Rojo', 'Pistola de masaje Theragun Prime Gen 5 con 5 velocidades y app conectada. Recuperación muscular profunda post entrenamiento.', 206.13, 1, '2026-02-08 04:03:12.384', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (497, 85, 20, 'Theragun Prime Gen 5 - Talla 42 - Verde', 'Pistola de masaje Theragun Prime Gen 5 con 5 velocidades y app conectada. Recuperación muscular profunda post entrenamiento.', 250.18, 0, '2025-08-18 14:54:57.187', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (498, 73, 20, 'Hypervolt 2 Pro Hyperice', 'Pistola de percusión Hypervolt 2 Pro con 5 cabezales y 3 velocidades. Alivio rápido de tensiones musculares.', 169.65, 0, '2025-07-01 02:10:55.064', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (499, 96, 20, 'Hypervolt 2 Pro Hyperice - Talla 39 - Blanco', 'Pistola de percusión Hypervolt 2 Pro con 5 cabezales y 3 velocidades. Alivio rápido de tensiones musculares.', 188.24, 0, '2026-03-09 10:45:11.4', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (500, 64, 20, 'Hypervolt 2 Pro Hyperice - Talla 40 - Azul', 'Pistola de percusión Hypervolt 2 Pro con 5 cabezales y 3 velocidades. Alivio rápido de tensiones musculares.', 181.64, 0, '2025-08-16 11:00:54.655', 'buen estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (501, 64, 20, 'Hypervolt 2 Pro Hyperice - Talla 41 - Rojo', 'Pistola de percusión Hypervolt 2 Pro con 5 cabezales y 3 velocidades. Alivio rápido de tensiones musculares.', 200.14, 1, '2025-07-19 08:38:22.568', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (502, 79, 20, 'Hypervolt 2 Pro Hyperice - Talla 42 - Verde', 'Pistola de percusión Hypervolt 2 Pro con 5 cabezales y 3 velocidades. Alivio rápido de tensiones musculares.', 184.28, 0, '2026-02-13 09:15:38.242', 'muy poco uso', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (503, 95, 20, 'Foam Roller Trigger Point Grid', 'Rodillo de foam Trigger Point Grid con superficie multidireccional. Masaje profundo de miofascia para runners.', 38.23, 1, '2025-05-31 22:12:57.706', 'muy poco uso', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (504, 78, 20, 'Foam Roller Trigger Point Grid - Talla 39 - Blanco', 'Rodillo de foam Trigger Point Grid con superficie multidireccional. Masaje profundo de miofascia para runners.', 43.88, 0, '2025-10-13 02:25:54.752', 'uso moderado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (505, 64, 20, 'Foam Roller Trigger Point Grid - Talla 40 - Azul', 'Rodillo de foam Trigger Point Grid con superficie multidireccional. Masaje profundo de miofascia para runners.', 43.63, 1, '2025-06-09 18:16:26.987', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (506, 92, 20, 'Foam Roller Trigger Point Grid - Talla 41 - Rojo', 'Rodillo de foam Trigger Point Grid con superficie multidireccional. Masaje profundo de miofascia para runners.', 45.82, 1, '2025-08-12 13:12:18.894', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (507, 77, 20, 'Foam Roller Trigger Point Grid - Talla 42 - Verde', 'Rodillo de foam Trigger Point Grid con superficie multidireccional. Masaje profundo de miofascia para runners.', 37.78, 1, '2026-04-04 14:20:03.439', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (508, 66, 20, 'Compressport Full Socks Recovery', 'Calcetines de recuperación Compressport con compresión 40mmHg. Aceleran la recuperación post maratón y ultra.', 61.52, 1, '2026-01-21 13:58:01.87', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (509, 82, 20, 'Compressport Full Socks Recovery - Talla 39 - Blanco', 'Calcetines de recuperación Compressport con compresión 40mmHg. Aceleran la recuperación post maratón y ultra.', 58.69, 1, '2025-06-18 05:26:05.487', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (510, 75, 20, 'Compressport Full Socks Recovery - Talla 40 - Azul', 'Calcetines de recuperación Compressport con compresión 40mmHg. Aceleran la recuperación post maratón y ultra.', 51.55, 1, '2026-03-03 21:07:25.599', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (511, 89, 20, 'Compressport Full Socks Recovery - Talla 41 - Rojo', 'Calcetines de recuperación Compressport con compresión 40mmHg. Aceleran la recuperación post maratón y ultra.', 53.29, 1, '2026-03-14 07:45:29.952', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (512, 86, 20, 'Compressport Full Socks Recovery - Talla 42 - Verde', 'Calcetines de recuperación Compressport con compresión 40mmHg. Aceleran la recuperación post maratón y ultra.', 53.64, 1, '2026-03-08 14:41:01.554', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (513, 85, 20, 'Marc Pro Plus EMS', 'Electroestimulador Marc Pro Plus para recuperación activa. Potencia la recuperación muscular entre sesiones de entrenamiento.', 329.47, 1, '2025-05-15 14:23:05.861', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (514, 78, 20, 'Marc Pro Plus EMS - Talla 39 - Blanco', 'Electroestimulador Marc Pro Plus para recuperación activa. Potencia la recuperación muscular entre sesiones de entrenamiento.', 356.86, 1, '2025-02-13 16:32:49.665', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (515, 63, 20, 'Marc Pro Plus EMS - Talla 40 - Azul', 'Electroestimulador Marc Pro Plus para recuperación activa. Potencia la recuperación muscular entre sesiones de entrenamiento.', 343.61, 1, '2025-07-06 08:11:13.698', 'excelente estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (516, 93, 20, 'Marc Pro Plus EMS - Talla 41 - Rojo', 'Electroestimulador Marc Pro Plus para recuperación activa. Potencia la recuperación muscular entre sesiones de entrenamiento.', 275.14, 1, '2025-07-21 06:02:07.617', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (517, 63, 20, 'Marc Pro Plus EMS - Talla 42 - Verde', 'Electroestimulador Marc Pro Plus para recuperación activa. Potencia la recuperación muscular entre sesiones de entrenamiento.', 301.37, 1, '2025-05-29 09:19:45.084', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (518, 65, 20, 'Incrediwear Knee Sleeve', 'Rodillera de recuperación Incrediwear con tecnología de semiconductores. Mejora la circulación sin compresión excesiva.', 50.67, 1, '2025-10-02 01:14:48.357', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (519, 98, 20, 'Incrediwear Knee Sleeve - Talla 39 - Blanco', 'Rodillera de recuperación Incrediwear con tecnología de semiconductores. Mejora la circulación sin compresión excesiva.', 48.24, 1, '2025-08-26 23:48:46.944', 'buen estado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (520, 74, 20, 'Incrediwear Knee Sleeve - Talla 40 - Azul', 'Rodillera de recuperación Incrediwear con tecnología de semiconductores. Mejora la circulación sin compresión excesiva.', 40.29, 0, '2026-02-22 14:51:29.579', 'excelente estado', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (521, 96, 20, 'Incrediwear Knee Sleeve - Talla 41 - Rojo', 'Rodillera de recuperación Incrediwear con tecnología de semiconductores. Mejora la circulación sin compresión excesiva.', 45.95, 1, '2025-05-14 16:19:14.851', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (522, 72, 20, 'Incrediwear Knee Sleeve - Talla 42 - Verde', 'Rodillera de recuperación Incrediwear con tecnología de semiconductores. Mejora la circulación sin compresión excesiva.', 44.00, 1, '2025-09-26 04:32:31.539', 'muy poco uso', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (523, 79, 20, 'Pro-Tec Athletics IT Band Wrap', 'Banda de soporte para la cintilla iliotibial Pro-Tec. Reduce el dolor de rodilla del corredor durante el entrenamiento.', 30.78, 1, '2025-08-22 03:42:06.707', 'buen estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (524, 80, 20, 'Pro-Tec Athletics IT Band Wrap - Talla 39 - Blanco', 'Banda de soporte para la cintilla iliotibial Pro-Tec. Reduce el dolor de rodilla del corredor durante el entrenamiento.', 24.25, 0, '2025-10-06 09:38:47.162', 'como nuevo', 'vendido', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (525, 65, 20, 'Pro-Tec Athletics IT Band Wrap - Talla 40 - Azul', 'Banda de soporte para la cintilla iliotibial Pro-Tec. Reduce el dolor de rodilla del corredor durante el entrenamiento.', 26.72, 1, '2025-08-18 19:25:44.114', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (526, 98, 20, 'Pro-Tec Athletics IT Band Wrap - Talla 41 - Rojo', 'Banda de soporte para la cintilla iliotibial Pro-Tec. Reduce el dolor de rodilla del corredor durante el entrenamiento.', 28.14, 1, '2025-04-18 19:51:28.531', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (527, 85, 20, 'Pro-Tec Athletics IT Band Wrap - Talla 42 - Verde', 'Banda de soporte para la cintilla iliotibial Pro-Tec. Reduce el dolor de rodilla del corredor durante el entrenamiento.', 27.77, 1, '2025-01-20 08:30:16.879', 'excelente estado', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (528, 87, 20, 'NormaTec 3 Leg System Hyperice', 'Sistema de compresión neumática NormaTec 3 para piernas. Recuperación activa de alto rendimiento para deportistas.', 554.39, 1, '2025-07-02 14:17:21.991', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (529, 94, 20, 'NormaTec 3 Leg System Hyperice - Talla 39 - Blanco', 'Sistema de compresión neumática NormaTec 3 para piernas. Recuperación activa de alto rendimiento para deportistas.', 660.16, 1, '2025-04-13 15:10:53.787', 'uso moderado', 'inactivo', false, NULL, NULL, NULL, '2026-04-18 02:51:13.515293');
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (530, 65, 20, 'NormaTec 3 Leg System Hyperice - Talla 40 - Azul', 'Sistema de compresión neumática NormaTec 3 para piernas. Recuperación activa de alto rendimiento para deportistas.', 588.38, 1, '2026-02-26 02:00:04.995', 'excelente estado', 'activo', false, NULL, NULL, NULL, '2026-04-20 01:32:16.900357');
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (531, 94, 20, 'NormaTec 3 Leg System Hyperice - Talla 41 - Rojo', 'Sistema de compresión neumática NormaTec 3 para piernas. Recuperación activa de alto rendimiento para deportistas.', 570.41, 0, '2025-08-14 02:47:14.112', 'como nuevo', 'inactivo', false, NULL, NULL, NULL, '2026-04-20 01:32:14.619687');
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (532, 63, 20, 'NormaTec 3 Leg System Hyperice - Talla 42 - Verde', 'Sistema de compresión neumática NormaTec 3 para piernas. Recuperación activa de alto rendimiento para deportistas.', 735.32, 0, '2025-04-17 01:25:59.954', 'como nuevo', 'vendido', false, NULL, NULL, NULL, '2026-04-21 00:58:55.824175');
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (444, 61, 18, 'Stance Run Tab 3-pack - Talla 39 - Blanco', 'Pack 3 pares calcetines de running Stance Run Tab. Diseño bajo que evita la fricción con la zapatilla.', 38.96, 1, '2025-01-30 15:14:51.178', 'uso moderado', 'activo', false, NULL, NULL, NULL, NULL);
INSERT INTO public.producto OVERRIDING SYSTEM VALUE VALUES (533, 61, 11, 'Hoka Clifton 10 - Blancas y Azules - Talla 44.5', 'Zapatillas como nuevas. Un solo uso devido a que no es mi talla.', 120.00, 1, '2026-04-24 00:49:04.172972', 'como nuevo', 'activo', false, NULL, NULL, NULL, NULL);


--
-- TOC entry 4923 (class 0 OID 25353)
-- Dependencies: 232
-- Data for Name: resenya_producto; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (1, 90, 29, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2025-10-23 20:06:19.84');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (2, 68, 48, 4, 'Producto en perfectas condiciones, tal como se describe. Muy recomendable.', '2025-09-28 15:18:02.683');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (3, 76, 51, 5, 'Excelente calidad, el vendedor muy serio y puntual. Repetiría sin duda.', '2025-05-14 21:53:29.344');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (4, 79, 53, 5, 'Rápido, seguro y el artículo tal cual se describe. Un 10.', '2025-10-03 22:40:22.123');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (5, 93, 91, 4, 'Todo perfecto, llegó bien embalado y en el tiempo acordado.', '2025-06-16 00:38:29.51');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (6, 97, 99, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2026-01-15 04:54:18.926');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (7, 72, 102, 5, 'Todo perfecto, llegó bien embalado y en el tiempo acordado.', '2025-10-03 18:29:49.894');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (8, 66, 114, 3, 'La comunicación con el vendedor mejorable, pero el producto llegó bien.', '2025-07-14 20:07:26.287');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (9, 85, 124, 5, 'Todo perfecto, llegó bien embalado y en el tiempo acordado.', '2025-11-20 14:43:31.651');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (10, 76, 142, 3, 'Producto correcto, coincide con la descripción aunque podría estar algo más detallada.', '2025-10-05 14:48:30.326');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (11, 91, 145, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2026-03-02 01:33:30.972');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (12, 74, 167, 4, 'Muy buena experiencia de compra. El vendedor resolvió todas mis dudas.', '2026-01-09 07:01:18.474');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (13, 90, 172, 5, 'Todo perfecto, llegó bien embalado y en el tiempo acordado.', '2025-09-11 21:53:54.111');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (14, 61, 173, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2025-04-08 21:15:43.545');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (15, 71, 177, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2025-07-19 21:05:35.753');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (16, 83, 193, 5, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2025-07-26 19:07:13.184');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (17, 75, 195, 5, 'Producto en perfectas condiciones, tal como se describe. Muy recomendable.', '2026-01-15 01:19:43.919');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (18, 80, 199, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2025-08-25 03:24:18.297');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (19, 98, 204, 5, 'El producto supera las expectativas. Envío rápido y seguro.', '2025-06-20 14:56:35.723');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (20, 98, 224, 5, 'El producto supera las expectativas. Envío rápido y seguro.', '2025-07-29 12:16:04.729');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (21, 90, 233, 3, 'Producto correcto, coincide con la descripción aunque podría estar algo más detallada.', '2025-05-12 19:26:20.363');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (22, 86, 234, 4, 'Vendedor muy honesto y producto en perfecto estado. Encantado con la compra.', '2025-09-03 15:37:41.683');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (23, 88, 238, 5, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2025-02-19 23:52:55.562');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (24, 71, 249, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2025-05-28 14:44:44.934');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (25, 59, 259, 5, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2025-09-26 04:54:32.876');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (26, 67, 273, 5, 'Producto en perfectas condiciones, tal como se describe. Muy recomendable.', '2026-02-24 03:15:11.048');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (27, 84, 280, 4, 'Transacción sin problemas. El producto es exactamente lo que buscaba.', '2025-10-17 19:59:26.75');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (28, 68, 285, 3, 'Buen producto en general, el envío tardó un poco más de lo esperado.', '2025-07-12 14:13:38.869');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (29, 87, 296, 3, 'Producto correcto, coincide con la descripción aunque podría estar algo más detallada.', '2025-03-28 03:17:09.616');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (30, 69, 298, 4, 'El producto supera las expectativas. Envío rápido y seguro.', '2025-07-30 22:34:35.864');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (31, 74, 301, 5, 'Vendedor muy honesto y producto en perfecto estado. Encantado con la compra.', '2025-12-18 09:18:11.718');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (32, 71, 319, 5, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2025-04-29 16:21:49.591');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (33, 63, 332, 4, 'Producto auténtico y en muy buen estado. Totalmente recomendable.', '2025-10-05 07:08:16.369');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (34, 83, 337, 5, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2026-02-03 13:30:58.525');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (35, 78, 354, 5, 'Excelente calidad, el vendedor muy serio y puntual. Repetiría sin duda.', '2026-03-31 11:36:35.253');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (36, 64, 367, 3, 'Producto correcto, coincide con la descripción aunque podría estar algo más detallada.', '2026-01-08 03:40:05.439');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (37, 89, 393, 5, 'Vendedor muy honesto y producto en perfecto estado. Encantado con la compra.', '2025-06-17 16:22:23.347');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (38, 71, 406, 5, 'Producto auténtico y en muy buen estado. Totalmente recomendable.', '2025-07-10 20:38:33.276');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (39, 82, 411, 5, 'Vendedor muy honesto y producto en perfecto estado. Encantado con la compra.', '2025-09-05 00:02:11.868');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (40, 91, 416, 4, 'Producto en perfectas condiciones, tal como se describe. Muy recomendable.', '2025-11-21 17:38:24.006');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (41, 60, 418, 5, 'Excelente calidad, el vendedor muy serio y puntual. Repetiría sin duda.', '2025-07-18 13:34:07.878');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (42, 65, 423, 4, 'Excelente calidad, el vendedor muy serio y puntual. Repetiría sin duda.', '2025-08-27 16:36:51.548');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (43, 76, 424, 4, 'Transacción sin problemas. El producto es exactamente lo que buscaba.', '2025-02-28 00:24:05.474');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (44, 69, 438, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2025-10-23 23:44:29.713');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (45, 70, 449, 4, 'Muy buena experiencia de compra. El vendedor resolvió todas mis dudas.', '2025-08-29 08:17:59.985');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (46, 60, 466, 3, 'Buen producto en general, el envío tardó un poco más de lo esperado.', '2026-03-15 02:07:19.25');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (47, 85, 468, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2026-02-27 20:00:17.566');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (48, 81, 481, 4, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2025-09-11 17:32:47.819');
INSERT INTO public.resenya_producto OVERRIDING SYSTEM VALUE VALUES (49, 83, 500, 4, 'Transacción sin problemas. El producto es exactamente lo que buscaba.', '2026-01-12 03:23:05.156');


--
-- TOC entry 4925 (class 0 OID 25373)
-- Dependencies: 234
-- Data for Name: resenya_usuario; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (1, 92, 76, 3, 'Buen producto en general, el envío tardó un poco más de lo esperado.', '2026-03-11 09:11:56.798');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (2, 90, 98, 4, 'Muy buena experiencia de compra. El vendedor resolvió todas mis dudas.', '2025-11-13 15:18:21.808');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (3, 79, 87, 4, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2025-09-18 10:53:51.011');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (4, 68, 67, 5, 'El producto supera las expectativas. Envío rápido y seguro.', '2026-01-06 17:58:24.994');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (5, 78, 77, 5, 'Muy buena experiencia de compra. El vendedor resolvió todas mis dudas.', '2025-08-14 15:35:01.72');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (6, 97, 59, 4, 'Vendedor muy honesto y producto en perfecto estado. Encantado con la compra.', '2025-02-16 23:57:25.382');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (7, 72, 89, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2026-02-08 08:28:32.958');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (8, 76, 89, 3, 'Buen producto en general, el envío tardó un poco más de lo esperado.', '2026-01-11 00:17:52.266');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (9, 91, 63, 5, 'Transacción sin problemas. El producto es exactamente lo que buscaba.', '2026-01-23 15:51:11.676');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (10, 74, 90, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2025-08-21 21:43:11.6');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (11, 90, 97, 3, 'La comunicación con el vendedor mejorable, pero el producto llegó bien.', '2025-02-08 07:16:37.575');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (12, 61, 82, 4, 'Producto auténtico y en muy buen estado. Totalmente recomendable.', '2025-06-23 19:14:49.161');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (13, 71, 74, 4, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2025-03-16 12:37:42.579');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (14, 80, 83, 5, 'Rápido, seguro y el artículo tal cual se describe. Un 10.', '2025-04-04 04:22:25.766');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (15, 85, 89, 4, 'El producto supera las expectativas. Envío rápido y seguro.', '2025-02-03 08:32:40.752');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (16, 86, 88, 5, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2025-07-01 02:13:08.735');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (17, 88, 64, 4, 'Producto en perfectas condiciones, tal como se describe. Muy recomendable.', '2025-10-26 13:02:47.633');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (18, 71, 83, 5, 'El producto supera las expectativas. Envío rápido y seguro.', '2025-10-20 14:14:14.49');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (19, 80, 75, 5, 'Producto en perfectas condiciones, tal como se describe. Muy recomendable.', '2025-04-06 07:57:31.531');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (20, 63, 89, 3, 'La comunicación con el vendedor mejorable, pero el producto llegó bien.', '2025-03-08 17:59:48.024');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (21, 67, 70, 5, 'Todo perfecto, llegó bien embalado y en el tiempo acordado.', '2026-03-22 15:38:28.394');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (22, 84, 90, 4, 'Muy buena experiencia de compra. El vendedor resolvió todas mis dudas.', '2025-12-27 12:08:12.918');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (23, 87, 59, 5, 'Producto auténtico y en muy buen estado. Totalmente recomendable.', '2025-10-29 10:54:55.959');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (24, 69, 88, 3, 'Producto correcto, coincide con la descripción aunque podría estar algo más detallada.', '2025-02-23 06:05:20.941');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (25, 82, 76, 4, 'Muy buena experiencia de compra. El vendedor resolvió todas mis dudas.', '2025-07-23 07:56:00.799');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (26, 63, 87, 4, 'Transacción sin problemas. El producto es exactamente lo que buscaba.', '2025-11-29 05:42:10.222');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (27, 78, 91, 5, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2025-12-02 00:28:59.989');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (28, 64, 70, 4, 'Producto en perfectas condiciones, tal como se describe. Muy recomendable.', '2025-08-13 23:21:14.817');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (29, 89, 98, 5, 'El producto supera las expectativas. Envío rápido y seguro.', '2025-07-05 09:13:00.018');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (30, 71, 85, 4, 'Transacción sin problemas. El producto es exactamente lo que buscaba.', '2025-04-29 23:15:48.495');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (31, 82, 69, 5, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2025-07-28 11:38:51.4');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (32, 60, 75, 4, 'Muy buena experiencia de compra. El vendedor resolvió todas mis dudas.', '2026-03-06 10:42:59.858');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (33, 65, 61, 4, 'El producto supera las expectativas. Envío rápido y seguro.', '2025-11-08 10:02:44.813');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (34, 69, 85, 5, 'Muy buen estado, se nota que ha sido cuidado. Muy satisfecho con la compra.', '2025-10-15 12:34:01.502');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (35, 70, 74, 4, 'Transacción sin problemas. El producto es exactamente lo que buscaba.', '2025-09-22 16:37:35.822');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (36, 60, 66, 4, 'Rápido, seguro y el artículo tal cual se describe. Un 10.', '2025-05-14 00:26:42.978');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (37, 82, 81, 4, 'Transacción sin problemas. El producto es exactamente lo que buscaba.', '2025-12-28 16:24:21.645');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (38, 81, 78, 3, 'Producto correcto, coincide con la descripción aunque podría estar algo más detallada.', '2025-10-19 02:54:16.191');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (39, 63, 62, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2025-09-14 11:27:38.444');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (40, 83, 64, 3, 'Estado aceptable, hay algún detalle de uso no mencionado pero es comprensible.', '2025-03-04 23:34:57.061');
INSERT INTO public.resenya_usuario OVERRIDING SYSTEM VALUE VALUES (41, 89, 94, 4, 'Vendedor muy honesto y producto en perfecto estado. Encantado con la compra.', '2025-09-22 17:59:24.306');


--
-- TOC entry 4907 (class 0 OID 25224)
-- Dependencies: 216
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.rol OVERRIDING SYSTEM VALUE VALUES (1, 'usuario', 'Usuario estándar que puede comprar y vender productos');
INSERT INTO public.rol OVERRIDING SYSTEM VALUE VALUES (2, 'verificador', 'Usuario encargado de revisar productos antes de completar la transacción');
INSERT INTO public.rol OVERRIDING SYSTEM VALUE VALUES (3, 'administrador', 'Usuario con permisos de gestión y moderación');
INSERT INTO public.rol OVERRIDING SYSTEM VALUE VALUES (4, 'analista', 'Usuario con acceso al panel de métricas y análisis');
INSERT INTO public.rol OVERRIDING SYSTEM VALUE VALUES (5, 'superadministrador', NULL);


--
-- TOC entry 4917 (class 0 OID 25296)
-- Dependencies: 226
-- Data for Name: transaccion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (1, 64, 75, '2025-09-20 16:30:34.292', 94.57, 'reembolsada', 4.73, 89.84);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (2, 92, 76, '2025-01-30 13:42:06.061', 81.14, 'completada', 4.06, 77.08);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (3, 87, 65, '2025-03-07 10:17:30.394', 68.29, 'reembolsada', 3.41, 64.88);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (4, 90, 98, '2025-05-22 02:45:49.849', 129.86, 'completada', 6.49, 123.37);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (5, 73, 77, '2025-12-06 05:57:52.63', 166.22, 'pago_retenido', 8.31, 157.91);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (6, 68, 73, '2026-03-17 04:40:12.555', 177.50, 'pago_retenido', 8.88, 168.62);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (7, 83, 59, '2026-01-12 18:19:24.64', 108.75, 'reembolsada', 5.44, 103.31);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (8, 79, 87, '2025-06-14 15:29:23.054', 107.97, 'completada', 5.40, 102.57);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (9, 68, 67, '2026-02-12 17:44:54.533', 176.44, 'completada', 8.82, 167.62);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (10, 76, 79, '2025-08-24 19:31:30.017', 210.82, 'completada', 10.54, 200.28);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (11, 79, 92, '2025-08-19 04:13:08.728', 187.27, 'completada', 9.36, 177.91);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (12, 63, 85, '2026-01-17 18:43:44.388', 76.44, 'reembolsada', 3.82, 72.62);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (13, 87, 76, '2025-02-27 05:12:06.089', 111.80, 'reembolsada', 5.59, 106.21);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (14, 78, 77, '2026-01-06 04:08:13.546', 99.87, 'completada', 4.99, 94.88);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (15, 92, 87, '2025-03-06 10:37:21.02', 144.03, 'completada', 7.20, 136.83);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (16, 81, 69, '2025-03-26 04:05:45.986', 127.89, 'reembolsada', 6.39, 121.50);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (17, 93, 83, '2025-01-31 11:01:08.858', 156.30, 'completada', 7.82, 148.48);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (18, 79, 82, '2025-07-13 03:04:50.797', 161.13, 'pago_retenido', 8.06, 153.07);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (19, 97, 59, '2025-07-28 17:21:51.989', 127.24, 'completada', 6.36, 120.88);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (20, 72, 89, '2025-04-30 10:05:21.995', 150.61, 'completada', 7.53, 143.08);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (21, 91, 71, '2026-01-10 04:24:54.322', 122.57, 'reembolsada', 6.13, 116.44);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (22, 86, 72, '2025-04-01 15:31:40.316', 95.71, 'pago_retenido', 4.79, 90.92);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (23, 66, 97, '2025-07-23 11:27:54.87', 37.91, 'completada', 1.90, 36.01);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (24, 85, 93, '2025-10-04 17:54:59.454', 34.48, 'completada', 1.72, 32.76);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (25, 85, 70, '2025-07-15 13:04:37.123', 38.01, 'reembolsada', 1.90, 36.11);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (26, 76, 89, '2025-12-14 02:34:09.009', 30.21, 'completada', 1.51, 28.70);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (27, 91, 63, '2025-07-24 11:15:01.133', 84.51, 'completada', 4.23, 80.28);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (28, 76, 90, '2026-03-28 09:22:25.402', 50.46, 'pago_retenido', 2.52, 47.94);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (29, 74, 90, '2025-05-18 14:20:33.322', 56.19, 'completada', 2.81, 53.38);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (30, 90, 97, '2025-08-25 17:18:24.321', 74.37, 'completada', 3.72, 70.65);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (31, 61, 82, '2025-04-22 15:30:07.306', 34.72, 'completada', 1.74, 32.98);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (32, 65, 93, '2025-04-21 05:23:15.432', 41.49, 'completada', 2.07, 39.42);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (33, 71, 74, '2025-03-03 10:19:31.574', 37.78, 'completada', 1.89, 35.89);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (34, 83, 72, '2025-01-21 00:42:53.025', 343.80, 'completada', 17.19, 326.61);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (35, 75, 79, '2026-04-01 22:06:11.706', 390.68, 'completada', 19.53, 371.15);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (36, 80, 83, '2025-12-20 18:38:08.85', 259.83, 'completada', 12.99, 246.84);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (37, 71, 72, '2025-06-12 16:38:23.97', 277.93, 'pago_retenido', 13.90, 264.03);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (38, 98, 73, '2026-03-04 06:04:37.728', 489.56, 'completada', 24.48, 465.08);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (39, 70, 86, '2025-11-12 03:23:35.759', 168.98, 'reembolsada', 8.45, 160.53);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (40, 85, 75, '2026-01-21 07:44:48.645', 64.89, 'pago_retenido', 3.24, 61.65);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (41, 98, 86, '2026-03-03 08:46:53.999', 56.20, 'reembolsada', 2.81, 53.39);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (42, 67, 82, '2025-07-18 07:10:21.922', 188.35, 'completada', 9.42, 178.93);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (43, 98, 70, '2025-01-20 15:03:09.541', 90.56, 'completada', 4.53, 86.03);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (44, 85, 89, '2025-09-02 12:29:44.847', 544.50, 'completada', 27.23, 517.27);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (45, 90, 80, '2025-03-23 16:56:29.833', 360.39, 'completada', 18.02, 342.37);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (46, 86, 88, '2026-01-04 17:44:48.951', 429.19, 'completada', 21.46, 407.73);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (47, 68, 78, '2025-09-16 00:51:36.365', 404.87, 'pago_retenido', 20.24, 384.63);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (48, 88, 64, '2025-05-10 00:29:49.928', 104.60, 'completada', 5.23, 99.37);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (49, 97, 75, '2026-02-25 20:02:18.234', 162.58, 'pago_retenido', 8.13, 154.45);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (50, 71, 83, '2025-04-18 14:14:39.422', 85.13, 'completada', 4.26, 80.87);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (51, 70, 93, '2025-05-22 02:26:03.98', 108.25, 'reembolsada', 5.41, 102.84);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (52, 75, 65, '2025-03-07 21:25:11.061', 176.13, 'pago_retenido', 8.81, 167.32);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (53, 59, 69, '2025-10-16 16:31:18.081', 189.61, 'completada', 9.48, 180.13);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (54, 79, 87, '2026-03-29 10:44:03.737', 115.43, 'completada', 5.77, 109.66);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (55, 80, 75, '2025-09-20 16:43:19.734', 99.26, 'completada', 4.96, 94.30);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (56, 63, 89, '2025-11-16 00:52:40.207', 99.53, 'completada', 4.98, 94.55);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (57, 67, 70, '2025-11-01 00:16:37.765', 106.34, 'completada', 5.32, 101.02);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (58, 93, 67, '2025-06-24 05:21:34.215', 128.08, 'reembolsada', 6.40, 121.68);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (59, 84, 90, '2025-06-23 16:13:12.061', 152.05, 'completada', 7.60, 144.45);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (60, 68, 93, '2025-11-13 16:03:33.113', 16.36, 'completada', 0.82, 15.54);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (61, 87, 59, '2025-08-26 02:12:43.129', 19.81, 'completada', 0.99, 18.82);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (62, 69, 88, '2025-08-29 19:27:17.469', 39.63, 'completada', 1.98, 37.65);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (63, 74, 59, '2025-10-18 02:00:25.032', 40.58, 'completada', 2.03, 38.55);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (64, 98, 72, '2026-01-26 17:41:22.22', 35.80, 'completada', 1.79, 34.01);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (65, 82, 76, '2026-03-31 04:02:09.801', 33.41, 'completada', 1.67, 31.74);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (66, 71, 76, '2026-03-09 16:12:56.969', 124.20, 'completada', 6.21, 117.99);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (67, 61, 82, '2025-09-21 21:32:19.059', 20.13, 'completada', 1.01, 19.12);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (68, 64, 66, '2026-01-11 17:14:52.764', 15.50, 'reembolsada', 0.78, 14.72);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (69, 63, 87, '2026-01-23 18:57:16.231', 15.48, 'completada', 0.77, 14.71);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (70, 83, 94, '2025-11-19 07:52:43.486', 10.67, 'completada', 0.53, 10.14);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (71, 78, 91, '2025-01-23 08:27:07.877', 31.97, 'completada', 1.60, 30.37);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (72, 60, 82, '2025-10-06 00:48:13.861', 30.07, 'reembolsada', 1.50, 28.57);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (73, 64, 70, '2025-08-22 06:52:47.429', 27.66, 'completada', 1.38, 26.28);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (74, 77, 68, '2025-02-22 20:56:48.745', 22.02, 'pago_retenido', 1.10, 20.92);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (75, 98, 86, '2025-11-30 21:37:25.98', 23.57, 'pago_retenido', 1.18, 22.39);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (76, 89, 60, '2026-03-10 19:23:46.403', 67.23, 'reembolsada', 3.36, 63.87);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (77, 66, 90, '2026-01-20 21:04:19.428', 42.00, 'completada', 2.10, 39.90);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (78, 89, 98, '2025-11-17 12:50:32.499', 33.07, 'completada', 1.65, 31.42);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (79, 97, 86, '2025-02-18 00:27:11.887', 40.20, 'reembolsada', 2.01, 38.19);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (80, 97, 67, '2025-11-04 22:58:35.709', 24.70, 'pago_retenido', 1.24, 23.46);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (81, 71, 85, '2026-01-30 21:42:30.35', 193.51, 'completada', 9.68, 183.83);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (82, 71, 97, '2025-12-18 06:05:15.248', 150.23, 'pago_retenido', 7.51, 142.72);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (83, 82, 69, '2025-08-08 03:22:30.661', 101.59, 'completada', 5.08, 96.51);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (84, 68, 83, '2025-10-22 16:18:32.311', 120.19, 'pago_retenido', 6.01, 114.18);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (85, 91, 63, '2026-04-01 14:20:30.069', 130.54, 'completada', 6.53, 124.01);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (86, 60, 75, '2026-02-25 00:51:12.632', 15.81, 'completada', 0.79, 15.02);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (87, 65, 61, '2025-05-13 20:05:44.643', 23.84, 'completada', 1.19, 22.65);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (88, 76, 66, '2025-11-01 18:32:04.547', 22.18, 'completada', 1.11, 21.07);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (89, 69, 85, '2025-07-23 23:25:10.211', 17.10, 'completada', 0.86, 16.24);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (90, 67, 98, '2026-04-04 03:35:30.535', 22.65, 'reembolsada', 1.13, 21.52);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (91, 70, 74, '2025-02-19 18:42:48.117', 19.97, 'completada', 1.00, 18.97);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (92, 59, 89, '2025-05-29 02:45:33.151', 18.32, 'pago_retenido', 0.92, 17.40);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (93, 92, 64, '2025-02-23 04:08:17.854', 131.40, 'pago_retenido', 6.57, 124.83);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (94, 60, 66, '2025-06-01 11:35:09.844', 114.24, 'completada', 5.71, 108.53);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (95, 85, 74, '2026-03-31 03:42:47.851', 179.09, 'completada', 8.95, 170.14);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (96, 82, 81, '2025-04-19 20:50:44.92', 160.21, 'completada', 8.01, 152.20);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (97, 81, 78, '2025-06-02 22:13:45.294', 79.76, 'completada', 3.99, 75.77);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (98, 63, 62, '2025-05-29 13:36:47.838', 66.04, 'completada', 3.30, 62.74);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (99, 88, 63, '2025-04-13 10:03:44.161', 104.21, 'pago_retenido', 5.21, 99.00);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (100, 61, 85, '2026-02-23 23:09:18.564', 250.18, 'pago_retenido', 12.51, 237.67);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (101, 91, 73, '2025-11-18 11:53:32.015', 169.65, 'pago_retenido', 8.48, 161.17);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (102, 87, 96, '2026-03-03 02:57:25.154', 188.24, 'pago_retenido', 9.41, 178.83);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (103, 83, 64, '2025-09-02 02:08:16.451', 181.64, 'completada', 9.08, 172.56);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (104, 98, 79, '2025-08-04 22:18:45.467', 184.28, 'reembolsada', 9.21, 175.07);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (105, 97, 78, '2025-02-25 21:37:00.54', 43.88, 'pago_retenido', 2.19, 41.69);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (106, 83, 74, '2025-09-29 11:09:17.043', 40.29, 'completada', 2.01, 38.28);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (107, 67, 80, '2025-06-27 04:21:22.732', 24.25, 'pago_retenido', 1.21, 23.04);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (108, 89, 94, '2025-09-19 08:09:16.526', 570.41, 'completada', 28.52, 541.89);
INSERT INTO public.transaccion OVERRIDING SYSTEM VALUE VALUES (109, 61, 63, '2026-04-21 23:53:11.499026', 735.32, 'pago_retenido', 36.77, 698.55);


--
-- TOC entry 4911 (class 0 OID 25241)
-- Dependencies: 220
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (50, 3, 'Carlos', 'García López', 'admin_carlos', 'admin.carlos@marketplace.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (59, 1, 'Javier', 'López Serrano', 'javi_runner', 'javi.runner@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, '2026-04-20 01:32:13.048416');
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (56, 2, 'David', 'Romero Cruz', 'verif_david', 'verif.david@marketplace.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, '2026-04-18 04:20:19.545082');
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (87, 1, 'Hugo', 'Gallego Parra', 'hugo_ultra', 'hugo.ultra@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (55, 2, 'Sara', 'Jiménez Paz', 'verif_sara', 'verif.sara@marketplace.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (57, 2, 'Elena', 'Navarro Ríos', 'verif_elena', 'verif.elena@marketplace.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (58, 2, 'Pablo', 'Molina Reyes', 'verif_pablo', 'verif.pablo@marketplace.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (60, 1, 'María', 'González Pinto', 'maria_trail', 'maria.trail@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (61, 1, 'Antonio', 'Díaz Fuentes', 'toni_run', 'toni.run@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (63, 1, 'Francisco', 'Moreno Blanco', 'fran_ultra', 'fran.ultra@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (64, 1, 'Isabel', 'Álvarez Cano', 'isa_5k', 'isa.5k@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (65, 1, 'Manuel', 'Romero Peña', 'manu_maraton', 'manu.maraton@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (66, 1, 'Lucía', 'Domínguez Vera', 'lucia_kms', 'lucia.kms@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (67, 1, 'José', 'Gil Castillo', 'jose_10k', 'jose.10k@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (68, 1, 'Rosa', 'Muñoz Lara', 'rosa_trail', 'rosa.trail@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (69, 1, 'Andrés', 'Ortega Moya', 'andres_run', 'andres.run@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (70, 1, 'Patricia', 'Reyes Soto', 'patri_pace', 'patri.pace@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (71, 1, 'Sergio', 'Medina Castro', 'sergio_ultra', 'sergio.ultra@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (72, 1, 'Raquel', 'Delgado Vidal', 'raquel_5k', 'raquel.5k@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (73, 1, 'Roberto', 'Suárez Prieto', 'roberto_km', 'roberto.km@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (74, 1, 'Cristina', 'Flores Bravo', 'cris_runner', 'cris.runner@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (75, 1, 'Fernando', 'Ramos Aguilar', 'fer_maraton', 'fer.maraton@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (76, 1, 'Silvia', 'Vargas Rubio', 'silvia_trail', 'silvia.trail@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (77, 1, 'Álvaro', 'Iglesias Mora', 'alvaro_run', 'alvaro.run@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (78, 1, 'Natalia', 'Cano Vega', 'nati_pace', 'nati.pace@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (79, 1, 'Diego', 'Pascual Nieto', 'diego_ultra', 'diego.ultra@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (80, 1, 'Marta', 'Herrero Sanz', 'marta_10k', 'marta.10k@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (81, 1, 'Alejandro', 'Guerrero Pons', 'alex_runner', 'alex.runner@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (82, 1, 'Beatriz', 'Santos León', 'bea_trail', 'bea.trail@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (83, 1, 'Víctor', 'Pereira Montes', 'victor_km', 'victor.km@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (84, 1, 'Mónica', 'Cabrera Arias', 'moni_run', 'moni.run@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (85, 1, 'Rubén', 'Mendoza Fuente', 'ruben_pace', 'ruben.pace@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (86, 1, 'Nuria', 'Ibáñez Soler', 'nuria_5k', 'nuria.5k@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (88, 1, 'Verónica', 'Marín Cortés', 'vero_trail', 'vero.trail@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (89, 1, 'Iván', 'Ferrer Bernal', 'ivan_maraton', 'ivan.maraton@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (90, 1, 'Alicia', 'Molero Campos', 'ali_runner', 'ali.runner@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (91, 1, 'Óscar', 'Pardo Espejo', 'oscar_km', 'oscar.km@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (92, 1, 'Rocío', 'Bernal Acosta', 'rocio_run', 'rocio.run@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (93, 1, 'Marcos', 'Lozano Dueñas', 'marcos_trail', 'marcos.trail@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (94, 1, 'Susana', 'Núñez Roldán', 'susi_pace', 'susi.pace@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (62, 1, 'Carmen', 'Ruiz Herrera', 'carmen_pace', 'carmen.pace@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, '2026-04-18 04:20:23.178176');
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (54, 2, 'Miguel', 'Torres Vega', 'verif_miguel', 'verif.miguel@marketplace.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, '2026-04-19 02:15:38.339784');
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (53, 4, 'Ana', 'Fernández Gil', 'analista_ana', 'analista.ana@marketplace.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, '2026-04-19 02:16:39.613586');
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (52, 4, 'Pedro', 'Sánchez Mora', 'analista_pedro', 'analista.pedro@marketplace.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, '2026-04-19 02:16:40.426704');
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (95, 1, 'Enrique', 'Vázquez Peña', 'enri_ultra', 'enri.ultra@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (96, 1, 'Pilar', 'Castillo Mora', 'pilar_5k', 'pilar.5k@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (97, 1, 'Tomás', 'Esteban Vera', 'tomas_runner', 'tomas.runner@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (98, 1, 'Gloria', 'Hidalgo Pons', 'gloria_km', 'gloria.km@gmail.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (51, 3, 'Laura', 'Martínez Ruiz', 'admin_laura', 'admin.laura@marketplace.com', '$2b$10$K9EB6BsXrYH6OIAujHiROOpli4PeoqZGLqunF0/kpmR9szEeo1tfm', '2026-04-12 00:44:09.588172', 'activa', false, NULL, NULL, NULL, NULL);
INSERT INTO public.usuario OVERRIDING SYSTEM VALUE VALUES (99, 5, 'Alejandro', 'Carmona Bernabeu', 'Kra', 'alejandro.carmona.bernabeu@students.thepower.education', '$2b$10$21UQKadqtpq4j1DVULFRK.01GdGmpzAVRrjRtRR0GPNfYuzvbmswy', '2026-04-18 02:22:39.910729', 'activa', false, NULL, NULL, NULL, NULL);


--
-- TOC entry 4921 (class 0 OID 25331)
-- Dependencies: 230
-- Data for Name: verificacion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (1, 1, 56, 'rechazada', 'Las imágenes no corresponden al producto recibido.', '2025-09-16 09:01:37.117');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (2, 2, 56, 'aprobada', NULL, '2025-10-12 21:11:35.026');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (3, 3, 55, 'rechazada', 'El estado real del producto es peor al indicado por el vendedor.', '2026-02-20 21:03:21.24');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (4, 4, 54, 'aprobada', NULL, '2025-01-28 06:06:05.874');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (5, 7, 58, 'rechazada', 'El producto muestra signos de desgaste superiores a los descritos.', '2026-02-20 18:55:13.421');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (6, 8, 56, 'aprobada', NULL, '2025-11-16 00:28:51.803');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (7, 9, 58, 'aprobada', NULL, '2025-11-04 19:30:57.652');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (8, 10, 56, 'aprobada', NULL, '2025-08-07 00:37:55.859');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (9, 11, 56, 'aprobada', NULL, '2025-06-12 09:16:39.254');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (10, 12, 54, 'rechazada', 'Las imágenes no corresponden al producto recibido.', '2025-04-16 22:28:50.924');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (11, 13, 55, 'rechazada', 'El estado real del producto es peor al indicado por el vendedor.', '2025-04-08 04:50:20.471');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (12, 14, 54, 'aprobada', NULL, '2026-01-26 14:36:16.578');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (13, 15, 54, 'aprobada', NULL, '2025-02-05 22:23:32.631');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (14, 16, 55, 'rechazada', 'El producto presenta daños no mencionados en el anuncio.', '2025-05-20 05:23:36.805');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (15, 17, 57, 'aprobada', NULL, '2025-02-05 01:07:04.24');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (16, 19, 55, 'aprobada', NULL, '2025-08-27 10:34:23.268');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (17, 20, 57, 'aprobada', NULL, '2025-01-16 05:18:03.504');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (18, 21, 55, 'rechazada', 'El estado real del producto es peor al indicado por el vendedor.', '2026-03-27 04:36:27.922');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (19, 23, 55, 'aprobada', NULL, '2025-04-27 00:09:52.397');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (20, 24, 55, 'aprobada', NULL, '2025-06-13 20:48:52.261');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (21, 25, 57, 'rechazada', 'El producto no coincide con la descripción del anuncio.', '2025-07-19 04:25:26.354');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (22, 26, 58, 'aprobada', NULL, '2025-03-15 05:38:26.892');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (23, 27, 57, 'aprobada', NULL, '2025-06-21 14:32:22.981');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (24, 29, 57, 'aprobada', NULL, '2025-04-28 01:43:08.73');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (25, 30, 58, 'aprobada', NULL, '2026-03-04 12:11:38.526');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (26, 31, 54, 'aprobada', NULL, '2025-12-19 10:30:30.458');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (27, 32, 54, 'aprobada', NULL, '2025-06-26 16:51:39.782');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (28, 33, 54, 'aprobada', NULL, '2025-03-11 04:56:40.652');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (29, 34, 54, 'aprobada', NULL, '2025-07-09 12:05:23.66');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (30, 35, 54, 'aprobada', NULL, '2025-05-23 23:54:44.008');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (31, 36, 56, 'aprobada', NULL, '2025-03-23 04:20:39.378');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (32, 38, 58, 'aprobada', NULL, '2025-09-08 14:51:52.569');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (33, 39, 58, 'rechazada', 'El estado real del producto es peor al indicado por el vendedor.', '2025-03-18 22:21:05.412');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (34, 41, 54, 'rechazada', 'El producto muestra signos de desgaste superiores a los descritos.', '2025-04-27 22:56:26.732');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (35, 42, 58, 'aprobada', NULL, '2025-07-03 02:55:20.839');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (36, 43, 57, 'aprobada', NULL, '2025-04-29 18:57:03.19');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (37, 44, 57, 'aprobada', NULL, '2025-08-02 12:10:48.24');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (38, 45, 55, 'aprobada', NULL, '2026-01-30 15:26:31.166');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (39, 46, 57, 'aprobada', NULL, '2025-02-08 22:54:33.907');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (40, 48, 58, 'aprobada', NULL, '2026-03-16 01:16:39.57');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (41, 50, 54, 'aprobada', NULL, '2026-03-04 19:16:34.905');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (42, 51, 56, 'rechazada', 'El producto no coincide con la descripción del anuncio.', '2025-05-15 14:55:52.66');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (43, 53, 55, 'aprobada', NULL, '2026-02-05 13:57:57.521');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (44, 54, 54, 'aprobada', NULL, '2025-06-07 18:53:50.918');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (45, 55, 57, 'aprobada', NULL, '2025-03-20 00:15:25.898');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (46, 56, 58, 'aprobada', NULL, '2025-11-11 22:00:58.056');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (47, 57, 54, 'aprobada', NULL, '2025-08-12 18:07:40.454');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (48, 58, 56, 'rechazada', 'El producto muestra signos de desgaste superiores a los descritos.', '2025-11-19 08:25:25.187');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (49, 59, 56, 'aprobada', NULL, '2025-09-21 22:30:31.293');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (50, 60, 58, 'aprobada', NULL, '2025-10-23 05:21:29.418');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (51, 61, 56, 'aprobada', NULL, '2025-03-17 07:41:50.353');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (52, 62, 55, 'aprobada', NULL, '2025-01-25 00:25:02.361');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (53, 63, 56, 'aprobada', NULL, '2025-10-14 06:54:52.849');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (54, 64, 54, 'aprobada', NULL, '2025-09-13 01:17:49.683');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (55, 65, 57, 'aprobada', NULL, '2026-04-10 19:09:07.31');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (56, 66, 57, 'aprobada', NULL, '2025-09-28 06:29:42.117');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (57, 67, 56, 'aprobada', NULL, '2025-11-15 22:46:17.354');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (58, 68, 54, 'rechazada', 'El producto no coincide con la descripción del anuncio.', '2025-03-07 17:24:40.695');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (59, 69, 57, 'aprobada', NULL, '2025-05-26 21:25:38.047');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (60, 70, 55, 'aprobada', NULL, '2025-08-14 02:40:33.169');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (61, 71, 58, 'aprobada', NULL, '2025-07-09 05:08:13.411');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (62, 72, 57, 'rechazada', 'El producto muestra signos de desgaste superiores a los descritos.', '2026-02-03 05:00:09.578');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (63, 73, 54, 'aprobada', NULL, '2026-01-17 05:48:30.386');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (64, 76, 57, 'rechazada', 'El estado real del producto es peor al indicado por el vendedor.', '2026-02-17 18:03:45.744');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (65, 77, 58, 'aprobada', NULL, '2026-01-20 17:47:12.695');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (66, 78, 56, 'aprobada', NULL, '2025-06-25 00:55:25.277');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (67, 79, 58, 'rechazada', 'El producto muestra signos de desgaste superiores a los descritos.', '2025-02-09 15:04:46.55');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (68, 81, 56, 'aprobada', NULL, '2025-04-22 03:57:45.92');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (69, 83, 54, 'aprobada', NULL, '2025-10-01 22:30:38.787');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (70, 85, 58, 'aprobada', NULL, '2025-10-12 20:43:28.043');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (71, 86, 54, 'aprobada', NULL, '2025-06-05 14:21:07.955');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (72, 87, 54, 'aprobada', NULL, '2025-10-03 03:11:32.753');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (73, 88, 57, 'aprobada', NULL, '2025-10-09 07:08:23.766');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (74, 89, 57, 'aprobada', NULL, '2026-02-17 00:43:08.236');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (75, 90, 54, 'rechazada', 'El estado real del producto es peor al indicado por el vendedor.', '2025-06-28 20:58:34.412');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (76, 91, 56, 'aprobada', NULL, '2025-04-19 04:59:19.9');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (77, 94, 58, 'aprobada', NULL, '2025-02-06 14:05:29.486');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (78, 95, 56, 'aprobada', NULL, '2025-12-17 15:20:57.136');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (79, 96, 56, 'aprobada', NULL, '2026-04-06 03:37:57.111');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (80, 97, 56, 'aprobada', NULL, '2025-11-27 22:46:41.575');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (81, 98, 54, 'aprobada', NULL, '2025-06-17 16:51:38.19');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (82, 103, 55, 'aprobada', NULL, '2025-06-26 15:59:37.43');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (83, 104, 54, 'rechazada', 'El producto presenta daños no mencionados en el anuncio.', '2025-11-18 11:59:17.014');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (84, 106, 54, 'aprobada', NULL, '2025-11-12 23:47:27.884');
INSERT INTO public.verificacion OVERRIDING SYSTEM VALUE VALUES (85, 108, 56, 'aprobada', NULL, '2025-12-27 02:17:11.638');


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 217
-- Name: categoria_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categoria_id_categoria_seq', 20, true);


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 227
-- Name: detalle_transaccion_id_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_transaccion_id_detalle_seq', 109, true);


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 223
-- Name: imagen_producto_id_imagen_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.imagen_producto_id_imagen_seq', 1071, true);


--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 235
-- Name: log_auditoria_id_log_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.log_auditoria_id_log_seq', 144, true);


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 221
-- Name: producto_id_prod_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.producto_id_prod_seq', 533, true);


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 231
-- Name: resenya_producto_id_resenya_prod_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.resenya_producto_id_resenya_prod_seq', 49, true);


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 233
-- Name: resenya_usuario_id_resenya_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.resenya_usuario_id_resenya_usuario_seq', 41, true);


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 215
-- Name: rol_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rol_id_rol_seq', 5, true);


--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 225
-- Name: transaccion_id_transaccion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transaccion_id_transaccion_seq', 109, true);


--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 219
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 99, true);


--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 229
-- Name: verificacion_id_verificacion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.verificacion_id_verificacion_seq', 85, true);


--
-- TOC entry 4710 (class 2606 OID 25238)
-- Name: categoria categoria_nombre_categoria_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_nombre_categoria_key UNIQUE (nombre_categoria);


--
-- TOC entry 4712 (class 2606 OID 25236)
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id_categoria);


--
-- TOC entry 4728 (class 2606 OID 25319)
-- Name: detalle_transaccion detalle_transaccion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_transaccion
    ADD CONSTRAINT detalle_transaccion_pkey PRIMARY KEY (id_detalle);


--
-- TOC entry 4724 (class 2606 OID 25289)
-- Name: imagen_producto imagen_producto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.imagen_producto
    ADD CONSTRAINT imagen_producto_pkey PRIMARY KEY (id_imagen);


--
-- TOC entry 4743 (class 2606 OID 33605)
-- Name: log_auditoria log_auditoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_auditoria
    ADD CONSTRAINT log_auditoria_pkey PRIMARY KEY (id_log);


--
-- TOC entry 4722 (class 2606 OID 25271)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id_prod);


--
-- TOC entry 4734 (class 2606 OID 25361)
-- Name: resenya_producto resenya_producto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resenya_producto
    ADD CONSTRAINT resenya_producto_pkey PRIMARY KEY (id_resenya_prod);


--
-- TOC entry 4736 (class 2606 OID 25396)
-- Name: resenya_producto resenya_producto_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resenya_producto
    ADD CONSTRAINT resenya_producto_unique UNIQUE (id_usuario_autor, id_prod);


--
-- TOC entry 4738 (class 2606 OID 25381)
-- Name: resenya_usuario resenya_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resenya_usuario
    ADD CONSTRAINT resenya_usuario_pkey PRIMARY KEY (id_resenya_usuario);


--
-- TOC entry 4740 (class 2606 OID 25398)
-- Name: resenya_usuario resenya_usuario_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resenya_usuario
    ADD CONSTRAINT resenya_usuario_unique UNIQUE (id_usuario_autor, id_usuario_resenyado);


--
-- TOC entry 4706 (class 2606 OID 25230)
-- Name: rol rol_nombre_rol_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_nombre_rol_key UNIQUE (nombre_rol);


--
-- TOC entry 4708 (class 2606 OID 25228)
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id_rol);


--
-- TOC entry 4726 (class 2606 OID 25302)
-- Name: transaccion transaccion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT transaccion_pkey PRIMARY KEY (id_transaccion);


--
-- TOC entry 4715 (class 2606 OID 25253)
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- TOC entry 4717 (class 2606 OID 25251)
-- Name: usuario usuario_nickname_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_nickname_key UNIQUE (nickname);


--
-- TOC entry 4719 (class 2606 OID 25249)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 4730 (class 2606 OID 25341)
-- Name: verificacion verificacion_id_transaccion_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verificacion
    ADD CONSTRAINT verificacion_id_transaccion_key UNIQUE (id_transaccion);


--
-- TOC entry 4732 (class 2606 OID 25339)
-- Name: verificacion verificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verificacion
    ADD CONSTRAINT verificacion_pkey PRIMARY KEY (id_verificacion);


--
-- TOC entry 4741 (class 1259 OID 33621)
-- Name: idx_log_auditoria_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_log_auditoria_fecha ON public.log_auditoria USING btree (fecha_accion DESC);


--
-- TOC entry 4720 (class 1259 OID 33623)
-- Name: idx_producto_borrado_logico; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_producto_borrado_logico ON public.producto USING btree (borrado_logico, fecha_baja_programada);


--
-- TOC entry 4713 (class 1259 OID 33622)
-- Name: idx_usuario_borrado_logico; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usuario_borrado_logico ON public.usuario USING btree (borrado_logico, fecha_baja_programada);


--
-- TOC entry 4704 (class 1259 OID 25392)
-- Name: rol_nombre_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX rol_nombre_idx ON public.rol USING btree (lower((nombre_rol)::text));


--
-- TOC entry 4752 (class 2606 OID 25325)
-- Name: detalle_transaccion detalle_transaccion_id_prod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_transaccion
    ADD CONSTRAINT detalle_transaccion_id_prod_fkey FOREIGN KEY (id_prod) REFERENCES public.producto(id_prod);


--
-- TOC entry 4753 (class 2606 OID 25320)
-- Name: detalle_transaccion detalle_transaccion_id_transaccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_transaccion
    ADD CONSTRAINT detalle_transaccion_id_transaccion_fkey FOREIGN KEY (id_transaccion) REFERENCES public.transaccion(id_transaccion);


--
-- TOC entry 4746 (class 2606 OID 33591)
-- Name: producto fk_producto_eliminado_por; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT fk_producto_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES public.usuario(id_usuario) ON DELETE SET NULL;


--
-- TOC entry 4744 (class 2606 OID 33585)
-- Name: usuario fk_usuario_eliminado_por; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuario_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES public.usuario(id_usuario) ON DELETE SET NULL;


--
-- TOC entry 4749 (class 2606 OID 25290)
-- Name: imagen_producto imagen_producto_id_prod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.imagen_producto
    ADD CONSTRAINT imagen_producto_id_prod_fkey FOREIGN KEY (id_prod) REFERENCES public.producto(id_prod);


--
-- TOC entry 4760 (class 2606 OID 33606)
-- Name: log_auditoria log_auditoria_id_actor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_auditoria
    ADD CONSTRAINT log_auditoria_id_actor_fkey FOREIGN KEY (id_actor) REFERENCES public.usuario(id_usuario) ON DELETE SET NULL;


--
-- TOC entry 4761 (class 2606 OID 33616)
-- Name: log_auditoria log_auditoria_id_objetivo_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_auditoria
    ADD CONSTRAINT log_auditoria_id_objetivo_producto_fkey FOREIGN KEY (id_objetivo_producto) REFERENCES public.producto(id_prod) ON DELETE SET NULL;


--
-- TOC entry 4762 (class 2606 OID 33611)
-- Name: log_auditoria log_auditoria_id_objetivo_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_auditoria
    ADD CONSTRAINT log_auditoria_id_objetivo_usuario_fkey FOREIGN KEY (id_objetivo_usuario) REFERENCES public.usuario(id_usuario) ON DELETE SET NULL;


--
-- TOC entry 4747 (class 2606 OID 25277)
-- Name: producto producto_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categoria(id_categoria);


--
-- TOC entry 4748 (class 2606 OID 25272)
-- Name: producto producto_id_vendedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_id_vendedor_fkey FOREIGN KEY (id_vendedor) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 4756 (class 2606 OID 25367)
-- Name: resenya_producto resenya_producto_id_prod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resenya_producto
    ADD CONSTRAINT resenya_producto_id_prod_fkey FOREIGN KEY (id_prod) REFERENCES public.producto(id_prod);


--
-- TOC entry 4757 (class 2606 OID 25362)
-- Name: resenya_producto resenya_producto_id_usuario_autor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resenya_producto
    ADD CONSTRAINT resenya_producto_id_usuario_autor_fkey FOREIGN KEY (id_usuario_autor) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 4758 (class 2606 OID 25382)
-- Name: resenya_usuario resenya_usuario_id_usuario_autor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resenya_usuario
    ADD CONSTRAINT resenya_usuario_id_usuario_autor_fkey FOREIGN KEY (id_usuario_autor) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 4759 (class 2606 OID 25387)
-- Name: resenya_usuario resenya_usuario_id_usuario_resenyado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resenya_usuario
    ADD CONSTRAINT resenya_usuario_id_usuario_resenyado_fkey FOREIGN KEY (id_usuario_resenyado) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 4750 (class 2606 OID 25303)
-- Name: transaccion transaccion_id_comprador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT transaccion_id_comprador_fkey FOREIGN KEY (id_comprador) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 4751 (class 2606 OID 25308)
-- Name: transaccion transaccion_id_vendedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT transaccion_id_vendedor_fkey FOREIGN KEY (id_vendedor) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 4745 (class 2606 OID 25254)
-- Name: usuario usuario_id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.rol(id_rol);


--
-- TOC entry 4754 (class 2606 OID 25347)
-- Name: verificacion verificacion_id_revisor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verificacion
    ADD CONSTRAINT verificacion_id_revisor_fkey FOREIGN KEY (id_revisor) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 4755 (class 2606 OID 25342)
-- Name: verificacion verificacion_id_transaccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verificacion
    ADD CONSTRAINT verificacion_id_transaccion_fkey FOREIGN KEY (id_transaccion) REFERENCES public.transaccion(id_transaccion);


-- Completed on 2026-05-03 04:09:37

--
-- PostgreSQL database dump complete
--

