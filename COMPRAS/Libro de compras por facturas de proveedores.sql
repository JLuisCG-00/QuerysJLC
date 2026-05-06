-- LIBRO DE RETENCIONES POR FACTURAS DE PROVEEDORESV2
SELECT
    (SELECT CompnyName FROM OADM) AS [Empresa],
    (SELECT UPPER(CompnyAddr) FROM OADM) AS [Direccion_Empresa],
    (SELECT TaxIdNum FROM OADM) AS [RTN_Empresa],
    (SELECT E_Mail FROM OADM) AS [E_Mail_Empresa],
    (SELECT Phone1 FROM OADM) AS [Telefono_Empresa],
    (SELECT PrintHeadr FROM OADM) AS [Nombre_Empresa],
    CASE 
        WHEN T0."ObjType" = '18' THEN 'Factura Proveedor'
        WHEN T0."ObjType" = '19' THEN 'Nota de Crédito Proveedor'
        ELSE 'Otro'
    END AS "Clase de documento",
    T0."LicTradNum" AS "RTN_Proveedor",
    T0."CardName" AS "Nombre_Proveedor",
    T0."U_CAI_Proveedor" AS "CAI PROVEEDOR",
    T0."NumAtCard" AS "Factura Proveedor",
    T0."U_NFD" AS "#Documento",
    T0."U_CAI" AS "CAI Retencion",
    T0."DocDate" AS "Fecha Retencion",
    T2."WTName" AS "Descripcion de Retencion",
    T0."DocTotal" AS "Monto Base de Retencion",
    T1."WTAmnt" AS "Monto de Retencion",
    T2."Rate" AS "Tasa de Retencion"
FROM OPCH T0
INNER JOIN PCH5 T1 ON T0."DocEntry" = T1."AbsEntry"
INNER JOIN OWHT T2 ON T1."WTCode" = T2."WTCode"
WHERE
    T0."DocDate" >= {?1.Fecha_Ini}
    AND T0."DocDate" <= {?2.Fehca_Fin}
    AND T1."WTAmnt" > 0