-- QUERY COMPROBANTE DE RETENCION EN FACTURA DE PROVEEDORES
SELECT 
    -- Informacion de cabecera
    T0.CardCode AS "Codigo de Proveedor",
    T0.CardName AS "Nombre de Proveedor", 
    T0.DocDate AS "Fecha", 
    T0.NumAtCard AS "Numero de Factura",
    T0.LicTradNum AS "RTN Cliente",
    T0.U_CAI_Proveedor AS "CAI Fact Proveedor",
    T0.Address AS "Direccion de Proveedor",
    T0.DocCur AS "Moneda de Factura",

    -- Informacion de retencion
    T1.WTCode AS "Codigo de Retencion",
    T1.WTAmnt AS "Monto de Retencion",
    T2.WTName AS "Descripcion de Retencion",
    T2.Rate AS "Tasa de Retencion",
    T0.DocTotal AS "Monto Base de Retencion",

    -- Informacion Fiscal de Retencion
    T0.U_NFD AS "#Fiscal de retencion",
    T0.U_FLE AS "Fecha Limite de Emision",
    T0.U_INI AS "Correlativo Inicial",
    T0.U_FIN AS "Correlativo Final",
    T0.U_CAI AS "CAI Retencion"

FROM OPCH T0
    INNER JOIN PCH5 T1 ON T0.DocEntry = T1.AbsEntry
    INNER JOIN OWHT T2 ON T1.WTCode = T2.WTCode
WHERE T0.[DocEntry] = {?DocKey@}