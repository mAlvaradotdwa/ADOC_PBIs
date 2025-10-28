WITH ZIMPs AS (
    -- recosntrucción de mk para pre-packs
    SELECT
        pn.EBELN ZIMP ,
        pn.EBELP ZIMP_POS ,
        COALESCE ( NULLIF ( pn.KONNR , '' ) , p0.KONNR  ) MK ,
        COALESCE ( NULLIF ( pn.KTPNR , '00000'  ) , p0.KTPNR  ) MK_POS ,
        pn.MATNR 
    FROM SAP_ECC.EKPO pn
    LEFT JOIN SAP_ECC.EKPO p0
        ON p0.EBELN = pn.EBELN 
        AND p0.EBELP = pn.UEBPO 
    WHERE pn.LOEKZ <> 'L'
         -- AND pn.EBELN = 4500038208 
),
DatosMK AS (
    SELECT 
        z.* , 
        l.CHARG LOTE ,
        e.ZCENTRODES ,
        E.AEDAT AEDAT_MK ,
        e.ZFACTORY ZFACTORY_MK,
        e.ZINSTOREDATE ZINSTOREDATE_MK 
    FROM ZIMPs z
    LEFT JOIN SAP_ECC.EKET l
        ON z.ZIMP  = l.EBELN 
        AND z.ZIMP_POS = l.EBELP 
    LEFT JOIN SAP_ECC.EKPO e 
        ON z.MK = e.EBELN 
        AND z.MK_POS = e.EBELP 
    WHERE e.AEDAT >= 20240101
),
lotes AS (
    SELECT
        ek.CHARG ,
        EKPO.EBELN,
        EKPO.EBELP,
        EKPO.MATNR ,
        EKKO.FRGKE AS Indicador_de_Liberacion,
        EKKO.FRGGR AS Grupo_de_Liberacion,
        EKKO.FRGSX AS Estrategia_Liberacion,
        EKKO.BSART AS Tipo_Documento,  
        EKPO.EBELN AS Documento,
        EKPO.MATNR AS Articulo,
        EKPO.TXZ01 AS Descripcion, 
        EKPO.MENGE AS Cantidad,
        EKPO.LGORT AS Almacen,
        CASE 
            WHEN LEFT(EKPO.TXZ01, 7) = 'Prepack' 
            THEN CAST(SUBSTRING_REGEXPR('(\d+)' IN EKPO.TXZ01 GROUP 1) AS INTEGER) 
            ELSE 1 
        END * EKPO.MENGE AS Cantidad_Pares,
        EKPO.SAISO AS PE,
        EKPO.SAISO AS Ano_PE,
        EKPO.AEDAT AS Fecha_Creacion,
        EKPO.CREATIONDATE AS Fecha_Creacion2,
        EKPO.ZFACTORY AS XFactory_Actualizado, 
        EKPO.ZFACTORYO AS XFactory_Original,
        EKPO.WERKS AS Entidad_CD,
        EKPO.BUKRS AS Entidad_Solicitante,
        EKPO.ZCENTRODES AS Centro_Destino_Final,
        EKPO.ZINSTOREDATE AS Fecha_Tienda,
        EKKO.ZZF_DESPACHO AS XFactory_Requerida,
        EKKO.AEDAT AS Fecha_EKKO,
        EKKO.LIFNR AS Numero_Proveedor, 
        EKKO.INCO1 AS Incoterm,
        EKKO.INCO2 AS Puerto_Origen,
        EKKO.ZZF_DESPACHO AS Fecha_Despacho_Final,
        EKKO.ZZF_DESPINI AS Fecha_Despacho_Inicial,
        EKKO.ZZ_TIPO_FLETE AS Tipo_de_Flete,
        EKKO.ZZ_ZPORT AS Puerto_Origen2,
        EKKO.BUKRS AS Entidad_Compra,
        EKKO.EKORG AS Entidad_Solicitante2,
        EKKO.ZZ_CENTRO_D AS Entidad_CD2
    FROM SAP_ECC.EKET ek
    INNER JOIN SAP_ECC.EKPO EKPO
        ON ek.EBELN = EKPO.EBELN 
        AND ek.EBELP = EKPO.EBELP 
    INNER JOIN SAP_ECC.ekko EKKO
        ON EKPO.EBELN = EKKO.EBELN 
    WHERE EKPO.LOEKZ <> 'L'
),
final_cte AS (
    SELECT 
        m.*,
        Indicador_de_Liberacion,
        Grupo_de_Liberacion,
        Estrategia_Liberacion,
        Tipo_Documento,  
        Documento,
        Articulo,
        Descripcion, 
        Cantidad,
        Almacen,
        Cantidad_Pares,
        PE,
        Ano_PE,
        Fecha_Creacion,
        Fecha_Creacion2,
        XFactory_Actualizado, 
        XFactory_Original,
        Entidad_CD,
        Entidad_Solicitante,
        Centro_Destino_Final,
        Fecha_Tienda,
        XFactory_Requerida,
        Fecha_EKKO,
        Numero_Proveedor, 
        Incoterm,
        Puerto_Origen,
        Fecha_Despacho_Final,
        Fecha_Despacho_Inicial,
        Tipo_de_Flete,
        Puerto_Origen2,
        Entidad_Compra,
        Entidad_Solicitante2,
        Entidad_CD2
    FROM DatosMK m
    INNER JOIN lotes l
        ON m.LOTE = l.CHARG 
        AND m.ZIMP_POS  = l.EBELP 
        AND m.MATNR = l.MATNR 
)
SELECT *
FROM final_cte
/**/
