SELECT 'FACTURA' as "FA",
T0."DocEntry",

T0."CardCode" AS "Codigo Cliente",
T0."CardName" as "Nombre Apellido o Razon",
T1."PymntGroup" AS "Condicion de Pago",

(SELECT TOP 1 A."FormatCode"
 FROM JDT1 J
 INNER JOIN OACT A ON J."Account" = A."AcctCode"
 WHERE J."TransId" = T0."TransId"
 AND J."Credit" > 0) AS "Cuenta Contable",

(SELECT TOP 1 A."AcctName"
 FROM JDT1 J
 INNER JOIN OACT A ON J."Account" = A."AcctCode"
 WHERE J."TransId" = T0."TransId"
 AND J."Credit" > 0) AS "Nombre Cuenta",

ISNULL((
    SELECT SUM(A."LineTotal")
    FROM INV1 A
    WHERE A."DocEntry" = T0."DocEntry"
    AND A."TaxCode" = 'EXO'
),0) AS "SubT.Exportacion",

(SELECT A."PrintHeadr" FROM "OADM" A) AS "PrintHeadr",
(SELECT A."TaxIdNum" FROM "OADM" A) AS "R.T.N. Empresa",
(SELECT A."E_Mail" FROM "OADM" A) AS "Email",
(SELECT A."CompnyAddr" FROM "OADM" A) AS "Direccion Empresa",
(SELECT A."LogoFile" FROM "OADP" A) AS "Logo Empresa",
(SELECT A."BitmapPath" FROM "OADP" A) AS "PathLogo",
(SELECT A."Phone1" FROM "OADM" A) AS "Telefono Empresa",

T0."DocNum" as "No. Interno",
T0."Series",
T0."TaxDate" as "Fecha",
T0."NumAtCard" as "Num Doc Fiscal", 

(select A."Remark" from NNM1 A where A."Series"=T0."Series") AS "Sucursal",

0 AS "DocBase",		
T0."NumAtCard" AS "FiscalBase",

(SELECT COALESCE(CAST(T99."BitmapPath" AS NVARCHAR(MAX)), '') + 
        COALESCE(CAST(T99."LogoFile" AS NVARCHAR(MAX)), '') 
 FROM OADP T99) AS "Imagen",

T0."ObjType",

ISNULL((select sum(A."LineTotal") from INV1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='EXO'),0) as "MontoExonerado",
ISNULL((select sum(A."LineTotal") from INV1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='EXE'),0) as "MontoExento",
ISNULL((select sum(A."LineTotal") from INV1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='ISV'),0) as "MontoGravado",
ISNULL((select sum(A."LineTotal") from INV1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='ISV'),0) as "MontoBase",

ISNULL((select sum(A."LineTotal") from INV1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='ISV18'),0) as "MontoGravado18%",

ISNULL((select sum(A."VatSum") from INV1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='ISV'),0) as "Impuesto15",
ISNULL((select sum(A."VatSum") from INV1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='ISV18'),0) as "Impuesto18",

T0."U_SUB" as "Base",
T0."LicTradNum" AS "R.T.N CLIENTE",
T0."DocTotal" as "ValorTotal",
T0."U_NFD" "#Factura",
T0."DiscSum" as "Descuento"

FROM OINV T0  
LEFT JOIN OCTG T1 ON T0."GroupNum" = T1."GroupNum"

WHERE T0."DocDate" BETWEEN {?1FechaInicial} AND {?2FechaFinal}
AND T0."DocSubType"='--' 

UNION ALL

--------------------------------- NOTAS DE CREDITO

SELECT 'NOTA CREDITO' as "NC",
T0."DocEntry",

T0."CardCode" AS "Codigo Cliente",
T0."CardName" as "Nombre Apellido o Razon",
T1."PymntGroup" AS "Condicion de Pago",

(SELECT TOP 1 A."FormatCode"
 FROM JDT1 J
 INNER JOIN OACT A ON J."Account" = A."AcctCode"
 WHERE J."TransId" = T0."TransId"
 AND J."Debit" > 0) AS "Cuenta Contable",

(SELECT TOP 1 A."AcctName"
 FROM JDT1 J
 INNER JOIN OACT A ON J."Account" = A."AcctCode"
 WHERE J."TransId" = T0."TransId"
 AND J."Debit" > 0) AS "Nombre Cuenta",

ISNULL((
    SELECT SUM(A."LineTotal")
    FROM RIN1 A
    WHERE A."DocEntry" = T0."DocEntry"
    AND A."TaxCode" = 'EXO'
),0) * -1 AS "SubT.Exportacion",

(SELECT A."PrintHeadr" FROM "OADM" A) AS "PrintHeadr",
(SELECT A."TaxIdNum" FROM "OADM" A) AS "R.T.N. Empresa",
(SELECT A."E_Mail" FROM "OADM" A) AS "Email",
(SELECT A."CompnyAddr" FROM "OADM" A) AS "Direccion Empresa",
(SELECT A."LogoFile" FROM "OADP" A) AS "Logo Empresa",
(SELECT A."BitmapPath" FROM "OADP" A) AS "PathLogo",
(SELECT A."Phone1" FROM "OADM" A) AS "Telefono Empresa",

T0."DocNum" as "No. Interno",
T0."Series",
T0."TaxDate" as "Fecha",
T0."NumAtCard" as "Num Doc Fiscal", 

(select A."Remark" from NNM1 A where A."Series"=T0."Series") AS "Sucursal",

(SELECT AB."DocEntry" 
 FROM OINV AB 
 WHERE AB."DocEntry" = 
    (SELECT TAA."RefDocEntr" FROM RIN21 TAA WHERE TAA."DocEntry"=T0."DocEntry")
) AS "DocBase",

T0."NumAtCard" AS "FiscalBase",

(SELECT COALESCE(CAST(T99."BitmapPath" AS NVARCHAR(MAX)), '') + 
        COALESCE(CAST(T99."LogoFile" AS NVARCHAR(MAX)), '') 
 FROM OADP T99) AS "Imagen",

T0."ObjType",

ISNULL((select sum(A."LineTotal") from RIN1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='EXO'),0)*-1 as "MontoExonerado",
ISNULL((select sum(A."LineTotal") from RIN1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='EXE'),0)*-1 as "MontoExento",
ISNULL((select sum(A."LineTotal") from RIN1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='ISV'),0)*-1 as "MontoGravado",
ISNULL((select sum(A."LineTotal") from RIN1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='ISV'),0) as "MontoBase",

ISNULL((select sum(A."LineTotal") from RIN1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='ISV18'),0)*-1 as "MontoGravado18%",

ISNULL((select sum(A."VatSum") from RIN1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='ISV'),0)*-1 as "Impuesto15",
ISNULL((select sum(A."VatSum") from RIN1 A where A."DocEntry"=T0."DocEntry" and A."TaxCode"='ISV18'),0)*-1 as "Impuesto18",

T0."U_SUB" as "Base",
T0."LicTradNum" AS "R.T.N CLIENTE",
T0."DocTotal"*-1 as "ValorTotal",
T0."U_NFD" "#Factura",
T0."DiscSum" as "Descuento"

FROM ORIN T0  
LEFT JOIN OCTG T1 ON T0."GroupNum" = T1."GroupNum"

WHERE T0."DocDate" BETWEEN {?1FechaInicial} AND {?2FechaFinal}

ORDER BY 1, "Series";